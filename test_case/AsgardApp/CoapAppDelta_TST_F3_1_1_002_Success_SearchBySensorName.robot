*** Settings ***
#Documentation     TST_F3_1_1_002
Test Setup    Add Needed Image Path

Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
CoapAppDelta_TST_F3_1_1_002_Success_SearchBySensorName
    [Documentation]    Step is :    
	...    1.Core : Signin
	...    2.Core : Create Partner
	...    3.Core : Create Account
	...    4.Centric : ImportThing
	...    5.Centric : MappingIMEI
	...    6.Core : ActivateThingCore
	...    7.Core : CreateThingStateInfo
	...    8.Core : Create Control
	...    9.Core : CoapApp Register
	...    10.Core : CoapApp Delta
	...    11.Verify DB	
	...    12.Verify Log
	...    13.Remove Thing
	...    14.Remove Account
	...    15.Remove Partner 
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
	${valueKey}=    Set Variable    {"${VALUE_SENSORKEY}":"${random_Sensor}"}
	#=============End Prepare data Report==============
    ${thingToken}=    RegisterSuccess    ${createResponse} 
	#Replace Parameters Url IMSI or Token and IP 
	${url_config}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_DELTA}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Set Global Variable    ${url_config_lass}    ${url_config}?${VALUE_SENSORKEY}
	Log To Console    Config Url is : ${url_config_lass}
	#Send Report
    DeltaAsgardApp    ${url_config_lass}    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS} 
	#Check log detail and summary
    Log CoapApp Delta    ${CODE_20000}    ${RESULTDESC_OK}    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    2    ${createResponse}    ${thingToken}    ${valueKey}    
	#Inquiry for verify DB   
    Verify DB Delta : Sensor    ${createResponse}    ${valueKey}
    [Teardown]    Generic Test Case Teardown    Delta    ${createResponse}    ${EMPTY}

