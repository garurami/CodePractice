<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript"
	src="/resources/plugins/jQuery/jQuery-2.1.4.min.js">
	
</script>
<style>
#modDiv {
	width: 300px;
	height: 100px;
	background-color: gray;
	position: absolute;
	top: 50%;
	left: 50%;
	margin-top: -50px;
	margin-left: -150px;
	padding: 10px;
	z-index: 1000;
}
</style>
<title>Insert title here</title>

</head>
<script type="text/javascript">
	var bno = 1509;
	
	getPageList(1);
	
	//댓글 불러오는 함수
	function getAllList() {
		$.getJSON("/replies/all/" + bno, function(data) {

			var str = "";
			console.log(data.length);

			$(data).each(
					function() {
						str += "<li data-rno='"+ this.rno+"'class='replyLi'>"
								+ this.rno + ":" + this.replytext
								+ "<button>MOD</button></li>";
					});
			$("#replies").html(str);
			
		});
	}
	//page 만드는 함수
	 function getPageList(page){
		
		 
		
		$.getJSON("/replies/"+bno+"/"+page, function(data){
			
			console.log(data.list.length);
			
			var str = "";
			
			$(data.list).each(function(){
				str+="<li data-rno='" + this.rno+"' class='replyLi'>"+this.rno +":" + this.replytext+
				"<button>MOD</button></li>";
			});
			$("#replies").html(str);
			
			printPaging(data.pageMaker);
		});
	} 
	//pageMaker을 이용해서 printPaging()을 호출하는 함수
	 function printPaging(pageMaker){
		
		
		var str="";
		
		if(pageMaker.prev){
			str += "<li><a href='"+(pageMaker.startPage-1)+"'> << </a></li>";
		}
		
		for(var i=pageMaker.startPage, len = pageMaker.endPage; i <=len; i++){
			var strClass= pageMaker.cri.page == i?'class=active':'';
			str += "<li "+strClass+"><a href='" + i + "'>" +i+"</a></li>";
		}
		
		if(pageMaker.next){
			str += "<li><a href='"+(pageMaker.endPage + 1)+"'> >> </a></li>";
		}
		
		$('.pagination').html(str);
		
	} 
	$(document).ready(function() {
		
		//댓글 추가하는 ajax
		$("#replyAddBtn").on("click", function() {
			
			var replyer = $("#newReplyWriter").val();
			var replytext = $("#newReplyText").val();

			$.ajax({
				type : 'post',
				url : '/replies',
				headers : {
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "POST"
				},
				dataType : 'text',
				data : JSON.stringify({
					bno : bno,
					replyer : replyer,
					replytext : replytext
				}),
				success : function(result) {
					if (result == 'SUCCESS') {
						alert("등록 되었습니다.");
						getAllList();
						
					}
				}
			});
		});
		
		//MOD버튼 눌렀을시 나오는 DIV
		$("#replies").on("click", ".replyLi button", function() {
			var reply = $(this).parent();

			var rno = reply.attr("data-rno");
			var replytext = reply.text();
			
			$(".modal-title").html(rno);
			$("#replytext").val(replytext);
			$("#modDiv").show("slow");

		});
		//댓글 삭제하는 ajax
		$("#replyDelBtn").on("click", function(){
			
			var rno = $(".modal-title").html();
			var replytext = $("#replytext").val();
			
			$.ajax({
				type : 'delete',
				url : '/replies/' + rno,
				headers : {
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "DELETE"
				},
				dataType : "text",
				success : function(result){
					console.log("result: " + result);
					if(result == 'SUCCESS'){
						alert("삭제 되었습니다.");
						$("#modDiv").hide("slow");
						getAllList();
					}
				}
			});
		});
		//댓글 수정하는 ajax
		$("#replyModBtn").on("click", function(){
		
			var rno = $(".modal-title").html();
			var replytext = $("#replytext").val();
			
			$.ajax({
				type:'put',
				url:'/replies/' + rno,
				headers:{
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override":"PUT"
				},
				data:JSON.stringify({replytext:replytext}),
				dataType:'text',
				success:function(result){
					console.log("result: " + result);
					if(result == 'SUCCESS'){
						alert("수정되었습니다.");
						$("#modDiv").hide("slow");
						//getAllList();
						getPageList(replyPage);
					}
				}
			});
		});
		var replyPage=1;
		
		$(".pagination").on("click","li a", function(event){
			event.preventDefault();
			replyPage=$(this).attr("href");
			getPageList(replyPage);
		});
	});

</script>

<body>

	<h2>Ajax Test Page</h2>

	<div>
		<div>
			REPLYER <input type='text' name='replyer' id='newReplyWriter'>
		</div>
		<div>
			REPLY TEXT <input type='text' name='replytext' id='newReplyText'>
		</div>
		<button id="replyAddBtn">ADD REPLY</button>
	</div>
	<!-- jQuery 2.1.4 -->
		<ul id="replies">

	</ul>
	
	<ul class='pagination'>
	
	</ul>
	<div id='modDiv' style="display: none;">
		<div class='modal-title'></div>
		<div>
			<input type='text' id='replytext'>
		</div>
		<div>
			<button type="button" id="replyModBtn">Modify</button>
			<button type="button" id="replyDelBtn">DELETE</button>
			<button type="button" id="closeBtn">Close</button>
		</div>
	</div>

</body>
</html>