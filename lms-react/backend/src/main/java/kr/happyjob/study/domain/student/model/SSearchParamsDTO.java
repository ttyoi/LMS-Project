package kr.happyjob.study.domain.student.model;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
public class SSearchParamsDTO {
    private String searchKey;
    private String searchWord;
    private String loginID;
    private int pageSize;
    private int currentPage;
    private int start;
    private int end;
    private String startDate;
    private String endDate;
}
