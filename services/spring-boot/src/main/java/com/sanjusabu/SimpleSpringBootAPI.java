package com.sanjusabu;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@Slf4j
@SpringBootApplication
public class SimpleSpringBootAPI implements CommandLineRunner {

    public static void main(String[] args) {
        SpringApplication.run(SimpleSpringBootAPI.class, args);
    }

    public void run(String... args) {
        log.info("Application started");
    }
}
