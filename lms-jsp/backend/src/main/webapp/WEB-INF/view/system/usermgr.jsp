<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>사용자 관리</title>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
                              
<script type="text/javascript">
    
    var pagesize = 10;
    var bloacksize = 5;    
   
    $(document).ready(function() {
    	
    	fRegisterButtonClickEvent();
    	
    	listuser();    	
    	
    	comcombo("gender", "sex", "sel", "");
    	comcombo("usertype", "usertypesel", "all", "");
    	comcombo("usertype", "user_type", "sel", "");
    	comcombo("areacd", "loc", "sel", "");
    	
    	
    	

   });
    
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch (btnId) {			   
			    case 'btnSave' :
			    	fn_savefile();
				    break;				
			    case 'btnDelete' :
			    	fn_delete();
				    break;	
			    case 'btnSearchUser' :
				    listuser();
				    break;	
				case 'btnClose' :
					gfCloseModal();
					break;
			}
		});
		
		$("#preview").on("click", function(){
			fn_filefownload();
        });				
        
		$("#previewimgdiv").on("click", function(){
			fn_filefownload();
        });		
		
	}
    
   function listuser(currentpage)  {
	   
	   currentpage = currentpage || 1;
	   
	   var param = {
			    searchKey : $("#searchKey").val()
			  , searchword : $("#searchword").val()
			  , usertype : $("#usertypesel").val()
			  , currentpage : currentpage
			  , pagesize : pagesize
	   };
	   
	   var listcallback = function(data) {
			console.log(data);
			
			// 기존 목록 삭제 & 추가
			$('#listUser').empty().append(data);	
			
			// 총 개수 추출			
			var usertotalcnt = $("#usertotalcnt").val();
			
			
			// 페이지 네비게이션 생성			
			var paginationHtml = getPaginationHtml(currentpage, usertotalcnt, pagesize, bloacksize, 'listuser');
			console.log("paginationHtml : " + paginationHtml);
			$("#userPagination").empty().append( paginationHtml );
			
			// 현재 페이지 설정
			$("#currenViewPage").val(currentpage);
		};
	   
	   callAjax("/system/userlist.do", "post", "text", true, param , listcallback);
	   
   }
    
   function findzip() {   
	   
	   new daum.Postcode({
           oncomplete: function(data) {
               // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

               // 각 주소의 노출 규칙에 따라 주소를 조합한다.
               // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
               // zipcd
               // addr
               // dtladdr
               
               var addr = ''; // 주소 변수
               var extraAddr = ''; // 참고항목 변수

               //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
               if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                   addr = data.roadAddress;
               } else { // 사용자가 지번 주소를 선택했을 경우(J)
                   addr = data.jibunAddress;
               }

               // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
               if(data.userSelectedType === 'R'){
                   // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                   // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                   if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                       extraAddr += data.bname;
                   }
                   // 건물명이 있고, 공동주택일 경우 추가한다.
                   if(data.buildingName !== '' && data.apartment === 'Y'){
                       extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                   }
                   // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                   if(extraAddr !== ''){
                       extraAddr = ' (' + extraAddr + ')';
                   }
                   // 조합된 참고항목을 해당 필드에 넣는다.
                   // document.getElementById("sample6_extraAddress").value = extraAddr;
               
               } else {
                   //document.getElementById("sample6_extraAddress").value = '';
               }

               // 우편번호와 주소 정보를 해당 필드에 넣는다.
               //document.getElementById('sample6_postcode').value = data.zonecode;
               //document.getElementById("sample6_address").value = addr;
               
               
               console.log(JSON.stringify(data));
               console.log(JSON.stringify(data.zonecode));
               console.log(JSON.stringify(addr));
               console.log(JSON.stringify(extraAddr));
               
               $("#zipcd").val(data.zonecode);
               $("#addr").val(addr);
               
               // 커서를 상세주소 필드로 이동한다.
               //document.getElementById("sample6_detailAddress").focus();
           }
       }).open();	   
	   
	   
   }
   
   function newreg() {	   
	   
	   $("#action").val("I");
	   
	   initforn();	   
	   
	   gfModalPop("#usermgrdiv");
   }
   
   function moduser(loginid) {
	   
	   var param = {
			   loginid : loginid
	   }
	   
	   var selectusercallback = function(data) {
		   console.log(JSON.stringify(data));
		   
		   $("#action").val("U");
		   
		   initforn(data.userdata);	   
		   
		   gfModalPop("#usermgrdiv");
		   
	   }
	   
	   callAjax("/system/userselect.do", "post", "json", true, param , selectusercallback);
	   
	   
   }
   
   
   function initforn(object) {
	   
	   if($("#action").val()  == "I" ) {
		    console.log("등록");
		   
		    $("#loginID").val("");
		    $("#user_type").val("");
		    $("#name").val("");
		    $("#password").val("");
		    $("#sex").val("");
		    $("#hp").val("");
		    $("#email").val("");
		    $("#zipcd").val("");
		    $("#addr").val("");
		    $("#dtladdr").val("");
		    $("#loc").val("");
		    $("#birthday").val("");
            		    
		    $("#updafile").val("");
		    $("#preview").empty();
		    $("#previewimgdiv").empty().append("<img src='' id='previewimg'  name='previewimg'  style='width:100px; height:100px' />");
		    //$("#previewimg").attr("scr","");
		    
		    $("#existyndiv").hide();
		    
		    $("#btnDelete").hide();
		    $("#iddupcheck").show();	   
		    $("#loginID").attr("readonly",false);
		    
	   } else {
		   console.log("수정");
		   
		   $("#loginID").val(object.loginId);
		    $("#user_type").val(object.user_type);
		    $("#name").val(object.name);
		    $("#password").val(object.password);
		    $("#sex").val(object.sex);
		    $("#hp").val(object.hp);
		    $("#email").val(object.email);
		    $("#zipcd").val(object.zipcd);
		    $("#addr").val(object.addr);
		    $("#dtladdr").val(object.dtladdr);
		    $("#loc").val(object.loc);
		    $("#birthday").val(object.birthday);
		    
		    // img img tag 직접 접근
		    if(object.filename == "" || object.filename == null) {
		    	$("#previewimg").attr("src","");
		    	
		    	$("#existyndiv").hide();
		    } else {
		    	$("#existyndiv").show();
		    	
		    	var fileext = object.fileext;
		    	
		    	if(fileext.toLowerCase() == "jpg" || fileext.toLowerCase() == "png"  || fileext.toLowerCase() == "gif") {
		    		$("#previewimg").attr("src",object.logicalpath);
		    	} else {
		    		$("#previewimgdiv").empty().append(object.filename);
		    	}
		    }
		    
		    // preview		    
		    $("#preview").empty();
		    
		    if(object.filename == "" || object.filename == null) {
		    	$("#preview").empty();
		    } else {
		    	
		    	var fileext = object.fileext;
		    	
		    	if(fileext.toLowerCase() == "jpg" || fileext.toLowerCase() == "png"  || fileext.toLowerCase() == "gif") {
		    		$("#preview").empty().append("<img src='" + object.logicalpath +  "'  style='width:100px; height:100px'     />");
		    	} else {
		    		$("#preview").empty().append(object.filename);
		    	}
		    }
           		    
		    $("#updafile").val("");
		    $("#btnDelete").show();	    
		    $("#iddupcheck").hide();	   
		    $("#dupcheckyn").val("Y");
		    $("#loginID").attr("readonly",true);
		    
		    
		    
	      } 
}
	   
