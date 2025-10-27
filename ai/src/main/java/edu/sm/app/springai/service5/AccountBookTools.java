package edu.sm.app.springai.service5;

import edu.sm.app.dto.LlmAnalysisResult;
import edu.sm.app.service.LlmAnalysisResultService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.YearMonth;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
@Slf4j
@RequiredArgsConstructor
public class AccountBookTools {

    private final LlmAnalysisResultService llmAnalysisResultService;

    @Tool(description = """
        현재 날짜를 조회합니다.
        연도, 월, 일 정보를 반환합니다.
        """)
    public String getCurrentDate() {
        LocalDate today = LocalDate.now();
        String result = String.format("오늘은 %d년 %d월 %d일입니다.", 
            today.getYear(), 
            today.getMonthValue(), 
            today.getDayOfMonth());
        log.info(result);
        return result;
    }

    @Tool(description = """
        이번 달의 총 지출 금액을 조회합니다.
        expense 타입의 모든 항목의 금액을 합산하여 반환합니다.
        """)
    public String getTotalExpenseThisMonth() {
        try {
            YearMonth currentMonth = YearMonth.now();
            LocalDate startDate = currentMonth.atDay(1);
            LocalDate endDate = currentMonth.atEndOfMonth();
            
            List<LlmAnalysisResult> results = llmAnalysisResultService.getByDateRange(startDate, endDate);
            BigDecimal total = results.stream()
                .filter(r -> "expense".equals(r.getAnalysisType()))
                .map(LlmAnalysisResult::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
            
            log.info("이번 달 총 지출: {}원", total);
            return String.format("이번 달 총 지출은 %s원입니다.", total);
        } catch (Exception e) {
            log.error("총 지출 조회 실패", e);
            return "총 지출 조회에 실패했습니다.";
        }
    }

    @Tool(description = """
        이번 달에서 가장 비싼 지출 항목을 조회합니다.
        날짜, 금액, 카테고리, 설명 정보를 반환합니다.
        """)
    public String getMostExpensiveItem() {
        try {
            YearMonth currentMonth = YearMonth.now();
            LocalDate startDate = currentMonth.atDay(1);
            LocalDate endDate = currentMonth.atEndOfMonth();
            
            List<LlmAnalysisResult> results = llmAnalysisResultService.getByDateRange(startDate, endDate);
            LlmAnalysisResult maxExpense = results.stream()
                .filter(r -> "expense".equals(r.getAnalysisType()))
                .max(Comparator.comparing(LlmAnalysisResult::getAmount))
                .orElse(null);
            
            if (maxExpense != null) {
                String result = String.format("가장 비싼 지출은 %s에 %s원으로 %s입니다. 카테고리: %s", 
                    maxExpense.getAnalysisDate(), 
                    maxExpense.getAmount(), 
                    maxExpense.getDescription(),
                    maxExpense.getCategory());
                log.info(result);
                return result;
            }
            return "이번 달 지출 내역이 없습니다.";
        } catch (Exception e) {
            log.error("가장 비싼 지출 조회 실패", e);
            return "가장 비싼 지출 조회에 실패했습니다.";
        }
    }

    @Tool(description = """
        특정 날짜의 지출 내역을 조회합니다.
        해당 날짜의 모든 지출 항목과 총액을 반환합니다.
        날짜는 YYYY-MM-DD 형식입니다.
        """)
    public String getExpensesByDate(
        @ToolParam(description = "조회할 날짜 (YYYY-MM-DD 형식)", required = true) String date) {
        try {
            LocalDate targetDate = LocalDate.parse(date);
            List<LlmAnalysisResult> results = llmAnalysisResultService.getByDate(targetDate);
            
            List<LlmAnalysisResult> expenses = results.stream()
                .filter(r -> "expense".equals(r.getAnalysisType()))
                .collect(Collectors.toList());
            
            if (expenses.isEmpty()) {
                return String.format("%s에는 지출 내역이 없습니다.", date);
            }
            
            BigDecimal total = expenses.stream()
                .map(LlmAnalysisResult::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
            
            StringBuilder result = new StringBuilder(String.format("%s의 지출 내역:\n", date));
            for (LlmAnalysisResult expense : expenses) {
                result.append(String.format("- %s원: %s (카테고리: %s)\n", 
                    expense.getAmount(), 
                    expense.getDescription(),
                    expense.getCategory()));
            }
            result.append(String.format("총 %s원입니다.", total));
            
            log.info(result.toString());
            return result.toString();
        } catch (Exception e) {
            log.error("날짜별 지출 조회 실패", e);
            return "날짜별 지출 조회에 실패했습니다.";
        }
    }

    @Tool(description = """
        특정 날짜에 지출 내역을 추가합니다.
        날짜는 YYYY-MM-DD 형식입니다.
        금액은 숫자로 입력합니다.
        설명은 지출 내역에 대한 설명입니다.
        카테고리는 '식비', '교통', '쇼핑' 등입니다.
        """)
    public String addExpense(
        @ToolParam(description = "날짜 (YYYY-MM-DD 형식)", required = true) String date,
        @ToolParam(description = "금액", required = true) double amount,
        @ToolParam(description = "지출 설명", required = true) String description,
        @ToolParam(description = "카테고리", required = false) String category) {
        try {
            LocalDate targetDate = LocalDate.parse(date);
            
            LlmAnalysisResult newExpense = LlmAnalysisResult.builder()
                .inputData("수동 입력")
                .llmOutput(String.format("{\"date\":\"%s\",\"amount\":%f,\"description\":\"%s\"}", date, amount, description))
                .analysisType("expense")
                .analysisDate(targetDate)
                .amount(BigDecimal.valueOf(amount))
                .category(category != null ? category : "기타")
                .description(description)
                .modelName("manual-input")
                .modelVersion("1.0")
                .analysisTimestamp(OffsetDateTime.now())
                .build();
            
            llmAnalysisResultService.register(newExpense);
            
            String result = String.format("%s에 %s원 지출을 추가했습니다. 설명: %s", date, amount, description);
            log.info(result);
            return result;
        } catch (Exception e) {
            log.error("지출 추가 실패", e);
            return "지출 추가에 실패했습니다.";
        }
    }

    @Tool(description = """
        특정 날짜의 특정 금액에 해당하는 지출 내역을 삭제합니다.
        날짜는 YYYY-MM-DD 형식입니다.
        금액이 정확히 일치하는 항목을 삭제합니다.
        """)
    public String deleteExpense(
        @ToolParam(description = "날짜 (YYYY-MM-DD 형식)", required = true) String date,
        @ToolParam(description = "삭제할 금액", required = true) double amount) {
        try {
            LocalDate targetDate = LocalDate.parse(date);
            List<LlmAnalysisResult> results = llmAnalysisResultService.getByDate(targetDate);
            
            LlmAnalysisResult toDelete = results.stream()
                .filter(r -> "expense".equals(r.getAnalysisType()))
                .filter(r -> r.getAmount().compareTo(BigDecimal.valueOf(amount)) == 0)
                .findFirst()
                .orElse(null);
            
            if (toDelete != null) {
                llmAnalysisResultService.remove(toDelete.getId());
                String result = String.format("%s에 %s원 지출을 삭제했습니다.", date, amount);
                log.info(result);
                return result;
            } else {
                return String.format("%s에 %s원 지출 내역을 찾을 수 없습니다.", date, amount);
            }
        } catch (Exception e) {
            log.error("지출 삭제 실패", e);
            return "지출 삭제에 실패했습니다.";
        }
    }

    @Tool(description = """
        이번 달에서 가장 지출이 많았던 날짜를 조회합니다.
        해당 날짜와 총 지출액을 반환합니다.
        """)
    public String getDayWithMostExpenses() {
        try {
            YearMonth currentMonth = YearMonth.now();
            LocalDate startDate = currentMonth.atDay(1);
            LocalDate endDate = currentMonth.atEndOfMonth();
            
            List<LlmAnalysisResult> results = llmAnalysisResultService.getByDateRange(startDate, endDate);
            
            Map<LocalDate, BigDecimal> dailyExpenses = new HashMap<>();
            results.stream()
                .filter(r -> "expense".equals(r.getAnalysisType()))
                .forEach(r -> {
                    LocalDate date = r.getAnalysisDate();
                    dailyExpenses.put(date, 
                        dailyExpenses.getOrDefault(date, BigDecimal.ZERO).add(r.getAmount()));
                });
            
            if (dailyExpenses.isEmpty()) {
                return "이번 달 지출 내역이 없습니다.";
            }
            
            Map.Entry<LocalDate, BigDecimal> maxEntry = dailyExpenses.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .orElse(null);
            
            if (maxEntry != null) {
                String result = String.format("가장 지출이 많았던 날은 %s이며, 총 %s원을 지출했습니다.", 
                    maxEntry.getKey(), 
                    maxEntry.getValue());
                log.info(result);
                return result;
            }
            return "이번 달 지출 내역이 없습니다.";
        } catch (Exception e) {
            log.error("가장 지출이 많았던 날 조회 실패", e);
            return "가장 지출이 많았던 날 조회에 실패했습니다.";
        }
    }

    @Tool(description = """
        이번 달 카테고리별 지출 합계를 조회합니다.
        각 카테고리와 해당 카테고리의 총 지출액을 반환합니다.
        가장 많이 소비한 카테고리를 알 수 있습니다.
        """)
    public String getExpensesByCategory() {
        try {
            YearMonth currentMonth = YearMonth.now();
            LocalDate startDate = currentMonth.atDay(1);
            LocalDate endDate = currentMonth.atEndOfMonth();
            
            List<LlmAnalysisResult> results = llmAnalysisResultService.getByDateRange(startDate, endDate);
            
            Map<String, BigDecimal> categoryExpenses = new HashMap<>();
            results.stream()
                .filter(r -> "expense".equals(r.getAnalysisType()))
                .forEach(r -> {
                    String category = r.getCategory() != null ? r.getCategory() : "기타";
                    categoryExpenses.put(category, 
                        categoryExpenses.getOrDefault(category, BigDecimal.ZERO).add(r.getAmount()));
                });
            
            if (categoryExpenses.isEmpty()) {
                return "이번 달 지출 내역이 없습니다.";
            }
            
            StringBuilder result = new StringBuilder("이번 달 카테고리별 지출:\n");
            categoryExpenses.entrySet().stream()
                .sorted(Map.Entry.<String, BigDecimal>comparingByValue().reversed())
                .forEach(entry -> {
                    result.append(String.format("- %s: %s원\n", entry.getKey(), entry.getValue()));
                });
            
            Map.Entry<String, BigDecimal> maxCategory = categoryExpenses.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .orElse(null);
            
            if (maxCategory != null) {
                result.append(String.format("\n가장 많이 소비한 카테고리는 '%s'이며, %s원을 지출했습니다.", 
                    maxCategory.getKey(), 
                    maxCategory.getValue()));
            }
            
            log.info(result.toString());
            return result.toString();
        } catch (Exception e) {
            log.error("카테고리별 지출 조회 실패", e);
            return "카테고리별 지출 조회에 실패했습니다.";
        }
    }
}

