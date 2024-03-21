from ..version import get_last_local_version
from ..ebuild import create_ebuild

ATOM = 'dev-libs/gobject-introspection-common'


async def run(new_version):
    #print("check ebuild for %s" % ATOM)
    last_version = sorted(get_last_local_version(ATOM))[-1]
    if last_version < new_version:
        await create_ebuild(ATOM, new_version)
