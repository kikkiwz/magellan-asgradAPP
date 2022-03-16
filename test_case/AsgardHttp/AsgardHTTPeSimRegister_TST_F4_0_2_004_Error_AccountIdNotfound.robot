*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
*** Test Cases ***

AsgardHTTPeSimRegister_TST_F4_0_2_004_Error_AccountIdNotfound
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : Remove Account
    ...    8.MGCore : AsgardHTTPeSimRegister
    ...    9.MGCore & Centric : Remove Thing
    ...    10.MGCore : Remove Partner
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${IMEI}=    Set Variable    ${createResponse}[4]
	${AccountId}=    Set Variable    ${createResponse}[5]
	${PartnerId}=    Set Variable    ${createResponse}[6]
    Remove AccountName    ${accessToken}    ${PartnerId}    ${AccountId}
	#=============End Prepare data Report==============
	# Register 
	${authen}=    Set Variable    ${IMSI}:${IPAddress}
	${res}=    AsgardHTTPRegister    ${authen}     ${OPERATION_STATUS_AsgardHTTPRegister_40400}
	# Check log detail and summary 
	${identity}=    Set Variable    {"Imei":"${IMEI}","ThingId":"${ThingID}","Imsi":"${IMSI}"}		 
	${custom}=    Set Variable    {"Imsi":["${IMSI}"],"url":"${HOST}${URL_AsgardHTTPRegister}","Imei":["${IMEI}"],"ThingId":["${ThingID}"]}  	 
	${body}=    Set Variable    ""
	${orderRef}=    Set Variable    ${res}[1]
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_ACCOUNT}    ${ENDPOINTNAME_THINGS} 
	Log HTTP Register    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${orderRef}    ${IMSI}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}   
	[Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}


