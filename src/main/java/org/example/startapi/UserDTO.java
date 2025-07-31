package org.example.startapi;

import com.fasterxml.jackson.annotation.JsonProperty;

public class UserDTO {
    @JsonProperty("userId")
    private String userId;

    @JsonProperty("password")
    private String password;

    private String userName;

    private int userPoint;

    private String phoneNumber;

    public UserDTO() {}

    public UserDTO(String userId, String password, String userName, int userPoint, String phoneNumber) {
        this.userId = userId;
        this.password = password;
        this.userName = userName;
        this.userPoint = userPoint;
        this.phoneNumber = phoneNumber;
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
}
