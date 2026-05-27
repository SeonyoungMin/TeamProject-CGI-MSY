package com.team404.repository;

import java.util.List;

import com.team404.domain.Report;

public interface ReportRepository {

    // 신고 등록
    void insert(Report report);

    // 신고 목록 전체 (관리자용)
    List<Report> findAll();

    // 타입별 신고 목록
    List<Report> findByTargetType(String targetType);

    // 신고 상태 변경 (대기 → 처리완료)
    void updateStatus(int reportNo, String status);

    // 중복 신고 확인 (같은 사람이 같은 대상을 이미 신고했는지)
    boolean existsReport(int reporterNo, String targetType, int targetNo);
    
    // 신고 처리 상태 드롭다운
    List<Report> findByStatus(String status);

}