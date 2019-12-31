# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_5,3_6,3_7,3_8} )

inherit gnome2 meson multilib python-single-r1 virtualx

DESCRIPTION="A GObject plugins library"
HOMEPAGE="https://developer.gnome.org/libpeas/stable/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux"

IUSE="+gtk glade lua luajit +python gtk-doc"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/glib-2.38:2
	>=dev-libs/gobject-introspection-1.39:=
	glade? ( >=dev-util/glade-3.9.1:3.10 )
	gtk? ( >=x11-libs/gtk+-3:3[introspection] )
	lua? (
		>=dev-lua/lgi-0.9.0
		luajit? ( >=dev-lang/luajit-2:2 )
		!luajit? ( =dev-lang/lua-5.1*:0 ) )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.2:3[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.40
	virtual/pkgconfig

	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"
pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Dlua51=$(usex lua true false)
		-Dpython2=false
		-Dpython3=$(usex python true false)
		-Dintrospection=true
		-Dvapi=true
		-Dwidgetry=true
		-Dglade_catalog=$(usex glade true false)
		-Ddemos=false
		-Dgtk_doc=$(usex gtk-doc true false)
	)

	meson_src_configure
}

src_test() {
	# This looks fixed since 1.18.0:
	#
	# FIXME: Tests fail because of some bug involving Xvfb and Gtk.IconTheme
	# DO NOT REPORT UPSTREAM, this is not a libpeas bug.
	# To reproduce:
	# >>> from gi.repository import Gtk
	# >>> Gtk.IconTheme.get_default().has_icon("gtk-about")
	# This should return True, it returns False for Xvfb
	virtx emake check
}
