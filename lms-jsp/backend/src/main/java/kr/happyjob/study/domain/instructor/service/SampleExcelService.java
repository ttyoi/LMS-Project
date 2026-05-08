package kr.happyjob.study.domain.instructor.service;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;
import java.util.List;

@Service
public class SampleExcelService {

    private void createSheet(Workbook wb, String sheetName, List<List<String>> data, boolean autoSize) {

        Sheet sheet = wb.createSheet(sheetName);


        // 현재 적용
        // === 헤더 스타일 ===
        CellStyle headerStyle = wb.createCellStyle();
        Font headerFont = wb.createFont();
        headerFont.setBoldweight(Font.BOLDWEIGHT_BOLD);   // old method
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerStyle.setFont(headerFont);


        // 배경색
        headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        headerStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);  // old const

        // 정렬
        headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
        headerStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);


        // 테두리
        headerStyle.setBorderTop(CellStyle.BORDER_THIN);
        headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
        headerStyle.setBorderLeft(CellStyle.BORDER_THIN);
        headerStyle.setBorderRight(CellStyle.BORDER_THIN);


        // === 컬럼명 스타일 ===
        CellStyle columnHeaderStyle = wb.createCellStyle();
        Font colFont = wb.createFont();
        colFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
        columnHeaderStyle.setFont(colFont);

        columnHeaderStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
        columnHeaderStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

        columnHeaderStyle.setAlignment(CellStyle.ALIGN_CENTER);
        columnHeaderStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);


        columnHeaderStyle.setBorderTop(CellStyle.BORDER_MEDIUM);
        columnHeaderStyle.setBorderBottom(CellStyle.BORDER_MEDIUM);
        columnHeaderStyle.setBorderLeft(CellStyle.BORDER_MEDIUM);
        columnHeaderStyle.setBorderRight(CellStyle.BORDER_MEDIUM);


        // === 일반 셀 스타일 ===
        CellStyle bodyStyle = wb.createCellStyle();
        bodyStyle.setBorderTop(CellStyle.BORDER_THIN);
        bodyStyle.setBorderBottom(CellStyle.BORDER_THIN);
        bodyStyle.setBorderLeft(CellStyle.BORDER_THIN);
        bodyStyle.setBorderRight(CellStyle.BORDER_THIN);
        bodyStyle.setAlignment(CellStyle.ALIGN_CENTER);
        bodyStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        bodyStyle.setWrapText(true);

        for (int r = 0; r < data.size(); r++) {
            Row row = sheet.createRow(r);
            List<String> rowData = data.get(r);

            for (int c = 0; c < rowData.size(); c++) {
                Cell cell = row.createCell(c);
                cell.setCellValue(rowData.get(c));

                if (r == 0) {
                    cell.setCellStyle(headerStyle);       // 시험정보
                } else if (r == 2) {
                    cell.setCellStyle(columnHeaderStyle); // 컬럼명
                } else {
                    cell.setCellStyle(bodyStyle);         // 일반
                }
            }
        }
        
        // 1번째 셀 길이 고정
        int currentWidth = sheet.getColumnWidth(0);
        sheet.setColumnWidth(0, currentWidth + 5*256);

        if (autoSize && data.size() > 0) {
            int colCount = data.get(0).size();
            for (int col = 1; col < colCount; col++) {
                sheet.autoSizeColumn(col);
                int secondWidth = sheet.getColumnWidth(2);
                sheet.setColumnWidth(2,secondWidth + 5*256);

            }
        }
    }

    public byte[] generateSampleExcel() throws Exception {

        Workbook wb = new XSSFWorkbook();

        // ---------------- Sheet1 ----------------
        List<List<String>> sheet1 = Arrays.asList(
                Arrays.asList("과목코드", "차시", "시험명"),
                Arrays.asList(),
                Arrays.asList("문제번호", "지문", "보기1", "보기2", "보기3", "보기4", "정답", "배점", "해설"),
                Arrays.asList(
                        "1",
                        "다음 중 프로그래밍 언어가 아닌 것은?",
                        "Python",
                        "C",
                        "Java",
                        "Javascript",
                        "4",
                        "5",
                        "Javascript는 스크립트 언어입니다."
                )
        );
        createSheet(wb, "문제업로드_양식", sheet1, true);

        // ---------------- Sheet2 ----------------
        List<List<String>> sheet2 = Arrays.asList(
                Arrays.asList("파일 작성 규칙 안내"),
                Arrays.asList(),
                Arrays.asList("[전체 규칙]"),
                Arrays.asList("- Sheet1 구조를 변경하면 업로드할 수 없습니다."),
                Arrays.asList("- 첫 번째 행은 시험정보 입력란이며 수정 금지"),
                Arrays.asList("- 세 번째 행은 컬럼명이며 수정 금지"),
                Arrays.asList(),
                Arrays.asList("[시험정보 입력란 규칙]"),
                Arrays.asList("- 첫 번째 칸은 강의코드, 숫자형"),
                Arrays.asList("- 두 번째 칸은 시험명, 문자열"),
                Arrays.asList("- 세 번째 칸은 차시, 숫자형"),
                Arrays.asList("- 시험 정보 입력란은 모두 필수로 입력할 것"),
                Arrays.asList(),
                Arrays.asList("[컬럼 규칙]"),
                Arrays.asList("문제번호: 필수, 문자열"),
                Arrays.asList("지문: 필수, 최대 1000자"),
                Arrays.asList("보기1~4: 선택, 각 255자 제한"),
                Arrays.asList("정답: 1~4 중 하나(필수)"),
                Arrays.asList("배점: 숫자, 기본값 0"),
                Arrays.asList("해설: 선택"),
                Arrays.asList(),
                Arrays.asList("[파일 용량 제한]"),
                Arrays.asList("업로드 가능한 최대 파일 용량은 2MB입니다.")
        );
        createSheet(wb, "작성방법_규칙", sheet2, false);

        // ---------------- Sheet3 ----------------
        List<List<String>> sheet3 = Arrays.asList(
                Arrays.asList("올바른 예시"),
                Arrays.asList("문제번호", "지문", "보기1", "보기2", "보기3", "보기4", "정답", "배점", "해설"),
                Arrays.asList("1", "What is 2+2?", "3", "4", "5", "6", "2", "3", "정답은 4"),
                Arrays.asList(),
                Arrays.asList("잘못된 예시"),
                Arrays.asList("문제번호", "지문", "보기1", "보기2", "보기3", "보기4", "정답", "배점", "해설", "오류내용"),
                Arrays.asList("1", "지문 없음", "2", "3", "4", "보기 누락", "5 (1~4 아닌 값)", "5", "", "필수값 누락 → 업로드 실패")
        );
        createSheet(wb, "예시", sheet3, true);

        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        wb.write(bos);
        wb.close();

        return bos.toByteArray();
    }
}

