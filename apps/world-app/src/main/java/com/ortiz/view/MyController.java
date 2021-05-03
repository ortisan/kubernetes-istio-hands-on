package com.ortiz.view;

import com.ortiz.business.IWorldService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MyController {

    @Autowired
    private IWorldService worldService;

    @GetMapping("/world/say-world")
    public String sayHello() {
        return worldService.sayWorld();
    }
}
