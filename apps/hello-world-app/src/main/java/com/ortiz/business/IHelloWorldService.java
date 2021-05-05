package com.ortiz.business;

import reactor.core.publisher.Mono;

public interface IHelloWorldService {
    Mono<String> sayHelloWorld();
}
