# C++ Development Guide

> Open with `<leader>Dc` from any C/C++ buffer · `q` or `<Esc>` to close

---

## Typical Project Workflow

### 1. Create the project structure

```
myproject/
├── CMakeLists.txt
├── src/
│   └── main.cpp
└── include/
    └── myproject/
        └── foo.h
```

### 2. Minimal CMakeLists.txt template

```cmake
cmake_minimum_required(VERSION 3.20)
project(myproject VERSION 0.1.0 LANGUAGES CXX)

# Enforce modern C++, disable GNU extensions (for portability)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)   # required by clangd

add_executable(myproject src/main.cpp)

target_include_directories(myproject PRIVATE include)

# Strict warnings — treat as errors in CI, warnings locally
target_compile_options(myproject PRIVATE
  -Wall -Wextra -Wpedantic
  # Uncomment for CI: -Werror
)
```

### 3. Configure and build (in Neovim)

| Key | Action |
|-----|--------|
| `<leader>mx` | Choose build type (Debug / Release / RelWithDebInfo) |
| `<leader>mt` | Select which target to build/run |
| `<leader>mg` | Configure project (runs cmake + generates compile_commands.json) |
| `<leader>mb` | Build selected target |
| `<leader>mr` | Run selected target |
| `<leader>mi` | Show project info |

> **First time**: pick `Debug` with `<leader>mx`, then `<leader>mg` to configure.  
> cmake-tools creates `build/Debug/` with a `compile_commands.json` symlinked to the project root — this is what clangd reads for accurate diagnostics.

### 4. Build from the terminal (alternative)

```bash
# Configure (Debug)
cmake -B build/Debug -G Ninja -DCMAKE_BUILD_TYPE=Debug

# Build
cmake --build build/Debug -j$(nproc)

# Run
./build/Debug/myproject
```

---

## LSP Features (clangd)

clangd runs automatically in C/C++ buffers. Key features:

| Key | Action |
|-----|--------|
| `K` | Hover docs / signature (clangd — good for your own code) |
| `<leader>K` | cppman: full cppreference docs for word under cursor |
| `gd` | Go to definition |
| `gr` | Find all references |
| `<leader>ca` | Code action (includes clang-tidy fixes) |
| `<leader>cf` | Format with clang-format |
| `<leader>uh` | Toggle inlay hints (parameter names, deduced types) |
| `<leader>cd` | Inline diagnostic popup |
| `[d` / `]d` | Previous / next diagnostic |

### clang-tidy diagnostics

clangd runs clang-tidy checks inline as you type. The active check categories are:

- **`bugprone-*`** — common sources of bugs
- **`modernize-*`** — teaches idiomatic modern C++ (prefer `auto`, range-for, etc.)
- **`performance-*`** — unnecessary copies, inefficient patterns
- **`readability-*`** — code clarity
- **`cppcoreguidelines-*`** — C++ Core Guidelines

Use `<leader>ca` on a diagnostic to apply an automated fix.

Config lives at `~/.config/clangd/config.yaml`.

---

## Debugging (DAP + codelldb)

> Always build with `Debug` build type before debugging (`<leader>mx` → Debug, `<leader>mb`).

| Key | Action |
|-----|--------|
| `<leader>md` | Launch debugger via cmake-tools (auto-selects target) |
| `<leader>db` | Toggle breakpoint on current line |
| `<leader>dc` | Continue / start |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>du` | Toggle DAP UI (variables, call stack, watches) |
| `<leader>dB` | Conditional breakpoint (enter expression, e.g. `i == 5`) |

> **Tip**: `<leader>md` is the easiest entry point — cmake-tools sets up the codelldb adapter and picks the right binary automatically.

---

## Compiler Explorer (Godbolt)

See the assembly your compiler produces for a piece of code:

1. Select C++ code in visual mode (or place cursor in a function)
2. `<leader>ce` — send to Godbolt, opens result in a split
3. `<leader>cE` — live mode: updates assembly as you edit

This is excellent for learning what the compiler actually does with your abstractions.

---

## Build Types

| Type | Flags | Use for |
|------|-------|---------|
| `Debug` | `-O0 -g` | Debugging (full symbols, no optimization) |
| `Release` | `-O3 -DNDEBUG` | Benchmarking / shipping |
| `RelWithDebInfo` | `-O2 -g -DNDEBUG` | Profiling (symbols + optimized) |

Switch with `<leader>mx`, then regenerate with `<leader>mg`.

---

## Sanitizers (catch bugs at runtime)

Add a custom build type in CMakeLists.txt for AddressSanitizer:

```cmake
# At the top of CMakeLists.txt, after project()
set(CMAKE_CONFIGURATION_TYPES "Debug;Release;RelWithDebInfo;Asan" CACHE STRING "" FORCE)

if(CMAKE_BUILD_TYPE STREQUAL "Asan")
  add_compile_options(-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer)
  add_link_options(-fsanitize=address,undefined)
endif()
```

Then configure with:
```bash
cmake -B build/Asan -G Ninja -DCMAKE_BUILD_TYPE=Asan
cmake --build build/Asan -j$(nproc)
./build/Asan/myproject
```

ASan will report memory errors (buffer overflow, use-after-free) with exact stack traces.

---

## Tips

- **Ninja** is used as the generator (faster than Make for incremental builds)
- **`compile_commands.json`** is symlinked to the project root automatically — clangd picks it up immediately after `<leader>mg`
- **`-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`** must be in CMakeLists.txt for clangd to get accurate per-file flags; the template above includes it
- **Inlay hints** (`<leader>uh`) show parameter names and deduced `auto` types inline — very useful while learning
- The **`plugins/cpp.lua`** file in the repo root is unused; the active config is `lua/plugins/cpp.lua`

---

## CMake Commands Reference

| Command | Action |
|---------|--------|
| `:CMakeGenerate` | Configure (cmake ..) |
| `:CMakeBuild` | Build selected target |
| `:CMakeRun` | Run selected target |
| `:CMakeDebug` | Debug with DAP |
| `:CMakeClean` | Clean build artifacts |
| `:CMakeSelectBuildType` | Debug / Release / RelWithDebInfo |
| `:CMakeSelectTarget` | Choose target |
| `:CMakeSelectBuildDir` | Choose build directory |
| `:CMakeInfo` | Show project info |
