package com.mycom.myapp.playlist;

import java.util.Date;

public class PlaylistVO {
	private int playlistID;
	private String playlistName;
	private String description;
	private String thumbnailID;
	private String creatorEmail;
	private int totalVideo;
	private int totalVideoLength;
	private int seq;
	private int exposed;
	private Date modDate;
	
	public String getThumbnailID() {
		return thumbnailID;
	}
	public void setThumbnailID(String thumbnailID) {
		this.thumbnailID = thumbnailID;
	}
	public int getExposed() {
		return exposed;
	}
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
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
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
	public int getTotalVideoLength() {
		return totalVideoLength;
	}
	public void setTotalVideoLength(int totalVideoLength) {
		this.totalVideoLength = totalVideoLength;
	}
	public int isExposed() {
		return exposed;
	}
	public void setExposed(int exposed) {
		this.exposed = exposed;
	}
	public Date getModDate() {
		return modDate;
	}
	public void setModDate(Date modDate) {
		this.modDate = modDate;
	}
}
