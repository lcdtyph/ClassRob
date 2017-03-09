#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import sqlite3
import os

def main():
    db_path = 'output/course.db'
    if os.path.exists(db_path):
        os.remove(db_path)
    conn = sqlite3.connect(db_path)

    conn.execute('''CREATE TABLE course_info(
                Cnumber char(8) not null,
                Cname varchar(255) not null,
                Clocation varchar(128) not null,
                Chours tinyint not null,
                Cteacher char(16) not null,
                primary key(Cnumber, Cteacher));''')
    conn.execute('''CREATE TABLE course_schedule(
                Cnumber char(8) not null,
                Cday tinyint not null,
                Ctime_start tinyint not null,
                Ctime_end tinyint not null,
                Croom varchar(64) not null,
                Cweeks varchar(64) not null);''')

    conn.commit()
    conn.close()

if __name__ == '__main__':
    main()

