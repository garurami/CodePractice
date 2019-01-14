<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../include/header.jsp"%>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
<script type="text/javascript" src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script type="text/javascript">

var bno = ${boardVO.bno};
var replyPage = 1;

//getPage()는 특정한 게시물에 대한 페이징 처리를 위해서 호출되는 함수 내부적으로 jQuery를 이용해서 JSON타입의 데이터를 처리
//getPage()는 페이지 번호를 파라미터로 전달 받고, jQuery의 getJSON()을 이용해서 댓글의 목록 데이터를 처리.
//댓글의 목록 데이터는 'pageMaker'와 'list'로 구성되므로 이를 printPaging()과 printData()에서 처리
function getPage(pageInfo){
	$.getJSON(pageInfo, function(data){
		printData(data.list, $("#repliesDiv"), $('#template'));
		printPaging(data.pageMaker, $(".pagination"));
		
		$("#modifyModal").modal('hide');
	});
}

var printPaging = function(pageMaker, target){
	var str =""
	if(pageMaker.prev){
		str += "<li><a href='"+(pageMaker.startPage-1)+"'> << </a></li>";
	}
	for(var i=pageMaker.startPage, len = pageMaker.endPage; i <= len; i++){
		var strClass=pageMaker.cri.page == i?'class=active':'';
		str += "<li " + strClass+"><a href='"+i+"'>"+i+"</a></li>";
	}
	if(pageMaker.next){
		str += "<li><a href='"+(pageMaker.endPage + 1)+"'> >> </a></li>";
	}
	
	target.html(str);
};
//화면상에서 하나의 댓글을 구성하는 부분
//prettifyDate regdate에는 handlebar의 기능을 확장하는 방법의 예로 사용됨
//helper라는 기능을 이용해서 데이터의 상세한 처리에 필요한 기능들을 처리. 만약 원한는 기능이 없을 경우 registerHelper()를 이용해서 사용자가 새로운 기능을 추가 할 수 있음.
Handlebars.registerHelper("prettifyDate", function(timeValue){
	var dateObj = new Date(timeValue);
	var year = dateObj.getFullYear();
	var month = dateObj.getMonth() + 1;
	var date = dateObj.getDate();
	return year +"/" + month + "/" + date;
});

var printData = function (replyArr, target, templateObject){
	var template = Handlebars.compile(templateObject.html());
	
	var html = template(replyArr);
	$(".replyLi").remove();
	target.after(html);
}
	$(document).ready(function() {
		var formObj = $("form[role='form']");

		console.log(formObj);

		$(".btn-wrning").on("click", function() {
			formObj.attr("action", "/sboard/modifyPage");
			formObj.attr("method", "get");
			formObj.submit();
		});
		$(".btn-danger").on("click", function() {
			formObj.attr("action", "/sboard/removePage");
			formObj.submit();
		});
		$(".btn-primary").on("click", function() {
			formObj.attr("method", "get");
			formObj.attr("action", "/sboard/list");
			formObj.submit();
		});
		//최초로 댓글의 1페이지를 가져오는 작업
		$("#repliesDiv").on("click", function(){
			
			if($(".timeline li").size() > 1){
				return;
			}
			
			getPage("/replies/" + bno + "/1");
		});
		//댓글의 버튼 이벤트 처리
		$(".timeline").on("click",".replyLi",function(event){
			
			var reply=$(this);
			
			$("#replytext").val(reply.find('.timeline-body').text());
			$(".modal-title").html(reply.attr("data-rno"));
		});
		//페이징 처리의 코드는 <ul class='pagination'>에서 이루어짐.
		$(".pagination").on("click", "li a", function(event){
			
			event.preventDefault();
			
			replyPage = $(this).attr("href");
			
			getPage("/replies/" + bno + "/" +replyPage);
		});
		
		$("#replyAddBtn").on("click",function(){
			var replyerObj = $("#newReplyWriter");
			var replytextObj = $("#newReplyText");
			var replyer = replyerObj.val();
			var replytext = replytextObj.val();
			
			$.ajax({
				type : 'post',
				url:'/replies/',
				headers:{
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "POST"
					},
					dataType:'text',
					data:JSON.stringify({bno:bno, replyer:replyer, replytext:replytext}),
					success:function(result){
						console.log("result: " + result);
						if(result == 'SUCCESS'){
							alert("등록 되었습니다.");
							replyPage = 1;
							getPage("/replies/"+bno+"/"+replyPage);
							replyerObj.val("");
							replytextObj.val("");
						}
					}
				});
		});
	});
