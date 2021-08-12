package com.mycom.myapp.playlist;

public class PlaylistVO {
	private int playlistID;
	private String playlistName;
	private String description;
	private String creatorEmail;
	private int seq;
	private int totalVideo;
	private boolean exposed; //public 이름 바꿔야함
	private double totalVideoLength;
	private double duration;
	private String thumbnailID;
	
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
	public boolean isExposed() {
		return exposed;
	}
	public void setExposed(boolean exposed) {
		this.exposed = exposed;
	}
	public double getTotalVideoLength() {
		return totalVideoLength;
	}
	public void setTotalVideoLength(double totalVideoLength) {
		this.totalVideoLength = totalVideoLength;
	}
	public double getDuration() {
		return duration;
	}
	public void setDuration(double duration) {
		this.duration = duration;
	}
	public String getThumbnailID() {
		return thumbnailID;
	}
	public void setThumbnailID(String thumbnailID) {
		this.thumbnailID = thumbnailID;
	}
}
