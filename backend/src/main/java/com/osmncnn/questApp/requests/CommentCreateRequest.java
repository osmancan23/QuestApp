package com.osmncnn.questApp.requests;

import lombok.Data;

@Data
public class CommentCreateRequest {
    Long postId;
    String comment;
}
