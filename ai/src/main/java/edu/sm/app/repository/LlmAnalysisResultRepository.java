package edu.sm.app.repository;

import edu.sm.app.dto.LlmAnalysisResult;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
@Mapper
public interface LlmAnalysisResultRepository extends SmRepository<LlmAnalysisResult, Long> {
    
    // 특정 날짜 범위의 분석 결과 조회 (캘린더용)
    List<LlmAnalysisResult> selectByDateRange(LocalDate startDate, LocalDate endDate) throws Exception;
    
    // 특정 날짜의 분석 결과 조회
    List<LlmAnalysisResult> selectByDate(LocalDate date) throws Exception;
    
    // 분석 타입별 조회
    List<LlmAnalysisResult> selectByAnalysisType(String analysisType) throws Exception;
    
    // 최근 분석 결과 조회 (최신순)
    List<LlmAnalysisResult> selectRecent(int limit) throws Exception;
}
