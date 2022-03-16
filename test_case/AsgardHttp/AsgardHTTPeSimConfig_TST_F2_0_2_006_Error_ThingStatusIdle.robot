*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
*** Test Cases ***

AsgardHTTPeSimConfig_TST_F2_0_2_006_Error_ThingStatusIdle
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : Create ThingStateInfo
    ...    8.MGCore : Create ConfigGroup
    ...    9.MGCore : AsgardHTTPeSimRegister
    ...    10.MGCore : Remove ThingFromAccount
    ...    11.MGCore : AsgardHTTPeSimConfig
    ...    12.MGCore : Remove ConfigGroup
    ...    13.MGCore & Centric : Remove Thing
    ...    14.MGCore : Remove Account
    ...    15.MGCore : Remove Partner
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${AccountId}=    Set Variable    ${createResponse}[5]
	${PartnerId}=    Set Variable    ${createResponse}[6]
	#Create ConfigGroup
    ${resultCreateConfigGroup}=    CreateConfigGroup    ${accessToken}    ${ThingID}    ${AccountId}
	${groupId}=    Set Variable    ${resultCreateConfigGroup}[0]
	${groupName}=    Set Variable    ${resultCreateConfigGroup}[1]
	#=============End Prepare data Report==============
	# Register 
	${authen}=    Set Variable    ${IMSI}:${IPAddress}
	${res}=    AsgardHTTPRegister    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_20000}
	${ThingToken}=    Get From Dictionary    ${res}[0]     ${FIELD_THINGTOKEN}  
	# Config 
    Remove ThingFromAccount    ${accessToken}    ${AccountId}    ${ThingId}
	${authen}=    Set Variable    ${ThingToken}:${IPAddress}
	${res_config}=    AsgardHTTPConfig    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_40400}    ${VALUE_CONFIGINFO_KEY_REFRESHTIME}
	# Check log detail and summary 
	${identity}=    Set Variable    ${EMPTY}		 
	${custom}=    Set Variable    ${NULL}  	 
	${body}=    Set Variable    ${EMPTY}
	${orderRef}=    Set Variable    ${res_config}[1]
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS}
	Log HTTP Config    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${orderRef}    ${ThingToken}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}        
	[Teardown]    Generic Test Case Teardown    Config    ${createResponse}    ${groupId}


