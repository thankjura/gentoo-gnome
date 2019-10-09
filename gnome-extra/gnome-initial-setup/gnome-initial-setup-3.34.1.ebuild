# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="GNOME initial setup"
HOMEPAGE="https://github.com/GNOME/gnome-initial-setup"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"

DEPEND="
	>=dev-util/intltool-0.40.0
	>=dev-lang/perl-5.8.1
	>=net-misc/networkmanager-0.9.6.4
	>=dev-libs/glib-2.36
	>=x11-libs/gtk+-3.11.3
	>=x11-libs/pango-1.32.5
	>=app-i18n/ibus-1.4.99
	>=gnome-base/gnome-desktop-3.7.5
	>=sys-auth/polkit-0.103
	>=gnome-base/gdm-3.8.3
	>=app-misc/geoclue-2.1.2
	media-libs/fontconfig
	dev-libs/libgweather
	net-libs/gnome-online-accounts
	net-libs/rest:0.7
	dev-libs/json-glib
	app-crypt/libsecret
	dev-libs/libpwquality
	net-libs/webkit-gtk:4
	virtual/pkgconfig
"
