package edu.sm.app.springai.service3;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.content.Media;
import org.springframework.ai.image.ImageMessage;
import org.springframework.ai.image.ImageModel;
import org.springframework.ai.image.ImagePrompt;
import org.springframework.ai.image.ImageResponse;
import org.springframework.ai.openai.OpenAiImageOptions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.springframework.util.MimeType;
import reactor.core.publisher.Flux;

import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class AiImageService {
  private ChatClient chatClient;
  private ImageModel imageModel;

  public AiImageService(ChatClient.Builder chatClientBuilder, ImageModel imageModel) {
    this.imageModel = imageModel;
    chatClient = chatClientBuilder.build();
  }

  // ##### 이미지 분석 메소드 #####
  public Flux<String> imageAnalysis(String question, String contentType, byte[] bytes) {
    // 시스템 메시지 생성
    SystemMessage systemMessage = SystemMessage.builder()
            .text("""
          당신은 이미지 분석 전문가입니다.   
          사용자 질문에 맞게 이미지를 분석하고 답변을 한국어로 하세요. 
        """)
            .build();

    // 미디어 생성
    Media media = Media.builder()
            .mimeType(MimeType.valueOf(contentType))
            .data(new ByteArrayResource(bytes))
            .build();

    // 사용자 메시지 생성
    UserMessage userMessage = UserMessage.builder()
            .text(question)
            .media(media)
            .build();

    // 프롬프트 생성
    Prompt prompt = Prompt.builder()
            .messages(systemMessage, userMessage)
            .build();

    // LLM에 요청하고, 응답받기
    Flux<String> flux = chatClient.prompt(prompt)
            .stream()
            .content();
    return flux;
  }


  // ##### 이미지 분석 메소드 #####
  public String imageAnalysis2(String question, String contentType, byte[] bytes) {
    // 시스템 메시지 생성
    SystemMessage systemMessage = SystemMessage.builder()
            .text("""
          당신은 이미지 분석 전문가입니다.   
          사용자 질문에 맞게 이미지를 분석하고 답변을 한국어로 하세요. 
        """)
            .build();

    // 미디어 생성
    Media media = Media.builder()
            .mimeType(MimeType.valueOf(contentType))
            .data(new ByteArrayResource(bytes))
            .build();

    // 사용자 메시지 생성
    UserMessage userMessage = UserMessage.builder()
            .text(question)
            .media(media)
            .build();

    // 프롬프트 생성
    Prompt prompt = Prompt.builder()
            .messages(systemMessage, userMessage)
            .build();

    // LLM에 요청하고, 응답받기
    String result = chatClient.prompt(prompt)
            .call()
            .content();
    return result;
  }

  public String getRecyclingSuggestion(String contentType, byte[] bytes) {
    // 1. Define the persona with a System Message
    SystemMessage systemMessage = SystemMessage.builder()
            .text("""
          당신은 대한민국 분리수거 전문가입니다.
          이미지를 보고 어떤 물건인지 식별한 후, 그 물건을 어떻게 분리수거해야 하는지 단계별로 설명해주세요.
          답변은 두 부분으로 구성됩니다:
          - 품목: [물건 이름]
          - 분리수거 방법: [단계별 설명]
        """)
            .build();

    // 2. Create the media object from the image bytes
    Media media = Media.builder()
            .mimeType(MimeType.valueOf(contentType))
            .data(new ByteArrayResource(bytes))
            .build();

    // 3. Create the user message with the image
    UserMessage userMessage = UserMessage.builder()
            .text("이 이미지 속 물건의 분리수거 방법을 알려주세요.")
            .media(media)
            .build();

    // 4. Create the prompt
    Prompt prompt = Prompt.builder()
            .messages(systemMessage, userMessage)
            .build();

    // 5. Call the AI model and get the response
    return chatClient.prompt(prompt)
            .call()
            .content();
  }


  // ##### 이미지를 새로 생성하는 메소드 #####
  public String generateImage(String description) {
    // 한글 질문을 영어 질문으로 번역
    String englishDescription = koToEn(description);

    // 이미지 설명을 포함하는 ImageMessage 생성
    ImageMessage imageMessage = new ImageMessage(englishDescription);

    // gpt-image-1 옵션 설정
    /*
    OpenAiImageOptions imageOptions = OpenAiImageOptions.builder()
        .model("gpt-image-1")
        .quality("low")
        .width(1536)
        .height(1024)
        .N(1)
        .build();
  */
    // dall-e 시리즈 옵션 설정
    OpenAiImageOptions imageOptions = OpenAiImageOptions.builder()
            .model("dall-e-3")
            .responseFormat("b64_json")
            .width(1024)
            .height(1024)
            .N(1)
            .build();

    // 프롬프트 생성
    List<ImageMessage> imageMessageList = List.of(imageMessage);
    ImagePrompt imagePrompt = new ImagePrompt(imageMessageList, imageOptions);

    // 모델 호출 및 응답 받기
    ImageResponse imageResponse = imageModel.call(imagePrompt);

    // base64로 인코딩된 이미지 문자열 얻기
    String b64Json = imageResponse.getResult().getOutput().getB64Json();
    return b64Json;
  }

  private String koToEn(String text) {
    String question = """
          당신은 번역사입니다. 아래 한글 문장을 영어 문장으로 번역해주세요.
          %s
        """.formatted(text);

    // UserMessage 생성
    UserMessage userMessage = UserMessage.builder()
            .text(question)
            .build();

    // Prompt 생성
    Prompt prompt = Prompt.builder()
            .messages(userMessage)
            .build();

    // LLM을 호출하고 텍스트 답변 얻기
    String englishDescription = chatClient.prompt(prompt).call().content();
    return englishDescription;
  }
}