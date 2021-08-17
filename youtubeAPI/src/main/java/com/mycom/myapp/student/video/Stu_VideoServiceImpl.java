package com.mycom.myapp.student.video;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class Stu_VideoServiceImpl implements Stu_VideoService{
	
	@Autowired
	Stu_VideoDAO videoDAO;
	
	@Override
	public Stu_VideoVO getVideo(int playlistID) {
		return videoDAO.getVideo(playlistID);
	}
	
	@Override
	public List<Stu_VideoVO> getVideoList(Stu_VideoVO vo) {
		return videoDAO.getVideoList(vo);
	}
}