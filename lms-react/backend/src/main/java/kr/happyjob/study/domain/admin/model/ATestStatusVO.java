package kr.happyjob.study.domain.admin.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ATestStatusVO {
    private Integer courseId;
    private Integer period;
    private int status;
}
