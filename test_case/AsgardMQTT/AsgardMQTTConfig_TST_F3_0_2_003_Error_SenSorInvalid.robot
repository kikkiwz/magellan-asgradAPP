*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
AsgardMQTTConfig_TST_F3_0_2_003_Error_SenSorInvalid
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
	${responseMQTTConfig}=    MQTTConfig    ${IMSI}    ${ASGARD_MQTT_VALUE_TST_F3_0_2_003_URL_SENSORNAME_INVALID}    2
	${ThingToken_MQTTConfig}=    Set Variable    ${responseMQTTConfig}[0]
	# Check log detail and summary
	${identity}=    Set Variable    {"ThingID":"${ThingID}","Imei":"${IMEI}","Imsi":"${IMSI}"}		
	${custom}=    Evaluate    {"customData":{"Imsi":['${IMSI}'],"Imei":['${IMEI}'],"ThingID":['${ThingID}']}}
	${body}=    Evaluate    {"${VALUE_CONFIGINFO_KEY_REFRESHTIME}":"${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}","${VALUE_CONFIGINFO_KEY_MAX}":"${VALUE_CONFIGINFO_KEY_MAX_VALUE}"}	
	Log MQTT Config Error    1    ${CODE_40400}    ${RESULTDESC_DESCRIPTION_ONLINECONFIGSNOTFOUND_ERROR}    ${EMPTY}    ${EMPTY}    ${VALUE_CONFIGINFO_KEY_MAX}    ${ThingToken_MQTTConfig}    ${ASGARD_MQTT_VALUE_TST_F3_0_2_003_URL_SENSORNAME_INVALID}    ${identity}    ${custom}    ${body}
    [Teardown]    Generic Test Case Teardown    Config    ${createResponse}    ${groupId}   



