package com.osmncnn.questApp.services;

import com.osmncnn.questApp.entities.Comment;
import com.osmncnn.questApp.entities.Post;
import com.osmncnn.questApp.entities.User;
import com.osmncnn.questApp.repos.CommentRepository;
import com.osmncnn.questApp.requests.CommentCreateRequest;
import com.osmncnn.questApp.requests.CommentUpdateRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CommentService {

    private final CommentRepository commentRepository;

    private final UserService _userService;

    private final PostService _postService;

    public CommentService(CommentRepository commentRepository , UserService _userService , PostService _postService) {
        this.commentRepository = commentRepository;
        this._userService = _userService;
        this._postService = _postService;

    }




    public List<Comment> getCommentsWithByUserIdAndPostId(Optional<Long> userId, Optional<Long> postId) {
        if (userId.isPresent() && postId.isPresent()) {
            return commentRepository.getCommentsWithByUserIdAndPostId(userId.get(),postId.get());
        }else if(userId.isPresent()){
            return commentRepository.getCommentsWithByUserId(userId.get());
        }else if(postId.isPresent()){
            return commentRepository.getCommentsWithByPostId(postId.get());
        }

        return commentRepository.findAll();
    }

    public Comment getComment(Long commentId) {
        return commentRepository.findById(commentId).orElse(null);
    }

    public Comment createComment(CommentCreateRequest commentCreateRequest) {
         Post post =   _postService.getPostById(commentCreateRequest.getPostId());
         User user = _userService.getUser(commentCreateRequest.getUserId());

         if(post == null || user == null) {
             return null;
         }
         Comment comment = new Comment();
         comment.setId(commentCreateRequest.getId());
         comment.setPost(post);
         comment.setUser(user);
         comment.setContent(commentCreateRequest.getComment());

         return commentRepository.save(comment);
    }

    public void deleteComment(Long commentId) {
        commentRepository.deleteById(commentId);
    }

    public Comment updateComment(Long commentId, CommentUpdateRequest commentUpdateRequest) {
        Comment comment = commentRepository.findById(commentId).orElse(null);
        if(comment == null) return null;

        comment.setContent(commentUpdateRequest.getContent());
        return commentRepository.save(comment);
    }
}
