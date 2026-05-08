import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      // 백엔드 Spring MVC 서버로 프록시
      // ^로 시작하면 정규식으로 인식됩니다.
      // *.do 엔드포인트(/loginProc.do, /dashboard.do 등) 전부 포함
      "^/.*\\.do": {
        target: "http://localhost:80",
        changeOrigin: true,
        secure: false,
        bypass(req) {
          if (req.headers.accept?.includes("text/html")) return "/index.html";
        },
      },
      "/api": {
        target: "http://localhost:80",
        changeOrigin: true,
        secure: false,
      },
      "/inst": {
        target: "http://localhost:80",
        changeOrigin: true,
        secure: false,
        bypass(req) {
          if (req.headers.accept?.includes("text/html")) return "/index.html";
        },
      },
      "/stu": {
        target: "http://localhost:80",
        changeOrigin: true,
        secure: false,
        bypass(req) {
          if (req.headers.accept?.includes("text/html")) return "/index.html";
        },
      },
      "/admin": {
        target: "http://localhost:80",
        changeOrigin: true,
        secure: false,
        bypass(req) {
          if (req.headers.accept?.includes("text/html")) return "/index.html";
        },
      },
    },
  },
});
