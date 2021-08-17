package com.mycom.myapp.student.classContent;

import java.util.List;

public interface Stu_ClassContentsService {
	public Stu_ClassContentsVO getOneContent(int id);
	public List<Stu_ClassContentsVO> getWeekClassContents(Stu_ClassContentsVO vo); //추가
	public List<Stu_ClassContentsVO> getSamePlaylistID(Stu_ClassContentsVO vo); //추가
	public List<Stu_ClassContentsVO> getAllClassContents(int classID);
	public int getDaySeq(Stu_ClassContentsVO vo);
}