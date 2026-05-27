package com.team404.repository;

import com.team404.domain.FraudAccount;

public interface FraudAccountRepository {

	void save(FraudAccount fraud);

	boolean existsLockedBySellerNo(int sellerNo);

}