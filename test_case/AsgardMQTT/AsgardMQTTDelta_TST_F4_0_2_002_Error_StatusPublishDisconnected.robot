*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
Create Data get
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
	${valueKey}=    Set Variable    {"${ASGARD_MQTT_VALUE_TST_F4_0_2_002_SENSORNAME}":""}
	#=============End Prepare data Report==============
	# Delta Success
	${ThingToken_MQTT}=    MQTTDelta    ${IMSI}    ${ASGARD_MQTT_VALUE_TST_F4_0_2_002_SENSORNAME}    1
	# Check log detail and summary   
	Log MQTT Delta    ${ASGARD_MQTT_VALUE_TST_F4_0_2_002_SENSORNAME}    ${ThingToken_MQTT}    ${valueKey}    ${IMSI}
    [Teardown]    Generic Test Case Teardown    Delta    ${createResponse}    ${EMPTY}  

  
