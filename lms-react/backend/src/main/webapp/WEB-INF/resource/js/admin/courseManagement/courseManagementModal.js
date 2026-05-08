// 행 이벤트 바인딩
function bindRowEvents() {
    document.querySelectorAll('.table-row').forEach(row => {

        // 행 클릭 → 상세보기
        row.addEventListener('click', async e => {
            if (e.target.tagName === 'BUTTON') return;

            // dataset.id에서 실제 courseId 가져오기
            const courseId = row.dataset.id;

            if (!courseId) {
                console.warn('courseId가 설정되지 않았습니다.');
                return;
            }

            try {
                // fetch URL을 @PathVariable 방식에 맞춤
                const res = await fetch(`/admin/courseManagement/detail/${courseId}`);

                if (!res.ok) {
                    throw new Error(`HTTP 오류! 상태: ${res.status}`);
                }

                const course = await res.json();

                const statusMap = {
                    1: '활성화',
                    0: '비활성화'
                };

                // 모달에 데이터 채우기
                document.getElementById('modal_title').value = course.title || '';
                document.getElementById('modal_test_status').value = statusMap[Number(course.status)] || '비활성화';

                document.getElementById('modal_professor').value = course.name || '';
                document.getElementById('modal_sub_prof').value = course.subName || '';
                document.getElementById('modal_people_limit').value = 40;
                // class_id를 classMap으로 변환
                document.getElementById('modal_class_id').value = course.class_name || '';
                document.getElementById('modal_start_date').value = course.start_date ? formatDate(course.start_date) : '';
                document.getElementById('modal_time').value =
                    course.start_time && course.end_time
                        ? `${course.start_time} ~ ${course.end_time}`
                        : '09:00 - 12:00';
                document.getElementById('modal_req_status').value = statusMap[course.cos_sta_code] || course.cos_sta_code || '';

                // 강의공지사항
                document.getElementById('modal_operations_note').value = course.notice || '';
                document.getElementById('modal_description').value = course.content || '';
                document.getElementById('modal_syllabus').value = course.plan || '';

                // 모달 열기
                document.getElementById('courseModal').style.display = 'flex';
            } catch (err) {
                console.error('강의 상세 조회 실패:', err);
            }
        });
    });
}

// 모달 닫기
function closeCourseModal() {
    document.getElementById('courseModal').style.display = 'none';
}

// 테이블에서 class_id 표시 시에도 적용
function renderTableRow(c) {
    const status = getCourseStatus(c.start_date, c.end_date);

    const row = document.createElement('div');
    row.className = 'content-box table-row';
    row.dataset.id = c.course_id;

    row.innerHTML = `
        <span class="col course-id">${c.course_id}</span>
        <span class="col title">${c.title}</span>
        <span class="col professor">${c.name}</span>
        <span class="col class-id">${classMap[c.class_id] || c.class_id}</span>
        <span class="col period">${formatDate(c.start_date)} ~ ${formatDate(c.end_date)}</span>
        <span class="col req-status">${c.cos_sta_code}</span>
        <span class="col status">
            <span class="status-badge" style="${getStatusStyle(status)}">${status}</span>
        </span>
    `;

    return row;
}
