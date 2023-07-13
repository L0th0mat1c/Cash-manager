package com.online.cashmanager.model;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Transient;

import com.sun.istack.NotNull;

import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class Locality {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private Long id;
		
	private String login;
	
	private String pwdHash;
	
	@Transient
	private String token;
	
	@Transient
	private String pwd;
	
	@OneToOne(cascade = CascadeType.ALL)
    @NotNull
	private BankAccount bankAccount = new BankAccount();
}
