import { useEffect } from "react";
import styles from "./AddressSearch.module.css";

/**
 * 카카오 우편번호 검색 공용 컴포넌트
 * @param {string} zipcode - 우편번호 상태
 * @param {string} addr1 - 기본주소 상태
 * @param {string} addr2 - 상세주소 상태
 * @param {function} onAddressChange - 주소 변경 시 부모 상태를 업데이트하는 콜백 함수
 * @param {string} variant - 기본(default), 2열 표시용(split), 1줄 표시용(inline)
 */
function AddressSearch({ zipcode, addr1, addr2, onAddressChange, variant = "default" }) {
  // 카카오 우편번호 스크립트 동적 로드
  useEffect(() => {
    const scriptId = "daum-postcode-script";
    if (!document.getElementById(scriptId)) {
      const script = document.createElement("script");
      script.id = scriptId;
      script.src =
        "//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js";
      script.async = true;
      document.body.appendChild(script);
    }
  }, []);

  const handleSearch = () => {
    if (!window.daum) {
      alert("우편번호 서비스를 불러오는 중입니다. 잠시 후 다시 시도해 주세요.");
      return;
    }

    new window.daum.Postcode({
      oncomplete: function (data) {
        // 부모 컴포넌트의 onAddressChange 실행
        onAddressChange({
          zipcode: data.zonecode,
          addr1: data.address,
          addr2: addr2, // 상세주소는 기존 입력값 유지
        });
      },
    }).open();
  };

  const handleDetailChange = (e) => {
    onAddressChange({
      zipcode,
      addr1,
      addr2: e.target.value,
    });
  };

  const readOnlyStyle = {
    backgroundColor: "#f5f5f5", // 연한 회색 배경
    color: "#666", // 글자색 살짝 흐리게
    pointerEvents: "none", // 마우스 클릭, 포커스 등 완벽 차단
  };

  if (variant === "split") {
    return (
      <>
        <div className={styles.splitField}>
          <span className={styles.splitLabel}>주소</span>
          <div className={styles.inputWithBtn}>
            <input
              type="text"
              value={zipcode || ""}
              placeholder="우편번호"
              className={`${styles.input} ${styles.splitInput}`}
              style={{ width: "96px", flex: "none", ...readOnlyStyle }}
              readOnly
              required
            />
            <input
              type="text"
              value={addr1 || ""}
              placeholder="기본 주소"
              className={`${styles.input} ${styles.splitInput}`}
              style={{ ...readOnlyStyle }}
              readOnly
              required
            />
          </div>
        </div>

        <div className={styles.splitField}>
          <span className={`${styles.splitLabel} ${styles.hiddenLabel}`}>상세 주소</span>
          <div className={styles.inputWithBtn}>
            <input
              type="text"
              value={addr2 || ""}
              onChange={handleDetailChange}
              placeholder="상세 주소를 입력하세요"
              className={`${styles.input} ${styles.splitInput}`}
              maxLength={16}
            />
            <button
              type="button"
              className={`${styles.checkBtn} ${styles.splitButton}`}
              onClick={handleSearch}
            >
              주소검색
            </button>
          </div>
        </div>
      </>
    );
  }

  if (variant === "inline") {
    return (
      <div className={styles.inlineContainer}>
        <div className={styles.inputWithBtn}>
          <input
            type="text"
            value={zipcode || ""}
            placeholder="우편번호"
            className={`${styles.input} ${styles.inlineInput}`}
            style={{ width: "96px", flex: "none", ...readOnlyStyle }}
            readOnly
            required
          />
          <input
            type="text"
            value={addr1 || ""}
            placeholder="기본 주소"
            className={`${styles.input} ${styles.inlineInput}`}
            style={{ ...readOnlyStyle }}
            readOnly
            required
          />
          <input
            type="text"
            value={addr2 || ""}
            onChange={handleDetailChange}
            placeholder="상세 주소를 입력하세요"
            className={`${styles.input} ${styles.inlineInput}`}
            maxLength={30}
          />
          <button
            type="button"
            className={`${styles.checkBtn} ${styles.inlineButton}`}
            onClick={handleSearch}
          >
            주소검색
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className={styles.addressContainer}>
      <div className={styles.inputWithBtn}>
        <input
          type="text"
          value={zipcode || ""}
          placeholder="우편번호"
          className={styles.input}
          style={{ width: "90px", flex: "none", ...readOnlyStyle }}
          readOnly
          required
        />
        <input
          type="text"
          value={addr1 || ""}
          placeholder="기본 주소"
          className={styles.input}
          style={{ ...readOnlyStyle }}
          readOnly
          required
        />
      </div>
      <div className={styles.inputWithBtn}>
        <input
          type="text"
          value={addr2 || ""}
          onChange={handleDetailChange}
          placeholder="상세 주소를 입력하세요"
          className={styles.input}
          maxLength={16}
        />
        <button
          type="button"
          className={styles.checkBtn}
          onClick={handleSearch}
        >
          주소검색
        </button>
      </div>
    </div>
  );
}

export default AddressSearch;
