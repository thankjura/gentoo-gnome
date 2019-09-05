# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.32"

inherit gnome2 vala meson

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/action/show/Apps/Terminal/VTE"

LICENSE="LGPL-2+"
SLOT="2.91"
IUSE="+crypt debug glade +introspection vala doc"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
REQUIRED_USE="vala? ( introspection )"

SRC_URI="${SRC_URI}"

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=dev-libs/libpcre2-10.21
	>=x11-libs/gtk+-3.16:3[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses:0=
	sys-libs/zlib
	dev-libs/fribidi

	crypt?  ( >=net-libs/gnutls-3.2.7:0= )
	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig

	vala? ( $(vala_depend) )
"
RDEPEND="${RDEPEND}
	!x11-libs/vte:2.90[glade]
"

src_prepare() {
	use vala && vala_src_prepare
	eapply_user
	meson_src_prepare
}

src_configure() {
	local emesonargs=(
		-Ddebugg=$(usex debug true false)
		-Ddocs=$(usex doc true false)
		-Dgir=$(usex introspection true false)
		-Dfribidi=true
		-Dgnutls=true
		-Dgtk3=true
		-Dgtk4=false
		-Diconv=true
		-Dvapi=$(usex vala true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	mv "${ED}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}
