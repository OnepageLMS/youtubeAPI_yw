package com.mycom.myapp.student.playlistCheck;

import java.util.Date;

public class Stu_PlaylistCheckVO  {
	
		private int id;
		private int studentID;
		private int playlistID;
		private int classPlaylistID;
		private int classID;
		private int totalVideo;
		private double totalWatched;
		private Date regdate;
		private Date updateWatched;
		
		private int videoID; //이거 mapper에서 videoID사용해서 추가하는 
		
		public int getId() {
			return id;
		}
		public void setId(int id) {
			this.id = id;
		}
		public int getStudentID() {
			return studentID;
		}
		public void setStudentID(int studentID) {
			this.studentID = studentID;
		}
		public int getPlaylistID() {
			return playlistID;
		}
		public void setPlaylistID(int playlistID) {
			this.playlistID = playlistID;
		}	
		public int getClassPlaylistID() {
			return classPlaylistID;
		}
		public void setClassPlaylistID(int classPlaylistID) {
			this.classPlaylistID = classPlaylistID;
		}
		public int getClassID() {
			return classID;
		}
		public void setClassID(int classID) {
			this.classID = classID;
		}
		public int getTotalVideo() {
			return totalVideo;
		}
		public void setTotalVideo(int totalVideo) {
			this.totalVideo = totalVideo;
		}
		public double getTotalWatched() {
			return totalWatched;
		}
		public void setTotalWatched(double totalWatched) {
			this.totalWatched = totalWatched;
		}
		public Date getRegdate() {
			return regdate;
		}
		public void setRegdate(Date regdate) {
			this.regdate = regdate;
		}
		public Date getUpdateWatched() {
			return updateWatched;
		}
		public void setUpdateWatched(Date updateWatched) {
			this.updateWatched = updateWatched;
		}
		public int getVideoID() {
			return videoID;
		}
		public void setVideoID(int videoID) {
			this.videoID = videoID;
		}
}
