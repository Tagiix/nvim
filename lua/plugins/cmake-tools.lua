return {
  "Civitasv/cmake-tools.nvim",
  opts = {
    cmake_generator = "Ninja",
    cmake_build_directory = "build/${variant:buildType}",
    cmake_regenerate_on_save = true,  -- re-run cmake when CMakeLists.txt is saved
    cmake_soft_link_compile_commands = true, -- symlink compile_commands.json to project root
    cmake_compile_commands_from_lsp = false,
  },
  keys = {
    { "<leader>mg", "<cmd>CMakeGenerate<cr>",         desc = "CMake: Generate" },
    { "<leader>mb", "<cmd>CMakeBuild<cr>",            desc = "CMake: Build" },
    { "<leader>mr", "<cmd>CMakeRun<cr>",              desc = "CMake: Run" },
    { "<leader>md", "<cmd>CMakeDebug<cr>",            desc = "CMake: Debug" },
    { "<leader>mc", "<cmd>CMakeClean<cr>",            desc = "CMake: Clean" },
    { "<leader>mt", "<cmd>CMakeSelectTarget<cr>",     desc = "CMake: Select Target" },
    { "<leader>mx", "<cmd>CMakeSelectBuildType<cr>",  desc = "CMake: Build Type" },
    { "<leader>mi", "<cmd>CMakeInfo<cr>",             desc = "CMake: Info" },
  },
}
