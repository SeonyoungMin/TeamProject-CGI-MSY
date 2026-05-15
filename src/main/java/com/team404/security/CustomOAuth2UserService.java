package com.team404.security;

import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;

public class CustomOAuth2UserService extends DefaultOAuth2UserService {
    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        System.out.println("=== OAuth2UserService 호출됨: " + 
            userRequest.getClientRegistration().getRegistrationId());
        try {
            OAuth2User user = super.loadUser(userRequest);
            System.out.println("=== OAuth2 attributes: " + user.getAttributes());
            return user;
        } catch (Exception e) {
            System.out.println("=== OAuth2UserService 예외: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}