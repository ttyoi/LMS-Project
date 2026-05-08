# 📘 LMS-JQuery

**Java + Spring MVC + Maven + Tomcat 기반의 학습 관리 시스템(LMS)**  
Frontend는 **JSP + jQuery**, Backend는 **Spring MVC + MyBatis**, DB는 **MySQL**로 구성된 전형적인 웹 MVC 구조 프로젝트입니다.

---

## 🔧 **기술 스택 (Tech Stack)**

### 🖥️ Backend
- Java 17
- Spring MVC
- Maven
- MyBatis
- Tomcat (버전 제한 없음)
- JDK 17

### 🎨 Frontend
- JSP
- jQuery
- HTML/CSS

### 🗄️ Database
- MySQL
- Toad / Workbench 사용 가능

---

## 📂 **프로젝트 구조 (Architecture)**

Spring MVC 구조:
```angular2html
Controller → Service → DAO → MyBatis → MySQL
↑ ↓
└────────── JSP (jQuery) ←──┘
```


- **Controller** : 요청 매핑, 파라미터 처리, Model 전달
- **Service** : 비즈니스 로직
- **DAO** : DB 접근
- **MyBatis Mapper** : SQL 관리
- **JSP(jQuery)** : UI, AJAX 비동기 호출, 화면 렌더링

---
##  **디렉토리 구조**

```angular2html
src/main/java
 └ kr.happyjob.study
      ├ common            ★ 공통(인증/예외/유틸/인터셉터)
      ├ config            ★ 공통 설정(Spring, MyBatis 등)
      ├ core              ★ 권한 관리/세션/인터셉터
      ├ domain            ★ 도메인(학생/강사/관리자)
      │    ├ student
      │    │    ├ controller
      │    │    ├ service
      │    │    ├ dao
      │    │    └ model
      │    ├ instructor
      │    │    ├ controller
      │    │    ├ service
      │    │    ├ dao
      │    │    └ model
      │    └ admin
      │         ├ controller
      │         ├ service
      │         ├ dao
      │         └ model
      └ global
          ├ exception
          ├ util
          ├ dto
          └ annotation

src/main/resources
 ├ sql
 │  └ mapper        ★ MyBatis XML 파일들
 │        ├ student
 │        ├ instructor
 │        └ admin
 ├ mybatis-mysql-config.xml
 └ applicationContext.xml

src/main/webapp
├ WEB-INF
│    ├ view
│    │    ├ common
│    │    └ domain
│    │          ├ admin
│    │          ├ instructor
│    │          └ student
│    ├ resource
│    └ tlds
└ web.xml
```

---

## 📌 **주요 기능 정의 (Requirements Spec)**
👉 기능정의 스프레드시트:  
**[📄 기능정의/작업현황판/공통테이블정보(API명세포함) 링크]**  
https://docs.google.com/spreadsheets/d/1lvp0uC5bCf3_d-a8rbsA8xBXVxjA4kUc/edit?pli=1&gid=648316872#gid=648316872

---



## 📝 **개발 컨벤션 (Development Convention)**

프로젝트 전체 구성원들이 일관된 방식으로 개발하기 위해 다음의 컨벤션 문서를 기준으로 작업합니다.

📄 **개발 컨벤션 문서 링크:**  
👉 [개발 컨벤션 문서 보기](https://www.notion.so/2b982816a50480a7b152c9771de792e8)


## 🔄 **동작 흐름 (Request Flow)**

### 📌 데이터 흐름 요약

1. JSP(jQuery)에서 AJAX 요청
2. Spring Controller로 파라미터 전달
3. Service → DAO → MyBatis에서 SQL 실행
4. 결과를 Model 또는 JSON으로 반환
5. JSP에서 화면에 렌더링(append, val, html 등)

---

## 🛠️ **로컬 실행 방법 (How to Run)**

### 1. JDK 17 설치
### 2. LMS 프로젝트 Import
### 3. MySQL DB 생성 및 스키마 적용
### 4. `context-datasource.xml` DB정보 수정
### 5. Tomcat 등록 후 Run
### 6. 접속  
