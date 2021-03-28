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
        filename = glob(path.join(local_path, "%s-%s*.ebuild" % (pkg_name, last_overlay_version.ebuild_version)))[-1]
        shutil.move(filename, path.join(local_path, ebuild_name))

    lines = []
    with Path(local_path, ebuild_name).open("r") as f:
        for line in f:
            lines.append(line)

    with Path(local_path, ebuild_name).open("w") as f:
        source = ""
        for line in lines:
            if not line.startswith("inherit ") or "gnome-src" in line:
                source += line
                continue
            deps = [d.strip() for d in line.split(" ") if d.strip()]
            deps.remove("inherit")
            if "gnome.org" in deps:
                deps.remove("gnome.org")

            if "gnome2" in deps:
                deps.remove("gnome2")
                deps.append("gnome2-utils")
                deps.append("xdg")

            deps.append("gnome-src")

            source += "inherit " + " ".join(set(deps)) + "\n"
        f.write(source)

    out = await create_subprocess_shell("cd %s && sudo ebuild %s digest" % (local_path, ebuild_name),
                                        stdin=PIPE, stdout=PIPE, stderr=STDOUT)
    return await out.wait()
