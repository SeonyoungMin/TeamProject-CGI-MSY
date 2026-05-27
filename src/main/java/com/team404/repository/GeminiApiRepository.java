package com.team404.repository;

import com.team404.domain.Image;

public interface GeminiApiRepository {

	String analyze(Image image, String prompt);
}
