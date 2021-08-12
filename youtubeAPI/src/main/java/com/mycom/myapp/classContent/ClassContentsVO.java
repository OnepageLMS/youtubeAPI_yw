package com.mycom.myapp.classContent;

import java.util.Date;

public class ClassContentsVO {
	private int id;
	private String title;
	private String description;
	private int classID;
	private int playlistID; //null값은 int에 저장안됨
	private String thumbnailID;
	private int week;
	private int day;
	private int daySeq;
	private boolean published;
	private Date startDate;
	private Date endDate;
	private Date modDate;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public int getClassID() {
		return classID;
	}
	public void setClassID(int classID) {
		this.classID = classID;
	}
	public int getPlaylistID() {
		return playlistID;
	}
	public void setPlaylistID(int playlistID) {
		this.playlistID = playlistID;
	}
	public String getThumbnailID() {
		return thumbnailID;
	}
	public void setThumbnailID(String thumbnailID) {
		this.thumbnailID = thumbnailID;
	}
	public int getWeek() {
		return week;
	}
	public void setWeek(int week) {
		this.week = week;
	}
	public int getDay() {
		return day;
	}
	public void setDay(int day) {
		this.day = day;
	}
	public int getDaySeq() {
		return daySeq;
	}
	public void setDaySeq(int daySeq) {
		this.daySeq = daySeq;
	}
	public boolean isPublished() {
		return published;
	}
	public void setPublished(boolean published) {
		this.published = published;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public Date getModDate() {
		return modDate;
	}
	public void setModDate(Date modDate) {
		this.modDate = modDate;
	}
	
}
