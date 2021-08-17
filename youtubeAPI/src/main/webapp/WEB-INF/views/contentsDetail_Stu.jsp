<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>VideoCheck</title>
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
	
	<style>
		
		.first {
			float: left;	   
		    box-sizing: border-box;
		}
		
		.second{
			display: inline-block; 
		    border: 1px solid green;
		    padding: 10px;
		    margin-left: 1%;
		    box-sizing: border-box;
		}

		#myProgress {
		  width: 100%;
		  background-color: #ddd;
		}
		
		#myBar {
		  width: 1%;
		  height: 30px;
		  background-color: #287ebf;
		}
	</style>
	
</head>
<body>
		<div>
			<div class="first">
				<p class="videoTitle"></p>
	    		<div id="onepageLMS"></div>
	    		<div id='timerBox' class="timerBox">
					<div id="time" class="time">00:00:00</div>
				</div>
				<div id="myProgress">
  					<div id="myBar"></div>
				</div>
			</div>
			
	        <div id="myPlaylist" class="second" >
	        	<div id="total_runningtime"></div>
	        	<div id="get_view" ></div>
	        </div>
        </div>
       
         <form action = "../../contentList/<%= request.getAttribute("classID") %>" method="get">
 			<button type = "submit"> 나가기 </button>
 		</form>
 		
 		
 		
    <script type="text/javascript">
    	
    	
        var tag = document.createElement('script');
        tag.src = "https://www.youtube.com/iframe_api";
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
 
        /**
         * onYouTubeIframeAPIReady 함수는 필수로 구현해야 한다.
         * 플레이어 API에 대한 JavaScript 다운로드 완료 시 API가 이 함수 호출한다.
         * 페이지 로드 시 표시할 플레이어 개체를 만들어야 한다.
         This function creates an <iFrame> after the API code downloads.
         */
        //
        var player;
        var playlist;
	 	var playlist_length;
        var studentEmail = ${list.studentEmail};
        var classID = ${classID};
        
        var playerState;
        var time = 0;
		var starFlag = false;
		
		var hour = 0;
		var min = 0;
	    var sec = 0;
		var db_timer = 0;
		var flag = 0;
		var timer;
		
		var howmanytime = 0;
		var watchedFlag = 0;
		
		var lastVideo;
		var playlistID;
		var ori_index =0;
 		
		var playlistcheck
	 	$(function(){ //db로부터 정보 불러오기!
	 		
	 		playlistcheck = JSON.parse('${playlistCheck}');
	 	
	 		$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax 
	 			  url : "../../../ajaxTest.do",
	 			  type : "post",
	 			  async : false,
	 			  data : {	
	 				 playlistID : playlistcheck[0].playlistID
	 			  },
	 			  success : function(data) {
	 				 playlist = data;
	 				 playlist_length = Object.keys(playlist).length;
	 			  },
	 			  error : function() {
	 			  	alert("error");
	 			  }
	 		})
	 		
	 		lastVideo = playlist[0].id;
	 		myThumbnail();
	 		move();
	 		 
	 	});
	 	
	 	var total_runningtime = 0;
	 	
	 	function myThumbnail(){
	 		
	 		for(var i=0; i<playlist_length; i++){
	 			//영상 하나하나의 러닝타임을 구하는 코드
	 			var show_min = Math.floor(parseInt(playlist[i].duration)/60);
		        var show_hour = Math.floor(show_min/60);
		        var show_sec = parseInt(playlist[i].duration)%60;
		        show_min = show_min%60;
		        
		        var show_th = show_hour;
		        var show_tm = show_min;
		        var show_ts = show_sec;
		        
		        if(show_th<10){
		        	show_th = "0" + show_hour;
		        }
		        if(show_tm < 10){
		        	show_tm = "0" + show_min;
		        }
		        if(show_ts < 10){
		        	show_ts = "0" + show_sec;
		        }
		        
	 			var thumbnail = '<img src="https://img.youtube.com/vi/' + playlist[i].youtubeID + '/1.jpg">';
	 			
	 			var newTitle = playlist[i].newTitle;
	 			var title = playlist[i].title;
	 			
	 			if (playlist[i].newTitle == null){
	 				playlist[i].newTitle = playlist[i].title;
	 				playlist[i].title = '';
			    }
	 			
	 			console.log("title " + (playlist[i].newTitle) + " length " + (playlist[i].newTitle).length);
	 			if ((playlist[i].newTitle).length > 45){
	 				playlist[i].newTitle = (playlist[i].newTitle).substring(0, 45) + " ..."; 
				}
	 			
	 			if(playlist[i].watched == 1){ //끝까지 다 본 영상임을 표시하는 코드
	 				$("#get_view").append(thumbnail + playlist[i].newTitle + '<div style = "background-color: #287ebf; width = auto" onclick="viewVideo(\'' +playlist[i].youtubeID.toString() + '\'' + ',' + playlist[i].id + ',' 
		 					+ playlist[i].start_s + ',' + playlist[i].end_s +  ',' + i + ')" >' +show_th + ":" + show_tm + ":" + show_ts + " /seq : " + playlist[i].seq+'</div>' );
	 			}
	 			else{ //끝까지 본 영상이 아닐 경우
	 				$("#get_view").append(thumbnail + playlist[i].newTitle + '<div onclick="viewVideo(\'' +playlist[i].youtubeID.toString() + '\'' + ',' + playlist[i].id + ',' 
		 					+ playlist[i].start_s + ',' + playlist[i].end_s +  ',' + i + ')" >' +show_th + ":" + show_tm + ":" + show_ts + " /seq : " + playlist[i].seq+ '</div>' );
	 			}
	 			
	 			total_runningtime += parseInt(playlist[i].duration);
	 		}
	 		
	 		//playlist 내의 영상 시간 총 길이
	 		var total_min = Math.floor(total_runningtime/60);
	        var total_hour = Math.floor(total_min/60);
	        var total_sec = total_runningtime%60;
	       	total_min = total_min%60;
	        
	        var total_th = total_hour;
	        var total_tm = total_min;
	        var total_ts = total_sec;
	        
	        if(total_th<10){
	        	total_th = "0" + total_hour;
	        }
	        if(total_tm < 10){
	        	total_tm = "0" + total_min;
	        }
	        if(total_ts < 10){
	        	total_ts = "0" + total_sec;
	        }
	        
	        $("#total_runningtime").append('<div> total runningTime ' +total_th + ":" + total_tm + ":" + total_ts + " / " +total_runningtime+ '</div>');
	 	}
	 	
	 	function move() { //progress bar 보여주기
         	var percentage;
 			
 			$.ajax({
	 			  url : "../../../ajaxTest2.do",
	 			  type : "post",
	 			  async : false,
	 			  data : {	//하나의 classID내에 같은 PlaylistID를 가진 것들이 여러개 있을 수 있다. 그러니 playlistID뿐만 아니라 
	 				  playlistID : playlistcheck[0].playlistID,
	 				  id : playlistcheck[0].id
	 			  },
	 			  success : function(data) { //playlistID에 맞는 플레이리스트 가져오기 -> playlistCheck테이블에서
	 				 
	 				 if(data.length == 0){ //null값을 리턴받았을 때 , 즉 아직 플레이리스트를 실행하지 않아서 playlsitCheck에 대한 정보가 없을 때
	 				 	//이 때 playlistCheck테이블에 row 추가해주기
	 				 	
		 				 	$.ajax({ //null일 때 totalWatched에 insert해주기
				 			  url : "../../../ajaxTest3.do",
				 			  type : "post",
				 			  async : false,
				 			  data : {	
				 				 studentID : studentEmail,
				 				 playlistID : playlistcheck[0].playlistID,
				 				 classPlaylistID : playlistcheck[0].id,
				 				 classID : classID,
				 				 totalVideo : playlist_length,
				 				 totalWatched : 0.00
				 			  },
				 			  success : function(data) {
				 				console.log(data);
				 				//percentage.totalWatched = 0;
				 			  },
				 			  error : function() {
				 			  	alert("error");
				 			  }
				 		 })
	 				}
	 				 
	 				 else{
	 					console.log("null이 아닌데??");
	 					percentage = data;
		 				percentage_length = Object.keys(playlist).length;
	 				}
	 				
	 			},
	 			error : function() {
	 			  	alert("error");
	 			}
	 		})
	 		
             var elem = document.getElementById("myBar");
             if(!percentage){ //null값을 리턴받았을 때, 즉, totalWatched에 대한정보가 없으면 아직 안봤다는 이야기이기 때문에 0으로 표시한다.
            	 var width = parseInt(0 / total_runningtime * 100);
             }
             else{
            	 console.log("percentage.totalWatched " + percentage.totalWatched );
            	 var width = parseInt(percentage.totalWatched / total_runningtime * 100);
            	 //배열의 형태가 아니라 VO하나만 리턴받는거라서 인덱스 표시하지 않는다.
             }
             
             elem.style.width = width + "%";
             elem.innerHTML = width + "%";
               
         }
	 	
	 	
        function viewVideo(videoID, id, startTime, endTime, index) { // 선택한 비디오 아이디를 가지고 플레이어 띄우기
 			start_s = startTime;
        
 			$('.videoTitle').text(playlist[ori_index].newTitle); //비디오 제목 정해두기
 			if (confirm("다른 영상으로 변경하시겠습니까? ") == true){    //확인
 				flag = 0;
 	 			time = 0;
 	 			
 	 			clearInterval(timer); //현재 재생중인 timer를 중지하지 않고, 새로운 youtube를 실행해서 timer 두개가 실행되는 현상으로, 새로운 유튜브를 실행할 때 타이머 중지!
				//이 전에 db에 lastTime, timer 저장하기 ajax를 써봅시다!
				
				$.ajax({ //다른 영상으로 변경할 때 현재 보고있던 영상에 대한 정보를 db에업데이트 시켜둔다.
					'type' : "post",
					'url' : "../../../changevideo",
					'data' : {
								lastTime : player.getCurrentTime(),
								studentID : studentEmail,
								videoID : lastVideo,
								playlistID : playlist[ori_index].playlistID,
								timer : db_timer + parseInt(playlist[ori_index].timer)
					},
					success : function(data){
						lastVideo = id; // 보던 비디오 ID에 id를 넣는다
						ori_index = index; // 원래 인덱스에 index를 넣는다.
					}, 
					error : function(err){
						alert("playlist 추가 실패! : ", err.responseText);
					}
				}); //보던 영상 정보 저장
				//보던 영상에 대해 start_s, end_s 업데이트 해두기
				
				if(playlist[index].lastTime >= 0.0){ //이미 보던 영상이다.
					startTime = playlist[index].lastTime;
					howmanytime = playlist[index].timer;
					watchedFag = 1;
				}
				
				player.loadVideoById({'videoId': videoID,
		               'startSeconds': startTime,
		               'endSeconds': endTime,
		               'suggestedQuality': 'default'})
		          
				
				//이 영상을 처음보는 것이 아니라면 이전에 보던 시간부터 startTime을 설정해두기
 				
    		}
    		
    		else{   //취소
    			return;

    		}
 		}
        
        
        function onYouTubeIframeAPIReady() {
            player = new YT.Player('onepageLMS', {
                height: '315',            // <iframe> 태그 지정시 필요없음
                width: '560',             // <iframe> 태그 지정시 필요없음
                videoId: playlist[0].youtubeID,
                playerVars: {             // <iframe> 태그 지정시 필요없음
                    controls: '2'
                },
                events: {
                    'onReady': onPlayerReady,               // 플레이어 로드가 완료되고 API 호출을 받을 준비가 될 때마다 실행
                    'onStateChange': onPlayerStateChange    // 플레이어의 상태가 변경될 때마다 실행
                }
            });
            
        }
        
        function onPlayerReady(event) { 
        	//이거는 플레이리스트의 첫번째 영상이 실행되면서 진행되는 코드 (영상클릭없이 페이지 딱 처음 로딩되었을 )
            console.log('onPlayerReady 실행');
            $('.videoTitle').text(playlist[ori_index].newTitle);
            $.ajax({
				'type' : "post",
				'url' : "../../../videocheck",
				'data' : {
							studentID : studentEmail, //학생ID(email)
							videoID : playlist[0].id //현재 재생중인 (플레이리스트 첫번째 영상의 ) id
				},
				success : function(data){
					
					if(playlist[0].lastTime >= 0.0) { //보던 영상이라면 lastTime부터 시작
						player.seekTo(playlist[0].lastTime, true);
					}
					else //처음보는 영상이면 지정된 start_s부터 시작
						player.seekTo(playlsit[0].start_s, true);
			        player.pauseVideo();
					
				}, 
				error : function(err){
					alert("playlist 추가 실패! : ", err.responseText);
				}
			});
            console.log('onPlayerReady 마감');
            
        }
        
		  
        function onPlayerStateChange(event) {
        	
        	/*영상이 시작하기 전에 이전에 봤던 곳부터 이어봤는지 물어보도록!*/
        	if(event.data == -1) {
        		console.log("flag : " +flag+ " /watchedFlag : "+watchedFlag);
				if(flag == 0 && watchedFlag != 1){ //아직 끝까지 안봤을 때만 물어보기! //처음볼때는 물어보지 않기
        			
        			if (confirm("이어서 시청하시겠습니까?") == true){    
        				flag = 1;
        				player.playVideo();
            		}
            		
            		else{   //취소
            			player.seekTo(playlist[ori_index].start_s, true);
            			flag = 1;
            			player.playVideo();
            			return;

            		}

        		}
        	}
        	
        	
        	/*영상이 실행될 때 타이머 실행하도록!*/
        	if(event.data == 1) {
        		
        		//console.log(event.data);
        		
        		starFlag = false;
        		timer = setInterval(function(){
        			if(!starFlag){
        				
        	    		
        		       	min = Math.floor(time/60);
        		        hour = Math.floor(min/60);
        		        sec = time%60;
        		        min = min%60;
        		
        		        var th = hour;
        		        var tm = min;
        		        var ts = sec;
        		        
        		        if(th<10){
        		        	th = "0" + hour;
        		        }
        		        if(tm < 10){
        		        	tm = "0" + min;
        		        }
        		        if(ts < 10){
        		        	ts = "0" + sec;
        		        }
        				
        		        
        		        document.getElementById("time").innerHTML = th + ":" + tm + ":" + ts;
        		        db_timer = time;
        		        time++;
        			}
    		      }, 1000);
        		
        		
        	}
        	
        	/*영상이 일시정지될 때 타이머도 멈추도록!*/
        	if(event.data == 2){
        		 if(time != 0){
        		  console.log("pause!!! timer : " + timer + " time : " + time);
       		      clearInterval(timer);
       		      starFlag = true;
       		    }
        	}
        	
        	/*영상이 종료되었을 때 타이머 멈추도록, 영상을 끝까지 본 경우! (영상의 총 길이가 마지막으로 본 시간으로 들어간다.)*/
        	if(event.data == 0){
        		watchedFlag = 1;
        		
        		$.ajax({
					'type' : "post",
					'url' : "../../../changewatch",
					'data' : {
								lastTime : player.getDuration(), //lastTime에 영상의 마지막 시간을 넣어주기
								studentID : studentEmail, //studentID 그대로
								videoID : playlist[ori_index].id, //videoID 그대로
								timer : time + parseInt(playlist[ori_index].timer), //timer도 업데이트를 위해 필요
								watch : 1, //영상을 다 보았으니 시청여부는 1로(출석) 업데이트!
								playlistID : playlist[0].playlistID
					},
					
					success : function(data){
						//영상을 잘 봤다면, 다음 영상으로 자동재생하도록
						console.log("ori_index : " +ori_index + "videoID : " + playlist[ori_index].youtubeID +" id : " +playlist[ori_index].id);
						ori_index++;
						$('.videoTitle').text(playlist[ori_index].newTitle);
						
						if(playlist[ori_index].lastTime >= 0.0){//보던 영상이라는 의미
							player.loadVideoById({'videoId': playlist[ori_index].youtubeID,
					               'startSeconds': playlist[ori_index].lastTime,
					               'endSeconds': playlist[ori_index].end_s,
					               'suggestedQuality': 'default'})
						}
						else{
							player.loadVideoById({'videoId': playlist[ori_index].youtubeID,
					               'startSeconds': playlist[ori_index].start_s,
					               'endSeconds': playlist[ori_index].end_s,
					               'suggestedQuality': 'default'})
						}
						move(); //영상 다 볼 때마다 시간 업데이트 해주기
					}, 
					error : function(err){
						alert("playlist 추가 실패! : ", err.responseText );
						//console.log("실패했는데 watch : " + watch);
						
					}
				});
        		
        		
        		
	       		 if(time != 0){
	       		  	console.log("stop!!");
	      		    clearInterval(timer);
	      		    starFlag = true;
	      		    time = 0;
	      		    
	      		  
	      	  	}
       		}
          
        	
            // 재생여부를 통계로 쌓는다.
            collectPlayCount(event.data);
        }
       
        var played = false;
        function collectPlayCount(data) {
            if (data == YT.PlayerState.PLAYING && played == false) {
                // todo statistics
                played = true;
                console.log('statistics');
            }
        }
        
       
        
        
    </script>
    
    
</body>
</html>