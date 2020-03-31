# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7,8} )

inherit gnome2 python-single-r1 meson

DESCRIPTION="Music management for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Music"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=app-misc/tracker-1.11.1
	>=dev-python/pygobject-3.21.1:3[cairo]
	>=dev-libs/glib-2.28:2
	>=dev-libs/gobject-introspection-1.35.9:=
	>=media-libs/grilo-0.3.2:0.3[introspection]
	>=media-libs/libmediaart-1.9.1:2.0[introspection]
	>=x11-libs/gtk+-3.19.3:3[introspection]
"
# xdg-user-dirs-update needs to be there to create needed dirs
# https://bugzilla.gnome.org/show_bug.cgi?id=731613
RDEPEND="${COMMON_DEPEND}
	|| (
		app-misc/tracker-miners[gstreamer]
		app-misc/tracker-miners[ffmpeg]
	)
	x11-libs/libnotify[introspection]
	$(python_gen_cond_dep '
		>=dev-python/pygobject-3.21.1:3[${PYTHON_MULTI_USEDEP}]
		dev-python/dbus-python[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
	')
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	media-plugins/gst-plugins-meta:1.0
	>=media-plugins/grilo-plugins-0.3.10:0.3[tracker]
	x11-misc/xdg-user-dirs
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.26
	virtual/pkgconfig
"

pkg_setup() {
	python_setup
}

src_prepare() {
	sed -e '/sys.path.insert/d' -i "${S}"/gnome-music.in || die "python fixup sed failed"
	gnome2_src_prepare
}

src_install() {
	meson_src_install
	python_fix_shebang "${D}"usr/bin/gnome-music
}
