package kr.happyjob.study.domain.instructor.controller;

import kr.happyjob.study.domain.instructor.service.SampleExcelService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.URLEncoder;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class SampleExcelController {

    private final SampleExcelService sampleExcelService;

    @GetMapping("/excel/sample")
    public ResponseEntity<byte[]> downloadSampleExcel() throws Exception {

        byte[] excelFile = sampleExcelService.generateSampleExcel();
        String fileName = "문제업로드_샘플" + ".xlsx";
        String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+","20%");

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename="+ encodedFileName)
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(excelFile);
    }
}
