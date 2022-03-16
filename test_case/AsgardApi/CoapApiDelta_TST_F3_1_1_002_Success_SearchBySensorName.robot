*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
CoapApiDelta_TST_F3_1_1_002_Success_SearchBySensorName
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

	#Register
    ${thingToken}=    AsgardAPI RegisterSuccess    ${createResponse} 

	#Replace Parameters Url IMSI or Token and IP 
	${url_config}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_DELTA}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Set Global Variable    ${url_config_lass}    ${url_config}?${VALUE_SENSORKEY}
	Log To Console    Config Url is : ${url_config_lass}
	
	#Send Report
    ${deltaResponse}=    AsgardAPI DeltaAsgardApp    ${url_config_lass}    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS} 
	#Check log detail and summary
	${identity}=    Set Variable    {"Imei":"${IMEI}","ThingID":"${ThingID}","Imsi":"${IMSI}"}		
	${custom}=    Set Variable    {"Imei":["${IMEI}"],"url":"coapapis.magellan.svc.cluster.local${ASGARD_COAPAPI_URL_DELTA}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","Imsi":["${IMSI}"],"ThingID":["${ThingID}"]}
	${body}=    Set Variable    {"ThingToken":"${thingToken}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","Sensor":"${VALUE_SENSORKEY}"}
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS}    ${ENDPOINTNAME_ACCOUNT}    ${ENDPOINTNAME_THINGS} 
	AsgardAPI Log Delta    2    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${createResponse}    ${thingToken}    ${identity}    ${custom}    ${body}    ${endPointName_detail_list}    ${VALUE_SENSORKEY}    ${valueKey}
	#Inquiry for verify DB   
	Verify DB Delta : Sensor    ${createResponse}    ${valueKey}
    [Teardown]    Generic Test Case Teardown    Delta    ${createResponse}    ${EMPTY}