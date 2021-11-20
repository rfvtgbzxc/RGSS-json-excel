# RGSS-to-json-excel
### 这个项目的主要目的是将RGSS的数据库的数据与json格式互转，而json格式具有更好的拓展性，因此可以再将json转化为excel，以此让数据可以被方便的编辑。

### 该项目的组件相当轻量，部分内容是为RGSS定制的，如果要在非RGSS环境下运行，需要自行调整。

# 组件（√代表已完成）
* rgss-serializer √
  * 用于将原生对象转换为json，参考了Marshal的数据结构。
  * 其中为RGSS定制的部分是对Table类型的处理。
* json-to-excel √
  * 用于将json转换为excel
* excel-to-rxData √
  * 用于将excel转换为原生对象
* smarter-rxData_json_excel
  * 不再需要nodejs和json作为中间态的脚本

# 初始化（安装库和依赖）
### 1.安装nodejs
### 2.在CodeAndExample目录下运行指令，安装js库：
``` shell
npm install
```
### 3.安装ruby
### 4.运行指令，安装ruby库
``` shell
gem install read_excel
```

# 理论工作流程
## 一、数据的导出
### 1. 将Data文件夹放入CodeAndExample文件夹
### 2. 运行指令：
``` shell
ruby rxdata_json_excel.rb 2json
```
期待结果：
```
Write file Actors.json successed!
Write file Enemies.json successed!
Write file Weapons.json successed!
All successed!
```
### 3.运行指令
```
node json-excel 2excel
```
期待结果：
```
JsonToExcel run successfully !
```
### 4.此时CodeAndExample目录下出现文件"Database.xlsx"，开始使用吧！

## 二、数据的导入
### 运行指令：
```
ruby rxdata_json_excel.rb 2rxdata
```
期待结果：
```
Write file Actors.rxdata successed!
Write file Enemies.rxdata successed!
Write file Weapons.rxdata successed!
All successed!
```
因为这个过程对xlsx文件是只读的，所以可以不用关闭excel，保存后就可以运行指令对数据进行同步。

# 填写配置文件
### Demo中仅提供了Actors，Weapons和Enemies的数据，要处理更多的文件和数据，需要填写config.rb和config.js。
- bind_files：描述要处理哪些数据库成员，对应值可以是"AllAvailable"或者一个数组，只有数组里的成员的数据会被同步。
- attributes：用于在表格中，设定数据的名称和类型，部分数据（布尔变量）必须要声明类型，否则excel转换到rxdata时，其会被视为0或1。
