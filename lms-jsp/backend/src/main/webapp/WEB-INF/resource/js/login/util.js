/**
 * 영어, 숫자만 사용 가능
 * @param input
 * @param errorID 해당 문자열을 넣을 DOM id
 */
function onlyEngANum(input){
    const invalue = input.value;
    const idRegex=/[^a-zA-Z0-9]/g; //영어 + 숫자가 아닌 문자

    if(idRegex.test(invalue)){
        input.value = input.value.replaceAll(idRegex,"");
        return false;
    }else{
        return true;
    }//end if~else
}//end onlyEngANum

/**
 * 숫자만 사용 가능
 * @param input
 * @param errorID 해당 문자열을 넣을 DOM id
 */
function onlyNumber(input, errorID){
    let reg = /[^0-9]/g;

    //만약 숫자가 아니면, 아래쪽에 숫자 아니라고 경고문구 뜨게끔.
    if(reg.test(input.value)){
        $("#"+errorID).show();
        input.value=input.value.replaceAll(reg, "");
        return false;
    }else{
        $("#"+errorID).hide();
        return true;
    }//end if~else

}//end onlyNumber


/**
 * 해당 form에 있는 글자가 30byte를 넘지 않도록 제한.
 * @param input
 * @param errorID 해당 문자열을 넣을 DOM id
 */
function checkLimitLetterCnt(input, errorID){

    if(input.value.length > 30){
        $("#"+errorID).text("30글자 이내로 작성해주세요.").css("color","red");
        input.value = input.value.substring(0,30);
        return false;
    }else{
        $("#"+errorID).text("");
        return true;
    }
}//end checkLimitLetterNumber


/**
 * 영어, 한글만 가능
 * @param input
 * @param errorID
 */
function checkSpecialChar(input, errorID){
    const reg=/[^ㅏ-ㅣa-zA-Z가-힣ㄱ-ㅎ]/g;

    if(reg.test(input.value)){
        $("#"+errorID).text("영어, 한글만 사용할 수 있습니다.").css("color","red");
        input.value = input.value.replaceAll(reg, "");
        return false;
    }//end if

    return true;
}//end chechSpecialChar


/**
 * 이메일 부분에 입력할 수 있는건, 영문자 숫자만.
 * 도메인은 따로 받음.
 * @param input
 */
function checkEmail(input){
    if(!onlyEngANum(input)){
        alert("영문자, 숫자만 사용 가능합니다.");
    }//end if
}//end checkEmail

/**
 * 이메일 도메인이 형식에 맞는지 체크
 * @param input
 */
function checkEmailDomain(input){
    const reg = /^[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$/;

    if($(input).val().trim()!=="" && !reg.test(input.value)){
        alert("맞는 이메일 도메인 형식이 아닙니다.");
        $(input).val("");
    }//end if

}//end checkEmailDoamin


/**
 * 생년월일이 맞는 범위인지 확인
 * @param input
 */
function checkBirthDay(input){
    const birthNum = input.value;
    let retStatus=true;
    let regx = /^[0-9]{8}$/;

    if(birthNum === "") return true;

    const year = parseInt(birthNum.substring(0,4));
    const month = parseInt(birthNum.substring(4,6));
    const day=parseInt(birthNum.substring(6,8));

    //8개 숫자이어야 함.
    if(!regx.test(birthNum)) retStatus = false;

    //년도 제한 : 1900 ~ 현재년도
    const currentYear = new Date().getFullYear();
    if(year < 1800 || year > currentYear) retStatus=false;

    //월
    if(month<1 || month>12) retStatus=false;

    //일
    const lastDay = new Date(year, month, 0).getDate(); //달의 마지막일
    if(day<1 || day>lastDay) retStatus=false;

    if(retStatus === false ){
        alert("날짜 범위가 이상한 생년월일입니다.");
        $(input).val("");
        $(input).focus();
        return false;
    }//end if

    return true;
}//end checkBirthDay


/**
 * 전체 이메일 도메인 형식 맞는지 확인
 * @param email
 */
function checkFullEmail(email){
    const emailReg = /^[A-Za-z0-9]+@[A-Za-z0-9]+\.[A-Za-z]{2,}$/;

    if(emailReg.test(email)){
        //이메일 형식에 맞음.
        return true;
    }else{
        return false;
    }//end if~else
}//end checkFullEmail


/**
 * 이름 부분, 30바이트 제한, 특수문자
 * @param input
 * @param errorID
 */
function checkNameForm(input, errorID){
    if(!checkSpecialChar(input,errorID)) return;
    checkLimitLetterCnt(input, errorID);
}//end checkNameForm



/**
 * 상세주소 쓸 수 있는 글자 필터링
 * @param input
 * @returns {boolean}
 */
function checkAddr2(input){
    const reg=/[^ㅏ-ㅣ0-9a-zA-Z가-힣()\-\sㄱ-ㅎ]/g;

    if(reg.test(input.value)){
        input.value = input.value.replaceAll(reg,"");
        alert("(), -, 한글, 영어, 숫자 외에는 쓸 수 없습니다.");
        return false;
    }//end if
}//end onlyHanEngNum

/**
 * 이메일의 도메인
 */
function changeEmailDomain(){
    const $emailDomain = $("#emailDomain");
    const $emailSelect = $("#emailSelect");

    if($emailSelect.val() !== ''){
        $emailDomain.val($emailSelect.val());
        $emailDomain.prop("readonly",true);
    }else{
        $emailDomain.prop("readonly",false);
        $emailDomain.val("");
    }//end if~else
}//end changeEmailDomain

/**
 * 비밀번호 일치하는지 체크
 * @param pass1
 * @param pass2
 * @returns {boolean}
 */
function chkPasswordUtil(pass1, pass2){
    return pass1=== pass2;
}//end checkPassword


