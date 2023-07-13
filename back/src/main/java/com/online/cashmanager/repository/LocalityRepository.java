package com.online.cashmanager.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

import com.online.cashmanager.model.Locality;


public interface LocalityRepository extends CrudRepository<Locality, Long> {
	
	public Optional<Locality> findByLogin(String login);
}