package com.osmncnn.questApp.services;

import com.osmncnn.questApp.entities.Like;
import com.osmncnn.questApp.entities.Post;
import com.osmncnn.questApp.entities.User;
import com.osmncnn.questApp.repos.PostRepository;
import com.osmncnn.questApp.requests.PostCreateRequest;
import com.osmncnn.questApp.requests.PostUpdateRequest;
import com.osmncnn.questApp.respons.LikeResponse;
import com.osmncnn.questApp.respons.PostResponse;
import lombok.Setter;
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

    public PostService(PostRepository postRepository , UserService userService ,@Lazy LikeService likeService) {
        this.postRepository = postRepository;
        this.userService = userService;
        this.likeService = likeService;
    }


    public List<PostResponse> getAllPosts(Optional<Long> userId) {
        List<Post> postList ;
        if(userId.isPresent()) {
            postList = postRepository.findByUserId(userId.get());
        }
        else{
            postList = postRepository.findAll();
        }

        return postList.stream().map(post -> {
                List<LikeResponse> likes =  likeService.fetchAllLikes(Optional.of(post.getId()),Optional.ofNullable(null));
                 return new PostResponse(post,likes);
        }).collect(Collectors.toList());
    }

    public Post getPostById(Long postId) {
      Optional<Post> post =   postRepository.findById(postId);

      if(post.isPresent()) return post.get();

      return null;
    }

    public Post createPost(PostCreateRequest postCreateRequest) {
       User user = userService.getUser(postCreateRequest.getUserId());

       if(user == null) return null;
       Post newPost = new Post();
       newPost.setId(postCreateRequest.getId());
       newPost.setTitle(postCreateRequest.getTitle());
       newPost.setContent(postCreateRequest.getContent());
       newPost.setUser(user);

       return   postRepository.save(newPost);
    }

    public Post updatePost(PostUpdateRequest postUpdateRequest, Long postId) {
        Optional<Post> response = postRepository.findById(postId);

        if(response.isPresent()){
            Post post = response.get();

            post.setTitle(postUpdateRequest.getTitle());

            post.setContent(postUpdateRequest.getContent());

            return   postRepository.save(post);
        }

        return null;
    }

    public void deletePost(Long postId) {
        postRepository.deleteById(postId);
    }
}
