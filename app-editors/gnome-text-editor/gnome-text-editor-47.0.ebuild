# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="A simple text editor for the GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-text-editor"
S="${WORKDIR}/gnome-text-editor-${PV/_/.}"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"

IUSE="spell"

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-libs/glib-2.73.0:2
	>=gui-libs/gtk-4.12:4
	>=gui-libs/gtksourceview-5.10.0:5
	>=gui-libs/libadwaita-1.5_alpha:1
	app-text/editorconfig-core-c
	x11-libs/cairo
	spell? (
		>=app-text/enchant-2.2.0:2
		dev-libs/icu:=
	)
"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas
"
BDEPEND="
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.21
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature spell enchant)
		-Dbugreport_url="https://bugs.gentoo.org"
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
