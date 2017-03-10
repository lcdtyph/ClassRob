# ClassRob

## 蹭蹭课表

解决交大同学的蹭课需求。

## 构建

### 构建环境

+ python3.6+
+ sqlite3
+ macOS Sierra
+ Xcode 8.0

### 数据库建立

先从教育信息网下载当前学期的排课表导出为XML格式，而后执行：

```bash
cd build_database
./build_db.sh <xml_file>
```

结果会保存在```build_database/output/course.db```中。

### APP构建
 
 *// TODO*
 
## License

>lcdtyph <lcdtyph@gmail.com>
Copyright (C) 2016  lcdtyph

>This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

>This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

>You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