function filesel(event) {
		   var image = event.target;
		      
	       if(image.files[0]) {

	            var selfile = image.files[0].name;
	            var selfilearr = selfile.split(".");     
	            var inserthtml = "";
	            var lastindex = selfilearr.length - 1;
	            	            
	            if(selfilearr[lastindex].toLowerCase() == "jpg" || selfilearr[lastindex].toLowerCase() == "gif" || selfilearr[lastindex].toLowerCase() == "jpge" || selfilearr[lastindex].toLowerCase() == "png") {
	               inserthtml = "<img src='" + window.URL.createObjectURL(image.files[0]) + "' style='width:100px; height:100px' />";
	            } else {
	               inserthtml = selfile;
	            }

	           $("#preview").empty().append(inserthtml);
		   
	           $("#previewimg").attr("src",window.URL.createObjectURL(image.files[0]));
	           
	           $('input[id=existyn]').prop('checked', false);
	           // $('input[id=existyn]').prop('readonly', true);
	   }
   }
   
   function iddupcheck() {
	   
	   if($("#loginID").val() == "" || $("#loginID").val() == null) {
		   alert("Login ID를 입력해주세요.");
		   return;
	   }
	   
	   var param = {
			   dupcheckid : $("#loginID").val(),
	   }
	   
	   var dupcheckcallback = function(data) {
		   console.log(JSON.stringify(data));		   
		   // data.idcheck
		   alert(data.idcheckmsg);
		   
		   $("#dupcheckyn").val(data.idcheck);		  
		   
	   }
	   
	   callAjax("/system/iddupcheck.do", "post", "json", true, param , dupcheckcallback);
	   
   }
 
	/** 저장 validation */
	function fn_Validate() {

		var chk = checkNotEmpty(
				[
						[ "loginID", "Login ID를 입력해 주세요." ]
					,	[ "user_type", "사용자 구분을 입력해 주세요" ]
					,	[ "name", "이름을 입력해 주세요." ]
					,	[ "password", "비밀번호을 입력해 주세요." ]	
				]
		);

		if (!chk) {
			return;
		}

		return true;
	}   
   
   
   function fn_savefile() {		
	   
	   if($("#dupcheckyn").val() == "N") {
		   alert("중복 체크를 해주세요");
		   return;
	   }
	   
	   if(!fn_Validate()) return;
		
		var frm = document.getElementById("myForm");
		frm.enctype = 'multipart/form-data';
		var fileData = new FormData(frm);		
		
		var filesavecallback = function(returnval) {
			console.log( JSON.stringify(returnval) );
			
			if(returnval.result == "Y") {
				alert(returnval.resultmsg);
				gfCloseModal();
				
				if($("#action").val() == "U") {
					listuser($("#currenViewPage").val());
				} else {
					listuser();
				}
			} else {
				alert("오류가 발생 되었습니다.");
			}		
			
		}
		
		callAjaxFileUploadSetFormData("/system/usersave.do", "post", "json", true, fileData, filesavecallback);
	
	}
   
   function fn_delete() {	   
	   $("#action").val("D");
	   
	   fn_savefile();
   }
   
	function fn_filefownload() {		
		var params = "";
		params += "<input type='hidden' name='loginID' id='loginID' value='"+ $("#loginID").val() +"' />";
		
		jQuery("<form action='/system/downloaduserfile.do' method='post'>"+params+"</form>").appendTo('body').submit().remove();

	}
	
	
