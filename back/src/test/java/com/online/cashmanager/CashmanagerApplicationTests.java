package com.online.cashmanager;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import javax.transaction.Transaction;

import org.jboss.logging.Logger;
import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import com.online.cashmanager.endpoint.BankAccountEndpoint;
import com.online.cashmanager.endpoint.LocalityEndpoint;
import com.online.cashmanager.model.BankAccount;
import com.online.cashmanager.model.dto.LocalityDto;
import com.online.cashmanager.model.dto.TransactionDto;
import com.online.cashmanager.services.api.BankAccountService;
import com.online.cashmanager.services.api.LocalityService;

@SpringBootTest
@TestMethodOrder(OrderAnnotation.class) 
class CashmanagerApplicationTests {

	@Autowired
	private LocalityEndpoint localityEndpoint;
	
	@Autowired
	private BankAccountEndpoint bankAccountEndpoint;
	
	@Autowired
	private BankAccountService bankAccountService;
	
	private static LocalityDto localityOne;
	
	private static BankAccount accountOne;
	
	private static Logger logger = Logger.getLogger(CashmanagerApplicationTests.class);

	@Test
	@Order(1)
	void createLocality() {
		logger.warn("Test cration locality");
		localityOne = new LocalityDto();
		
		localityOne.setLogin("SuperU");
		localityOne.setPwd("super");
		
		try {
			localityOne = localityEndpoint.create(localityOne);
		} catch (ResponseStatusException ex) {
			assertEquals(ex.getStatus(), HttpStatus.OK);
		}
		assertNotNull(localityOne);
		assertNotNull(localityOne.getId());
		assertNotNull(localityOne.getLogin());
		assertNotNull(localityOne.getToken());
	}
	
	@Test
	@Order(2)
	void createBankAccount() {
		logger.warn("Test cration bank account");
		
		accountOne = new BankAccount();
		
		accountOne.setFirstName("Pablo");
		accountOne.setLastName("Picasso");
		accountOne.setBalance(1000.0);
		
		try {
			accountOne = bankAccountService.createBankAccount(accountOne);
		} catch (ResponseStatusException ex) {
			assertEquals(ex.getStatus(), HttpStatus.OK);
		}
		
		assertNotNull(accountOne.getBalance());
		assertNotNull(accountOne.getCardId());
		assertNotNull(accountOne.getFirstName());
		assertNotNull(accountOne.getId());
		assertNotNull(accountOne.getLastName());
	}
	
	@Test
	@Order(3)
	void login() {
		logger.warn("Test login");

		localityOne.setPwd("super");
		
		try {
			localityOne = localityEndpoint.login(localityOne);
		} catch (ResponseStatusException ex) {
			assertEquals(ex.getStatus(), HttpStatus.OK);
		}
		assertNotNull(localityOne);
		assertNotNull(localityOne.getId());
		assertNotNull(localityOne.getLogin());
		assertNotNull(localityOne.getToken());
	}

	@Test
	@Order(4)
	void logout() {
		logger.warn("Test logout");
		try {
			localityEndpoint.logout(localityOne.getToken());
		} catch (ResponseStatusException ex) {
			assertEquals(ex.getStatus(), HttpStatus.OK);
		}
	}
	
	@Test
	@Order(5)
	void login2() {
		logger.warn("Test second login");

		localityOne.setPwd("super");

		try {
			localityOne = localityEndpoint.login(localityOne);
		} catch (ResponseStatusException ex) {
			assertEquals(ex.getStatus(), HttpStatus.OK);
		}
		assertNotNull(localityOne);
		assertNotNull(localityOne.getId());
		assertNotNull(localityOne.getLogin());
		assertNotNull(localityOne.getToken());
	}
	
	@Test
	@Order(6)
	void updateLocality() {
		logger.warn("Test update locality");

		LocalityDto newLocatity = new LocalityDto();
		newLocatity.setLogin("SuperSuperU");
		try {
			localityOne = localityEndpoint.updateLocality(newLocatity, localityOne.getToken());
		} catch (ResponseStatusException ex) {
			assertEquals(ex.getStatus(), HttpStatus.OK);
		}
		assertNotNull(localityOne);
		assertNotNull(localityOne.getId());
		assertEquals(localityOne.getLogin(), newLocatity.getLogin());
	}
	
	@Test
	@Order(7)
	void login3() {
		logger.warn("Test third login");

		localityOne.setPwd("super");

		try {
			localityOne = localityEndpoint.login(localityOne);
		} catch (ResponseStatusException ex) {
			assertEquals(ex.getStatus(), HttpStatus.OK);
		}
		assertNotNull(localityOne);
		assertNotNull(localityOne.getId());
		assertNotNull(localityOne.getLogin());
		assertNotNull(localityOne.getToken());
	}
	
	@Test
	@Order(8)
	void pay() {
		logger.warn("Test paiment");

		TransactionDto transaction = new TransactionDto();
		transaction.setPrice(323.0);
		transaction.setCardId(accountOne.getCardId());
		boolean result = false;
		try {
			result = bankAccountEndpoint.pay(transaction, localityOne.getToken());
		} catch (ResponseStatusException ex) {
			assertEquals(ex.getStatus(), HttpStatus.OK);
		}
		assertTrue(result);
	}
	
	@Test
	@Order(9)
	void delete() {
		logger.warn("Test delete locality");
		try {
			localityEndpoint.delete(localityOne.getToken());
		} catch (ResponseStatusException ex) {
			assertEquals(ex.getStatus(), HttpStatus.OK);
		}
	}
}
