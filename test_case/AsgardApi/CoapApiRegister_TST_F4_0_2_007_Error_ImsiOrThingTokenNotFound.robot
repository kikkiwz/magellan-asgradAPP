*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
CoapApiRegister_TST_F4_0_2_007_Error_ImsiOrThingTokenNotFound
    [Documentation]    Step is :    
	...    1.Core : Signin
	...    2.Core : Create Partner
	...    3.Core : Create Account
	...    4.Centric : ImportThing
	...    5.Centric : MappingIMEI
	...    6.Core : ActivateThingCore
	...    7.Core : CreateThingStateInfo
	...    8.Core : CoapApp Register
	...    9.Verify Log
	...    10.Remove Thing
	...    11.Remove Account
	...    12.Remove Partner
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${IMEI}=    Set Variable    ${createResponse}[4]
	${AccountId}=    Set Variable    ${createResponse}[5]
	${PartnerId}=    Set Variable    ${createResponse}[6]

	#Replace Parameters Url IMSI or Token and IP 
	${url_register}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_REGISTER}    ${ASGARD_COAPAPP_FIELD_IMSI}    ${IMSI}x    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Log To Console    url${url_register}
	#Remove ThingFromAccount    ${accessToken}    ${AccountId}    ${ThingID}

	#Register and check log
    AsgardAPI RegisterAsgardApp Error    ${url_register}    ${ASGARD_COAPAP_IMAGE_RESPONSE_ERROR_40300}

	#Check log detail and summary
	${identity}=    Set Variable    {"Imei":null,"ThingID":null,"Imsi":"${IMSI}x"}		
	${custom}=    Set Variable    {"Imei":null,"url":"coapapis.magellan.svc.cluster.local${ASGARD_COAPAPI_URL_REGISTER}","Imsi":["${IMSI}x"],"IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","ThingID":null}
	${body}=    Set Variable    {"Imsi":"${IMSI}x","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}"}
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS}   
	AsgardAPI Log Register    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${createResponse}    ${IMSI}x    ${identity}    ${custom}    ${body}    ${endPointName_detail_list}
    [Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}
