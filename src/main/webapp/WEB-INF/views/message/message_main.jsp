<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Message</title>
<link rel="stylesheet" href="/resources/ad_assets/css/message.css">
<script src="https://code.jquery.com/jquery-3.1.0.min.js"></script>
</head>
<body>

	<jsp:include page="../include/navbar.jsp"></jsp:include>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	
	<div class="msg-container">
		<div class="messaging">
			<div class="inbox_msg">

				<!-- 메세지 목록(list) 영역 : message_list.jsp -->
				<div class="inbox_people">
					<!-- 메세지 리스트 상단바 recent, 검색아이콘-->
					<div class="headind_srch">
						<div class="recent_heading">
							<h4>Recent</h4>
						</div>

						<!-- 메세지 검색 -->
						<div class="srch_bar">
							<div class="stylish-input-group">
								<input type="text" class="search-bar" placeholder="Search">
								<span class="input-group-addon">
									<button type="button">
										<i class="fa fa-search" aria-hidden="true"></i>
									</button>
								</span>
							</div>
						</div>
					</div>

					<!-- 실제 대화한 메세지 목록 -->
					<div class="inbox_chat">
					
					</div>
				</div>

				<!-- 메세지 내용(content) 영역 : message_content.jsp -->
				<div class="mesgs">

					<!-- 실제 대화한 메세지 내용 목록(대화내용) -->
					<div class="msg_history" name="contentList"></div>

					<!-- 메세지 입력란이 올자리 -->
					<div class="send_message"></div>
				</div>
			</div>
		</div>
	</div>




	<script>
	
		// 메세지 리스트 가져오기(처음)
		const FirstMessageList = function() {
			$.ajax({
					url : "msgList.do",
					method : "get",
					success : function(data) {
						console.log("FirstMessageList()");

						$('.inbox_chat').html(data);

						// 메세지 리스트 중 한 개 클릭 - 채팅가능
						$('.chat_list').on('click',function() {

							// 그때의 메세지방, 상대방 id담음
							let msgRoomNo = $(this).attr('msgRoomNo');
							let otherId = $(this).attr('otherId');
							console.log("msgRoomNo : "+msgRoomNo);
							console.log("otherId : "+otherId);

							// 클릭한 채팅방 빼고, 나머지 active효과 해제
							// .chat_list_box를 갖지 않는 .chat_list_box요소의 내용에 msgRoomNo더함
							$('.chat_list_box').not('.chat_list_box.chat_list_box'+ msgRoomNo)
									.removeClass('active_chat');
							// 선택한 채팅방만 active효과(active_chat)
							$('.chat_list_box'+msgRoomNo).addClass('active_chat');
							
							// 메세지 입력/전송칸 
							let send_msg = "";
							send_msg += "<div class='type_msg'>";
							send_msg += "	<div class='input_msg_write row'>";
							send_msg += "		<div class='col-11'>";
							send_msg += "			<input type='text' class='write_msg form-control' placeholder='메세지를 입력해주세요' />";
							send_msg += "		</div>";
							send_msg += "		<div class='col-1'>";
							send_msg += "			<button class='msg_send_btn' type='button'><i class='fa fa-paper-plane-o' aria-hidden='true'></i></button>";
							send_msg += "		</div>";
							send_msg += "	</div>";
							send_msg += "</div>";

							// 메세지 입력/전송 칸 보이기
							$('.send_message').html(send_msg);
							

							// 메세지 전송버튼 클릭
							$('.msg_send_btn').on('click',function() {
									// 메세지 전송함수 호출(클릭한 채팅방 번호, 상대방 id)
									SendMessage(msgRoomNo,otherId);
								});

							// 클릭한 채팅방 번호 넘겨주면 그 채팅방에 해당하는 메세지 보여주는 함수 호출()
							ShowMessageContent(msgRoomNo);
						});
					}
				});
			
		};

		// 메세지 리스트 다시 가져오기 (처음X, FirstMessageList함수랑 비슷)
		const MessageList = function() {
			$.ajax({
					url : "msgList.do",
					method : "get",
					data : {},
					success : function(data) {
						console.log("MessageList()");

						$('.inbox_chat').html(data);

						// 메세지 리스트 중 한 개 클릭 - 채팅가능
						$('.chat_list').on('click',function() {

							// 그때의 메세지방, 상대방 id담음
							let msgRoomNo = $(this).attr('msgRoomNo');
							let otherId = $(this).attr('otherId');

							// 클릭한 채팅방 빼고, 나머지 active효과 해제
							$('.chat_list_box').not('.chat_list_box.chat_list_box'+ msgRoomNo)
									.removeClass('active_chat');
							// 선택한 채팅방만 active효과(active_chat)
							$('.chat_list_box'+ msgRoomNo).addClass('active_chat');

							// 메세지 입력/전송칸 
							let send_msg = "";
							send_msg += "<div class='type_msg'>";
							send_msg += "	<div class='input_msg_write row'>";
							send_msg += "		<div class='col-11'>";
							send_msg += "			<input type='text' class='write_msg form-control' placeholder='메세지를 입력해주세요' />";
							send_msg += "		</div>";
							send_msg += "		<div class='col-1'>";
							send_msg += "			<button class='msg_send_btn' type='button'><i class='fa fa-paper-plane-o' aria-hidden='true'></i></button>";
							send_msg += "		</div>";
							send_msg += "	</div>";
							send_msg += "</div>";

							// 메세지 입력/전송 칸 보이기
							$('.send_message').html(send_msg);

							// 메세지 전송버튼 클릭
							$('.msg_send_btn').on('click',function() {

								// 메세지 전송함수 호출(클릭한 채팅방, 상대방 id)
								SendMessage(msgRoomNo, otherId);
							});
							
							/* // 메세지 쓴 후, 엔터
							$('.write_msg').keydown(function(event){
									// 메세지 전송함수 호출(클릭한 채팅방, 상대방 id)
									SendMessage(msgRoomNo, otherId);
								
							}); */

							// 클릭한 채팅방 번호 넘겨주면 그에 해당하는 메세지 보여주는 함수 호출()
							ShowMessageContent(msgRoomNo);

						});

						// 전송버튼 클릭시 현재 열린 메세지의 선택된 표시 사라지는 걸 막기위함
						$('.chat_list_box:first').addClass('active_chat');
					}
				});
			
		};

		// 클릭한 메세지 내용 보여주고, 읽지 않은 메세지를 읽음처리하는 함수
		const ShowMessageContent = function(msgRoomNo) {
			console.log("msgRoomNo"+msgRoomNo);
			$.ajax({
				url : "msgContent.do",
				method : "GET",
				data : {
					"msgRoomNo" : msgRoomNo
				},
				success : function(data) {
					console.log("ShowMessageContent() 메시지 가져오기");

					// 메세지 내용을 html에 담음
					$('.msg_history').html(data);

					// 함수 호출할 떄마다 스크롤 맨 아래로 위치시킴
					$('.msg_history').scrollTop(
							$('.msg_history')[0].scrollHeight);
				},
				error : function() {
					alert('에러 발생');
				}
			})

			// 해당 채팅방의 메세지 내용을 읽었음으로 읽음처리 
			$('.unread' + msgRoomNo).empty();
		};

		// 메세지 전송 함수
		const SendMessage = function(msgRoomNo, otherId) {
			console.log("SendMessage()호출")
			console.log("msgRoomNo : "+ msgRoomNo, "otherId : "+otherId);
			// 입력한 메세지 담기
			let msgContent = $('.write_msg').val();

			// 공백지우기
			msgContent = msgContent.trim();

			if (msgContent == "") {
				alert("메세지를 입력해주세요");
			} else {
				$.ajax({
					url : "msgSend.do",
					method : "GET",
					data : {
						msgRoomNo : msgRoomNo,
						otherId : otherId,
						msgContent : msgContent
					},
					success : function(data) {
						console.log("메세지 전송 성공");

						// 메세지 입력칸 비우기
						$('.write_msg').val("");

						// 메세지 내용 리로드
						ShowMessageContent(msgRoomNo);

						// 메세지 리스트 리로드
						MessageList();
					},
					error : function() {
						alert('서버 에러');
					}
				});
			}
		};

		$(document).ready(function() {
			// 메세지 리스트 리로드
			FirstMessageList();
		});
		
	</script>

</body>
</html>