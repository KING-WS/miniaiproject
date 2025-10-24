package edu.sm.app.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Light {
    private String room;
    private boolean on = false;

    public Light(String room) {
        this.room = room;
    }
}
