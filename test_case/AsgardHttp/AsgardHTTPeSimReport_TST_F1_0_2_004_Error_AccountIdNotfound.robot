*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
*** Test Cases ***

AsgardHTTPeSimReport_TST_F1_0_2_004_Error_AccountIdNotfound
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : Create ThingStateInfo
    ...    8.MGCore : AsgardHTTPeSimRegister
    ...    9.MGCore : Remove AccountName
    ...    10.MGCore : AsgardHTTPeSimReport
    ...    11.MGCore & Centric : Remove Thing
    ...    12.MGCore : Remove Account
    ...    13.MGCore : Remove Partner
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${AccountId}=    Set Variable    ${createResponse}[5]
	${PartnerId}=    Set Variable    ${createResponse}[6]
	${Sensor_Value}=    Set Variable    ${createResponse}[9]	
	${random_num}=    Evaluate    random.randint(100, 999)    random
	${Sensor_Key_Report}=    Set Variable    AA
	${Sensor_Value_Report}=    Set Variable    PM.${random_num}
	${Timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	#=============End Prepare data Report==============
	# Register 
	${authen}=    Set Variable    ${IMSI}:${IPAddress}
	${res}=    AsgardHTTPRegister    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_20000}
	${ThingToken}=    Get From Dictionary    ${res}[0]     ${FIELD_THINGTOKEN}  
	# Report 
	Remove AccountName    ${accessToken}    ${PartnerId}    ${AccountId}
	${authen}=    Set Variable    ${ThingToken}${random_num}:${IPAddress}
	${res_report}=    AsgardHTTPReport    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_40400}   ${Sensor_Key_Report}    ${Sensor_Value_Report}    ${Timestamp}  
	# Check log detail and summary 
	${identity}=    Set Variable    ${EMPTY}		 
	# ${custom}=    Set Variable    {"Imsi":["${IMSI}"],"url":"${HOST}${URL_AsgardHTTPRegister}","Imei":["${authen}"],"ThingId":["${ThingID}"]} 
	${custom}=    Set Variable    ${NULL} 	 
	${body}=    Set Variable    {"${Sensor_Key_Report}":"${Sensor_Value_Report}","Timestamp":"${Timestamp}"}
	${orderRef}=    Set Variable    ${res_report}[1]
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS} 
	Log HTTP Report    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${orderRef}    ${ThingToken}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}
	[Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}


