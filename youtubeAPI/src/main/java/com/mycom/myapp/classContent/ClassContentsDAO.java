package com.mycom.myapp.classContent;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ClassContentsDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertContent(ClassContentsVO vo) {
		int result = sqlSession.insert("ClassContent.insertContent");
		return result;
	}
	
	public int deleteContent(ClassContentsVO vo) {
		int result = sqlSession.delete("ClassContent.deleteContent");
		return result;
	}
}
