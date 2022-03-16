*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
#Suite Setup    Open Directory

*** Test Cases ***
################### Post ###################
CoapAppRegister_TST_F4_1_1_001_Success
    [Documentation]    Step is :    
	...    1.Core : Signin
	...    2.Core : Create Partner
	...    3.Core : Create Account
	...    4.Centric : ImportThing
	...    5.Centric : MappingIMEI
	...    6.Core : ActivateThingCore
	...    7.Core : CreateThingStateInfo
	...    8.Core : CoapApp Register
	...    9.Verify DB	
	...    10.Verify Log
	...    11.Remove Thing
	...    12.Remove Account
	...    13.Remove Partner 
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	Log To Console    IMSI is : ${IMSI}
	#=============End Prepare data Report==============
    #Replace Parameters Url IMSI or Token and IP 
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_REGISTER}    ${ASGARD_COAPAPP_FIELD_IMSI}    ${IMSI}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Log To Console    Register Url is : ${url}
	#Register and check log
    RegisterAsgardApp    ${url}
	#Check log detail and summary
	${thingToken}=    Log CoapApp Register    ${CODE_20000}    ${RESULTDESC_OK}    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${createResponse}    ${IMSI}
	#Inquiry for verify DB   
	Verify DB Check Data : ThingToken    ${createResponse}    ${thingToken}  
    [Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}

		



	