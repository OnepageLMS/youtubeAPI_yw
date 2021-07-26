package com.mycom.myapp.video;

import java.util.List;

public interface VideoService {
	public int insertVideo(VideoVO vo);
	public int deleteVideo(int id);
	public int updateVideo(VideoVO vo);
//	public VideoVO getVideo(int playlistID);
	public List<VideoVO> getVideoList(int playlistID);
//	public PlaylistVO getPlaylist(int id);
}
