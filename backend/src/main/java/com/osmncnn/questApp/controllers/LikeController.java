package com.osmncnn.questApp.controllers;

import com.osmncnn.questApp.entities.Like;
import com.osmncnn.questApp.requests.LikeCreateRequest;
import com.osmncnn.questApp.respons.LikeResponse;
import com.osmncnn.questApp.services.LikeService;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController()
@RequestMapping("/likes")
public class LikeController {

    private final LikeService likeService;


    public LikeController(LikeService likeService) {
        this.likeService = likeService;
    }

    @GetMapping
    public List<LikeResponse> fetchAllLikes(@RequestParam Optional<Long> userId,
                                            @RequestParam Optional<Long> postId){
        return  likeService.fetchAllLikes(postId,userId);
    }

    @PostMapping
    public Like createOneLike(@RequestBody LikeCreateRequest like){
        return likeService.createOneLike(like);
    }

    @GetMapping("/{likeId}")
    public Like fetchOneLike(@PathVariable Long likeId) {
        return likeService.fetchOneLikeById(likeId);
    }

    @DeleteMapping("/{likeId}")
    public void deleteOneLike(@PathVariable Long likeId) {
        likeService.deleteOneLikeById(likeId);
    }



}
