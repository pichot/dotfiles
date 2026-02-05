# Dotfiles Repository

Personal dotfiles managed with chezmoi, targeting multiple machines.

## Computers

| Machine | OS | Notes |
|---------|-----|-------|
| MacBook Pro | macOS (darwin) | Primary dev machine, M1 Pro |
| Desktop | CachyOS (linux) | Arch-based Linux |

## Chezmoi

Template variables available in `.tmpl` files:

- `.os` - `"macos"` or `"linux"`
- `.plugin_dir` - zsh plugin directory (`/opt/homebrew/share` on macOS, `/usr/share/zsh/plugins` on Linux)

Common patterns:
```
{{- if eq .os "macos" }}
# macOS-specific
{{- else if eq .os "linux" }}
# Linux-specific
{{- end }}
```

## Shell

- **Shell**: zsh
- **Prompt**: Starship with Gruvbox Dark theme
- **Plugins**: zsh-autosuggestions, zsh-syntax-highlighting, zsh-history-substring-search
- **Tools**: fzf, zoxide

## Terminal

- **macOS**: Ghostty
- **Linux**: Ghostty or system default

## Key Files

- `dot_zshrc.tmpl` - Main shell config
- `dot_config/starship.toml` - Prompt configuration
- `dot_config/fastfetch/config.jsonc.tmpl` - System info display (runs on terminal startup)
- `dot_config/ghostty/config` - Terminal settings

## Notes

- CachyOS runs fastfetch by default, so it's only added to zshrc for macOS
- Use `chezmoi diff` to preview changes, `chezmoi apply` to apply
