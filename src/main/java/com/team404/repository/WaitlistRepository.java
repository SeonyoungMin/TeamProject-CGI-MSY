package com.team404.repository;

import java.util.List;

public interface WaitlistRepository {

	void insert(int productNo, int userNo);

	void delete(int productNo, int userNo);

	boolean exists(int productNo, int userNo);

	int countByProduct(int productNo);

	List<Integer> findUserNosByProduct(int productNo);

	int deleteAllByProduct(int productNo);
}
