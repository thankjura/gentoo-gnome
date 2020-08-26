# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson multilib-minimal pax-utils

DESCRIPTION="Open source multimedia framework"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://${PN}.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+caps +introspection nls +orc test unwind gtk-doc"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	caps? ( sys-libs/libcap[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
	unwind? (
		>=sys-libs/libunwind-1.2_rc1[${MULTILIB_USEDEP}]
		dev-libs/elfutils[${MULTILIB_USEDEP}]
	)
	!<media-libs/gst-plugins-bad-1.13.1:1.0
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.12
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

multilib_src_configure() {
	local emesonargs=(
		-Dgst_debug=false
		-Dgst_parse=true
		-Dregistry=true
		-Dtracer_hooks=true
		-Doption-parsing=true
		-Dpoisoning=false
		-Dmemory-alignment=malloc
		-Dcheck=disabled
		$(meson_feature unwind libunwind)
		$(meson_feature unwind libdw)
		-Ddbghelp=disabled
		-Dbash-completion=disabled
		-Dcoretracers=auto
		-Dexamples=disabled
		$(meson_feature test tests)
		-Dbenchmarks=disabled
		-Dtools=enabled
		-Dgtk_doc=$(multilib_native_usex gtk-doc enabled disabled)
		-Dintrospection=$(multilib_native_usex introspection enabled disabled)
		$(meson_feature nls)
		-Dgobject-cast-checks=disabled
		-Dglib-asserts=disabled
		-Dglib-checks=disabled
		-Dextra-checks=disabled
		-Dpackage-name="GStreamer ebuild for Gentoo"
		-Dpackage-origin="https://packages.gentoo.org/package/media-libs/gstreamer"
		-Ddoc=disabled

	)

	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
	# Needed for orc-using gst plugins on hardened/PaX systems, bug #421579
	use orc && pax-mark -m "${ED}usr/$(get_libdir)/gstreamer-${SLOT}/gst-plugin-scanner"
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS MAINTAINERS README RELEASE"
	einstalldocs

	find "${ED}" -name '*.la' -delete || die

	# Needed for orc-using gst plugins on hardened/PaX systems, bug #421579
	use orc && pax-mark -m "${ED}usr/bin/gst-launch-${SLOT}"
}
