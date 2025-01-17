package com.osmncnn.questApp.respons;

import com.osmncnn.questApp.entities.Post;
import lombok.Data;

import java.util.List;

@Data
public class PostResponse {
    Long id;
    Long userId;
    String userName;
    String content;
    String imageUrl;
    List<LikeResponse> likes;
    List<CommentResponse> comments;
    Integer commentCount;
    java.util.Date createdAt;
    Boolean isLiked;

    // Liste için kullanılacak constructor (sadece yorum sayısı)
    public PostResponse(Post post, List<LikeResponse> likes, Integer commentCount, Long currentUserId) {
        this.id = post.getId();
        this.userId = post.getUser().getId();
        this.userName = post.getUser().getName();
        this.content = post.getContent();
        this.imageUrl = post.getImageUrl();
        this.likes = likes;
        this.commentCount = commentCount;
        this.createdAt = post.getCreatedAt();
        this.isLiked = likes != null && likes.stream().anyMatch(like -> like.getUserId().equals(currentUserId));
    }

    // Detay sayfası için kullanılacak constructor (tüm yorumlar)
    public PostResponse(Post post, List<LikeResponse> likes, List<CommentResponse> comments, Long currentUserId) {
        this.id = post.getId();
        this.userId = post.getUser().getId();
        this.userName = post.getUser().getName();
        this.content = post.getContent();
        this.imageUrl = post.getImageUrl();
        this.likes = likes;
        this.comments = comments;
        this.commentCount = comments != null ? comments.size() : 0;
        this.createdAt = post.getCreatedAt();
        this.isLiked = likes != null && likes.stream().anyMatch(like -> like.getUserId().equals(currentUserId));
    }
}
