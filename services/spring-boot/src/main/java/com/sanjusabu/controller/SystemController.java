package com.sanjusabu.controller;

import com.sanjusabu.service.SystemService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/system")
public class SystemController {

    private final SystemService systemService;

    public SystemController(SystemService systemService) {
        this.systemService = systemService;
    }

    @GetMapping("ping")
    public ResponseEntity<String> ping() {
        return systemService.ping();
    }

    @GetMapping("fastapi")
    public ResponseEntity<String> fastapi() {
        return systemService.fastapi();
    }

    @GetMapping("admin-name")
    public ResponseEntity<String> adminName() {
        return systemService.adminName();
    }

    @GetMapping("springboot")
    public ResponseEntity<Map<String, String>> springboot() {
        return systemService.springboot();
    }
}
