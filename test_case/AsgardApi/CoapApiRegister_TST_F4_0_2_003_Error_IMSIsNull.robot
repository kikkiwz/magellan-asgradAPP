*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
CoapApiRegister_TST_F4_0_2_003_Error_IMSIsNull
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
	${IMSI}=    Set Variable    ${SPACE}  
	#Replace Parameters Url IMSI or Token and IP 
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_REGISTER}    ${ASGARD_COAPAPP_FIELD_IMSI}    ${IMSI}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${IPAddress}
	Log To Console    url${url}

	#Register and check log
    AsgardAPI RegisterAsgardApp Error    ${url}    ${ASGARD_COAPAP_IMAGE_RESPONSE_ERROR_40300}
	#Check log detail and summary (not have log for coapapi)
    [Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}

