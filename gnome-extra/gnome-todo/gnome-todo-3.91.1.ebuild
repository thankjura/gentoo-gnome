# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 meson

DESCRIPTION="Personal task manager"
HOMEPAGE="https://wiki.gnome.org/Apps/Todo"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/glib-2.43.4:2
	>=x11-libs/gtk+-3.22.0:3
	>=net-libs/gnome-online-accounts-3.28.0
	>=gnome-extra/evolution-data-server-3.28.0:=[gtk]
	>=dev-libs/libical-0.43
	>=dev-libs/libpeas-1.22
	>=dev-libs/gobject-introspection-1.42:=
"
DEPEND="${RDEPEND}
	>=dev-util/meson-0.40.0
	doc? ( dev-util/gtk-doc )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	meson_src_configure \
		-Dbackground-plugin=true \
		-Ddark-theme-plugin=true \
		-Dscheduled-panel-plugin=true \
		-Dscore-plugin=true \
		-Dtoday-panel-plugin=true \
		-Dunscheduled-panel-plugin=true \
		-Dtodo-txt-plugin=true \
		-Dtodoist-plugin=true \
		$(meson_use doc enable-gtk-doc) \
		-Dintrospection=true
}
