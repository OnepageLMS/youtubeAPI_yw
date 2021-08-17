package com.mycom.myapp.student.playlistCheck;

import java.util.List;

public interface Stu_PlaylistCheckService  {
	public int insertPlaylist(Stu_PlaylistCheckVO vo);

	public int deletePlaylist(int id) ;
	
	public int updatePlaylist(Stu_PlaylistCheckVO vo);
	
	public int updateTotalWatched(Stu_PlaylistCheckVO vo);
	
	public Stu_PlaylistCheckVO getPlaylist(int playlistID);
	
	public Stu_PlaylistCheckVO getPlaylistByPlaylistID(Stu_PlaylistCheckVO vo);
	
	public int getTotalVideo(int playlistID);
	
	public List<Stu_PlaylistCheckVO> getAllPlaylist();
}
