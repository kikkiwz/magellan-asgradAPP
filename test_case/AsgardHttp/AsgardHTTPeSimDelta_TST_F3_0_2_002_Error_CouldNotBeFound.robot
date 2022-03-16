*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
*** Test Cases ***

AsgardHTTPeSimDelta_TST_F3_0_2_002_Error_CouldNotBeFound
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : Create ThingStateInfo
    ...    8.MGCore : Create ControlThing
    ...    9.MGCore : AsgardHTTPeSimRegister
    ...    10.MGCore : AsgardHTTPeSimConfig
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
	Log To Console    createResponse${createResponse}
	Log To Console    ThingID${ThingID}
	#Create Control
	${random_Sensor}=    Evaluate    random.randint(100, 999)    random
    ${resultSensorKey}=    Create ControlThing    ${accessToken}    ${ThingId}    ${AccountId}    ${VALUE_SENSORKEY}    ${random_Sensor}
	Log To Console    ${resultSensorKey}${${resultSensorKey}}
	${valueKey}=    Set Variable    {"${VALUE_SENSORKEY}":"${random_Sensor}"}
	Log To Console    valueKey${valueKey}
	#=============End Prepare data Report==============
	# Register 
	${authen}=    Set Variable    ${IMSI}:${IPAddress}
	${res}=    AsgardHTTPRegister    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_20000}
	${ThingToken}=    Get From Dictionary    ${res}[0]     ${FIELD_THINGTOKEN}  
	# Config 
	${authen}=    Set Variable    ${ThingToken}${random_Sensor}:${IPAddress}
	${res_delta}=    AsgardHTTPDelta    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_40400}
	# Check log detail and summary 
	${orderRef}=    Set Variable    ${res_delta}[1]
	${identity}=    Set Variable    ${EMPTY}		 
	${custom}=    Set Variable    ${NULL} 	 
	${body}=    Set Variable    ${EMPTY}
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS} 
	Log HTTP Delta    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${orderRef}    ${ThingToken}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}    
    [Teardown]    Generic Test Case Teardown    Delta    ${createResponse}    ${EMPTY} 


