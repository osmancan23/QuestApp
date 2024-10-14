package com.osmncnn.questApp.controllers;

import com.osmncnn.questApp.entities.User;
import com.osmncnn.questApp.repos.UserRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping(value = "/users")
public class UserController {
    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping()
    public List<User> getAllUsers() {
       return userRepository.findAll();
    }

    @PostMapping()
    public User createUser(@RequestBody User user) {
        return  userRepository.save(user);
    }

    @GetMapping("/{userId}")
    public User getUser(@PathVariable long userId) {
        return userRepository.findById(userId).orElse(null);
    }

    @DeleteMapping("/{userId}")
    public void deleteUser(@PathVariable long userId) {
        userRepository.deleteById(userId);
    }

    @PutMapping("/{userId}")
    public void updateUser(@PathVariable long userId, @RequestBody User newUser) {
        Optional<User> user =  userRepository.findById(userId);
        if(user.isPresent()) {
          User oldUser =   user.get();
          oldUser.setName(newUser.getName());
          oldUser.setPassword(newUser.getPassword());
          userRepository.save(oldUser);

        }
    }
}
