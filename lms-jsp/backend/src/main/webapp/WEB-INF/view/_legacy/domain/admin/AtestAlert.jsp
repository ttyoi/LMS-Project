<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 12. 11.
  Time: 오후 3:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Alert</title>
    <script>
        alert("<%= request.getAttribute("msg") %>");
        location.href = "<%= request.getAttribute("url") %>";
    </script>
</head>
<body>

</body>
</html>
