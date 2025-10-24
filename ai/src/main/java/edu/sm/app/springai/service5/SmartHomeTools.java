package edu.sm.app.springai.service5;

import edu.sm.app.dto.AirConditioner;
import edu.sm.app.dto.Light;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

@Component
@Slf4j
public class SmartHomeTools {

    private final Map<String, Light> lights = new HashMap<>();
    private final AirConditioner airConditioner = new AirConditioner();

    public SmartHomeTools() {
        // Initialize some lights for demonstration
        lights.put("안방", new Light("안방"));
        lights.put("거실", new Light("거실"));
        lights.put("주방", new Light("주방"));
    }

    @Tool(description = "지정된 방의 조명을 켭니다. 성공 시 '방 이름 조명을 켰습니다.'를 반환합니다.")
    public String turnOnLight(@ToolParam(description = "조명을 켤 방 이름 (예: 안방, 거실, 주방)") String room) {
        if (lights.containsKey(room)) {
            lights.get(room).setOn(true);
            log.info("{} 조명을 켭니다.", room);
            return room + " 조명을 켰습니다.";
        }
        return room + "에 조명이 없습니다.";
    }

    @Tool(description = "지정된 방의 조명을 끕니다. 성공 시 '방 이름 조명을 껐습니다.'를 반환합니다.")
    public String turnOffLight(@ToolParam(description = "조명을 끌 방 이름 (예: 안방, 거실, 주방)") String room) {
        if (lights.containsKey(room)) {
            lights.get(room).setOn(false);
            log.info("{} 조명을 끕니다.", room);
            return room + " 조명을 껐습니다.";
        }
        return room + "에 조명이 없습니다.";
    }

    @Tool(description = "에어컨을 켭니다. 성공 시 '에어컨을 켰습니다.'를 반환합니다.")
    public String turnOnAirConditioner() {
        airConditioner.setOn(true);
        log.info("에어컨을 켭니다.");
        return "에어컨을 켰습니다.";
    }

    @Tool(description = "에어컨을 끕니다. 성공 시 '에어컨을 껐습니다.'를 반환합니다.")
    public String turnOffAirConditioner() {
        airConditioner.setOn(false);
        log.info("에어컨을 끕니다.");
        return "에어컨을 껐습니다.";
    }

    @Tool(description = "에어컨 희망 온도를 설정합니다. 성공 시 '에어컨 온도를 N도로 설정했습니다.'를 반환합니다.")
    public String setAirConditionerTemp(@ToolParam(description = "설정할 온도") int temperature) {
        airConditioner.setTemperature(temperature);
        log.info("에어컨 온도를 {}도로 설정합니다.", temperature);
        return "에어컨 온도를 " + temperature + "도로 설정했습니다.";
    }

    @Tool(description = "모든 스마트홈 기기의 현재 상태를 알려줍니다.")
    public String getDevicesStatus() {
        StringBuilder statusBuilder = new StringBuilder();
        statusBuilder.append("현재 집안 상태는 다음과 같습니다:<br/>");
        statusBuilder.append("<ul>");

        lights.forEach((room, light) -> {
            statusBuilder.append("<li>").append(room).append(" 조명: ")
                         .append(light.isOn() ? "켜짐" : "꺼짐").append("</li>");
        });

        statusBuilder.append("<li>에어컨: ").append(airConditioner.isOn() ? "켜짐" : "꺼짐")
                     .append(" (희망 온도: ").append(airConditioner.getTemperature()).append("도)</li>");

        statusBuilder.append("</ul>");

        String status = statusBuilder.toString();
        log.info("Generated Status HTML: {}", status); // Log the HTML string
        return status;
    }
}
