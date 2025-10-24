package edu.sm.controller;

import edu.sm.app.springai.service5.HeatingSystemService;
import edu.sm.app.springai.service5.SmartHomeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model; // Added import for Model
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/springai5")
public class SpringAI5Controller {

    String dir = "springai5/"; // Added dir variable

    @Autowired
    private SmartHomeService smartHomeService;
    @Autowired
    private HeatingSystemService heatingSystemService;

    // Added default mapping for /springai5
    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center", dir + "center"); // Changed to dir + "center"
        model.addAttribute("left", dir + "left");
        return "index";
    }

    // Modified homeai method to match SpringAI4Controller pattern
    @RequestMapping("/homeai") // Changed from @GetMapping to @RequestMapping
    public String homeai(Model model) { // Added Model parameter
        model.addAttribute("center", dir + "homeai"); // Set center attribute
        model.addAttribute("left", dir + "left");   // Set left attribute
        return "index"; // Return "index" view
    }
    @RequestMapping("/ai4")
    public String ai4(Model model) {
        model.addAttribute("center", dir+"ai4");
        model.addAttribute("left", dir+"left");
        return "index";
    }
    @RequestMapping("/ai5")
    public String ai5(Model model) {
        model.addAttribute("center", dir+"ai5");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @ResponseBody
    @PostMapping("/smarthome")
    public String smartHomeChat(@RequestParam String question) {
        return smartHomeService.chat(question);
    }

    @ResponseBody
    @PostMapping("/heating")
    public String heatingChat(@RequestParam String question){
        return heatingSystemService.chat(question);
    }
}
