# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils xdg meson

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="https://wiki.gnome.org/Apps/Seahorse"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
IUSE="debug ldap zeroconf +help"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"

COMMON_DEPEND="
	>=app-crypt/gcr-3.11.91:=
	>=dev-libs/glib-2.10:2
	>=x11-libs/gtk+-3.4:3
	>=app-crypt/libsecret-0.16[vala]
	>=net-libs/libsoup-2.33.92:2.4
	x11-misc/shared-mime-info
	>=gui-libs/libhandy-0.0.12

	net-misc/openssh
	>=app-crypt/gpgme-1
	>=app-crypt/gnupg-2.0.12

	ldap? ( net-nds/openldap:= )
	zeroconf? ( >=net-dns/avahi-0.6:= )
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.35
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"
# Need seahorse-plugins git snapshot
RDEPEND="${COMMON_DEPEND}
	!<app-crypt/seahorse-plugins-2.91.0_pre20110114
"

src_prepare() {
	default
	rm -rf subprojects/libhandy
}

src_configure() {
	VALAC=$(type -P true)

	local emesonargs=(
		-Dpgp-support=true
		-Dcheck-compatible-gpg=true
		-Dpkcs11-support=true
		-Dkeyservers-support=true
		-Dhkp-support=true
		-Dldap-support=$(usex ldap true false)
		-Dkey-sharing=$(usex zeroconf true false)
		-Dhelp=$(usex help true false)
	)
	meson_src_configure
}
