import { useEffect, useMemo, useState } from "react";
import { NavLink, useNavigate, useLocation } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";
import api from "../../api/axios";
import styles from "./Sidebar.module.css";

function resolveImageUrl(path, name) {
  if (!path || !name) return "";
  const base = path.endsWith("/") ? path.slice(0, -1) : path;
  const file = name.startsWith("/") ? name.slice(1) : name;
  const joined = `${base}/${file}`;
  if (/^https?:\/\//i.test(joined)) return joined;
  const origin =
    window.location.port === "3000"
      ? `${window.location.protocol}//${window.location.hostname}:80`
      : window.location.origin;
  return joined.startsWith("/") ? `${origin}${joined}` : `${origin}/${joined}`;
}

/**
 * 좌측 사이드바 네비게이션
 *
 * 로그인 응답의 usrMnuAtrt(메뉴 권한 목록)를 기반으로
 * 사용자 권한에 맞는 메뉴를 동적으로 렌더링합니다.
 *
 * 메뉴 구조:
 *   1depth (상위 메뉴) → 클릭 시 2depth(하위 메뉴) 펼침
 */
function Sidebar({ isOpen = false, onClose }) {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const normalizedMenus = useMemo(
    () => normalizeMenus(user?.usrMnuAtrt ?? [], user?.userType),
    [user?.usrMnuAtrt, user?.userType],
  );

  // 펼쳐진 상위 메뉴 ID를 관리
  const [openMenuId, setOpenMenuId] = useState(null);
  const [profileImgSrc, setProfileImgSrc] = useState("");

  useEffect(() => {
    if (!user?.userType || user.userType === "A") return;
    const basePath = user.userType === "I" ? "/inst" : "/stu";
    api.get(`${basePath}/userInfoAjax.do`, { headers: { AJAX: "true" } })
      .then(res => {
        const src = resolveImageUrl(res.data?.imgLogiPath, res.data?.imgName);
        if (src) setProfileImgSrc(src);
      })
      .catch(() => {});
  }, [user?.userType, user?.loginId]);

  useEffect(() => {
    const nextOpenMenuId = findOpenMenuIdForPath(normalizedMenus, location.pathname);
    setOpenMenuId(nextOpenMenuId);
  }, [location.pathname, normalizedMenus]);

  // 상위 메뉴 토글
  const toggleMenu = (menuId) => {
    setOpenMenuId((prev) => (prev === menuId ? null : menuId));
  };

  // 로그아웃: 서버 세션 무효화 완료 후 이동하여 새 로그인과의 타이밍 충돌 방지
  const handleLogout = async () => {
    logout();
    if (!user?.isMock) {
      await api.get("/loginOut.do").catch(() => {});
    }
    navigate("/login");
  };

  // 사용자 권한 표시
  const userTypeLabel = {
    S: "학생",
    I: "강사",
    A: "관리자",
  };

  return (
    <aside className={`${styles.sidebar} ${isOpen ? styles.sidebarOpen : ""}`}>
      {/* 로고 */}
      <div className={styles.logo}>
        <span className={styles.logoText}>HappyJob</span>
        <span className={styles.logoSub}>LMS</span>
      </div>

      {/* 사용자 정보 + 로그아웃 */}
      <div className={styles.userInfo}>
        <div className={styles.userRow}>
          <div className={styles.avatar}>
            {profileImgSrc
              ? <img src={profileImgSrc} alt="프로필" className={styles.avatarImg} onError={() => setProfileImgSrc("")} />
              : (user?.userNm?.charAt(0) ?? "?")}
          </div>
          <div className={styles.userDetail}>
            <span className={styles.userName}>{user?.userNm}</span>
            <span className={styles.userType}>
              {userTypeLabel[user?.userType] ?? user?.userType}
            </span>
          </div>
        </div>
        <button className={styles.logoutBtn} onClick={handleLogout}>
          로그아웃
        </button>
      </div>

      {/* 네비게이션 메뉴 */}
      <nav className={styles.nav}>
        {normalizedMenus.map((menu) => {
          const isGroupActive = isMenuGroupActive(menu, location.pathname);

          return (
            <div key={menu.mnu_id} className={styles.menuGroup}>
              {menu.nodeList?.length > 0 ? (
              <>
                {/* 하위 메뉴가 있는 경우: 토글 버튼 */}
                <button
                  className={`${styles.menuItem} ${isGroupActive ? styles.menuItemActive : ""}`}
                  onClick={() => toggleMenu(menu.mnu_id)}
                >
                  <span className={styles.menuIcon}>
                    {getMenuIcon(menu.mnu_ico_cod)}
                  </span>
                  <span className={styles.menuName}>{menu.mnu_nm}</span>
                  <span
                    className={`${styles.arrow} ${openMenuId === menu.mnu_id ? styles.arrowOpen : ""}`}
                  >
                    ▾
                  </span>
                </button>

                {/* 2depth 하위 메뉴 */}
                {openMenuId === menu.mnu_id && (
                  <ul className={styles.subMenu}>
                    {menu.nodeList.map((sub) => (
                      <li key={sub.mnu_id}>
                        <NavLink
                          to={sub.mnu_url}
                          className={({ isActive }) =>
                            `${styles.subItem} ${isActive ? styles.subItemActive : ""}`
                          }
                          onClick={onClose}
                        >
                          {sub.mnu_nm}
                        </NavLink>
                      </li>
                    ))}
                  </ul>
                )}
              </>
            ) : (
              /* 하위 메뉴가 없는 경우: 직접 링크 */
              menu.mnu_url && (
                <NavLink
                  to={menu.mnu_url}
                  className={() => {
                    const related = menu.mnu_related ?? [menu.mnu_url];
                    const isActive = related.includes(location.pathname);
                    return `${styles.menuItem} ${isActive ? styles.menuItemActive : ""}`;
                  }}
                  onClick={onClose}
                >
                  <span className={styles.menuIcon}>
                    {getMenuIcon(menu.mnu_ico_cod)}
                  </span>
                  <span className={styles.menuName}>{menu.mnu_nm}</span>
                </NavLink>
              )
              )}
            </div>
          );
        })}
      </nav>
    </aside>
  );
}

/**
 * 메뉴명 → 아이콘 코드 매핑
 * 실서버는 mnu_ico_cod가 "menu000"으로 고정되어 있어 메뉴명으로 대신 판단합니다.
 */
const ICON_BY_NAME = {
  // 관리자
  대시보드: "dashboard",
  "시험 관리": "exam",
  "강의 운영": "lecture",
  "사용자 관리": "users",
  "커뮤니티 관리": "qna",
  // 강사 (실서버 mnu_nm 기준)
  "나의 강의 관리": "lecture",
  "나의 강의": "lecture",
  커뮤니티: "qna",
  // 학생
  "학습 관리": "homework",
  "수강 관리": "lecture",
  // 공통
  마이페이지: "mypage",
};

/**
 * 메뉴 아이콘 코드를 이모지로 변환
 * 실제 아이콘 라이브러리(lucide-react 등)로 교체 가능합니다.
 */
function getMenuIcon(iconCode) {
  const iconMap = {
    dashboard: "📊",
    mypage: "👤",
    lecture: "📚",
    attendance: "📋",
    homework: "📝",
    exam: "📄",
    material: "📁",
    qna: "💬",
    survey: "📊",
    notice: "📢",
    users: "👥",
    classroom: "🏫",
    admin: "⚙️",
  };
  return iconMap[iconCode] ?? "📌";
}

/**
 * 서버 메뉴 데이터를 렌더링에 맞게 정규화합니다.
 *
 * 1. 아이콘 코드가 "menu000"이면 메뉴명 기반으로 교체
 * 2. 사용자 관리(학생/강사 nodeList) → 1뎁스 직접 링크로 변환
 * 3. 학생/강사 마이페이지 → 사용자 정보 관리 / 수강 현황 2뎁스로 합성
 * 4. nodeList가 1개이고 부모 URL이 null인 경우(대시보드 패턴) → 직접 링크로 변환
 * 5. 강사 "나의 강의 관리" → 강의 관련 / 시험·과제 관련으로 분리
 */

// 사이드바에서 숨길 URL 목록
const HIDDEN_URLS = ["/inst/course-plan"];

// 강사 시험·과제 URL 목록
const EXAM_URLS = [
  "/inst/exams",
  "/inst/exam-register",
  "/inst/assignments",
  "/inst/submissions",
];

function buildMyPageNodes(userType) {
  const isInst = String(userType ?? "").toUpperCase() === "I";
  const basePath = isInst ? "/inst" : "/stu";
  return [
    {
      mnu_id: `${basePath}_user_info`,
      mnu_nm: "사용자 정보 관리",
      mnu_url: `${basePath}/user-info`,
    },
    {
      mnu_id: `${basePath}_course_status`,
      mnu_nm: isInst ? "강의 현황" : "수강 현황",
      mnu_url: `${basePath}/course-status`,
    },
  ];
}

function normalizeMenus(menus, userType) {
  const result = [];

  for (let menu of menus) {
    // 숨김 URL 단일 메뉴 제외
    if (menu.mnu_url && HIDDEN_URLS.includes(menu.mnu_url)) continue;
    // 하위 메뉴에서 숨김 URL 제거
    if (menu.nodeList?.length) {
      menu = { ...menu, nodeList: menu.nodeList.filter((n) => !HIDDEN_URLS.includes(n.mnu_url)) };
    }

    // 아이콘 정규화
    const ico =
      !menu.mnu_ico_cod || menu.mnu_ico_cod === "menu000"
        ? (ICON_BY_NAME[menu.mnu_nm] ?? "admin")
        : menu.mnu_ico_cod;

    // 시험 관리: 시험일정/시험문제 2뎁스 → 1뎁스 직접 링크
    const isExamMgmt = menu.nodeList?.some(
      (n) => n.mnu_url === "/admin/exam/schedule" || n.mnu_url === "/admin/test-exam",
    );
    if (isExamMgmt) {
      result.push({
        ...menu,
        mnu_ico_cod: ico,
        mnu_url: "/admin/exam/schedule",
        mnu_related: ["/admin/exam/schedule", "/admin/test-exam"],
        nodeList: [],
      });
      continue;
    }

    // 사용자 관리: 학생/강사 2뎁스 → 1뎁스
    const isUserMgmt = menu.nodeList?.some(
      (n) => n.mnu_url === "/admin/stu" || n.mnu_url === "/admin/inst",
    );
    if (isUserMgmt) {
      result.push({
        ...menu,
        mnu_ico_cod: ico,
        mnu_url: "/admin/stu",
        mnu_related: ["/admin/stu", "/admin/inst"],
        nodeList: [],
      });
      continue;
    }

    if (menu.mnu_nm === "마이페이지" && (userType === "S" || userType === "I")) {
      result.push({
        ...menu,
        mnu_ico_cod: "mypage",
        mnu_url: null,
        nodeList: buildMyPageNodes(userType),
      });
      continue;
    }

    // 학생 "수강 관리" → 전체 강의 목록 / 나의 강의를 1뎁스 직접 링크로 통합
    const hasCourseNodes = menu.nodeList?.some(
      (n) => n.mnu_url === "/stu/courses" || n.mnu_url === "/stu/my-courses",
    );
    if (hasCourseNodes) {
      result.push({
        ...menu,
        mnu_ico_cod: ico,
        mnu_url: "/stu/courses",
        mnu_related: ["/stu/courses", "/stu/my-courses"],
        nodeList: [],
      });
      continue;
    }

    // 강사 "나의 강의 관리" → 강의 그룹 / 시험·과제 그룹으로 분리
    const hasExamItems = menu.nodeList?.some((n) => EXAM_URLS.includes(n.mnu_url));
    if (menu.mnu_nm === "나의 강의 관리" && hasExamItems) {
      const courseNodes = menu.nodeList.filter((n) => !EXAM_URLS.includes(n.mnu_url));
      const examNodes   = menu.nodeList.filter((n) =>  EXAM_URLS.includes(n.mnu_url));

      result.push({ ...menu, mnu_ico_cod: "lecture", nodeList: courseNodes });
      result.push({
        mnu_id: `${menu.mnu_id}_exam`,
        mnu_nm: "시험/과제",
        mnu_url: null,
        mnu_ico_cod: "exam",
        nodeList: examNodes,
      });
      continue;
    }

    // 단일 nodeList + 부모 URL 없음 → 직접 링크 (마이페이지 패턴)
    if (!menu.mnu_url && menu.nodeList?.length === 1) {
      result.push({
        ...menu,
        mnu_ico_cod: ico,
        mnu_url: menu.nodeList[0].mnu_url,
        nodeList: [],
      });
      continue;
    }

    result.push({ ...menu, mnu_ico_cod: ico });
  }

  return result;
}

function isMenuGroupActive(menu, pathname) {
  return (menu.nodeList ?? []).some((sub) => sub.mnu_url === pathname);
}

function findOpenMenuIdForPath(menus, pathname) {
  const matchedMenu = menus.find((menu) => isMenuGroupActive(menu, pathname));
  return matchedMenu?.mnu_id ?? null;
}

export default Sidebar;
