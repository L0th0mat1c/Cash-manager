package com.online.cashmanager.services.api;


import com.online.cashmanager.model.BankAccount;
import com.online.cashmanager.model.Locality;
import com.online.cashmanager.model.dto.TransactionDto;

public interface BankAccountService {

	public boolean pay(TransactionDto transaction, Locality connectedLocality);
	public BankAccount createBankAccount(BankAccount account);
}