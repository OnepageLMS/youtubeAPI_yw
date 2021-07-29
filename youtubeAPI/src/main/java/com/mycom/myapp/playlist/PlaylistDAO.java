package com.mycom.myapp.playlist;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class PlaylistDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	public int addPlaylist(PlaylistVO vo) {
		int result = sqlSession.insert("Playlist.addPlaylist", vo);
		return result;
	}
	
	public int changeSeq(PlaylistVO vo) {
		int result = sqlSession.update("Playlist.changeSeq", vo);
		return result;
	}
	
	public int deletePlaylist(int playlistID) {
		int result = sqlSession.delete("Playlist.deletePlaylist", playlistID);
		return result;
	}
	
	public PlaylistVO getPlaylist(int playlistID) {
		PlaylistVO result = sqlSession.selectOne("Playlist.getPlaylist", playlistID);
		return result;
	}
	
	public List<PlaylistVO> getAllPlaylist(){
		List<PlaylistVO> result = sqlSession.selectList("Playlist.getAllPlaylist");
		return result;
	}
	
	public int getCount() {
		int result = sqlSession.selectOne("Playlist.getCount");
		return result;
	}
	
	public int updateCount(PlaylistVO vo) {
		int result = sqlSession.update("Playlist.updateCount", vo);
		return result;
	}
}
