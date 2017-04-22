#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import requests
import sys
import re
from url_to_json import url2json

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

    urls = re.findall(r'<item><title>[^</]+</title><link>([^<]+)</link>', reqbody)

    for url in urls:
        try:
            newhtml = url2json(url)
            reqbody = reqbody.replace(url, 'http://lcdtyph.com.cn/' + newhtml)
        except:
            print(url)

    with open(prefix + "/" + filename, 'w') as f:
        f.write(reqbody.replace('gb2312', 'utf-8'))

if __name__ == '__main__':
    main()

