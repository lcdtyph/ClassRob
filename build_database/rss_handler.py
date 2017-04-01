#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import requests
import sys

def main():
    prefix = '.'
    filename = 'output/rss.xml'
    count = 30
    if len(sys.argv) > 3:
        prefix = sys.argv[1]
        filename = sys.argv[2]
        count = int(sys.argv[3])
    rss_url = 'http://www.jwc.sjtu.edu.cn/rss/rss_notice.aspx?SubjectID=198015&TemplateID=221009'
    req = requests.get(rss_url)
    reqbody = str(req.text)
    
    lastpos = 0
    for i in range(count):
        lastpos = reqbody.find('</item>', lastpos) + len('</item>')
    reqbody = reqbody[0: lastpos] + '</channel></rss>'
    with open(prefix + "/" + filename, 'w') as f:
        f.write(reqbody.replace('gb2312', 'utf-8'))

if __name__ == '__main__':
    main()

