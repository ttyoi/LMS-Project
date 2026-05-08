import { useLocation } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext'
import styles from './Header.module.css'

function Header({ onMenuToggle }) {
  const { user } = useAuth()
  const location = useLocation()

  const pageTitle = getPageTitle(location.pathname, user?.usrMnuAtrt)

  return (
    <header className={styles.header}>
      <div className={styles.breadcrumb}>
        <button className={styles.hamburger} onClick={onMenuToggle} aria-label="메뉴 열기">
          ☰
        </button>
        <span className={styles.pageName}>{pageTitle}</span>
      </div>

      <div className={styles.right}>
        <span className={styles.greeting}>
          안녕하세요, <strong>{user?.userNm}</strong>님
        </span>
      </div>
    </header>
  )
}

function getPageTitle(pathname, menus = []) {
  const staticMap = {
    '/dashboard': '대시보드',
    '/mypage': '마이페이지',
    '/register': '회원가입',
    '/lecture': '강의/수강목록',
    '/attendance': '출석관리/계획서',
    '/homework': '과제',
    '/exam': '시험',
    '/material': '학습자료',
    '/qna': 'Q&A',
    '/survey': '설문',
    '/notice': '공지사항',
    '/admin/users': '사용자 관리',
    '/admin/lecture': '강의 관리',
    '/admin/classroom': '강의실 관리',
    '/admin/exam': '시험 관리',
    "/stu/user-info": "사용자 정보 관리",
    "/stu/course-status": "수강 현황",
    "/inst/user-info": "사용자 정보 관리",
    "/inst/course-status": "강의 현황",
  }

  if (staticMap[pathname]) return staticMap[pathname]

  for (const menu of menus) {
    if (menu.mnu_url === pathname) return menu.mnu_nm
    for (const sub of menu.nodeList ?? []) {
      if (sub.mnu_url === pathname) return sub.mnu_nm
    }
  }

  return 'HappyJob LMS'
}

export default Header
