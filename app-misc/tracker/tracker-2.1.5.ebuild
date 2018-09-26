# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_6 )

inherit autotools bash-completion-r1 eutils gnome2 linux-info multilib python-any-r1 vala versionator virtualx

DESCRIPTION="A tagging metadata database, search tool and indexer"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/100"
IUSE="elibc_glibc gtk iptc kernel_linux +miner-fs networkmanager stemmer upower"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

RDEPEND="
	>dev-db/sqlite-3.8.4.2:=
	>=dev-libs/glib-2.44:2
	>=dev-libs/gobject-introspection-0.9.5:=
	>=dev-libs/icu-4.8.1.1:=
	>=media-libs/libpng-1.2:0=
	>=media-libs/libmediaart-1.9:2.0
	>=x11-libs/pango-1:=
	sys-apps/util-linux
	miner-fs? ( app-misc/tracker-miners[miner-fs] )
	elibc_glibc? ( >=sys-libs/glibc-2.12 )
	gtk? (
		>=dev-libs/libgee-0.3:0.8
		>=x11-libs/gtk+-3:3 )
	iptc? ( media-libs/libiptcdata )
	kernel_linux? ( >=sys-libs/libseccomp-2.0.0 )
	networkmanager? ( >=net-misc/networkmanager-0.8:= )
	stemmer? ( dev-libs/snowball-stemmer )
	upower? ( 
		sys-power/upower 
		app-misc/tracker-miners[upower]
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.8
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	gtk? ( >=dev-libs/libgee-0.3:0.8 )
	test? (
		>=dev-libs/dbus-glib-0.82-r1
		>=sys-apps/dbus-1.3.1[X] )
"

src_prepare() {
	eautoreconf # See bug #367975
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-introspection \
		--enable-tracker-fts \
		--with-unicode-support=libicu \
		--with-bash-completion-dir="$(get_bashcompdir)" \
		$(use_enable upower upower) \
		$(use_enable networkmanager network-manager) \
		$(use_enable stemmer libstemmer) \
		$(use_enable test functional-tests) \
		$(use_enable test unit-tests)
}
