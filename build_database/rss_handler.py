#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import requests
import sys

def main():
    prefix = '.'
    filename = 'output/rss.xml'
    if len(sys.argv) > 2:
        prefix = sys.argv[1]
        filename = sys.argv[2]
    rss_url = 'http://www.jwc.sjtu.edu.cn/rss/rss_notice.aspx?SubjectID=198015&TemplateID=221009'
    req = requests.get(rss_url)
    with open(prefix + "/" + filename, 'w') as f:
        f.write(str(req.text).replace('gb2312', 'utf-8'))

if __name__ == '__main__':
    main()

