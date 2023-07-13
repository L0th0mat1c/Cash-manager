package com.online.cashmanager.endpoint;

import java.util.List;

import org.jboss.logging.Logger;
import org.mapstruct.factory.Mappers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.online.cashmanager.model.Locality;
import com.online.cashmanager.model.dto.LocalityDto;
import com.online.cashmanager.model.mapper.LocalityMapper;
import com.online.cashmanager.services.api.LocalityService;

@CrossOrigin
@RestController
@RequestMapping("localitys")
public class LocalityEndpoint {
	
	private static Logger logger = Logger.getLogger(LocalityEndpoint.class);

	@Autowired
	private LocalityService localityService;
	
	private LocalityMapper localityMapper = Mappers.getMapper(LocalityMapper.class);
	
	
	@PostMapping("/login")
	@ResponseBody
	public LocalityDto login(@RequestBody LocalityDto locality) {		
		return localityMapper.localityToLocalityDto(localityService.login(localityMapper.localityDtoToLocality(locality)));
	}
	
	@GetMapping("/logout")
	@ResponseBody
	public void logout(@RequestHeader(value="Authorization") String token) {		
		Locality connectedLocality = localityService.getByToken(token);
		
		localityService.logout(connectedLocality);
	}
	
	@PutMapping("")
	@ResponseBody
	public LocalityDto updateLocality(@RequestBody LocalityDto locality, @RequestHeader(value="Authorization") String token) {
		Locality connectedLocality = localityService.getByToken(token);
		 
		return localityMapper.localityToLocalityDto(localityService.updateLocality(connectedLocality, localityMapper.localityDtoToLocality(locality)));
	}
	
	@PostMapping("")
	@ResponseBody
	public LocalityDto create(@RequestBody LocalityDto locality) {		
		return localityMapper.localityToLocalityDto(localityService.create(localityMapper.localityDtoToLocality(locality)));
	}
	
	@DeleteMapping("")
	public void delete(@RequestHeader(value="Authorization") String token) {
		Locality connectedLocality = localityService.getByToken(token);
		
		localityService.delete(connectedLocality);
	}
	
}	