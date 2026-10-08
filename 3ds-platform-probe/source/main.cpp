// SPDX-License-Identifier: GPL-2.0-or-later
#include <SDL.h>
#include <3ds.h>

#include <algorithm>
#include <array>
#include <atomic>
#include <chrono>
#include <cmath>
#include <condition_variable>
#include <cstdarg>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <malloc.h>
#include <mutex>
#include <stdexcept>
#include <string>
#include <thread>
#include <vector>

namespace {
constexpr int gameWidth = 640;
constexpr int gameHeight = 480;
constexpr int cropWidth = 320;
constexpr int cropHeight = 240;
constexpr const char* logDirectory = "sdmc:/3ds/fheroes2-probe";
thread_local int threadLocalProbe = 7;

class Log {
public:
    Log() {
        std::error_code error;
        std::filesystem::create_directories(logDirectory, error);
        _file = std::fopen("sdmc:/3ds/fheroes2-probe/probe.log", "a");
        write("BEGIN probe %s, compiler %s", PROBE_VERSION, __VERSION__);
        if (error) write("mkdir error: %s", error.message().c_str());
    }
    ~Log() { if (_file) std::fclose(_file); }
    bool available() const { return _file != nullptr; }
    void write(const char* format, ...) {
        if (!_file) return;
        std::fprintf(_file, "[%lu ms] ", static_cast<unsigned long>(SDL_GetTicks()));
        va_list arguments;
        va_start(arguments, format);
        std::vfprintf(_file, format, arguments);
        va_end(arguments);
        std::fputc('\n', _file);
        std::fflush(_file);
    }
private:
    FILE* _file = nullptr;
};

void memorySnapshot(Log& log, const char* stage) {
    const auto memory = mallinfo();
    const u32 regionSize = osGetMemRegionSize(MEMREGION_APPLICATION);
    const u32 regionUsed = osGetMemRegionUsed(MEMREGION_APPLICATION);
    const bool regionValid = regionUsed <= regionSize;
    log.write("MEM %s: heap_size=%lu used_alloc=%d free_in_heap=%d linear_free=%lu app_region_size=%lu app_region_used=%lu app_region_free=%ld valid=%d",
        stage, static_cast<unsigned long>(envGetHeapSize()), memory.uordblks, memory.fordblks,
        static_cast<unsigned long>(linearSpaceFree()),
        static_cast<unsigned long>(regionSize), static_cast<unsigned long>(regionUsed),
        regionValid ? static_cast<long>(regionSize - regionUsed) : -1L, regionValid);
}

bool testFilesystem(Log& log) {
    try {
        const auto directory = std::filesystem::path(logDirectory) / "runtime-test";
        std::filesystem::create_directories(directory);
        const auto path = directory / "roundtrip.txt";
        const std::string expected = "fheroes2-probe SD roundtrip v1";
        {
            std::ofstream output(path, std::ios::trunc);
            output << expected;
            output.flush();
            if (!output) throw std::runtime_error("write/flush failed");
        }
        std::ifstream input(path);
        std::string actual;
        std::getline(input, actual);
        bool found = false;
        for (const auto& item : std::filesystem::directory_iterator(directory)) {
            if (item.path().filename() == "roundtrip.txt" && item.is_regular_file()) found = true;
        }
        const bool passed = input && actual == expected && found;
        log.write("TEST filesystem: %s, bytes=%lu, directory_iterator=%d", passed ? "PASS" : "FAIL",
            static_cast<unsigned long>(std::filesystem::file_size(path)), found);
        return passed;
    } catch (const std::exception& error) {
        log.write("TEST filesystem: FAIL: %s", error.what());
        return false;
    }
}

bool testCppThreads(Log& log) {
    try {
        std::mutex mutex;
        std::condition_variable condition;
        bool ready = false;
        int result = 0;
        threadLocalProbe = 11;
        std::thread worker([&] {
            // Yield explicitly on 3DS. Do not assume preemptive desktop scheduling.
            SDL_Delay(10);
            {
                std::lock_guard<std::mutex> lock(mutex);
                result = threadLocalProbe == 7 ? 42 : 0;
                threadLocalProbe = 42;
                ready = true;
            }
            condition.notify_one();
        });
        bool passed;
        {
            std::unique_lock<std::mutex> lock(mutex);
            passed = condition.wait_for(lock, std::chrono::seconds(2), [&] { return ready; });
        }
        worker.join();
        passed = passed && result == 42 && threadLocalProbe == 11;
        log.write("TEST std::thread + mutex + condition_variable + thread_local: %s", passed ? "PASS" : "FAIL");
        return passed;
    } catch (const std::exception& error) {
        log.write("TEST std::thread: FAIL: %s", error.what());
        return false;
    }
}

struct SDLThreadState {
    SDL_sem* semaphore = nullptr;
    std::atomic<int> result{0};
};

int sdlWorker(void* pointer) {
    auto& state = *static_cast<SDLThreadState*>(pointer);
    SDL_Delay(10);
    state.result.store(73);
    SDL_SemPost(state.semaphore);
    return 0;
}

bool testSDLThreads(Log& log) {
    SDLThreadState state;
    state.semaphore = SDL_CreateSemaphore(0);
    if (!state.semaphore) {
        log.write("TEST SDL thread: FAIL: %s", SDL_GetError());
        return false;
    }
    SDL_Thread* worker = SDL_CreateThread(sdlWorker, "probe-worker", &state);
    if (!worker) {
        log.write("TEST SDL thread: FAIL: %s", SDL_GetError());
        SDL_DestroySemaphore(state.semaphore);
        return false;
    }
    const bool passed = SDL_SemWaitTimeout(state.semaphore, 2000) == 0 && state.result.load() == 73;
    SDL_WaitThread(worker, nullptr);
    SDL_DestroySemaphore(state.semaphore);
    log.write("TEST SDL thread + semaphore: %s", passed ? "PASS" : "FAIL");
    return passed;
}

// Small original bitmap alphabet: no external font or original game assets required.
struct Glyph { char character; std::array<Uint8, 7> rows; };
constexpr Glyph alphabet[] = {
    {'A',{14,17,17,31,17,17,17}}, {'B',{30,17,17,30,17,17,30}},
    {'C',{14,17,16,16,16,17,14}}, {'D',{30,17,17,17,17,17,30}},
    {'E',{31,16,16,30,16,16,31}}, {'F',{31,16,16,30,16,16,16}},
    {'G',{14,17,16,23,17,17,15}}, {'H',{17,17,17,31,17,17,17}},
    {'I',{14,4,4,4,4,4,14}}, {'J',{7,2,2,2,18,18,12}},
    {'K',{17,18,20,24,20,18,17}}, {'L',{16,16,16,16,16,16,31}},
    {'M',{17,27,21,21,17,17,17}}, {'N',{17,25,21,19,17,17,17}},
    {'O',{14,17,17,17,17,17,14}}, {'P',{30,17,17,30,16,16,16}},
    {'Q',{14,17,17,17,21,18,13}}, {'R',{30,17,17,30,20,18,17}},
    {'S',{15,16,16,14,1,1,30}}, {'T',{31,4,4,4,4,4,4}},
    {'U',{17,17,17,17,17,17,14}}, {'V',{17,17,17,17,17,10,4}},
    {'W',{17,17,17,21,21,21,10}}, {'X',{17,17,10,4,10,17,17}},
    {'Y',{17,17,10,4,4,4,4}}, {'Z',{31,1,2,4,8,16,31}},
    {'0',{14,17,19,21,25,17,14}}, {'1',{4,12,4,4,4,4,14}},
    {'2',{14,17,1,2,4,8,31}}, {'3',{30,1,1,14,1,1,30}},
    {'4',{2,6,10,18,31,2,2}}, {'5',{31,16,16,30,1,1,30}},
    {'6',{14,16,16,30,17,17,14}}, {'7',{31,1,2,4,8,8,8}},
    {'8',{14,17,17,14,17,17,14}}, {'9',{14,17,17,15,1,1,14}},
    {':',{0,4,4,0,4,4,0}}, {'.',{0,0,0,0,0,4,4}},
    {'/',{1,2,2,4,8,8,16}}, {'-',{0,0,0,31,0,0,0}},
    {'=',{0,31,0,31,0,0,0}}, {'+',{0,4,4,31,4,4,0}},
    {'?',{14,17,1,2,4,0,4}}
};

template<class Pixel>
void textPixels(const std::string& text, int x, int y, Pixel&& pixel, int scale = 1) {
    for (char character : text) {
        const auto glyph = std::find_if(std::begin(alphabet), std::end(alphabet),
            [character](const Glyph& item) { return item.character == character; });
        if (glyph != std::end(alphabet)) {
            for (int row = 0; row < 7; ++row) for (int column = 0; column < 5; ++column) {
                if (!(glyph->rows[row] & (1 << (4 - column)))) continue;
                for (int dy = 0; dy < scale; ++dy) for (int dx = 0; dx < scale; ++dx)
                    pixel(x + column * scale + dx, y + row * scale + dy);
            }
        }
        x += 6 * scale;
    }
}

struct Screen {
    SDL_Window* window = nullptr;
    SDL_Renderer* renderer = nullptr;
    SDL_Texture* texture = nullptr;
    ~Screen() {
        SDL_DestroyTexture(texture);
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
    }
    bool create(int display, int width, int height, int textureWidth, int textureHeight, Log& log) {
        window = SDL_CreateWindow("fheroes2 platform probe", SDL_WINDOWPOS_UNDEFINED_DISPLAY(display),
            SDL_WINDOWPOS_UNDEFINED_DISPLAY(display), width, height, SDL_WINDOW_FULLSCREEN);
        if (window) renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_SOFTWARE);
        if (renderer) texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_ARGB8888,
            SDL_TEXTUREACCESS_STREAMING, textureWidth, textureHeight);
        if (!texture) { log.write("FAIL screen %d: %s", display, SDL_GetError()); return false; }
        SDL_SetTextureBlendMode(texture, SDL_BLENDMODE_NONE);
        SDL_RendererInfo info{};
        SDL_GetRendererInfo(renderer, &info);
        int actualWidth = 0, actualHeight = 0;
        SDL_GetWindowSize(window, &actualWidth, &actualHeight);
        log.write("SCREEN %d: %dx%d, renderer=%s flags=%lu, texture=%dx%d", display,
            actualWidth, actualHeight, info.name, static_cast<unsigned long>(info.flags), textureWidth, textureHeight);
        return true;
    }
};

