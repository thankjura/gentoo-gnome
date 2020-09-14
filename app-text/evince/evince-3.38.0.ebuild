# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd gnome.org gnome2-utils meson

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Evince"

LICENSE="GPL-2+ CC-BY-SA-3.0"
# subslot = evd3.(suffix of libevdocument3)-evv3.(suffix of libevview3)
SLOT="0/evd3.4-evv3.3"
IUSE="djvu dvi gstreamer gnome gnome-keyring +introspection nautilus nsplugin postscript spell t1lib tiff xps"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"

# atk used in libview
# bundles unarr
COMMON_DEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.38.0:2
	>=dev-libs/libxml2-2.5:2
	sys-libs/zlib:=
	>=x11-libs/gdk-pixbuf-2.36.5:2
	>=x11-libs/gtk+-3.22.0:3[introspection?]
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/cairo-1.10:=
	>=app-text/poppler-0.76.0[cairo]
	>=app-arch/libarchive-3.2.0
	djvu? ( >=app-text/djvu-3.5.22:= )
	dvi? (
		virtual/tex-base
		dev-libs/kpathsea:=
		t1lib? ( >=media-libs/t1lib-5:= ) )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0 )
	gnome? ( gnome-base/gnome-desktop:3= )
	gnome-keyring? ( >=app-crypt/libsecret-0.5 )
	introspection? ( >=dev-libs/gobject-introspection-1:= )
	nautilus? ( >=gnome-base/nautilus-3.28.0 )
	postscript? ( >=app-text/libspectre-0.2:= )
	spell? ( >=app-text/gspell-1.6.0:= )
	tiff? ( >=media-libs/tiff-3.6:0= )
	xps? ( >=app-text/libgxps-0.2.1:= )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs
	gnome-base/librsvg
	|| (
		>=x11-themes/adwaita-icon-theme-2.17.1
		>=x11-themes/hicolor-icon-theme-0.10 )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.13
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	app-text/yelp-tools
"

src_configure() {
	local emesonargs=(
		-Dplatform="gnome"
		-Dviewer=true
		-Dpreviewer=true
		-Dthumbnailer=true
		$(meson_use nsplugin browser_plugin)
		$(meson_use nautilus)
		-Dcomics=enabled
		$(meson_feature djvu)
		$(meson_feature dvi)
		-Dpdf=enabled
		$(meson_feature postscript ps)
		$(meson_feature tiff)
		$(meson_feature xps)
		-Dgtk_doc=false
		-Duser_doc=false
		$(meson_use introspection)
		-Ddbus=true
		$(meson_feature gnome-keyring keyring)
		-Dgtk_unix_print=enabled
		-Dthumbnail_cache=enabled
		$(meson_feature gstreamer multimedia)
		$(meson_feature spell gspell)
		$(meson_feature t1lib)
		-Dbrowser_plugin_dir="${EPREFIX}"/usr/$(get_libdir)/nsbrowser/plugins
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
	)
	meson_src_configure
}
