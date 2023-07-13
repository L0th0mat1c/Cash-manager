package com.online.cashmanager.services.impl;

import java.util.Optional;

import org.jboss.logging.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.online.cashmanager.model.BankAccount;
import com.online.cashmanager.model.Locality;
import com.online.cashmanager.model.dto.TransactionDto;
import com.online.cashmanager.repository.BankAccountRepository;
import com.online.cashmanager.repository.LocalityRepository;
import com.online.cashmanager.services.api.BankAccountService;

@Service
public class BankAccountServiceImpl implements BankAccountService {

	private static Logger logger = Logger.getLogger(LocalityServiceImpl.class);
	
	@Autowired
	private BankAccountRepository bankAccountRepository;
	
	private boolean stringBlank(String str) {
		return (str == null || str.isBlank());
	}
	
	@Override
	public boolean pay(TransactionDto transaction, Locality connectedLocality) {
		Optional<BankAccount> optAccount = bankAccountRepository.findByCardId(transaction.getCardId());
		
		if (optAccount.isPresent()) {
			BankAccount account = optAccount.get();
			BankAccount localityAccount = connectedLocality.getBankAccount();
			if (account.getBalance() - transaction.getPrice() > 0) {
				account.setBalance(account.getBalance() - transaction.getPrice());
				localityAccount.setBalance(localityAccount.getBalance() + transaction.getPrice());
				bankAccountRepository.save(localityAccount);
				bankAccountRepository.save(account);
				return true;
			} else {
				return false;
			}
		} else {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "BankAccount " + transaction.getCardId() + " not exist");
		}
	}
	
	@Override
	public BankAccount createBankAccount(BankAccount account) {
		if (stringBlank(account.getFirstName()) || stringBlank(account.getLastName())) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "BankAccount need a firstName and a lastName");
		}
		return bankAccountRepository.save(account);
	}
}