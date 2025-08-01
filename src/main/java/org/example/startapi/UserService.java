package org.example.startapi;

import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;

@Service
public class UserService {
    //DB대체 List형식으로 대체 구현
    private List<UserDTO> users = new ArrayList<>();

    // DB 대체구현된 List에 값 입력 == 사용자DB
    public UserService() {
        users.add(new UserDTO("test1@test.com", "1234", "홍길동", 100, "010-1111-1111"));
        users.add(new UserDTO("test2@test.com", "abcd", "김철수", 200, "010-2222-2222"));
        users.add(new UserDTO("son@test.com", "1234", "손흥민", 300, "010-3333-3333"));
    }
    //로그인메서드 요청 받은 ID PW 정보 맞는지 검증 Sql문 : SELECT * FROM users WHERE user_id = ? AND password = ?; 대체
    public UserDTO login(String userId, String password) {
        for (UserDTO user : users) {
            if (user.getUserId().equals(userId) && user.getPassword().equals(password)) {
                return user; // 일치하는 사용자 찾으면 반환
            }
        }
        return null; 
    }
    // 회원가입 메서드: 성공하면 true, 아이디 중복 시 false 반환
    public boolean registerUser(UserDTO newUser) {
        // 중복 아이디 체크
        for (UserDTO user : users) {
            if (user.getUserId().equals(newUser.getUserId()) || user.getPhoneNumber().equals(newUser.getPhoneNumber())) {
                return false; // 이미 존재하는 아이디
            }
        }
        // 중복 없으면 리스트에 추가
        users.add(newUser);
        System.out.println("✅ 사용자 목록:");
        for (UserDTO user : users) {
            System.out.println("📌 " + user.getUserId() + " / " + user.getUserName());
        }
        return true;

    }
}
