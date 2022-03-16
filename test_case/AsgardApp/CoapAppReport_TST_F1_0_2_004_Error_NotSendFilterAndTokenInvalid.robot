*** Settings ***
#Documentation     TST_F1_0_2_004
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
CoapAppReport_TST_F1_0_2_004_Error_NotSendFilterAndTokenInvalid
    [Documentation]    Step is :    
	...    1.Core : Signin
	...    2.Core : Create Partner
	...    3.Core : Create Account
	...    4.Centric : ImportThing
	...    5.Centric : MappingIMEI
	...    6.Core : ActivateThingCore
	...    7.Core : CreateThingStateInfo
	...    8.Core : CoapApp Register
	...    9.Core : CoapApp Report
	...    10.Verify Log
	...    11.Remove Thing
	...    12.Remove Account
	...    13.Remove Partner 
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${AccountId}=    Set Variable    ${createResponse}[5]
	${random_Sensor_App}=    Evaluate    random.randint(100, 999)    random
	${SensorValue}=    Set Variable    SCTest.${randomSensorApp}
	#=============End Prepare data Report==============
	${thingToken}=    RegisterSuccess    ${createResponse} 	
	#Replace Parameters Url IMSI or Token and IP 
	${url_report}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_REPORT}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}${ASGARD_COAPAPP_VALUE_TST_F1_0_2_003_THINGTOKEN_INVALID}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Log To Console    URL Report is : ${url_report}
    #random_Sensor_Report
	${randomSensorApp}=    Evaluate    random.randint(100, 999)    random
	${valueKey}=    Set Variable    {"${VALUE_SENSORKEY}":"Pm1.25${randomSensorApp}"}
	Log To Console    valueKey${valueKey}	
	#Send Report
    ReportAsgardApp    ${url_report}    ${valueKey}    ${ASGARD_COAPAP_IMAGE_RESPONSE_ERROR_40010}   
	#Check log detail and summary
    ${thingToken}=    Set Variable    ${thingToken}${ASGARD_COAPAPP_VALUE_TST_F1_0_2_003_THINGTOKEN_INVALID}
    Log CoapApp Report        ${CODE_40300}    ${RESULTDESC_FORBIDDEN_ERROR}    ${CODE_40300}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    1    ${createResponse}    ${thingToken}    ${valueKey}
    [Teardown]    Generic Test Case Teardown    Report    ${createResponse}     ${EMPTY}


	
	