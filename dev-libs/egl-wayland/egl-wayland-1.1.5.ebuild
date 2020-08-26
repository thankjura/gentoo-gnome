# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Wayland EGL External Platform library"
HOMEPAGE="https://github.com/NVIDIA/egl-wayland"
SRC_URI="https://github.com/NVIDIA/egl-wayland/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	x11-drivers/nvidia-drivers[wayland]
	dev-libs/eglexternalplatform
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	meson_src_install
	rm -rf ${D}/usr/lib64/libnvidia-egl-wayland.so*
}
