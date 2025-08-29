package org.example.startapi;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final UserQnaRepository userQnaRepository;

    @Autowired
    public UserService(UserRepository userRepository, UserQnaRepository userQnaRepository) {
        this.userRepository = userRepository;
        this.userQnaRepository = userQnaRepository;
    }

    // --- 로그인 및 사용자 조회 ---
    public User login(String userId, String password) {
        return userRepository.findByUserIdAndPassword(userId, password).orElse(null);
    }

    public User pinNoLogin(int userPinNo) {
        if (userPinNo == 0) return null;
        return userRepository.findByPinNo(userPinNo).orElse(null);
    }

    // --- 회원가입 ---
    @Transactional
    public boolean registerUser(UserDTO newUserDto) {
        if (userRepository.existsByUserId(newUserDto.getUserId()) || userRepository.existsByPhoneNumber(newUserDto.getPhoneNumber())) {
            return false; // 중복
        }
        User user = new User();
        user.setUserId(newUserDto.getUserId());
        user.setPassword(newUserDto.getPassword());
        user.setUserName(newUserDto.getUserName());
        user.setUserPoint(newUserDto.getUserPoint());
        user.setPhoneNumber(newUserDto.getPhoneNumber());
        user.setUserAddress(newUserDto.getUserAddress());
        userRepository.save(user);
        return true;
    }

    // --- 1:1 문의 ---
    @Transactional
    public UserQna qna(UserQnaDTO qnaDto) {
        UserQna newQna = new UserQna();
        newQna.setConsultType(qnaDto.getConsultType());
        newQna.setContentType(qnaDto.getContentType());
        newQna.setTitle(qnaDto.getTitle());
        newQna.setContent(qnaDto.getContent());
        newQna.setName(qnaDto.getName());
        newQna.setPhone(qnaDto.getPhone());
        newQna.setEmail(qnaDto.getEmail());
        newQna.setAddTime(LocalDate.parse(qnaDto.getAddTime())); // String -> LocalDate
        return userQnaRepository.save(newQna);
    }

    public List<UserQna> getQnaListByPhone(String phone) {
        return userQnaRepository.findByPhone(phone);
    }

    @Transactional
    public boolean deleteQna(LocalDateTime addTime, String phone) {
        LocalDate addDate = addTime.toLocalDate();
        Optional<UserQna> qnaOptional = userQnaRepository.findByPhoneAndAddTime(phone, addDate);
        if (qnaOptional.isPresent()) {
            userQnaRepository.delete(qnaOptional.get());
            return true;
        }
        return false;
    }

    // --- 사용자 정보 변경 ---
    @Transactional
    public boolean changePassword(String newPassword, String phoneNumber) {
        return userRepository.findByPhoneNumber(phoneNumber)
                .map(user -> {
                    if (user.getPassword().equals(newPassword)) return false;
                    user.setPassword(newPassword);
                    userRepository.save(user);
                    return true;
                })
                .orElse(false);
    }

    @Transactional
    public boolean registerPinNo(int pinNo, String phoneNumber) {
        return userRepository.findByPhoneNumber(phoneNumber)
                .map(user -> {
                    user.setPinNo(pinNo);
                    userRepository.save(user);
                    return true;
                })
                .orElse(false);
    }

    @Transactional
    public User changeAddress(String phoneNumber, String address) {
        return userRepository.findByPhoneNumber(phoneNumber)
                .map(user -> {
                    user.setUserAddress(address);
                    return userRepository.save(user);
                })
                .orElse(null);
    }

    // --- 주소지 조회 ---
    public User getUserAddress(String phoneNumber) {
        return userRepository.findByPhoneNumber(phoneNumber).orElse(null);
    }
}