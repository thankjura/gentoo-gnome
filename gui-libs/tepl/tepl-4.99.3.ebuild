# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 virtualx meson

DESCRIPTION="GtkSourceView-based text editors and IDE helper library"
HOMEPAGE="https://wiki.gnome.org/Projects/Tepl"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~sparc ~x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.52:2
	>=x11-libs/gtk+-3.22:3[introspection?]
	>=x11-libs/gtksourceview-4.0:4[introspection?]
	>=gui-libs/amtk-5.0:5[introspection?]
	>=dev-libs/libxml2-2.5:2
	app-i18n/uchardet
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.6
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.25
	virtual/pkgconfig
"

RESTRICT="!test? ( test )"

src_prepare() {
	gnome2_src_prepare
}

src_configure() {
	# valgrind checks not ran by default and require suppression files not in locations where they'd be installed by other packages
	local emesonargs=(
		-Dgtk_doc=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}

src_test() {
	virtx emake check
}
