import { useEffect, useRef, useState } from "react";
import { Link, useNavigate, useSearchParams } from "react-router-dom";
import api from "../../api/axios";
import styles from "./FindPage.module.css";

const TIMER_SECONDS = 5 * 60;
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const EMPTY_ID_FORM = { email: "", authCode: "" };
const EMPTY_PW_FORM = { loginID: "", email: "", authCode: "" };
const EMPTY_VERIFICATION = { sentCode: "", remainingSeconds: 0 };

function createFormBody(data) {
  const params = new URLSearchParams();

  Object.entries(data).forEach(([key, value]) => {
    params.append(key, value);
  });

  return params;
}

function formatTimer(seconds, hasCode) {
  if (!hasCode) {
    return "";
  }

  const safeSeconds = Math.max(seconds, 0);
  const minutes = Math.floor(safeSeconds / 60);
  const remainingSeconds = String(safeSeconds % 60).padStart(2, "0");
  return `${minutes}:${remainingSeconds}`;
}

function FindIdPage() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const activeTab = searchParams.get("tab");
  const [idForm, setIdForm] = useState(EMPTY_ID_FORM);
  const [pwForm, setPwForm] = useState(EMPTY_PW_FORM);
  const [idVerification, setIdVerification] = useState(EMPTY_VERIFICATION);
  const [pwVerification, setPwVerification] = useState(EMPTY_VERIFICATION);
  const [idCodeLoading, setIdCodeLoading] = useState(false);
  const [idFindLoading, setIdFindLoading] = useState(false);
  const [pwCodeLoading, setPwCodeLoading] = useState(false);
  const [pwFindLoading, setPwFindLoading] = useState(false);

  const passwordSectionRef = useRef(null);
  const passwordIdInputRef = useRef(null);
  const idAuthInputRef = useRef(null);
  const pwAuthInputRef = useRef(null);

  const isIdCodeButtonDisabled =
    idCodeLoading || idVerification.remainingSeconds > 0;
  const isPwCodeButtonDisabled =
    pwCodeLoading || pwVerification.remainingSeconds > 0;

  useEffect(() => {
    const timerId = window.setInterval(() => {
      setIdVerification((prev) =>
        prev.remainingSeconds > 0
          ? { ...prev, remainingSeconds: prev.remainingSeconds - 1 }
          : prev,
      );
      setPwVerification((prev) =>
        prev.remainingSeconds > 0
          ? { ...prev, remainingSeconds: prev.remainingSeconds - 1 }
          : prev,
      );
    }, 1000);

    return () => window.clearInterval(timerId);
  }, []);

  useEffect(() => {
    if (activeTab !== "pw") {
      return;
    }

    passwordSectionRef.current?.scrollIntoView({
      behavior: "smooth",
      block: "center",
    });
    passwordIdInputRef.current?.focus();
  }, [activeTab]);

  const resetIdSection = () => {
    setIdForm(EMPTY_ID_FORM);
    setIdVerification(EMPTY_VERIFICATION);
  };

  const handleIdFormChange = (e) => {
    const { name, value } = e.target;

    setIdForm((prev) => ({
      ...prev,
      [name]: value,
      ...(name === "email" ? { authCode: "" } : {}),
    }));

    if (name === "email") {
      setIdVerification(EMPTY_VERIFICATION);
    }
  };

  const handlePwFormChange = (e) => {
    const { name, value } = e.target;

    setPwForm((prev) => ({
      ...prev,
      [name]: value,
      ...(name === "loginID" || name === "email" ? { authCode: "" } : {}),
    }));

    if (name === "loginID" || name === "email") {
      setPwVerification(EMPTY_VERIFICATION);
    }
  };

  const requestIdAuthCode = async () => {
    const email = idForm.email.trim();

    if (!email) {
      window.alert("이메일을 입력해주세요.");
      return;
    }

    if (!EMAIL_REGEX.test(email)) {
      window.alert("이메일 형식이 올바르지 않습니다.");
      return;
    }

    setIdCodeLoading(true);

    try {
      const findResponse = await api.post(
        "/selectFindInfo.do",
        createFormBody({ user_email: email }),
      );

      if (findResponse.data?.result !== "SUCCESS") {
        window.alert("존재하지 않는 이메일 입니다.");
        return;
      }

      const mailResponse = await api.post(
        "/sendmail.do",
        createFormBody({ email }),
      );
      const mailResult = mailResponse.data ?? {};

      if (mailResult.result !== "SUCCESS") {
        window.alert(
          mailResult.resultMsg ?? "인증번호 발송에 실패했습니다.",
        );
        return;
      }

      const authNumId = String(mailResult.authNumId ?? "").trim();

      if (!authNumId) {
        window.alert("인증번호 발송에 실패했습니다.");
        return;
      }

      setIdForm((prev) => ({
        ...prev,
        email,
        authCode: "",
      }));
      setIdVerification({
        sentCode: authNumId,
        remainingSeconds: TIMER_SECONDS,
      });
      window.alert("해당 이메일로 인증번호를 전송하였습니다.");
      idAuthInputRef.current?.focus();
    } catch (error) {
      console.error("아이디 찾기 인증번호 발송 오류:", error);
      window.alert("인증번호 발송 중 오류가 발생했습니다.");
    } finally {
      setIdCodeLoading(false);
    }
  };

  const handleFindId = async () => {
    const email = idForm.email.trim();
    const authCode = idForm.authCode.trim();

    if (!email) {
      window.alert("이메일을 입력해주세요.");
      return;
    }

    if (!EMAIL_REGEX.test(email)) {
      window.alert("이메일 형식이 올바르지 않습니다.");
      return;
    }

    if (!idVerification.sentCode) {
      window.alert("먼저 인증번호를 받아주세요.");
      return;
    }

    if (!authCode) {
      window.alert("인증번호를 입력해주세요.");
      return;
    }

    if (idVerification.remainingSeconds <= 0) {
      window.alert("인증번호가 만료되었습니다. 다시 인증번호를 받아주세요.");
      return;
    }

    if (authCode !== idVerification.sentCode) {
      window.alert("인증번호가 틀렸습니다.");
      return;
    }

    setIdFindLoading(true);

    try {
      const response = await api.post(
        "/selectFindInfo.do",
        createFormBody({ user_email: email }),
      );

      if (
        response.data?.result !== "SUCCESS" ||
        !response.data?.resultModel?.loginID
      ) {
        window.alert("일치하는 정보가 없습니다.");
        return;
      }

      window.alert(
        `회원님의 아이디는 ${response.data.resultModel.loginID} 입니다.`,
      );
    } catch (error) {
      console.error("아이디 찾기 오류:", error);
      window.alert("아이디 찾기 중 오류가 발생했습니다.");
    } finally {
      setIdFindLoading(false);
    }
  };

  const requestPasswordAuthCode = async () => {
    const loginID = pwForm.loginID.trim();
    const email = pwForm.email.trim();

    if (!loginID) {
      window.alert("아이디를 입력해주세요.");
      return;
    }

    if (!email) {
      window.alert("이메일을 입력해주세요.");
      return;
    }

    if (!EMAIL_REGEX.test(email)) {
      window.alert("이메일 형식이 올바르지 않습니다.");
      return;
    }

    resetIdSection();
    setPwCodeLoading(true);

    try {
      const findResponse = await api.post(
        "/selectFindInfoPw.do",
        createFormBody({ loginID, user_email: email }),
      );

      if (findResponse.data?.result !== "SUCCESS") {
        window.alert("아이디 또는 이메일이 일치하지 않습니다.");
        return;
      }

      const mailResponse = await api.post(
        "/sendmail.do",
        createFormBody({ email }),
      );
      const mailResult = mailResponse.data ?? {};

      if (mailResult.result !== "SUCCESS") {
        window.alert(
          mailResult.resultMsg ?? "인증번호 발송에 실패했습니다.",
        );
        return;
      }

      const authNumId = String(mailResult.authNumId ?? "").trim();

      if (!authNumId) {
        window.alert("인증번호 발송에 실패했습니다.");
        return;
      }

      setPwForm((prev) => ({
        ...prev,
        loginID,
        email,
        authCode: "",
      }));
      setPwVerification({
        sentCode: authNumId,
        remainingSeconds: TIMER_SECONDS,
      });
      window.alert("해당 이메일로 인증번호를 전송하였습니다.");
      pwAuthInputRef.current?.focus();
    } catch (error) {
      console.error("비밀번호 찾기 인증번호 발송 오류:", error);
      window.alert("인증번호 발송 중 오류가 발생했습니다.");
    } finally {
      setPwCodeLoading(false);
    }
  };

  const handleFindPassword = async () => {
    const loginID = pwForm.loginID.trim();
    const email = pwForm.email.trim();
    const authCode = pwForm.authCode.trim();

    if (!loginID) {
      window.alert("아이디를 입력해주세요.");
      return;
    }

    if (!email) {
      window.alert("이메일을 입력해주세요.");
      return;
    }

    if (!EMAIL_REGEX.test(email)) {
      window.alert("이메일 형식이 올바르지 않습니다.");
      return;
    }

    if (!pwVerification.sentCode) {
      window.alert("먼저 인증번호를 받아주세요.");
      return;
    }

    if (!authCode) {
      window.alert("인증번호를 입력해주세요.");
      return;
    }

    if (pwVerification.remainingSeconds <= 0) {
      window.alert("인증번호가 만료되었습니다. 다시 인증번호를 받아주세요.");
      return;
    }

    if (authCode !== pwVerification.sentCode) {
      window.alert("인증번호가 틀렸습니다.");
      return;
    }

    setPwFindLoading(true);

    try {
      const response = await api.post(
        "/searchPassword.do",
        createFormBody({ id: loginID, email }),
      );
      const isIssued =
        typeof response.data === "string" &&
        response.data.includes("임시 비밀번호를 발급했습니다.");
      const message =
        typeof response.data === "string"
          ? response.data
          : "임시 비밀번호 발급 중 오류가 발생했습니다.";

      window.alert(message);

      if (isIssued) {
        navigate("/login");
      }
    } catch (error) {
      console.error("비밀번호 찾기 오류:", error);
      window.alert("비밀번호 찾기 중 오류가 발생했습니다.");
    } finally {
      setPwFindLoading(false);
    }
  };

  return (
    <div className={styles.container}>
      <div className={styles.card}>
        <div className={styles.header}>
          <h1 className={styles.title}>HappyJob LMS</h1>
          <p className={styles.subtitle}>아이디/비밀번호 찾기</p>
        </div>

        <div className={styles.contentGrid}>
          <div className={styles.section}>
            <div className={styles.sectionHeader}>
              <h2 className={styles.sectionTitle}>아이디 찾기</h2>
            </div>

            <div className={styles.field}>
              <label className={`${styles.label} ${styles.required}`} htmlFor="findIdEmail">
                이메일
              </label>
              <input
                id="findIdEmail"
                type="email"
                name="email"
                value={idForm.email}
                onChange={handleIdFormChange}
                className={styles.input}
                placeholder="이메일을 입력하세요"
                autoComplete="email"
              />
            </div>

            <div className={styles.field}>
              <label className={styles.label} htmlFor="findIdAuthCode">
                인증번호
              </label>
              <div className={styles.authRow}>
                <div className={styles.inputWithTimer}>
                  <input
                    ref={idAuthInputRef}
                    id="findIdAuthCode"
                    type="text"
                    name="authCode"
                    value={idForm.authCode}
                    onChange={handleIdFormChange}
                    className={`${styles.input} ${
                      idVerification.sentCode ? styles.authInput : ""
                    }`}
                    inputMode="numeric"
                  />
                  {idVerification.sentCode && (
                    <span
                      className={`${styles.timer} ${
                        idVerification.remainingSeconds <= 0
                          ? styles.timerExpired
                          : ""
                      }`}
                    >
                      {formatTimer(idVerification.remainingSeconds, true)}
                    </span>
                  )}
                </div>
                <button
                  type="button"
                  className={styles.secondaryButton}
                  onClick={requestIdAuthCode}
                  disabled={isIdCodeButtonDisabled}
                >
                  {idCodeLoading ? "전송 중..." : "인증번호 받기"}
                </button>
              </div>
            </div>

            <button
              type="button"
              className={styles.primaryButton}
              onClick={handleFindId}
              disabled={idFindLoading}
            >
              {idFindLoading ? "확인 중..." : "아이디 찾기"}
            </button>
          </div>

          <div
            ref={passwordSectionRef}
            className={`${styles.section} ${styles.passwordSection}`}
          >
            <div className={styles.sectionHeader}>
              <h2 className={styles.sectionTitle}>비밀번호 찾기</h2>
            </div>

            <div className={styles.field}>
              <label className={`${styles.label} ${styles.required}`} htmlFor="findPwLoginId">
                아이디
              </label>
              <input
                ref={passwordIdInputRef}
                id="findPwLoginId"
                type="text"
                name="loginID"
                value={pwForm.loginID}
                onChange={handlePwFormChange}
                className={styles.input}
                placeholder="아이디를 입력하세요"
                autoComplete="username"
              />
            </div>

            <div className={styles.field}>
              <label className={`${styles.label} ${styles.required}`} htmlFor="findPwEmail">
                이메일
              </label>
              <input
                id="findPwEmail"
                type="email"
                name="email"
                value={pwForm.email}
                onChange={handlePwFormChange}
                className={styles.input}
                placeholder="이메일을 입력하세요"
                autoComplete="email"
              />
            </div>

            <div className={styles.field}>
              <label className={styles.label} htmlFor="findPwAuthCode">
                인증번호
              </label>
              <div className={styles.authRow}>
                <div className={styles.inputWithTimer}>
                  <input
                    ref={pwAuthInputRef}
                    id="findPwAuthCode"
                    type="text"
                    name="authCode"
                    value={pwForm.authCode}
                    onChange={handlePwFormChange}
                    className={`${styles.input} ${
                      pwVerification.sentCode ? styles.authInput : ""
                    }`}
                    inputMode="numeric"
                  />
                  {pwVerification.sentCode && (
                    <span
                      className={`${styles.timer} ${
                        pwVerification.remainingSeconds <= 0
                          ? styles.timerExpired
                          : ""
                      }`}
                    >
                      {formatTimer(pwVerification.remainingSeconds, true)}
                    </span>
                  )}
                </div>
                <button
                  type="button"
                  className={styles.secondaryButton}
                  onClick={requestPasswordAuthCode}
                  disabled={isPwCodeButtonDisabled}
                >
                  {pwCodeLoading ? "전송 중..." : "인증번호 받기"}
                </button>
              </div>
            </div>

            <button
              type="button"
              className={styles.primaryButton}
              onClick={handleFindPassword}
              disabled={pwFindLoading}
            >
              {pwFindLoading ? "발급 중..." : "비밀번호 찾기"}
            </button>
          </div>
        </div>

        <div className={styles.links}>
          <Link to="/register" className={styles.link}>
            회원가입
          </Link>
          <span className={styles.divider}>|</span>
          <Link to="/login" className={styles.link}>
            로그인
          </Link>
        </div>
      </div>
    </div>
  );
}

export default FindIdPage;
