package com.mycom.myapp.classes;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ClassesDAO {
	@Autowired
	SqlSession sqlSession;
	
	public ClassesVO getClass(int id) {
		ClassesVO vo = sqlSession.selectOne("Classes.getClass", id);
		return vo;
	}
}
