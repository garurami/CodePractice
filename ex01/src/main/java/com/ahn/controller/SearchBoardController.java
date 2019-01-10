package com.ahn.controller;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.ahn.domain.PageMaker;
import com.ahn.domain.SearchCriteria;
import com.ahn.service.BoardService;

@Controller
@RequestMapping("/sboard/*")
public class SearchBoardController {

	private static final Logger logger = LoggerFactory.getLogger(SearchBoardController.class);
	
	@Inject
	private BoardService service;
	
	@RequestMapping(value="/list", method = RequestMethod.GET)
	public void listPage(@ModelAttribute("cri") SearchCriteria cri, Model model)throws Exception{
		
		logger.info(cri.toString());
		
		model.addAttribute("list", service.listCriteria(cri));
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		
		pageMaker.setTotalCount(service.listCountCriteria(cri));
		
		model.addAttribute("pageMaker", pageMaker);
	}
	
}
