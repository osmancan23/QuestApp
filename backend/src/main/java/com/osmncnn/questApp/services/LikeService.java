package com.osmncnn.questApp.services;

import com.osmncnn.questApp.entities.Like;
import com.osmncnn.questApp.entities.Post;
import com.osmncnn.questApp.entities.User;
import com.osmncnn.questApp.repos.LikeRepository;
import com.osmncnn.questApp.requests.LikeCreateRequest;
import com.osmncnn.questApp.respons.LikeResponse;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class LikeService {
    private final LikeRepository repository;
    private final UserService userService;
    private final PostService postService;

    public LikeService(LikeRepository repository, UserService userService, PostService postService) {
        this.repository = repository;
        this.userService = userService;
        this.postService = postService;
    }


    public List<LikeResponse> fetchAllLikes(Optional<Long> postId, Optional<Long> userId) {
        List<Like> list;
        if(userId.isPresent() && postId.isPresent()) {
            list = repository.findByUserIdAndPostId(userId.get(), postId.get());
        }else if(userId.isPresent()) {
            list = repository.findByUserId(userId.get());
        }else if(postId.isPresent()) {
            list = repository.findByPostId(postId.get());
        }else
            list = repository.findAll();
        return list.stream().map(LikeResponse::new).collect(Collectors.toList());
    }


    public Like createOneLike(LikeCreateRequest like) {
        User user =   userService.getUser(like.getUserId());
        Post post = postService.getPostById(like.getPostId());

        if(user != null && post != null) {
            Like likeToSave = new Like();
            likeToSave.setId(like.getId());
            likeToSave.setPost(post);
            likeToSave.setUser(user);
            return repository.save(likeToSave);
        }else{
            return null;
        }
    }

    public Like fetchOneLikeById(Long likeId) {
        Optional<Like> like = repository.findById(likeId);
        return like.orElse(null);
    }

    public void deleteOneLikeById(Long likeId) {
        repository.deleteById(likeId);
    }
}
