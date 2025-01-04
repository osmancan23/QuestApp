package com.osmncnn.questApp.services;

import com.osmncnn.questApp.entities.Like;
import com.osmncnn.questApp.entities.Post;
import com.osmncnn.questApp.entities.User;
import com.osmncnn.questApp.repos.LikeRepository;
import com.osmncnn.questApp.repos.PostRepository;
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
    private final PostRepository postRepository;

    public LikeService(LikeRepository repository, UserService userService, PostRepository postRepository) {
        this.repository = repository;
        this.userService = userService;
        this.postRepository = postRepository;
    }

    public List<LikeResponse> getAllLikes(Optional<Long> userId, Optional<Long> postId) {
        List<Like> list;
        if (userId.isPresent() && postId.isPresent()) {
            list = repository.findByUserIdAndPostId(userId.get(), postId.get());
        } else if (userId.isPresent()) {
            list = repository.findByUserId(userId.get());
        } else if (postId.isPresent()) {
            list = repository.findByPostId(postId.get());
        } else {
            list = repository.findAll();
        }
        return list.stream().map(LikeResponse::new).collect(Collectors.toList());
    }

    public LikeResponse createOneLike(LikeCreateRequest request, Long userId) {
        User user = userService.getUser(userId);
        Post post = postRepository.findById(request.getPostId()).orElse(null);

        if (user != null && post != null) {
            if (repository.existsByUserIdAndPostId(userId, request.getPostId())) {
                throw new RuntimeException("Bu postu zaten beğenmişsiniz!");
            }

            Like likeToSave = new Like();
            likeToSave.setPost(post);
            likeToSave.setUser(user);
            Like savedLike = repository.save(likeToSave);
            return new LikeResponse(savedLike);
        }
        return null;
    }

    public LikeResponse getLikeById(Long likeId) {
        Optional<Like> like = repository.findById(likeId);
        return like.map(LikeResponse::new).orElse(null);
    }

    public void deleteLikeById(Long likeId) {
        repository.deleteById(likeId);
    }

    public void deleteAllLikesByPostId(Long postId) {
        List<Like> likes = repository.findByPostId(postId);
        repository.deleteAll(likes);
    }
}
