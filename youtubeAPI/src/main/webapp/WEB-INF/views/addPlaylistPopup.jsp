<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h4> Playlist 추가 </h4>
	
	<form method="post" action="player.jsp">
		playlist 명 <input type="text" id="playlistName" name="playlistName" placeholder="플레이리스트 이름">
		설명 <textarea id="description" name="description"> </textarea>
		<button type="submit"> 생성 </button>
		<button onclick="close_window();return false;"> 취소 </button>
	</form>
	
	
</body>

<script>
</script>
</html>