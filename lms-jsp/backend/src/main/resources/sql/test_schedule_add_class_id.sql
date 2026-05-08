-- 시험 일정에 시험 강의실(배정 강의실) 컬럼 추가.
-- 시험별로 비어있는 강의실 중 하나를 선택해 배정할 수 있도록 합니다.
-- 실행: DB 클라이언트에서 아래 구문 실행 (MySQL 기준)

ALTER TABLE test_schedule ADD COLUMN class_id INT NULL COMMENT '시험 배정 강의실 (NULL이면 강의의 강의실 사용)';
