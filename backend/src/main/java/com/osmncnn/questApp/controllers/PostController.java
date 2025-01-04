package com.osmncnn.questApp.controllers;

import com.osmncnn.questApp.entities.Post;
import com.osmncnn.questApp.requests.PostCreateRequest;
import com.osmncnn.questApp.requests.PostUpdateRequest;
import com.osmncnn.questApp.respons.PostResponse;
import com.osmncnn.questApp.security.JwtTokenProvider;
import com.osmncnn.questApp.services.PostService;
import org.springframework.http.ResponseEntity;
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
    public List<PostResponse> getAllPosts(@RequestHeader(value = "Authorization", required = false) String token) {
        Long currentUserId = null;
        if (token != null && token.startsWith("Bearer ")) {
            currentUserId = jwtTokenProvider.getUserIdFromJwt(token.substring(7));
        }
        return postService.getAllPosts(Optional.ofNullable(currentUserId));
    }

    @GetMapping("/{postId}")
    public PostResponse getPost(@PathVariable Long postId,
            @RequestHeader(value = "Authorization", required = false) String token) {
        Long currentUserId = null;
        if (token != null && token.startsWith("Bearer ")) {
            currentUserId = jwtTokenProvider.getUserIdFromJwt(token.substring(7));
        }
        return postService.getPostById(postId, currentUserId);
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
    public List<PostResponse> getUserPosts(@PathVariable Long userId,
            @RequestHeader(value = "Authorization", required = false) String token) {
        Long currentUserId = null;
        if (token != null && token.startsWith("Bearer ")) {
            currentUserId = jwtTokenProvider.getUserIdFromJwt(token.substring(7));
        }
        return postService.getUserPosts(userId, currentUserId);
    }

    @DeleteMapping("/all")
    public ResponseEntity<String> deleteAllPosts() {
        postService.deleteAllPosts();
        return ResponseEntity.ok("Tüm postlar başarıyla silindi");
    }

}
