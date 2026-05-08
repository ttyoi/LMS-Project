import { useEffect, useRef, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import styles from "./RegisterPage.module.css";
import api from "../../api/axios";
import AddressSearch from "../../components/common/AddressSearch";

const EMPTY_MESSAGE = { type: "", text: "" };
const KOREAN_CHAR_REGEX = /[ㄱ-ㅎㅏ-ㅣ가-힣]/g;
const WHITESPACE_REGEX = /\s/g;
const SANITIZED_FIELDS = new Set(["loginID", "birthday", "phone", "email"]);
const DEFAULT_BIRTHDAY_SUFFIX = "1";

function normalizeBirthdayForSubmit(value) {
  const birthday = value.replace(/\D/g, "").slice(0, 8);
  return birthday ? `${birthday}${DEFAULT_BIRTHDAY_SUFFIX}` : "";
}

function RegisterPage() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const instructorType = searchParams.get("type");
  const registerId = (searchParams.get("id") ?? "").trim();
  const isInstructorMode = instructorType === "instructor";

  const [form, setForm] = useState({
    loginID: "",
    password: "",
    passwordConfirm: "",
    name: "",
    birthday: "",
    phone: "",
    email: "",
    zipcode: "",
    addr1: "",
    addr2: "",
  });

  const [idMessage, setIdMessage] = useState(EMPTY_MESSAGE);
  const [passwordMessage, setPasswordMessage] = useState(EMPTY_MESSAGE);
  const [message, setMessage] = useState(EMPTY_MESSAGE);
  const [loading, setLoading] = useState(false);
  const [bootstrapLoading, setBootstrapLoading] = useState(false);
  const [isIdChecked, setIsIdChecked] = useState(false);
  const composingFieldRef = useRef("");
  const checkedLoginIdRef = useRef("");
  const latestIdCheckRef = useRef(0);

  useEffect(() => {
    let ignore = false;

    async function loadInstructorInfo() {
      if (!isInstructorMode) {
        return;
      }

      if (!registerId) {
        window.alert(
          "올바른 접근 방식이 아닙니다. 이메일의 회원가입 링크로 다시 접속해 주세요.",
        );
        navigate("/login", { replace: true });
        return;
      }

      setBootstrapLoading(true);
      setMessage(EMPTY_MESSAGE);
      setIdMessage(EMPTY_MESSAGE);

      try {
        const response = await api.post(
          "/api/inst/registerInstructorInfo",
          { id: registerId },
          {
            headers: {
              "Content-Type": "application/json",
            },
          },
        );

        const email = response.data?.email?.trim?.() ?? "";

        if (ignore) {
          return;
        }

        if (response.data?.result === "SUCCESS" && email) {
          setForm((prev) => ({
            ...prev,
            loginID: registerId,
            email,
          }));
          setIsIdChecked(true);
          checkedLoginIdRef.current = registerId;
          return;
        }

        throw new Error(
          response.data?.msg || "강사 가입 정보를 찾을 수 없습니다.",
        );
      } catch (err) {
        if (ignore) {
          return;
        }

        console.error("강사 가입 정보 조회 오류:", err);
        window.alert(
          "강사 가입 정보를 불러오지 못했습니다. 관리자에게 문의해 주세요.",
        );
        navigate("/login", { replace: true });
      } finally {
        if (!ignore) {
          setBootstrapLoading(false);
        }
      }
    }

    loadInstructorInfo();

    return () => {
      ignore = true;
    };
  }, [isInstructorMode, navigate, registerId]);

  const sanitizeValue = (name, value) => {
    if (name === "birthday") {
      let val = value.replace(/\D/g, "");

      val = val.substring(0, 8);

      if (val.length > 6) {
        val = `${val.slice(0, 4)}-${val.slice(4, 6)}-${val.slice(6)}`;
      } else if (val.length > 4) {
        val = `${val.slice(0, 4)}-${val.slice(4)}`;
      }

      return val;
    }

    if (name === "phone") {
      let val = value.replace(/\D/g, "");

      val = val.substring(0, 11);

      if (val.length > 7) {
        val = `${val.slice(0, 3)}-${val.slice(3, 7)}-${val.slice(7)}`;
      } else if (val.length > 3) {
        val = `${val.slice(0, 3)}-${val.slice(3)}`;
      }

      return val;
    }

    if (name === "loginID") {
      return value.replace(KOREAN_CHAR_REGEX, "").replace(WHITESPACE_REGEX, "");
    }

    if (name === "email" || name === "password" || name === "passwordConfirm") {
      return value.replace(WHITESPACE_REGEX, "");
    }

    return value;
  };

  const updateFormValue = (name, value) => {
    if (name === "loginID") {
      setIsIdChecked(false);
      checkedLoginIdRef.current = "";
      setIdMessage(EMPTY_MESSAGE);
    }

    if (name === "password" || name === "passwordConfirm") {
      setPasswordMessage(EMPTY_MESSAGE);
    }

    setForm((prev) => ({
      ...prev,
      [name]: sanitizeValue(name, value),
    }));
  };

  const handleChange = (e) => {
    const { name, value } = e.target;

    if (
      SANITIZED_FIELDS.has(name) &&
      (e.nativeEvent?.isComposing || composingFieldRef.current === name)
    ) {
      if (name === "loginID") {
        setIsIdChecked(false);
      }

      setForm((prev) => ({ ...prev, [name]: value }));
      return;
    }

    updateFormValue(name, value);
  };

  const handleCompositionStart = (e) => {
    const { name } = e.target;

    if (SANITIZED_FIELDS.has(name)) {
      composingFieldRef.current = name;
    }
  };

  const handleCompositionEnd = (e) => {
    const { name, value } = e.target;

    if (!SANITIZED_FIELDS.has(name)) {
      return;
    }

    composingFieldRef.current = "";
    updateFormValue(name, value);
  };

  const validatePasswordMatch = () => {
    if (!form.passwordConfirm) {
      setPasswordMessage(EMPTY_MESSAGE);
      return false;
    }

    if (form.password === form.passwordConfirm) {
      setPasswordMessage(EMPTY_MESSAGE);
      return true;
    }

    setPasswordMessage({
      type: "error",
      text: "비밀번호가 일치하지 않습니다.",
    });
    return false;
  };

  const parseCountResponse = (value) => {
    const parsed = Number(String(value).trim());
    return Number.isFinite(parsed) ? parsed : null;
  };

  const checkDuplicateId = async (loginID) => {
    if (isInstructorMode) {
      return true;
    }

    const trimmedLoginId = loginID.trim();

    if (!trimmedLoginId) {
      setIdMessage(EMPTY_MESSAGE);
      setIsIdChecked(false);
      checkedLoginIdRef.current = "";
      return false;
    }

    if (trimmedLoginId.length < 3) {
      setIdMessage({
        type: "error",
        text: "아이디는 3자 이상 입력해 주세요.",
      });
      setIsIdChecked(false);
      checkedLoginIdRef.current = "";
      return false;
    }

    if (trimmedLoginId === checkedLoginIdRef.current && isIdChecked) {
      return true;
    }

    const requestOrder = latestIdCheckRef.current + 1;
    latestIdCheckRef.current = requestOrder;

    try {
      const params = new URLSearchParams();
      params.append("loginID", trimmedLoginId);
      const response = await api.post("/check_loginID.do", params);
      const duplicateCount = parseCountResponse(response.data);

      if (latestIdCheckRef.current !== requestOrder) {
        return false;
      }

      if (duplicateCount === null) {
        setIdMessage({
          type: "error",
          text: "아이디 확인 응답을 해석할 수 없습니다.",
        });
        console.error("아이디 중복 체크 응답 형식 오류:", response.data);
        setIsIdChecked(false);
        checkedLoginIdRef.current = "";
        return false;
      }

      if (duplicateCount === 0) {
        setIdMessage(EMPTY_MESSAGE);
        setIsIdChecked(true);
        checkedLoginIdRef.current = trimmedLoginId;
        return true;
      } else {
        setIdMessage({
          type: "error",
          text: "중복된 아이디입니다.",
        });
        setIsIdChecked(false);
        checkedLoginIdRef.current = "";
        return false;
      }
    } catch (err) {
      if (latestIdCheckRef.current !== requestOrder) {
        return false;
      }

      setIdMessage({
        type: "error",
        text: "아이디 중복 확인 중 오류가 발생했습니다.",
      });
      console.error("아이디 중복 체크 오류:", err);
      setIsIdChecked(false);
      checkedLoginIdRef.current = "";
      return false;
    }
  };

  const handleLoginIdBlur = async () => {
    if (isInstructorMode) {
      return;
    }

    await checkDuplicateId(form.loginID);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    setMessage(EMPTY_MESSAGE);

    if (isInstructorMode) {
      const isPasswordValid = validatePasswordMatch();

      if (!isPasswordValid) {
        return;
      }

      if (!form.loginID.trim() || !form.email.trim()) {
        setMessage({
          type: "error",
          text: "강사 가입 정보를 불러오지 못했습니다. 이메일 링크로 다시 접속해 주세요.",
        });
        return;
      }

      setLoading(true);

      try {
        const formData = new FormData();
        formData.append("loginID", form.loginID.trim());
        formData.append("email", form.email.trim());
        formData.append("password", form.password);
        formData.append("name", form.name);
        formData.append("zipcode", form.zipcode);
        formData.append("addr1", form.addr1);
        formData.append("addr2", form.addr2);
        formData.append("birthday", normalizeBirthdayForSubmit(form.birthday));
        formData.append("phone", form.phone);

        const response = await api.post(
          "/api/inst/join/registerInstructor",
          formData,
          {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          },
        );

        if (response.data?.result === "SUCCESS") {
          alert(response.data?.msg ?? "강사 회원가입이 완료되었습니다.");
          navigate("/login");
          return;
        }

        setMessage({
          type: "error",
          text: response.data?.msg || "강사 회원가입에 실패했습니다.",
        });
      } catch (err) {
        setMessage({
          type: "error",
          text: "서버와 연결할 수 없습니다. 잠시 후 다시 시도해 주세요.",
        });
        console.error("강사 회원가입 오류:", err);
      } finally {
        setLoading(false);
      }

      return;
    }

    const isPasswordValid = validatePasswordMatch();
    const isLoginIdValid = await checkDuplicateId(form.loginID.trim());

    if (!isLoginIdValid || !isPasswordValid) {
      return;
    }

    setLoading(true);
    try {
      const params = new URLSearchParams();
      params.append("action", "I");
      params.append("loginID", form.loginID.trim());
      params.append("userName", form.name);
      params.append("password", form.password);
      params.append("zipCode", form.zipcode);
      params.append("address", form.addr1);
      params.append("detailAddress", form.addr2);
      params.append("birthday", normalizeBirthdayForSubmit(form.birthday));
      params.append("tel", form.phone);
      params.append("email", form.email.trim());

      const response = await api.post("/register.do", params);
      const result = response.data?.result;
      const resultMsg =
        response.data?.resultMsg ?? "회원가입이 완료되었습니다.";

      if (result === "SUCCESS") {
        alert(`${resultMsg} 로그인해 주세요.`);
        navigate("/login");
        return;
      }

      setMessage({
        type: "error",
        text: resultMsg || "회원가입에 실패했습니다.",
      });
    } catch (err) {
      setMessage({
        type: "error",
        text: "서버와 연결할 수 없습니다. 잠시 후 다시 시도해 주세요.",
      });
      console.error("회원가입 오류:", err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={styles.container}>
      <div className={styles.card}>
        <div className={styles.header}>
          <h1 className={styles.title}>HappyJob LMS</h1>
          <p className={styles.subtitle}>
            {isInstructorMode ? "강사 회원가입" : "회원가입"}
          </p>
        </div>

        {bootstrapLoading ? (
          <div className={styles.loadingBox}>
            강사 가입 정보를 불러오는 중입니다.
          </div>
        ) : (
          <form onSubmit={handleSubmit} className={styles.form}>
            {/* 아이디 */}
            <div className={styles.field}>
              <label className={`${styles.label} ${styles.required}`}>
                아이디
              </label>
              <div className={styles.inputWrapper}>
                <div className={styles.inputWithBtn}>
                  <input
                    type="text"
                    name="loginID"
                    value={form.loginID}
                    onChange={handleChange}
                    placeholder="아이디를 입력하세요"
                    onBlur={handleLoginIdBlur}
                    onCompositionStart={handleCompositionStart}
                    onCompositionEnd={handleCompositionEnd}
                    className={`${styles.input} ${
                      isInstructorMode ? styles.readOnlyInput : ""
                    }`}
                    minLength={3}
                    maxLength={16}
                    readOnly={isInstructorMode}
                    required
                    autoFocus={!isInstructorMode}
                  />
                </div>
                {!isInstructorMode && idMessage.text && (
                  <p
                    className={`${styles.feedback} ${
                      idMessage.type === "error"
                        ? styles.feedbackError
                        : styles.feedbackSuccess
                    }`}
                  >
                    {idMessage.text}
                  </p>
                )}
              </div>
            </div>

            {/* 비밀번호 */}
            <div className={styles.field}>
              <label className={`${styles.label} ${styles.required}`}>
                비밀번호
              </label>
              <div className={styles.inputWrapper}>
                <input
                  type="password"
                  name="password"
                  value={form.password}
                  onChange={handleChange}
                  placeholder="비밀번호를 입력하세요"
                  className={styles.input}
                  minLength={3}
                  maxLength={12}
                  required
                />
              </div>
            </div>

            <div className={styles.field}>
              <label className={`${styles.label} ${styles.required}`}>
                비밀번호 확인
              </label>
              <div className={styles.inputWrapper}>
                <input
                  type="password"
                  name="passwordConfirm"
                  value={form.passwordConfirm}
                  onChange={handleChange}
                  onBlur={validatePasswordMatch}
                  placeholder="비밀번호를 다시 입력하세요"
                  className={styles.input}
                  minLength={3}
                  maxLength={12}
                  required
                />
                {passwordMessage.text && (
                  <p
                    className={`${styles.feedback} ${
                      passwordMessage.type === "error"
                        ? styles.feedbackError
                        : styles.feedbackSuccess
                    }`}
                  >
                    {passwordMessage.text}
                  </p>
                )}
              </div>
            </div>

            {/* 이름 */}
            <div className={styles.field}>
              <label className={`${styles.label} ${styles.required}`}>
                이름
              </label>
              <div className={styles.inputWrapper}>
                <input
                  type="text"
                  name="name"
                  value={form.name}
                  onChange={handleChange}
                  placeholder="홍길동"
                  className={`${styles.input} ${styles.nameInput}`}
                  minLength={2}
                  maxLength={8}
                  required
                />
              </div>
              <label className={`${styles.label} ${styles.birthdayLabel}`}>
                생년월일
              </label>
              <input
                type="text"
                name="birthday"
                value={form.birthday}
                onChange={handleChange}
                onCompositionStart={handleCompositionStart}
                onCompositionEnd={handleCompositionEnd}
                placeholder="YYYY-MM-DD"
                className={`${styles.input} ${styles.centeredInput}`}
              />
            </div>

            <div className={styles.field}>
              <label className={styles.label}>연락처</label>
              <div className={styles.inputWrapper}>
                <input
                  type="tel"
                  name="phone"
                  value={form.phone}
                  onChange={handleChange}
                  placeholder="-없이 숫자만 입력"
                  onCompositionStart={handleCompositionStart}
                  onCompositionEnd={handleCompositionEnd}
                  className={styles.input}
                />
              </div>
            </div>

            {/* 이메일 */}
            <div className={styles.field}>
              <label className={`${styles.label} ${styles.required}`}>
                이메일
              </label>
              <div className={styles.inputWrapper}>
                <input
                  type="email"
                  name="email"
                  value={form.email}
                  onChange={handleChange}
                  placeholder="example@domain.com"
                  onCompositionStart={handleCompositionStart}
                  onCompositionEnd={handleCompositionEnd}
                  className={`${styles.input} ${
                    isInstructorMode ? styles.readOnlyInput : ""
                  }`}
                  readOnly={isInstructorMode}
                  required
                />
              </div>
            </div>

            {/* 주소 (공용 컴포넌트) */}
            <div className={`${styles.field} ${styles.addressField}`}>
              <label className={`${styles.label} ${styles.addressLabel}`}>
                주소
              </label>
              <div className={styles.inputWrapper}>
                <AddressSearch
                  zipcode={form.zipcode}
                  addr1={form.addr1}
                  addr2={form.addr2}
                  onAddressChange={(newData) =>
                    setForm((prev) => ({ ...prev, ...newData }))
                  }
                />
              </div>
            </div>

            {/* 메세지 영역 */}
            {message.text && (
              <div className={styles.inputWrapper}>
                <p
                  className={
                    message.type === "error" ? styles.error : styles.success
                  }
                >
                  {message.text}
                </p>
              </div>
            )}

            <button
              type="submit"
              className={styles.button}
              disabled={loading || bootstrapLoading}
            >
              {loading
                ? "처리 중..."
                : isInstructorMode
                  ? "강사 회원가입"
                  : "회원가입"}
            </button>
          </form>
        )}

        <div className={styles.footer}>
          이미 계정이 있으신가요?
          <button
            type="button"
            className={styles.linkBtn}
            onClick={() => navigate("/login")}
          >
            로그인
          </button>
        </div>
      </div>
    </div>
  );
}

export default RegisterPage;
