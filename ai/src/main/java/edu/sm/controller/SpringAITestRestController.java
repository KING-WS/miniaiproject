package edu.sm.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.LlmAnalysisResult;
import edu.sm.app.service.LlmAnalysisResultService;
import edu.sm.app.springai.service5.AccountBookService;
import edu.sm.app.springai.service5.AccountBookQueryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@Slf4j
@RequestMapping("/springaiTest")
@RequiredArgsConstructor
public class SpringAITestRestController {

    private final LlmAnalysisResultService llmAnalysisResultService;
    private final AccountBookService accountBookService;
    private final AccountBookQueryService accountBookQueryService;
    private final ObjectMapper objectMapper;

    // 영수증 처리 API
    @RequestMapping("/process-receipt")
    public Map<String, Object> processReceipt(@RequestParam("receipt") MultipartFile receipt) {
        Map<String, Object> response = new HashMap<>();

        try {
            // LLM을 통한 영수증 분석 (가게 이름, 주 서비스업 카테고리 포함)
            Map<String, Object> analysisResult = accountBookService.processReceipt(
                    receipt.getContentType(),
                    receipt.getBytes()
            );

            // 분석 결과를 데이터베이스에 저장
            String jsonOutput = objectMapper.writeValueAsString(analysisResult);
            String storeName = (String) analysisResult.get("storeName"); // LLM이 분석한 가게 이름 가져오기
            String businessCategory = (String) analysisResult.get("businessCategory"); // LLM이 분석한 주 서비스업 카테고리 가져오기

            // description에 가게 이름과 상품 목록 포함
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> items = (List<Map<String, Object>>) analysisResult.get("items");
            String itemDescription = "";
            if (items != null && !items.isEmpty()) {
                itemDescription = items.stream()
                        .map(item -> (String) item.get("name"))
                        .collect(Collectors.joining(", "));
            }
            String description = "";
            if (storeName != null && !storeName.isEmpty()) {
                description += storeName + " - ";
            }
            description += "영수증 분석 결과: " + itemDescription;

            LlmAnalysisResult llmResult = LlmAnalysisResult.builder()
                    .inputData("영수증 이미지 분석")
                    .llmOutput(jsonOutput)
                    .analysisType("expense")
                    .analysisDate(LocalDate.parse((String) analysisResult.get("date")))
                    .amount(new BigDecimal(((Number) analysisResult.get("totalAmount")).doubleValue()))
                    .category(businessCategory) // 동적으로 분류된 주 서비스업 카테고리를 저장
                    .description(description) // 가게 이름과 상품 목록을 포함한 설명 저장
                    .modelName("gpt-4-vision")
                    .modelVersion("1.0")
                    .analysisTimestamp(OffsetDateTime.now())
                    .build();

            llmAnalysisResultService.register(llmResult);

            // 프론트엔드로 반환할 응답 구성
            response.put("success", true);
            response.put("status", "completed");
            response.put("date", analysisResult.get("date"));
            response.put("totalAmount", analysisResult.get("totalAmount"));
            response.put("items", analysisResult.get("items"));
            response.put("storeName", storeName); // 가게 이름도 응답에 포함
            response.put("category", businessCategory); // 주 서비스업 카테고리도 응답에 포함

        } catch (Exception e) {
            log.error("영수증 처리 중 오류 발생", e);
            response.put("success", false);
            response.put("error", "영수증 처리 중 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
        }

        return response;
    }

    // 데이터베이스에서 분석 결과 조회 API
    @RequestMapping("/get-analysis-results")
    public Map<String, Object> getAnalysisResults() {
        Map<String, Object> response = new HashMap<>();

        try {
            List<LlmAnalysisResult> results = llmAnalysisResultService.get();
            response.put("success", true);
            response.put("results", results);
        } catch (Exception e) {
            log.error("분석 결과 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("error", "분석 결과 조회 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    // 테스트 데이터 추가 API
    @RequestMapping("/add-test-data")
    public Map<String, Object> addTestData() {
        Map<String, Object> response = new HashMap<>();

        try {
            // 테스트 데이터 생성
            LlmAnalysisResult testData = LlmAnalysisResult.builder()
                    .inputData("테스트 영수증 데이터")
                    .llmOutput("{\"date\":\"2024-01-15\",\"totalAmount\":15000,\"items\":[{\"name\":\"커피\",\"price\":5000},{\"name\":\"샌드위치\",\"price\":10000}]}")
                    .analysisType("expense")
                    .analysisDate(LocalDate.now())
                    .amount(new BigDecimal("15000"))
                    .category("식비")
                    .description("테스트용 영수증 데이터")
                    .modelName("test-model")
                    .modelVersion("1.0")
                    .analysisTimestamp(OffsetDateTime.now())
                    .build();

            llmAnalysisResultService.register(testData);

            response.put("success", true);
            response.put("message", "테스트 데이터가 성공적으로 추가되었습니다.");
        } catch (Exception e) {
            log.error("테스트 데이터 추가 중 오류 발생", e);
            response.put("success", false);
            response.put("error", "테스트 데이터 추가 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    // 가계부 질문 처리 API
    @RequestMapping("/query-account-book")
    public String queryAccountBook(@RequestParam("question") String question) {
        try {
            log.info("가계부 질문 수신: {}", question);
            String answer = accountBookQueryService.query(question);
            log.info("가계부 질문 응답: {}", answer);
            return answer;
        } catch (Exception e) {
            log.error("가계부 질문 처리 중 오류 발생", e);
            return "가계부 질문 처리 중 오류가 발생했습니다: " + e.getMessage();
        }
    }
}