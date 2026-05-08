let isIDDuplicatedchecked = false;
let isPasswordSamechecked = false;
let isEmailDuplicatedchecked = false;


$(function(){

    /* 입력 창에서 blur 일 때, 이메일 중복 확인  */
    $("#emailFront,#emailDomain").on("blur",triggerEmailDuplicateCheck);

    /* selectbox 변경시마다, 이메일 중복 확인 */
    $("#emailSelect").on("change",triggerEmailDuplicateCheck);



    /**
     * 가입하기 버튼 눌렀을 때.
     * Form 제출
     */
    $("#joinForm").on("submit",function(event) {

        //아이디, 이름 비밀번호, 생년월일, 이메일, 약관 동의 얘네는 비어있으면 안됨.
        //여기서 이메일 중복 여부 체크
        if(!isEmailDuplicatedchecked){
            alert("이메일이 사용가능한지 확인해주세요.");
            event.preventDefault();
            return false;
        } else if (!isIDDuplicatedchecked) {
            alert("아이디 중복 확인해주세요.");
            event.preventDefault();
            return false;
        } else if (!isPasswordSamechecked) {
            alert("비밀번호가 일치하지 않습니다.");
            event.preventDefault();
            return false;
        } else if (!validateRequiredFields()) {
            alert("필수 입력값들을 입력해주세요.");
            event.preventDefault();
            return false;
        } else if (!$("#termsChk").is(":checked") || !$("#termsChk2").is(":checked")) {
            alert("필수 약관을 모두 동의해주세요.");
            event.preventDefault();
            return false;
        }else{
            return true;
        }//end if~else

    });//end onSubmit

});//onLoad








/* -------------------------------------------------------------------------- */

/**
 * 이메일 중복 체크
 */
function triggerEmailDuplicateCheck(){
    const email=$("#emailFront").val() + "@" + $("#emailDomain").val();

    if(checkFullEmail(email)) checkDuplicateEmail();
}//end triggerEmailDuplicateCheck


/**
 * ID Form 검사
 * @param input
 * @param errorID 해당 문자열을 넣을 DOM id
 */
function checkID(input, errorID=null){
    const isValid = onlyEngANum(input);

    if(!isValid){
        if(errorID === null){
            alert("아이디는 영문과 숫자만 사용할 수 있습니다.");
        }else{
            $("#"+errorID).text("아이디는 영문과 숫자만 사용할 수 있습니다.").css("color","red");
        }//end if~else
        return;
    }//end if

    //정상일 경우
    if(errorID !== null){
        $("#"+errorID).text("");
        checkLimitLetterCnt(input, errorID); //30글자 이내
    }//end if
    
}//end checkID


/**
 * 아이디 중복 확인
 * @param ctx ${pageContext.request.contextPath}
 * @param id id 값
 */
function checkDuplicateID(ctx,id){
    if(!id || id.trim() ===""){
        $("#resultIDStr").text("아이디를 입력해주세요.").css("color","red");
        return;
    }//end if

    $.ajax({
        url : ctx+"/join/checkDuplicateID",
        type: "POST",
        data : {loginID : id},
        success : function(data){
            if(data > 0){
                $("#resultIDStr").text("이미 사용 중인 아이디 입니다.").css("color","red");
                isIDDuplicatedchecked=false;
            }else{
                $("#resultIDStr").text("사용 가능한 아이디 입니다.").css("color","green");
                isIDDuplicatedchecked=true;
            }//end if~else

        },
        error : function(xhr,status, error){
            console.log("에러 발생!!" + error);
        }
    });
}//end checkDuplicateID

/**
 * 이메일 중복 확인
 */
function checkDuplicateEmail(){
    $.ajax({
        url:"/join/checkDuplicateEmail",
        type : "POST",
        data : {email : $("#emailFront").val() + "@"+$("#emailDomain").val()},
        success : function(data){
            if(data !== 0){
                //이미 존재하는 이메일
                $("#emailStr").text("이미 가입된 이메일입니다.").css("color","red");
                isEmailDuplicatedchecked=false;
            }else{
                $("#emailStr").text("사용 가능한 이메일입니다.").css("color","green");
                isEmailDuplicatedchecked=true;
            }//end if~else
        },
        error : function(xhr, status, error){
            console.log("에러발생!!!!---",error);
        }
    });//end ajax
}//end checkDuplicateEmail


/**
 * 약관 클릭했을 시, modal 띄우기
 */
