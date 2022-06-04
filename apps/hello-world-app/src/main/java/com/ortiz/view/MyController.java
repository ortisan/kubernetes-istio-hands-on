package com.ortiz.view;

import com.ortiz.business.IHelloWorldService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
public class MyController {

    @Autowired
    private IHelloWorldService helloWorldService;

    @GetMapping("/hello-world/say-hello-world")
    public Mono<ResponseEntity> sayHelloWorldHello() {
        return helloWorldService.sayHelloWorld().flatMap((String helloMessage) -> {
            ResponseEntity body = ResponseEntity.status(HttpStatus.CREATED).body(helloMessage);
            return Mono.just(body);
        }).onErrorResume(exc -> {
            ResponseEntity body = ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(exc.getMessage());
            return Mono.just(body);
        });
    }
}
