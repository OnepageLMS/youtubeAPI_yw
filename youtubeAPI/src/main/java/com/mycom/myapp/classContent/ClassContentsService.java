package com.mycom.myapp.classContent;

import java.util.List;

public interface ClassContentsService {
	public int insertContent(ClassContentsVO vo);
	public int deleteContent(ClassContentsVO vo);
	public List<ClassContentsVO> getAllClassContents(int classID);
	public int getDaySeq(ClassContentsVO vo);
}
