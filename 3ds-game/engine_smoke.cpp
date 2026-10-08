// SPDX-License-Identifier: GPL-2.0-or-later
#include <SDL_main.h>
#include <3ds.h>
#include <cstdio>
#include <filesystem>
#include <stdexcept>
#include <vector>
#include "serialize.h"
#include "zzlib.h"
#include "platform_3ds.h"
#include "localevent.h"
#include "interface_base.h"
#include <SDL.h>
#include "image.h"

int main(int, char**) {
    std::error_code error;
    std::filesystem::create_directories("sdmc:/3ds/fheroes2-engine-test", error);
    FILE* log = std::fopen("sdmc:/3ds/fheroes2-engine-test/results.log", "w");
    if (!log) return 1;
    bool newModel = false;
    APT_CheckNew3DS(&newModel);
    std::fprintf(log, "MODEL new=%d\n", newModel);
    bool passed = false;
    try {
        RWStreamBuf stream;
        stream.putBE16(0x1234);
        stream.putLE16(0x5678);
        stream.putBE32(0x89abcdef);
        stream.putLE32(0x10203040);
        const auto bytes = stream.getRaw(0);
        const std::vector<uint8_t> expected{0x12,0x34,0x78,0x56,0x89,0xab,0xcd,0xef,0x40,0x30,0x20,0x10};
        if (stream.fail() || bytes != expected) throw std::runtime_error("Serialized byte order differs");
        ROStreamBuf reader(bytes);
        if (reader.fail() || reader.getBE16() != 0x1234 || reader.getLE16() != 0x5678
            || reader.getBE32() != 0x89abcdef || reader.getLE32() != 0x10203040 || reader.fail()) {
            throw std::runtime_error("Serialized values do not roundtrip");
        }
        std::fprintf(log, "Engine endian serialization: PASS\n");
        std::vector<uint8_t> payload(4096);
        for (size_t i=0; i<payload.size(); ++i) payload[i] = static_cast<uint8_t>(i*7);
        const auto zipped = Compression::zipData(payload.data(), payload.size(), false);
        const auto unzipped = Compression::unzipData(zipped.data(), zipped.size(), payload.size());
        if (zipped.empty() || unzipped != payload) throw std::runtime_error("Compression roundtrip differs");
        std::fprintf(log, "Engine zlib compression: PASS\n");
        Platform3DS::setVirtualFrameSize({640,480});
        Platform3DS::resetViewportFollow();
        uint32_t cameraTime = 0;
        Platform3DS::followCursor({639,479}, cameraTime);
        if (Platform3DS::viewport() != fheroes2::Point{320,240}
            || Platform3DS::touchPosition(1.0f,1.0f) != fheroes2::Point{639,479}) throw std::runtime_error("Viewport edge differs");
        Platform3DS::setTouchHeld(true);
        Platform3DS::followCursor({0,0}, cameraTime += 16);
        if (Platform3DS::viewport() != fheroes2::Point{320,240}) throw std::runtime_error("Held touch changed viewport");
        Platform3DS::setTouchHeld(false);
        Platform3DS::followCursor({0,0}, cameraTime += 16);
        if (Platform3DS::viewport() != fheroes2::Point{320,240}) throw std::runtime_error("Touch release moved viewport");
        Platform3DS::followCursor({1,1}, cameraTime += 16);
        Platform3DS::followCursor({0,0}, cameraTime += 16);
        if (Platform3DS::touchPosition(0.5f,0.5f) != fheroes2::Point{160,120}) throw std::runtime_error("Touch center differs");
        std::fprintf(log, "3DS viewport/touch edges and hold: PASS\n");
        Platform3DS::resetViewportFollow();
        Platform3DS::followCursor({160,120}, cameraTime += 16);
        Platform3DS::followCursor({180,135}, cameraTime += 16);
        if (Platform3DS::viewport() != fheroes2::Point{0,0}) throw std::runtime_error("Camera moved inside stationary zone");
        Platform3DS::followCursor({300,200}, cameraTime += 16);
        const auto firstStep = Platform3DS::viewport();
        if (firstStep.x <= 0 || firstStep.x >= 108 || firstStep.y <= 0 || firstStep.y >= 56)
            throw std::runtime_error("Camera did not ease towards target");
        if (Platform3DS::needsViewportRefresh(cameraTime + 15) || !Platform3DS::needsViewportRefresh(cameraTime + 16))
            throw std::runtime_error("Camera refresh scheduling differs");
        for (int i=0; i<45; ++i) Platform3DS::followCursor({300,200}, cameraTime += 16);
        if (Platform3DS::viewport() != fheroes2::Point{108,56} || Platform3DS::needsViewportRefresh(cameraTime + 16))
            throw std::runtime_error("Stationary pointer camera did not settle");
        const auto settled = Platform3DS::viewport();
        if (Platform3DS::touchPosition(0.5f,0.5f) != fheroes2::Point{settled.x+160,settled.y+120})
            throw std::runtime_error("Eased viewport touch mapping differs");
        Platform3DS::followCursor({400,250}, cameraTime += 16, true);
        Platform3DS::followCursor({400,250}, cameraTime += 16, false);
        if (Platform3DS::viewport() != settled) throw std::runtime_error("Button hold or release moved viewport");
        // Same elapsed time must produce the same camera position at different update rates.
        const auto runCamera = [](const uint32_t step) {
            Platform3DS::resetViewportFollow();
            Platform3DS::followCursor({0,0}, 0);
            Platform3DS::followCursor({160,120}, 16);
            for (uint32_t t=step; t<=160; t+=step) Platform3DS::followCursor({300,200}, 16+t);
            return Platform3DS::viewport();
        };
        if (runCamera(16) != runCamera(32)) throw std::runtime_error("Camera easing depends on frame rate");
        const auto interrupted = Platform3DS::viewport();
        Platform3DS::setTouchHeld(true);
        Platform3DS::followCursor({interrupted.x+20,interrupted.y+30}, 192);
        Platform3DS::setTouchHeld(false);
        Platform3DS::followCursor({interrupted.x+20,interrupted.y+30}, 208);
        Platform3DS::followCursor({interrupted.x+20,interrupted.y+30}, 224);
        if (Platform3DS::viewport() != interrupted || Platform3DS::needsViewportRefresh(240))
            throw std::runtime_error("Touch left residual camera motion");
        std::fprintf(log, "3DS smooth follow: dead zone, settling, button freeze, timing: PASS\n");
        Platform3DS::resetViewportFollow();
        Platform3DS::followCursor({0,0}, 0);
        Platform3DS::setTouchHeld(true);
        Platform3DS::followTouchMotion(0.5f,0.5f,16);
        if (Platform3DS::viewport() != fheroes2::Point{0,0}) throw std::runtime_error("Central stylus motion moved camera");
        Platform3DS::followTouchMotion(0.95f,0.875f,32);
        const auto touchCrop = Platform3DS::viewport();
        if (touchCrop.x <= 0 || touchCrop.y <= 0 || !Platform3DS::needsViewportRefresh(32))
            throw std::runtime_error("Stylus motion did not scroll or schedule refresh");
        const auto touchCursor = Platform3DS::touchPosition(0.95f,0.875f);
        if (touchCursor != fheroes2::Point{touchCrop.x+304,touchCrop.y+210})
            throw std::runtime_error("Scrolling stylus cursor differs from touch point");
        Platform3DS::followCursor(touchCursor,48,true);
        Platform3DS::followCursor(touchCursor,64,true);
        if (Platform3DS::viewport() != touchCrop || Platform3DS::needsViewportRefresh(80))
            throw std::runtime_error("Stationary stylus kept scrolling");
        for (uint32_t t=80; t<=800; t+=16) {
            Platform3DS::followTouchMotion(1.0f,1.0f,t);
            Platform3DS::followCursor(Platform3DS::touchPosition(1.0f,1.0f),t,true);
        }
        if (Platform3DS::viewport() != fheroes2::Point{320,240}) throw std::runtime_error("Stylus did not reach frame edge");
        Platform3DS::setTouchHeld(false);
        Platform3DS::followCursor({639,479},816);
        if (Platform3DS::viewport() != fheroes2::Point{320,240}) throw std::runtime_error("Stylus release moved scrolled viewport");
        std::fprintf(log, "3DS stylus follow: scrolling, cursor mapping, stationary hold, edges: PASS\n");
        if (SDL_Init(SDL_INIT_EVENTS | SDL_INIT_TIMER) != 0) throw std::runtime_error("SDL event init failed");
        LocalEvent::initEventEngine();
        auto & events = LocalEvent::Get();
        const auto sendTouch = [&events](const Uint32 type, const float x, const float y) {
            SDL_Event event{};
            event.type = type;
            event.tfinger.touchId = 1;
            event.tfinger.fingerId = 0;
            event.tfinger.x = x;
            event.tfinger.y = y;
            if (SDL_PushEvent(&event) != 1) throw std::runtime_error("Touch event injection failed");
            // SDL_PollEvent can first consume the previous pump's end-of-cycle sentinel.
            for (int attempt=0; attempt<4 && SDL_HasEvent(type); ++attempt) {
                if (!events.HandleEvents(false,true)) throw std::runtime_error("Touch event processing failed");
            }
            if (SDL_HasEvent(type)) throw std::runtime_error("Touch event was not drained");
        };
        const auto beforeTap = Platform3DS::viewport();
        sendTouch(SDL_FINGERDOWN,0.95f,0.875f);
        sendTouch(SDL_FINGERMOTION,0.96f,0.88f);
        sendTouch(SDL_FINGERUP,0,0);
        if (!events.MouseClickLeft()) throw std::runtime_error("Normal stylus tap was swallowed");
        if (Platform3DS::viewport() != beforeTap) throw std::runtime_error("Pen jitter moved viewport");
        sendTouch(SDL_FINGERDOWN,0.5f,0.5f);
        sendTouch(SDL_FINGERMOTION,0.7f,0.7f);
        if (!Platform3DS::isTouchViewportGesture()) throw std::runtime_error("Touch gesture not recognized");
        sendTouch(SDL_FINGERUP,0,0);
        if (events.MouseClickLeft() || events.MouseClickLeft({0,0,640,480})) throw std::runtime_error("Viewport gesture became a click");
        if (Interface::BaseInterface::isScrollLeft({0,0}) || Interface::BaseInterface::isScrollTop({0,0})
            || Interface::BaseInterface::isScrollRight({639,479}) || Interface::BaseInterface::isScrollBottom({639,479}))
            throw std::runtime_error("Stylus enabled map edge scroll");
        Platform3DS::useControllerPointer();
        if (!Interface::BaseInterface::isScrollLeft({0,0}) || !Interface::BaseInterface::isScrollTop({0,0}))
            throw std::runtime_error("Controller did not restore map edge scroll");
        // A fresh tap after a completed drag must remain usable.
        sendTouch(SDL_FINGERDOWN,0.5f,0.5f);
        sendTouch(SDL_FINGERUP,0,0);
        if (!events.MouseClickLeft()) throw std::runtime_error("Tap after viewport gesture was swallowed");
        std::fprintf(log, "3DS input routing: real touch events, tap, gesture cancellation, map edge scroll: PASS\n");
        sendTouch(SDL_FINGERDOWN,0.5f,0.5f);
        if (!events.isMouseLeftButtonPressed() || events.isMouseRightButtonPressed()) throw std::runtime_error("Short hold became right press");
        SDL_Delay(600);
        events.HandleEvents(false,true);
        if (!events.isMouseRightButtonPressed() || events.isMouseLeftButtonPressed()) throw std::runtime_error("Stationary hold did not become right press");
        const auto holdCursor = events.getMouseCursorPos();
        const auto holdCrop = Platform3DS::viewport();
        sendTouch(SDL_FINGERMOTION,0.9f,0.9f);
        if (events.getMouseCursorPos() != holdCursor || Platform3DS::viewport() != holdCrop || !events.isMouseRightButtonPressed())
            throw std::runtime_error("Right hold did not retain its target");
        sendTouch(SDL_FINGERUP,0,0);
        if (events.isMouseRightButtonPressed() || events.MouseClickLeft() || !events.MouseClickRight())
            throw std::runtime_error("Right hold release differs");
        sendTouch(SDL_FINGERDOWN,0.5f,0.5f);
        sendTouch(SDL_FINGERMOTION,0.7f,0.7f);
        SDL_Delay(600);
        events.HandleEvents(false,true);
        if (events.isMouseRightButtonPressed()) throw std::runtime_error("Viewport drag became right press");
        sendTouch(SDL_FINGERUP,0,0);
        sendTouch(SDL_FINGERDOWN,0.5f,0.5f);
        sendTouch(SDL_FINGERUP,0,0);
        if (!events.MouseClickLeft()) throw std::runtime_error("Tap after right hold was swallowed");
        std::fprintf(log, "3DS stylus right hold: delay, fixed target, right release, gesture cancellation: PASS\n");
        fheroes2::Image panelImage(320,240);
        events.resetFor3DSPanel();
        Platform3DS::setCommandPanelImage(&panelImage);
        const auto panelCrop = Platform3DS::viewport();
        sendTouch(SDL_FINGERDOWN,0.25f,0.25f);
        sendTouch(SDL_FINGERUP,0,0);
        if (events.isMouseLeftButtonPressed() || events.MouseClickLeft() || Platform3DS::viewport() != panelCrop)
            throw std::runtime_error("Panel touch leaked into game input");
        Platform3DS::PanelInput panelInput;
        if (!Platform3DS::consumePanelInput(panelInput) || panelInput.type != Platform3DS::PanelInputType::TouchDown
            || panelInput.position != fheroes2::Point{80,60}) throw std::runtime_error("Panel touch coordinates differ");
        if (!Platform3DS::consumePanelInput(panelInput) || panelInput.type != Platform3DS::PanelInputType::TouchUp)
            throw std::runtime_error("Panel touch release missing");
        for (int i=0; i<8; ++i) {
            const auto rect = Platform3DS::panelButtonRect(i);
            if (Platform3DS::panelButtonAt({rect.x+rect.width/2,rect.y+rect.height/2}) != i)
                throw std::runtime_error("Panel button hit testing differs");
        }
        if (Platform3DS::panelButtonAt({160,80}) != -1) throw std::runtime_error("Panel gutter is clickable");
        if (!Platform3DS::handlePanelController(SDL_CONTROLLER_BUTTON_A,true)) throw std::runtime_error("Panel A not captured");
        if (!Platform3DS::consumePanelInput(panelInput) || panelInput.key != Platform3DS::PanelKey::Confirm)
            throw std::runtime_error("Panel confirm missing");
        Platform3DS::setCommandPanelImage(nullptr);
        if (!Platform3DS::handlePanelController(SDL_CONTROLLER_BUTTON_A,false)
            || Platform3DS::handlePanelController(SDL_CONTROLLER_BUTTON_A,true)) throw std::runtime_error("Panel close release guard differs");
        std::fprintf(log, "3DS command panel: input isolation, physical hit testing, closing release guard: PASS\n");
        fheroes2::Image stripImage(320,40);
        Platform3DS::setCommandStripImage(&stripImage);
        Platform3DS::resetViewportFollow();
        for (uint32_t t=0; t<=1200; t+=16) Platform3DS::followCursor({639,479},t);
        if (Platform3DS::detailHeight() != 200 || Platform3DS::viewport() != fheroes2::Point{320,280}
            || Platform3DS::needsViewportRefresh(1300)) throw std::runtime_error("Strip viewport edge or easing differs");
        if (Platform3DS::touchPosition(1,1) != fheroes2::Point{639,479}) throw std::runtime_error("Strip map touch bounds differ");
        Platform3DS::setCommandStripImage(nullptr);
        Platform3DS::followCursor({639,479},1320);
        if (Platform3DS::detailHeight() != 240 || Platform3DS::viewport() != fheroes2::Point{320,240})
            throw std::runtime_error("Hidden strip viewport escaped full frame");
        Platform3DS::setCommandStripImage(&stripImage);
        for (uint32_t t=1340; t<=2600; t+=16) Platform3DS::followCursor({639,479},t);
        if (Platform3DS::viewport() != fheroes2::Point{320,280} || Platform3DS::needsViewportRefresh(2700))
            throw std::runtime_error("Restored strip viewport did not settle");
        Platform3DS::resetViewportFollow();
        Platform3DS::beginTouch(.5f,.5f);
        for (uint32_t t=0; t<=1200; t+=16) Platform3DS::followTouchMotion(1,1,t);
        if (Platform3DS::viewport() != fheroes2::Point{320,280}) throw std::runtime_error("Stylus strip viewport cannot reach bottom edge");
        Platform3DS::setCommandStripImage(nullptr);
        events.resetFor3DSPanel();
        std::fprintf(log, "3DS command strip viewport: 200px detail, edges, toggle bounds, easing, stylus: PASS\n");
        Platform3DS::setVirtualFrameSize({800,480});
        for (uint32_t t=0; t<=1200; t+=16) Platform3DS::followCursor({799,479},t);
        if (Platform3DS::viewport() != fheroes2::Point{480,240}
            || Platform3DS::touchPosition(1,1) != fheroes2::Point{799,479}
            || Platform3DS::needsViewportRefresh(1300)) throw std::runtime_error("Wide frame right edge or settling differs");
        Platform3DS::setCommandStripImage(&stripImage);
        for (uint32_t t=1340; t<=2600; t+=16) Platform3DS::followCursor({799,479},t);
        if (Platform3DS::viewport() != fheroes2::Point{480,280} || Platform3DS::needsViewportRefresh(2700))
            throw std::runtime_error("Wide strip frame edge differs");
        Platform3DS::resetViewportFollow();
        Platform3DS::followCursor({0,0},2800);
        Platform3DS::beginTouch(.5f,.5f);
        for (uint32_t t=2820; t<=4800; t+=16) Platform3DS::followTouchMotion(1,1,t);
        if (Platform3DS::viewport() != fheroes2::Point{480,280}) throw std::runtime_error("Stylus cannot reach wide frame edge");
        Platform3DS::setCommandStripImage(nullptr);
        Platform3DS::setVirtualFrameSize({640,480});
        if (Platform3DS::viewport() != fheroes2::Point{320,240}) throw std::runtime_error("Frame shrink left viewport out of bounds");
        Platform3DS::setVirtualFrameSize({800,480});
        events.resetFor3DSPanel();
        const auto sendButton = [&events](const int button, const bool pressed) {
            SDL_Event event{}; event.type = pressed ? SDL_CONTROLLERBUTTONDOWN : SDL_CONTROLLERBUTTONUP;
            event.cbutton.button = button; event.cbutton.state = pressed ? SDL_PRESSED : SDL_RELEASED;
            if (SDL_PushEvent(&event) != 1) throw std::runtime_error("D-pad injection failed");
            for (int attempt=0; attempt<4 && SDL_HasEvent(event.type); ++attempt) events.HandleEvents(false,true);
            if (SDL_HasEvent(event.type)) throw std::runtime_error("D-pad event was not drained");
        };
        Platform3DS::setAdventureInputActive(true);
        sendButton(SDL_CONTROLLER_BUTTON_DPAD_LEFT,true);
        if (Platform3DS::adventureScrollDirection() != fheroes2::Point{-1,0} || events.isAnyKeyPressed())
            throw std::runtime_error("Map left leaked into hero hotkey");
        events.HandleEvents(false,true);
        if (Platform3DS::adventureScrollDirection() != fheroes2::Point{-1,0}) throw std::runtime_error("D-pad hold lost without events");
        sendButton(SDL_CONTROLLER_BUTTON_DPAD_UP,true);
        if (Platform3DS::adventureScrollDirection() != fheroes2::Point{-1,-1}) throw std::runtime_error("D-pad diagonal differs");
        sendButton(SDL_CONTROLLER_BUTTON_DPAD_RIGHT,true);
        if (Platform3DS::adventureScrollDirection() != fheroes2::Point{0,-1}) throw std::runtime_error("Opposite directions do not cancel");
        sendButton(SDL_CONTROLLER_BUTTON_DPAD_UP,false);
        sendButton(SDL_CONTROLLER_BUTTON_DPAD_RIGHT,false);
        sendButton(SDL_CONTROLLER_BUTTON_DPAD_LEFT,false);
        if (Platform3DS::adventureScrollDirection() != fheroes2::Point{}) throw std::runtime_error("Released D-pad kept scrolling");
        sendButton(SDL_CONTROLLER_BUTTON_DPAD_DOWN,true);
        if (Platform3DS::adventureScrollDirection() != fheroes2::Point{0,1}) throw std::runtime_error("Map down differs");
        Platform3DS::setAdventureInputActive(false);
        events.HandleEvents(false,true);
        if (Platform3DS::adventureScrollDirection() != fheroes2::Point{}) throw std::runtime_error("Dialog inherited map scroll");
        Platform3DS::setAdventureInputActive(true);
        events.HandleEvents(false,true);
        if (Platform3DS::adventureScrollDirection() != fheroes2::Point{}) throw std::runtime_error("Dialog exit resumed stale hold");
        Platform3DS::setAdventureInputActive(false);
        sendButton(SDL_CONTROLLER_BUTTON_DPAD_DOWN,false);
        if (events.isAnyKeyPressed()) throw std::runtime_error("Map button release leaked into dialog");
        sendButton(SDL_CONTROLLER_BUTTON_DPAD_RIGHT,true);
        if (!events.isKeyPressed(fheroes2::Key::KEY_T)) throw std::runtime_error("Non-map D-pad mapping changed");
        sendButton(SDL_CONTROLLER_BUTTON_DPAD_RIGHT,false);
        Platform3DS::cancelAdventureScroll();
        std::fprintf(log, "3DS wide frame and D-pad: 800px edge, stylus, shrink, hold, diagonals, opposites, release, modal isolation: PASS\n");
        passed = true;
    } catch (const std::exception& exception) {
        std::fprintf(log, "FAIL: %s\n", exception.what());
    }
    std::fprintf(log, "ENGINE SELFTEST: %s\n", passed ? "PASS" : "FAIL");
    std::fclose(log);
    return passed ? 0 : 1;
}
