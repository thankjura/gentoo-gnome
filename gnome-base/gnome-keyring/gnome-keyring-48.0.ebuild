# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )

inherit gnome.org gnome2-utils pam meson python-any-r1 virtualx

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-keyring"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="pam selinux +ssh-agent systemd test valgrind"
RESTRICT="!test? ( test )"

# Replace gkd gpg-agent with pinentry[gnome-keyring] one, bug #547456
RDEPEND="
	>=app-crypt/gcr-3.27.90:0=[gtk]
	>=app-crypt/gnupg-2.0.28:=
	>=app-eselect/eselect-pinentry-0.5
	app-misc/ca-certificates
	>=dev-libs/glib-2.44:2
	>=dev-libs/libgcrypt-1.2.2:0=
	pam? ( sys-libs/pam )
	selinux? ( sec-policy/selinux-gnome )
	ssh-agent? ( virtual/openssh )
"
DEPEND="
	${RDEPEND}
	valgrind? ( dev-debug/valgrind )
"
BDEPEND="
	>=app-eselect/eselect-pinentry-0.5
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use pam)
		$(meson_use ssh-agent)
		$(meson_feature selinux)
		$(meson_feature systemd)
		-Ddebug-mode=false
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if ! [[ $(eselect pinentry show | grep "pinentry-gnome3") ]] ; then
		ewarn "Please select pinentry-gnome3 as default pinentry provider:"
		ewarn " # eselect pinentry set pinentry-gnome3"
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
