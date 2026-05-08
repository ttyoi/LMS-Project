import { useEffect, useMemo, useRef, useState } from "react";
import { useLocation } from "react-router-dom";
import api from "../../api/axios";
import AddressSearch from "../../components/common/AddressSearch";
import { useAuth } from "../../context/AuthContext";
import defaultProfileImage from "../../assets/default-profile.jpg";
import styles from "./UserInfoPage.module.css";

const EMPTY_USER = {
  loginID: "",
  name: "",
  phone: "",
  email: "",
  birthday: "",
  zipcode: "",
  addr1: "",
  addr2: "",
  resumeName: "",
  resumeId: 0,
  imgName: "",
  imgLogiPath: "",
  chkTemPassword: "",
};

const EMPTY_FORM = {
  phone: "",
  email: "",
  birthday: "",
  zipcode: "",
  addr1: "",
  addr2: "",
};

const EMPTY_PASSWORD = {
  oldPassword: "",
  newPassword: "",
};

const EMPTY_EDU = { eduLevel: "", career: "" };
const SANITIZED_FIELDS = new Set(["birthday", "phone", "email"]);
const WHITESPACE_REGEX = /\s/g;
const DEFAULT_BIRTHDAY_SUFFIX = "1";
const ENV_BACKEND_ORIGIN = (import.meta.env.VITE_BACKEND_ORIGIN ?? "").trim();
const AJAX_REQUEST_CONFIG = { headers: { AJAX: "true" } };

function withAjaxHeader(config = {}) {
  return {
    ...config,
    headers: {
      AJAX: "true",
      ...(config.headers ?? {}),
    },
  };
}

function resolveBackendOrigin() {
  if (ENV_BACKEND_ORIGIN) {
    return ENV_BACKEND_ORIGIN.replace(/\/$/, "");
  }

  if (typeof window === "undefined") return "";

  if (window.location.port === "3000") {
    return `${window.location.protocol}//${window.location.hostname}:80`;
  }

  return window.location.origin;
}

