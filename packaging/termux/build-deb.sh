#!/bin/sh

set -eu

script_dir=$(
    CDPATH= cd -- "$(dirname -- "$0")"
    pwd
)
repo_root=$(
    CDPATH= cd -- "$script_dir/../.."
    pwd
)

prefix_dir="${PREFIX:-/data/data/com.termux/files/usr}"
meson_bin="${MESON:-}"
if [ -z "$meson_bin" ]; then
    if [ -x "$HOME/.local/bin/meson" ]; then
        meson_bin="$HOME/.local/bin/meson"
    else
        meson_bin="meson"
    fi
fi

package_name="${PACKAGE_NAME:-linuxthemestore}"
package_arch="${ARCH:-$(dpkg --print-architecture)}"
base_version="${VERSION:-$(sed -n 's/^version = "\(.*\)"$/\1/p' "$repo_root/Cargo.toml" | head -n 1)}"
deb_revision="${DEB_REVISION:-1}"
package_version="${PACKAGE_VERSION:-${base_version}-${deb_revision}}"
build_dir="${BUILD_DIR:-$repo_root/build-deb-termux}"
stage_dir="${STAGE_DIR:-$repo_root/stage-deb-termux}"
out_dir="${OUT_DIR:-$repo_root/dist}"
buildtype="${MESON_BUILDTYPE:-release}"
homepage="${HOMEPAGE:-https://github.com/GeneralKaos666/linuxthemestore}"
description="${DESCRIPTION:-Browse, search, and manage Linux desktop themes from Termux}"
depends="${DEPENDS:-dbus, glib, gsettings-desktop-schemas, gtk4, libadwaita, p7zip, tar, unzip}"
keep_stage="${KEEP_STAGE:-0}"

maintainer_name="${DEB_MAINTAINER_NAME:-$(git -C "$repo_root" config --get user.name || true)}"
maintainer_email="${DEB_MAINTAINER_EMAIL:-$(git -C "$repo_root" config --get user.email || true)}"
if [ -z "$maintainer_name" ]; then
    maintainer_name="Unknown Maintainer"
fi
if [ -z "$maintainer_email" ]; then
    maintainer_email="unknown@localhost"
fi
maintainer="${DEB_MAINTAINER:-$maintainer_name <$maintainer_email>}"

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf 'Missing required command: %s\n' "$1" >&2
        exit 1
    fi
}

require_cmd cargo
require_cmd dpkg
require_cmd dpkg-deb
require_cmd install

if ! command -v "$meson_bin" >/dev/null 2>&1; then
    printf 'Missing Meson executable: %s\n' "$meson_bin" >&2
    exit 1
fi

rm -rf "$build_dir" "$stage_dir"
mkdir -p "$out_dir"

"$meson_bin" setup "$build_dir" --buildtype="$buildtype" --prefix="$prefix_dir"
"$meson_bin" compile -C "$build_dir"
"$meson_bin" install -C "$build_dir" --destdir "$stage_dir"

package_root="$stage_dir$prefix_dir"
binary_path="$package_root/bin/$package_name"
libexec_dir="$package_root/libexec"
wrapper_path="$package_root/bin/$package_name"

mkdir -p "$libexec_dir"
chmod 0755 "$libexec_dir"
mv "$binary_path" "$libexec_dir/$package_name-bin"

cat >"$wrapper_path" <<EOF
#!$prefix_dir/bin/sh
set -eu

PREFIX_DIR="$prefix_dir"
export DISPLAY="\${DISPLAY:-:0}"
export XDG_RUNTIME_DIR="\${XDG_RUNTIME_DIR:-\${TMPDIR:-\$PREFIX_DIR/tmp}}"
export GDK_BACKEND="\${GDK_BACKEND:-x11}"

real_bin="\$PREFIX_DIR/libexec/$package_name-bin"

if [ -n "\${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
    exec "\$real_bin" "\$@"
fi

exec "\$PREFIX_DIR/bin/dbus-run-session" "\$real_bin" "\$@"
EOF
chmod 0755 "$wrapper_path"

debian_dir="$stage_dir/DEBIAN"
mkdir -p "$debian_dir"
chmod 0755 "$debian_dir"

installed_size=$(du -sk "$package_root" | cut -f 1)

cat >"$debian_dir/control" <<EOF
Package: $package_name
Version: $package_version
Architecture: $package_arch
Maintainer: $maintainer
Installed-Size: $installed_size
Depends: $depends
Section: x11
Priority: optional
Homepage: $homepage
Description: $description
 A GTK4/libadwaita application for browsing, downloading, and installing Linux
 desktop themes from Termux. This package installs a Termux-friendly launcher
 that defaults to the X11 backend and starts a D-Bus session when needed.
EOF
chmod 0644 "$debian_dir/control"

cat >"$debian_dir/postinst" <<EOF
#!$prefix_dir/bin/sh
set -eu

if [ -x "$prefix_dir/bin/gtk4-update-icon-cache" ]; then
    "$prefix_dir/bin/gtk4-update-icon-cache" -q -t -f "$prefix_dir/share/icons/hicolor" || true
fi

if [ -x "$prefix_dir/bin/update-desktop-database" ]; then
    "$prefix_dir/bin/update-desktop-database" -q "$prefix_dir/share/applications" || true
fi
EOF
chmod 0755 "$debian_dir/postinst"

cat >"$debian_dir/postrm" <<EOF
#!$prefix_dir/bin/sh
set -eu

if [ -x "$prefix_dir/bin/gtk4-update-icon-cache" ]; then
    "$prefix_dir/bin/gtk4-update-icon-cache" -q -t -f "$prefix_dir/share/icons/hicolor" || true
fi

if [ -x "$prefix_dir/bin/update-desktop-database" ]; then
    "$prefix_dir/bin/update-desktop-database" -q "$prefix_dir/share/applications" || true
fi
EOF
chmod 0755 "$debian_dir/postrm"

output_path="$out_dir/${package_name}_${package_version}_${package_arch}.deb"
dpkg-deb --build "$stage_dir" "$output_path"

printf 'Built package: %s\n' "$output_path"

if [ "$keep_stage" != "1" ]; then
    rm -rf "$build_dir" "$stage_dir"
fi
