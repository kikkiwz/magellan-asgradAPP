*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
CoapApiDelta_TST_F3_0_2_006_Error_ThingStatusIdle
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
	...    10.Core : Remove ThingFromAccount
	...    11.Core : CoapApp Delta
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
	${PartnerId}=    Set Variable    ${createResponse}[6]
	#${PartnerId}=    Set Variable    ${createResponse}[6]
	#Create Control
	${random_Sensor}=    Evaluate    random.randint(100, 999)    random
    ${resultSensorKey}=    Create ControlThing    ${accessToken}    ${ThingId}    ${AccountId}    ${VALUE_SENSORKEY}    ${random_Sensor}
	${valueKey}=    Set Variable    {"${VALUE_SENSORKEY}":"${random_Sensor}"}

	#Register
    ${thingToken}=    AsgardAPI RegisterSuccess    ${createResponse} 

	#Replace Parameters Url IMSI or Token and IP 
	${url_config}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_DELTA}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Log To Console    URL Report is : ${url_config}
	Remove ThingFromAccount    ${accessToken}    ${AccountId}    ${ThingID}	
	#Send Report
    ${deltaResponse}=    AsgardAPI DeltaAsgardApp    ${url_config}    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS} 
	#Check log detail and summary
	${identity}=    Set Variable    {"Imei":null,"ThingID":null,"Imsi":null}		
	${custom}=    Set Variable    {"Imei":null,"url":"coapapis.magellan.svc.cluster.local${ASGARD_COAPAPI_URL_DELTA}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","Imsi":null,"ThingID":null}
	${body}=    Set Variable    {"ThingToken":"${thingToken}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}"}
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS} 
	AsgardAPI Log Delta    1    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${createResponse}    ${thingToken}    ${identity}    ${custom}    ${body}    ${endPointName_detail_list}    ${EMPTY}    ${EMPTY}
    [Teardown]    Generic Test Case Teardown    Delta    ${createResponse}    ${EMPTY}

