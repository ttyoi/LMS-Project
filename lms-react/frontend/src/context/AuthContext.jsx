import { createContext, useContext, useState, useEffect } from 'react'
import { setIgnoreAuthErrors, cancelPendingRequests } from '../api/axios'

/**
 * AuthContext
 *
 * 로그인한 사용자 정보와 메뉴 권한을 앱 전역에서 사용할 수 있게 합니다.
 *
 * 사용 예시:
 *   const { user, login, logout } = useAuth()
 */
const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  // 로그인 성공 시 서버에서 받아온 사용자 정보를 저장합니다.
  // 예: { loginId, userNm, userType, usrMnuAtrt, serverName }
  const [user, setUser] = useState(() => {
    const saved = localStorage.getItem('user')
    return saved ? JSON.parse(saved) : null
  })

  const login = (userData) => {
    setUser(userData)
    localStorage.setItem('user', JSON.stringify(userData))
    // cancelPendingRequests()로 이전 세션 요청이 모두 취소되었으므로 즉시 에러 감지 활성화
    setIgnoreAuthErrors(false)
  }

  const logout = () => {
    // 진행 중인 모든 API 요청을 즉시 취소하여 이전 세션의 401/901 응답이 새 로그인에 영향을 주지 않도록 함
    cancelPendingRequests()
    setIgnoreAuthErrors(true)
    setUser(null)
    localStorage.removeItem('user')
  }

  // 다른 탭에서 로그인/로그아웃 시 현재 탭에도 즉시 반영
  useEffect(() => {
    const handleStorage = (e) => {
      if (e.key !== 'user') return
      setUser(e.newValue ? JSON.parse(e.newValue) : null)
    }
    window.addEventListener('storage', handleStorage)
    return () => window.removeEventListener('storage', handleStorage)
  }, [])

  return (
    <AuthContext.Provider value={{ user, login, logout }}>
      {children}
    </AuthContext.Provider>
  )
}

/**
 * AuthContext를 쉽게 사용하기 위한 커스텀 훅
 */
export function useAuth() {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error('useAuth는 AuthProvider 내부에서만 사용 가능합니다.')
  }
  return context
}
