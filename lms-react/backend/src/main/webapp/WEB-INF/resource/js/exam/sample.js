// import * as XLSX from "xlsx"; (윈도우함수로 사용한다면 모듈import/export 를 사용해선 안됨.)

// 엑셀 너비 자동 조절 함수
// 백엔드에서 생성할때는 sheet.autoSizeColumn(columnIndex); 를 사용할 것
function autoFitColumns(worksheet, data) {
    const colWidths = data[0].map((_, colIndex) => {
        let maxLen = 10;

        data.forEach((row) => {
            const val = row[colIndex] ? row[colIndex].toString() : "";
            maxLen = Math.max(maxLen, val.length);
        });

        return { wch: maxLen + 2 }; // padding
    });

    worksheet["!cols"] = colWidths;
}

window.downloadSampleExcel = function () {
    window.location.href = "/excel/sample";
};
