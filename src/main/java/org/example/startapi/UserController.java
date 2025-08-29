package org.example.startapi;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    // --- 로그인 API ---
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody UserDTO loginRequest) {
        System.out.println("---------------로그인 호출--------------------");
        System.out.println("로그인 ID : " + loginRequest.getUserId());
        System.out.println("로그인 PW : " +  loginRequest.getPassword());

        User loginUser = userService.login(loginRequest.getUserId(), loginRequest.getPassword());

        if (loginUser != null) {
            UserDTO responseDto = convertToUserDto(loginUser); //entity => DTO로 변환작업
            return ResponseEntity.ok(responseDto);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 실패");
        }
    }

    @PostMapping("/login_pinNo")
    public ResponseEntity<?> loginPinNo(@RequestBody UserDTO pinNoRequest) {
        System.out.println("----------핀번호 로그인호출---------");
        System.out.println("로그인 요청 pinNo : " + pinNoRequest.getPinNo());
        User pinNoUser = userService.pinNoLogin(pinNoRequest.getPinNo());
        System.out.println("DB 응답값 : " + pinNoUser);
        if (pinNoUser != null) {
            UserDTO responseDto = convertToUserDto(pinNoUser);
            return ResponseEntity.ok(responseDto);
        } else {
            System.out.println("DB 조회 후 존재하지 않은 핀번호입니다");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }

    // --- 회원가입 API ---
    @PostMapping("/joinUser")
    public ResponseEntity<?> joinUser(@RequestBody UserDTO joinUserRequest) {
        boolean isRegistered = userService.registerUser(joinUserRequest);
        if (isRegistered) {
            return ResponseEntity.ok("회원가입 성공");
        } else {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("중복된 아이디 또는 전화번호입니다.");
        }
    }

    // --- 1대1 문의 API ---
    @PostMapping("/qna")
    public ResponseEntity<?> qna(@RequestBody UserQnaDTO qnaRequest) {
        UserQna savedQna = userService.qna(qnaRequest);
        if (savedQna != null) {
            UserQnaDTO responseDto = convertToQnaDto(savedQna);
            return ResponseEntity.ok(responseDto);
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("등록 불가");
        }
    }

    // --- 1대1 문의 목록 가져오기 ---
    @GetMapping("/qna/list")
    public ResponseEntity<List<UserQnaDTO>> getQnaListByPhone(@RequestParam String phone) {
        List<UserQna> qnaList = userService.getQnaListByPhone(phone);
        List<UserQnaDTO> responseDtoList = qnaList.stream()
                .map(this::convertToQnaDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responseDtoList);
    }

    // --- 1대1 문의 내역 삭제하기 ---
    @DeleteMapping("/qna/delete")
    public ResponseEntity<?> deleteQnaByTime(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime addtime,
            @RequestParam String phone) {
        boolean isDeleted = userService.deleteQna(addtime, phone);
        if (isDeleted) {
            return ResponseEntity.ok("삭제되었습니다.");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("삭제할 항목을 찾을 수 없습니다.");
        }
    }

    // --- 비밀번호 변경 ---
    @PostMapping("/changePw")
    public ResponseEntity<?> changePw(@RequestBody UserChangePasswordDTO changePwRequest) {
        boolean result = userService.changePassword(changePwRequest.getNewPassword(), changePwRequest.getPhoneNumber());
        if (result) {
            return ResponseEntity.ok("비밀번호가 성공적으로 변경되었습니다.");
        } else {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("변경 실패: 사용자를 찾을 수 없거나 기존 비밀번호와 동일합니다.");
        }
    }

    // --- Pin 번호 등록 ---
    @PostMapping("/register_pinNo")
    public ResponseEntity<?> registerPinNo(@RequestBody UserDTO pinNoRequest) {
        boolean isRegistered = userService.registerPinNo(pinNoRequest.getPinNo(), pinNoRequest.getPhoneNumber());
        if (isRegistered) {
            return ResponseEntity.ok("Pin번호 등록이 완료되었습니다.");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("사용자를 찾을 수 없습니다.");
        }
    }

    // --- 주소지 변경 ---
    @PostMapping("/changeAddress")
    public ResponseEntity<?> changeAddress(@RequestBody UserDTO userRequest) {
        User updatedUser = userService.changeAddress(userRequest.getPhoneNumber(), userRequest.getUserAddress());
        if (updatedUser != null) {
            UserDTO responseDto = convertToUserDto(updatedUser);
            return ResponseEntity.ok(responseDto);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("사용자를 찾을 수 없어 변경에 실패했습니다.");
        }
    }

    // --- 주소지 가져오기 ---
    @GetMapping("/getAddress")
    public ResponseEntity<?> getAddress(@RequestParam String phoneNumber) {
        User user = userService.getUserAddress(phoneNumber);
        if (user != null) {
            UserDTO responseDto = convertToUserDto(user);
            return ResponseEntity.ok(responseDto);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("조회 실패");
        }
    }

    // --- Entity to DTO 변환 헬퍼(Helper) 메소드 ---
    private UserDTO convertToUserDto(User user) {
        UserDTO dto = new UserDTO();
        dto.setUserId(user.getUserId());
        // dto.setPassword(null); // 비밀번호는 응답에 포함하지 않음
        dto.setUserName(user.getUserName());
        dto.setUserPoint(user.getUserPoint());
        dto.setPhoneNumber(user.getPhoneNumber());
        dto.setPinNo(user.getPinNo());
        dto.setUserAddress(user.getUserAddress());
        return dto;
    }

    private UserQnaDTO convertToQnaDto(UserQna qna) {
        return new UserQnaDTO(
                qna.getConsultType(),
                qna.getContentType(),
                qna.getTitle(),
                qna.getContent(),
                qna.getName(),
                qna.getPhone(),
                qna.getEmail(),
                qna.getAddTime().toString() // LocalDate -> String
        );
    }
}