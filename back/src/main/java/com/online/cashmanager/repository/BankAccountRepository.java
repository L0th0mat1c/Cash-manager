package com.online.cashmanager.repository;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

import com.online.cashmanager.model.BankAccount;


public interface BankAccountRepository extends CrudRepository<BankAccount, Long> {
	
	public Optional<BankAccount> findByCardId(String cardId);
}