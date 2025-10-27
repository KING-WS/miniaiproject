# Spring AI 기반 일상 생활 지능형 어시스턴트

> Spring AI 프레임워크를 활용하여 일상생활의 다양한 영역에서 지능형 서비스를 제공하는 통합 AI 웹 애플리케이션.

---

## 👥 팀원
- 김우성
- 정승혁
- 구민우
- 신창영

---

## ✨ 주요 기능

### 🏠 스마트홈 AI
-   **자연어 기반 기기 제어**: "거실 불 켜줘", "에어컨 22도로 설정해줘" 등 자연어 명령으로 스마트홈 기기를 제어함.
-   **음성 인식 입력**: Web Speech API를 활용하여 음성으로 명령 입력 가능.
-   **실시간 상태 모니터링**: 현재 집안의 모든 기기 상태(조명, 에어컨 등)를 실시간으로 확인할 수 있음.
-   **다중 기기 지원**: 안방, 거실, 주방 조명 및 에어컨 온도 조절 등 여러 기기를 통합 제어함.
-   **AI 컨텍스트 이해**: Spring AI의 Function Calling 기능을 활용하여 사용자 의도를 파악하고 적절한 기기 제어 함수를 자동 호출함.

### 💰 가계부 AI (영수증 스캐너)
-   **영수증 자동 스캔 및 분석**: 웹캠으로 영수증을 촬영하면 AI가 자동으로 날짜, 가게명, 상품 목록, 총 금액, 카테고리를 추출함.
-   **지능형 카테고리 분류**: LLM이 가게 정보를 바탕으로 지출 카테고리를 자동 분류함 (편의점, 마트, 음식점, 카페, 주유소, 병원/약국, 교통, 쇼핑, 교육, 문화생활, 미용, 통신, 주거/공과금, 기타).
-   **자동 캘린더 등록**: 분석된 영수증 정보가 자동으로 FullCalendar에 등록되어 월별 지출 내역을 시각적으로 확인 가능함.
-   **AI 어시스턴트 (플로팅 버튼)**: 우측 하단 플로팅 버튼을 통해 AI에게 가계부 질문 가능.
    - "이번 달 총 지출은?"
    - "가장 비싼 지출은?"
    - "22일에 편의점 5000원 추가해줘"
    - "어제 지출 삭제해줘"
-   **자연어 기반 CRUD**: AI가 자연어를 이해하여 지출 추가, 삭제, 조회 등의 작업을 데이터베이스에 반영함.
-   **상세 내역 모달**: 캘린더의 이벤트 클릭 시 상품별 상세 내역을 확인할 수 있음.

### ♻️ 분리수거 맨
-   **실시간 물품 분석**: 웹캠으로 쓰레기를 비추면 AI가 이미지를 분석하여 물품을 인식함.
-   **맞춤형 분리수거 가이드**: 인식된 물품에 대한 구체적인 분리수거 방법을 상세히 안내함.
-   **즉각적인 피드백**: '분류하기' 버튼 클릭 시 실시간으로 분석 결과를 제공함.
-   **이미지 기반 AI 추론**: Spring AI의 Multimodal 기능을 활용하여 이미지를 LLM에 전달하고 분류 가이드를 생성함.

### 📈 주식 분석 AI
-   **차트 패턴 분석**: 주식 차트 이미지를 업로드하면 AI가 기술적 분석 패턴(헤드앤숄더, 쌍바닥, 삼각수렴, 골든크로스 등)을 식별하고 지지/저항선을 분석함.
-   **뉴스 감성 분석**: 뉴스 기사 캡처 이미지에서 텍스트를 추출(OCR)하고, 감성을 긍정/중립/부정으로 분류하여 투자 판단을 지원함.
-   **시각적 인사이트 제공**: 분석 결과를 구조화된 형태로 제공하여 투자자의 의사결정을 돕음.
-   **이미지 기반 멀티모달 분석**: Spring AI의 Vision API를 활용하여 이미지 내용을 이해하고 전문적인 금융 분석을 수행함.

---

## 🛠️ 기술 스택

| 구분 | 기술 스택 |
| :--- | :--- |
| **Backend** | `Java 17`, `Spring Boot 3.x`, `Spring AI`, `MyBatis`, `PostgreSQL` |
| **Frontend** | `JSP`, `JavaScript (ES6+)`, `jQuery`, `Bootstrap 5`, `FullCalendar.js` |
| **AI** | `OpenAI (gpt-4o)`, `Vision API (Multimodal)`, `Function Calling`, `OCR` |
| **Database** | `PostgreSQL 16`, `Pgvector` (벡터 데이터 저장 및 검색) |
| **ETC** | `Web Speech API` (음성 인식), `Jasypt` (설정 파일 암호화), `Lombok` |

