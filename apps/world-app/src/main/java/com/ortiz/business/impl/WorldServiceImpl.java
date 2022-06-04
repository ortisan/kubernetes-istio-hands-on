package com.ortiz.business.impl;

import com.ortiz.business.IWorldService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Random;

@Service
public class WorldServiceImpl implements IWorldService {

    private static final Logger LOGGER = LoggerFactory.getLogger(WorldServiceImpl.class);

    @Value("${application.percentual_erro}")
    private Integer percentualErro;

    @Value("${application.version}")
    private String version;

    @Override
    public String sayWorld() {
        Random rand = new Random(); // instance of random class
        int randomNumber = 1 + rand.nextInt(100);
        LOGGER.info("Percentual erro: {} - Número random gerado: {}", percentualErro, randomNumber);
        if (randomNumber <= this.percentualErro) {
            throw new RuntimeException("Erro randomico para testar Canário");
        }
        return String.format("World (%s)", version);
    }
}
