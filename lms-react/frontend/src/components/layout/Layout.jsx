import { useState } from 'react'
import { Outlet } from 'react-router-dom'
import Sidebar from './Sidebar'
import Header from './Header'
import styles from './Layout.module.css'

function Layout() {
  const [sidebarOpen, setSidebarOpen] = useState(false)

  const closeSidebar = () => setSidebarOpen(false)

  return (
    <div className={styles.wrapper}>
      <Sidebar isOpen={sidebarOpen} onClose={closeSidebar} />

      {sidebarOpen && (
        <div className={styles.overlay} onClick={closeSidebar} />
      )}

      <div className={styles.main}>
        <Header onMenuToggle={() => setSidebarOpen((prev) => !prev)} />
        <main className={styles.content}>
          <Outlet />
        </main>
      </div>
    </div>
  )
}

export default Layout
