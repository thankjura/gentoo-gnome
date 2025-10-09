from os import path, listdir
from itertools import zip_longest
from typing import Optional

import aiohttp
import re
from .parser import GParser

ftp_version_regexp = re.compile(r"-(\d+(\.\d+)*(\.rc|\.alpha|\.beta)?(\.\d+)?)")
ebuild_version_regexp = re.compile(r"-(\d+(\.\d+)*(_rc\d*|_alpha\d*|_beta\d*)?)")
PREFIX = 'https://download.gnome.org/sources/'

PORTAGE_PREFIX = '/var/db/repos/gentoo'
LOCAL_PREFIX = path.dirname(path.dirname(__file__))


class Version:
    def __init__(self, vstring):
        self.__vstring = vstring.replace("_", ".")
        self.__vstring = re.sub(r'(rc|alpha|beta)(\d+)', r'\1.\2', self.__vstring)
        self.__parts = self.__vstring.split(".")

    @property
    def parts(self) -> list:
        return self.__parts

    def __gt__(self, other: 'Version'):
        for left, right in zip_longest(self.__parts, other.parts):
            if not left:
                return not right.isdigit()
            if not right:
                return left.isdigit()
            if left == right:
                continue

            if left.isdigit() and right.isdigit():
                return int(left) > int(right)

            if left.isdigit():
                return True
            elif right.isdigit():
                return False

            if left == "rc":
                return True

            if left == "beta":
                if right == "rc":
                    return False
                else:
                    return True

            if left == "alpha":
                return False

            return False

    def __ge__(self, other: 'Version'):
        if self.__vstring == other.__vstring:
            return True

        return self.__gt__(other)

    def __le__(self, other: 'Version'):
        if self.__vstring == other.__vstring:
            return True

        return self.__le__(other)

    def __lt__(self, other: 'Version'):
        return not self.__ge__(other)

    def __str__(self):
        return self.__vstring

    def __eq__(self, ver):
        return self.__vstring == ver.__vstring

    @property
    def ebuild_version(self):
        return self.__vstring.replace(".rc", "_rc").replace("a.", "a").replace(".alpha", "_alpha").replace(".beta", "_beta")

    def __repr__(self):
        return f"Version({self.__vstring})"


def is_float(value):
    try:
        float(value)
        return True
    except ValueError:
        return False


async def get_last_ftp_version(atom, slot=None) -> Optional[Version]:
    async with aiohttp.ClientSession() as session:
        async with session.get(PREFIX + atom + "/") as resp:
            if resp.status < 200 or resp.status >= 400:
                return None
            html = await resp.text()
            parser = GParser()
            parser.feed(html)

        if slot:
            slot = Version(slot)
        available_slots = []
        for link in parser.links:
            if not is_float(link):
                continue
            available_slots.append(Version(link))
        available_slots.sort()
        if slot:
            if slot in available_slots:
                atom_url = PREFIX + atom + "/" + str(slot) + "/"
            else:
                # print("\n\n\n\n")
                # print([x.ebuild_version for x in available_slots])
                # print(slot.ebuild_version)
                # print([x.ebuild_version for x in [s for s in available_slots if slot >= s]])
                last_slot = [s for s in available_slots if slot >= s][-1]
                atom_url = PREFIX + atom + "/" + str(last_slot) + "/"
        else:
            last_slot = available_slots[-1]
            atom_url = PREFIX + atom + "/" + str(last_slot) + "/"

        async with session.get(atom_url) as resp:
            if resp.status < 200 or resp.status >= 400:
                return None
            html = await resp.text()
            parser.feed(html)
        versions = []
        for al in parser.links:
            if str(al).endswith('tar.xz') or str(al).endswith('tar.gz'):
                versions.append(Version(ftp_version_regexp.findall(str(al))[0][0]))
        versions.sort()
        return versions[-1]


def get_last_local_version(atom):
    def get_last_version(prefix):
        versions = []
        if not path.exists(path.join(prefix, atom)):
            return Version('0')
        for f in listdir(path.join(prefix, atom)):
            if f.endswith(".ebuild"):
                ver = ebuild_version_regexp.findall(f)[0][0]
                if ver == "9999":
                    continue

                versions.append(Version(ver))

        if versions:
            versions.sort()
            return versions[-1]
        return Version('0')

    last_portage_version = get_last_version(PORTAGE_PREFIX)
    last_overlay_version = get_last_version(path.dirname(LOCAL_PREFIX))
    return [last_overlay_version, last_portage_version]
