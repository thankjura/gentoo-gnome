# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 meson

DESCRIPTION="GNOME power management service"
HOMEPAGE="https://projects.gnome.org/gnome-power-manager/"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

COMMON_DEPEND="
	>=dev-libs/glib-2.45.8:2
	>=x11-libs/gtk+-3.3.8:3
	>=x11-libs/cairo-1
	>=sys-power/upower-0.99:=
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.7
	x11-proto/randrproto
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

src_configure() {
	local emesonargs=(
		-D enable-tests=$(usex test true false)
	)

	meson_src_configure
}
