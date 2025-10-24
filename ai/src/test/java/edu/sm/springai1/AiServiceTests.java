package edu.sm.springai1;

import edu.sm.app.springai.service1.AiService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import reactor.core.publisher.Flux;

@SpringBootTest
@Slf4j
class AiServiceTests {

    @Autowired
    AiService aiService;

    @Test
    void contextLoads() {
        String question = "천안에 맛집 알려줘";
        Flux<String> result = aiService.generateStreamText(question);
        result.collectList().block().stream().forEach(System.out::println);
//        String result = aiService.generateText(question);
//        log.info("result:{}", result);
    }

}
