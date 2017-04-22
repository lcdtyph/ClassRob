#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import xml.sax
import re
from planinfo import PlanInfo
from planinfo import ClassInfo
import sqlite3
import sys

class XmlHandler(xml.sax.ContentHandler):
    
    def __init__(self):
        self.course = None
        self.conn = sqlite3.connect('output/course.db')
        self.ready = False

    def startElement(self, tag, attributes):
        self.course = ClassInfo()
        self.ready = False
        if tag == 'Detail':
            try:
                self.course.parse(attributes)
                self.ready = True
            except ValueError:
                open('output/error.log', 'a').write(attributes['xm'] + attributes['kcbm'] + '\n')
            except KeyError:
                pass

    def endElement(self, tag):
        if tag == 'Detail' and self.ready:
            try:
                self.conn.execute('''insert into course_info(Cnumber, Cname, Clocation, Chours, Cteacher, Cmark)
                                values(?, ?, ?, ?, ?, ?)''', (self.course.code, self.course.course,
                                self.course.location, self.course.coursehour, self.course.teacher, self.course.classmark))
            except sqlite3.IntegrityError as e:
                print('%s\nduplicate %s' % (e, str(self.course)))
                
            for plan in self.course.plan:
                self.conn.execute('''insert into
                    course_schedule(Cnumber, Cday, Ctime_start, Ctime_end, Croom, Cweeks, Cteacher)
                    values(?, ?, ?, ?, ?, ?, ?)''', (self.course.code, plan.day,
                        plan.time[0], plan.time[1],
                        plan.room, plan.week, self.course.teacher))
            
    def endDocument(self):
        self.conn.commit()
        self.conn.close()

def main():
    if len(sys.argv) <= 1:
        print('usage: %s <xml_file_name>' % sys.argv[0])
        sys.exit(1)
    parser = xml.sax.make_parser()
    parser.setContentHandler(XmlHandler())

    parser.parse(sys.argv[1])
    print("Done!")

if __name__ == '__main__':
    main()

