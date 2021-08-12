package com.mycom.myapp.playlist;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PlaylistServiceImpl implements PlaylistService{
	@Autowired
	PlaylistDAO playlistDAO;
	
	@Override
	public int addPlaylist(PlaylistVO vo) {
		return playlistDAO.addPlaylist(vo);
	}
	
	@Override
	public int addThumbnailID(PlaylistVO vo) {
		return playlistDAO.addThumbnailID(vo);
	}
	
	@Override
	public int changeSeq(PlaylistVO vo) {
		return playlistDAO.changeSeq(vo);
	}
	
	@Override
	public int deletePlaylist(int playlistID) {
		return playlistDAO.deletePlaylist(playlistID);
	}
	
	@Override
	public PlaylistVO getPlaylist(int playlistID) {
		return playlistDAO.getPlaylist(playlistID);
	}
	
	@Override
	public List<PlaylistVO> getAllPlaylist() {
		return playlistDAO.getAllPlaylist();
	}
	
	@Override
	public int getCount() {
		return playlistDAO.getCount();
	}
	
	@Override
	public int updateCount(int playlistID) {
		return playlistDAO.updateCount(playlistID);
	}

	@Override
	public int updateTotalVideoLength(PlaylistVO vo) {
		return playlistDAO.updateTotalVideoLength(vo);
	}

	
}
