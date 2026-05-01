package com.sanjusabu.repository;

import com.sanjusabu.entity.UserTable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepo extends JpaRepository<UserTable, Long> {}
