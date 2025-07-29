package org.example.startapi;

import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;

@Service
public class UserService {
    //DB대체 List형식으로 대체 구현
    private List<UserDTO> users = new ArrayList<>();

    // DB 대체구현된 List에 값 입력 == 사용자DB 예시
    public UserService() {
        users.add(new UserDTO( "test1@test.com", "1234","홍길동",100));
        users.add(new UserDTO( "test2@test.com", "abcd","김철수",200));
        users.add(new UserDTO( "son@test.com", "1234","손흥민",300));
    }
    //login메서드 요청 받은 ID PW 정보 맞는지 검증 Sql문 : SELECT * FROM users WHERE user_id = ? AND password = ?; 대체
    public UserDTO login(String userId, String password) {
        //System.out.println(">>> 회원 리스트: " + users);
        for (UserDTO user : users) {
            if (user.getUserId().equals(userId) && user.getPassword().equals(password)) {
                return user; // 일치하는 사용자 찾으면 반환
            }
        }
        return null; // 못 찾으면 null 반환
    }
}
