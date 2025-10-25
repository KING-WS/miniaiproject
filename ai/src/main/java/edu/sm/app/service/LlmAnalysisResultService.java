package edu.sm.app.service;

import edu.sm.app.dto.LlmAnalysisResult;
import edu.sm.app.repository.LlmAnalysisResultRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class LlmAnalysisResultService implements SmService<LlmAnalysisResult, Long> {

    final LlmAnalysisResultRepository llmAnalysisResultRepository;

    @Override
    public void register(LlmAnalysisResult llmAnalysisResult) throws Exception {
        llmAnalysisResultRepository.insert(llmAnalysisResult);
    }

    @Override
    public void modify(LlmAnalysisResult llmAnalysisResult) throws Exception {
        llmAnalysisResultRepository.update(llmAnalysisResult);
    }

    @Override
    public void remove(Long id) throws Exception {
        llmAnalysisResultRepository.delete(id);
    }

    @Override
    public List<LlmAnalysisResult> get() throws Exception {
        return llmAnalysisResultRepository.selectAll();
    }

    @Override
    public LlmAnalysisResult get(Long id) throws Exception {
        return llmAnalysisResultRepository.select(id);
    }

    // 특정 날짜 범위의 분석 결과 조회 (캘린더용)
    public List<LlmAnalysisResult> getByDateRange(LocalDate startDate, LocalDate endDate) throws Exception {
        return llmAnalysisResultRepository.selectByDateRange(startDate, endDate);
    }

    // 특정 날짜의 분석 결과 조회
    public List<LlmAnalysisResult> getByDate(LocalDate date) throws Exception {
        return llmAnalysisResultRepository.selectByDate(date);
    }

    // 분석 타입별 조회
    public List<LlmAnalysisResult> getByAnalysisType(String analysisType) throws Exception {
        return llmAnalysisResultRepository.selectByAnalysisType(analysisType);
    }

    // 최근 분석 결과 조회 (최신순)
    public List<LlmAnalysisResult> getRecent(int limit) throws Exception {
        return llmAnalysisResultRepository.selectRecent(limit);
    }
}
