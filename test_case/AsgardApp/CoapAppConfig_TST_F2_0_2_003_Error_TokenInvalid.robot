*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
#Suite Setup    Open Directory
*** Test Cases ***
################### Post ###################
CoapAppConfig_TST_F2_0_2_003_Error_TokenInvalid
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
	#=============Start Prepare data Report============== 
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
	#=============End Prepare data Report==============
	${thingToken}=    RegisterSuccess    ${createResponse}
	#Replace Parameters Url IMSI or Token and IP 
	${url_config}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_CONFIG}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}${ASGARD_COAPAPP_VALUE_TST_F2_0_2_003_THINGTOKEN_INVALID}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Log To Console    Config Url is : ${url_config}
	#=============End Prepare data Report==============
	#Send Config
    ConfigAsgardApp    ${url_config}    ${ASGARD_COAPAP_IMAGE_RESPONSE_SUCCESS_CONFIG_002}  
	#Check log detail and summary
    ${thingToken}=    Set Variable    ${thingToken}${ASGARD_COAPAPP_VALUE_TST_F2_0_2_003_THINGTOKEN_INVALID}
    Log CoapApp Config     ${CODE_40300}    ${RESULTDESC_FORBIDDEN_ERROR}    ${CODE_40300}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    1    ${createResponse}    ${thingToken}    
    [Teardown]    Generic Test Case Teardown    Config    ${createResponse}    ${groupId}


	
