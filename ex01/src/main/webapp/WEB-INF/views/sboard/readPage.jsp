<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false"%>
<%@ include file="../include/header.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript"
	src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
	
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
<script>
//template를 이용하는 페이지를 처리하는 JavaScript의 기능
var bno=${boardVO.bno};
var replyPage=1;

function getPage(pageInfo){
	$.getJSON(pageInfo, function(data){
		printData(data.list, $("#repliesDiv"), $('#template'));
		printPaging(data.pageMaker, $(".pagination"));
		
		$("#modifyModal").modal('hide');
	});
}

var printPaging = function(pageMaker, target){
	var str ="";
	
	if(pageMaker.prev){
		str += "<li><a href='"+(pageMaker.startPage-1)+"'> << </a></li>";
	}
	
	for(var i=pageMaker.startPage, len = pageMaker.endPage; i <=len; i++){
		var strClass=pageMaker.cri.page == i?'class=active':'';
		str += "<li " + strClass+"><a href='" + i +"'>" + i + "</a></li>";
	}
	
	if(pageMaker.next){
		str += "<li><a href='" + (pageMaker.endPage + 1) + "'> >> </a></li>";
	}
	
	target.html(str);
}
</script>
<script>

	$(document)
			.ready(
					function() {
						var formObj = $("form[role='form']");

						console.log(formObj);

						//읽어온 데이터를 수정하는 코드
						$(".modifyBtn")
								.on(
										"click",
										function() {
											formObj
													.attr(
															"action",
															"/sboard/modifyPage?page=${cri.page}&perPageNum=${cri.perPageNum}&searchType=${cri.searchType}&keyword=${cri.keyword}");
											formObj.attr("method", "get");
											formObj.submit();
										});
						//읽어온 데이터를 삭제하는 코드
						$(".removeBtn")
								.on(
										"click",
										function() {
											console.log("삭제");
											formObj
													.attr(
															"action",
															"/sboard/removePage?page=${cri.page}&perPageNum=${cri.perPageNum}&searchType=${cri.searchType}&keyword=${cri.keyword}");
											formObj.submit();
										});
						//읽어온 데이터 화면에서 List버튼을 눌렀을경우 리스트 목록으로 이동하는 코드
						$(".goListBtn")
								.on(
										"click",
										function() {
											self.location = "/sboard/list?page=${cri.page}&perPageNum=${cri.perPageNum}&searchType=${cri.searchType}&keyword=${cri.keyword}";
										});
						//댓글 페이징 처리
						$("#repliesDiv").on("click", function(){
							if($(".timeline li").size() > 1){
								return;
							}
							getPage("/replies/" +bno + "/1");
						});
						//수정처리 하는 코드
						$("#replyModBtn").on("click", function(){
							var rno =$(".modal-title").html();
							var replytext=$("#replytext").val();
							
							$.ajax({
								type : 'put',
								url : '/replies/' + rno,
								headers:{
									"Content-Type": "application/json",
									"X-HTTP-Method-Override" : "PUT"
								},
								data:JSON.stringify({replytext:replytext}),
								dataType:'text',
								success:function(result){
									console.log("result: " + result);
									if(result == 'SUCCESS'){
										alert("수정되었습니다.");
										getPage("/replies/" + bno + "/" + replyPage);
									}
								}
							});
						});
						//삭제처리 하는 코드
						$("#replyDelBtn").on("click", function(){
							var rno = $(".modal-title").html();
							var replytext = $("#replytext").val();
							
							$.ajax({
								type:'delete',
								url:'/replies/' + rno,
								headers:{
									"Content-Type" : "application/json",
									"X-HTTP-Method-Override" : "DELETE"
								},
								dataType:'text',
								success:function(result){
									console.log("result: " + result);
									if(result == 'SUCCESS'){
										alert("삭제 되었습니다.");
										getPage("/replies/" + bno + "/" + replyPage);
									}
								}
							});
						});
						//해당 게시판의 모든 댓글을 가져와서 페이징 표시를 하는코도
						$("#pagination").on("click", "li a", function(event){
							
							event.preventDefault();
							
							replyPage = $(this).attr("href");
							
							getPage("/replies/" + bno + "/" +replyPage);
						});
						
						//각 댓글의 버튼 이벤트 처리
						$(".timeline").on("click",".replyLi",function(event){
							var reply= $(this);
							
							$("#replytext").val(reply.find('.timeline-body').text());
							$(".modal-title").html(reply.attr("data-rno"));
						});
						//댓글 등록을 눌렀을때 실행되는 코드
						$("#replyAddBtn").on("click",function(){
							var replyerObj = $("#newReplyWriter");
							var replytextObj = $("#newReplyText");
							var replyer = replyerObj.val();
							var replytext = replytextObj.val();
							
							$.ajax({
								type:'post',
								url:'/replies/',
								headers:{
									"Content-Type" : "application/json",
									"X-HTTP-Method-Override" : "POST"
								},
								dataType:'text',
								data: JSON.stringify({bno:bno, replyer:replyer, replytext:replytext}),
								success:function(result){
									console.log("result: " + result);
									if(result == 'SUCCESS'){
										alert("등록되었습니다.");
										replyPage = 1;
										getPage("/replies/" + bno + "/" +replyPage);
										replyerObj.val("");
										replytextObj.val("");
									}
								}
							});
						});
					});
	</script>
	<!-- handlebars template를 사용 -->
	<script>
	Handlebars.registerHelper("prettifyDate", function(timeValue){
		var dateObj = new Date(timeValue);
		var year = dateObj.getFullYear();
		var month = dateObj.getMonth() + 1;
		var date = dateObj.getDate();
		return year+"/"+month+"/"+date;
	});
	
	var printData = function(replyArr, target, templateObject){
		var template = Handlebars.compile(templateObject.html());
		
		var html = template(replyArr);
		$(".replyLi").remove();
		target.after(html);
	}
	</script>