---

## 🚀 기술적 특징

### Spring AI Function Calling 활용
-   **스마트홈 AI**: `@Tool` 어노테이션을 활용한 Function Calling으로 사용자의 자연어 명령을 파싱하여 적절한 기기 제어 함수(`turnOnLight`, `setAirConditionerTemp` 등)를 자동 호출함.
-   **가계부 AI**: 사용자 질문("이번 달 총 지출은?")을 AI가 이해하고 적절한 도구 함수(`getTotalExpenseThisMonth`, `addExpense` 등)를 자동으로 선택 및 실행함.
-   **컨텍스트 인식**: AI가 대화 맥락을 이해하여 복잡한 요청도 정확하게 처리함.

### Multimodal AI (Vision API) 적용
-   **영수증 OCR**: 카메라로 촬영한 영수증 이미지를 Vision API로 전송하여 텍스트 추출 및 구조화된 데이터로 변환함.
-   **분리수거 물품 인식**: 웹캠 이미지를 AI가 분석하여 물품을 식별하고 분리수거 방법을 안내함.
-   **주식 차트 분석**: 차트 이미지에서 기술적 패턴을 인식하고 전문적인 분석을 제공함.
-   **뉴스 감성 분석**: 뉴스 이미지에서 텍스트를 추출하고 감성을 분류함.

### 동적 프롬프트 엔지니어링
-   사용자의 자연어 입력과 현재 컨텍스트(날짜, 기기 상태 등)를 바탕으로 **동적으로 시스템 프롬프트를 생성**하여 AI의 응답 정확도를 향상시킴.
-   가계부 AI에서는 현재 날짜 정보를 동적으로 프롬프트에 포함하여 "22일", "이번 달" 등의 표현을 정확하게 해석함.
-   영수증 분석 시 **구조화된 JSON 응답**을 요청하는 프롬프트를 사용하여 안정적인 데이터 파싱을 보장함.

### 음성 인터페이스 (Web Speech API)
-   `webkitSpeechRecognition` API를 활용하여 **키보드 없이 음성만으로 AI와 상호작용** 가능함.
-   스마트홈 제어를 핸즈프리로 수행할 수 있어 사용성이 크게 향상됨.

### 실시간 데이터 동기화
-   **영수증 분석 후 자동 캘린더 갱신**: 영수증 분석이 완료되면 AJAX로 캘린더를 자동 새로고침하여 실시간으로 지출 내역을 반영함.
-   **스마트홈 상태 실시간 업데이트**: 기기 제어 명령 실행 후 현재 상태를 자동으로 갱신하여 사용자에게 즉각적인 피드백을 제공함.


### 비동기 통신 기반의 동적 UI
-   모든 AI 기능 요청은 `Fetch API`와 `AJAX`를 통해 비동기 처리되어, AI 응답 처리 중에도 UI 사용이 가능함.
-   **실시간 로딩 표시**: AI 분석 중에는 "분석 중...", "질문 처리 중..." 등의 피드백을 제공하여 사용자 경험을 개선함.

### 데이터베이스 통합
-   **PostgreSQL + MyBatis**: 영수증 분석 결과를 데이터베이스에 영구 저장하고, AI가 이 데이터를 조회/수정/삭제할 수 있음.
-   **LLM 분석 결과 저장소**: 모든 가계부 데이터를 `llm_analysis_result` 테이블에 저장하여 월별 통계, 카테고리별 분석 등이 가능함.

---

## 📂 프로젝트 구조

```
c:\miniaiproject\ai\
├── src\
│   ├── main\
│   │   ├── java\
│   │   │   └── edu\sm\
│   │   │       ├── app\
│   │   │       │   ├── dto\                         # 데이터 전송 객체
│   │   │       │   │   ├── AirConditioner.java
│   │   │       │   │   ├── Light.java
│   │   │       │   │   └── LlmAnalysisResult.java
│   │   │       │   ├── repository\                  # 데이터 접근 계층
│   │   │       │   ├── service\                     # 비즈니스 로직
│   │   │       │   └── springai\
│   │   │       │       └── service5\                # Spring AI 서비스들
│   │   │       │           ├── SmartHomeService.java
│   │   │       │           ├── SmartHomeTools.java
│   │   │       │           ├── AccountBookService.java
│   │   │       │           ├── AccountBookQueryService.java
│   │   │       │           └── AccountBookTools.java
│   │   │       ├── controller\                      # REST 컨트롤러
│   │   │       │   ├── SpringAI5Controller.java
│   │   │       │   ├── Ai5Controller.java
│   │   │       │   └── JusickController.java
│   │   │       └── config\                          # 설정 클래스
│   │   ├── resources\
│   │   │   ├── application.yml
│   │   │   ├── mapper\                              # MyBatis 매퍼
│   │   │   └── static\
│   │   │       ├── css\
│   │   │       ├── js\
│   │   │       └── image\
│   │   └── webapp\
│   │       └── views\
│   │           └── springai5\                       # JSP 뷰
│   │               ├── homeai.jsp                   # 스마트홈 AI
│   │               ├── scannerai.jsp                # 가계부 AI
│   │               ├── ai4.jsp                      # 분리수거 맨
│   │               └── ai5.jsp                      # 주식 분석 AI
│   └── test\                                        # 테스트 코드
├── build.gradle
└── README.md
```

