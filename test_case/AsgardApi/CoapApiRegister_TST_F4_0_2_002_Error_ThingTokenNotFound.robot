*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
CoapApiRegister_TST_F4_0_2_002_Error_ThingTokenNotFound
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
	#Replace Parameters Url IMSI or Token and IP 
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_REGISTER}    ${ASGARD_COAPAPP_FIELD_IMSI}    ${ASGARD_COAPAPP_VALUE_TST_F4_0_2_002_IMSI}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_VALUE_TST_F4_0_2_002_IPADDRESS}
	Log To Console    url${url}

	#Register and check log
    AsgardAPI RegisterAsgardApp Error    ${url}    ${ASGARD_COAPAP_IMAGE_RESPONSE_ERROR_40300}
	#Check log detail and summary
	${identity}=    Set Variable    {"Imei":null,"ThingID":null,"Imsi":"${ASGARD_COAPAPP_VALUE_TST_F4_0_2_002_IMSI}"}		
	${custom}=    Set Variable    {"Imei":null,"url":"coapapis.magellan.svc.cluster.local${ASGARD_COAPAPI_URL_REGISTER}","Imsi":["${ASGARD_COAPAPP_VALUE_TST_F4_0_2_002_IMSI}"],"IpAddress":"${ASGARD_COAPAPP_VALUE_TST_F4_0_2_002_IPADDRESS}","ThingID":null}
	${body}=    Set Variable    {"Imsi":"${ASGARD_COAPAPP_VALUE_TST_F4_0_2_002_IMSI}","IpAddress":"${ASGARD_COAPAPP_VALUE_TST_F4_0_2_002_IPADDRESS}"}    
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS} 
	AsgardAPI Log Register    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${createResponse}    ${ASGARD_COAPAPP_VALUE_TST_F4_0_2_002_IMSI}    ${identity}    ${custom}    ${body}    ${endPointName_detail_list}
    [Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}

