<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@include file="../includes/header.jsp"%>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.5.0.min.js"></script>
<script type="text/javascript">
	$(function(){
		var b_no = $("#b_no").val();
		$("#clickheart").hide();

		var getCDist = function(c_no){
			$.ajax("/category/get",{data: {c_no: c_no}, success: function(data){
				console.log(data);
			}});
		}
		$("#updateBtn").on("click",function(){
			self.location = "/board/update?b_no="+b_no;
		})
		$("#deleteBtn").on("click",function(){
			console.log(b_no);
			var re = confirm("정말로 삭제하시겠습니까?");
			if(re){
				$.ajax("/board/delete", {type: 'GET', data: {b_no: b_no}, success: function(result){
					if( result == "0"){
						alert("죄송합니다. 예기치 않은 오류가 발생했습니다. 게시물을 삭제하지 못 했습니다.");
					}else{
						alert("게시물을 성공적으로 삭제했습니다.");
						window.history.back();
					}
				}});
			}
		})
		
		//댓글 목록 ajax
		$.ajax("/reply/list",{type:"GET",data:{b_no:b_no}, success: function(reply){
			console.log(reply);
			$.each(reply, function(idx,r){
 				var tr = $("<tr class='rep'></tr>");
				var button= $("<button class='deleteReply'></button>").text("삭제").attr("r_no",r.r_no);
				var td1 = $("<td width=10%></td>").html(r.m_id);
				var td2 = $("<td width=50%></td>").html(r.r_content);
				//날짜 양식 맞춰야함.
				var td3 = $("<td width=20%></td>").html(r.r_date);
				var td4 = $("<td width=10%></td>").html("신고버튼");
				var td5 = $("<td width=10%></td>");
				td5.append(button);
				tr.append(td1,td2,td3,td4,td5);
				$("#replyTable").append(tr);
			})
		}})

		//댓글 등록 ajax
		$("#insertReply").on("click",function(){
			var r = $("#boardReply").serialize();
			var re = confirm("Ae-Ho는 클린한 웹 서비스를 위하여 댓글 수정 기능을 지원하지 않습니다. 착한 댓글을 등록하시겠습니까?")
			if(re){
				$.ajax("/reply/insert",{type:"POST", data:r, success:function(result){
					alert(result);
					location.href="/board/get?b_no="+b_no;
				}})
			}
		})

		//댓글 삭제 ajax 기능구현부터!
		$(document).on("click",".deleteReply",function(){
			var rno = $(this).attr("r_no");
			var re = confirm("해당 댓글을 삭제하시겠습니까?")
			if(re){
				$.ajax("/reply/delete",{type:"GET", data:{r_no:rno}, success:function(result){
					alert(result)
					location.href="/board/get?b_no="+b_no;
				}})
			}
		})
		
		//좋아요
		$(document).on("click","#heart",function(){
			$.ajax("/board/insertLove",{data:{m_id:"tiger", b_no:b_no}, success:function(result){
				alert(result);
				if(result == 1){
					$("#clickheart").show();
					$("#heart").hide();
				}
				
			}})
		})

		//좋아요 취소
		$(document).on("click","#clickheart",function(){
			$.ajax("/board/")
		})
		
	})
</script>
	<input type="hidden" id="b_no" value="${ board.b_no }">
	<input type="hidden" id="c_no" value="${ board.c_no }">
	<table class="table table-bordered">
		<tr>
			<td colspan="3"><h3><c:out value="${board.b_title }"/></h3></td>
			<td>
				<img id="heart" src="/img/heart.png"/ width="30" height="30">
				<img id="clickheart" src="/img/clickheart.png"/ width="30" height="30">				
			</td>
		</tr>
		<tr>
			<td width="45%"><c:out value="${board.m_id }"/></td>
			<td width="15%"><fmt:formatDate pattern="yyyy-MM-dd" value="${board.b_date }"/></td>
			<td width="15%"><fmt:formatDate pattern="yyyy-MM-dd" value="${board.b_updatedate }"/></td>
			<td width="25%">조회 <c:out value="${board.b_hit }"/>  / Love <c:out value="${board.b_lovecnt }"/> / hate <c:out value="${board.b_hatecnt }"/></td>
		</tr>
		<tr>
			<td colspan="4">
				<c:out value="${board.b_content }"/>
			</td>
		</tr>
	</table>
	<button id="updateBtn" class="btn btn-outline-dark">수정</button>
	<button id="deleteBtn" class="btn btn-outline-dark">삭제</button>
	<hr>
	<h4>댓글</h4>
	<table id="replyTable" class="table table-bordered">
	</table>
	<hr>
	<form id="boardReply">
		<input type="hidden" name="b_no" value="<c:out value='${board.b_no }'/>">
		<input type="text" name="m_id" value="tiger" readonly="readonly">
		<input type="text" name="r_content" required="required">
	</form>
	<button type="submit" id="insertReply" class="btn btn-outline-dark">댓글등록</button>
<%@include file="../includes/footer.jsp"%>