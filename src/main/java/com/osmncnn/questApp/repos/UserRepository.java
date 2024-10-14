package com.osmncnn.questApp.repos;

import com.osmncnn.questApp.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
