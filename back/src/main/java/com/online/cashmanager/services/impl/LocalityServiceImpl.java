package com.online.cashmanager.services.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.online.cashmanager.model.Locality;
import com.online.cashmanager.repository.LocalityRepository;
import com.online.cashmanager.services.JWT.JwtTokenUtil;
import com.online.cashmanager.services.api.LocalityService;

import java.util.Optional;

import org.jboss.logging.Logger;

@Service
public class LocalityServiceImpl implements LocalityService {
	
	private static Logger logger = Logger.getLogger(LocalityServiceImpl.class);
	
	@Autowired
	private LocalityRepository localityRepository;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	private JwtTokenUtil jwtTokenUtil;
	
	private boolean stringBlank(String str) {
		return (str == null || str.isBlank());
	}
	
	private Locality getById(Long id) {
		Optional<Locality> locality = localityRepository.findById(id);
		if (locality.isPresent()) {
			return locality.get();
		} else {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Locality id=" + id + " not exist");
		}
	}
	
	@Override
	public Locality getByToken(String token) {
		try {
			String login = jwtTokenUtil.getLoginFromToken(token);
			Optional<Locality> locality = localityRepository.findByLogin(login);
			if (locality.isPresent()) {
					if (jwtTokenUtil.validateToken(token, locality.get().getLogin())) {
						return locality.get();
					}
				throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Token has expired");
			}
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Locality token=" + token + " not exist");
		} catch (Exception e) {
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid Token");
		}
	}
	
	@Override
	public Locality login(Locality locality) {
		if (stringBlank(locality.getLogin()) || stringBlank(locality.getPwd())) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "You must provide an login and a password.");
		}
				
		Optional<Locality> localityResponse = localityRepository.findByLogin(locality.getLogin());
		
		if (localityResponse.isPresent()) {
			Locality u = localityResponse.get();
			if (passwordEncoder.matches(locality.getPwd(), u.getPwdHash())) {
				u.setToken(jwtTokenUtil.generateToken(u.getLogin()));
				u.setPwd(null);
				return u;
			} else {
				throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Bad password");
			}
		} else {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Locality " + locality.getLogin() + " not exist");
		}

	}
	
	@Override
	public void logout(Locality locality) {
		locality.setToken(null);
		localityRepository.save(locality);
	}
	
	@Override
	public Locality updateLocality(Locality connectedLocality, Locality toModifyLocality) {
		if (toModifyLocality.getLogin() != null && localityRepository.findByLogin(toModifyLocality.getLogin()).isPresent()) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "This login (" + toModifyLocality.getLogin() + ") is already in use.");
		} else if (toModifyLocality.getLogin() != null) {
			connectedLocality.setLogin(toModifyLocality.getLogin());				
		}
		
		if (toModifyLocality.getPwd() != null) {
			connectedLocality.setPwdHash(passwordEncoder.encode(toModifyLocality.getPwd()));
		}
		return localityRepository.save(connectedLocality);
	}
	
	@Override
	public Locality create(Locality locality) {
		if (locality.getId() != null) {
			throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You try to force an id in database, its illegal.");
		}
		if (stringBlank(locality.getLogin()) || stringBlank(locality.getPwd())) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "You must provide an login and a password.");
		}
		
		if (localityRepository.findByLogin(locality.getLogin()).isPresent()) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "This login (" + locality.getLogin() + ") is already in use.");
		}
		
		locality.setPwdHash(passwordEncoder.encode(locality.getPwd()));
		locality = localityRepository.save(locality);
		locality.setToken(jwtTokenUtil.generateToken(locality.getLogin()));
		return locality;
	}
	
	@Override
	public void delete(Locality locality) {
		this.getById(locality.getId());
		localityRepository.delete(locality);
	}
}