$(document).on("click",".terms-row",function(event){
    event.preventDefault();
    //console.log("checkbox1::::::"+$("#termsChk").is(":checked")+"-----"+"checkbox2::::::"+$("#termsChk2").is(":checked"));

    //클릭된 .terms-row 안에 있는 체크박스 찾기
    let $checkbox = $(this).find("input[type='checkbox']");
    let checkboxID = $checkbox.attr("id");

    //모달에 현재 열린 체크박스 아이디 저장
    $("#termsModal").data("checkboxID", checkboxID);

    if(!$checkbox.is(":checked")){
        //약관 불러오기
        $.ajax({
            url:"/join/getUserPolicy",
            data : {checkboxID : checkboxID},
            type:"POST",
            success : function(data){
                $("#terms-title").text(data.title);
                $("#user-terms-text").text(data.content);
            },
            error : function(xhr, status, error){
                console.log("에러발생!!"+error);
            }
        });//end ajax
        $("#termsModal").show();
    }else{
        //체크 해제
        $checkbox.prop("checked",false);

    }//if~else

});//end onclick

/**
 * 약관 동의
 */
function agreeTerms(){
    let checkboxID = $("#termsModal").data("checkboxID");
    let $checkbox=$("#"+checkboxID);

    $checkbox.prop("checked",true);

    $("#termsModal").hide();
}//end agreeTerms

/**
 * 약관 닫기
 */
function closeTermsModal(){
    $("#termsModal").hide();
}//end closeTermsModal


/**
 * 해당 id를 가진 태그들의 value 값이 비어있는 값인지 체크
 * @returns {boolean}
 */
function validateRequiredFields(){
    const fields=["id","name", "password", "chkpassword","birth1", "birth2", "emailFront", "emailDomain"];

    for(const str of fields){
        const value = $("#"+str).val().trim();
        if(value === ""){
            return false;
        }//end if
    }//end for
    return true;
}//end validateRequiredFields


/**
 * 아이디 찾기
 * @param idStr dom ID string
 */
function findID(idStr){
    const email = $("#"+idStr).val();
    if(!checkFullEmail(email)){
        //이메일 형식에 맞지 않음.
        alert("올바른 이메일 형태가 아닙니다.\n이메일을 다시 확인해 주세요.");
    }else{
        $.ajax({
            url : "/findID",
            method : "POST",
            data : {email : email},
            dataType:"text",
            success : function(data){
                alert(data);
            },
            error : function(xhr, status, error){
                console.log("에러발생!!!---",error);
            }
        });//end ajax
    }//end if~else

}//end findID

/**
 * 비밀번호 찾기
 * @param idStr
 * @param emailStr
 */
function findPassword(idStr, emailStr){
    const $id = $("#"+idStr);
    const email = $("#"+emailStr).val();
    if(!checkFullEmail(email)){
        alert("올바른 이메일 형태가 아닙니다.\n이메일을 다시 확인해 주세요.");
    }else{
        $.ajax({
            url:"/searchPassword",
            type : "POST",
            data : {
                id : $id.val(),
                email: email
            },
            beforeSend: function(){
                //로딩표시 ON
                $("#loading").show();
            },
            success : function(data){
                $("#loading").hide();
                alert(data);
                if(data.includes("이메일을 확인해주세요.")){
                    location.replace("/login.do");
                }//end if
            },
            error : function(xhr, status, error){
                $("#loading").hide();
                console.log("에러 발생!!!! ===",error);
            },
        });//end ajax
    }//end if~else
}//end findPassword

/**
 * 비밀번호가 같은지 체크
 * @param pass1inputID
 * @param input
 * @param errorID
 */
function checkPassword(pass1inputID, input,errorID){
    const pass1val=$("#"+pass1inputID).val();

    if(input.value === ''){
        $("#"+errorID).text("");
        return;
    }//end if

    isPasswordSamechecked = chkPasswordUtil(pass1val,input.value);

    $("#"+errorID).text(isPasswordSamechecked ? "비밀번호가 일치합니다." : "비밀번호가 다릅니다.")
        .css("color",isPasswordSamechecked?"green":"red");

}//end checkPassword


/**
 * 아이디, 비밀번호 찾기 일 때, ....
 * @param input
 * @returns {boolean}
 */
function onlyEngANumForFindId(input){
    const invalue = input.value;
    let idRegex= idRegex = /[^a-zA-Z0-9]/g;

    if(invalue.includes("happyjob")){
        idRegex = /[^a-zA-Z0-9_]/g;
    }//end if


    if(idRegex.test(value)){
        input.value = value.replaceAll(idRegex,"");
        return false;
    }//end if

    return true;
}//end onlyEngANumForFindId

/**
 * [아이디/비밀번호찾기]
 * 아이디 비밀번호 찾기
 * @param input
 * @param errorID
 */
function checkFindIDAPW(input, errorID=null){
    const isValid = onlyEngANumForFindId(input);

    if(!isValid){
        if(errorID === null){
            alert("아이디는 영문과 숫자만 사용할 수 있습니다.");
        }else{
            $("#"+errorID).text("아이디는 영문과 숫자만 사용할 수 있습니다.").css("color","red");
        }//end if~else
        return;
    }//end if

    //정상일 경우
    if(errorID !== null){
        $("#"+errorID).text("");
        checkLimitLetterCnt(input, errorID); //30글자 이내
    }//end if
}

