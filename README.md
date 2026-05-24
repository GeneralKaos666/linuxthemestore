# Linux Theme Store
**Browse, Search Categorically and manage installed themes for your Gnome/Gtk based desktop**
-  A modern desktop app for discovering, downoading Linux themes, icoirectly from Pling & Opendesktop  
- No browser required.
- Just browse, click, and beautify your desktop!

## Releases

### 1.0.5-1 (2026-05-22)
**Added support for Termux
- Both build and install inside Termux

### 1.0.5 (2025-06-18)
**Added ability to apply themes for:**
- Converted Preview Pics in Detailed Screen to Caraousel
- Bug Fixed where themes were being set randomly in Installed page

### 1.0.4 (2025-06-17)
**Added ability to apply themes for:**
- Gtk4 Themes
- Icon Themes
- Cursor Themes

### 1.0.3 (2025-06-11)
**Features:**
- Search is now separate and includes all categories
- Added Wallpapers
- Added autoscrolling when bottom of the category page is reached

### 1.0.2 (2025-06-06)
**Features:**
- Added Search functionality
- Redundant Code Cleanup


### 1.0.1 (2025-06-04)
**Performance improvements:**
- Better Image Quality for verifying themes
- Quicker Pagination and page loading
- UI Design improvements
- Redundant Code Cleanup


### 1.0.0 (2025-05-28)
**Initial Release**

---
Here are some screenshots & video preview

[![Thumbnail](https://raw.githubusercontent.com/debasish-patra-1987/linuxthemestore/ed61ee4cff31c6a936413416b94068bbf767c6fe/screenshots/1.png)](https://raw.githubusercontent.com/debasish-patra-1987/linuxthemestore/ed61ee4cff31c6a936413416b94068bbf767c6fe/screenshots/1.png)

[![Thumbnail](https://raw.githubusercontent.com/debasish-patra-1987/linuxthemestore/ed61ee4cff31c6a936413416b94068bbf767c6fe/screenshots/2.png)](https://raw.githubusercontent.com/debasish-patra-1987/linuxthemestore/ed61ee4cff31c6a936413416b94068bbf767c6fe/screenshots/1.png)

[![Thumbnail](https://raw.githubusercontent.com/debasish-patra-1987/linuxthemestore/ed61ee4cff31c6a936413416b94068bbf767c6fe/screenshots/3.png)](https://raw.githubusercontent.com/debasish-patra-1987/linuxthemestore/ed61ee4cff31c6a936413416b94068bbf767c6fe/screenshots/3.png)

[![Thumbnail](https://raw.githubusercontent.com/debasish-patra-1987/linuxthemestore/ed61ee4cff31c6a936413416b94068bbf767c6fe/screenshots/4.png)](https://raw.githubusercontent.com/debasish-patra-1987/linuxthemestore/ed61ee4cff31c6a936413416b94068bbf767c6fe/screenshots/4.png)


[![alt text](https://i.ibb.co/V0TK6Sgg/5.png)](https://github.com/debasish-patra-1987/linuxthemestore/raw/refs/heads/main/screenshots/screencastsample.mp4)

## Installation

### Build on Termux with Meson
```
pkg install x11-repo
pkg install rust clang pkg-config gtk4 libadwaita glib tar unzip p7zip dbus gsettings-desktop-schemas python
pip3 install --user meson

git clone https://github.com/GeneralKaos666/linuxthemestore.git
cd linuxthemestore
meson setup build --prefix=$PREFIX
meson compile -C build
meson install -C build
```

Run it with Termux:X11:
```
export DISPLAY=:0
export XDG_RUNTIME_DIR=$TMPDIR
export GDK_BACKEND=x11
dbus-run-session linuxthemestore
```

On Termux, the Meson/Cargo build defaults to `cargo build -j1` to avoid the `Text file busy` error seen with parallel Cargo jobs.

### Build an aarch64 Termux `.deb`
```
pkg install x11-repo
pkg install rust clang pkg-config gtk4 libadwaita glib tar unzip p7zip dbus gsettings-desktop-schemas dpkg python
pip3 install --user meson

git clone https://github.com/debasish-patra-1987/linuxthemestore.git
cd linuxthemestore
chmod +x packaging/termux/build-deb.sh
./packaging/termux/build-deb.sh
```

The package is written to `dist/` as:
```
dist/linuxthemestore_<version>-1_aarch64.deb
```

Manual runs of `.github/workflows/build-termux-deb.yml` can also publish to GitHub Releases now: start the workflow with a `release_tag`, and it will create that release on the workflow commit if it does not already exist, then upload the generated `.deb` and `.buildinfo` assets.

Useful overrides:
```
DEB_MAINTAINER="Your Name <you@example.com>" ./packaging/termux/build-deb.sh
PACKAGE_VERSION=1.0.5-1 ./packaging/termux/build-deb.sh
OUT_DIR=$PWD/out ./packaging/termux/build-deb.sh
```

Install it with:
```
dpkg -i dist/linuxthemestore_<version>-1_aarch64.deb
```

The packaged launcher defaults to `DISPLAY=:0`, `GDK_BACKEND=x11`, and starts `dbus-run-session` automatically when needed, but you still need a running Termux:X11 session.

Manual Uninstallation via root
```
rm /usr/bin/linuxthemestore
rm /usr/share/metainfo/io.github.debasish_patra_1987.linuxthemestore.metainfo.xml
rm /usr/share/icons/hicolor/scalable/apps/io.github.debasish_patra_1987.linuxthemestore.svg
rm /usr/share/applications/io.github.debasish_patra_1987.linuxthemestore.desktop
```
## License
GPL3+

If you are happy with my work, please consider donating 

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-yellow?logo=buy-me-a-coffee&logoColor=white&style=for-the-badge)](https://coff.ee/patradebasish1987)
