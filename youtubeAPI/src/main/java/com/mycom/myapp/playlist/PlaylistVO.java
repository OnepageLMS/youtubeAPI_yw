package com.mycom.myapp.playlist;

public class PlaylistVO {
	private int playlistID;
	private String playlistName;
	private String creatorEmail;
	//private boolean allow; //public 이름 바꿔야함
	//private int folderID;
	
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
}
