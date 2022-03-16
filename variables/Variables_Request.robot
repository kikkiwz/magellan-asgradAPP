*** Variables ***
${timeout}    0.5 second
${delay}    0.3
${BROWSER}    chrome

#header
${HEADER_CONTENT_TYPE}    application/json
${HEADER_ACCEPT}    */* 
${HEADER_X_AIS_USERNAME_AISPARTNER}    AisPartner
${HEADER_AUTHENTICATION}    Basic ZWxhc3RpYzpSM2RoQHQhQCM=

#NAME_SESSION
${NAME_SESSION_GET}    GETAPI
${NAME_SESSION_POST}    POSTAPI
${NAME_SESSION_PUT}    PUTAPI
${NAME_SESSION_DELETE}    DELETEAPI

#status code
${STATUS_CODE_SUCCESS}    200
${STATUS_CODE_CREATE}    201

#field resultCode resultDescription 
${VALUE_RESULTCODE_20000}    20000
${VALUE_RESULTCODE_20100}    20100
${VALUE_RESULTCODE_50000}    50000

${FIELD_OPERATIONSTATUS}    OperationStatus
${FIELD_CODE}    Code
${FIELD_DESCRIPTION}    Description
${FIELD_OPERATIONSTATUS_LOWCASE}    operationStatus
${FIELD_CODE_LOWCASE}    code
${FIELD_DESCRIPTION_LOWCASE}    description

#${FIELD_RESULT_CODE}    resultCode
#${FIELD_RESULT_DESCRIPTION}    resultDescription
#${VALUE_RESULTDESCRIPTION_SUCCESS}    Success
#${VALUE_RESULTDESCRIPTION_SYSTEMERROR}    System error


#API test
#${URL_GET_STUDENT}    /api/get-student
#${URL_POST_STUDENT}    /api/create-student

#${STUDENT_ID}    2
#${URL_PUT_STUDENT}    /api/put-student/${STUDENT_ID}
#${URL_GET_STUDENT_ID}    /api/get-student/${STUDENT_ID}







