package org.example.startapi;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    // userId와 password로 사용자를 찾는 메소드 (로그인용)
    Optional<User> findByUserIdAndPassword(String userId, String password);

    // pinNo로 사용자를 찾는 메소드 (핀번호 로그인용)
    Optional<User> findByPinNo(int pinNo);

    // phoneNumber로 사용자를 찾는 메소드 (정보 변경 및 조회용)
    Optional<User> findByPhoneNumber(String phoneNumber);

    // userId가 존재하는지 확인하는 메소드 (회원가입 중복 체크용)
    boolean existsByUserId(String userId);

    // phoneNumber가 존재하는지 확인하는 메소드 (회원가입 중복 체크용)
    boolean existsByPhoneNumber(String phoneNumber);
}