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
	
	public int addThumbnailID(PlaylistVO vo) {
		int result = sqlSession.update("Playlist.addThumbnailID", vo);
		return result;
	}
	
	public int changeSeq(PlaylistVO vo) {
		int result = sqlSession.update("Playlist.changeSeq", vo);
		return result;
	}
	
	public int updatePlaylistName(PlaylistVO vo) {
		int result = sqlSession.update("Playlist.updatePlaylistName", vo);
		return result;
	}
	
	public int updateDescription(PlaylistVO vo) {
		int result = sqlSession.update("Playlist.updateDescription", vo);
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
	
	public List<PlaylistVO> getAllPlaylist(){ //이부분 public 된것만 가져오도록 변경 필요!! (lms내 다른사람이 만든거 검색할때 사용)
		List<PlaylistVO> result = sqlSession.selectList("Playlist.getAllPlaylist");
		return result;
	}
	
	public List<PlaylistVO> getAllMyPlaylist(String creatorEmail){ //내가 만든 playlist만 가져올 때
		List<PlaylistVO> result = sqlSession.selectList("Playlist.getAllMyPlaylist", creatorEmail);
		return result;
	}
	
	public int getCount() {
		int result = sqlSession.selectOne("Playlist.getPlaylistCount");
		return result;
	}
	
	public int updateCount(int playlistID) { //totalVideo 업데이트
		int result = sqlSession.update("Playlist.updateCount", playlistID);
		return result;
	}
	public int updateTotalVideoLength(int playlistID) {
		int result = sqlSession.update("Playlist.updateTotalVideoLength", playlistID);
		return result;
	}

}