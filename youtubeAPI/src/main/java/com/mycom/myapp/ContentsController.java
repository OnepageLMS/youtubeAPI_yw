package com.mycom.myapp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.mycom.myapp.classContent.ClassContentsService;
import com.mycom.myapp.classes.ClassesService;

@Controller
public class ContentsController {
	
	@Autowired
	private ClassesService classService;
	@Autowired
	private ClassContentsService classContentsService;
	
	@RequestMapping(value = "/contentList", method = RequestMethod.GET)
	public String contentList(Model model) {
		
		model.addAttribute("classInfo", classService.getClass(1));

		return "contentsList";
	}

}
