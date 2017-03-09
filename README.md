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
 