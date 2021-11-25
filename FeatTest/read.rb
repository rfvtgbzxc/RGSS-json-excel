require "read_excel"

workbook = ReadExcel.new("hello.xlsx")
worksheets = {}
workbook.worksheets.each do |sheet|
  worksheets[sheet.name] = sheet
end
puts workbook.worksheets[0].row(0)[4].class.name
