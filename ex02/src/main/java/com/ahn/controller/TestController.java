package com.ahn.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.ahn.domain.ReplyVO;
import com.ahn.service.ReplyService;

/**
 * Handles requests for the application home page.
 */
@RestController
public class TestController {
	
	@RequestMapping("/test")
	public String test() {
	
		return "test";
		
	}
	
	
	
}
