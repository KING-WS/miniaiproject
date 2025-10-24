package edu.sm.app.dto;

import lombok.Data;

@Data
public class AirConditioner {
    private int temperature = 24; // Default temperature
    private boolean on = false;
}
