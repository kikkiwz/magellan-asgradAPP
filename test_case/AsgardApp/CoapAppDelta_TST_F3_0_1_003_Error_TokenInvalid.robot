*** Settings ***
#Documentation     TST_F3_0_1_003
Test Setup    Add Needed Image Path

Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
CoapAppDelta_TST_F3_0_1_003_Error_TokenInvalid
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
	...    11.Verify Log
	...    12.Remove Thing
	...    13.Remove Account
	...    14.Remove Partner 
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
	${thingToken}=    Set Variable    ${thingToken}${ASGARD_COAPAPP_VALUE_TST_F3_0_1_003_THINGTOKEN_INVALID}
	#Replace Parameters Url IMSI or Token and IP 
	${url_config}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_DELTA}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Log To Console    URL Report is : ${url_config}
	#Send Report
    DeltaAsgardApp    ${url_config}    ${ASGARD_COAPAP_IMAGE_RESPONSE_ERROR_40300} 
	#Check log detail and summary
    Log CoapApp Delta    ${CODE_40300}    ${RESULTDESC_FORBIDDEN_ERROR}    ${CODE_40300}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    1    ${createResponse}    ${thingToken}    ${valueKey}
    [Teardown]    Generic Test Case Teardown    Delta    ${createResponse}    ${EMPTY}
	


