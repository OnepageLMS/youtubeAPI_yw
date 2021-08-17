package com.mycom.myapp.student.videocheck;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.student.videocheck.Stu_VideoCheckDAO;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckVO;

@Service
public class Stu_VideoCheckServiceImpl implements Stu_VideoCheckService {
	
	@Autowired
	Stu_VideoCheckDAO videoCheckDAO;

	@Override
	public int insertTime(Stu_VideoCheckVO vo) {
		return videoCheckDAO.insertTime(vo);
	}
	
	@Override
	public int deleteTime(int id) {
		return videoCheckDAO.deleteTime(id);
	}
	
	@Override
	public int updateTime(Stu_VideoCheckVO vo) {
		return videoCheckDAO.updateTime(vo);
	}
	
	@Override
	public int updateWatch(Stu_VideoCheckVO vo) {
		return videoCheckDAO.updateWatch(vo);
	}
	
	@Override
	public Stu_VideoCheckVO getTime(int id) {
		return videoCheckDAO.getTime(id);
	}
	
	@Override
	public Stu_VideoCheckVO getTime(Stu_VideoCheckVO vo) {
		return videoCheckDAO.getTime(vo);
	}

	@Override
	public List<Stu_VideoCheckVO> getTimeList() {
		return videoCheckDAO.getTimeList();
	}

}
