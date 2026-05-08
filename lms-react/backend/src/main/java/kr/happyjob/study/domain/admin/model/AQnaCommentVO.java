package kr.happyjob.study.domain.admin.model;

import java.util.Date;

public class AQnaCommentVO {

    private Long commentId;     // 댓글 ID
    private Long postId;        // 게시글 ID
    private String content;     // 댓글 내용
    private String isTeacher;   // 강사 여부 (Y/N)
    private String isDeleted;   // 삭제 여부 (Y/N)
    private Date createdAt;     // 생성일자
    private String loginID;     // 작성자 ID
    private String writerName;  // 작성자 이름 (JOIN)

    // Getter / Setter
    public Long getCommentId() {
        return commentId;
    }

    public void setCommentId(Long commentId) {
        this.commentId = commentId;
    }

    public Long getPostId() {
        return postId;
    }

    public void setPostId(Long postId) {
        this.postId = postId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getIsTeacher() {
        return isTeacher;
    }

    public void setIsTeacher(String isTeacher) {
        this.isTeacher = isTeacher;
    }

    public String getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(String isDeleted) {
        this.isDeleted = isDeleted;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
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

    public void setWriterName(String writerName) {
        this.writerName = writerName;
    }
}
