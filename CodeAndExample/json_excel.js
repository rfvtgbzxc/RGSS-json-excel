const fs = require('fs');
const ExcelJS = require('exceljs');
const { bindFiles, attributes } = require('./config');
const { nextTick } = require('process');
function readFileUsePromise(filename) {
  return new Promise((resolve) => {
    fs.readFile(`./${filename}`, "utf8", (err, result) => {
      resolve(result)
    });
  });
}
function writeFileUsePromise(filename, data) {
  return new Promise((resolve, reject) => {
    fs.writeFile(filename, data, (err) => {
      if (err) {
        console.log(err);
        resolve(false);
      }
      else {
        resolve(true);
      }
    })
  });
}
function getFileExistenceUsePromise(filename) {
  return new Promise((resolve, reject) => {
    fs.stat(filename, (err, stats) => {
      if (err) {
        resolve(false);
      }
      else {
        resolve(true);
      }
    })
  });
}
function getRowIndex2Id(sheet) {
  // 获取基于id的rowIndex索引表
  const lastRow = sheet.lastRow;
  const rowIndex2Id = {};
  for (let rowIndex = 2; rowIndex <= lastRow.number; rowIndex++) {
    rowIndex2Id[rowIndex] = sheet.getCell(rowIndex, 1).value;
  }
  return rowIndex2Id;
}
async function JsonToExcel() {
  const workbook = new ExcelJS.Workbook();
  if (await getFileExistenceUsePromise("Database.xlsx")) {
    await workbook.xlsx.readFile("Database.xlsx");
  }
  for (let pageName in bindFiles) {
    const data = await readFileUsePromise(`Json/${pageName}.json`);
    const lines = JSON.parse(data);
    let sheet = workbook.getWorksheet(pageName);
    let rowIndex2Id = null;
    if (!!!sheet) {
      sheet = workbook.addWorksheet(pageName);
    }
    else {
      rowIndex2Id = getRowIndex2Id(sheet);
    }
    sheet.views = [
      { state: 'frozen', ySplit: 1 }
    ];
    // 第一行是属性名称
    let colIndex = 1;
    let columns;
    if (bindFiles[pageName] === "AllAvailable") {
      columns = Object.keys(attributes[pageName]);
    }
    else {
      columns = bindFiles[pageName];
    }
    for (let attrName of columns) {
      sheet.getColumn(colIndex).header = attributes[pageName][attrName];
      colIndex++;
    }
    // 写属性值
    for (let rowIndex = 2; rowIndex <= lines.length; rowIndex++) {
      for (let i = 0; i < columns.length; i++) {
        let requestId = rowIndex2Id === null ? rowIndex - 1 : (!!!rowIndex2Id[rowIndex] ? rowIndex - 1 : rowIndex2Id[rowIndex]);
        sheet.getRow(rowIndex).getCell(1 + i).value = lines[requestId][`:@${columns[i]}`];
      }
    }
  }
  await workbook.xlsx.writeFile("Database.xlsx");
  console.log("JsonToExcel run successfully !")
}
async function ExcelToJson() {
  for (let pageName in bindFiles) {
    if (!await getFileExistenceUsePromise(`Json/${pageName}.json`)) {
      console.log(`ExcelToJson error: need file ${pageName}.json!`);
      return;
    }
  }
  const workbook = new ExcelJS.Workbook();
  if (await getFileExistenceUsePromise("Database.xlsx")) {
    await workbook.xlsx.readFile("Database.xlsx");
  }
  else {
    console.log(`ExcelToJson error: need file Database.xlsx!`);
    return;
  }
  for (let pageName in bindFiles) {
    const sheet = workbook.getWorksheet(pageName);
    if (!!!sheet) {
      continue;
    }
    const jsonData = await readFileUsePromise(`Json/${pageName}.json`);
    const lines = JSON.parse(jsonData);
    const rowIndex2Id = getRowIndex2Id(sheet);
    let columns;
    if (bindFiles[pageName] === "AllAvailable") {
      columns = Object.keys(attributes[pageName]);
    }
    else {
      columns = bindFiles[pageName];
    }
    // 写属性值
    for (let rowIndex = 2; rowIndex < lines.length; rowIndex++) {
      for (let i = 0; i < columns.length; i++) {
        const requestId = rowIndex2Id === null ? rowIndex - 1 : rowIndex2Id[rowIndex];
        lines[requestId][`:@${columns[i]}`] = sheet.getCell(rowIndex, 1 + i).value;
      }
    }
    if (await writeFileUsePromise(`Json/${pageName}.json`, JSON.stringify(lines))) {
      console.log(`Write file ${pageName}.json successed!`);
    }
    else {
      console.log(`Write file ${pageName}.json failed.`);
    }
  }
  console.log("ExcelToJson run successfully !")
}
//JsonToExcel();
//ExcelToJson();
switch (process.argv[2]) {
  case "2excel":
    JsonToExcel();
    break;
  case "2json":
    ExcelToJson();
    break;
  default:
    console.log(`unrecognized param ${process.argv[2]}, choose '2excel' or '2json'.`)
}