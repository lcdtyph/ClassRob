#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

from lxml import html
import sys
import requests

def main():
    if len(sys.argv) < 2:
        return

    url2json(sys.argv[1])

def url2json(url):
    fmt = '''
<html><body>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<h1>
%s
</h1>

%s

</body></html>
    '''

    req = requests.get(url)
    reqbody = str(req.text)

    tree = html.fromstring(reqbody)

    title = tree.xpath(".//table[@class='main_r_list_left_k']/tr[1]")
    title = html.tostring(title[0]).decode('utf-8')

    proper = tree.xpath("//td[@class='font_cont1']")
    proper = html.tostring(proper[0]).decode('utf-8')

    filename = url[url.rfind('/') + 1: ]
    with open('output/' + filename, 'w') as f:
        f.write(fmt % (title, proper))
    return filename

if __name__ == '__main__':
    main()

