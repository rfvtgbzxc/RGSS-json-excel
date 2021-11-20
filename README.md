# RGSS-to-json-excel
### The main purpose of this project is to interconvert RGSS database data with JSON format, which is more extensible, so json can be converted into Excel, so that data can be easily edited.

### The components of the project are fairly lightweight, and some of the content is customized for RGSS, which needs to be adjusted if it is to run in a non-RGSS environment.

# Component (√ indicates completed)
### A component is a folder containing code, use cases, and references.
* rgss-serializer
  * Use to convert native objects to JSON, referencing Marshal's data structure.
  * The part that is customized for RGSS is the handling of the Table type.
* rgss-json-parser
  * Use to convert JSON back to native data objects.
* json-to-excel
  * Use to convert JSON to Excel
* excel-to-json
  * Use to convert Excel to JSON

# Theoretical workflow
### 1. Load RGSS-Serializer into the RGSS script library and convert the data to JSON in the following code:
```ruby
file1 = File.open("Data/Actors.rxdata","rb")
actors = Marshal.load(file1)
file2 = File.open("Actors.json", "w")
file2.write(Serializer.new.stringify(actors))
file1.close
file2.close
```
### 2. I'm not sure yet. The author doesn't know how to use references in Excel, so it's possible that only a portion of non-reference data will be allowed to be imported during the JSON-excel interchange (which is the majority of the data).