
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Youtube Search</title>
<style>
.video {
	padding: 7px;
}

.info {
	font-size: 12px;
}

img {
	width: 128px;
	height: 80px;
	padding: 5px;
}
</style>
</head>
<script src="https://code.jquery.com/jquery-3.5.1.js"
	integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
	crossorigin="anonymous"></script>

<script>	
	function fnGetList(sGetToken) {
		var $getval = $("#search_box").val();
		var $getorder = $("#opt").val();
		if ($getval == "") {
			alert("검색어를 입력하세요.");
			$("#search_box").focus();
			return;
		}
		$("#get_view").empty();
		$("#nav_view").empty();

		var videoList; //youtube Search-API 결과 저장

		var maxResults = "20";
		var key = "AIzaSyCnS1z2Dk27-yex5Kbrs5XjF_DkRDhfM-c";
		var sTargetUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&order="
				+ $getorder + "&q=" + encodeURIComponent($getval) //encoding
				+ "&key=" + key
				//+ "&access_token="
				//+ accessToken
				+ "&maxResults=" + maxResults + "&type=video";
		if (sGetToken != null) {
			sTargetUrl += "&pageToken=" + sGetToken + "";
		}
		$.ajax({
				type : "POST",
				url : sTargetUrl,
				dataType : "jsonp",
				success : function(jdata) {
					//console.log(jdata);
					$(jdata.items).each(function(i) {
									var id = this.id.videoId;
									var thumbnail = '<img src="https://img.youtube.com/vi/' + id + '/0.jpg">';
									var url = '<a href="https://youtu.be/' + id + '">';
									var title = this.snippet.title;
									var viewCount, likeCount, dislikeCount = 0;
									var getVideo = "https://www.googleapis.com/youtube/v3/videos?part=statistics&id="
										+ id
										+ "&key="
										+ key;
									console.log(i + "--> jdata: " + title);
									$.ajax({
											type : "GET",
											url : getVideo,
											dataType : "jsonp",
											async: false,
											success : function(jdata2) {
												viewCount = jdata2.items[0].statistics.viewCount;
												likeCount = jdata2.items[0].statistics.likeCount;
												dislikeCount = jdata2.items[0].statistics.dislikeCount;
												$("#get_view")
														.append(
																'<div class="video">'
																		+ thumbnail
																		+ url
																		+ '<span>'
																		+ title
																		+ '</span></a>'
																		+ '<p class="info"> view: '
																		+ viewCount
																		+ ' like: '
																		+ likeCount
																		+ ' dislike: '
																		+ dislikeCount
																		+ '</p></div>');
												console.log("jdata2: " + title);
												},
												error : function(xhr, textStatus) {
													console.log(xhr.responseText);
													alert("video detail 에러");
													return;
												}
											
											})
								})
							.promise()
							.done(
									function() {
										if (jdata.prevPageToken) {
											$("#nav_view")
													.append(
															'<a href="javascript:fnGetList(\''
																	+ jdata.prevPageToken
																	+ '\');"><이전></a>');
										}
										if (jdata.nextPageToken) {
											$("#nav_view")
													.append(
															'<a href="javascript:fnGetList(\''
																	+ jdata.nextPageToken
																	+ '\');"><다음></a>');
										}
									});
				},

				error : function(xhr, textStatus) {
					console.log(xhr.responseText);
					alert("에러");
					return;
				}
			});
	}
</script>

<body>

	<form name="form1" method="post" onsubmit="return false;">
		<select name="opt" id="opt">
			<option value="relevance">관련순</option>
			<option value="date">날짜순</option>
			<option value="viewCount">조회순</option>
			<option value="title">문자순</option>
			<option value="rating">평가순</option>
		</select> 
		<input type="text" id="search_box">
		<button onclick="fnGetList();">검색</button>
	</form>

	<div id="get_view"></div>

	<div id="nav_view"></div>
	 
	 <!-- 
	<form action="main">
		검색창 <input type="text" name="keyword"
			placeholder="For example: tom brady" /> <input type="submit"
			name="submit" />
	</form>
	
	<h2>검색 결과</h2>
	<div class="resultlist">
		<table>
			<c:forEach items="${videos}" var="v">
				<tr>
					<td>${v.title}</td>
					<td>${v.description}</td>
					<td>${v.videoID}</td>
					<td>${v.thumbnailUrl}</td>
				</tr>
			</c:forEach>
		</table>

	</div>
 	-->
</body>
</html>