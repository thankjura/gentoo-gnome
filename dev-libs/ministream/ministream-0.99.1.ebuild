# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson

DESCRIPTION="Small appstream manifest parser"
HOMEPAGE="https://gitlab.gnome.org/GNOME/ministream.git"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.80.0:2
	introspection? ( >=dev-libs/gobject-introspection-1.83.2:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		$(meson_feature introspection)
		-Das-compare=disabled
		-Dtests=false
	)

	meson_src_configure
}
