*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
AsgardMQTTReport_TST_F2_1_1_001_Success
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : Create ThingStateInfo
    ...    8.MGCore : AsgardMQTT Register
    ...    9.MGCore : AsgardMQTT Report
    ...    10.MGCore & Centric : Remove Thing
    ...    11.MGCore : Remove Account
    ...    12.MGCore : Remove Partner
    Connect To Mongodb    ${CONNECT_MONGODB}
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingToken_Provisioning}=    Set Variable    ${createResponse}[2]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${IMEI}=    Set Variable    ${createResponse}[4]
	${randomSensorApp}=    Evaluate    random.randint(100, 999)    random
	${sensorKey}=    Set Variable    TestAutomate 
	${sensorValue}=    Set Variable    Pm1.2${randomSensorApp}  
	${valueKey}=    Set Variable    {"${sensorKey}":"${sensorValue}"}
	#=============End Prepare data Report==============
	# Report Success
	${ThingToken_MQTT}=    MQTTReport    ${IMSI}    ${valueKey}  
	# Check log detail and summary
	Log MQTT Report    ${sensorKey}    ${ThingToken_MQTT}    ${valueKey}
	# Inquiry For Verify DB   
	${result}=    Search Some Record    mgcore    things    {"${FIELD_THINGTOKEN}" : "${ThingToken_MQTT}"}
	Log    ${result}
	${ThingToken_DB}=    Get From Dictionary    ${result}     ${FIELD_THINGTOKEN}
	${StateInfo}=    Get From Dictionary    ${result}     ${FIELD_STATEINFO}
	Log    ${StateInfo}
	${StateInfo_Report}=    Get From Dictionary    ${StateInfo}     ${FIELD_STATEINFO_REPORT}
	Log    ${StateInfo_Report}	
	${valueKey_Report}=    Get From Dictionary    ${StateInfo_Report}     ${sensorKey}
	Log    ${valueKey_Report}		
	Should Be Equal    ${sensorValue}    ${valueKey_Report}
    [Teardown]    Generic Test Case Teardown    Report    ${createResponse}    ${EMPTY}     

