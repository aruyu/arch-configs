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

## Scripts to install Desktop Manager and Window Manager

<details>
<summary><b>For Xorg, X11 (SDDM + Openbox WM)</b></summary>

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/aruyu/arch-configs/master/tools/install_xorg.sh)"
```

*Additianally, if you need Openbox configs, check out my personal Openbox dotfiles.*

> https://github.com/aruyu/openbox-dotfiles

</details>

<details>
<summary><b>For Wayland (GDM + Sway compositor)</b></summary>

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/aruyu/arch-configs/master/tools/install_wayland.sh)"
```

*If you need Sway configs, check out my personal Sway dotfiles.*

> https://github.com/aruyu/sway-dotfiles

*Alternatively, check out my personal Hyprland dotfiles.*

> https://github.com/aruyu/hyprland-dotfiles

</details>
