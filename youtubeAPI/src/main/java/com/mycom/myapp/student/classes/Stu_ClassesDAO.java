package com.mycom.myapp.student.classes;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class Stu_ClassesDAO {
	@Autowired
	SqlSession sqlSession;
	
	public Stu_ClassesVO getClass(int id) {
		Stu_ClassesVO vo = sqlSession.selectOne("Stu_Classes.getClass", id);
		return vo;
	}
}