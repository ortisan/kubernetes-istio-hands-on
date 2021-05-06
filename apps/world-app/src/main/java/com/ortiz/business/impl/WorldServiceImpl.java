package com.ortiz.business.impl;

import com.ortiz.business.IWorldService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Random;

@Service
public class WorldServiceImpl implements IWorldService {

    @Value("${application.percentual_erro}")
    private Integer percentualErro;

    @Override
    public String sayWorld() {
        Random rand = new Random(); //instance of random class
        int randomNumber = rand.nextInt(100);
        if (randomNumber <= this.percentualErro) {
            throw new RuntimeException("Erro randomico para testar Canário");
        }
        return "World";
    }
}
