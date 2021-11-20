# RGSS-to-json-excel
### 这个项目的主要目的是将RGSS的数据库的数据与json格式互转，而json格式具有更好的拓展性，因此可以再将json转化为excel，以此让数据可以被方便的编辑。

### 该项目的组件相当轻量，部分内容是为RGSS定制的，如果要在非RGSS环境下运行，需要自行调整。

# 组件（√代表已完成）
* rgss-serializer
  * 用于将原生对象转换为json，参考了Marshal的数据结构。
  * 其中为RGSS定制的部分是对Table类型的处理。
* json-to-excel
  * 用于将json转换为excel
* excel-to-rxData
  * 用于将excel转换为原生对象

# 理论工作流程
### 1. ：
```ruby
file1 = File.open("Data/Actors.rxdata","rb")
actors = Marshal.load(file1)
file2 = File.open("Actors.json", "w")
file2.write(Serializer.new.stringify(actors))
file1.close
file2.close
```
### 2. 还没想好，作者不太了解excel里如何使用引用，因此在json到excel互转的过程中可能会只允许导入一部分非引用类型的数据（这是数据里的绝大部分）。