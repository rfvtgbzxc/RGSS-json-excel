# unsupport:
# Class, Module, Struct, hash key of object
# A json file includes series of value, key-value pairs and array.
# A value in this file may be a: ture/flase/nil/number/string/symbol/array/hash/object/symbol_link/object_link.
# A key-value pairs, itself may be a hash/object, its key may be a ture/false/nil/number/string/symbol, its value may be as the same as listed before.
# An array, itself may be a array/table(RGSS), its value be so.
#
# To distinguish hash and object, key-value pairs has a extra pair: "&type"-"hash"/"object"
# To specify object's class name, key-value pairs has a extra pair: "&class"-"classname"
# Add "!" before "&" to specify that it's a normal string key (if exist)
# !&type      normal string key
#
# To distinguish array and table(RGSS), array has a extra unit: "T"/"A"
# Add "!" before "T"/"A" to specify that it's a normal string value
# !T          normal string value
# To distinguish value of string, symbol, symbol_link and object_link, value likes "xxx" has a special prefix:
# :xxx        symbol
# ;xxx        symbol link
# @xxx        object link
# 
# To distinguish key of ture, false, nil, number, string, symbol(key must be a string in josn), some key has a special prefix, or itself is special:
# true        true
# false       false
# nil         nil
# #xxx        number
# xxx         string
# :xxx        symbol
# ;xxx        symbol link
#
# Add "!" to specify that it's a normal string
# !true       normal string "true"
# !false      normal string "false"
# !nil        normal string "nil"
# !#xxx       normal string which start with char "#"
# !:xxx       normal string which start with char ":"
# !;xxx       normal string which start with char ";"
# !@xxx       normal string which start with char "@"
# !!xxx       normal string which start with char "!"
# !!!xxx      normal string which start with chars "!!"
#
# That's all need to be known ;)
require "./RGSS1Modules.rb"
require 'read_excel'
require "./config.rb"

class Serializer
  def initialize(dereference = false)
    @dereference = dereference
    refresh
  end

  def refresh
    @symbol_list = {}
    @symbol_count = 0
    @object_list = {}
    @object_count = 0
  end

  def add_symbol(obj)
    @symbol_list[obj] = @symbol_count
    @symbol_count += 1
  end

  def add_object(obj)
    @object_list[obj] = @object_count
    @object_count += 1
  end

  def decorate_key_string(str)
    if str[0] == '!' or str[0] == ';' or str[0] == '@' or str[0] == '&' or str[0] == '#' or str == 'true' or str == 'false' or str == 'nil'
      '!' + str
    else
      str
    end
  end

  def decorate_value_string(str)
    if str[0] == '!' or str[0] == ';' or str[0] == '@' or str[0] == '&' or str[0] == 'T' or str[0] == 'A' 
      '!' + str
    else
      str
    end
  end

  def table_to_arr(table)
    arr = Array.new(table.xsize)
    (0...table.xsize).each do |i|
      if table.ysize == 1
        arr[i] = table[i]
        next
      end
      arr[i] = Array.new(table.ysize)
      (0...table.ysize).each do |j|
        if table.zsize == 1
          arr[i][j] = table[i, j]
          next
        end
        arr[i][j] = Array.new(table.zsize)
      end
    end
    arr
  end
  def handle_Arraylike(obj)
    json = '['
    if obj.is_a?(Table)
      obj = table_to_arr(obj) 
      json += '"T"'
    else
      json += '"A"'
    end
    obj.each do |i|
      json += ','
      json += stringify_help(i)
    end
    json += ']'
    return json
  end
  def stringify_help(obj)
    json = ''
    if @object_list.include?(obj) and !@dereference
      json += "\"@#{@object_list[obj]}\""
      return json
    end
    case obj
    when true
      json += 'true'
    when false
      json += 'false'
    when nil
      json += 'null'
    when Numeric
      json += obj.to_s
    when String
      json += "\"#{decorate_value_string(obj)}\""
    when Symbol
      if !@symbol_list.include?(obj) or @dereference
        add_symbol(obj)
        json += "\":#{obj.id2name}\""
      else
        json += "\";#{@symbol_list[obj]}\""
      end
    when Array
      add_object(obj)
      json += handle_Arraylike(obj)
    when Hash
      add_object(obj)
      json += '{"&type":"hash"'
      (0...obj.size).each do |i|
        json += ','
        k = obj.keys[i]
        v = obj[k]
        if k.is_a?(String)
          json += "\"#{decorate_key_string(k)}\""
        elsif k.is_a?(Numeric)
          json += "\"##{k}\""
        elsif k.is_a?(TrueClass)
          json += '"true"'
        elsif k.is_a?(FalseClass)
          json += '"false"'
        elsif k.is_a?(NilClass)
          json += '"nil"'
        elsif k.is_a?(Symbol)
          if !@symbol_list.include?(k) or @dereference
            add_symbol(k)
            json += "\":#{k.id2name}\""
          else
            json += "\";#{@symbol_list[k]}\""
          end
        else
          raise 'key of hash in json must be one of these: string, symbol, number, true, false, nil!'
        end
        json += ':'
        json += stringify_help(v)
      end
      json += '}'
    when Object
      add_object(obj)
      if obj.is_a?(Table)
        json += handle_Arraylike(obj)
      else
        json += "{\"&type\":\"object\", \"&class\":\"#{obj.class.name}\""
        obj.instance_variables.each do |var_symbol|
          json += ','
          value = obj.instance_variable_get(var_symbol)
          if !@symbol_list.include?(var_symbol) or @dereference
            add_symbol(var_symbol)
            json += "\":#{var_symbol.id2name}\""
          else
            json += "\";#{@symbol_list[var_symbol]}\""
          end
          json += ':'
          json += stringify_help(value)
        end
        json += '}'
      end   
    else
      raise('unrecognized obj type')
    end
    json
  end

  def stringify(obj)
    refresh
    return stringify_help(obj)
  end

  # this is for ruby 1.9
  def get_class

  end

  # this is customized for RGSS Database
  def partial_prase(str, obj)

  end
