package com.ortiz.business.impl;

import com.ortiz.business.IHelloService;
import org.springframework.stereotype.Service;

@Service
public class HelloServiceImpl implements IHelloService {

    @Override
    public String sayHello() {
        return "Hello";
    }
}
