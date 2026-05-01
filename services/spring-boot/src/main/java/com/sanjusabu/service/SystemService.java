package com.sanjusabu.service;

import com.sanjusabu.entity.UserTable;
import com.sanjusabu.repository.UserRepo;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.Map;
import java.util.Optional;

@Service
public class SystemService {

    @Value("${fastapi.url}")
    private String url;

    private final UserRepo userRepo;
    private final RestClient restClient;

    public SystemService(UserRepo userRepo, RestClient restClient) {
        this.userRepo = userRepo;
        this.restClient = restClient;
    }

    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("pong");
    }

    public ResponseEntity<String> adminName() {
        Optional<UserTable> admin = userRepo.findById(1L);

        return admin
                .map( userTable -> ResponseEntity.ok("DB CONNECTED: " + userTable.getUsername()))
                .orElse(ResponseEntity.ok("DB CONNECTED: "+ "NO DATA IN THE DB"));
    }

    public ResponseEntity<String> fastapi() {
        return ResponseEntity.ok(
                restClient.get()
                        .uri(url)
                        .retrieve()
                        .body(String.class)
        );
    }

    public ResponseEntity<Map<String, String>> springboot() {
        return ResponseEntity.ok(Map.of("status", "active"));
    }
}
