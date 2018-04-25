from ..version import get_last_local_version
from ..ebuild import create_ebuild

ATOMS = (
    'media-plugins/gst-plugins-flac',
    'media-plugins/gst-plugins-oss',
    'media-plugins/gst-plugins-libpng',
    'media-plugins/gst-plugins-shout2',
    'media-plugins/gst-plugins-wavpack',
    'media-plugins/gst-plugins-gdkpixbuf',
    'media-plugins/gst-plugins-dv',
    'media-plugins/gst-plugins-vpx',
    'media-plugins/gst-plugins-jpeg',
    'media-plugins/gst-plugins-v4l2',
    'media-plugins/gst-plugins-soup',
    'media-plugins/gst-plugins-pulse',
    'media-plugins/gst-plugins-speex',
    'media-plugins/gst-plugins-ximagesrc',
    'media-plugins/gst-plugins-raw1394',
    'media-plugins/gst-plugins-taglib',
    'media-plugins/gst-plugins-jack',
    'media-plugins/gst-plugins-flac',
    'media-plugins/gst-plugins-lame',
)


async def run(new_version):
    for a in ATOMS:
        #print("check ebuild for %s" % a)
        last_version = sorted(get_last_local_version(a))[-1]
        if last_version < new_version:
            await create_ebuild(a, new_version)
