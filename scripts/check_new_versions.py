#!/bin/env python3

import asyncio
import curses
from datetime import datetime
from os import path
from curses_log import CursesLog
from handler.version import LOCAL_PREFIX, get_last_ftp_version, get_last_local_version, Version
from handler.ebuild import create_ebuild
from handler import custom

custom_modules = [m for m in dir(custom) if not m.startswith('__')]
loop = asyncio.get_event_loop()
log = CursesLog()


async def check_atom_process(atom, slot):
    pkg_name = atom.split("/")[1]
    last_local_version = sorted(get_last_local_version(atom))[-1]
    log.add_str(atom, "{}:{} -> ".format(atom, slot).ljust(50))
    log.add_str(atom, "local: {} ".format(last_local_version.ebuild_version).ljust(18), append=True)

    custom_handler = False
    only_local_check = False
    if pkg_name.replace("-", "_") in custom_modules:
        custom_handler = True
        mod = getattr(custom, pkg_name.replace("-", "_"))
        only_local_check = getattr(mod, 'ONLY_LOCAL_CHECK', False)

    if only_local_check:
        last_ftp_version = last_local_version
    else:
        last_ftp_version: Version = await get_last_ftp_version(pkg_name, slot)
        if last_ftp_version > last_local_version:
            log.add_str(atom, "ftp : {} ".format(last_ftp_version).ljust(20), True, curses.color_pair(2))
        else:
            log.add_str(atom, "ftp : {} ".format(last_ftp_version), True, curses.color_pair(1))

        if last_ftp_version > last_local_version:
            returncode = await create_ebuild(atom, last_ftp_version)
            if returncode == 0:
                log.add_str(atom, " [updated]", True, curses.color_pair(1))
            else:
                log.add_str(atom, " [fail]", True, curses.color_pair(2))

    if custom_handler:
        await getattr(custom, pkg_name.replace("-", "_")).run(last_ftp_version)


async def check_atom(atom):
    e = atom.strip().split(":")
    atom = e[0]
    slot = e[1] if len(e) == 2 else None

    x = asyncio.ensure_future(check_atom_process(atom, slot))
    await x


async def bound_check(sem, atom):
    async with sem:
        await check_atom(atom)


async def main(conf):
    sem = asyncio.Semaphore(8)
    tasks = []
    for atom in conf:
        task = asyncio.ensure_future(bound_check(sem, atom))
        tasks.append(task)

    responses = asyncio.gather(*tasks)
    await responses


if __name__ == '__main__':
    start = datetime.now()
    with open(path.join(LOCAL_PREFIX, 'apps_list.conf')) as config:
        loop.run_until_complete(main(config))

    log.add_str("finish", "Finish at {} sec".format((datetime.now() - start)), False, curses.color_pair(1))
    input("\nPress any key")
    log.exit()
