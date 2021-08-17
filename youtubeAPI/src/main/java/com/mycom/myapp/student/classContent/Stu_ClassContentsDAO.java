package com.mycom.myapp.student.classContent;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.student.classContent.*;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckVO;

@Repository
public class Stu_ClassContentsDAO {
	@Autowired
	SqlSession sqlSession;
	
	public Stu_ClassContentsVO getOneContent(int id) {
		Stu_ClassContentsVO result = sqlSession.selectOne("Stu_ClassContents.getOneContent", id);
		return result;
	}
	
	public List<Stu_ClassContentsVO> getWeekClassContents(Stu_ClassContentsVO vo){
		List<Stu_ClassContentsVO> result = sqlSession.selectList("Stu_ClassContents.getWeekClassContents", vo);
		return result;
	}
	
	public List<Stu_ClassContentsVO> getSamePlaylistID(Stu_ClassContentsVO vo) {
		List<Stu_ClassContentsVO> result = sqlSession.selectList("Stu_ClassContents.getSamePlaylistID", vo);
		return result;
	}
	
	public List<Stu_ClassContentsVO> getAllClassContents(int classID){
		List<Stu_ClassContentsVO> result = sqlSession.selectList("Stu_ClassContents.getAllClassContents", classID);
		return result;
	}
	
	public int getDaySeq(Stu_ClassContentsVO vo) {
		int result = sqlSession.selectOne("Stu_ClassContents.getDaySeq", vo);
		return result;
	}
}
