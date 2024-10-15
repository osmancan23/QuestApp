package com.osmncnn.questApp.services;

import com.osmncnn.questApp.entities.Post;
import com.osmncnn.questApp.entities.User;
import com.osmncnn.questApp.repos.PostRepository;
import com.osmncnn.questApp.requests.PostCreateRequest;
import com.osmncnn.questApp.requests.PostUpdateRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PostService {
    private PostRepository postRepository;
    private  UserService userService;

    public PostService(PostRepository postRepository , UserService userService) {
        this.postRepository = postRepository;
        this.userService = userService;
    }

    public List<Post> getAllPosts(Optional<Long> userId) {
        if(userId.isPresent()) return postRepository.findByUserId(userId.get());

        return postRepository.findAll();
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
