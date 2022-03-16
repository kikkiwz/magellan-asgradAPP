*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
*** Test Cases ***

AsgardHTTPeSimRegister_TST_F4_1_1_001_Success
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
	${IMEI}=    Set Variable    ${createResponse}[4]
	${AccountId}=    Set Variable    ${createResponse}[5]
	#Create Control
	${random_Sensor}=    Evaluate    random.randint(100, 999)    random
    ${resultSensorKey}=    Create ControlThing    ${accessToken}    ${ThingId}    ${AccountId}    ${VALUE_SENSORKEY}    ${random_Sensor}
	#=============End Prepare data Report==============
	# Register 
	${authen}=    Set Variable    ${IMSI}:${IPAddress}
	${res}=    AsgardHTTPRegister    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_20000}
	${ThingToken}=    Get From Dictionary    ${res}[0]     ${FIELD_THINGTOKEN}  
	# Config 
	${authen}=    Set Variable    ${ThingToken}:${IPAddress}
	${res_delta}=    AsgardHTTPDelta    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_20000}
	# Check log detail and summary 
	${orderRef}=    Set Variable    ${res_delta}[1]
	${identity}=    Set Variable    {"Imei":"${IMEI}","ThingId":"${ThingID}","Imsi":"${IMSI}"}		 
	${custom}=    Set Variable    {"Imsi":["${IMSI}"],"url":"${HOST}${URL_AsgardHTTPDelta}","Imei":["${IMEI}"],"ThingID":["${ThingID}"]}
	${body}=    Set Variable    {"${VALUE_SENSORKEY}":"${random_Sensor}"}
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS}    ${ENDPOINTNAME_ACCOUNT}    ${ENDPOINTNAME_THINGS} 
	Log HTTP Delta    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${orderRef}    ${ThingToken}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}    
	# Verify DB 
	${result}=    Search Some Record    mgcore    things    {"${FIELD_THINGSECRET}" : "${IMSI}"}
	Log    ${result}
	${StateInfo}=    Get From Dictionary    ${result}     ${FIELD_STATEINFO}
	${Delta_DB}=    Get From Dictionary    ${StateInfo}     Delta	
	${SensorValueDB}=    Get From Dictionary    ${Delta_DB}     ${VALUE_SENSORKEY}
	${sensorKey}=    Convert To String    ${random_Sensor} 	
	Should Be Equal    ${SensorValueDB}    ${sensorKey}
    [Teardown]    Generic Test Case Teardown    Delta    ${createResponse}    ${EMPTY} 


