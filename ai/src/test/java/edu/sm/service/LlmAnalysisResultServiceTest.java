package edu.sm.service;

import edu.sm.app.dto.LlmAnalysisResult;
import edu.sm.app.service.LlmAnalysisResultService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

import static org.junit.jupiter.api.Assertions.fail;

@Slf4j
@SpringBootTest
class LlmAnalysisResultServiceTest {

    @Autowired
    LlmAnalysisResultService llmAnalysisResultService;

    @Test
    void register() {
        // --- 1. 테스트 데이터 준비 ---
        LlmAnalysisResult newResult = LlmAnalysisResult.builder()
                .inputData("오늘 점심에 15000원 지출했습니다")
                .llmOutput("{\"type\":\"expense\",\"amount\":15000,\"category\":\"식비\",\"date\":\"2024-01-15\"}")
                .analysisType("expense")
                .analysisDate(LocalDate.now())
                .amount(new BigDecimal("15000"))
                .category("식비")
                .description("점심 식사")
                .modelName("gpt-4")
                .modelVersion("1.0")
                .analysisTimestamp(OffsetDateTime.now())
                .build();

        log.info("새 LLM 분석 결과 등록을 시도합니다: {}", newResult.getAnalysisType());

        try {
            // --- 2. 서비스 메소드 호출 ---
            llmAnalysisResultService.register(newResult);
            log.info("register() 메소드 호출 완료.");

            // --- 3. 검증 ---
            // 등록이 성공했는지만 확인 (조회는 별도 테스트에서)
            log.info("LLM 분석 결과 등록 테스트 성공!");

        } catch (Exception e) {
            // 예외가 발생하면 테스트 실패
            log.error("테스트 중 예외가 발생했습니다.", e);
            fail("테스트 중 예외가 발생했습니다: " + e.getMessage());
        }
    }


}
