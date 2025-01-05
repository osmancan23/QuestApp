package com.osmncnn.questApp.services;

import com.osmncnn.questApp.entities.User;
import com.osmncnn.questApp.repos.PostRepository;
import com.osmncnn.questApp.repos.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final PostRepository  postRepository;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder, PostRepository postRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.postRepository = postRepository;
    }


    public List<User> getAllUsers() {
        return  userRepository.findAll();
    }

    public User createUser(User user) {
       return userRepository.save(user);
    }

    public User getUser(long userId)  {
        User user =  userRepository.findById(userId).orElse(null);

      int count =  postRepository.findByUserId(userId).size();

      user.setPostCount(count);


      return user;
    }

    public void deleteUser(long userId) {
        userRepository.deleteById(userId);
    }

    public void updateUser(long userId, User newUser) {
        Optional<User> user =  userRepository.findById(userId);
        if(user.isPresent()) {
            User oldUser =   user.get();
            oldUser.setName(newUser.getName());
            oldUser.setPassword(passwordEncoder.encode(newUser.getPassword()));
            userRepository.save(oldUser);

        }
    }

    public User getOneUserByUserName(String userName) {
        return userRepository.findByName(userName);
    }
}
