<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>Job Korea</title>
    <style>

        /* 상단 전체 영역 정렬 */
        .qna-top-bar {
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* 검색 영역 */
        .search-area {
            display: flex;
            gap: 5px;
            height: 32px;
        }

        /* 검색 버튼 디자인(optional) */
        .btn-search {
            padding: 5px 12px;
        }

        /* 질문 작성 버튼 디자인 */
        .btn-write {
            background-color: #4aa8d8; /* 파스텔 블루 */
            color: white;
            border: none;
            padding: 8px 18px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.25s ease;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .btn-write:hover {
            background-color: #3595c7;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }

        .btn-write:active {
            transform: translateY(0px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        /* 테이블 행 hover 효과 */
        table.col tbody tr:hover {
            background-color: #f5f5f5;
        }

    </style>

    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
</head>
<body>

    <input type="hidden" id="currentPage" value="1">
    <input type="hidden" id="selectedInfNo" value="">
    <!-- 모달 배경 -->
    <div id="mask"></div>

    <div id="wrap_area">

        <h2 class="hidden">컨텐츠 영역</h2>
        <div id="container">
            <ul>
                <li class="lnb">
                    <!-- lnb 영역 --> <jsp:include
                        page="/WEB-INF/view/common/lnbMenu.jsp"/> <!--// lnb 영역 -->
                </li>
                <li class="contents">
                    <!-- contents -->
                    <h3 class="hidden">contents 영역</h3> <!-- content -->

                    <div class="content" style="margin-bottom:20px;">

                        <p class="Location">
                            <a href="/dashboard/dashboard.do" class="btn_set home">메인으로</a>
                            <span class="btn_nav bold">메인</span> <a href="${rolePath}" class="btn_set refresh">새로고침</a>
                        </p>
                        <div>
                            <p class="conTitle" style="margin-bottom: 1%;">
                                <span>Q&A 게시판</span>
                            </p>
                        </div>
                        <div class="qna-top-bar">
                            <%-- 왼쪽 : 검색 영역 --%>
                            <form method="get" action="${rolePath}" id="searchForm">
                                <div class="search-area">
                                    <select id="categoryFilter" name="category">
                                        <option value="">카테고리</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryCode}" ${param.category == cat.categoryCode ? "selected" : ""}>
                                                    ${cat.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>

                                    <input type="text" id="searchKeyword" name="keyword" value="${param.keyword}"
                                           placeholder="검색어를 입력하세요"/>
                                    <button type="submit" class="btn-search">검색</button>
                                </div>
                            </form>

                             <%-- 오른쪽 :질문 작성--%>
                            <div class="write-area">
                                <button type="button" class="btn-write" onclick="location.href='${rolePath}/write'">질문 작성</button>
                            </div>
                        </div>

                        <table class="col">
                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>카테고리</th>
                                <th>제목</th>
                                <th>작성일</th>
                                <th>작성자</th>
                                <th>답변상태</th>
                            </tr>
                            </thead>

                            <tbody>
                            <%-- 검색 결과가 없을 때--%>
                            <c:if test="${empty qnaList}">
                                <tr>
                                    <td colspan="6" style="text-align:center; padding:20px; color:#777;">
                                        검색 결과가 없습니다.
                                    </td>
                                </tr>
                            </c:if>

                            <%-- 검색 결과가 있을 때--%>
                               <c:forEach var="row" items="${qnaList}" varStatus="status">
                                   <tr>
                                        <%-- 번호 (postId와 별개로 화면에서 1~10 표시)--%>
                                        <td>${status.index +1}</td>

                                        <%-- 카테고리 --%>
                                        <td>${row.categoryName}</td>

                                        <%-- 제목 (상세페이지로 이동)--%>
                                        <td>
                                            <a href="${rolePath}/detail?postId=${row.postId}" style="cursor:pointer; color:inherit; text-decoration:none;">
                                                ${row.title}
                                            </a>
                                        </td>

                                        <%-- 작성일 --%>
                                        <td><fmt:formatDate value="${row.createdAt}" pattern="yyyy-MM-dd"/></td>

                                        <%--작성자--%>
                                        <td>${row.writerName}</td>

                                        <%--답변 상태--%>
<%--                                        <td>${row.answerStatus}</td>--%>
                                        <td>
                                            <c:choose>
                                                <c:when test="${row.answerStatus=='N'}">
                                                    미답변
                                                </c:when>
                                                <c:otherwise>
                                                    답변완료
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                   </tr>
                               </c:forEach>
                            </tbody>
<%--                            <tr>--%>
<%--                                <td>9</td>--%>
<%--                                <td>[수강관련]</td>--%>
<%--                                <td>--%>
<%--                                    <a href="/admin/qna/detail" style="cursor:pointer; color:inherit; text-decoration:none;">--%>
<%--                                        시험 범위 어떻게 되나요?--%>
<%--                                    </a>--%>
<%--                                </td>--%>
<%--                                <td>2025-11-22</td>--%>
<%--                                <td>고나은</td>--%>
<%--                                <td>미답변</td>--%>
<%--                            </tr>--%>

                        </table>




                        <!-- 페이징 -->
                        <div style="text-align:center; margin-top:20px;">
                            <%-- 전체 페이지 수 계산 --%>
                            <c:set var="totalPage"
                                   value="${(totalCnt / pageSize) + (totalCnt % pageSize > 0 ? 1 : 0)}" />

                            <%-- 이전 버튼 --%>
                            <c:if test="${page > 1}">
                                <a href="${rolePath}?page=${page - 1}">《 이전</a>
                            </c:if>

                            <%-- 페이지 번호 반복 --%>
                            <c:forEach var="i" begin="1" end="${totalPage}">
                                <a href="${rolePath}?page=${i}"
                                   style="margin:0 5px; ${i == page ? 'font-weight:bold; text-decoration:underline;' : ''}">
                                        ${i}
                                </a>
                            </c:forEach>

                            <%-- 다음 버튼 --%>
                            <c:if test="${page < totalPage}">
                                <a href="${rolePath}?page=${page + 1}">다음 》</a>
                            </c:if>

                        </div>
                    </div>
                </li>
            </ul>
        </div>

    </div>


</form>
</body>
</html>