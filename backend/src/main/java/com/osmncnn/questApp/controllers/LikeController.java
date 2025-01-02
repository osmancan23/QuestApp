package com.osmncnn.questApp.controllers;

import com.osmncnn.questApp.entities.Like;
import com.osmncnn.questApp.requests.LikeCreateRequest;
import com.osmncnn.questApp.respons.LikeResponse;
import com.osmncnn.questApp.security.JwtTokenProvider;
import com.osmncnn.questApp.services.LikeService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/likes")
public class LikeController {

    private final LikeService likeService;
    private final JwtTokenProvider jwtTokenProvider;

    public LikeController(LikeService likeService, JwtTokenProvider jwtTokenProvider) {
        this.likeService = likeService;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @GetMapping
    public List<LikeResponse> getAllLikes(@RequestParam Optional<Long> userId,
            @RequestParam Optional<Long> postId) {
        return likeService.getAllLikes(userId, postId);
    }

    @PostMapping
    public LikeResponse createLike(@RequestBody LikeCreateRequest request,
            @RequestHeader("Authorization") String token) {
        Long userId = jwtTokenProvider.getUserIdFromJwt(token.substring(7));
        return likeService.createOneLike(request, userId);
    }

    @GetMapping("/{likeId}")
    public LikeResponse getLike(@PathVariable Long likeId) {
        return likeService.getLikeById(likeId);
    }

    @DeleteMapping("/{likeId}")
    public void deleteLike(@PathVariable Long likeId) {
        likeService.deleteLikeById(likeId);
    }
}
