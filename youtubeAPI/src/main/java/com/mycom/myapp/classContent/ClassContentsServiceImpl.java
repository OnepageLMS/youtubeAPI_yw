package com.mycom.myapp.classContent;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ClassContentsServiceImpl implements ClassContentsService{

	@Autowired
	ClassContentsDAO classContentsDAO;
	
	@Override
	public int insertContent(ClassContentsVO vo) {
		return classContentsDAO.insertContent(vo);
	}
	
	@Override
	public int updateContent(ClassContentsVO vo) {
		return classContentsDAO.updateContent(vo);
	}
	
	@Override
	public int deleteContent(int id) {
		return classContentsDAO.deleteContent(id);
	}
	
	@Override
	public ClassContentsVO getOneContent(int id) {
		return classContentsDAO.getOneContent(id);
	}
	@Override
	public List<ClassContentsVO> getAllClassContents(int classID){
		return classContentsDAO.getAllClassContents(classID);
	}
	
	@Override
	public int getDaySeq(ClassContentsVO vo) {
		return classContentsDAO.getDaySeq(vo);
	}
	
}
