package org.example.startapi;

public class UserChangePasswordDTO {
    private String phoneNumber; // 전화번호
    private String newPassword; //신규 비밀번호

    //getter setter
    public UserChangePasswordDTO(String phoneNumber, String newPassword) {
        this.phoneNumber = phoneNumber;
        this.newPassword = newPassword;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }
}