void screenText(SDL_Renderer* renderer, const std::string& text, int x, int y) {
    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
    textPixels(text, x, y, [renderer](int px, int py) { SDL_RenderDrawPoint(renderer, px, py); });
}

void makeTestFrame(std::vector<Uint8>& image) {
    for (int y = 0; y < gameHeight; ++y) for (int x = 0; x < gameWidth; ++x) {
        Uint8 value = static_cast<Uint8>(16 + ((x / 32 + y / 32) % 12) * 12);
        if (x % 32 == 0 || y % 32 == 0) value = 240;
        image[y * gameWidth + x] = value;
    }
    auto pixel = [&image](int x, int y) {
        if (x >= 0 && x < gameWidth && y >= 0 && y < gameHeight) image[y * gameWidth + x] = 240;
    };
    textPixels("FHEROES2 3DS PLATFORM TEST", 30, 20, pixel, 2);
    textPixels("640 X 480 VIRTUAL FRAME", 30, 48, pixel, 2);
    for (int row = 0; row < 4; ++row) {
        for (int column = 0; column < 4; ++column) {
            textPixels(std::to_string(column * 160) + ":" + std::to_string(row * 120),
                column * 160 + 8, row * 120 + 88, pixel);
        }
    }
    textPixels("BOTTOM RIGHT 639:479", 378, 454, pixel, 2);
}

