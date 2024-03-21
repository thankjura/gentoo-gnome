from os import path, makedirs
import shutil
from asyncio.subprocess import PIPE, STDOUT, create_subprocess_shell
from glob import glob
from pathlib import Path

from .version import LOCAL_PREFIX, PORTAGE_PREFIX, get_last_local_version, Version


async def create_ebuild(atom, version: Version):
    pkg_name = atom.split("/")[1]
    local_path = path.join(path.dirname(LOCAL_PREFIX), atom)
    if not path.exists(local_path):
        makedirs(local_path)
    last_overlay_version, last_portage_version = get_last_local_version(atom)
    ebuild_name = "%s-%s.ebuild" % (pkg_name, version.ebuild_version)
    if not last_overlay_version or last_portage_version > last_overlay_version:
        filename = glob(path.join(PORTAGE_PREFIX, atom,
                                  "%s-%s*.ebuild" % (pkg_name, last_portage_version.ebuild_version)))[-1]
        shutil.copyfile(filename, path.join(local_path, ebuild_name))
    else:
        try:
            filename = glob(path.join(local_path, "%s-%s*.ebuild" % (pkg_name, last_overlay_version.ebuild_version)))[-1]
        except:
            print("%s-%s*.ebuild" % (pkg_name, last_overlay_version.ebuild_version))
            raise Exception()
        shutil.move(filename, path.join(local_path, ebuild_name))

    out = await create_subprocess_shell("cd %s && sudo ebuild %s digest" % (local_path, ebuild_name),
                                        stdin=PIPE, stdout=PIPE, stderr=STDOUT)
    return await out.wait()
