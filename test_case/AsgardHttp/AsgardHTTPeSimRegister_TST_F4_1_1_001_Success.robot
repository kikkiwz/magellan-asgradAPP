*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
*** Test Cases ***

AsgardHTTPeSimRegister_TST_F4_1_1_001_Success
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : AsgardHTTPeSimRegister
    ...    8.MGCore & Centric : Remove Thing
    ...    9.MGCore : Remove Account
    ...    10.MGCore : Remove Partner
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${IMEI}=    Set Variable    ${createResponse}[4]
	#=============End Prepare data Report==============
	# Register 
	${authen}=    Set Variable    ${IMSI}:${IPAddress}
	${res}=    AsgardHTTPRegister    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_20000}
	${ThingToken}=    Get From Dictionary    ${res}[0]     ${FIELD_THINGTOKEN} 
	# Check log detail and summary 
	${identity}=    Set Variable    {"Imei":"${IMEI}","ThingId":"${ThingID}","Imsi":"${IMSI}"}		 
	${custom}=    Set Variable    {"Imsi":["${IMSI}"],"url":"${HOST}${URL_AsgardHTTPRegister}","Imei":["${IMEI}"],"ThingId":["${ThingID}"]}
	${body}=    Set Variable    "" 
	${orderRef}=    Set Variable    ${res}[1]
	${endPointName_detail_list}    Create List     ${ENDPOINTNAME_THINGS}    ${ENDPOINTNAME_ACCOUNT}    ${ENDPOINTNAME_THINGS}         
	Log HTTP Register    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${orderRef}    ${ThingToken}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}   
	# Verify DB  
	ConnectMongodb
    ${Result_ThingToken_DB}=    Search By Select Fields    ${MGCORE_DBNAME}    ${MGCORE_COLLECTION_THING}    {"${FIELD_THINGSECRET}" : "${IMSI}"}    ${FIELD_THINGTOKEN}
	Disconnect From Mongodb
	${ThingToken_DB}=    Get From Dictionary    ${Result_ThingToken_DB}     ${FIELD_THINGTOKEN}
	Should Be Equal    ${ThingToken}    ${ThingToken_DB}
	#[Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}


