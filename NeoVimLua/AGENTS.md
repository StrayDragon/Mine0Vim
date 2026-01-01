# Repository Guidelines

## Project Structure & Module Organization
- `init.lua` is the entry point; it delegates to `lua/init.lua`.
- `lua/config/` holds core settings (`options.lua`, `keymaps.lua`, `lazy.lua`).
- `lua/plugins/` contains lazy.nvim plugin specs grouped by topic (e.g., `core.lua`, `lsp.lua`, `ui.lua`, `rust.lua`).
- `after/` hosts filetype or plugin overrides loaded after defaults.
- `keymap.csv` is a quick reference for keybindings.
- `.luacheckrc` defines lint globals and ignore rules.

## Build, Test, and Development Commands
- `nvim --clean -u ./init.lua` runs Neovim with only this configuration.
- `luacheck lua/` lints the Lua config using `.luacheckrc`.
- `pnpm install` installs the Node provider dependency (`neovim`).
- In Neovim: `:Lazy sync` installs/updates plugins, `:Lazy clean` removes unused ones.

## Coding Style & Naming Conventions
- Indent Lua with tabs to match existing files; keep tables vertically aligned.
- Keep module filenames descriptive and scoped to features (e.g., `lua/plugins/lsp.lua`).
- Place plugin-specific config near its spec to keep modules self-contained.

## Testing Guidelines
- No automated test suite is present; validate changes by running Neovim and exercising affected features.
- Run `luacheck lua/` before PRs to catch unused globals or syntax issues.
- For UI changes, verify the theme, keymaps, and statusline load without errors.

## Commit & Pull Request Guidelines
- Commit messages follow Conventional Commits: `type(scope): summary` (seen scopes include `neovimlua` and `rust`).
- PRs should include: a short description, rationale, and how to test (e.g., `nvim --clean -u ./init.lua` or `:Lazy sync`).
- Add screenshots for UI/theme updates and note any plugin additions or removals.

## Environment & Configuration Tips
- Python provider expects a local `.venv` under the config path; install `pynvim` there if needed.
- Node provider uses the `neovim` package listed in `package.json`.
