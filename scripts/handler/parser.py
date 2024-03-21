from html.parser import HTMLParser


class GParser(HTMLParser):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.__links = []

    def error(self, message):
        pass

    def handle_starttag(self, tag, attrs):
        if tag != "a":
            return

        attrs = dict(attrs)
        if 'title' not in attrs:
            return

        self.__links.append(attrs['title'])

    @property
    def links(self):
        return self.__links

    def feed(self, data):
        self.__links = []
        super(GParser, self).feed(data)

