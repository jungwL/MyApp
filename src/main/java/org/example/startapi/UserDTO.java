package org.example.startapi;

import com.fasterxml.jackson.annotation.JsonProperty;

public class UserDTO {
    @JsonProperty("userId")
    private String userId;  //아이디(이메일)

    @JsonProperty("password")
    private String password; //비밀번호

    private String userName; //이름

    private int userPoint;  //멤버십 포인트 점수q

    private String phoneNumber; //휴대폰 번호

    private int pinNo;

    public UserDTO() {}

    public UserDTO(String userId, String password, String userName, int userPoint, String phoneNumber, int pinNo) {
        this.userId = userId;
        this.password = password;
        this.userName = userName;
        this.userPoint = userPoint;
        this.phoneNumber = phoneNumber;
        this.pinNo = pinNo;
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

    public int getPinNo() {return pinNo;}

    public void setPinNo(int pinNo) {this.pinNo = pinNo;}
}
