# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 meson

DESCRIPTION="An easy-to-use application that will help you to discover what to cook today"
HOMEPAGE="https://wiki.gnome.org/Apps/Recipes"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+spell +archive +sound"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-util/meson-0.36
	>=sys-devel/gettext-0.19.7
	spell? ( app-text/gspell )
	archive? ( app-arch/gnome-autoar )
	sound? ( media-libs/libcanberra )
	>=dev-libs/glib-2.42
	>=x11-libs/gtk+-3.22
"

src_prepare() {
	cd ${S}/subprojects
	rmdir libgd
	git clone git://git.gnome.org/libgd
	cd ${S}
	rm -rf build
	default
}
