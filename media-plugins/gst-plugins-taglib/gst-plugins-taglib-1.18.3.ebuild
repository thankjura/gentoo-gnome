# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="ID3v2/APEv2 tagger plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/taglib-1.9.1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
