from ..version import get_last_local_version
from ..ebuild import create_ebuild

ATOMS = ('dev-util/gdbus-codegen', 'dev-util/glib-utils')


async def run(new_version):
    #print("check ebuild for %s" % ATOM)
    for ATOM in ATOMS:
        last_version = sorted(get_last_local_version(ATOM))[-1]
        if last_version < new_version:
            await create_ebuild(ATOM, new_version)
