package com.mycom.myapp.playlist;

import java.util.List;

public interface PlaylistService {
	public int addPlaylist(PlaylistVO vo);
	public int changeSeq(PlaylistVO vo);
	public int updatePlaylistName(PlaylistVO vo);
	public int updateDescription(PlaylistVO vo);
	public int deletePlaylist(int playlistID);
	public PlaylistVO getPlaylist(int playlistID);
	public List<PlaylistVO> getAllPlaylist();
	public List<PlaylistVO> getAllMyPlaylist(String creatorEmail);
	public int getCount();
	public int updateCount(int playlistID);
	public int updateTotalVideoLength(int playlistID);
}
