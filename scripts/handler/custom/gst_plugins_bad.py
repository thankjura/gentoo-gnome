from ..version import get_last_local_version
from ..ebuild import create_ebuild

ONLY_LOCAL_CHECK = True

ATOMS = (
    'media-plugins/gst-plugins-libmms',
    'media-plugins/gst-plugins-ofa',
    'media-plugins/gst-plugins-mplex',
    'media-plugins/gst-plugins-mplex',
    'media-plugins/gst-plugins-dts',
    'media-plugins/gst-plugins-rtmp',
    'media-plugins/gst-plugins-faad',
    'media-plugins/gst-plugins-faac',
    'media-plugins/gst-plugins-voamrwbenc',
    'media-plugins/gst-plugins-resindvd',
    'media-plugins/gst-plugins-hls',
    'media-plugins/gst-plugins-dvb',
    'media-plugins/gst-plugins-soundtouch',
    'media-plugins/gst-plugins-dash',
    'media-plugins/gst-plugins-smoothstreaming',
    'media-plugins/gst-plugins-modplug',
    'media-plugins/gst-plugins-voaacenc',
    'media-plugins/gst-plugins-assrender',
    'media-plugins/gst-plugins-mpeg2enc',
)


async def run(new_version):
    for a in ATOMS:
        #print("check ebuild for %s" % a)
        last_version = sorted(get_last_local_version(a))[-1]
        if last_version < new_version:
            await create_ebuild(a, new_version)
