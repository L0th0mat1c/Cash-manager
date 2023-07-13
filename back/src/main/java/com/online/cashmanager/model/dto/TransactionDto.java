package com.online.cashmanager.model.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TransactionDto {
	
	private Double price;
	
	private String cardId;
}