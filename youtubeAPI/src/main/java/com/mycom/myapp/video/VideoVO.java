package com.mycom.myapp.video;

import java.util.Date;
import java.util.List;

public class VideoVO {
	private int id;	//video id 
	private String youtubeID; 
	private String title;
	private String newTitle;
	private double start_s;
	private double end_s;
	private int playlistID;
	private int seq;
	private String tag;
	private Date regdate;
	private List<Integer> playlistArr;
	private double maxLength;
	private double duration;
	
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
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getNewTitle() {
		return newTitle;
	}
	public void setNewTitle(String newTitle) {
		this.newTitle = newTitle;
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
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getTag() {
		return tag;
	}
	public void setTag(String tag) {
		this.tag = tag;
	}
	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}
	public List<Integer> getPlaylistArr() {
		return playlistArr;
	}
	public void setPlaylistArr(List<Integer> playlistArr) {
		this.playlistArr = playlistArr;
	}
	public double getmaxLength() {
		return maxLength;
	}
	public void setmaxLength(double maxLength) {
		this.maxLength = maxLength;
	}
	public double getDuration() {
		return duration;
	}
	public void setDuration(double duration) {
		this.duration = duration;
	}

}