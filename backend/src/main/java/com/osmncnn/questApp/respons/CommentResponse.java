package com.osmncnn.questApp.respons;

import com.osmncnn.questApp.entities.Comment;
import lombok.Data;

@Data
public class CommentResponse {
    private Long id;
    private Long userId;
    private String userName;
    private Long postId;
    private String content;

    public CommentResponse(Comment comment) {
        this.id = comment.getId();
        this.userId = comment.getUser().getId();
        this.userName = comment.getUser().getName();
        this.postId = comment.getPost().getId();
        this.content = comment.getContent();
    }
}