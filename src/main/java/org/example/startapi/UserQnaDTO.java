package org.example.startapi;

import java.util.Date;

// com.example.dto.UserQnaDTO.java
public class UserQnaDTO {

    private String consultType;      // 상담유형 (예: 문의, 칭찬 등)
    private String contentType;      // 내용유형 (예: 제품, 이벤트 등)
    private String title;            // 제목
    private String content;          // 문의 내용
    private String name;             // 작성자 이름
    private String phone;            // 전화번호
    private String email;            // 이메일
    private String addTime;          // 입력 날짜정보

    // 생성자
    public UserQnaDTO(String consultType, String contentType, String title,
                      String content, String name, String phone, String email, String addTime) {
        this.consultType = consultType;
        this.contentType = contentType;
        this.title = title;
        this.content = content;
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.addTime = addTime;
    }


    //getter, setter

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

    public String getAddTime() {
        return addTime;
    }

    public void setAddTime(String addTime) {
        this.addTime = addTime;
    }
}
