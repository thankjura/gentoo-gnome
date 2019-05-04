# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 meson

DESCRIPTION="A nice way to view information about use of system resources"
HOMEPAGE="https://wiki.gnome.org/Apps/Usage"

LICENSE="GPL-3"
SLOT="0"
IUSE="+caps"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-lang/vala
	dev-libs/glib
	x11-libs/gtk+:3
	>=dev-util/meson-0.36
	>=gnome-base/libgtop-2.34.2
	caps? ( sys-libs/libcap )
"

src_install() {
	meson_src_install
	if use caps; then
		setcap "cap_net_raw,cap_net_admin=eip" ${ED}/usr/bin/gnome-usage
	fi
	gnome2_src_install
}
