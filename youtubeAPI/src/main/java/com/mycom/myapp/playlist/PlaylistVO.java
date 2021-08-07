package com.mycom.myapp.playlist;

import java.util.Date;

public class PlaylistVO {
	private int playlistID;
	private String playlistName;
	private String creatorEmail;
	private int seq;
	private int totalVideo;
	//private boolean public; //public 이름 바꿔야함
	private Date modDate;
	
	public int getPlaylistID() { 
		return playlistID;
	}
	public void setPlaylistID(int playlistID) { //playlist 정렬 순서 바꿀때 사용
		this.playlistID = playlistID;
	}
	public String getPlaylistName() {
		return playlistName;
	}
	public void setPlaylistName(String playlistName) {
		this.playlistName = playlistName;
	}
	public String getCreatorEmail() {
		return creatorEmail;
	}
	public void setCreatorEmail(String creatorEmail) {
		this.creatorEmail = creatorEmail;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public int getTotalVideo() {
		return totalVideo;
	}
	public void setTotalVideo(int totalVideo) {
		this.totalVideo = totalVideo;
	}
	public Date getModDate() {
		return modDate;
	}
	public void setModDate(Date modDate) {
		this.modDate = modDate;
	}
}
