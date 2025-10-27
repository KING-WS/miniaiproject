package edu.sm.app.springai.service5;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Service
@Slf4j
public class AccountBookQueryService {
    
    private final ChatClient chatClient;
    
    @Autowired
    private AccountBookTools accountBookTools;
    
    public AccountBookQueryService(ChatModel chatModel) {
        this.chatClient = ChatClient.builder(chatModel).build();
    }
    
    /**
     * 가계부에 대한 질문을 처리합니다.
     * LLM이 사용자의 질문을 이해하고 적절한 도구를 호출하여 답변을 생성합니다.
     */
    public String query(String question) {
        log.info("가계부 질문 처리: {}", question);
        
        // 현재 날짜 정보를 동적으로 생성
        LocalDate today = LocalDate.now();
        String currentDate = today.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"));
        int year = today.getYear();
        int month = today.getMonthValue();
        
        String systemPrompt = String.format("""
                당신은 가계부 관리 전문 AI 어시스턴트입니다.
                
                **중요: 오늘 날짜는 %s입니다.**
                현재 연도는 %d년, 현재 월은 %d월입니다.
                
                사용자의 질문을 이해하고, 제공된 도구를 사용하여 정확한 답변을 제공하세요.
                
                사용 가능한 도구들:
                - getCurrentDate: 현재 날짜 조회
                - getTotalExpenseThisMonth: 이번 달 총 지출 조회
                - getMostExpensiveItem: 이번 달 가장 비싼 지출 조회
                - getExpensesByDate: 특정 날짜의 지출 내역 조회
                - addExpense: 새로운 지출 추가
                - deleteExpense: 특정 지출 삭제
                - getDayWithMostExpenses: 가장 지출이 많았던 날 조회
                - getExpensesByCategory: 카테고리별 지출 조회
                
                사용자가 날짜를 "22일", "이번 달 22일" 등으로 표현하면, 
                현재 연도(%d년)와 현재 월(%d월)을 기준으로 YYYY-MM-DD 형식으로 변환하세요.
                예: "22일" -> "%d-%02d-22"
                
                사용자가 "지워줘", "삭제해줘" 등으로 요청하면 deleteExpense 도구를 사용하세요.
                사용자가 "추가해줘", "놓아줘", "기록해줘" 등으로 요청하면 addExpense 도구를 사용하세요.
                
                답변은 친절하고 이해하기 쉽게 작성하세요.
                금액은 항상 쉼표를 사용하여 표시하세요. (예: 10,000원)
                """, currentDate, year, month, year, month, year, month);
        
        String answer = chatClient.prompt()
            .system(systemPrompt)
            .user(question)
            .tools(accountBookTools)
            .call()
            .content();
        
        log.info("가계부 질문 응답: {}", answer);
        return answer;
    }
}