---

**주요 기능:**
- 자연어/음성 명령으로 조명, 에어컨 제어
- 실시간 기기 상태 모니터링
- AI 대화 히스토리 표시

### 💰 가계부 AI (영수증 스캐너)
<img width="1900" height="895" alt="가계부 AI - 캘린더 뷰" src="https://github.com/user-attachments/assets/accountbook-calendar" />

**캘린더 기능:**
- 월별 지출 내역 시각화
- 일자별 지출 금액 표시
- 카테고리별 색상 구분

<img width="1900" height="895" alt="가계부 AI - 영수증 스캔" src="https://github.com/user-attachments/assets/receipt-scanner" />

**영수증 스캔 기능:**
- 실시간 웹캠 미리보기
- 영수증 캡쳐 및 OCR 분석
- 자동 항목 추출 (날짜, 가게명, 상품, 금액, 카테고리)

<img width="1900" height="895" alt="가계부 AI - AI 어시스턴트" src="https://github.com/user-attachments/assets/ai-assistant-floating" />

**AI 어시스턴트 (플로팅 버튼):**
- 우측 하단 플로팅 버튼으로 언제든 접근
- 자연어 질의응답
- 지출 추가/삭제 명령

### ♻️ 분리수거 맨
<img width="1900" height="895" alt="분리수거 맨 화면" src="https://github.com/user-attachments/assets/recycling-helper" />

**주요 기능:**
- 웹캠으로 물품 촬영
- AI 이미지 인식 및 분류
- 상세한 분리수거 방법 안내

### 📈 주식 분석 AI
<img width="1900" height="895" alt="주식 분석 AI - 차트 분석" src="https://github.com/user-attachments/assets/stock-chart-analysis" />

**차트 패턴 분석:**
- 기술적 분석 패턴 자동 인식
- 지지/저항선 분석
- 패턴 의미 해석 및 전망 제시

<img width="1900" height="895" alt="주식 분석 AI - 뉴스 감성 분석" src="https://github.com/user-attachments/assets/stock-news-sentiment" />

**뉴스 감성 분석:**
- 이미지에서 텍스트 추출 (OCR)
- 감성 분류 (긍정/중립/부정)
- 투자 판단 근거 제시

---

## 🎯 핵심 기술 구현

### 1. Spring AI Function Calling - 스마트홈 제어

```java
@Component
@Slf4j
public class SmartHomeTools {
    
    @Tool(description = "지정된 방의 조명을 켭니다.")
    public String turnOnLight(
        @ToolParam(description = "조명을 켤 방 이름") String room) {
        if (lights.containsKey(room)) {
            lights.get(room).setOn(true);
            return room + " 조명을 켰습니다.";
        }
        return room + "에 조명이 없습니다.";
    }
    
    @Tool(description = "에어컨 희망 온도를 설정합니다.")
    public String setAirConditionerTemp(
        @ToolParam(description = "설정할 온도") int temperature) {
        airConditioner.setTemperature(temperature);
        return "에어컨 온도를 " + temperature + "도로 설정했습니다.";
    }
}
```

### 2. Vision API - 영수증 OCR 및 분석

```java
@Service
public class AccountBookService {
    
    public Map<String, Object> processReceipt(String contentType, byte[] bytes) {
        Media media = Media.builder()
            .mimeType(MimeType.valueOf(contentType))
            .data(new ByteArrayResource(bytes))
            .build();
        
        String prompt = """
            영수증 이미지에서 다음 정보를 추출해줘:
            1. 날짜 (YYYY-MM-DD 형식)
            2. 상품명과 가격 목록
            3. 총 금액
            4. 가게 이름
            5. 서비스업 카테고리 분류
            
            결과를 JSON 형식으로 반환:
            {"date": "날짜", "totalAmount": 금액, "items": [...], 
             "storeName": "가게명", "businessCategory": "카테고리"}
            """;
        
        String jsonResponse = chatClient.prompt()
            .messages(UserMessage.builder()
                .text(prompt)
                .media(media)
                .build())
            .call()
            .content();
            
        return parseAndSaveToDatabase(jsonResponse);
    }
}
```

