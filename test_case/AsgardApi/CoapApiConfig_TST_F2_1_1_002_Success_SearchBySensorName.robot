*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
CoapApiConfig_TST_F2_1_1_002_Success_SearchBySensorName
    [Documentation]    Step is :    
	...    1.Core : Signin
	...    2.Core : Create Partner
	...    3.Core : Create Account
	...    4.Centric : ImportThing
	...    5.Centric : MappingIMEI
	...    6.Core : ActivateThingCore
	...    7.Core : CreateThingStateInfo
	...    8.Core : Create ConfigGroup
	...    9.Core : CoapApp Register
	...    10.Core : CoapApp Config
	...    12.Verify DB
	...    13.Verify Log
	...    14.Remove Thing
	...    15.Remove Account
	...    16.Remove Partner
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${IMEI}=    Set Variable    ${createResponse}[4]
	${AccountId}=    Set Variable    ${createResponse}[5]
	#Create ConfigGroup
    ${resultCreateConfigGroup}=    CreateConfigGroup    ${accessToken}    ${ThingID}    ${AccountId}
	${groupId}=    Set Variable    ${resultCreateConfigGroup}[0]
	${groupName}=    Set Variable    ${resultCreateConfigGroup}[1]
    #Register
	${thingToken}=    AsgardAPI RegisterSuccess    ${createResponse} 
	#Replace Parameters Url IMSI or Token and IP 
	${url_config}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_CONFIG}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Set Global Variable    ${url_config_lass}    ${url_config}?${VALUE_ConfigInfo_KEY_MAX}
	Log To Console    Config Url is : ${url_config_lass}
	#Send Config
    ${reportResponse}=    AsgardAPI ConfigAsgardApp    ${url_config_lass}    ${ASGARD_COAPAP_IMAGE_RESPONSE_SUCCESS_CONFIG_002}  
	#Check log detail and summary
	${identity}=    Set Variable    {"Imei":"${IMEI}","ThingID":"${ThingID}","Imsi":"${IMSI}"}		
	${custom}=    Set Variable    {"Imei":["${IMEI}"],"url":"coapapis.magellan.svc.cluster.local${ASGARD_COAPAPI_URL_CONFIG}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","Imsi":["${IMSI}"],"ThingID":["${ThingID}"]}
	${body}=    Set Variable    {"ThingToken":"${thingToken}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","Sensor":"${VALUE_ConfigInfo_KEY_MAX}"}		
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_ONLINECONFIG}    ${ENDPOINTNAME_ACCOUNT}    ${ENDPOINTNAME_THINGS} 
	AsgardAPI Log Config    2    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${createResponse}    ${thingToken}    ${identity}    ${custom}    ${body}    ${endPointName_detail_list}    ${VALUE_ConfigInfo_KEY_MAX}
	#Inquiry for verify DB   
	Verify DB Check Data : Config [RefreshTime and Max]    ${accessToken}   ${AccountId}    ${ThingID}  
    [Teardown]    Generic Test Case Teardown    Config    ${createResponse}    ${groupId}

