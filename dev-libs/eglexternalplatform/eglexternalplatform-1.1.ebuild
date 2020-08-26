# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="EGL External Platform Interface"
HOMEPAGE="https://github.com/NVIDIA/eglexternalplatform"
SRC_URI="https://github.com/NVIDIA/eglexternalplatform/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	insinto /usr/include/EGL
	insopts -m644
	doins interface/*
	insinto /usr/$(get_libdir)/pkgconfig
	insopts -m644
	doins *.pc
	dodoc COPYING
}
