import curses
import signal
import sys
from collections import OrderedDict

class CursesLog:
    def __init__(self):
        self._rows = OrderedDict()
        self._screen = curses.initscr()
        curses.def_shell_mode()
        curses.start_color()
        curses.use_default_colors()
        curses.init_pair(1, curses.COLOR_GREEN, -1)
        curses.init_pair(2, curses.COLOR_RED, -1)
        curses.cbreak()
        curses.noecho()

    def _remove_first(self):
        self._rows.pop(list(self._rows)[0])
        for k, v in self._rows.items():
            v["y"] -= 1

    def add_str(self, marker, message, append=False, *args, **kwargs):
        if marker in self._rows:
            d = self._rows[marker]
            if not append:
                self._screen.addstr(d["y"], d["x"] , message, *args, **kwargs)
            else:
                self._screen.addstr(d["y"], d["end"], message, *args, **kwargs)
        else:
            if self._screen.getmaxyx()[0] <= len(self._rows):
                self._screen.move(0, 0)
                self._screen.deleteln()
                self._screen.refresh()
                self._remove_first()

            self._screen.addstr(len(self._rows), 0, message, *args, **kwargs)

        y, x = self._screen.getyx()
        self._rows[marker] = {
            "y": y,
            "x": x - len(message),
            "end": x
        }
        self._screen.refresh()

    @staticmethod
    def exit():
        curses.echo()
        curses.nocbreak()
        curses.reset_shell_mode()
        curses.endwin()


def signal_handler(signal, frame):
    CursesLog.exit()
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)
