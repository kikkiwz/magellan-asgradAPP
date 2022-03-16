*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot



*** Test Cases ***
################### Post ###################
CoapApiConfig_TST_F2_0_2_004_Error_ThingtokenNotFound
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
	...    11.Verify Log
	...    12.Remove Thing
	...    13.Remove Account
	...    14.Remove Partner 
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
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_CONFIG}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${ASGARD_COAPAPI_VALUE_TST_F2_1_0_004_THINGTOKEN_INVALID}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	#Send Config
    ${reportResponse}=    AsgardAPI ConfigAsgardApp    ${url}    ${ASGARD_COAPAP_IMAGE_RESPONSE_ERROR_40300}  
	#Check log detail and summary
	${identity}=    Set Variable    {"Imei":null,"ThingID":null,"Imsi":null}		
	${custom}=    Set Variable    {"Imei":null,"url":"coapapis.magellan.svc.cluster.local${ASGARD_COAPAPI_URL_CONFIG}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","Imsi":null,"ThingID":null}
	${body}=    Set Variable    {"ThingToken":"${ASGARD_COAPAPI_VALUE_TST_F2_1_0_004_THINGTOKEN_INVALID}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}"}
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS} 
	AsgardAPI Log Config    1     ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${createResponse}    ${ASGARD_COAPAPI_VALUE_TST_F2_1_0_004_THINGTOKEN_INVALID}    ${identity}    ${custom}    ${body}    ${endPointName_detail_list}    ${EMPTY}
    [Teardown]    Generic Test Case Teardown    Config    ${createResponse}    ${groupId}
