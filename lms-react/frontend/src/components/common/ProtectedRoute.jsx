import { Navigate } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext'

/**
 * ProtectedRoute
 * - 비로그인: /login 으로 이동
 * - allowedRoles 지정 시 권한 불일치: /login 으로 이동 (Context도 초기화)
 */
function ProtectedRoute({ children, allowedRoles }) {
  const { user, logout } = useAuth()

  if (!user) {
    return <Navigate to="/login" replace />
  }

  if (allowedRoles && !allowedRoles.includes(user.userType)) {
    return <Navigate to="/login" replace />
  }

  return children
}

export default ProtectedRoute
