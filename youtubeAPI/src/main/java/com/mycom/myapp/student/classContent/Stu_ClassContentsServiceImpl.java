package com.mycom.myapp.student.classContent;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class Stu_ClassContentsServiceImpl implements Stu_ClassContentsService{

	@Autowired
	Stu_ClassContentsDAO classContentsDAO;
	
	@Override
	public Stu_ClassContentsVO getOneContent(int id) {
		return classContentsDAO.getOneContent(id);
	}
	
	@Override
	public List<Stu_ClassContentsVO> getWeekClassContents(Stu_ClassContentsVO vo){
		return classContentsDAO.getWeekClassContents(vo);
	}
	
	@Override
	public List<Stu_ClassContentsVO> getSamePlaylistID(Stu_ClassContentsVO vo) {
		return classContentsDAO.getSamePlaylistID(vo);
	}
	
	@Override
	public List<Stu_ClassContentsVO> getAllClassContents(int classID){
		return classContentsDAO.getAllClassContents(classID);
	}
	
	@Override
	public int getDaySeq(Stu_ClassContentsVO vo) {
		return classContentsDAO.getDaySeq(vo);
	}
	
}