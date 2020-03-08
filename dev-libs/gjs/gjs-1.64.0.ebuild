# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils pax-utils flag-o-matic meson

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="+cairo elibc_glibc examples gtk test"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=dev-libs/gobject-introspection-1.61.2:=
	>=dev-util/sysprof-3.33.3

	sys-libs/readline:0
	dev-lang/spidermonkey:68
	virtual/libffi
	cairo? ( x11-libs/cairo[X] )
	gtk? ( x11-libs/gtk+:3 )
"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

src_configure() {
	local emesonargs=(
		$(meson_feature cairo)
		-Dreadline=enabled
		$(meson_feature elibc_glibc profiler)
		$(meson_use test installed_tests)
		-Ddtrace=false
		-Dsystemtap=false
		-Dbsymbolic_functions=true
		-Dspidermonkey_rtti=false
		-Dskip_dbus_tests=$(usex test false true)
		-Dskip_gtk_tests=$(usex test false true)
		-Dverbose_logs=false
	)

	meson_src_configure

	#append-cxxflags -std=c++14
}

src_install() {
	# installation sometimes fails in parallel, bug #???
	meson_src_install -j1

	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins "${S}"/examples/*
	fi

	# Required for gjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/gjs-console"
}
