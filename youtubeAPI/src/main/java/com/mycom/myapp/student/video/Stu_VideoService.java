package com.mycom.myapp.student.video;

import java.util.List;

public interface Stu_VideoService {
	
	
	public Stu_VideoVO getVideo(int playlistID);
	//public List<PlaylistVO> getVideoList(int playlistID);
	public List<Stu_VideoVO> getVideoList(Stu_VideoVO vo);
//	public PlaylistVO getPlaylist(int id);

}