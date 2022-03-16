*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot


*** Test Cases ***
################### Post ###################
AsgardMQTTDelta_TST_F4_1_1_001_Success
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : Create ThingStateInfo
    ...    8.MGCore : Create Control
    ...    9.MGCore : AsgardMQTT Register
    ...    10.MGCore : AsgardMQTT Delta
    ...    11.MGCore : Remove ConfigGroup
    ...    12.MGCore & Centric : Remove Thing
    ...    13.MGCore : Remove Account
    ...    14.MGCore : Remove Partner
    Connect To Mongodb    ${CONNECT_MONGODB}
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingToken_Provisioning}=    Set Variable    ${createResponse}[2]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${IMEI}=    Set Variable    ${createResponse}[4]
	${AccountId}=    Set Variable    ${createResponse}[5]
	#Create Control
	${random_Sensor}=    Evaluate    random.randint(100, 999)    random
    ${resultSensorKey}=    Create ControlThing    ${accessToken}    ${ThingId}    ${AccountId}    ${VALUE_SENSORKEY}    ${random_Sensor}
	${valueKey}=    Set Variable    {"${VALUE_SENSORKEY}":""}
	#=============End Prepare data Report==============
	# Report Success
	${ThingToken_MQTT}=    MQTTDelta    ${IMSI}    ${VALUE_SENSORKEY}    1
	# Check log detail and summary   
	Log MQTT Delta    ${VALUE_SENSORKEY}    ${ThingToken_MQTT}    ${valueKey}    ${IMSI}  
	# Inquiry For Verify DB   
	${result}=    Search Some Record    mgcore    things    {"ThingToken" : "${ThingToken_MQTT}"}
	Log    ${result}
	${StateInfo}=    Get From Dictionary    ${result}     ${FIELD_STATEINFO}
	${Delta_DB}=    Get From Dictionary    ${StateInfo}     Delta	
	${SensorValueDB}=    Get From Dictionary    ${Delta_DB}     ${VALUE_SENSORKEY}
	${sensorKey}=    Convert To String    ${random_Sensor} 	
	Should Be Equal    ${SensorValueDB}    ${sensorKey}
    [Teardown]    Generic Test Case Teardown    Delta    ${createResponse}    ${EMPTY}    



	





