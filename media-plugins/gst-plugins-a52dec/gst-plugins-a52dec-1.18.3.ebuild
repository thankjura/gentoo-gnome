# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-ugly

inherit gstreamer-meson

DESCRIPTION="ATSC A/52 audio decoder plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/a52dec:0=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
