package com.ortiz.business.impl;

import com.ortiz.business.IHelloService;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class HelloServiceImpl implements IHelloService {

    @Value("${application.version}")
    private String version;

    @Override
    public String sayHello() {
        return String.format("Hello (%s)", version);
    }
}
