# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 multilib-minimal meson vala

DESCRIPTION="Experimental new features for GTK+ and GLib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libdazzle"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~sparc x86"

IUSE="gtk-doc +introspection vala"

RDEPEND="
	>=dev-libs/glib-2.56.0:2
	>=x11-libs/gtk+-3.24.0:3[introspection?]
	introspection? ( dev-libs/gobject-introspection:= )
"

DEPEND="${RDEPEND}
	$(vala_depend)
	dev-libs/libxml2:2
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

src_prepare() {
	default
	vala_src_prepare
}
