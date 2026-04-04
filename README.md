# Arch Configs

## Configs & installation scripts for Arch Linux

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
sh -c "$(curl -fsSL https://raw.githubusercontent.com/aruyu/arch-configs/master/tools/install_openbox.sh)"
```

*Additianally, if you need Openbox configs, check out my personal Openbox dotfiles.*

> https://github.com/aruyu/openbox-dotfiles

</details>

<details>
<summary><b>For Wayland (GDM + SwayFx Compositor)</b></summary>

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/aruyu/arch-configs/master/tools/install_swayfx.sh)"
```

*If you need Sway configs, check out my personal Sway dotfiles.*

> https://github.com/aruyu/sway-dotfiles

*Alternatively, check out my personal Hyprland dotfiles.*

> https://github.com/aruyu/hyprland-dotfiles

</details>

## Issues

> [!CAUTION]
> There is a known issue where interface errors/buggy occur when using 'iio-sensor-proxy' with the Surface Pro series.
> **The hanging on the *'Power tab'*** in *gnome-control-center (Settings)* can be fixed by using below commands.

```bash
sudo systemctl stop --now iio-sensor-proxy
sudo downgrade iio-sensor-proxy #downgrade to 3.5.2 or under
sudo systemctl restart iio-sensor-proxy
```
