TERMUX_PKG_HOMEPAGE=https://github.com/GeneralKaos666/linuxthemestore
TERMUX_PKG_DESCRIPTION="Browse, search, and manage Linux desktop themes from Termux"
TERMUX_PKG_LICENSE="GPL-3.0-only"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@MAINTAINER@"
TERMUX_PKG_VERSION="@VERSION@"
TERMUX_PKG_SRCURL="@SRCURL@"
TERMUX_PKG_SHA256="@SHA256@"
TERMUX_PKG_DEPENDS="gtk4, libadwaita"
TERMUX_PKG_BUILD_DEPENDS="clang, gtk4, libadwaita, pkg-config, rust"
TERMUX_PKG_AUTO_UPDATE=false

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make_install() {
	cargo install \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--locked \
		--path . \
		--force \
		--no-track \
		--target "$CARGO_TARGET_NAME" \
		--root "$TERMUX_PREFIX"

	install -Dm644 \
		assets/io.github.debasish_patra_1987.linuxthemestore.desktop \
		"$TERMUX_PREFIX/share/applications/io.github.debasish_patra_1987.linuxthemestore.desktop"
	install -Dm644 \
		assets/io.github.debasish_patra_1987.linuxthemestore.metainfo.xml \
		"$TERMUX_PREFIX/share/metainfo/io.github.debasish_patra_1987.linuxthemestore.metainfo.xml"
	install -Dm644 \
		assets/io.github.debasish_patra_1987.linuxthemestore.svg \
		"$TERMUX_PREFIX/share/icons/hicolor/scalable/apps/io.github.debasish_patra_1987.linuxthemestore.svg"
}
