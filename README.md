# RGSS-to-json-excel
### The main purpose of this project is to interconvert RGSS database data with JSON format, which is more extensible, so json can be converted into Excel, so that data can be easily edited.

### The components of the project are fairly lightweight, and some of the content is customized for RGSS, which needs to be adjusted if it is to run in a non-RGSS environment.

# Component (√ indicates completed)
### A component is a folder containing code, use cases, and references.
* rgss-serializer
  * Use to convert native objects to JSON, referencing Marshal's data structure.
  * The part that is customized for RGSS is the handling of the Table type.
* excel-to-rxData
  * Use to convert Excel to native objects
* smarter-rxData_json_excel
  * Nodejs and JSON are no longer required as intermediate scripts

# Initialize (install libraries and dependencies)
### 1.Install nodejs
### 2.Run the command in the CodeAndExample directory to install the JS library:
``` shell
npm install
```
### 3.Install ruby
### 4.Run the command to install the Ruby library
``` shell
gem install read_excel
```

# Theoretical workflow
## Data Export
### 1. Place the Data folder in the CodeAndExample folder
### 2. Run Shell:
``` shell
ruby rxdata_json_excel.rb 2json
```
Expected results:
```
Write file Actors.json successed!
Write file Enemies.json successed!
Write file Weapons.json successed!
All successed!
```
### 3.Run Shell:
```
node json-excel 2excel
```
Expected results:
```
JsonToExcel run successfully !
```
### 4."Database. XLSX "appears in the CodeAndExample directory.Get started!

## Data Import
### Run Shell:
```
ruby rxdata_json_excel.rb 2rxdata
```
Expected results:
```
Write file Actors.rxdata successed!
Write file Enemies.rxdata successed!
Write file Weapons.rxdata successed!
All successed!
```
Because this process is read-only to XLSX files, you can save Excel and run commands to synchronize data without closing excel.

# Filling in the Configuration File
### Demo only provides data for Actors, Weapons, and Enemies. To process more files and data, you need to fill in config.rb and config.js.
- bind_files：Describes which database members to process. The corresponding value can be "AllAvailable" or an array. Only the members of the array will be synchronized.
- words：Used to adjust the name of the data in the table.
