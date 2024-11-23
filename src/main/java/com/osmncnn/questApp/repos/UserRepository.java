package com.osmncnn.questApp.repos;

import com.osmncnn.questApp.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.security.core.userdetails.UserDetails;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByName(String username);

}
