*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
#Suite Setup    Connect To Mongodb    mongodb://admin:ais.co.th@52.163.210.190:27018/mgcore?authSource=admin
*** Test Cases ***
################### Post ###################

AsgardMQTTRegister_TST_F1_1_1_001_Success
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : Create ThingStateInfo
    ...    8.MGCore : AsgardMQTT Register
    ...    9.MGCore & Centric : Remove Thing
    ...    10.MGCore : Remove Account
    ...    11.MGCore : Remove Partner
    Connect To Mongodb    ${CONNECT_MONGODB}
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	#${ThingToken}=    Set Variable    ${createResponse}[2]
	${ThingID_MGCORE}=    Set Variable    ${createResponse}[3]
	${IMEI}=    Set Variable    ${createResponse}[4]
	${AccountId}=    Set Variable    ${createResponse}[5]
	${PartnerId}=    Set Variable    ${createResponse}[6]
	#=============End Prepare data Report==============
	# Register Success
	${ThingToken_MQTT}=    MQTTRegister    ${IMSI}
	# Check log detail and summary 
	Log MQTT Register    ${ThingID_MGCORE}    ${IMSI}    ${IMEI}
	# Verify DB   
    ${Result_ThingToken_DB}=    Search By Select Fields    ${MGCORE_DBNAME}    ${MGCORE_COLLECTION_THING}    {"${FIELD_THINGTOKEN}" : "${ThingToken_MQTT}"}    ${FIELD_THINGTOKEN}
	${ThingToken_DB}=    Get From Dictionary    ${Result_ThingToken_DB}     ${FIELD_THINGTOKEN}
	Should Be Equal    ${ThingToken_MQTT}    ${ThingToken_DB}
	Disconnect From Mongodb
	[Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}


