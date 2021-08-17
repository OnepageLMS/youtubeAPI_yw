package com.mycom.myapp.student.videocheck;

import java.sql.Date;

//import java.math.BigDecimal;

public class Stu_VideoCheckVO {
	private int id;
	private int videoID;
	private int playlistID;
	private String studentEmail;
	private double lastTime;
	private double timer;
	private int watched;
	private int watchedUpdate;
	private Date regDate;
	private Date modDate;
	
	public int getID() {
		return id;
	}
	public void setID(int id) {
		this.id = id;
	}
	
	public int getvideoID() {
		return videoID;
	}
	public void setvideoID(int videoID) {
		this.videoID = videoID;
	}
	
	public int getPlaylistID() {
		return playlistID;
	}
	public void setPlaylistID(int playlistID) {
		this.playlistID = playlistID;
	}
	
	public String getStudentEmail() {
		return studentEmail;
	}
	public void setStudentEmail(String studentEmail) {
		this.studentEmail = studentEmail;
	}
	
	public double getLastTime() {
		return lastTime;
	}
	public void setLastTime(double lastTime) {
		this.lastTime = lastTime;
	}
	
	public double getTimer() {
		return timer;
	}
	public void setTimer(double timer) {
		this.timer = timer;
	}
	
	public int getWatched() {
		return watched;
	}
	public void setWatched(int watched) {
		this.watched = watched;
	}
	
	public int getWatchedUpdate() {
		return watchedUpdate;
	}
	public void setWatchedUpdate(int watchedUpdate) {
		this.watchedUpdate = watchedUpdate;
	}
	
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	
	public Date getModDate() {
		return modDate;
	}
	public void setModDate(Date modDate) {
		this.modDate = modDate;
	}
}