struct Input {
    double cursorX = 320, cursorY = 240;
    double cropX = 160, cropY = 120;
    std::array<bool, SDL_CONTROLLER_BUTTON_MAX> buttons{};
    Sint16 axisX = 0, axisY = 0;
    bool touch = false;
    bool fast = true;
    bool showStatus = true;
    bool running = true;
};

double axisSpeed(Sint16 axis) {
    if (std::abs(static_cast<int>(axis)) < 6000) return 0;
    return static_cast<double>(axis) / 32768.0 * 240;
}

void handleEvent(const SDL_Event& event, Input& input, Log& log, bool& sdPass) {
        switch (event.type) {
        case SDL_QUIT: input.running = false; break;
        case SDL_CONTROLLERAXISMOTION:
            if (event.caxis.axis == SDL_CONTROLLER_AXIS_LEFTX) input.axisX = event.caxis.value;
            if (event.caxis.axis == SDL_CONTROLLER_AXIS_LEFTY) input.axisY = event.caxis.value;
            break;
        case SDL_CONTROLLERBUTTONDOWN:
        case SDL_CONTROLLERBUTTONUP: {
            const bool down = event.type == SDL_CONTROLLERBUTTONDOWN;
            if (event.cbutton.button < input.buttons.size()) input.buttons[event.cbutton.button] = down;
            log.write("BUTTON %s %u cursor=%d,%d", down ? "DOWN" : "UP", event.cbutton.button,
                static_cast<int>(input.cursorX), static_cast<int>(input.cursorY));
            if (!down) break;
            if (event.cbutton.button == SDL_CONTROLLER_BUTTON_START) input.running = false;
            if (event.cbutton.button == SDL_CONTROLLER_BUTTON_BACK) input.showStatus = !input.showStatus;
            if (event.cbutton.button == SDL_CONTROLLER_BUTTON_X) {
                input.fast = !input.fast;
                osSetSpeedupEnable(input.fast);
                log.write("SPEEDUP requested=%d (not an Old 3DS emulation)", input.fast);
            }
            if (event.cbutton.button == SDL_CONTROLLER_BUTTON_Y) sdPass = testFilesystem(log);
            break;
        }
        case SDL_FINGERDOWN:
        case SDL_FINGERMOTION:
        case SDL_FINGERUP:
            input.cursorX = std::clamp(std::floor(input.cropX) + std::floor(event.tfinger.x * cropWidth), 0.0, 639.0);
            input.cursorY = std::clamp(std::floor(input.cropY) + std::floor(event.tfinger.y * cropHeight), 0.0, 479.0);
            input.touch = event.type != SDL_FINGERUP;
            if (event.type != SDL_FINGERMOTION) log.write("TOUCH %s game=%d,%d crop=%d,%d",
                input.touch ? "DOWN" : "UP", static_cast<int>(input.cursorX), static_cast<int>(input.cursorY),
                static_cast<int>(input.cropX), static_cast<int>(input.cropY));
            break;
        case SDL_APP_WILLENTERBACKGROUND:
            log.write("LIFECYCLE background"); break;
        case SDL_APP_DIDENTERFOREGROUND:
            log.write("LIFECYCLE foreground"); break;
        default: break;
        }
}

