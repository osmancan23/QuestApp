package com.osmncnn.questApp.requests;

import lombok.Data;

@Data
public class PostCreateRequest {

    Long id;
    String title;
    String content;
    Long userId;

}
