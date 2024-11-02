package com.osmncnn.questApp.respons;

import com.osmncnn.questApp.entities.Post;
import lombok.Data;

import java.util.List;

@Data
public class PostResponse {
    Long id;
    Long userId;
    String userName;
    String title;
    String content;
    List<LikeResponse> likes;

    public PostResponse(Post post,List<LikeResponse> likes) {
        this.id = post.getId();
        this.userId = post.getUser().getId();
        this.userName = post.getUser().getName();
        this.title = post.getTitle();
        this.content = post.getContent();
        this.likes = likes;
    }
}
