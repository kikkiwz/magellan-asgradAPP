*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
*** Test Cases ***
################### Post ###################

AsgardHTTPeSimRegister_TST_F4_1_1_001_Success
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : Create ThingStateInfo
    ...    8.MGCore : Create ConfigGroup
    ...    9.MGCore : AsgardHTTPeSimRegister
    ...    10.MGCore : AsgardHTTPeSimConfig
    ...    11.MGCore : Remove ConfigGroup
    ...    12.MGCore & Centric : Remove Thing
    ...    13.MGCore : Remove Account
    ...    14.MGCore : Remove Partner
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
	# Register 
	${authen}=    Set Variable    ${IMSI}:${IPAddress}
	${res}=    AsgardHTTPRegister    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_20000}
	${ThingToken}=    Get From Dictionary    ${res}[0]     ${FIELD_THINGTOKEN}  
	# Config 
	${authen}=    Set Variable    ${ThingToken}:${IPAddress}
	${res_config}=    AsgardHTTPConfig    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_20000}    ${VALUE_CONFIGINFO_KEY_REFRESHTIME}
	# Check log detail and summary 
	${orderRef}=    Set Variable    ${res_config}[1]
	${identity}=    Set Variable    {"Imei":"${IMEI}","ThingId":"${ThingID}","Imsi":"${IMSI}"}		 
	${custom}=    Set Variable    {"Imsi":["${IMSI}"],"url":"${HOST}${URL_AsgardHTTPConfig}","Imei":["${IMEI}"],"ThingID":["${ThingID}"]}
	${body}=    Set Variable    {"${VALUE_CONFIGINFO_KEY_REFRESHTIME}":"${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}"}
    ${endPointName_detail_list}    Create List    ${ENDPOINTNAME_ONLINECONFIG}    ${ENDPOINTNAME_ACCOUNT}    ${ENDPOINTNAME_THINGS}  
	Log HTTP Config    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${orderRef}    ${ThingToken}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}    
	# Verify DB 
	ConnectMongodb
	${result}=    Search Some Record    mgcore    onlineconfigs    {"OnlineConfigName" : "${groupName}"}
	Log    ${result}
	${CustomDetails}=    Get From Dictionary    ${result}     ${FIELD_CUSTOMDETAILS}
	${sensorKey_DB}=    Get From Dictionary    ${CustomDetails}     ${VALUE_CONFIGINFO_KEY_REFRESHTIME}	
	Disconnect From Mongodb	
	Should Be Equal    ${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}    ${sensorKey_DB}
    [Teardown]    Generic Test Case Teardown    Config    ${createResponse}    ${groupId}


