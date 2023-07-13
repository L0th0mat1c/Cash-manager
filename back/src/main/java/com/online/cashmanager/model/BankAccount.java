package com.online.cashmanager.model;

import java.util.UUID;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.websocket.server.PathParam;

import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class BankAccount {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private Long id;
	
	private String firstName;
	
	private String LastName;
	
	private String cardId = UUID.randomUUID().toString();
	
	private Double balance = 0.0;
	
}