void pollEvents(Input& input, Log& log, bool& sdPass) {
    SDL_Event event;
    while (SDL_PollEvent(&event)) handleEvent(event, input, log, sdPass);
}

void updateInput(Input& input, double elapsed) {
    // Keep the displayed fragment and cursor anchored while a stylus is held.
    if (input.touch) return;
    input.cursorX = std::clamp(input.cursorX + axisSpeed(input.axisX) * elapsed, 0.0, 639.0);
    input.cursorY = std::clamp(input.cursorY + axisSpeed(input.axisY) * elapsed, 0.0, 479.0);
    // Manual D-pad panning, deliberately independent of the cursor.
    const int dx = input.buttons[SDL_CONTROLLER_BUTTON_DPAD_RIGHT] - input.buttons[SDL_CONTROLLER_BUTTON_DPAD_LEFT];
    const int dy = input.buttons[SDL_CONTROLLER_BUTTON_DPAD_DOWN] - input.buttons[SDL_CONTROLLER_BUTTON_DPAD_UP];
    input.cropX = std::clamp(input.cropX + dx * 180 * elapsed, 0.0, 320.0);
    input.cropY = std::clamp(input.cropY + dy * 180 * elapsed, 0.0, 240.0);
}

bool testInput(Log& log, bool& sdPass) {
    Input input;
    SDL_Event event{};
    bool passed = true;
    for (Uint8 button : {SDL_CONTROLLER_BUTTON_A, SDL_CONTROLLER_BUTTON_B}) {
        event.type = SDL_CONTROLLERBUTTONDOWN;
        event.cbutton.button = button;
        handleEvent(event, input, log, sdPass);
        passed &= input.buttons[button];
        event.type = SDL_CONTROLLERBUTTONUP;
        handleEvent(event, input, log, sdPass);
        passed &= !input.buttons[button];
    }
    input.cropX = 160.8; input.cropY = 120.4;
    event.type = SDL_FINGERDOWN; event.tfinger.x = 0.5f; event.tfinger.y = 0.5f;
    handleEvent(event, input, log, sdPass);
    passed &= input.touch && input.cursorX == 320 && input.cursorY == 240;
    input.buttons[SDL_CONTROLLER_BUTTON_DPAD_RIGHT] = true;
    input.axisX = 32767;
    updateInput(input, 1.0);
    passed &= input.cropX == 160.8 && input.cursorX == 320;
    event.type = SDL_FINGERUP;
    handleEvent(event, input, log, sdPass);
    passed &= !input.touch;
    updateInput(input, 1.0);
    passed &= input.cursorX > 550 && input.cropX == 320;
    input.axisX = 0;
    input.buttons[SDL_CONTROLLER_BUTTON_DPAD_RIGHT] = false;
    input.cropY = 240;
    event.type = SDL_FINGERDOWN; event.tfinger.x = 1.0f; event.tfinger.y = 1.0f;
    handleEvent(event, input, log, sdPass);
    passed &= input.cursorX == 639 && input.cursorY == 479;
    event.type = SDL_FINGERUP;
    handleEvent(event, input, log, sdPass);
    event.type = SDL_CONTROLLERBUTTONDOWN; event.cbutton.button = SDL_CONTROLLER_BUTTON_START;
    handleEvent(event, input, log, sdPass);
    passed &= !input.running;
    log.write("TEST input event handler (synthetic, not physical HID): %s", passed ? "PASS" : "FAIL");
    return passed;
}

