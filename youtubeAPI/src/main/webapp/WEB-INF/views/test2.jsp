<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="ie=edge" />
<script src="https://code.jquery.com/jquery-3.5.1.js"
	integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
	crossorigin="anonymous"></script>
	
<link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" /> <!-- jquery for drag&drop list order -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<style>
.buttons {
	margin-bottom: 10px;
}
</style>
</head>

<body>
<script>
function deleteVideo(playlistSeq, videoID){ // video 삭제
	
	/*
	if (confirm("정말 삭제하시겠습니까?" == true)){
		$.ajax({
			'type' : "post",
			'url' : "http://localhost:8080/myapp/deleteVideo",
			'data' : {id : videoID},
			success : function(data){
				changeAllVideo(playlistSeq, videoID); //삭제한 videoID도 넘겨줘야 함.
		
			}, error : function(err){
				alert("video 삭제 실패! : ", err.responseText);
			}

		});
	}else
		return false;
	
	*/
	changeAllVideo(playlistSeq, videoID);
	console.log("deletedVideo: " + videoID);

}

function changeAllVideo(playlistSeq, deletedID){ // video 추가, 삭제, 순서변경 뒤 해당 playlist의 전체 video order 재정렬
	var idList = new Array();
	var childs = $(".card-body")[playlistSeq].children;

	for (var i=0; i<childs.length; i++){
		var videoID = childs[i].getAttribute('videoid');
		console.log(id);

		if (deletedID != null){ // 이 함수가 playlist 삭제 뒤에 실행됐을 땐 삭제된 playlistID	 제외하고 재정렬 (db에서 삭제하는것보다 list가 더 빨리 불러와져서 이렇게 해줘야함)
			if (deletedID != videoID)
				idList.push(videoID);
		}
		else
			idList.push(videoID);
	}
	console.log(idList);
	
	var childs = $(".card-body")[playlistSeq].children; //삭제한 video가 속한 playlist의 다른 video 정보들을 저장

	for (var i in childs) {
		console.log(childs[i].attributes);
		var videoID = childs[i].attributes.getNamedItem("videoid").value;
		console.log(videoID);
		//console.log(childs[i].attributes[3].value);
		
		if (deletedID != null){ // 이 함수가 playlist 삭제 뒤에 실행됐을 땐 삭제된 playlistID	 제외하고 재정렬 (db에서 삭제하는것보다 list가 더 빨리 불러와져서 이렇게 해줘야함)
			if (deletedID != videoID)
				idList.push(videoID);
		}
		else
			idList.push(videoID);
	}
	console.log(idList);
	
	/*
	$.ajax({
	      type: "post",
	      url: "http://localhost:8080/myapp/changeVideosOrder", //새로 바뀐 순서대로 db update
	      data : { changedList : idList },
	      dataType  : "json", 
	      success  : function(data) {
	  	  		getAllVideo(playlistSeq); 
	    	  
	      }, error:function(request,status,error){
	          //alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	    	  getAllVideo(playlistSeq); 
	       }
	    });
    */
}
</script>
	<div id="allPlaylist" class="ui-sortable" total="6">
		<div class="playlistSeq card text-white bg-info mb-10">
			<div class="card-header ui-sortable-handle" listid="6">
				1 : dd<a href="#" onclick="deletePlaylist('6')"> 삭제 </a>
			</div>
			<div class="card-body" videototal="1">
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="0"
					videoid="158" youtubeid="VMn-BQAaCyI" start_s="1.54" end_s="2.97">
					0[Full Album] 악동뮤지션(A K M U)(악뮤) - N E X T EPISODE<a href="#"
						onclick="deleteVideo(0,158)"> 삭제 </a>
				</div>
			</div>
		</div>
		<div class="playlistSeq card text-white bg-info mb-10">
			<div class="card-header ui-sortable-handle" listid="0">
				2 : test3<a href="#" onclick="deletePlaylist('0')"> 삭제 </a>
			</div>
			<div class="card-body" videototal="6">
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="1"
					videoid="155" youtubeid="VMn-BQAaCyI" start_s="0" end_s="1520">
					5[Full Album] 악동뮤지션(A K M U)(악뮤) - N E X T EPISODE<a href="#"
						onclick="deleteVideo(1,155)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="1"
					videoid="148" youtubeid="wzAWI9h3q18" start_s="20" end_s="29">
					4Jade Is Awesome - Do you Even JADE bro? 삭제 삭제 삭제<a href="#"
						onclick="deleteVideo(1,148)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="1"
					videoid="147" youtubeid="wzAWI9h3q18" start_s="20" end_s="24">
					3Jade Is Awesome - Do you Even JADE bro? 삭제 삭제<a href="#"
						onclick="deleteVideo(1,147)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="1"
					videoid="146" youtubeid="wzAWI9h3q18" start_s="20" end_s="29">
					2Jade Is Awesome - Do you Even JADE bro? 삭제<a href="#"
						onclick="deleteVideo(1,146)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="1"
					videoid="125" youtubeid="9Tmzt6Q9WI8" start_s="2.91" end_s="484">
					1Spring MVC (스프링 웹 MVC) 강의 01 - Spring MVC란<a href="#"
						onclick="deleteVideo(1,125)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="1"
					videoid="7" youtubeid="wzAWI9h3q18" start_s="20" end_s="1031">
					0Jade Is Awesome - Do you Even JADE bro?<a href="#"
						onclick="deleteVideo(1,7)"> 삭제 </a>
				</div>
			</div>
		</div>
		<div class="playlistSeq card text-white bg-info mb-10">
			<div class="card-header ui-sortable-handle" listid="3">
				3 : test2<a href="#" onclick="deletePlaylist('3')"> 삭제 </a>
			</div>
			<div class="card-body" videototal="5">
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="2"
					videoid="144" youtubeid="VMn-BQAaCyI" start_s="1101" end_s="1290">
					5[Full Album] 악동뮤지션(AKMU) - N E X T EPISODE | 전곡 듣기 삭제<a href="#"
						onclick="deleteVideo(2,144)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="2"
					videoid="126" youtubeid="VMn-BQAaCyI" start_s="1101" end_s="1290">
					4[Full Album] 악동뮤지션(AKMU) - N E X T EPISODE | 전곡 듣기<a href="#"
						onclick="deleteVideo(2,126)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="2"
					videoid="154" youtubeid="t9ccIykXTCM" start_s="0" end_s="419">
					4라이브러리? 프레임워크? 차이점 아직도 모름? 5분 순삭.<a href="#"
						onclick="deleteVideo(2,154)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="2"
					videoid="124" youtubeid="BkRZfxznaOo" start_s="0.62" end_s="79.88">
					3Spring MVC Tutorial for Beginners<a href="#"
						onclick="deleteVideo(2,124)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="2"
					videoid="120" youtubeid="AemZ3fGyMx8" start_s="24.4133"
					end_s="508.181">
					2한때 인기열풍이었던 걸그룹 노래 playlist #2<a href="#"
						onclick="deleteVideo(2,120)"> 삭제 </a>
				</div>
			</div>
		</div>
		<div class="playlistSeq card text-white bg-info mb-10">
			<div class="card-header ui-sortable-handle" listid="4">
				4 : test<a href="#" onclick="deletePlaylist('4')"> 삭제 </a>
			</div>
			<div class="card-body" videototal="6">
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="3"
					videoid="153" youtubeid="g2b-NbR48Jo" start_s="0" end_s="4452">
					5Spring MVC Tutorial | Full Course<a href="#"
						onclick="deleteVideo(3,153)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="3"
					videoid="152" youtubeid="goICym_Kj0Q" start_s="0" end_s="6134">
					4악동뮤지션 인기곡 노래모음 / BEST 30곡<a href="#" onclick="deleteVideo(3,152)">
						삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="3"
					videoid="142" youtubeid="LcsWtmLPBmc" start_s="122" end_s="2929">
					3IN FULL: NSW Premier provides COVID-19 update | AB<a href="#"
						onclick="deleteVideo(3,142)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="3"
					videoid="150" youtubeid="VMn-BQAaCyI" start_s="0" end_s="1520">
					3[Full Album] 악동뮤지션(A K M U)(악뮤) - N E X T EPISODE<a href="#"
						onclick="deleteVideo(3,150)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="3"
					videoid="149" youtubeid="i7d6Zkrc0Nk" start_s="0" end_s="3938">
					2악동뮤지션 노래모음 | Best18 | 악뮤<a href="#" onclick="deleteVideo(3,149)">
						삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="3"
					videoid="131" youtubeid="aC9Wq4Yf2vY" start_s="0" end_s="220">
					0AKMU IU NAKKA Lyrics (악동뮤지션 아이유 낙하 가사) [Color Coded
					Lyrics/Han/Rom/Eng]<a href="#" onclick="deleteVideo(3,131)"> 삭제
					</a>
				</div>
			</div>
		</div>
		<div class="playlistSeq card text-white bg-info mb-10">
			<div class="card-header ui-sortable-handle" listid="1">
				5 : hello<a href="#" onclick="deletePlaylist('1')"> 삭제 </a>
			</div>
			<div class="card-body" videototal="3">
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="4"
					videoid="127" youtubeid="9Tmzt6Q9WI8" start_s="0.9" end_s="88.12">
					3Spring MVC (스프링 웹 MVC) 강의 01 - Spring MVC란<a href="#"
						onclick="deleteVideo(4,127)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="4"
					videoid="14" youtubeid="wzAWI9h3q18" start_s="400" end_s="1031">
					2Jade Is Awesome - Do you Even JADE bro?<a href="#"
						onclick="deleteVideo(4,14)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="4"
					videoid="8" youtubeid="gq4S-ovWVlM" start_s="20" end_s="1031">
					0What is the Spring framework really all about?<a href="#"
						onclick="deleteVideo(4,8)"> 삭제 </a>
				</div>
			</div>
		</div>
		<div class="playlistSeq card text-white bg-info mb-10">
			<div class="card-header ui-sortable-handle" listid="2">
				6 : hello2<a href="#" onclick="deletePlaylist('2')"> 삭제 </a>
			</div>
			<div class="card-body" videototal="4">
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="5"
					videoid="151" youtubeid="VMn-BQAaCyI" start_s="0" end_s="1520">
					3[Full Album] 악동뮤지션(A K M U)(악뮤) - N E X T EPISODE<a href="#"
						onclick="deleteVideo(5,151)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="5"
					videoid="145" youtubeid="QqTphjitet4" start_s="0" end_s="620">
					2Can This New Sword Defeat The New Boss?<a href="#"
						onclick="deleteVideo(5,145)"> 삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="5"
					videoid="143" youtubeid="i7d6Zkrc0Nk" start_s="647" end_s="1215.07">
					1악동뮤지션 노래모음 | Best18 | 악뮤<a href="#" onclick="deleteVideo(5,143)">
						삭제 </a>
				</div>
				<div class="videos" onclick="openSavedVideo(this)" playlistseq="5"
					videoid="123" youtubeid="LcsWtmLPBmc" start_s="122" end_s="2929">
					0IN FULL: NSW Premier provides COVID-19 update | AB<a href="#"
						onclick="deleteVideo(5,123)"> 삭제 </a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>