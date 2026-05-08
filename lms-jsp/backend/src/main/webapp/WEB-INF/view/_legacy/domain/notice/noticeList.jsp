<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%--문자열을 data 속성에 넣을 때 필요--%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--<c:if test="${sessionScope.userType ne 'A'}">
    <c:redirect url="/dashboard/dashboard.do"/>
</c:if>--%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>공지사항</title>

    <script type="text/javascript">
        (function() {
            // 전체 URL
            var href = window.location.href;

            // hash(#) 기준 분리
            var hashIndex = href.indexOf('#');
            var urlNoHash = (hashIndex > -1) ? href.substring(0, hashIndex) : href;
            var hashPart  = (hashIndex > -1) ? href.substring(hashIndex)     : "";

            // ? 기준 분리
            var qIndex = urlNoHash.indexOf('?');
            if (qIndex > -1) {
                var base = urlNoHash.substring(0, qIndex);   // http://localhost/admin/notices

                history.replaceState(null, "", base + hashPart);
            }
        })();
    </script>

    <!-- sweet alert import -->
    <script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/domain/notice/newNoticeModal.jsp"></jsp:include>

    <script type="text/javascript">

        var pageSizeNotice      = ${empty pageSize ? 10 : pageSize};      // 한 페이지당 개수
        var pageBlockSizeNotice = 5;                                      // 페이징 블록 크기

        var currentPage = ${currentPage};
        var totalCount  = ${noticeCnt};

        $(function () {
            //공통 HTMl
            var paginationHtml = getPaginationHtml(
                currentPage,
                totalCount,
                pageSizeNotice,
                pageBlockSizeNotice,
                'goNoticePage' // 페이지 이동에 사용할 함수 이름
            );

            $("#noticePagination").html(paginationHtml);

            //상세 모달
            $(".divComGrpCodList").on("click", ".notice-row", function() {
                var $tr=$(this);

                var id = $tr.data("id");
                var title = $tr.data("title");
                var user =$tr.data("user");
                var viewCnt=$tr.data("view");
                var regDate = $tr.data("regdate");
                var content = $tr.data("content");

                // 모달에 값 넣기
                $("#nt_id").text(id);
                $("#nt_title").text(title);
                $("#nt_user").text(user);
                $("#nt_view_count").text(viewCnt);
                $("#nt_regdate").text(regDate);
                // 상세
                $("#nt_content_view").text(content);
                // 수정
                $("#nt_content_edit").val(content);

                // 모달, 마스크 보이기
                $("#mask").fadeIn();
                $("#noticeModal").fadeIn();

                // 모달 열림 - 항상 보기 모드
                $("#nt_content_view").show();
                $("#nt_content_edit").hide();
                $("#btnEditNotice span").text("수정");

                $("#mask").fadeIn();
                $("#noticeModal").fadeIn();

                // 조회수
                $.ajax({
                    url  : "${CTX_PATH}/admin/notices/viewCount",
                    type:"POST",
                    data: {
                        noticeId: id
                    },
                    success: function(res) {
                        if(res == "success"){
                            var newCnt = (parseInt(viewCnt, 10) || 0) +1;

                            $tr.data("view",newCnt);
                            $tr.find("td").eq(4).text(newCnt);
                            $("#nt_view_count").text(newCnt);

                        }
                    },
                    error: function (){
                        alert("조회수 증가 실패");
                    }
                });


            });
            //모달 닫기
            $("#btnCloseNotice").on("click",function(e){
                e.preventDefault();
                $("#noticeModal").fadeOut();
                $("#mask").fadeOut();
                location.reload();
            });

            // admin : 수정 + 저장 (학생, 강사 없음)
            $("#btnEditNotice").on("click",function(e) {
                e.preventDefault();

                var $btn=$(this);
                var mode = $btn.find("span").text().trim();

                // 수정모드
                if(mode === "수정") {
                    $("#nt_content_view").hide();
                    $("#nt_content_edit").show();
                    $btn.find("span").text("저장");
                }else{
                    //저장
                    var noticeId = $("#nt_id").text().trim();
                    var newContent = $("#nt_content_edit").val();

                    //ajax
                    $.ajax({
                        url  : "${CTX_PATH}/admin/notices/updateContent",
                        type:"POST",
                        data: {
                            notice_id:noticeId,
                            content:newContent
                        },
                        success: function(res) {
                            //성공하면 내용 갱신
                            $("#nt_content_view").text(newContent);
                            $("#nt_content_view").show();
                            $("#nt_content_edit").hide();
                            $btn.find("span").text("수정");

                            alert("수정되었습니다.");
                        },
                        error: function (){
                            alert("수정- 오류발생");
                        }
                    });
                }

            });

            $("a[name='modal']").on("click",function (e){
                e.preventDefault();
                $("#new_title").val("");
                $("#new_content").val("");

                $("#mask").fadeIn();
                $("#newNoticeModal").fadeIn();
            })
            // 공지사항 작성
            $("#btnSaveNotice").on("click", function(e){
                e.preventDefault();

                $.ajax({
                    url: "${CTX_PATH}/admin/notices/insertNotice",
                    type: "POST",
                    data: {
                        title: $("#new_title").val(),
                        content: $("#new_content").val()
                    },
                    success: function(res){
                        alert("등록되었습니다.");
                        location.reload();
                    },
                    error: function(){
                        alert("등록 중 오류 발생");
                    }
                });
            });

            // 삭제
            $("#btnDeleteNotice").on("click", function(e){
                e.preventDefault();

                // 글번호 가져오기
                var noticeId = $("#nt_id").text().trim();

                if(!noticeId) {
                    alert("글 번호를 찾을 수 없습니다.");
                    return;
                }
                if(!confirm("정말 삭제하시겠습니까?")){
                    return;
                }

                $.ajax({
                    url: "${CTX_PATH}/admin/notices/deleteNotice",
                    type: "POST",
                    data: {
                        noticeId:noticeId
                    },
                    success: function(res){
                        alert("삭제되었습니다..");
                        location.reload();
                    },
                    error: function(){
                        alert("삭제 중 오류 발생");
                    }
                });
            });

            // 검색
            $("#btnSearchGrpcod").on("click", function(e){
               e.preventDefault();
               // 항상 1페이지부터
               goNoticePage(1);
            });

        });
        //강사님 코드 - 변경
        function goNoticePage(page) {

            var pageSize = pageSizeNotice;
            var sname = $("#sname").val() || "";
            var searchType = $("#searchType").val() || "";

            var url = "${CTX_PATH}/admin/notices"
                + "?currentPage=" + page
                + "&pageSize=" + pageSize
                + "&sname=" + encodeURIComponent(sname)
                + "&searchType=" + encodeURIComponent(searchType);

            location.href = url;
        }

    </script>

    <style>
        .notice-row {
            cursor: pointer;
        }

        /* 모달 박스 */
        #noticeModal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);  /* 화면 정가운데 - 이거 외우기 */
            width: 800px;
            background: #fff;
            border: 1px solid #ccc;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            z-index: 1001;
            padding: 20px;
            box-sizing: border-box;
        }

        #newNoticeModal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%); /* 중앙 정렬 */
            width: 800px; /* 모달 너비 */
            background: #fff;
            border: 1px solid #ccc;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            z-index: 1001; /* 상세 모달과 동일하게 마스크보다 위에 있어야 함 */
            padding: 20px;
            box-sizing: border-box;
        }

        #noticeModal table.row {
            width: 100%;
        }
        .notice-btn-area {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;   /* 양 끝으로 벌리기 - 이거 외우기 */
            align-items: center;
        }

        .notice-btn-area .left,
        .notice-btn-area .right {
            display: flex;
            gap: 8px;
        }

        #mask {
            position: fixed;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.4);  /* 반투명 검정 - 이거 외우기 */
            z-index: 1000;
            display: none;
        }
    </style>

