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
    ...    8.MGCore : AsgardHTTPeSimRegister
    ...    9.MGCore : AsgardHTTPeSimReport
    ...    10.MGCore & Centric : Remove Thing
    ...    11.MGCore : Remove Account
    ...    12.MGCore : Remove Partner
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${IMEI}=    Set Variable    ${createResponse}[4]
	${Sensor_Value}=    Set Variable    ${createResponse}[9]	
	${random_num}=    Evaluate    random.randint(100, 999)    random
	${Sensor_Key_Report}=    Set Variable    AA
	${Sensor_Value_Report}=    Set Variable    PM.${random_num}
	${Timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	#=============End Prepare data Report==============
	# Register 
	${authen}=    Set Variable    ${IMSI}:${IPAddress}
	${res}=    AsgardHTTPRegister    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_20000}
	${ThingToken}=    Get From Dictionary    ${res}[0]     ${FIELD_THINGTOKEN}
	# Report 
	${authen}=    Set Variable    ${ThingToken}:${IPAddress}
	${res_report}=    AsgardHTTPReport    ${authen}    ${OPERATION_STATUS_AsgardHTTPRegister_20000}    ${Sensor_Key_Report}    ${Sensor_Value_Report}    ${Timestamp}  
	# Check log detail and summary 
	${identity}=    Set Variable    {"Imei":"${IMEI}","ThingId":"${ThingID}","Imsi":"${IMSI}"}		 
	${custom}=    Set Variable    {"Imsi":["${IMSI}"],"url":"${HOST}${URL_AsgardHTTPReport}","Imei":["${IMEI}"],"ThingID":["${ThingID}"]}
	${body}=    Set Variable    {"${Sensor_Key_Report}":"${Sensor_Value_Report}","Timestamp":"${Timestamp}"}
	${orderRef}=    Set Variable    ${res_report}[1]
    ${endPointName_detail_list}    Create List    ${ENDPOINTNAME_CUSTOMER}    ${ENDPOINTNAME_ACCOUNT}    ${ENDPOINTNAME_THINGS}  
	Log HTTP Report    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${orderRef}    ${ThingToken}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}
	# Verify DB 
	ConnectMongodb
	${Sensor_Value_Str}=    Convert To String    ${Sensor_Value}
	${Payload_Expect}=    Create Dictionary    ${VALUE_SENSORKEY}=${Sensor_Value_Str}    ${Sensor_Key_Report}=${Sensor_Value_Report}    Timestamp=${Timestamp}
    ${Result}=    Search Some Record    ${MGCORE_DBNAME}    ${MGCORE_COLLECTION_THING}    {"${FIELD_THINGSECRET}" : "${IMSI}"}  # ${FIELD_STATEINFO}.${FIELD_STATEINFO_REPORT}
	Log    ${Result}
    ${StateInfo}=    Get From Dictionary    ${Result}     ${FIELD_STATEINFO}
    ${Payload_DB}=    Get From Dictionary    ${StateInfo}     ${FIELD_STATEINFO_REPORT}
	Disconnect From Mongodb
	Should Be Equal    ${Payload_Expect}    ${Payload_DB}
	#[Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}


