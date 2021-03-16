# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="Video sink plugin for GStreamer that renders to a GtkWidget"
KEYWORDS="~amd64 ~x86"
IUSE="+egl gles2 +opengl wayland +X"

GL_DEPS="
	>=x11-libs/gtk+-3.15:3[X?,wayland?,${MULTILIB_USEDEP}]
"

RDEPEND="
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},egl=,gles2=,opengl=,wayland=,X=]
	>=x11-libs/gtk+-3.15:3[${MULTILIB_USEDEP}]
	gles2? ( ${GL_DEPS} )
	opengl? ( ${GL_DEPS} )

	!<media-libs/gst-plugins-bad-1.13.1:1.0
"
DEPEND="${RDEPEND}"