### 3. 가계부 AI Tools - 자연어 CRUD

```java
@Component
@Slf4j
@RequiredArgsConstructor
public class AccountBookTools {
    
    @Tool(description = "이번 달의 총 지출 금액을 조회합니다.")
    public String getTotalExpenseThisMonth() {
        // 데이터베이스에서 이번 달 지출 합계 조회
        BigDecimal total = llmAnalysisResultService.getTotalExpenseThisMonth();
        return String.format("이번 달 총 지출은 %,d원입니다.", total.intValue());
    }
    
    @Tool(description = "새로운 지출을 추가합니다.")
    public String addExpense(
        @ToolParam(description = "지출 날짜 (YYYY-MM-DD)") String date,
        @ToolParam(description = "지출 금액") int amount,
        @ToolParam(description = "지출 카테고리") String category) {
        
        LlmAnalysisResult result = new LlmAnalysisResult();
        result.setAnalysisDate(LocalDate.parse(date));
        result.setAmount(BigDecimal.valueOf(amount));
        result.setCategory(category);
        result.setAnalysisType("expense");
        
        llmAnalysisResultService.add(result);
        return String.format("%s에 %,d원 지출을 추가했습니다.", date, amount);
    }
}
```

### 4. 플로팅 AI 어시스턴트 UI

```javascript
let ai_center = {
    init: function() {
        // 플로팅 버튼 클릭시 모달 토글
        $('#floatingAiBtn').on('click', () => {
            $('#aiAssistantModal').toggle();
        });
        
        // 질문하기
        $('#askBtn').on('click', () => {
            this.askQuestion();
        });
    },
    
    askQuestion: function() {
        const question = $('#accountQuestion').val().trim();
        
        $.ajax({
            url: '/springaiTest/query-account-book',
            type: 'GET',
            data: { question: question },
            success: function(response) {
                $('#aiResponse').text(response);
                
                // AI가 데이터를 추가/삭제한 경우 캘린더 새로고침
                if (response.includes('추가') || response.includes('삭제')) {
                    calendar_center.loadEvents();
                }
            }
        });
    }
};
```

---

## 🔧 설치 및 실행

### 사전 요구사항
- **JDK 17** 이상
- **PostgreSQL 16** 이상
- **Gradle 8.x**
- **OpenAI API Key**

### 환경 설정

1. **프로젝트 클론**
```bash
git clone https://github.com/your-repo/spring-ai-assistant.git
cd spring-ai-assistant
```

2. **PostgreSQL 데이터베이스 생성**
```sql
CREATE DATABASE aidb;
CREATE EXTENSION vector;  -- pgvector 확장 설치
```

3. **application.yml 설정**
```yaml
spring:
  ai:
    openai:
      api-key: ${OPENAI_API_KEY}
      chat:
        options:
          model: gpt-4o
  datasource:
    url: jdbc:postgresql://localhost:5432/aidb
    username: your_username
    password: your_password
```

4. **데이터베이스 테이블 생성**
```bash
# src/main/resources/sql/datatable.sql 실행
psql -U your_username -d aidb -f src/main/resources/sql/datatable.sql
```

### 실행

```bash
# Gradle 빌드
./gradlew clean build

# 애플리케이션 실행
./gradlew bootRun
```

브라우저에서 `http://localhost:8080` 접속

---

## 📊 주요 API 엔드포인트

| 기능 | Method | Endpoint | 설명 |
|------|--------|----------|------|
| 스마트홈 제어 | POST | `/springai5/smarthome` | 자연어 명령 처리 |
| 영수증 분석 | POST | `/springaiTest/process-receipt` | 영수증 이미지 OCR 및 분석 |
| 가계부 질의 | GET | `/springaiTest/query-account-book` | AI 어시스턴트 질문 처리 |
| 분석 결과 조회 | GET | `/springaiTest/get-analysis-results` | 캘린더용 데이터 조회 |
| 분리수거 분석 | POST | `/ai5/recycling` | 물품 이미지 분류 |
| 차트 분석 | POST | `/jusick/analyzeChart` | 주식 차트 패턴 분석 |
| 뉴스 감성 분석 | POST | `/jusick/analyzeNews` | 뉴스 이미지 감성 분류 |

---





