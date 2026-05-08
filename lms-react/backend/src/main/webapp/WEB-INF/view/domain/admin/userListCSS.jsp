<style>
    /* 공통 버튼 스타일 */
    .modal-btn-wrap .btn-blue,
    .modal-btn-wrap .btn-red {
        min-width: 90px;
        padding: 8px 16px;

        border-radius: 4px;
        border: 1px solid transparent;

        font-size: 13px;
        font-weight: 500;
        line-height: 1.4;

        cursor: pointer;
        outline: none;

        display: inline-flex;
        align-items: center;
        justify-content: center;

        box-sizing: border-box;
        transition: background-color 0.15s ease,
        border-color 0.15s ease,
        color 0.15s ease,
        box-shadow 0.15s ease;
    }

    /* 파란 버튼 (저장) */
    .modal-btn-wrap .btn-blue {
        background-color: #1c7ed6;
        border-color: #1c7ed6;
        color: #fff;
    }

    .modal-btn-wrap .btn-blue:hover {
        background-color: #1864ab;
        border-color: #1864ab;
        box-shadow: 0 0 0 2px rgba(24, 100, 171, 0.2);
    }

    .modal-btn-wrap .btn-blue:active {
        background-color: #155493;
        border-color: #155493;
        box-shadow: none;
    }

    /* 빨간 버튼 (닫기/취소) */
    .modal-btn-wrap .btn-red {
        background-color: #8AA1B3;
        border-color: #2f383d;
        color: #fff;
    }

    .modal-btn-wrap .btn-red:hover {
        background-color: #6d7a83;
        border-color: #2f383d;
        box-shadow: 0 0 0 2px rgba(103, 101, 102, 0.8);
    }

    .modal-btn-wrap .btn-red:active {
        background-color: #8AA1B3;
        border-color: #2f383d;
        box-shadow: none;
    }

    /* 비활성화 상태 공통 */
    .modal-btn-wrap .btn-blue:disabled,
    .modal-btn-wrap .btn-red:disabled {
        background-color: #dee2e6;
        border-color: #dee2e6;
        color: #868e96;
        cursor: not-allowed;
        box-shadow: none;
    }

    .modal-title{
        font-size: 25px;
        margin-bottom:15px;
        font-family: "Noto Sans KR", sans-serif;
    }
    .modal-subtitle{
        font-size: 20px;
        margin-bottom:15px;
        font-family: "Noto Sans KR", sans-serif;
    }
    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.45);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 9999;
    }

    .modal-box {
        background: #fff;
        padding: 25px 30px;
        border-radius: 10px;
        box-shadow: 0px 4px 15px rgba(0,0,0,0.2);

        width: 900px;
        height: 85vh;

        display: flex;
        flex-direction: column;
        box-sizing: border-box;

    }
    .modal-scroll-area {
        flex: 1;                 /* 위쪽 내용이 남는 높도 다 차지 */
        overflow-y: auto;        /* 여기만 세로 스크롤 */
        padding-right: 5px;
        margin-bottom: 12px;
    }

    .modal-btn-wrap {
        display: flex;
        justify-content: flex-end;   /* 오른쪽 정렬 */
        gap: 8px;                    /* 버튼 사이 간격 */
        padding-top: 10px;
        margin-top: 4px;
        border-top: 1px solid #e0e0e0;
        background-color: #fff;
    }
    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.45);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 9999;
    }
    .modal-scroll-area {
        flex: 1;                 /* 위쪽 내용이 남는 높도 다 차지 */
        overflow-y: auto;        /* 여기만 세로 스크롤 */
        padding-right: 5px;
        margin-bottom: 12px;
    }

    .modal-btn-wrap {
        display: flex;
        justify-content: flex-end;   /* 오른쪽 정렬 */
        gap: 8px;                    /* 버튼 사이 간격 */
        padding-top: 10px;
        margin-top: 4px;
        border-top: 1px solid #e0e0e0;
        background-color: #fff;
    }
</style>