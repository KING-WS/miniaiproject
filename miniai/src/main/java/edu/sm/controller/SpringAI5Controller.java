package edu.sm.controller;

import edu.sm.app.dto.RecyclingResponse;
import edu.sm.app.springai.service5.RecyclingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@Slf4j
@RequestMapping("/springai5")
@RequiredArgsConstructor
public class SpringAI5Controller {

    String dir = "springai5/";

    private final RecyclingService recyclingService;

    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center", dir+"center");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @PostMapping("/classify")
    @ResponseBody
    public RecyclingResponse classify(@RequestParam("image") MultipartFile imageFile) {
        return recyclingService.classifyAndGuide(imageFile.getResource(), imageFile.getContentType());
    }

    @RequestMapping("/ai1")
    public String ai1(Model model) {
        model.addAttribute("center", dir+"ai1");
        model.addAttribute("left", dir+"left");
        return "index";
    }
    @RequestMapping("/ai2")
    public String ai2(Model model) {
        model.addAttribute("center", dir+"ai2");
        model.addAttribute("left", dir+"left");
        return "index";
    }
    @RequestMapping("/ai3")
    public String ai3(Model model) {
        model.addAttribute("center", dir+"ai3");
        model.addAttribute("left", dir+"left");
        return "index";
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


}