</script>
<!-- Handlerbars를 사용하는 템플릿 코드 -->
<script id="template" type="text/x-handlebars-template">
{{#each .}}
<li class="replyLi" data-rno={{rno}}>
<i class="fa fa-comments bg-blue"></i>
	<div class="timeline-item">
		<span class="time">
			<i class="fa fa-clock-o"></i>{{prettifyDate regdate}}
		</span>
		<h3 class="timeline-header"><strong>{{rno}}</strong> -{{replyer}}</h3>
		<div class="timeline-body">{{replytext}}</div>
			<div class="timeline-footer">
				<a class="btn btn-primary btn-xs" data-toggle="modal" data-target="#modifyModal">Modify</a>
			</div>
		</div>
</li>
{{/each}}
</script>
<body>

	<div class="box-footer">
		<button type="submit" class="btn btn-wrning modifyBtn">Modify</button>
		<button type="submit" class="btn btn-danger removeBtn">REMOVE</button>
		<button type="submit" class="btn btn-primary goListBtn">LIST
			ALL</button>
	</div>

	


	<div class="box-body">
		<div class="form-group">
			<label for="exampleInputEmail1">Title</label> <input type="text"
				name='title' class="form-control" value="${boardVO.title }"
				readonly="readonly">
		</div>
		<div class="form-group">
			<label for="exampleInputPassword1">Content</label>
			<textarea name="content" class="form-control" rows="3"
				readonly="readonly">${boardVO.content }</textarea>
		</div>
		<div class="form-group">
			<label for="exampleInputEmail1">Writer</label> <input type="text"
				name="writer" class="form-control" value="${boardVO.writer }"
				readonly="readonly">
		</div>
	</div>
	<!-- /.box-body -->

	<form role="form" action="modifyPage" method="post">
		<input type='hidden' name='bno' value="${boardVO.bno }"> <input
			type='hidden' name='page' value="${cri.page }"> <input
			type='hidden' name='perPageNum' value="${cri.perPageNum }"> <input
			type='hidden' name='searchType' value="${cri.searchType }"> <input
			type='hidden' name='keyword' value="${cri.keyword }">
	</form>
	
	<div class="row">
		<div class="col-md-12">
			<div class="box box-success">
				<div class="box-header">
					<h3 class="box-title">ADD NEW REPLY</h3>
				</div>
				<div class="box-body">
					<label for="newReplyWriter">Writer</label> <input
						class="form-control" type="text" placeholder="USER ID"
						id="newReplyWriter"> <label for="newReplyText">ReplyText</label>
					<input class="form-control" type="text" placeholder="REPLY TEXT"
						id="newReplyText">
				</div>
				<!-- /.box-body -->
				<div class="box-footer">
					<button type="submit" class="btn btn-primary" id="replyAddBtn">ADD
						REPLY</button>
				</div>
			</div>
		</div>
	</div>
	<!-- The time line -->
	<ul class="timeline">
	<!-- timeline time label -->
	<li class="time-label" id="repliesDiv"><span class="bg-green">Replies List</span></li>
	</ul>
	<div class='text-center'>
	<ul id="pagination" class="pagination pagination-sm no-margin">
	
	</ul>
	</div>
	<%@ include file="../include/footer.jsp"%>
</body>
</html>