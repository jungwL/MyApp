package org.example.startapi;

import org.springframework.data.jpa.repository.JpaRepository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface UserQnaRepository extends JpaRepository<UserQna, Long> {

    // 전화번호(phone)를 기준으로 모든 문의 내역을 찾는 메소드
    List<UserQna> findByPhone(String phone);

    // 전화번호(phone)와 문의 등록 날짜(addTime)를 기준으로 특정 문의 내역을 찾는 메소드 (삭제용)
    Optional<UserQna> findByPhoneAndAddTime(String phone, LocalDate addTime);
}