# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="Compiler for the GObject type system"
HOMEPAGE="https://wiki.gnome.org/Projects/Vala"

LICENSE="LGPL-2.1"
SLOT="0.44"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-linux"
IUSE="test valadoc"

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=dev-libs/vala-common-${PV}
	valadoc? ( >=media-gfx/graphviz-2.16 )
"
DEPEND="${RDEPEND}
	!${CATEGORY}/${PN}:0
	dev-libs/libxslt
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	test? (
		dev-libs/dbus-glib
		>=dev-libs/glib-2.26:2
		dev-libs/gobject-introspection )
"

src_configure() {
	# weasyprint enables generation of PDF from HTML
	gnome2_src_configure \
		--disable-unversioned \
		$(use_enable valadoc) \
		VALAC=: \
		WEASYPRINT=:
}

src_install() {
	emake DESTDIR="${D}" install
	dosym /usr/bin/vala-"${SLOT}" /usr/bin/vala
	dosym /usr/bin/vala-gen-introspect-"${SLOT}" /usr/bin/vala-gen-introspect
	dosym /usr/bin/valac-"${SLOT}" /usr/bin/valac
	dosym /usr/bin/valadoc-"${SLOT}" /usr/bin/valadoc
	dosym /usr/bin/vapicheck-"${SLOT}" /usr/bin/vapicheck
	dosym /usr/bin/vapigen-"${SLOT}" /usr/bin/vapigen
}
