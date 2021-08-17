package com.mycom.myapp.student.video;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class Stu_VideoDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	
	public Stu_VideoVO getVideo(int playlistID) {
		return sqlSession.selectOne("Stu_Video.getVideo", playlistID);
	}
	
	public List<Stu_VideoVO> getVideoList(Stu_VideoVO vo) {
		//System.out.println("dao!");
		return sqlSession.selectList("Stu_Video.getVideoList", vo);
	}
	/*public PlaylistVO getPlaylist (int id) {
		return sqlSession.selectOne("Playlist.getPlaylist", id);
	}*/
	
}