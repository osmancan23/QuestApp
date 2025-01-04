package com.osmncnn.questApp.services;

import com.osmncnn.questApp.entities.Comment;
import com.osmncnn.questApp.entities.Post;
import com.osmncnn.questApp.entities.User;
import com.osmncnn.questApp.repos.CommentRepository;
import com.osmncnn.questApp.repos.PostRepository;
import com.osmncnn.questApp.requests.CommentCreateRequest;
import com.osmncnn.questApp.requests.CommentUpdateRequest;
import com.osmncnn.questApp.respons.CommentResponse;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CommentService {
    private final CommentRepository commentRepository;
    private final UserService userService;
    private final PostRepository postRepository;

    public CommentService(CommentRepository commentRepository, UserService userService, PostRepository postRepository) {
        this.commentRepository = commentRepository;
        this.userService = userService;
        this.postRepository = postRepository;
    }

    public List<CommentResponse> getAllComments(Optional<Long> userId, Optional<Long> postId) {
        List<Comment> comments;
        if (userId.isPresent() && postId.isPresent()) {
            comments = commentRepository.getCommentsWithByUserIdAndPostId(userId.get(), postId.get());
        } else if (userId.isPresent()) {
            comments = commentRepository.getCommentsWithByUserId(userId.get());
        } else if (postId.isPresent()) {
            comments = commentRepository.getCommentsWithByPostId(postId.get());
        } else {
            comments = commentRepository.findAll();
        }
        return comments.stream().map(CommentResponse::new).collect(Collectors.toList());
    }

    public CommentResponse getCommentById(Long commentId) {
        Optional<Comment> comment = commentRepository.findById(commentId);
        return comment.map(CommentResponse::new).orElse(null);
    }

    public CommentResponse createComment(CommentCreateRequest request, Long userId) {
        Post post = postRepository.findById(request.getPostId()).orElse(null);
        User user = userService.getUser(userId);

        if (post == null || user == null) {
            return null;
        }

        Comment comment = new Comment();
        comment.setPost(post);
        comment.setUser(user);
        comment.setContent(request.getComment());

        Comment savedComment = commentRepository.save(comment);
        return new CommentResponse(savedComment);
    }

    public CommentResponse updateComment(Long commentId, CommentUpdateRequest request) {
        Optional<Comment> optionalComment = commentRepository.findById(commentId);
        if (optionalComment.isPresent()) {
            Comment comment = optionalComment.get();
            comment.setContent(request.getContent());
            Comment updatedComment = commentRepository.save(comment);
            return new CommentResponse(updatedComment);
        }
        return null;
    }

    public void deleteComment(Long commentId) {
        commentRepository.deleteById(commentId);
    }

    public void deleteAllCommentsByPostId(Long postId) {
        List<Comment> comments = commentRepository.getCommentsWithByPostId(postId);
        commentRepository.deleteAll(comments);
    }
}
