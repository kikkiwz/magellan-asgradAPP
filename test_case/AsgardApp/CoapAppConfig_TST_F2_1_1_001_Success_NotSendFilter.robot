*** Settings ***
#Documentation     TST_F2_1_1_001
#Test Setup    Add Needed Image Path

Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
CoapAppConfig_TST_F2_1_1_001_Success_NotSendFilter
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
	${url_config}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_CONFIG}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}	
	Log To Console    Config Url is : ${url_config} 
	#Send Config
    ConfigAsgardApp    ${url_config}    ${ASGARD_COAPAP_IMAGE_RESPONSE_SUCCESS_CONFIG}  
	#Check log detail and summary
    Log CoapApp Config    ${CODE_20000}    ${RESULTDESC_OK}    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    1     ${createResponse}    ${thingToken}
	#Inquiry for verify DB   
    Verify DB Check Data : Config [RefreshTime and Max]    ${accessToken}   ${AccountId}    ${ThingID}
    [Teardown]    Generic Test Case Teardown    Config    ${createResponse}    ${groupId}

	