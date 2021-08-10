package com.mycom.myapp.video;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class VideoServiceImpl implements VideoService{

	@Autowired
	VideoDAO videoDAO;

	@Override
	public int insertVideo(VideoVO vo) {
		return videoDAO.insertVideo(vo);
	}

	@Override
	public int deleteVideo(int id) {
		return videoDAO.deleteVideo(id);
	}

	@Override
	public int updateVideo(VideoVO vo) {
		return videoDAO.updateVideo(vo);
	}
	
	@Override
	public int changeSeq(VideoVO vo) {
		return videoDAO.changeSeq(vo);
	}

	@Override
	public VideoVO getVideo(int id) {
		return videoDAO.getVideo(id);
	}

	@Override
	public List<VideoVO> getVideoList(int playlistID) {
		return videoDAO.getVideoList(playlistID);
	}
	
	@Override
	public int getTotalCount(int playlistID) {
		return videoDAO.getTotalCount(playlistID);
	}
}