import styles from './PlaceholderPage.module.css'

/**
 * PlaceholderPage (미구현 페이지 공통 컴포넌트)
 *
 * 팀원들이 각자 담당 페이지를 구현하기 전, 임시로 표시하는 컴포넌트입니다.
 *
 * @param {string} title - 페이지 제목
 * @param {string} description - 페이지 설명
 * @param {string} assignee - 담당자 이름
 */
function PlaceholderPage({ title, description, assignee }) {
  return (
    <div className={styles.container}>
      <div className={styles.badge}>🚧 구현 예정</div>
      <h2 className={styles.title}>{title}</h2>
      {description && <p className={styles.description}>{description}</p>}
      {assignee && (
        <div className={styles.assignee}>
          담당: <strong>{assignee}</strong>
        </div>
      )}
      <p className={styles.guide}>
        이 파일을 열어서 직접 구현해 보세요!
      </p>
    </div>
  )
}

export default PlaceholderPage
