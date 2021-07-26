package com.mycom.myapp.video;

import java.util.Date;

public class VideoVO {
	private int id;
	private String youtubeID;
	private double start_s;
	private double end_s;
	private int playlistID;
	private Date regdate;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getYoutubeID() {
		return youtubeID;
	}
	public void setYoutubeID(String youtubeID) {
		this.youtubeID = youtubeID;
	}
	public double getStart_s() {
		return start_s;
	}
	public void setStart_s(double start_s) {
		this.start_s = start_s;
	}
	public double getEnd_s() {
		return end_s;
	}
	public void setEnd_s(double end_s) {
		this.end_s = end_s;
	}
	public int getPlaylistID() {
		return playlistID;
	}
	public void setPlaylistID(int playlistID) {
		this.playlistID = playlistID;
	}
	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}

	
}
