<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="ie=edge" />
<style>
.buttons {
	margin-bottom: 10px;
}
</style>
</head>
<body>
	<pre id="debug"></pre>
	<div class="buttons">
		<button data-play-youtube-video="GfCPFk8lyhM">Play Video 1</button>
		<button data-play-youtube-video="LXb3EKWsInQ">Play Video 2</button>
		<button id="destroy-youtube-player">Destroy Player</button>
	</div>
	<div id="player"></div>
	<script>
		(function() {
			var tag = document.createElement("script");

			tag.src = "https://www.youtube.com/iframe_api";
			var firstScriptTag = document.getElementsByTagName("script")[0];
			firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

			var player;
			var videoId;

			// Creates youtube video player and assigns it into scope
			// so that we can interact with player outside of this function
			function playVideo() {
				player = new YT.Player("player", {
					height : "400",
					width : "320",
					videoId : videoId,
					playerVars : {
						modestbranding : 1,
						rel : 0
					},
					events : {
						onReady : function(event) {
							event.target.playVideo();
						}
					}
				});
			}

			// grab all buttons with the play youtube video data attribute
			var playYoutubeVideoButtons = document
					.querySelectorAll("[data-play-youtube-video]");

			// attach an event to each button found in the document
			for (var i = 0; i < playYoutubeVideoButtons.length; i++) {
				playYoutubeVideoButtons[i]
						.addEventListener(
								"click",
								function() {

									// if previous player was initialised, we destroy it
									if (player) {
										player.destroy();
									}

									// set the video id in scope to the video id located on the button
									videoId = this.dataset.playYoutubeVideo;

									// play the video
									playVideo();

									// update debug text
									document.getElementById("debug").innerHTML = "Youtube video: "
											+ videoId + " has started playing.";
								});
			}

			// Below is a just hook an event to a button that destroys the youtube player when clicked
			var destroyYoutubePlayer = document
					.getElementById("destroy-youtube-player");

			destroyYoutubePlayer
					.addEventListener(
							"click",
							function() {
								if (player) {
									document.getElementById("debug").innerHTML = "Youtube player has been destroyed.";
									return player.destroy();
								}

								document.getElementById("debug").innerHTML = "Youtube player has not been initialised.";
							});
		})();
	</script>
</body>
</html>