</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" id="currenViewPage" value="1">
	<input type="hidden" name="dupcheckyn" id="dupcheckyn" value="N">
	<input type="hidden" name="action" id="action" value="">
	
   <!-- 모달 배경 -->
   <div id="mask"></div>

   <div id="wrap_area">

      <h2 class="hidden">header 영역</h2>
      <jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

      <h2 class="hidden">컨텐츠 영역</h2>
      <div id="container">
         <ul>
            <li class="lnb">
               <!-- lnb 영역 --> <jsp:include
                  page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
            </li>
            <li class="contents">
               <!-- contents -->
               <h3 class="hidden">contents 영역</h3> <!-- content -->
               <div class="content">

                  <p class="Location">
                     <a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
                        class="btn_nav bold">시스템관리</span> <span class="btn_nav bold">사용자 관리
                        </span> <a href="/system/userMgmt.do" class="btn_set refresh">새로고침</a>
                  </p>
                  <p class="conTitle">
						<span>사용자 관리</span> <span class="fr"> 
						<select id="searchKey" name="searchKey" style="width: 100px;">
							    <option value="" >전체</option>
								<option value="loginid" >LoginID</option>
								<option value="name" >이름</option>
						</select> 							
     	                <input type="text" style="width: 300px; height: 25px;" id="searchword" name="searchword">  
						<select id="usertypesel" name="usertypesel"></select>
						<a href="" class="btnType blue" id="btnSearchUser" name="btn"><span>검  색</span></a>
						<a class="btnType blue" href="javascript:newreg();" name="modal"><span>신규등록</span></a>
						</span>
					</p>    
						
					<div id="divuserList">
						<table class="col">
							<caption>caption</caption>
							<colgroup>
							    <col width="5%">
								<col width="15%">
								<col width="20%">
								<col width="20%">
								<col width="15%">
								<col width="15%">
								<col width="10%">
							</colgroup>

							<thead>
								<tr>
								    <th scope="col">번호</th>
									<th scope="col">Login ID</th>
									<th scope="col">성명</th>
									<th scope="col">유저 타입</th>
									<th scope="col">등록일자</th>
									<th scope="col">생년월일</th>
									<th scope="col"></th>
								</tr>
							</thead>
							<tbody id="listUser"></tbody>
						</table>
					</div>

					<div class="paging_area"  id="userPagination"> </div>
           </div> <!--// content -->
  
               <h3 class="hidden">풋터 영역</h3>
               <jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
            </li>
         </ul>
      </div>
   </div>

   <!--// 모달팝업 -->
   	<div id="usermgrdiv" class="layerPop layerType2" style="width: 800px;">
		<dl>
			<dt>
				<strong>사용자 관리</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Login ID <span class="font_red">*</span></th>
							<td>
							     <input type="text" class="inputTxt p45" name="loginID" id="loginID" />
							     <a href="javascript:iddupcheck();" class="btnType blue" id="iddupcheck" name="iddupcheck"><span>중복체크</span></a>
							</td>
							<th scope="row">비밀번호 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100"
								name="password" id="password" /></td>
						</tr>
						<tr>
							<th scope="row">이름 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100"
								name="name" id="name" /></td>
							<th scope="row">사용자 구분 <span class="font_red">*</span></th>
							<td><select id="user_type" name="user_type"></select> </td>
						</tr>

						<tr>
							<th scope="row">성별</th>
							<td> 
							    <select id="sex" name="sex"></select>
                             </td>
							<th scope="row">휴대폰</th>
							<td><input type="text" class="inputTxt p100" name="hp" id="hp" /></td>
						</tr>

						<tr>
							<th scope="row">eMail </th>
							<td colspan=3><input type="text" class="inputTxt p100"
								name="email" id="email" /></td>
						</tr>		
						
						<tr>
							<th scope="row">우편번호 </th>
							<td>
							    <input type="text" class="inputTxt p15"	name="zipcd" id="zipcd"  readonly />
							    <a class="btnType blue" href="javascript:findzip()" name="modal"><span>찾기</span></a>
							    <input type="text" class="inputTxt p100"	name="addr" id="addr"  readonly />
							 </td>
							<td colspan=2><input type="text" class="inputTxt p100" name="dtladdr" id="dtladdr" /></td>
						</tr>						
						
						<tr>
							<th scope="row">지역 </th>
							<td>
							    <select id="loc" name="loc"></select>
							</td>
							<th scope="row">생년월일 </th>
							<td><input type="date" class="inputTxt p100" name="birthday" id="birthday" /></td>
						</tr>				
						
						<tr>
							<th scope="row">사진 </th>
							<td><input type="file" class="inputTxt p100"
								name="updafile" id="updafile" onChange="javascript:filesel(event);"  />
							    
							    <div id="existyndiv">
							        <br>
							        기존파일 유지 <input type="checkbox" id="existyn" name="existyn"  />
							    </div> 
							</td>
							<th scope="row">미리보기 </th>
							<td>
							      <div id="preview" name="preview" ></div>
							      <div id="previewimgdiv" name="previewimgdiv">
							           <img src="" id="previewimg" name="previewimg"  style="width:100px; height:100px"/>
							      </div>
							</td>
						</tr>								
						
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSave" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDelete" name="btn"><span>삭제</span></a> 
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>

</form>   
</body>
</html>