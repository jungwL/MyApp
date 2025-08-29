package org.example.startapi;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity // 이 클래스가 데이터베이스 테이블과 매핑되는 엔티티임을 선언합니다.
@Table(name = "qna") // 실제 데이터베이스의 테이블 이름을 "qna"로 지정합니다.
public class UserQna {

    @Id // 이 필드가 테이블의 기본 키(Primary Key)임을 나타냅니다.
    @GeneratedValue(strategy = GenerationType.IDENTITY) // 기본 키 값을 데이터베이스가 자동으로 생성(auto-increment)하도록 합니다.
    private Long id;

    private String consultType;      // 상담유형
    private String contentType;      // 내용유형
    private String title;            // 제목

    @Lob // 내용이 길어질 수 있으므로 CLOB 또는 TEXT 타입으로 매핑합니다.
    private String content;          // 문의 내용

    private String name;             // 작성자 이름
    private String phone;            // 전화번호
    private String email;            // 이메일

    @Column(nullable = false)
    private LocalDate addTime;       // 입력 날짜 (String -> LocalDate 타입으로 변경)

    // JPA 엔티티는 비어있는 기본 생성자가 반드시 필요합니다.
    public UserQna() {
    }

    // --- Getter and Setter ---
    // (Lombok을 사용하면 아래 코드는 생략 가능)

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

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

    public LocalDate getAddTime() {
        return addTime;
    }

    public void setAddTime(LocalDate addTime) {
        this.addTime = addTime;
    }
}