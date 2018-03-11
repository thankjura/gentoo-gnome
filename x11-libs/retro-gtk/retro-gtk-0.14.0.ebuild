# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2

DESCRIPTION="Toolkit to write Gtk+ 3 based libretro frontends"
HOMEPAGE="https://git.gnome.org/browse/retro-gtk/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-util/intltool
	dev-libs/glib
	media-sound/pulseaudio
	virtual/pkgconfig
"

src_prepare() {
	./autogen.sh
	default
}
