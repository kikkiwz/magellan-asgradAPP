*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
*** Test Cases ***

AsgardHTTPeSimRegister_TST_F4_0_2_006_Error_ThingStatusIdle
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : Remove ThingFromAccount
    ...    8.MGCore : AsgardHTTPeSimRegister
    ...    9.MGCore & Centric : Remove Thing
    ...    10.MGCore : Remove Account
    ...    11.MGCore : Remove Partner
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${IMEI}=    Set Variable    ${createResponse}[4]
	${AccountId}=    Set Variable    ${createResponse}[5]
    Remove ThingFromAccount    ${accessToken}    ${AccountId}    ${ThingId} 
	#=============End Prepare data Report==============
	# Register 
	${authen}=    Set Variable    ${IMSI}:${IPAddress}
	${res}=    AsgardHTTPRegister    ${authen}     ${OPERATION_STATUS_AsgardHTTPRegister_40400}
	# Check log detail and summary 
	${identity}=    Set Variable    {"Imei":null,"ThingId":null,"Imsi":"${IMSI}"}		 
	${custom}=    Set Variable    {"Imsi":["${IMSI}"],"url":"${HOST}${URL_AsgardHTTPRegister}","Imei":null,"ThingId":null}   	 
	${body}=    Set Variable    ""
	${orderRef}=    Set Variable    ${res}[1]
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS}
	Log HTTP Register    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${orderRef}    ${IMSI}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}   
	[Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}

