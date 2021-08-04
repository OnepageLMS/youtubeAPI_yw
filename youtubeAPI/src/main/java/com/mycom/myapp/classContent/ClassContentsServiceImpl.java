package com.mycom.myapp.classContent;

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
	public int deleteContent(ClassContentsVO vo) {
		return classContentsDAO.deleteContent(vo);
	}
	
}
