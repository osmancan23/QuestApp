package com.osmncnn.questApp.services;

import com.osmncnn.questApp.entities.Post;
import com.osmncnn.questApp.entities.User;
import com.osmncnn.questApp.repos.PostRepository;
import com.osmncnn.questApp.requests.PostCreateRequest;
import com.osmncnn.questApp.requests.PostUpdateRequest;
import com.osmncnn.questApp.respons.CommentResponse;
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
    private final CommentService commentService;

    public PostService(PostRepository postRepository, UserService userService, @Lazy LikeService likeService,
            @Lazy CommentService commentService) {
        this.postRepository = postRepository;
        this.userService = userService;
        this.likeService = likeService;
        this.commentService = commentService;
    }

    public List<PostResponse> getAllPosts(Optional<Long> currentUserId) {
        List<Post> posts = postRepository.findAllByOrderByCreatedAtDesc();
        return posts.stream().map(post -> {
            List<LikeResponse> likes = likeService.getAllLikes(Optional.empty(), Optional.of(post.getId()));
            return new PostResponse(post, likes,
                    commentService.getAllComments(Optional.empty(), Optional.of(post.getId())).size(),
                    currentUserId.orElse(null));
        }).collect(Collectors.toList());
    }

    public PostResponse getPostById(Long postId, Long currentUserId) {
        Optional<Post> postOptional = postRepository.findById(postId);
        if (postOptional.isPresent()) {
            Post post = postOptional.get();
            List<LikeResponse> likes = likeService.getAllLikes(Optional.empty(), Optional.of(post.getId()));
            List<CommentResponse> comments = commentService.getAllComments(Optional.empty(), Optional.of(post.getId()));
            return new PostResponse(post, likes, comments, currentUserId);
        }
        return null;
    }

    public Post updatePost(PostUpdateRequest postUpdateRequest, Long postId) {
        Optional<Post> response = postRepository.findById(postId);

        if (response.isPresent()) {
            Post post = response.get();
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
        newPost.setContent(postCreateRequest.getContent());
        newPost.setImageUrl(postCreateRequest.getImageUrl());
        newPost.setUser(user);
        Post savedPost = postRepository.save(newPost);

        return new PostResponse(savedPost, likeService.getAllLikes(Optional.empty(), Optional.of(savedPost.getId())), 0,
                userId);
    }

    public List<PostResponse> getUserPosts(Long userId, Long currentUserId) {
        User user = userService.getUser(userId);
        if (user == null) {
            return null;
        }

        List<Post> posts = postRepository.findByUserIdOrderByCreatedAtDesc(userId);
        return posts.stream().map(post -> {
            List<LikeResponse> likes = likeService.getAllLikes(Optional.empty(), Optional.of(post.getId()));
            List<CommentResponse> comments = commentService.getAllComments(Optional.empty(), Optional.of(post.getId()));
            return new PostResponse(post, likes, comments != null ? comments.size() : 0, currentUserId);
        }).collect(Collectors.toList());
    }

    public void deleteAllPosts() {
        List<Post> allPosts = postRepository.findAll();
        for (Post post : allPosts) {
            commentService.deleteAllCommentsByPostId(post.getId());
            likeService.deleteAllLikesByPostId(post.getId());
        }
        postRepository.deleteAll();
    }
}
