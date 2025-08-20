package org.example.startapi;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/api")
public class UserController {

    @Autowired
    private UserService userService;
    //------------------------------------------------------------------------------------------------
    //로그인 API
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody UserDTO loginRequest) {
        //flutter 요청받은 값 디버깅
        System.out.println("------------------ 로그인 호출---------------------- ");
        System.out.println("flutter 요청 받은 ID값 : " + loginRequest.getUserId());
        System.out.println("flutter 요청 받은 PW값 : " + loginRequest.getPassword());

        //요청받은 값을 파라미터로 userService login 메서드 실행
        UserDTO loginUser = userService.login(loginRequest.getUserId(), loginRequest.getPassword());

        if (loginUser != null) {
            System.out.println("로그인 성공O: " + loginUser.getUserId() + "  사용자 이름 : " + loginUser.getUserName());
            return ResponseEntity.ok(loginUser); //200
        } else {
            System.out.println("로그인 실패X - 아이디 또는 비밀번호가 일치하지 않음");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 실패"); //401
        }
    }
    @PostMapping("/login_pinNo")
    public ResponseEntity<?> loginPinNo(@RequestBody UserDTO pinNoRequest) {
        System.out.println("------------------Pin 번호 로그인 호출-----------------");
        System.out.println("flutter 요청 받은 핀 번호 값 : " +  pinNoRequest.getPinNo());

        UserDTO pinNoUser = userService.pinNoLogin(pinNoRequest.getPinNo());

        if (pinNoUser != null) {
            System.out.println("로그인 성공O: " + pinNoUser.getUserId() + "  사용자 이름 : " + pinNoUser.getUserName());
            return ResponseEntity.ok(pinNoUser);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }
    //------------------------------------------------------------------------------------------------
    //회원가입 API
    @PostMapping("/joinUser")
    public ResponseEntity<?> joinUser(@RequestBody UserDTO joinUserRequest) {
        System.out.println("------------------ 회원가입 호출---------------------- ");
        System.out.println("flutter 요청 받은 ID값 : " + joinUserRequest.getUserName());
        System.out.println("flutter 요청 받은 ID값 : " + joinUserRequest.getUserId());
        System.out.println("flutter 요청 받은 PW값 : " + joinUserRequest.getPassword());
        System.out.println("flutter 요청 받은 ID값 : " + joinUserRequest.getPhoneNumber());

        boolean isRegistered = userService.registerUser(joinUserRequest);

        System.out.println("isRegistered = " + isRegistered);
        //반환 true일경우
        if (isRegistered) {
            System.out.println("회원가입 성공: " + joinUserRequest.getUserId());
            return ResponseEntity.ok(joinUserRequest);
        } else { //반환 값이 false일 경우
            System.out.println("회원가입 실패 - 중복된 아이디: " + joinUserRequest.getUserId());
            return ResponseEntity.status(HttpStatus.CONFLICT).body("중복된 아이디입니다."); //409(중복,충돌) 될경우
        }
    }
    //------------------------------------------------------------------------------------------------
    //1대1문의 API
    @PostMapping("/qna")
    public  ResponseEntity<?> qna(@RequestBody UserQnaDTO qnaRequest) {
        System.out.println("------------------ 1대1문의 입력 호출---------------------- ");
        System.out.println("flutter 요청 받은 상담유형값 : " + qnaRequest.getConsultType());
        System.out.println("flutter 요청 받은 내용유형값 : " + qnaRequest.getContentType());
        System.out.println("flutter 요청 받은 제목값 : " + qnaRequest.getTitle());
        System.out.println("flutter 요청 받은 제목값 : " + qnaRequest.getContent());
        System.out.println("flutter 요청 받은 이름값 : " + qnaRequest.getName());
        System.out.println("flutter 요청 받은 전화번호값 : " + qnaRequest.getPhone());
        System.out.println("flutter 요청 받은 이메일값 : " + qnaRequest.getEmail());
        System.out.println("flutter 요청 받은 입력시간값 : " + qnaRequest.getAddTime());

        //요청받은 값을 파라미터로 userService login 메서드 실행
        UserQnaDTO qnaUser = userService.qna(
                qnaRequest.getConsultType(),
                qnaRequest.getContentType(),
                qnaRequest.getTitle(),
                qnaRequest.getContent(),
                qnaRequest.getName(),
                qnaRequest.getPhone(),
                qnaRequest.getEmail(),
                qnaRequest.getAddTime()
        );

        if (qnaUser != null) {
            System.out.println("등록성공");
            return ResponseEntity.ok(qnaUser);
        } else {
            System.out.println("등록불가");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("등록불가"); //400
        }
    }
    //------------------------------------------------------------------------------------------------
    //1대1문의 목록가져오기
    @GetMapping("/qna/list")
    public ResponseEntity<?> getQnaListByPhone(@RequestParam String phone) {
        System.out.println("------------------ 전화번호 기반 1대1문의 리스트 조회 호출 ----------------------");
        System.out.println("요청 전화번호: " + phone);

        List<UserQnaDTO> qnaList = userService.getQnaListByPhone(phone);
        System.out.println("회원 문의 리스트 : " + qnaList);
        if(qnaList != null) {
            return ResponseEntity.ok(qnaList); //200
        }else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("리소스를 찾을 수 없습니다."); //404
        }
    }
    //----------------------------------------------------------------------------------------------
    //1대1문의 내역 삭제하기
    @DeleteMapping("qna/delete")
    public ResponseEntity<?> deleteQnaByTime(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime addtime,
            @RequestParam String phone) {
        System.out.println("요청 addtime : " + addtime);
        System.out.println("요청 phone : " + phone);

        boolean userQnaDTO = userService.deleteQna(addtime, phone);

        if (userQnaDTO) {
            System.out.println("삭제되었습니다. ");
            return ResponseEntity.ok(userQnaDTO);
        }else {
            System.out.println("삭제가 불가합니다.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("삭제불가");
        }

    }

    //------------------------------------------------------------------------------------------------
    //비밀번호 변경
    @PostMapping("/changePw")
    public ResponseEntity<?> changePw(@RequestBody UserChangePasswordDTO changePwRequest) {
        System.out.println("------------------ 비밀번호 변경 호출 ----------------------");
        System.out.println("요청 비밀번호: " + changePwRequest.getNewPassword());
        System.out.println("요청 전화번호: " + changePwRequest.getPhoneNumber());
        //userService changePassword 메서드 실행
        boolean result = userService.changePassword(changePwRequest.getNewPassword(), changePwRequest.getPhoneNumber());

        if (result) {
            System.out.println("비밀번호 변경이 완료됬습니다.");
            return ResponseEntity.ok("비밀번호가 성공적으로 변경되었습니다.");
        } else {
            System.out.println("비밀번호 변경에 실패했습니다.");
            return ResponseEntity.status(HttpStatus.CONFLICT).body("중복된 비밀번호입니다. 변경 실패"); //409(중복,충돌) 될경우
        }
    }
    //------------------------------------------------------------------------------------------------
    //마이페이지 - Pin 번호 등록
    @PostMapping("/register_pinNo")
    public ResponseEntity<?> registerPinNo(@RequestBody UserDTO pinNoRequest) {
        System.out.println("------------------Pin 번호 등록 호출------------------");
        System.out.println("마이페이지 flutter 요청 Pin번호 : " +  pinNoRequest.getPinNo());

        boolean insertPinNo = userService.registerPinNo(pinNoRequest.getPinNo(),pinNoRequest.getPhoneNumber());

        if (insertPinNo) {
            System.out.println("Pin번호 등록이 완료됬습니다.");
            return ResponseEntity.ok("Pin번호 등록이 완료됬습니다.");
        } else {
            System.out.println("핀번호 등록에 실패했습니다.");
            return ResponseEntity.status(HttpStatus.CONFLICT).body("중복된 핀번호입니다. 등록 실패"); //409(중복,충돌) 될경우
        }

    }
}
