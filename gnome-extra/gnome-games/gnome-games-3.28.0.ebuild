# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2

DESCRIPTION="Games is a game manager application for GNOME."
HOMEPAGE="https://wiki.gnome.org/Design/Playground/Games"

LICENSE="GPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	x11-libs/gtk+:3
	net-libs/libsoup
	app-misc/tracker
	>=x11-libs/retro-gtk-0.10
	media-libs/grilo:0.3[vala]
	virtual/pkgconfig
"

src_prepare() {
	./autogen.sh
	default
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
