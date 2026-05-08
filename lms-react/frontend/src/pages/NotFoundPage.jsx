import { useLocation } from 'react-router-dom'

/**
 * 등록되지 않은 경로로 접근했을 때 표시되는 페이지
 * 어떤 URL로 왔는지 보여줍니다 → 라우트 추가에 활용
 */
function NotFoundPage() {
  const location = useLocation()

  return (
    <div style={{
      display: 'flex', flexDirection: 'column', alignItems: 'center',
      justifyContent: 'center', minHeight: '400px', gap: '12px',
      background: '#fff', borderRadius: '12px', border: '2px dashed #feb2b2',
      padding: '48px',
    }}>
      <div style={{ fontSize: '48px' }}>🗺️</div>
      <h2 style={{ color: '#c53030', margin: 0 }}>라우트 미등록</h2>
      <p style={{ color: '#555', fontSize: '15px' }}>
        App.jsx에 아래 경로에 대한 Route가 아직 없습니다.
      </p>
      <code style={{
        background: '#fff5f5', border: '1px solid #feb2b2', borderRadius: '6px',
        padding: '10px 20px', fontSize: '16px', fontWeight: 'bold', color: '#c53030',
      }}>
        {location.pathname}
      </code>
      <p style={{ color: '#888', fontSize: '13px' }}>
        App.jsx에{' '}
        <code style={{ background: '#f7fafc', padding: '2px 6px', borderRadius: '4px' }}>
          {'<Route path="' + location.pathname + '" element={<컴포넌트 />} />'}
        </code>
        를 추가하세요.
      </p>
    </div>
  )
}

export default NotFoundPage
