from ..version import get_last_local_version
from ..ebuild import create_ebuild

ONLY_LOCAL_CHECK = True

ATOMS = (
    'media-plugins/gst-plugins-cdio',
    'media-plugins/gst-plugins-sidplay',
    'media-plugins/gst-plugins-a52dec',
    'media-plugins/gst-plugins-twolame',
    'media-plugins/gst-plugins-amr',
    'media-plugins/gst-plugins-dvdread',
    'media-plugins/gst-plugins-x264',
    'media-plugins/gst-plugins-mpeg2dec',
)


async def run(new_version):
    for a in ATOMS:
        #print("check ebuild for %s" % a)
        last_version = sorted(get_last_local_version(a))[-1]
        if last_version < new_version:
            await create_ebuild(a, new_version)
