package com.online.cashmanager.model.mapper;


import java.util.List;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;

import com.online.cashmanager.model.Locality;
import com.online.cashmanager.model.dto.LocalityDto;

@Mapper
public interface LocalityMapper {
	
	public Locality localityDtoToLocality(LocalityDto locality);
	
	@Mapping(target = "pwd", ignore = true)
	public LocalityDto localityToLocalityDto(Locality locality);
	
	public List<Locality> localityDtoListToLocalityList(List<LocalityDto> locality);
	public List<LocalityDto> localityListToLocalityDtoList(List<Locality> locality);
}