    $(document).ready(function () {
    $.ajax({
        url: '/inst/homeworklist',
        method: 'GET',
        success: function (data) {
            let html = "";
            $.each(data, function(i, hw) {
                html += "<tr>";
                html += "<td>" + (i+1) + "</td>";

                // 🔥 상세페이지로 이동하는 링크
                html += "<td class='col-name'>";
                html += "<a href='/inst/homeworkDetail?homework_code=" + hw.homework_code + "'>";
                html += hw.title + "</a></td>";

                html += "<td>" + hw.start_date + "</td>";
                html += "<td>" + hw.end_date + "</td>";
                html += "<td>" + hw.status + "</td>";
                html += "<td>↓</td>";
                html += "</tr>";
            });
            $(".assignment-table tbody").html(html);
        }
    });
});


