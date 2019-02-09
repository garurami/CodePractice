package com.ahn.controller;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.ahn.domain.MessageVO;
import com.ahn.service.MessageService;

@RestController
@RequestMapping("/messages")
public class MessageController {
	
	@Inject
	private MessageService service;
	
	private Logger logger = LoggerFactory.getLogger(MessageController.class);
	@RequestMapping(value="/", method = RequestMethod.POST)
	public ResponseEntity<String> addMessage(@RequestBody MessageVO vo){
		
		logger.info("test");
		ResponseEntity<String> entity = null;
		try {
			service.addMessage(vo);
			entity = new ResponseEntity<>("success", HttpStatus.OK);
		}catch(Exception e) {
			e.printStackTrace();
			entity=new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		return entity;
	}

}
