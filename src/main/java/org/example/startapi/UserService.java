package org.example.startapi;

import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserService {
    private List<UserDTO> usersList = new ArrayList<>(); //회원정보 리스트
    private List<UserQnaDTO> qnaList = new ArrayList<>(); //1대1문의 리스트

    public UserService() {
        //-------------------------------------------회원 리스트--------------------------------------------------------------------
        usersList.add(new UserDTO("test1@test.com", "1234", "홍길동", 100, "01011111111",1111));
        usersList.add(new UserDTO("test2@test.com", "abcd", "김철수", 200, "01022222222",2222));
        usersList.add(new UserDTO("son@test.com", "123456789@", "손흥민", 1200, "01033333333",3333));
        //------------------------------------------1대1문의 리스트-------------------------------------------------------------------
        qnaList.add(new UserQnaDTO("칭찬","정보서비스","테스트","문의내용","홍길동","01011111111","test1@test.com","2025-06-06"));
        qnaList.add(new UserQnaDTO("칭찬","이벤트","이벤트 당첨됬습니다.","이벤트 당첨됬는데 수령지를 알고싶습니다.","홍길동","01011111111","test1@test.com","2025-06-08"));
        qnaList.add(new UserQnaDTO("칭찬","이벤트","이벤트 당첨됬습니다.","이벤트 수령지.","손흥민","01033333333","son@test.com","2025-05-13"));
    }
    //-------------------------------------------------------------------------------------
    // 로그인 검증 메서드
    public UserDTO login(String userId, String password) {
        for (UserDTO user : usersList) {
            if (user.getUserId().equals(userId) && user.getPassword().equals(password)) {
                return user;
            }
        }
        return null;
    }
    //핀번호 로그인 메서드
    public UserDTO pinNoLogin(int userPinNo) {
        for (UserDTO user : usersList) {
            if (user.getPinNo() == userPinNo) {
                return user;
            }
        }
        return null;
    }
    //---------------------------------------------------------------------------
    // 회원가입: 아이디 또는 전화번호 중복 검사 메서드
    public boolean registerUser(UserDTO newUser) {
        for (UserDTO user : usersList) {
            if (user.getUserId().equals(newUser.getUserId())
                    || user.getPhoneNumber().equals(newUser.getPhoneNumber())) {
                return false; // 중복된 아이디 또는 전화번호
            }
        }
        usersList.add(newUser);
        return true;
    }
    //------------------------------------------------------------------------------
    // 1대1 문의 등록 메서드
    public UserQnaDTO qna(String consultType, String contentType, String title,
                          String content, String name, String phone, String email, String addTime) {
        UserQnaDTO newQna = new UserQnaDTO(consultType, contentType, title, content, name, phone, email, addTime);
        qnaList.add(newQna); //매개변수 값들을 리스트에 담는다.
        return newQna;
    }
    // 전화번호 기준 1:1 문의 목록 반환(1:1문의 탭 선택시  실행)
    public List<UserQnaDTO> getQnaListByPhone(String phone) {
        return qnaList.stream() // 스크림 생성
                .filter(qna -> qna.getPhone() != null && qna.getPhone().equals(phone)) //qna가 phone이 null값이 아니고 qnaList에 저장된 phoneNumber값이랑 매개변수 phone 값이랑 같은 경우
                .collect(Collectors.toList()); // true 값만 리스트에 담는다.
    }
    //------------------------------------------------------------------------------
    // 비밀번호 변경 메서드
    public boolean changePassword(String cPassword, String phoneNumber) {
        for (UserDTO user : usersList) {
            // 전화번호 일치하는 사용자 찾기
            if (user.getPhoneNumber().equals(phoneNumber)) {
                // 새 비밀번호가 기존 비밀번호와 동일한 경우
                if (user.getPassword().equals(cPassword)) {
                    return false; // 변경 불가
                }
                // 비밀번호 변경 처리
                user.setPassword(cPassword);
                return true;
            }
        }
        // 해당 전화번호의 사용자가 없는 경우
        return false;
    }
    //------------------------------------------------------------------------------
    // Pin 번호 등록 메서드
    public boolean registerPinNo(int pinNo , String phoneNumber) {
        for (UserDTO user : usersList) {
            if(user.getPhoneNumber().equals(phoneNumber)) {
                user.setPinNo(pinNo);
                return true;
            }
        }
        return false;
    }
}
