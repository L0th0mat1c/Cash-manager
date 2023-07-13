package com.online.cashmanager.endpoint;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.online.cashmanager.model.Locality;
import com.online.cashmanager.model.dto.LocalityDto;
import com.online.cashmanager.model.dto.TransactionDto;
import com.online.cashmanager.services.api.BankAccountService;
import com.online.cashmanager.services.api.LocalityService;


@CrossOrigin
@RestController
@RequestMapping("bankaccount")
public class BankAccountEndpoint {
	
	@Autowired
	private BankAccountService bankAccountService;
	
	@Autowired
	private LocalityService localityService;
	
	@PostMapping("/pay")
	@ResponseBody
	public Boolean pay(@RequestBody TransactionDto transaction, @RequestHeader(value="Authorization") String token) {		
		Locality connectedLocality = localityService.getByToken(token);

		return bankAccountService.pay(transaction, connectedLocality);
	}
}