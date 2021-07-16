<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>find youtube video</title>
</head>
<script src="https://code.jquery.com/jquery-3.5.1.js"
	integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
	crossorigin="anonymous"></script>

<script>
	function fnGetList(sGetToken) {
		var $getval = $("#search_box").val();
		if ($getval == "") {
			alert("검색어를 입력하세요.");
			$("#search_box").focus();
			return;
		}
		$("#get_view").empty();
		$("#nav_view").empty();
		var order = "relevance";
		/*
		date – 리소스를 만든 날짜를 기준으로 최근 항목부터 시간 순서대로 리소스를 정렬합니다.
		rating – 높은 평가부터 낮은 평가순으로 리소스를 정렬합니다.
		relevance – 검색 쿼리에 대한 관련성을 기준으로 리소스를 정렬합니다. 이 매개변수의 기본값입니다.
		title – 제목에 따라 문자순으로 리소스를 정렬합니다.
		videoCount – 업로드한 동영상 수에 따라 채널을 내림차순으로 정렬합니다.
		viewCount – 리소스를 조회수가 높은 항목부터 정렬합니다.
		*/
		
		var maxResults = "30";
		var key = "AIzaSyCnS1z2Dk27-yex5Kbrs5XjF_DkRDhfM-c"; //API key 
		//var accessToken = "ya29.a0ARrdaM_R2D0RP4Zsjx_zliW1Xi9hDmZJ9jd0dy4SXyGoaikWXFpX9KWQVX64ss3HHB4RE1zpSJztWonIxrUKio_aO7XAc1hrNG4O1WQjSKSuesea8I7p7RXPlFhRIZ1sVwGboyCfWweJ_rKShZ82rqbyhTuW3A";
		var sTargetUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&order="
				+ order
				+ "&q="
				+ encodeURIComponent($getval) //encoding
				+ "&key="
				+ key
				//+ "&access_token="
				//+ accessToken
				+ "&maxResults=" + maxResults;
		console.log(sGetToken);
		if (sGetToken != null) {
			sTargetUrl += "&pageToken=" + sGetToken + "";
		}
		console.log(sTargetUrl);
		$.ajax({	//video like, length 정보 등도 같이 가져오기!
			type : "POST",
			url : sTargetUrl,
			dataType : "jsonp",
			success : function(jdata) {
				console.log(jdata);
				$(jdata.items).each(
						//받아온 youtube video list
						function(i) {
							$("#get_view").append(
									'<p class="box"><a href="https://youtu.be/'+this.id.videoId+'">'
											+ '<span>' + this.snippet.title
											+ '</span></a></p>');
						}).promise().done(
						function() {
							if (jdata.prevPageToken) {
								$("#nav_view").append(
										'<a href="javascript:fnGetList(\''
												+ jdata.prevPageToken
												+ '\');"><이전></a>');
							}
							if (jdata.nextPageToken) {
								$("#nav_view").append(
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
		<input type="text" id="search_box">
		<button onclick="fnGetList();">가져오기</button>
	</form>

	<div id="get_view"></div>

	<div id="nav_view"></div>



	<h2>Controller 전송</h2>
	<form action="search">
		검색창 <input type="text" name="keyword"
			placeholder="For example: tom brady" /> <input type="submit"
			name="submit" />
	</form>

	<h2>검색 결과</h2>
	<div class="resultlist">
		<table>
			<tr>
				<td>title</td>
				<td>description</td>
				<td>URL</td>
				<td>publishDate</td>
			</tr>
			<c:forEach var="v" items="${videos}">
				<tr>
					<td>${v.title}</td>
					<td>${v.description}</td>
					<td>${v.url}</td>
					<td>${v.publishDate}</td>
				</tr>
			</c:forEach>
		</table>

	</div>


</body>
</html>