function buildImageSrc(path, name) {
  if (!path || !name) return "";
  if (/^https?:\/\//i.test(name)) return name;
  const normalizedPath = path.endsWith("/") ? path.slice(0, -1) : path;
  const normalizedName = name.startsWith("/") ? name.slice(1) : name;
  const joinedPath = `${normalizedPath}/${normalizedName}`;
  if (/^https?:\/\//i.test(joinedPath)) return joinedPath;

  const backendOrigin = resolveBackendOrigin();
  if (!backendOrigin) return joinedPath;
  if (joinedPath.startsWith("/")) return `${backendOrigin}${joinedPath}`;
  return `${backendOrigin}/${joinedPath}`;
}

function extractOriginalResumeName(fileName) {
  if (!fileName) return "";
  const matched = String(fileName).match(/^.*_[0-9a-fA-F-]{36}_(.+)$/);
  return matched?.[1] ?? fileName;
}

function createFormBody(payload) {
  const params = new URLSearchParams();
  Object.entries(payload).forEach(([key, value]) => {
    if (value !== undefined && value !== null) params.append(key, String(value));
  });
  return params;
}

function getRoleConfig(userType, pathname) {
  const normalized = String(userType ?? "").toUpperCase();
  if (normalized === "I" || pathname.startsWith("/inst/")) {
    return {
      isStudent: false,
      basePath: "/inst",
      topDescription: "기본 정보와 학력 및 경력 사항을 한 화면에서 수정합니다.",
    };
  }
  return {
    isStudent: true,
    basePath: "/stu",
    topDescription: "기본 정보와 이력서 파일을 한 화면에서 관리합니다.",
  };
}

function sanitizeValue(name, value) {
  if (name === "birthday") {
    let nextValue = value.replace(/\D/g, "").slice(0, 8);
    if (nextValue.length > 6) return `${nextValue.slice(0, 4)}-${nextValue.slice(4, 6)}-${nextValue.slice(6)}`;
    if (nextValue.length > 4) return `${nextValue.slice(0, 4)}-${nextValue.slice(4)}`;
    return nextValue;
  }
  if (name === "phone") {
    let nextValue = value.replace(/\D/g, "").slice(0, 11);
    if (nextValue.length > 7) return `${nextValue.slice(0, 3)}-${nextValue.slice(3, 7)}-${nextValue.slice(7)}`;
    if (nextValue.length > 3) return `${nextValue.slice(0, 3)}-${nextValue.slice(3)}`;
    return nextValue;
  }
  if (name === "email") return value.replace(WHITESPACE_REGEX, "");
  return value;
}

function normalizeBirthdayForSubmit(value) {
  const birthday = value.replace(/\D/g, "").slice(0, 8);
  return birthday ? `${birthday}${DEFAULT_BIRTHDAY_SUFFIX}` : "";
}

function displayFileName(file, fallback, emptyText) {
  if (file?.name) return file.name;
  if (fallback) return fallback;
  return emptyText;
}

function normalizePasswordError(result) {
  if (result === "WRONG_OLD_PASSWORD") return "현재 비밀번호가 올바르지 않습니다.";
  if (result === "SAME_PASSWORD") return "새 비밀번호가 이전 비밀번호와 동일합니다.";
  return "비밀번호 변경에 실패했습니다.";
}

function UserInfoPage() {
  const location = useLocation();
  const { user } = useAuth();
  const roleConfig = useMemo(
    () => getRoleConfig(user?.userType, location.pathname),
    [location.pathname, user?.userType],
  );

  const profileInputRef = useRef(null);
  const resumeInputRef = useRef(null);
  const composingFieldRef = useRef("");

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [userInfo, setUserInfo] = useState(EMPTY_USER);
  const [form, setForm] = useState(EMPTY_FORM);
  const [passwordForm, setPasswordForm] = useState(EMPTY_PASSWORD);
  const [eduCareerForm, setEduCareerForm] = useState(EMPTY_EDU);
  const [profileFile, setProfileFile] = useState(null);
  const [resumeFile, setResumeFile] = useState(null);
  const [profilePreview, setProfilePreview] = useState("");
  const [profileImageBroken, setProfileImageBroken] = useState(false);
  const [profileImageVersion, setProfileImageVersion] = useState(0);
  const [savingPage, setSavingPage] = useState(false);

  const profileImageSrc = useMemo(() => {
    if (profilePreview) return profilePreview;
    if (profileImageBroken) return "";
    const nextSrc = buildImageSrc(userInfo.imgLogiPath, userInfo.imgName);
    if (!nextSrc) return "";
    return profileImageVersion > 0 ? `${nextSrc}?v=${profileImageVersion}` : nextSrc;
  }, [profilePreview, profileImageBroken, profileImageVersion, userInfo.imgLogiPath, userInfo.imgName]);

  useEffect(() => {
    if (!profileFile) {
      setProfilePreview("");
      return undefined;
    }

    const previewUrl = URL.createObjectURL(profileFile);
    setProfilePreview(previewUrl);
    return () => URL.revokeObjectURL(previewUrl);
  }, [profileFile]);

  useEffect(() => {
    setProfileImageBroken(false);
  }, [userInfo.imgName, userInfo.imgLogiPath]);

  const loadPageData = async () => {
    setLoading(true);
    setError("");
    try {
      const userInfoResponse = await api.get(
        `${roleConfig.basePath}/userInfoAjax.do`,
        AJAX_REQUEST_CONFIG,
      );
      const nextUser = { ...EMPTY_USER, ...(userInfoResponse.data ?? {}) };
      setUserInfo(nextUser);
      setForm({
        phone: sanitizeValue("phone", nextUser.phone ?? ""),
        email: sanitizeValue("email", nextUser.email ?? ""),
        birthday: sanitizeValue("birthday", nextUser.birthday ?? ""),
        zipcode: nextUser.zipcode ?? "",
        addr1: nextUser.addr1 ?? "",
        addr2: nextUser.addr2 ?? "",
      });
      setPasswordForm(EMPTY_PASSWORD);

      if (roleConfig.isStudent) {
        setEduCareerForm(EMPTY_EDU);
      } else {
        const eduResponse = await api.get(
          `${roleConfig.basePath}/getEduCareer.do`,
          AJAX_REQUEST_CONFIG,
        );
        setEduCareerForm({
          eduLevel: eduResponse.data?.eduLevel ?? "",
          career: eduResponse.data?.career ?? "",
        });
      }
    } catch (loadError) {
      console.error("마이페이지 정보 조회 오류:", loadError);
      setError("사용자 정보를 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadPageData();
  }, [roleConfig.basePath, roleConfig.isStudent]);

  const updateFormValue = (name, value) => {
    setForm((prev) => ({ ...prev, [name]: sanitizeValue(name, value) }));
  };

  const handleFieldChange = (event) => {
    const { name, value } = event.target;
    if (
      SANITIZED_FIELDS.has(name) &&
      (event.nativeEvent?.isComposing || composingFieldRef.current === name)
    ) {
      setForm((prev) => ({ ...prev, [name]: value }));
      return;
    }
    updateFormValue(name, value);
  };

  const handleCompositionStart = (event) => {
    const { name } = event.target;
    if (SANITIZED_FIELDS.has(name)) composingFieldRef.current = name;
  };

  const handleCompositionEnd = (event) => {
    const { name, value } = event.target;
    if (!SANITIZED_FIELDS.has(name)) return;
    composingFieldRef.current = "";
    updateFormValue(name, value);
  };

  const handlePasswordChange = (event) => {
    const { name, value } = event.target;
    setPasswordForm((prev) => ({ ...prev, [name]: value }));
  };

  const clearSelectedFiles = () => {
    setProfileFile(null);
    setResumeFile(null);
    if (profileInputRef.current) profileInputRef.current.value = "";
    if (resumeInputRef.current) resumeInputRef.current.value = "";
  };

  const handlePageSave = async () => {
    const payload = {
      phone: form.phone.trim(),
      email: form.email.trim(),
      birthday: normalizeBirthdayForSubmit(form.birthday),
      zipcode: form.zipcode.trim(),
      addr1: form.addr1.trim(),
      addr2: form.addr2.trim(),
    };
    const oldPassword = passwordForm.oldPassword.trim();
    const newPassword = passwordForm.newPassword.trim();
    const wantsPasswordChange = Boolean(oldPassword || newPassword);

    if (!payload.email) {
      alert("이메일을 입력해 주세요.");
      return;
    }

    if (wantsPasswordChange && (!oldPassword || !newPassword)) {
      alert("현재 비밀번호와 새 비밀번호를 모두 입력해 주세요.");
      return;
    }

    setSavingPage(true);

    let baseInfoSaved = false;
    let successMessage = "사용자 정보가 저장되었습니다.";

    try {
      if (roleConfig.isStudent) {
        const updateResponse = await api.post(
          `${roleConfig.basePath}/updateUserInfo.do`,
          payload,
          withAjaxHeader({ headers: { "Content-Type": "application/json" } }),
        );
        if (updateResponse.data?.result !== "SUCCESS") {
          throw new Error("사용자 정보 저장에 실패했습니다.");
        }
      } else {
        const updateResponse = await api.post(
          `${roleConfig.basePath}/updateUserInfo.do`,
          createFormBody(payload),
          AJAX_REQUEST_CONFIG,
        );
        if (updateResponse.data?.result !== "SUCCESS") {
          throw new Error("사용자 정보 저장에 실패했습니다.");
        }

        const eduResponse = await api.post(
          `${roleConfig.basePath}/updateEduCareer.do`,
          createFormBody({
            eduLevel: eduCareerForm.eduLevel.trim(),
            career: eduCareerForm.career.trim(),
          }),
          AJAX_REQUEST_CONFIG,
        );
        if (eduResponse.data?.result !== "SUCCESS") {
          throw new Error("학력/경력 저장에 실패했습니다.");
        }
      }

      baseInfoSaved = true;

      if (profileFile) {
        const profileFormData = new FormData();
        profileFormData.append("file", profileFile);
        const profileResponse = await api.post(
          `${roleConfig.basePath}/uploadProfileImage.do`,
          profileFormData,
          withAjaxHeader({ headers: { "Content-Type": "multipart/form-data" } }),
        );
        if (profileResponse.data?.result !== "SUCCESS") {
          throw new Error("프로필 사진 저장에 실패했습니다.");
        }
        setUserInfo((prev) => ({
          ...prev,
          imgName: profileResponse.data?.imgName ?? prev.imgName,
          imgLogiPath: profileResponse.data?.imgLogiPath ?? prev.imgLogiPath,
        }));
        setProfileImageBroken(false);
        setProfileImageVersion(Date.now());
      }

      if (roleConfig.isStudent && resumeFile) {
        const resumeFormData = new FormData();
        resumeFormData.append("uploadFile", resumeFile);
        const resumeResponse = await api.post(
          `${roleConfig.basePath}/resume.do`,
          resumeFormData,
          withAjaxHeader({ headers: { "Content-Type": "multipart/form-data" } }),
        );
        if (resumeResponse.data?.result !== "SUCCESS") {
          throw new Error("이력서 저장에 실패했습니다.");
        }
      }

      if (wantsPasswordChange) {
        const passwordResponse = await api.post(
          `${roleConfig.basePath}/changePassword.do`,
          createFormBody({ oldPassword, newPassword }),
          AJAX_REQUEST_CONFIG,
        );
        if (passwordResponse.data?.result !== "SUCCESS") {
          throw new Error(normalizePasswordError(passwordResponse.data?.result));
        }
        successMessage = "사용자 정보와 비밀번호가 저장되었습니다.";
      }

      clearSelectedFiles();
      await loadPageData();
      alert(successMessage);
    } catch (saveError) {
      console.error("사용자 정보 저장 오류:", saveError);

      if (baseInfoSaved && wantsPasswordChange) {
        await loadPageData().catch(() => {});
        alert(`기본 정보는 저장되었지만 ${saveError.message || "비밀번호 변경에 실패했습니다."}`);
      } else {
        alert(saveError.message || "사용자 정보 저장에 실패했습니다.");
      }
    } finally {
      setSavingPage(false);
    }
  };

  const handleResumeDownload = (event) => {
    if (!user?.isMock) return;
    event.preventDefault();
    alert("(Mock) 이력서 다운로드는 생략됩니다.");
  };

  const handleResumeRemove = async () => {
    if (resumeFile) {
      setResumeFile(null);
      if (resumeInputRef.current) resumeInputRef.current.value = "";
      return;
    }

    if (!userInfo.resumeId) return;

    const shouldDelete = window.confirm("등록된 이력서를 삭제하시겠습니까?");
    if (!shouldDelete) return;

    try {
      const response = await api.post(
        `${roleConfig.basePath}/resume/delete.do`,
        createFormBody({}),
        AJAX_REQUEST_CONFIG,
      );
      if (response.data?.result !== "SUCCESS") {
        throw new Error("이력서 삭제에 실패했습니다.");
      }

      setUserInfo((prev) => ({
        ...prev,
        resumeId: 0,
        resumeName: "",
      }));
      if (resumeInputRef.current) resumeInputRef.current.value = "";
      alert("이력서가 삭제되었습니다.");
    } catch (deleteError) {
      console.error("이력서 삭제 오류:", deleteError);
      alert(deleteError.message || "이력서 삭제에 실패했습니다.");
    }
  };

  const renderProfileVisual = () => {
    return (
      <img
        src={profileImageSrc || defaultProfileImage}
        alt={profileImageSrc ? "프로필 사진" : "기본 프로필 사진"}
        className={`${styles.profileImage} ${!profileImageSrc ? styles.defaultProfileImage : ""}`}
        onError={() => {
          if (profileImageSrc) setProfileImageBroken(true);
        }}
      />
    );
  };

  return (
    <div className={styles.page}>
      <section className={styles.sheet}>
        <header className={styles.pageHeader}>
          <h1 className={styles.pageTitle}>사용자 정보 관리</h1>
        </header>

        {userInfo.chkTemPassword === "Y" && (
          <div className={styles.noticeBanner}>
            임시 비밀번호로 로그인한 상태입니다. 보안을 위해 비밀번호를 먼저 변경해 주세요.
          </div>
        )}

        {loading ? (
          <section className={styles.feedbackCard}>사용자 정보를 불러오는 중입니다.</section>
        ) : error ? (
          <section className={styles.feedbackCard}>
            <p className={styles.errorText}>{error}</p>
            <button type="button" className={styles.secondaryButton} onClick={() => window.location.reload()}>
              다시 시도
            </button>
          </section>
        ) : (
          <section className={styles.managementCard}>
            <div className={styles.profileSection}>
              <button
                type="button"
                className={styles.profileButton}
                onClick={() => profileInputRef.current?.click()}
              >
                {renderProfileVisual()}
                <span className={styles.profileOverlay}>프로필 사진 변경</span>
              </button>
            </div>

            <div className={styles.infoGrid}>
              <label className={styles.field}>
                <span className={styles.fieldLabel}>이름</span>
                <input className={`${styles.control} ${styles.readOnlyControl}`} value={userInfo.name ?? ""} readOnly />
              </label>

              {roleConfig.isStudent && (
                <div className={styles.field}>
                  <span className={styles.fieldLabel}>이력서</span>
                  <div className={styles.fileField}>
                    <div className={styles.fileDisplay}>
                      {resumeFile ? (
                        <input
                          className={`${styles.control} ${styles.readOnlyControl}`}
                          value={resumeFile.name}
                          readOnly
                        />
                      ) : userInfo.resumeId > 0 ? (
                        <a
                          className={styles.fileNameLink}
                          href={`/stu/resume/download.do?resumeId=${userInfo.resumeId}`}
                          onClick={handleResumeDownload}
                        >
                          {extractOriginalResumeName(userInfo.resumeName)}
                        </a>
                      ) : (
                        <input
                          className={`${styles.control} ${styles.readOnlyControl}`}
                          value={displayFileName(null, "", "등록된 이력서가 없습니다.")}
                          readOnly
                        />
                      )}
                      {(resumeFile || userInfo.resumeId > 0) && (
                        <button
                          type="button"
                          className={styles.removeFileButton}
                          onClick={handleResumeRemove}
                          aria-label="이력서 삭제"
                          title="이력서 삭제"
                        >
                          x
                        </button>
                      )}
                    </div>
                    <button type="button" className={styles.secondaryButton} onClick={() => resumeInputRef.current?.click()}>
                      등록/변경
                    </button>
                  </div>
                </div>
              )}

              {!roleConfig.isStudent && (
                <label className={styles.field}>
                  <span className={styles.fieldLabel}>이력서</span>
                  <input
                    className={`${styles.control} ${styles.readOnlyControl}`}
                    value=""
                    readOnly
                    disabled
                  />
                </label>
              )}

              <label className={styles.field}>
                <span className={styles.fieldLabel}>아이디</span>
                <input className={`${styles.control} ${styles.readOnlyControl}`} value={userInfo.loginID ?? ""} readOnly />
              </label>

              <label className={styles.field}>
                <span className={styles.fieldLabel}>이메일</span>
                <input
                  className={styles.control}
                  name="email"
                  type="email"
                  value={form.email}
                  onChange={handleFieldChange}
                  onCompositionStart={handleCompositionStart}
                  onCompositionEnd={handleCompositionEnd}
                />
              </label>

              <label className={styles.field}>
                <span className={styles.fieldLabel}>현재 비밀번호</span>
                <input
                  className={styles.control}
                  type="password"
                  name="oldPassword"
                  value={passwordForm.oldPassword}
                  onChange={handlePasswordChange}
                  placeholder="비밀번호 변경 시 입력"
                />
              </label>

              <label className={styles.field}>
                <span className={styles.fieldLabel}>새 비밀번호</span>
                <input
                  className={styles.control}
                  type="password"
                  name="newPassword"
                  value={passwordForm.newPassword}
                  onChange={handlePasswordChange}
                  placeholder="새 비밀번호 입력"
                />
              </label>

              <label className={styles.field}>
                <span className={styles.fieldLabel}>전화번호</span>
                <input
                  className={styles.control}
                  name="phone"
                  value={form.phone}
                  onChange={handleFieldChange}
                  onCompositionStart={handleCompositionStart}
                  onCompositionEnd={handleCompositionEnd}
                />
              </label>

              <label className={styles.field}>
                <span className={styles.fieldLabel}>생년월일</span>
                <input
                  className={styles.control}
                  name="birthday"
                  value={form.birthday}
                  onChange={handleFieldChange}
                  onCompositionStart={handleCompositionStart}
                  onCompositionEnd={handleCompositionEnd}
                  placeholder="YYYY-MM-DD"
                />
              </label>
            </div>

            <div className={`${styles.field} ${styles.sectionBlock}`}>
              <span className={styles.fieldLabel}>주소</span>
              <AddressSearch
                zipcode={form.zipcode}
                addr1={form.addr1}
                addr2={form.addr2}
                onAddressChange={(nextValue) => setForm((prev) => ({ ...prev, ...nextValue }))}
                variant="inline"
              />
            </div>

            {!roleConfig.isStudent && (
              <div className={styles.eduCareerSection}>
                <label className={styles.textareaField}>
                  <span className={styles.fieldLabel}>학력사항</span>
                  <textarea className={styles.textarea} name="eduLevel" value={eduCareerForm.eduLevel} onChange={(e) => setEduCareerForm((prev) => ({ ...prev, eduLevel: e.target.value }))} rows={5} />
                </label>
                <label className={styles.textareaField}>
                  <span className={styles.fieldLabel}>경력사항</span>
                  <textarea className={styles.textarea} name="career" value={eduCareerForm.career} onChange={(e) => setEduCareerForm((prev) => ({ ...prev, career: e.target.value }))} rows={5} />
                </label>
              </div>
            )}

            <div className={styles.saveRow}>
              <button type="button" className={styles.primaryButton} disabled={savingPage} onClick={handlePageSave}>
                {savingPage ? "저장 중..." : "저장"}
              </button>
            </div>
          </section>
        )}

        <input
          ref={profileInputRef}
          type="file"
          accept="image/*"
          className={styles.hiddenInput}
          onChange={(event) => setProfileFile(event.target.files?.[0] ?? null)}
        />
        <input ref={resumeInputRef} type="file" accept=".pdf,.doc,.docx" className={styles.hiddenInput} onChange={(event) => setResumeFile(event.target.files?.[0] ?? null)} />
      </section>
    </div>
  );
}

export default UserInfoPage;
