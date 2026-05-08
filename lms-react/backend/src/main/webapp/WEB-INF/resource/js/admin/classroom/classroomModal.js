document.addEventListener("DOMContentLoaded", () => {
    const container = document.getElementById('classroomList');

    if (!container) return console.error("classroomList 요소가 없습니다.");

    /* ======================= 페이징 관련 변수 ======================= */
    const pageSize = 10;
    let currentPage = 1;

    /* ======================= 모달 관련 ======================= */
    function closeAllModals() {
        document.querySelectorAll(".modal").forEach(m => m.style.display = "none");
    }
    document.querySelectorAll(".close").forEach(btn => btn.addEventListener("click", closeAllModals));

    // 모달 열기 버튼
    document.getElementById('btnAdd').addEventListener('click', () => {
        document.getElementById('modalAdd').style.display = 'block';
    });

    /* ======================= 강의실 리스트 로딩 (페이징 적용) ======================= */
    async function loadClassroomList() {
        try {
            const res = await fetch(`/admin/classrooms/list/paging?page=${currentPage}&pageSize=${pageSize}`);
            if (!res.ok) throw new Error('서버 응답 오류: ' + res.status);
            const data = await res.json();
            const list = data.list;

            list.sort((a, b) => {
                const numA = parseInt(a.class_name);
                const numB = parseInt(b.class_name);
                return numA - numB;
            });

            container.innerHTML = '';

            list.forEach(c => {
                const row = document.createElement('div');
                row.className = 'content-box table-row';
                row.dataset.id = c.class_id;

                row.innerHTML = `
                  <span class="classroom-name">${c.class_name}</span>
                  <span class="student-count">${c.people_limit}명</span>
                  <span class="actions">
                      <button class="btn-edit">수정</button>
                      <button class="btn-remove">삭제</button>
                  </span>
                `;

                container.appendChild(row);
            });

            // 페이지네이션 렌더링
            renderPagination(data.totalCount, currentPage);
            bindRowEvents();
        } catch (err) {
            console.error("강의실 목록 로딩 실패:", err);
        }
    }

    /* ======================= 페이지네이션 UI 렌더링 ======================= */
    function renderPagination(totalCount, page) {
        const totalPages = Math.ceil(totalCount / pageSize);
        const paginationContainer = document.getElementById('classroomPagination');
        paginationContainer.innerHTML = '';

        // 이전 버튼
        const prevBtn = document.createElement('button');
        prevBtn.textContent = '이전';
        prevBtn.disabled = page <= 1;
        prevBtn.onclick = () => {
            if (page > 1) {
                currentPage = page - 1;
                loadClassroomList();
            }
        };
        paginationContainer.appendChild(prevBtn);

        // 페이지 번호 (앞뒤로 2페이지씩)
        const pageWindow = 5;
        const startPage = Math.max(1, page - Math.floor(pageWindow / 2));
        const endPage = Math.min(totalPages, startPage + pageWindow - 1);

        // 첫 페이지
        if (startPage > 1) {
            const firstBtn = document.createElement('button');
            firstBtn.textContent = '1';
            firstBtn.onclick = () => {
                currentPage = 1;
                loadClassroomList();
            };
            paginationContainer.appendChild(firstBtn);

            if (startPage > 2) {
                const dots = document.createElement('span');
                dots.textContent = '...';
                paginationContainer.appendChild(dots);
            }
        }

        // 페이지 번호 버튼
        for (let i = startPage; i <= endPage; i++) {
            const pageBtn = document.createElement('button');
            pageBtn.textContent = i;
            pageBtn.onclick = () => {
                currentPage = i;
                loadClassroomList();
            };

            if (i === page) {
                pageBtn.className = 'active';
            }

            paginationContainer.appendChild(pageBtn);
        }

        // 마지막 페이지
        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                const dots = document.createElement('span');
                dots.textContent = '...';
                paginationContainer.appendChild(dots);
            }

            const lastBtn = document.createElement('button');
            lastBtn.textContent = totalPages;
            lastBtn.onclick = () => {
                currentPage = totalPages;
                loadClassroomList();
            };
            paginationContainer.appendChild(lastBtn);
        }

        // 다음 버튼
        const nextBtn = document.createElement('button');
        nextBtn.textContent = '다음';
        nextBtn.disabled = page >= totalPages;
        nextBtn.onclick = () => {
            if (page < totalPages) {
                currentPage = page + 1;
                loadClassroomList();
            }
        };
        paginationContainer.appendChild(nextBtn);
    }

    // 날짜 포맷 함수
    function formatDate(timestamp) {
        if (!timestamp) return '';
        const date = new Date(timestamp);
        const year = date.getFullYear();
        const month = ('0' + (date.getMonth() + 1)).slice(-2);
        const day = ('0' + date.getDate()).slice(-2);
        return `${year}-${month}-${day}`;
    }

    // 테이블 행 이벤트 바인딩
    function bindRowEvents() {
        document.querySelectorAll('.table-row').forEach(row => {
            row.onclick = async e => {
                if (e.target.tagName === 'BUTTON') return;

                const className = row.querySelector('.classroom-name').textContent.trim();
                console.log('🔍 요청할 강의실명:', className);

                try {
                    const res = await fetch(`/admin/classrooms/detail?name=${encodeURIComponent(className)}`);
                    console.log('📡 응답 상태:', res.status);

                    if (!res.ok) throw new Error('서버 응답 오류: ' + res.status);

                    const rows = await res.json();
                    console.log('📦 서버 응답 데이터:', rows);

                    if (rows && rows.length > 0) {
                        const firstRow = rows[0];

                        // 기본 강의실 정보
                        document.getElementById('detailName').textContent = firstRow.class_name || '-';
                        document.getElementById('detailCount').textContent = firstRow.people_limit + '명';

                        // 기존 모달 초기화
                        for (let i = 1; i <= 3; i++) {
                            document.getElementById('detailCourseTitle' + i).value = '';

                            const dateInput = document.getElementById('detailDate' + i);
                            if (dateInput) dateInput.value = '';

                            document.getElementById('detailProfessor' + i).value = firstRow.professor_name ?? '';
                            document.getElementById('detailSubProfessor' + i).value = firstRow.sub_prof_name ?? '';
                        }

                        // courseSchedules 구성
                        const courseSchedules = rows
                            .filter(r => r.title != null)
                            .map(r => ({
                                title: r.title,
                                start_date: r.start_date,
                                end_date: r.end_date,
                                professor_name: r.professor_name,
                                sub_prof_name: r.sub_prof_name
                            }));

                        // 모달에 데이터 적용
                        courseSchedules.forEach((sch, index) => {
                            const i = index + 1;
                            const inputTitle = document.getElementById('detailCourseTitle' + i);
                            if (!inputTitle) return;

                            inputTitle.value = sch.title || '';

                            const dateInput = document.getElementById('detailDate' + i);
                            if (dateInput) {
                                const start = formatDate(sch.start_date);
                                const end = formatDate(sch.end_date);
                                dateInput.value = `${start} ~ ${end}`;
                            }

                            document.getElementById('detailProfessor' + i).value = sch.professor_name || '';
                            document.getElementById('detailSubProfessor' + i).value = sch.sub_prof_name || '';
                        });

                        // 모달 열기
                        const modal = document.getElementById('modalDetail');
                        if (modal) modal.style.display = 'block';
                    }
                } catch (err) {
                    console.error("❌ 상세보기 로딩 실패:", err);
                }
            };

            // 편집 버튼 이벤트
            row.querySelector('.btn-edit')?.addEventListener('click', e => {
                e.stopPropagation();
                const className = row.querySelector('.classroom-name').textContent.trim();
                openEditModal(className);
            });
            // 삭제 버튼 이벤트
            row.querySelector('.btn-remove')?.addEventListener('click', e => {
                e.stopPropagation();
                rowClickDelete(row);
            });
        });
    }

    function rowClickDelete(row) {
        const classNameSpan = row.querySelector('.classroom-name');
        if (!classNameSpan) return console.error('강의실 이름 요소가 없습니다.');

        document.getElementById('deleteName').value = classNameSpan.textContent.trim();
        document.getElementById('modalDelete').style.display = 'block';
    }


    /* ======================= CRUD 버튼 ======================= */
    // 추가 저장
    document.getElementById('btnAddSave').addEventListener('click', async e => {
        e.preventDefault();
        const name = (document.getElementById('addName').value || '').trim();
        const count = parseInt(document.getElementById('addCount').value, 10);
        if (!name || isNaN(count)) { alert('강의실 명과 인원수를 올바르게 입력하세요.'); return; }

        try {
            await fetch('/admin/classrooms/insert', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    class_name: name,
                    people_limit: count,
                    status: 1
                })
            });
            closeAllModals();
            currentPage = 1;
            loadClassroomList();
        } catch (err) {
            console.error(err);
        }
    });

    // 수정 모달 열기 + 데이터 채우기
    function openEditModal(className) {
        const modal = document.getElementById('modalEdit');
        if (!modal) return;
        modal.style.display = 'block';

        fetch(`/admin/classrooms/detail?name=${encodeURIComponent(className)}`)
            .then(res => res.json())
            .then(rows => {
                if (!rows || rows.length === 0) return;

                const firstRow = rows[0];

                document.getElementById('editName').textContent = firstRow.class_name || '-';
                document.getElementById('editCount').textContent = firstRow.people_limit || '-';

                const lectures = rows.filter(r => r.title != null);

                for (let i = 1; i <= 3; i++) {
                    const lecture = lectures[i - 1] || {};

                    const titleInput = document.getElementById('editCourseTitle' + i);
                    const dateInput = document.getElementById('editDate' + i);
                    const profInput = document.getElementById('editProfessor' + i);
                    const subProfInput = document.getElementById('editSubProfessor' + i);

                    if (titleInput) titleInput.value = lecture.title || '';
                    if (dateInput) dateInput.value = lecture.start_date && lecture.end_date
                        ? `${formatDate(lecture.start_date)} ~ ${formatDate(lecture.end_date)}`
                        : '';
                    if (profInput) profInput.value = lecture.professor_name || '';
                    if (subProfInput) subProfInput.value = lecture.sub_prof_name || '';
                }
            })
            .catch(err => console.error("수정 모달 데이터 로딩 실패:", err));
    }

    // 수정 저장
    document.getElementById('btnEditSave').addEventListener('click', async e => {
        e.preventDefault();

        const rows = [];
        for (let i = 1; i <= 3; i++) {
            const title = document.getElementById('editCourseTitle' + i)?.value.trim() || '';
            const period = document.getElementById('editDate' + i)?.value.trim() || '';
            const professor = document.getElementById('editProfessor' + i)?.value.trim() || '';
            const sub_prof = document.getElementById('editSubProfessor' + i)?.value.trim() || '';
            rows.push({ title, period, professor, sub_prof });
        }

        try {
            await fetch('/admin/classrooms/update', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ courseSchedules: rows })
            });

            const modal = document.getElementById('modalEdit');
            if (modal) modal.style.display = 'none';
            currentPage = 1;
            loadClassroomList();
        } catch (err) {
            console.error("수정 저장 실패:", err);
        }
    });

    // 삭제 확인
    document.getElementById('btnDeleteConfirm').addEventListener('click', async () => {
        const className = document.getElementById('deleteName').value.trim();
        if (!className) return;
        try {
            await fetch(`/admin/classrooms/delete?class_name=${encodeURIComponent(className)}`, { method: 'DELETE' });
            closeAllModals();
            currentPage = 1;
            loadClassroomList();
        } catch (err) {
            console.error(err);
        }
    });


    /* ======================= 검색 기능 ======================= */
    document.getElementById('btnSearch').addEventListener('click', async e => {
        e.preventDefault();
        const keyword = document.getElementById('searchKeyword').value.trim();

        try {
            const res = await fetch('/admin/classrooms/list');
            const list = await res.json();

            const container = document.getElementById('classroomList');
            container.innerHTML = '';

            const filtered = keyword
                ? list.filter(c => c.class_name.includes(keyword))
                : list;

            filtered.sort((a, b) => parseInt(a.class_name) - parseInt(b.class_name));

            filtered.forEach(c => {
                const row = document.createElement('div');
                row.className = 'content-box table-row';
                row.dataset.id = c.class_id;

                row.innerHTML = `
                  <span class="classroom-name">${c.class_name}</span>
                  <span class="student-count">${c.people_limit}명</span>
                  <span class="actions">
                      <button class="btn-edit">수정</button>
                      <button class="btn-remove">삭제</button>
                  </span>
                `;
                container.appendChild(row);
            });

            // 검색 결과에는 페이징 숨기기
            document.getElementById('classroomPagination').innerHTML = '';

            bindRowEvents();
        } catch (err) {
            console.error(err);
        }
    });

    document.getElementById('searchKeyword').addEventListener('keypress', e => {
        if (e.key === 'Enter') {
            e.preventDefault();
            document.getElementById('btnSearch').click();
        }
    });

    // 모달 닫기
    document.querySelector('#modalDetail .close').addEventListener('click', () => {
        document.getElementById('modalDetail').style.display = 'none';
    });

    window.addEventListener('click', (e) => {
        const modalDetail = document.getElementById('modalDetail');
        const modalEdit = document.getElementById('modalEdit');

        if (e.target === modalDetail) modalDetail.style.display = 'none';
        if (e.target === modalEdit) modalEdit.style.display = 'none';
    });

    document.querySelectorAll('#modalEdit .close').forEach(btn => {
        btn.addEventListener('click', () => {
            document.getElementById('modalEdit').style.display = 'none';
        });
    });

    /* ======================= 초기 로딩 ======================= */
    loadClassroomList();
});