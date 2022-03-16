*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
AsgardMQTTRegister_TST_F1_0_2_002_Error_ImsiInvalid
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : Create ThingStateInfo
    ...    8.MGCore : AsgardMQTT Register
    ...    9.MGCore & Centric : Remove Thing
    ...    10.MGCore : Remove Account
    ...    11.MGCore : Remove Partner
    Connect To Mongodb    ${CONNECT_MONGODB}
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingToken_Provisioning}=    Set Variable    ${createResponse}[2]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${IMEI}=    Set Variable    ${createResponse}[4]
	#=============End Prepare data Report==============
	# Register Success
	${result}=    MQTTConnect    ${IMSI}${ASGARD_MQTT_VALUE_TST_F1_0_2_002_IMSI}
	Should Not Be True    ${result}
    [Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY} 



