package com.mycom.myapp.classContent;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ClassContentsDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertContent(ClassContentsVO vo) {
		int result = sqlSession.insert("ClassContents.insertContent", vo);
		return result;
	}
	
	public int deleteContent(ClassContentsVO vo) {
		int result = sqlSession.delete("ClassContents.deleteContent", vo);
		return result;
	}
	
	public List<ClassContentsVO> getAllClassContents(int classID){
		List<ClassContentsVO> result = sqlSession.selectList("ClassContents.getAllClassContents", classID);
		return result;
	}
	
	public int getDaySeq(ClassContentsVO vo) {
		int result = sqlSession.selectOne("ClassContents.getDaySeq", vo);
		return result;
	}
}
