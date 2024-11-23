package com.osmncnn.questApp.services;

import com.osmncnn.questApp.entities.User;
import com.osmncnn.questApp.repos.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }


    public List<User> getAllUsers() {
        return  userRepository.findAll();
    }

    public User createUser(User user) {
       return userRepository.save(user);
    }

    public User getUser(long userId) {
        return userRepository.findById(userId).orElse(null);
    }

    public void deleteUser(long userId) {
        userRepository.deleteById(userId);
    }

    public void updateUser(long userId, User newUser) {
        Optional<User> user =  userRepository.findById(userId);
        if(user.isPresent()) {
            User oldUser =   user.get();
            oldUser.setName(newUser.getName());
            oldUser.setPassword(newUser.getPassword());
            userRepository.save(oldUser);

        }
    }

    public User getOneUserByUserName(String userName) {
        return userRepository.findByName(userName);
    }
}
