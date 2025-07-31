package org.example.startapi;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody UserDTO loginRequest) {
        //flutter 요청받은 값 디버깅
        System.out.println("------------------ 로그인 API 호출---------------------- ");
        System.out.println("flutter 요청 받은 ID값 : " + loginRequest.getUserId());
        System.out.println("flutter 요청 받은 PW값 : " + loginRequest.getPassword());

        //요청받은 값을 파라미터로 userService login 메서드 실행
        UserDTO loginUser = userService.login(loginRequest.getUserId(), loginRequest.getPassword());

        if (loginUser != null) {
            System.out.println("로그인 성공O: " + loginUser.getUserId() + "  사용자 이름 : " + loginUser.getUserName());
            return ResponseEntity.ok(loginUser);
        } else {
            System.out.println("로그인 실패X - 아이디 또는 비밀번호가 일치하지 않음");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 실패");
        }
    }

    @PostMapping("/joinUser")
    public ResponseEntity<?> joinUser(@RequestBody UserDTO joinUserRequest) {
        System.out.println("------------------ 회원가입 API 호출---------------------- ");
        System.out.println("flutter 요청 받은 ID값 : " + joinUserRequest.getUserName());
        System.out.println("flutter 요청 받은 ID값 : " + joinUserRequest.getUserId());
        System.out.println("flutter 요청 받은 PW값 : " + joinUserRequest.getPassword());
        System.out.println("flutter 요청 받은 ID값 : " + joinUserRequest.getPhoneNumber());

        boolean isRegistered = userService.registerUser(joinUserRequest);

        if (isRegistered) {
            System.out.println("회원가입 성공: " + joinUserRequest.getUserId());
            return ResponseEntity.ok("회원가입 성공");
        } else {
            System.out.println("회원가입 실패 - 중복된 아이디: " + joinUserRequest.getUserId());
            return ResponseEntity.status(HttpStatus.CONFLICT).body("중복된 아이디입니다.");
        }
    }

}