</head>
<body>
<form id="myForm" action=""  method="">
    <input type="hidden" id="currentPageComnGrpCod" value="1">
    <input type="hidden" id="currentPageComnDtlCod" value="1">
    <input type="hidden" id="tmpGrpCod" value="">
    <input type="hidden" id="tmpGrpCodNm" value="">

    <!-- 모달 배경 -->
    <div id="mask" style="display:none;"></div>

    <div id="wrap_area">

        <h2 class="hidden">header 영역</h2>
        <jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

        <h2 class="hidden">컨텐츠 영역</h2>
        <div id="container">
            <ul>
                <li class="lnb">
                    <!-- lnb 영역 -->
                    <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include>
                    <!--// lnb 영역 -->
                </li>
                <li class="contents">
                    <!-- contents -->
                    <h3 class="hidden">contents 영역</h3> <!-- content -->
                    <div class="content">

                        <p class="Location">
                            <a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
                                class="btn_nav bold">커뮤니티 관리</span> <span class="btn_nav bold">공지사항
								</span>
                            <a href="${CTX_PATH}/admin/notices?reset=Y" class="btn_set refresh">새로고침</a>
                        </p>

                        <p class="conTitle">
                            <span>공지사항</span>
                            <span class="fr">
                                <select id="searchType" name="searchType" style="width: 100px;">
                                    <option value="all" ${searchType == 'all' ? 'selected': ''}>전체</option>
                                    <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
                                    <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
                                </select>
     	                    <input type="text" style="width: 300px; height: 25px;" id="sname" name="sname" value="${param.sname}">
							<a href="" class="btnType blue" id="btnSearchGrpcod" name="btn"><span>검  색</span></a>
                            <c:if test="${sessionScope.userType eq 'A'}">
                                <a class="btnType blue" href="" name="modal"><span>신규등록</span></a>
                            </c:if>
							</span>
                        </p>

                        <div class="divComGrpCodList">
                            <table class="col">
                                <caption>caption</caption>
                                <colgroup>
                                    <col width="6%">
                                    <col width="17%">
                                    <col width="20%">
                                    <col width="20%">
                                    <col width="10%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th scope="col">순번</th>
                                    <th scope="col">제목</th>
                                    <th scope="col">작성자</th>
                                    <th scope="col">등록일</th>
                                    <th scope="col">조회수</th>
                                </tr>
                                </thead>
                                <tbody>
                                <!-- 데이터가 0개인 경우 -->
                                <c:if test="${noticeCnt == 0}">
                                    <tr>
                                        <td colspan="5">등록된 공지사항이 없습니다.</td>
                                    </tr>
                                </c:if>

                                <!-- 데이터가 있는 경우 -->
                                <c:if test="${noticeCnt > 0}">
                                    <c:set var="rowNum" value="${noticeCnt - (pageSize * (currentPage - 1))}" />
                                    <c:forEach items="${notice}" var="row" varStatus="st">
                                        <tr class="notice-row"
                                            data-id="${row.notice_id}"
                                            data-title="${row.title}"
                                            data-user="${row.user}"
                                            data-view="${row.view_count}"
                                            data-regdate="<fmt:formatDate value='${row.reg_date}' pattern='yyyy-MM-dd'/>"
                                            data-content="${row.content}" >

                                            <td>${rowNum - st.index}</td>
                                            <td>${row.title}</td>
                                            <td>${row.user}</td>
                                            <td><fmt:formatDate value="${row.reg_date}" pattern="yyyy-MM-dd " /></td>
                                            <td>${row.view_count}</td>
                                        </tr>
                                    </c:forEach>
                                </c:if>


                                </tbody>
                            </table>
                        </div>

                        <%-- 페이지 네이션 --%>
