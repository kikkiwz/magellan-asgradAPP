*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
CoapAppRegister_TST_F4_0_2_002_Error
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
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	Log To Console    IMSI is : ${IMSI}
	${IMSI_INVALID}=    Set Variable    ${IMSI}xx   
	#=============End Prepare data Report==============
	#Replace Parameters Url IMSI or Token and IP 
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_REGISTER}    ${ASGARD_COAPAPP_FIELD_IMSI}    ${IMSI_INVALID}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Log To Console    url${url}
	#Register and check log
    RegisterAsgardApp    ${url}
	#Check log detail and summary
    Log CoapApp Register    ${CODE_40300}    ${RESULTDESC_FORBIDDEN_ERROR}    ${CODE_40300}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${createResponse}    ${IMSI_INVALID}
    [Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}
