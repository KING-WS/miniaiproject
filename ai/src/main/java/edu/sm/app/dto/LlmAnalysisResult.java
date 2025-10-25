package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

/**
 * LLM 분석 결과를 저장하는 DTO (사용자 독립적)
 * 캘린더 표시를 위한 날짜와 금액 정보를 포함
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LlmAnalysisResult {
    private Long id;
    private String inputData;
    private String llmOutput;
    private String analysisType; // 'expense', 'income', 'schedule' 등
    private LocalDate analysisDate; // 캘린더 표시용 날짜
    private BigDecimal amount; // 금액 (지출/수입인 경우)
    private String category; // 카테고리
    private String description; // 설명
    private String modelName;
    private String modelVersion;
    private OffsetDateTime analysisTimestamp;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
}