package edu.sm.app.springai.service5;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel; // Revert to ChatModel import
import org.springframework.stereotype.Service;

// Removed ChatResponse, Generation, List imports

@Service
@Slf4j
public class SmartHomeService {

    private final ChatClient chatClient;
    private final SmartHomeTools smartHomeTools;

    public SmartHomeService(ChatClient.Builder chatClientBuilder, SmartHomeTools smartHomeTools) {
        this.chatClient = chatClientBuilder.build();
        this.smartHomeTools = smartHomeTools;
    }

    public String chat(String userMessage) {
        // Check if the user is asking for the device status
        if (userMessage.contains("현재 집안 상태 알려줘") || userMessage.contains("모든 기기 상태 확인해줘")) {
            String statusHtml = smartHomeTools.getDevicesStatus();
            log.info("Direct Status HTML Response: {}", statusHtml);
            return statusHtml;
        }

        String answer = chatClient.prompt()
                .user(userMessage)
                .tools(smartHomeTools)
                .call()
                .content(); // Directly call .content()

        log.info("AI Response: {}", answer); // Re-added logging
        return answer;
    }
}
