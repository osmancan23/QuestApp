package com.osmncnn.questApp.controllers;

import com.osmncnn.questApp.entities.Post;
import com.osmncnn.questApp.requests.PostCreateRequest;
import com.osmncnn.questApp.requests.PostUpdateRequest;
import com.osmncnn.questApp.respons.PostResponse;
import com.osmncnn.questApp.security.JwtTokenProvider;
import com.osmncnn.questApp.services.PostService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping(value = "/posts")
public class PostController {
    private final PostService postService;
    private final JwtTokenProvider jwtTokenProvider;

    public PostController(PostService postService, JwtTokenProvider jwtTokenProvider) {
        this.postService = postService;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @GetMapping
    public List<PostResponse> getAllPosts(@RequestParam Optional<Long> userId) {
        return postService.getAllPosts(userId);
    }

    @GetMapping("/{postId}")
    public PostResponse getPost(@PathVariable Long postId) {
        return postService.getPostById(postId);
    }

    @PostMapping
    public PostResponse createPost(@RequestBody PostCreateRequest postCreateRequest,
            @RequestHeader("Authorization") String token) {
        Long userId = jwtTokenProvider.getUserIdFromJwt(token.substring(7));
        return postService.createOnePost(postCreateRequest, userId);
    }

    @PutMapping("/{postId}")
    public Post updatePost(@RequestBody PostUpdateRequest postUpdateRequest, @PathVariable Long postId) {
        return postService.updatePost(postUpdateRequest, postId);
    }

    @DeleteMapping("/{postId}")
    public void deletePost(@PathVariable Long postId) {
        postService.deletePost(postId);
    }

    @GetMapping("/user/{userId}")
    public List<PostResponse> getUserPosts(@PathVariable Long userId) {
        return postService.getUserPosts(userId);
    }

}
