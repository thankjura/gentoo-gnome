# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 vala meson

DESCRIPTION=" Tracker is a search engine and that allows the user to find their data as fast as possible."
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/100"
IUSE="cue exif ffmpeg flac gif gsf gstreamer gtk
iptc +iso +jpeg libav +miner-fs mp3 pdf
playlist rss test +tiff upnp-av upower +vorbis +xml xmp
xps"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

REQUIRED_USE="
	?? ( gstreamer ffmpeg )
	cue? ( gstreamer )
	upnp-av? ( gstreamer )
	!miner-fs? ( !cue !exif !flac !gif !gsf !iptc !iso !jpeg !mp3 !pdf !playlist !tiff !vorbis !xml !xmp !xps )
"

RDEPEND="
	>=dev-libs/glib-2.44:2
	>=dev-libs/gobject-introspection-0.9.5:=
	>=dev-libs/icu-4.8.1.1:=
	>=media-libs/libpng-1.2:0=
	>=media-libs/libmediaart-1.9:2.0
	>=x11-libs/pango-1:=
	sys-apps/util-linux
	virtual/imagemagick-tools[png,jpeg?]

	cue? ( media-libs/libcue )
	exif? ( >=media-libs/libexif-0.6 )
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:0= )
	)
	flac? ( >=media-libs/flac-1.2.1 )
	gif? ( media-libs/giflib:= )
	gsf? ( >=gnome-extra/libgsf-1.14.24 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0 )
	gtk? (
		>=dev-libs/libgee-0.3:0.8
		>=x11-libs/gtk+-3:3 )
	iptc? ( media-libs/libiptcdata )
	iso? ( >=sys-libs/libosinfo-0.2.9:= )
	jpeg? ( virtual/jpeg:0 )
	upower? ( || ( >=sys-power/upower-0.9 sys-power/upower-pm-utils ) )
	mp3? ( >=media-libs/taglib-1.6 )
	pdf? (
		>=x11-libs/cairo-1:=
		>=app-text/poppler-0.16:=[cairo,utils]
		>=x11-libs/gtk+-2.12:2 )
	playlist? ( >=dev-libs/totem-pl-parser-3 )
	rss? ( >=net-libs/libgrss-0.7:0 )
	tiff? ( media-libs/tiff:0 )
	upnp-av? ( >=media-libs/gupnp-dlna-0.9.4:2.0 )
	vorbis? ( >=media-libs/libvorbis-0.22 )
	xml? ( >=dev-libs/libxml2-2.6 )
	xmp? ( >=media-libs/exempi-2.1 )
	xps? ( app-text/libgxps )
	!gstreamer? ( !ffmpeg? ( || ( media-video/totem media-video/mplayer ) ) )
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
	eapply_user
	eapply ${FILESDIR}/${P}-fix-meson.patch
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-D docs=false
		-D extract=true
		-D functional_tests=$(usex test true false)
		-D guarantee_metadata=true
		-D journal=true
		-D miner_apps=true
		-D miner_fs=$(usex miner-fs true false)
		-D miner_rss=$(usex rss true false)
		-D writeback=true
		-D abiword=true
		-D dvi=true
		-D icon=true
		-D mp3=$(usex mp3 true false)
		-D ps=true
		-D text=true
		-D unzip_ps_gz_files=true
		-D battery_detection=$(usex upower upower none)
		-D mcharset_detection=icu
		-D generic_media_extractor=$(usex gstreamer gstreamer libav)
		-D gstreamer_backend=$(usex upnp-av gupnp discoverer)
	)
	meson_src_configure
}
