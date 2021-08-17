package com.mycom.myapp.classContent;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.mycom.myapp.classes.ClassesService;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/class")
public class ContentsController {
	
	@Autowired
	private ClassesService classService;
	@Autowired
	private ClassContentsService classContentsService;

	
	@RequestMapping(value = "/contentList/{classID}", method = RequestMethod.GET)
	public String contentList(@PathVariable("classID") int classID, Model model) {
		classID = 1;//임의로 1번 class 설정

		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("allContents", JSONArray.fromObject(classContentsService.getAllClassContents(classID)));
		return "contentsList";
	}
	
	@RequestMapping(value = "/contentDetail/{id}", method = RequestMethod.GET) //class contents 전체 보여주기
	public String contentDetail(@PathVariable("id") int id, Model model) {
		ClassContentsVO vo = classContentsService.getOneContent(id);
		model.addAttribute("vo", vo);
		return "contentDetail";
	}
	
	@RequestMapping(value = "/addContent/{classID}/{day}", method = RequestMethod.GET) //class contents 추가
	public String addContent(@PathVariable("classID") int classID, @PathVariable("day") int day, Model model) {
		
		ClassContentsVO vo = new ClassContentsVO();
		vo.setClassID(classID);
		vo.setDay(day);
		model.addAttribute("content", vo);
		
		return "addContent";
	}
	
	@RequestMapping(value = "/addContentOK", method = RequestMethod.POST)
	public String addContentOK(ClassContentsVO vo) {
		int classID = vo.getClassID();
		vo.setDaySeq(classContentsService.getDaySeq(vo));
		
		if (classContentsService.insertContent(vo) == 0)
			System.out.println("classContents 추가 실패!");
		else
			System.out.println("classContents 추가 성공!");
		
		return "redirect:contentList/" + classID;
	}
	
	@RequestMapping(value = "/editContent/{id}", method = RequestMethod.GET)
	public String editContent(@PathVariable("id") int id, Model model) {
		ClassContentsVO vo = classContentsService.getOneContent(id);
		model.addAttribute("vo", vo);
		return "editContent";
	}
	
	@RequestMapping(value = "/editContentOK", method = RequestMethod.POST)
	public String editContentOK(ClassContentsVO vo) {
		int classID = vo.getClassID();
		
		if (classContentsService.updateContent(vo) == 0)
			System.out.println("classContents 수정 실패!");
		else
			System.out.println("classContents 수정 성공!");
		
		return "redirect:contentList/" + classID;
	}
	
	@RequestMapping(value = "/deleteContent/{classID}/{id}", method = RequestMethod.GET)
	public String deleteContent(@PathVariable("classID") int classID, @PathVariable("id") int id) {
		if (classContentsService.deleteContent(id) == 0)
			System.out.println("classContents 삭제 실패!");
		else
			System.out.println("classContents 삭제 성공!");
		
		return "redirect:../../contentList/" + classID;
	}
	
}