end

def rxDataToJson
  for file_name in bind_files
    file1 = File.open("Data/#{file_name}.rxdata","rb")
    data = Marshal.load(file1)
    file2 = File.open("Json/#{file_name}.json","w")
    file2.write(Serializer.new(true).stringify(data))
    file1.close
    file2.close
    puts "Write file #{page_name}.json successed!"
  end
  puts "All successed!"
end

def excelToRxData
  for page_name, page_setting in ExcelToRxdataConfig::BindFiles
    if not File.exist?("#{page_name}.rxdata")
      puts "need file #{page_name}.rxdata!"
      return
    end
  end
  workbook = ReadExcel.new('Database.xlsx')
  worksheets = {}
  workbook.worksheets.each do |sheet|
    worksheets[sheet.name] = sheet
  end
  for page_name, page_setting in ExcelToRxdataConfig::BindFiles
    sheet = worksheets[page_name]
    next if sheet.nil?
    file = File.open("#{page_name}.rxdata","rb")
    data = Marshal.load(file)
    file.close
    file = File.open("#{page_name}_back.rxdata","wb")
    Marshal.dump(data, file)
    file.close
    columns = page_setting == "AllAvailable" ? ExcelToRxdataConfig::Words[page_name].keys : page_setting
    for rowIndex in 1...data.size
      row = sheet.row(rowIndex)
      item = data[row[0]]
      for columnIndex in 1...columns.size
        item.instance_variable_set("@#{columns[columnIndex]}",row[columnIndex])
      end
    end
    file = File.open("#{page_name}.rxdata","wb")
    Marshal.dump(data, file)
    file.close
    puts "Write file #{page_name}.rxdata successed!"
  end
  puts "All successed!"
end

#rxDataToJson

#excelToRxData






# a = [1, 2, 'vince', ['vince2']]
# b = :hello
# class Test
#   def initialize
#     @name = 'haha'
#     @index = 123
#   end
# end
# c = { '&type' => 'object', 'test' => Test.new, b => a, 'symbol' => b, true => a, false => b, nil => 'heihei', 1234 => '4321', 'true' => false,
#       'false' => true, '!true' => 'true', '1234' => 1234 }
# d = {}
# d[1] = 1
# d['1'] = 2
# puts d[1],d["1"]
# b = Test.new
# var = b.instance_variables[0]
# puts var.is_a?(Symbol)
# puts b.instance_variable_get(var);
# file = File.open("Data/Actors.rxdata","rb")
# data = Marshal.load(file)
#puts Serializer.new.stringify(c)
