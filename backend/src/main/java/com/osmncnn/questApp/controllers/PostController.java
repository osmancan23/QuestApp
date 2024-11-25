package com.osmncnn.questApp.controllers;

import com.osmncnn.questApp.entities.Post;
import com.osmncnn.questApp.requests.PostCreateRequest;
import com.osmncnn.questApp.requests.PostUpdateRequest;
import com.osmncnn.questApp.respons.PostResponse;
import com.osmncnn.questApp.services.PostService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping(value = "/posts")
public class PostController {
    private  final PostService postService;


    public PostController(PostService postService) {
        this.postService = postService;
    }

    @GetMapping
    public List<PostResponse> getAllPosts(@RequestParam Optional<Long> userId ) {
        return  postService.getAllPosts(userId);
    }

    @GetMapping("/{postId}")
    public  Post getPost(@PathVariable Long postId) {
        return  postService.getPostById(postId);
    }

    @PostMapping
    public Post createPost(@RequestBody PostCreateRequest postCreateRequest) {
        return  postService.createPost(postCreateRequest);
    }

    @PutMapping("/{postId}")
    public Post updatePost(@RequestBody PostUpdateRequest postUpdateRequest, @PathVariable Long postId) {
        return postService.updatePost(postUpdateRequest,postId);
    }

    @DeleteMapping("/{postId}")
    public void deletePost(@PathVariable Long postId) {
         postService.deletePost(postId);
    }


}
