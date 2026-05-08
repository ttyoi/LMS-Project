let isPasswordSamechecked=false;

/**
 * 강사 등록
 */
function registerInstructor(){

    $.ajax({
        url:"/inst/registerid",
        type:"GET",
        success : function(data){
            $("#t_id").val(data);
        },
        error : function(xhr, status, error){
            console.log("에러발생!!!", error);
        }
    });//end ajax
    //만든 random id를 넣어주기
    $("#teacherModal").show();
}//end registerInstructor

/**
 * 강사 등록 모달 닫기
 */
function closeTeacherModal(){
    $("#teacherModal").hide();
}//end closeTeacherModal


/**
 * 전체 이메일 형식 확인 및 alert
 * @param email
 */
function checkFullInstructorEmail(){
    const $email=$("#t_email");
    const emailReg = /^[A-Za-z0-9]+@[A-Za-z0-9]+\.[A-Za-z]{2,}$/;
    if(emailReg.test($email.val())){
        //이메일 형식이 맞음
    }else{
        $email.val("");
        alert("알맞은 이메일 형식이 아닙니다.\n다시 확인해주세요.");
    }//end if~else
}//end checkFullInstructorEmail

/**
 * 강사 등록을 위해, 메일 보내기
 */
function clickRegisterInstructor(){
    $("#loading").show();

    $.ajax({
        url:"/inst/registerInstructor",
        type:"POST",
        data : {
            id : $("#t_id").val(),
            email : $("#t_email").val()
        },
        dataType:"text",
        success : function(data){
            $("#loading").hide();
            $("#t_email").val("");
            setTimeout(function(){
                alert(data);
                closeTeacherModal();
            },0)
        },
        error : function(xhr, status, error){
            $("#loading").hide();

            setTimeout(function(){
                console.log("에러발생!!"+error);
            },0);
        }
    });//end ajax
}//end clickRegisterInstructor

/**
 * 해당 id를 가진 태그들의 value 값이 비어있는지 check
 * @returns {boolean}
 */
function instructorValidateRequiredField(){
    const fields=["id","name", "password", "chkpassword","birth1", "birth2"];

    for(const str of fields){
        const value = $("#"+str).val().trim();
        if(value === ""){
            return false;
        }//end if
    }//end for
    return true;
}//end instructorValidateRequiredField


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






