package com.osmncnn.questApp.services;

import com.osmncnn.questApp.entities.Post;
import com.osmncnn.questApp.entities.User;
import com.osmncnn.questApp.repos.PostRepository;
import com.osmncnn.questApp.requests.PostCreateRequest;
import com.osmncnn.questApp.requests.PostUpdateRequest;
import com.osmncnn.questApp.respons.LikeResponse;
import com.osmncnn.questApp.respons.PostResponse;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class PostService {
    private final PostRepository postRepository;
    private final UserService userService;
    private final LikeService likeService;

    public PostService(PostRepository postRepository, UserService userService, @Lazy LikeService likeService) {
        this.postRepository = postRepository;
        this.userService = userService;
        this.likeService = likeService;
    }

    public List<PostResponse> getAllPosts(Optional<Long> userId) {
        List<Post> postList;
        if (userId.isPresent()) {
            postList = postRepository.findByUserId(userId.get());
        } else {
            postList = postRepository.findAll();
        }

        return postList.stream().map(post -> {
            List<LikeResponse> likes = likeService.getAllLikes(Optional.empty(), Optional.of(post.getId()));
            return new PostResponse(post, likes);
        }).collect(Collectors.toList());
    }

    public Post getPostById(Long postId) {
        Optional<Post> post = postRepository.findById(postId);
        return post.orElse(null);
    }

    public Post updatePost(PostUpdateRequest postUpdateRequest, Long postId) {
        Optional<Post> response = postRepository.findById(postId);

        if (response.isPresent()) {
            Post post = response.get();
            post.setTitle(postUpdateRequest.getTitle());
            post.setContent(postUpdateRequest.getContent());
            return postRepository.save(post);
        }
        return null;
    }

    public void deletePost(Long postId) {
        postRepository.deleteById(postId);
    }

    public PostResponse createOnePost(PostCreateRequest postCreateRequest, Long userId) {
        User user = userService.getUser(userId);
        if (user == null)
            return null;

        Post newPost = new Post();
        newPost.setTitle(postCreateRequest.getTitle());
        newPost.setContent(postCreateRequest.getContent());
        newPost.setUser(user);
        Post savedPost = postRepository.save(newPost);

        return new PostResponse(savedPost, likeService.getAllLikes(Optional.empty(), Optional.of(savedPost.getId())));
    }

    public List<PostResponse> getUserPosts(Long userId) {
        User user = userService.getUser(userId);
        if (user == null) {
            return null;
        }

        List<Post> posts = postRepository.findByUserId(userId);
        return posts.stream().map(post -> {
            List<LikeResponse> likes = likeService.getAllLikes(Optional.empty(), Optional.of(post.getId()));
            return new PostResponse(post, likes);
        }).collect(Collectors.toList());
    }
}
