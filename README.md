# Arch Configs

## Installation scripts for Arch linux

* Default systems

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/aruyu/arch-configs/master/tools/install_system.sh)"
```

* Surface series

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/aruyu/arch-configs/master/tools/install_surface.sh)"
```

## Installation scripts for Desktop Manager and Window Manager

<details>
<summary><b>For Xorg, X11 (SDDM + Openbox WM)</b></summary>

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/aruyu/arch-configs/master/tools/install_xorg.sh)"
```

*Additianally, if you need Openbox configs, check out my personal Openbox dotfiles.*

> https://github.com/aruyu/openbox-dotfiles

</details>

<details>
<summary><b>For Wayland (GDM + Hyprland WM)</b></summary>

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/aruyu/arch-configs/master/tools/install_wayland.sh)"
```

*Additianally, if you need Hyprland configs, check out my personal Hyprland dotfiles.*

> https://github.com/aruyu/hyprland-dotfiles

</details>
