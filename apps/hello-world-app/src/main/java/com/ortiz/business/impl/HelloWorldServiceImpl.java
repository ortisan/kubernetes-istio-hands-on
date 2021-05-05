package com.ortiz.business.impl;

import com.ortiz.business.IHelloWorldService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.concurrent.atomic.AtomicReference;

@Service
public class HelloWorldServiceImpl implements IHelloWorldService {


    @Value("${application.hello.url}")
    private String urlHelloApp;
    @Value("${application.world.url}")
    private String urlWorldApp;

    private final WebClient helloWebClient;
    private final WebClient worldWebClient;

    public HelloWorldServiceImpl(@Autowired WebClient.Builder webClientBuilder) {
        this.helloWebClient = webClientBuilder.build();
        this.worldWebClient = webClientBuilder.build();
    }

    @Override
    public Mono<String> sayHelloWorld() {

        final AtomicReference<String> state = new AtomicReference<>();

        return Mono.just(state).flatMap((AtomicReference<String> stateMono) -> {
            return this.helloWebClient.get().uri(urlHelloApp).retrieve().bodyToMono(String.class).map((String helloPart) -> {
                String newState = helloPart;
                stateMono.compareAndSet(state.get(), newState);
                return stateMono;
            });
        }).flatMap(stateMono -> {
            return this.worldWebClient.get().uri(urlWorldApp).retrieve().bodyToMono(String.class).map((String worldPart) -> {
                String newState = String.format("%s %s", stateMono.get(), worldPart).trim();
                stateMono.compareAndSet(state.get(), newState);
                return stateMono;
            });
        }).flatMap(stateMono -> {
            return Mono.just(stateMono.get());
        });
    }
}