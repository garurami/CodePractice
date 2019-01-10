package com.ahn.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.ModelAndView;

@RestControllerAdvice
public class CommonExceptionAdvice {

	private static final Logger logger=LoggerFactory.getLogger(CommonExceptionAdvice.class);
	
	@ExceptionHandler(Exception.class)
	private ModelAndView errorModelAndView(Exception ex) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("/error_common");
		modelAndView.addObject("exeception", ex);
		
		return modelAndView;
	}
	
	
}
