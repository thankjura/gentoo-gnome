# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Small app for managing GNOME Shell extensions"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-extensions-app"

LICENSE="GPL-2+"
SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

#dev-libs/libshew
DEPEND="
	dev-libs/gjs
	dev-libs/appstream
	dev-util/desktop-file-utils
"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
