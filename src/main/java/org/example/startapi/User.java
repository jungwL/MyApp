package org.example.startapi; // 본인 프로젝트의 패키지 경로에 맞게 수정하세요

import jakarta.persistence.*;

@Entity
@Table(name = "users") // 데이터베이스 테이블 이름을 "users"로 지정
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // 엔티티의 고유 식별자 (Primary Key)

    @Column(unique = true, nullable = false)
    private String userId;  // 아이디(이메일)

    @Column(nullable = false)
    private String password; // 비밀번호

    private String userName; // 이름

    private int userPoint;  // 멤버십 포인트 점수

    @Column(unique = true, nullable = false)
    private String phoneNumber; // 휴대폰 번호

    private int pinNo; // 핀번호

    private String userAddress; // 주소

    // JPA는 기본 생성자가 반드시 필요합니다.
    public User() {
    }

    // --- Getter and Setter ---
    // (Lombok을 사용하면 생략 가능)

    public Long getId() {
        return id;
    }



    public void setId(Long id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getUserPoint() {
        return userPoint;
    }

    public void setUserPoint(int userPoint) {
        this.userPoint = userPoint;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public int getPinNo() {
        return pinNo;
    }

    public void setPinNo(int pinNo) {
        this.pinNo = pinNo;
    }

    public String getUserAddress() {
        return userAddress;
    }

    public void setUserAddress(String userAddress) {
        this.userAddress = userAddress;
    }
}