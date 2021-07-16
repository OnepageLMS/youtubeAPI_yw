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
		var maxResults = "30";
		var key = "AIzaSyCnS1z2Dk27-yex5Kbrs5XjF_DkRDhfM-c"; //API key 
		//var accessToken = "ya29.a0ARrdaM_R2D0RP4Zsjx_zliW1Xi9hDmZJ9jd0dy4SXyGoaikWXFpX9KWQVX64ss3HHB4RE1zpSJztWonIxrUKio_aO7XAc1hrNG4O1WQjSKSuesea8I7p7RXPlFhRIZ1sVwGboyCfWweJ_rKShZ82rqbyhTuW3A";
		var sTargetUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&order="
				+ order
				+ "&q="
				+ encodeURIComponent($getval)
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
		$.ajax({
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