bool saveFrame(Screen& screen, const char* name, Log& log) {
    int width = 0, height = 0;
    SDL_GetRendererOutputSize(screen.renderer, &width, &height);
    SDL_Surface* frame = SDL_CreateRGBSurfaceWithFormat(0, width, height, 32, SDL_PIXELFORMAT_ARGB8888);
    if (!frame) { log.write("FAIL snapshot allocation: %s", SDL_GetError()); return false; }
    const std::string path = std::string(logDirectory) + "/" + name;
    const bool passed = SDL_RenderReadPixels(screen.renderer, nullptr, SDL_PIXELFORMAT_ARGB8888, frame->pixels, frame->pitch) == 0
        && SDL_SaveBMP(frame, path.c_str()) == 0;
    log.write("SNAPSHOT %s %dx%d: %s", name, width, height, passed ? "PASS" : SDL_GetError());
    SDL_FreeSurface(frame);
    return passed;
}

int runProbe(Log& log) {
    bool newModel = false;
    const Result modelResult = APT_CheckNew3DS(&newModel);
    log.write("MODEL new=%d query_result=0x%08lx", newModel, static_cast<unsigned long>(modelResult));
    SDL_version version{};
    SDL_GetVersion(&version);
    log.write("SDL runtime %u.%u.%u video=%s", version.major, version.minor, version.patch, SDL_GetCurrentVideoDriver());
    memorySnapshot(log, "before-tests");
    bool sdPass = testFilesystem(log);
    const bool cppPass = testCppThreads(log);
    const bool sdlPass = testSDLThreads(log);
    try { throw std::runtime_error("probe exception roundtrip"); }
    catch (const std::runtime_error&) { log.write("TEST exceptions: PASS"); }
    struct Base { virtual ~Base() = default; };
    struct Derived : Base {};
    Derived derived;
    Base* base = &derived;
    const bool rttiPass = dynamic_cast<Derived*>(base) == &derived;
    log.write("TEST RTTI dynamic_cast: %s", rttiPass ? "PASS" : "FAIL");

    if (SDL_GetNumVideoDisplays() < 2) {
        log.write("FAIL: two physical displays required");
        return 1;
    }
    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "nearest");
    SDL_SetHint(SDL_HINT_TOUCH_MOUSE_EVENTS, "0");
    Screen top, bottom;
    if (!top.create(0, 400, 240, gameWidth, gameHeight, log)
        || !bottom.create(1, cropWidth, cropHeight, cropWidth, cropHeight, log)) return 1;
    SDL_GameController* controller = nullptr;
    for (int index = 0; index < SDL_NumJoysticks(); ++index) {
        if (SDL_IsGameController(index)) { controller = SDL_GameControllerOpen(index); break; }
    }
    log.write("CONTROLLER %s", controller ? SDL_GameControllerName(controller) : "NOT FOUND");
    std::vector<Uint8> indexed(gameWidth * gameHeight);
    std::vector<Uint32> rgba(gameWidth * gameHeight);
    std::vector<Uint32> crop(cropWidth * cropHeight);
    makeTestFrame(indexed);
    memorySnapshot(log, "screens-and-buffers-ready");
    Input input;
    const bool automated = std::filesystem::exists(std::string(logDirectory) + "/selftest.enabled");
    bool automatedPass = sdPass && cppPass && sdlPass && rttiPass;
    unsigned totalFrames = 0;
    if (automated) {
        log.write("SELFTEST enabled: synthetic input, snapshots, automatic exit");
        automatedPass &= testInput(log, sdPass);
    }
    const Uint64 frequency = SDL_GetPerformanceFrequency();
    Uint64 previous = SDL_GetPerformanceCounter();
    Uint32 lastReport = SDL_GetTicks();
    unsigned frames = 0;
    double convertTotal = 0, presentTotal = 0, displayedFPS = 0;
    double displayedConvert = 0, displayedPresent = 0;
    while (input.running) {
        pollEvents(input, log, sdPass);
        if (!input.running) break;
        const Uint64 begin = SDL_GetPerformanceCounter();
        const double elapsed = std::min(0.05, static_cast<double>(begin - previous) / frequency);
        if (begin - previous > frequency / 2) log.write("LIFECYCLE loop gap >500ms (suspend or stall)");
        previous = begin;
        updateInput(input, elapsed);
        const int cropX = static_cast<int>(input.cropX), cropY = static_cast<int>(input.cropY);
        std::array<Uint32, 256> palette{};
        const unsigned shift = (SDL_GetTicks() / 80) % 192;
        for (unsigned i = 0; i < palette.size(); ++i) {
            const unsigned phase = (i + shift) % 192;
            palette[i] = 0xff000000u | ((40 + phase) << 16) | ((40 + (phase * 3) % 192) << 8) | (50 + (phase * 5) % 192);
        }
        palette[240] = 0xffffffffu;
        for (size_t index = 0; index < indexed.size(); ++index) rgba[index] = palette[indexed[index]];
        for (int row = 0; row < cropHeight; ++row) {
            std::copy_n(rgba.data() + (cropY + row) * gameWidth + cropX, cropWidth, crop.data() + row * cropWidth);
        }
        const Uint64 converted = SDL_GetPerformanceCounter();
        if (SDL_UpdateTexture(top.texture, nullptr, rgba.data(), gameWidth * sizeof(Uint32)) < 0
            || SDL_UpdateTexture(bottom.texture, nullptr, crop.data(), cropWidth * sizeof(Uint32)) < 0) {
            log.write("FAIL texture upload: %s", SDL_GetError());
            if (controller) SDL_GameControllerClose(controller);
            return 1;
        }
        SDL_SetRenderDrawColor(top.renderer, 0, 0, 0, 255);
        SDL_RenderClear(top.renderer);
        SDL_Rect overview{40, 0, 320, 240};
        SDL_RenderCopy(top.renderer, top.texture, nullptr, &overview);
        SDL_SetRenderDrawColor(top.renderer, 255, 50, 30, 255);
        SDL_Rect region{40 + cropX / 2, cropY / 2, cropWidth / 2, cropHeight / 2};
        SDL_RenderDrawRect(top.renderer, &region);
        SDL_RenderCopy(bottom.renderer, bottom.texture, nullptr, nullptr);
        const bool pressed = input.touch || input.buttons[SDL_CONTROLLER_BUTTON_A];
        const bool rightPressed = input.buttons[SDL_CONTROLLER_BUTTON_B];
        SDL_SetRenderDrawColor(bottom.renderer, pressed || rightPressed ? 255 : 0, rightPressed ? 0 : 255,
            pressed ? 0 : 255, 255);
        const int cursorX = static_cast<int>(input.cursorX) - cropX;
        const int cursorY = static_cast<int>(input.cursorY) - cropY;
        SDL_RenderDrawLine(bottom.renderer, cursorX - 7, cursorY, cursorX + 7, cursorY);
        SDL_RenderDrawLine(bottom.renderer, cursorX, cursorY - 7, cursorX, cursorY + 7);
        SDL_SetRenderDrawColor(top.renderer, 255, 0, 0, 255);
        SDL_Rect cursorMark{40 + static_cast<int>(input.cursorX) / 2 - 2, static_cast<int>(input.cursorY) / 2 - 2, 5, 5};
        SDL_RenderDrawRect(top.renderer, &cursorMark);
        if (input.showStatus) {
            SDL_SetRenderDrawColor(top.renderer, 0, 0, 0, 255);
            SDL_Rect status{0, 0, 400, 48};
            SDL_RenderFillRect(top.renderer, &status);
            char line[80];
            std::snprintf(line, sizeof(line), "PROBE %s %s LOG:%s SD:%s CPP:%s SDL:%s", PROBE_VERSION,
                newModel ? "NEW" : "OLD", log.available() ? "OK" : "FAIL", sdPass ? "OK" : "FAIL",
                cppPass ? "OK" : "FAIL", sdlPass ? "OK" : "FAIL");
            screenText(top.renderer, line, 2, 2);
            std::snprintf(line, sizeof(line), "FPS:%.1f CONVERT:%.2fMS DRAW:%.2fMS", displayedFPS, displayedConvert, displayedPresent);
            screenText(top.renderer, line, 2, 11);
            std::snprintf(line, sizeof(line), "CURSOR:%d:%d CROP:%d:%d SPEED:%s", static_cast<int>(input.cursorX),
                static_cast<int>(input.cursorY), cropX, cropY, input.fast ? "NEW" : "BASE");
            screenText(top.renderer, line, 2, 20);
            screenText(top.renderer, "PAD:CURSOR DPAD:PAN A/B:CLICK Y:SD X:SPEED", 2, 29);
            screenText(top.renderer, "SELECT:STATUS START:EXIT", 2, 38);
        }
        if (automated && totalFrames == 30) {
            automatedPass &= saveFrame(top, "top.bmp", log);
            automatedPass &= saveFrame(bottom, "bottom.bmp", log);
        }
        SDL_RenderPresent(top.renderer);
        SDL_RenderPresent(bottom.renderer);
        const Uint64 presented = SDL_GetPerformanceCounter();
        convertTotal += 1000.0 * static_cast<double>(converted - begin) / frequency;
        presentTotal += 1000.0 * static_cast<double>(presented - converted) / frequency;
        ++frames;
        if (automated && ++totalFrames == 90) {
            log.write("SELFTEST: %s", automatedPass ? "PASS" : "FAIL");
            input.running = false;
        }
        const Uint32 now = SDL_GetTicks();
        if (now - lastReport >= 2000) {
            displayedFPS = frames * 1000.0 / (now - lastReport);
            displayedConvert = convertTotal / frames;
            displayedPresent = presentTotal / frames;
            log.write("PERF fps=%.2f convert_crop_ms=%.3f upload_draw_present_ms=%.3f speedup=%d status=%d",
                displayedFPS, displayedConvert, displayedPresent, input.fast, input.showStatus);
            memorySnapshot(log, "periodic");
            frames = 0; convertTotal = 0; presentTotal = 0; lastReport = now;
        }
        gspWaitForVBlank();
        SDL_Delay(1);
    }
    if (controller) SDL_GameControllerClose(controller);
    log.write("END normal exit");
    return 0;
}
} // namespace

int main(int, char**) {
    // SDL owns gfx/hid initialization; do not also call gfxInitDefault/gfxExit.
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_GAMECONTROLLER | SDL_INIT_TIMER) < 0) {
        Log log;
        log.write("FAIL SDL_Init: %s", SDL_GetError());
        return 1;
    }
    int result = 1;
    {
        Log log;
        try { result = runProbe(log); }
        catch (const std::exception& error) { log.write("FAIL exception: %s", error.what()); }
    }
    SDL_Quit();
    return result;
}
