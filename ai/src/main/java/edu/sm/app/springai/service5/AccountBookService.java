package edu.sm.app.springai.service5;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.content.Media;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.springframework.util.MimeType;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class AccountBookService {

    private final ChatClient chatClient;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    public AccountBookService(ChatModel chatModel) {
        this.chatClient = ChatClient.builder(chatModel).build();
    }

    public Map<String, Object> processReceipt(String contentType, byte[] bytes) {
        Media media = Media.builder()
                .mimeType(MimeType.valueOf(contentType))
                .data(new ByteArrayResource(bytes))
                .build();

        // 프롬프트 수정: 가게 이름과 주 서비스업 카테고리 분류까지 한 번에 요청하도록 강화
        String prompt = "너는 영수증 분석 및 지출 분류 전문가야. 이미지에서 다음 정보를 추출해줘:\n" +
                "1. '결제일시' 또는 '거래일시'를 찾아 날짜를 'YYYY-MM-DD' 형식으로 추출해줘.\n" +
                "2. 영수증에 있는 각 상품의 '상품명'과 '가격'을 추출해줘. 가격은 숫자만.\n" +
                "3. '합계', '결제금액', '승인금액' 중 하나에 해당하는 총 금액(숫자만)을 추출해줘.\n" +
                "4. 영수증에 명시된 가게 이름을 추출해줘.\n" +
                "5. 추출된 가게 이름을 바탕으로, 해당 가게의 주 서비스업 카테고리를 다음 중 하나로 분류해줘: ['편의점', '마트', '음식점', '카페', '주유소', '병원/약국', '교통', '쇼핑', '교육', '문화생활', '미용', '통신', '주거/공과금', '기타'].\n" +
                "결과를 반드시 다음 JSON 형식으로만 반환해줘: " +
                "{\"date\": \"추출한날짜\", \"totalAmount\": 추출한총금액, \"items\": [{\"name\": \"상품명1\", \"price\": 상품가격1}, {\"name\": \"상품명2\", \"price\": 상품가격2}], \"storeName\": \"추출한가게이름\", \"businessCategory\": \"분류한서비스업카테고리\"}";

        UserMessage userMessage = UserMessage.builder()
                .text(prompt)
                .media(media)
                .build();

        String jsonResponse = chatClient.prompt()
                .messages(userMessage)
                .call()
                .content();

        log.info("LLM Response: {}", jsonResponse);

        try {
            // LLM 응답이 마크다운 형식으로 감싸져 있을 경우 순수 JSON만 추출
            if (jsonResponse.contains("```json")) {
                jsonResponse = jsonResponse.substring(jsonResponse.indexOf('{'), jsonResponse.lastIndexOf('}') + 1).trim();
            } else if (jsonResponse.contains("{")) {
                jsonResponse = jsonResponse.substring(jsonResponse.indexOf('{'), jsonResponse.lastIndexOf('}') + 1).trim();
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> extractedData = objectMapper.readValue(jsonResponse, Map.class);

            // 카테고리 유효성 검사 (LLM이 이상한 값을 줄 경우를 대비)
            String businessCategory = (String) extractedData.get("businessCategory");
            List<String> validCategories = List.of(
                "편의점", "마트", "음식점", "카페", "주유소", "병원/약국", "교통", "쇼핑", "교육", "문화생활", "미용", "통신", "주거/공과금", "기타"
            );
            if (businessCategory == null || !validCategories.contains(businessCategory)) {
                extractedData.put("businessCategory", "기타"); // 유효하지 않으면 '기타'로 설정
            }

            return extractedData;

        } catch (Exception e) {
            log.error("영수증 데이터 파싱 오류. 응답: {}", jsonResponse, e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "영수증을 처리할 수 없습니다.");
            errorResponse.put("llmResponse", jsonResponse);
            errorResponse.put("exception", e.getMessage());
            return errorResponse;
        }
    }
}
