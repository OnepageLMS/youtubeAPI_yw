package com.mycom.myapp.student.classes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class Stu_ClassesServiceImpl implements Stu_ClassesService{
	@Autowired
	Stu_ClassesDAO classesDAO;
	
	@Override
	public Stu_ClassesVO getClass(int id) {
		return classesDAO.getClass(id);
	}
	
}
