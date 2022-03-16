*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
*** Test Cases ***

AsgardHTTPeSimReport_TST_F1_0_1_003_Error_ThingTokenUntrustedOrInvalid
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : Create ThingStateInfo
    ...    8.MGCore : AsgardHTTPeSimRegister
    ...    9.MGCore : AsgardHTTPeSimReport
    ...    10.MGCore & Centric : Remove Thing
    ...    11.MGCore : Remove Account
    ...    12.MGCore : Remove Partner
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
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
	${authen}=    Set Variable    ${ThingToken}${random_num}:${IPAddress}
	${res_report}=    AsgardHTTPReportNoauth    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_40103}   ${Sensor_Key_Report}    ${Sensor_Value_Report}    ${Timestamp}  
	# Check log detail and summary 
	${identity}=    Set Variable    ${EMPTY}	 
	${custom}=    Set Variable    ${NULL}	 
	${body}=    Set Variable    {"${Sensor_Key_Report}":"${Sensor_Value_Report}","Timestamp":"${Timestamp}"}
	${orderRef}=    Set Variable    ${res_report}[1]
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS} 
	Log HTTP Report    ${CODE_40103}    ${RESULTDESC_THE_TOKEN_IS_UNTRUSTED_OR_INVALID}    ${orderRef}    ${ThingToken}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}
	[Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}


