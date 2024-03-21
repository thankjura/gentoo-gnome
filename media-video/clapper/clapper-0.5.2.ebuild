# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="A GNOME media player built using GJS with GTK4"
HOMEPAGE="https://rafostar.github.io/clapper"
SRC_URI="https://github.com/Rafostar/clapper/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	gui-libs/gtk
	>=media-libs/gstreamer-1.18
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local emesonargs=(
		-Dplayer=true
		-Dlib=true
		-Ddevel-checks=false
		-Ddeprecated-glib-api=false
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
