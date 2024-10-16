package com.osmncnn.questApp.controllers;

import com.osmncnn.questApp.entities.Comment;
import com.osmncnn.questApp.requests.CommentCreateRequest;
import com.osmncnn.questApp.requests.CommentUpdateRequest;
import com.osmncnn.questApp.services.CommentService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController()
@RequestMapping("/comments")
public class CommentController {

    public CommentController(CommentService commentService) {
        this._commentService = commentService;
    }

    private final CommentService _commentService;

    @GetMapping
    public List<Comment> getComments(@RequestParam Optional<Long> userId , @RequestParam Optional<Long> postId) {
        return  _commentService.getCommentsWithByUserIdAndPostId(userId,postId);
    }

    @GetMapping("/{commentId}")
    public Comment getComment(@PathVariable Long commentId) {
        return _commentService.getComment(commentId);
    }

    @PostMapping
    public Comment createComment(@RequestBody CommentCreateRequest commentCreateRequest) {
        return _commentService.createComment(commentCreateRequest);
    }

    @DeleteMapping("/{commentId}")
    public void deleteComment(@PathVariable Long commentId) {
         _commentService.deleteComment(commentId);
    }

    @PutMapping("/{commentId}")
    public Comment updateComment(@PathVariable Long commentId , @RequestBody CommentUpdateRequest commentUpdateRequest){
        return _commentService.updateComment(commentId,commentUpdateRequest);

    }
}
