package com.osmncnn.questApp.repos;

import com.osmncnn.questApp.entities.Comment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment , Long> {

    List<Comment> getCommentsWithByUserIdAndPostId(Long userId, Long postId);

    List<Comment> getCommentsWithByPostId(Long postId);

    List<Comment> getCommentsWithByUserId(Long userId);
}
