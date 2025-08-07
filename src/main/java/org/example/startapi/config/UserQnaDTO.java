package org.example.startapi.config;

// com.example.dto.UserQnaDTO.java
public class UserQnaDTO {

    private String consultType;      // 상담유형 (예: 문의, 칭찬 등)
    private String contentType;      // 내용유형 (예: 제품, 이벤트 등)
    private String title;            // 제목
    private String content;          // 문의 내용
    private String name;             // 작성자 이름
    private String phone;            // 전화번호
    private String email;            // 이메일

    // 생성자, getter, setter
    public UserQnaDTO() {}

    public String getConsultType() {
        return consultType;
    }

    public void setConsultType(String consultType) {
        this.consultType = consultType;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
