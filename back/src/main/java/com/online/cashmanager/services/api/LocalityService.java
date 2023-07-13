package com.online.cashmanager.services.api;

import java.util.List;
import java.util.Optional;

import com.online.cashmanager.model.Locality;

public interface LocalityService {
	
	public Locality getByToken(String token);
	public Locality create(Locality locality);
	public Locality updateLocality(Locality connectedLocality, Locality toModifyLocality);
	public void delete(Locality locality);
	public Locality login(Locality locality);
	public void logout(Locality locality);
}