<title>Insert title here</title>
</head>
<body>
	<form role="form" method="post">
		<input type='hidden' name='bno' value="${boardVO.bno }"> <input
			type='hidden' name='page' value="${cri.page }"> <input
			type='hidden' name='perPageNum' value="${cri.perPageNum }"> <input
			type='hidden' name='searchType' value="${cri.searchType }"> <input
			type='hidden' name='keyword' value="${cri.keyword }">
	</form>

	<div class="box-footer">
		<button type="submit" class="btn btn-warning modifyBtn">Modify</button>
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
			<textarea class="form-control" name="content" rows="3"
				readonly="readonly">${boardVO.content }</textarea>
		</div>
		<div class="form-group">
			<label for="exampleInputEmail1">Writer</label> <input type="text"
				name="writer" class="form-control" value="${boardVO.writer }"
				readonly="readonly">
		</div>
	</div>
	<!-- /.box-body -->

	<div class="row">
		<div class="col-md-12">

			<div class="box box-success">
				<div class="box-header">
					<h3 class="box-title">ADD NEW REPLY</h3>
				</div>
				<div class="box-body">
					<label for="newReplyWriter">Writer</label> <input
						class="form-control" type="text" placeholder="UESR ID"
						id="newReplyWriter"> <label for="newReplyText">ReplyText</label>
					<input class="form-control" type="text" placeholder="REPLY TEXT"
						id="newReplyText">
				</div>
				<!-- /.box-body -->
				<div class="box-footer">
					<button type="submit" id="replyAddBtn">ADD
						REPLY</button>
				</div>
			</div>
			<!-- The time line -->
			<ul class="timeline">
			
			<!-- timeline time label -->
			<li class="time-label" id = "repliesDiv"><span class="bg-green">Replies List</span></li>
			
			</ul>
			
			<div class='text-center'>
			<ul id="pagination" class="pagination pagination-sm no-margin">
			
			</ul>
			</div>
		</div>
	</div>
	<!-- Modal -->
	<div id="modifyModal" class="modal modal-primary fade" role = "dialog">
		<div class="modal-dialog">
			<!-- Modal content -->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class = "modal-title"></h4>
				</div>
				<div class="modal-body" data-rno>
					<p><input type="text" id="replytext" class="form-control"></p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info" id="replyModBtn">Modify</button>
					<button type="button" class="btn btn-danger" id="replyDelBtn">DELETE</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>



</body>
<%@ include file="../include/footer.jsp"%>
</html>