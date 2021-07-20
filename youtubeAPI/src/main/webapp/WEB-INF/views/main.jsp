<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
	var maxResults = "20";
	var idList = [maxResults]; //youtube Search 결과 저장
	var titleList = [maxResults];
	var dateList = [maxResults];
	var viewCount = [maxResults];
	var likeCount = [maxResults];
	var dislikeCount = [maxResults];
	var count = 0;
	
	
	function fnGetList(sGetToken) {
		count = 0;
		var $getval = $("#search_box").val();
		var $getorder = $("#opt").val();
		if ($getval == "") {
			alert("검색어를 입력하세요.");
			$("#search_box").focus();
			return;
		}
		$("#get_view").empty();
		$("#nav_view").empty();
		
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
				async: false,
				success : function(jdata) {
					if (jdata.error) {
						$("#nav_view")
						.append('<p>정상적으로 검색이 되지 않았습니다! 나중에 다시 시도해주세요</p>');
						}
					console.log(jdata);
					$(jdata.items).each(function(i) {
						setList(i, this.id.videoId, this.snippet.title, this.snippet.publishedAt);
					}).promise().done(
						$(jdata.items).each(function(i) {
							var id = idList[i];
							var getVideo = "https://www.googleapis.com/youtube/v3/videos?part=statistics&id="
								+ id
								+ "&key="
								+ key;
							$.ajax({
								type : "GET",
								url : getVideo,
								dataType : "jsonp",
								success : function(jdata2) {
									setDetails(i, jdata2.items[0].statistics.viewCount, jdata2.items[0].statistics.likeCount, jdata2.items[0].statistics.dislikeCount);
									},
									error : function(xhr, textStatus) {
										console.log(xhr.responseText);
										alert("video detail 에러");
										return;
									}
								
								})
						})
					);	
					
					if (jdata.prevPageToken) {
						lastandnext(jdata.prevPageToken, "이전");
					}
					if (jdata.nextPageToken) {
						lastandnext(jdata.nextPageToken, "다음");
					}
					
				},

				error : function(xhr, textStatus) {
					console.log(xhr.responseText);
					alert("an error occured for searching");
					return;
				}
			});
	}

	
	function getView(){
		for(var i=0; i<maxResults; i++){
			var id = idList[i];
			var thumbnail = '<img src="https://img.youtube.com/vi/' + id + '/0.jpg">';
			var url = '<a href="https://youtu.be/' + id + '">';
			console.log(i, titleList[i], viewCount[i]);
			$("#get_view")
			.append(
					'<div class="video">'
							+ thumbnail
							+ url
							+ '<span>'
							+ titleList[i]
							+ '</span></a>'
							+ '<p class="info"> publised: '
							+ dateList[i]
							+ ' view: '
							+ viewCount[i]
							+ ' like: '
							+ likeCount[i]
							+ ' dislike: '
							+ dislikeCount[i]
							+ '</p></div>');
		}
	}

	function lastandnext(token, direction){
		$("#nav_view")
		.append(
				'<a href="javascript:fnGetList(\''
						+ token
						+ '\');"> ' + direction + ' </a>');
	}
	
	function setList(i, id, title, date){
		idList[i] = id;
		titleList[i] = title;
		dateList[i] = date
	}

	function setDetails(i, view, like, dislike){
		viewCount[i] = view;
		likeCount[i] = like;
		dislikeCount[i] = dislike;
		count += 1;
		if (count == 20) getView();
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
	 

</body>
</html>