<%--                        <div class="paging_area" id="comnGrpCodPagination">
                            &lt;%&ndash; 페이징 계산 &ndash;%&gt;
                            <c:set var="totalPage" value="${(noticeCnt + pageSize -1) / pageSize}" />
                            <c:set var = "pageBlock" value = "5"/>

                            <c:set var="startPage" value="${((currentPage-1)/ pageBlock)*pageBlock+1}"/>
                            <c:set var = "endPage" value="${startPage + pageBlock -1}"/>
                            <c:if test ="${endPage > totalPage}">
                                <c:set var="endPage" value="${totalPage}"/>
                            </c:if>

                            &lt;%&ndash; 버튼 출력&ndash;%&gt;
                            <c:if test="${totalPage > 0}">
                                <div class="paging">
                                    &lt;%&ndash; 맨앞 &ndash;%&gt;
                                        <c:if test="${currentPage > 1}">
                                            <a class="first" href="?currentPage=1&pageSize=${pageSize}">
                                                <span class="hidden"> &lt;&lt; </span>
                                            </a>
                                            <a class="pre" href="?currentPage=${currentPage - 1}&pageSize=${pageSize}">
                                                <span class="hidden"> &lt; </span>
                                            </a>
                                        </c:if>
                                    &lt;%&ndash; 페이지 번호 &ndash;%&gt;
                                        <c:forEach var="p" begin="${startPage}" end="${endPage}">
                                            <c:choose>
                                                <c:when test="${p == currentPage}">
                                                    <strong>${p}</strong>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="?currentPage=${p}&pageSize=${pageSize}">${p}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>

                                    &lt;%&ndash;다음 / 맨뒤&ndash;%&gt;
                                        <c:if test="${currentPage < totalPage}">
                                            <a class="next" href="?currentPage=${currentPage + 1}&pageSize=${pageSize}">
                                                <span class="hidden"> &gt;&gt; </span>
                                            </a>
                                            <a class="last" href="?currentPage=${totalPage}&pageSize=${pageSize}">
                                                <span class="hidden"> &gt; </span>
                                            </a>
                                        </c:if>
                                </div>
                            </c:if>
                        </div>--%>
                        <div class="paging_area" id="noticePagination"></div>


                    </div> <!--// content -->

                    <h3 class="hidden">풋터 영역</h3>
                    <jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
                </li>
            </ul>
        </div>
    </div>
    <%-- 상세 모달 인클루드 --%>
    <jsp:include page="/WEB-INF/view/domain/notice/noticeModal.jsp"></jsp:include>

</form>
</body>


</html>