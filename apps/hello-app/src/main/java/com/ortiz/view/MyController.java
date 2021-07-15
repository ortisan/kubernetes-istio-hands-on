package com.ortiz.view;

import com.ortiz.business.IHelloService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MyController {

    @Autowired
    private IHelloService helloService;

    @GetMapping("/hello/say-hello")
    public String sayHello() {
        return helloService.sayHello();
    }
}
