# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils gnome2 meson

DESCRIPTION="small GObject library giving you simple access to game controllers"
HOMEPAGE="https://gitlab.gnome.org/aplazas/libmanette"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux"

IUSE=""

RDEPEND="
	>=dev-libs/glib-2.50:2
	dev-libs/libgudev
	>=dev-libs/libevdev-1.4.5
"
DEPEND="${RDEPEND}"
