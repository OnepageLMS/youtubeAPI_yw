package com.mycom.myapp.playlist;

import java.util.List;

public interface PlaylistService {
	public int addPlaylist(PlaylistVO vo);
	public int addThumbnailID(PlaylistVO vo);
	public int changeSeq(PlaylistVO vo);
	public int deletePlaylist(int playlistID);
	public PlaylistVO getPlaylist(int playlistID);
	public List<PlaylistVO> getAllPlaylist();
	public int getCount();
	public int updateCount(int playlistID);
	public int updateTotalVideoLength(PlaylistVO vo); // 한개 이상의 변수가 sql 쿼리문에 필요할시에 vo로 사용 
}
