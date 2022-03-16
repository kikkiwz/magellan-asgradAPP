*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
AsgardMQTTConfig_TST_F3_1_1_001_Success_NotSendFilter
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : Create ThingStateInfo
    ...    8.MGCore : Create ConfigGroup
    ...    9.MGCore : AsgardMQTT Register
    ...    10.MGCore : AsgardMQTT Config
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
	#Create ConfigGroup
    ${resultCreateConfigGroup}=    CreateConfigGroup    ${accessToken}    ${ThingID}    ${AccountId}
	${groupId}=    Set Variable    ${resultCreateConfigGroup}[0]
	${groupName}=    Set Variable    ${resultCreateConfigGroup}[1]
	#=============End Prepare data Report==============
	# Report Success
	${responseMQTTConfig}=    MQTTConfig    ${IMSI}    ${VALUE_CONFIGINFO_KEY_MAX}    1
	${ThingToken_MQTT}=    Set Variable    ${responseMQTTConfig}[0]
	${valueKeyResponse}=    Set Variable    ${responseMQTTConfig}[1]
	# Check log detail and summary
	Log MQTT Config    ${ThingID}    ${ThingToken_MQTT}    ${IMSI}    ${IMEI}    ${EMPTY}    1
	# Inquiry For Verify DB   
	${result}=    Search Some Record    mgcore    onlineconfigs    {"OnlineConfigName" : "${groupName}"}
	Log    ${result}
	${CustomDetails}=    Get From Dictionary    ${result}     ${FIELD_CUSTOMDETAILS}
	${sensorKey_DB}=    Get From Dictionary    ${CustomDetails}     ${VALUE_CONFIGINFO_KEY_MAX}		
	Should Be Equal    ${VALUE_CONFIGINFO_KEY_MAX_VALUE}    ${sensorKey_DB}
    [Teardown]    Generic Test Case Teardown    Config    ${createResponse}    ${groupId}    