*** Settings ***
#Documentation     TST_F1_1_1_002
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
CoapAppReport_TST_F1_1_1_002_Success_SendFilterSensorName
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
	...    10.Verify DB
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
	${AccountId}=    Set Variable    ${createResponse}[5]
	${random_Sensor_App}=    Evaluate    random.randint(100, 999)    random
	${SensorValue}=    Set Variable    SCTest.${randomSensorApp}
    #random_Sensor_Report
	${valueKey}=    Set Variable    {"${VALUE_SENSORKEY}":"${SensorValue}"}
	#=============End Prepare data Report==============
	#Register
	${thingToken}=    RegisterSuccess    ${createResponse}
	#Replace Parameters Url IMSI or Token and IP 
	${url_report}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_REPORT}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Set Global Variable    ${url_report_lass}    ${url_report}?${VALUE_SENSORKEY}
	Log To Console    URL Report is : ${url_report_lass}	
	#Report
    ReportAsgardApp    ${url_report_lass}    ${SensorValue}    ${ASGARD_COAPAP_IMAGE_RESPONSE_SUCCESS_20000}   
	#Check log detail and summary
    Log CoapApp Report    ${CODE_20000}    ${RESULTDESC_OK}    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    2    ${createResponse}    ${thingToken}    ${valueKey}
	#Inquiry for verify DB   
    Verify DB Check Data : Sensor    ${accessToken}   ${AccountId}    ${ThingID}    ${valueKey} 
    [Teardown]    Generic Test Case Teardown    Report    ${createResponse}    ${EMPTY}