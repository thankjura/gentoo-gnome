# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{11..14} )

inherit gnome.org gnome2-utils meson xdg python-single-r1

DESCRIPTION="Make your screenshots ready for the world"
HOMEPAGE="https://github.com/AlexanderVanhee/Gradia"
SRC_URI="https://github.com/AlexanderVanhee/Gradia/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=gui-libs/gtk-4.12
	>=gui-libs/libadwaita-1.5.0
	gui-libs/gtksourceview:5
	>=dev-util/blueprint-compiler-0.17
	$(python_gen_cond_dep '
		>=dev-python/pygobject-3.48.0[${PYTHON_USEDEP}]
		dev-python/pytesseract[${PYTHON_USEDEP}]
	')
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES="${FILESDIR}/fix-build.patch"
S=${WORKDIR}/Gradia-${PV}

src_install() {
	meson_src_install
	python_fix_shebang "${D}"/usr/bin/gradia
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
