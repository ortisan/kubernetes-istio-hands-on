package com.ortiz.business.impl;

import com.ortiz.business.IWorldService;
import org.springframework.stereotype.Service;

@Service
public class WorldServiceImpl implements IWorldService {

    @Override
    public String sayWorld() {
        return "World";
    }
}
