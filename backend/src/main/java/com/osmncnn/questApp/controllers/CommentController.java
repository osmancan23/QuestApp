package com.osmncnn.questApp.controllers;

import com.osmncnn.questApp.requests.CommentCreateRequest;
import com.osmncnn.questApp.requests.CommentUpdateRequest;
import com.osmncnn.questApp.respons.CommentResponse;
import com.osmncnn.questApp.security.JwtTokenProvider;
import com.osmncnn.questApp.services.CommentService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/comments")
public class CommentController {
    private final CommentService commentService;
    private final JwtTokenProvider jwtTokenProvider;

    public CommentController(CommentService commentService, JwtTokenProvider jwtTokenProvider) {
        this.commentService = commentService;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @GetMapping
    public List<CommentResponse> getAllComments(@RequestParam Optional<Long> userId,
            @RequestParam Optional<Long> postId) {
        return commentService.getAllComments(userId, postId);
    }

    @GetMapping("/{commentId}")
    public CommentResponse getComment(@PathVariable Long commentId) {
        return commentService.getCommentById(commentId);
    }

    @PostMapping
    public CommentResponse createComment(@RequestBody CommentCreateRequest request,
            @RequestHeader("Authorization") String token) {
        Long userId = jwtTokenProvider.getUserIdFromJwt(token.substring(7));
        return commentService.createComment(request, userId);
    }

    @PutMapping("/{commentId}")
    public CommentResponse updateComment(@PathVariable Long commentId,
            @RequestBody CommentUpdateRequest request) {
        return commentService.updateComment(commentId, request);
    }

    @DeleteMapping("/{commentId}")
    public void deleteComment(@PathVariable Long commentId) {
        commentService.deleteComment(commentId);
    }
}
