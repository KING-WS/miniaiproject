package edu.sm.controller;

import edu.sm.app.springai.service3.AiImageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;

import java.io.IOException;

@Controller
@RequestMapping("/jusick")
@RequiredArgsConstructor
@Slf4j
public class JusickController {

    private final AiImageService aiImageService;

    @GetMapping
    public String jusickPage(org.springframework.ui.Model model) {
        model.addAttribute("left", "jusick/left");
        model.addAttribute("center", "jusick/center");
        return "index";
    }

    @PostMapping("/analyzeChart")
    @ResponseBody
    public ResponseEntity<String> analyzeChart(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return new ResponseEntity<>("파일이 비어 있습니다.", HttpStatus.BAD_REQUEST);
        }
        try {
            String question = "이 주식 차트 이미지에서 기술적 분석 패턴(예: 헤드앤숄더, 쌍바닥, 삼각수렴, 골든크로스 등)을 찾아주고, 지지/저항선을 표시해줘. 그리고 이 패턴이 의미하는 바를 자세히 설명해줘.";
            String contentType = file.getContentType();
            byte[] bytes = file.getBytes();

            // AiImageService를 사용하여 이미지 분석
            String analysisResult = aiImageService.imageAnalysis2(question, contentType, bytes);
            log.info("Chart Analysis Result: {}", analysisResult);

            return new ResponseEntity<>(analysisResult, HttpStatus.OK);
        } catch (IOException e) {
            log.error("차트 분석 중 파일 처리 오류 발생", e);
            return new ResponseEntity<>("파일 처리 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (Exception e) {
            log.error("차트 분석 중 AI 서비스 오류 발생", e);
            return new ResponseEntity<>("AI 분석 서비스 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/analyzeNews")
    @ResponseBody
    public ResponseEntity<String> analyzeNews(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return new ResponseEntity<>("파일이 비어 있습니다.", HttpStatus.BAD_REQUEST);
        }
        try {
            String question = "이 뉴스 기사 이미지에서 텍스트를 추출하고, 해당 텍스트의 감성을 긍정(POSITIVE), 중립(NEUTRAL), 부정(NEGATIVE) 중 하나로 분류해줘. 그리고 그 이유를 설명해줘.";
            String contentType = file.getContentType();
            byte[] bytes = file.getBytes();

            // AiImageService를 사용하여 이미지 분석 (OCR 및 감성 분석 포함)
            String analysisResult = aiImageService.imageAnalysis2(question, contentType, bytes);
            log.info("News Analysis Result: {}", analysisResult);

            return new ResponseEntity<>(analysisResult, HttpStatus.OK);
        } catch (IOException e) {
            log.error("뉴스 감성 분석 중 파일 처리 오류 발생", e);
            return new ResponseEntity<>("파일 처리 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (Exception e) {
            log.error("뉴스 감성 분석 중 AI 서비스 오류 발생", e);
            return new ResponseEntity<>("AI 분석 서비스 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}