#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import re

chineseday = '星期日 星期一 星期二 星期三 星期四 星期五 星期六'.split()

class PlanInfo:

    def __init__(self):
        self.day = 0
        self.time = ()
        self.room = ''
        self.teacher = ''
        self.week = ''

    def parse(self, plan, flag):
        day, time = plan[0].split()
        room, teacher = plan[1].split(plan[1][plan[1].index(')') + 1])

        self.day = chineseday.index(day)
        self.time = re.findall(r'第(\d+)节--第(\d+)节', time)[0]
        self.time = [int(t) for t in self.time]

        ret = re.findall(r'^([^\(]+)\((\d-\d+)周\)$', room)
        self.room, self.week = ret[0]
        self.teacher = re.findall(r'^([^\(]+).*$', teacher)[0]

        step = 1
        if flag:
            step = 2
        left, right = re.findall(r'(\d+)-(\d+)', self.week)[0]
        left = int(left)
        right = int(right)
        temp_str = ''
        for i in range(flag, 17, step):
            if i >= left and i <= right:
                temp_str += ' %d' % i
        self.week = temp_str.strip()

    def __str__(self):
        return '%d, %s, %s, %s, %s' % (self.day, str(self.time), self.room, self.teacher, self.week)

class ClassInfo:

    def __init__(self):
        self.department = '' # 院系名称
        self.teacher = ''
        self.title = ''      # 职称名称
        self.course = ''     # 课程名称
        self.code = ''       # 课程编码
        self.coursehour = ''  # 学时
        self.classmark = ''  # 学分
        self.plan = []       # 上课安排
        self.semester = ''   # 学期
        self.schoolyear = '' # 学年
        self.location = ''
       
    def parse(self, attr):
        self.department = attr["yxmc"].strip() # 院系名称
        self.teacher = attr["xm"].strip()
        # self.title = attr["zcmc"].strip()      # 职称名称
        self.course = attr["kcmc"].strip()     # 课程名称
        self.coursehour = attr["xqxs"].strip()  # 学时
        self.classmark = attr["xqxf"].strip()  # 学分
        self.location = attr["jxlmc"].strip()

        self.set_code(attr["kcbm"].strip())    # 课程编码
        self.set_plan(attr["sjms"].strip())    # 课程安排
        
    def set_code(self, code):
        ret = re.findall(r'^\d{3}-\((\d{4}-\d{4})-(\d)\)([^\(]+).*$', code)
        if ret:
            ret = ret[0]
            self.schoolyear = ret[0]
            self.semester = ret[1]
            self.code = ret[2]
        else:
            raise ValueError('code')

    def set_plan(self, plan):
        plan = plan.splitlines()[1: ]
        i = 0
        while i < len(plan):
            try:
                temp_plan = PlanInfo()
                if plan[i] == '双周':
                    i += 1
                    temp_plan.parse(plan[i: i + 2], 2)
                elif plan[i] == '单周':
                    i += 1
                    temp_plan.parse(plan[i: i + 2], 1)
                else:
                    temp_plan.parse(plan[i: i + 2], 0)
                self.plan.append(temp_plan)
            except IndexError:
                raise ValueError('\nlocation not alloced\n')
            finally:
                i += 2

    def __str__(self):
        result = '%s, %s, %s, %s, %s' % (self.course, self.teacher, self.schoolyear, self.semester, self.code)
        for line in self.plan:
            result += '\n\t%s' % line
        return result

