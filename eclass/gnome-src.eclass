# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gnome_src.eclass
# @MAINTAINER:
# me@slie.ru
# @AUTHOR:
# Authors: Yury <me@slie.ru>
# @BLURB: Helper eclass for gnome.org hosted archives
# @DESCRIPTION:
# Provide a default SRC_URI for tarball hosted on gnome.org mirrors.

# versionator inherit kept for older EAPIs due to ebuilds (potentially) relying on it
[[ ${EAPI} == [0123456] ]] && inherit eapi7-ver versionator

if [[ ${EAPI:-0} != [0123456] ]]; then
	BDEPEND="app-arch/xz-utils"
else
	DEPEND="app-arch/xz-utils"
fi

# @ECLASS-VARIABLE: GNOME_ORG_MODULE
# @DESCRIPTION:
# Name of the module as hosted on gnome.org mirrors.
# Leave unset if package name matches module name.
: ${GNOME_ORG_MODULE:=$PN}

# @ECLASS-VARIABLE: GNOME_ORG_PVP
# @INTERNAL
# @DESCRIPTION:
# Major and minor numbers of the version number.
: ${GNOME_ORG_PVP:=$(ver_cut 1-2)}

if [[ $(ver_cut 1) -ge 40 ]]; then
	GNOME_ORG_PVP=$(ver_cut 1)
fi

MY_PV=${PV/_/.}

SRC_URI="mirror://gnome/sources/${GNOME_ORG_MODULE}/${GNOME_ORG_PVP}/${GNOME_ORG_MODULE}-${MY_PV}.tar.xz"

S="${WORKDIR}/${GNOME_ORG_MODULE}-${MY_PV}"
