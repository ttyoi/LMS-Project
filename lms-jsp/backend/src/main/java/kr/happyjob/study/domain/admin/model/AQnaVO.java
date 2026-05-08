package kr.happyjob.study.domain.admin.model;

import java.util.Date;

public class AQnaVO {

    private int postId;          // 게시글 ID
    private String title;         // 제목
    private String content;       // 내용
    private String answerStatus;  // 답변상태 (미답변/답변완료)
    private String categoryCode;  // 카테고리 코드
    private String categoryName;  // 카테고리명 (JOIN)
    private String loginID;       // 작성자 ID
    private String writerName;    // 작성자 이름 (JOIN)
    private String userType;      // 유저 타입 (A, I, S)
    private Date createdAt;       // 작성일자
    private Date updatedAt;       // 수정일자
    private String isDeleted;     // 삭제 여부 (Y/N)
    private String requestTarget;     // 답변 요청 대상자 ID
    private String requestTargetName; // 답변 요청 대상자 이름


    // 파일 관련
    private String filOriName;     // 원본 파일명
    private String filSavName;     // 저장 파일명 (UUID)
    private String extendsName;    // 확장자
    private Integer size;          // 파일 크기
    private String logicalPath;    // 논리 경로
    private String physicalPath;   // 물리 경로

    // Getter / Setter
    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAnswerStatus() {
        return answerStatus;
    }

    public void setAnswerStatus(String answerStatus) {
        this.answerStatus = answerStatus;
    }

    public String getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getLoginID() {
        return loginID;
    }

    public void setLoginID(String loginID) {
        this.loginID = loginID;
    }

    public String getWriterName() {
        return writerName;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public void setWriterName(String writerName) {
        this.writerName = writerName;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getFilOriName() {
        return filOriName;
    }

    public void setFilOriName(String filOriName) {
        this.filOriName = filOriName;
    }

    public String getFilSavName() {
        return filSavName;
    }

    public void setFilSavName(String filSavName) {
        this.filSavName = filSavName;
    }

    public String getExtendsName() {
        return extendsName;
    }

    public void setExtendsName(String extendsName) {
        this.extendsName = extendsName;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(Integer size) {
        this.size = size;
    }

    public String getLogicalPath() {
        return logicalPath;
    }

    public void setLogicalPath(String logicalPath) {
        this.logicalPath = logicalPath;
    }

    public String getPhysicalPath() {
        return physicalPath;
    }

    public void setPhysicalPath(String physicalPath) {
        this.physicalPath = physicalPath;
    }

    public String getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(String isDeleted) {
        this.isDeleted = isDeleted;
    }

    public String getRequestTarget() { return requestTarget; }
    public void setRequestTarget(String requestTarget) { this.requestTarget = requestTarget; }

    public String getRequestTargetName() { return requestTargetName; }
    public void setRequestTargetName(String requestTargetName) { this.requestTargetName = requestTargetName; }

}
