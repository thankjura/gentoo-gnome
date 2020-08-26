from os import path, makedirs
import shutil
from asyncio.subprocess import PIPE, STDOUT, create_subprocess_shell
from glob import glob

from .version import LOCAL_PREFIX, PORTAGE_PREFIX, get_last_local_version


async def create_ebuild(atom, version):
    pkg_name = atom.split("/")[1]
    local_path = path.join(path.dirname(LOCAL_PREFIX), atom)
    if not path.exists(local_path):
        makedirs(local_path)
    last_overlay_version, last_portage_version = get_last_local_version(atom)
    ebuild_name = "%s-%s.ebuild" % (pkg_name, version.vstring)
    if not last_overlay_version or last_portage_version > last_overlay_version:
        #print("copy ebuild from portage")
        filename = glob(path.join(PORTAGE_PREFIX, atom,
                                  "%s-%s*.ebuild" % (pkg_name, str(last_portage_version).replace('.post', '-r'))))[-1]
        shutil.copyfile(filename, path.join(local_path, ebuild_name))
    else:
        #print("move ebuild in overlay")
        filename = glob(path.join(local_path, "%s-%s*.ebuild" % (pkg_name,
                                                                 str(last_overlay_version).replace('.post', '-r'))))[-1]
        shutil.move(filename, path.join(local_path, ebuild_name))

    #print(system("cd %s && sudo ebuild %s digest" % (local_path, ebuild_name)))
    out = await create_subprocess_shell("cd %s && sudo ebuild %s digest" % (local_path, ebuild_name), stdin = PIPE, stdout = PIPE, stderr = STDOUT)
    return await out.wait()
