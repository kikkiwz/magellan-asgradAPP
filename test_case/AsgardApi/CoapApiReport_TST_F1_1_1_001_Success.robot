*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
CoapApiReport_TST_F1_1_1_001_Success
    [Documentation]    Step is :    
	...    1.Core : Signin
	...    2.Core : Create Partner
	...    3.Core : Create Account
	...    4.Centric : ImportThing
	...    5.Centric : MappingIMEI
	...    6.Core : ActivateThingCore
	...    7.Core : CreateThingStateInfo
	...    8.Core : CoapApp Register
	...    9.Core : CoapApp Report
	...    10.Verify DB
	...    11.Verify Log
	...    12.Remove Thing
	...    13.Remove Account
	...    14.Remove Partner 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${IMEI}=    Set Variable    ${createResponse}[4]
	${AccountId}=    Set Variable    ${createResponse}[5]
	${PartnerId}=    Set Variable    ${createResponse}[6]
	${random_Sensor_App}=    Evaluate    random.randint(100, 999)    random
	${SensorValue}=    Set Variable    SCTest.${randomSensorApp}
    #random_Sensor_Report
	${valueKey}=    Set Variable    {"${VALUE_SENSORKEY}":"${SensorValue}"}

	#Register
	${thingToken}=    AsgardAPI RegisterSuccess    ${createResponse}

	#Replace Parameters Url IMSI or Token and IP 
	${url_report}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_REPORT}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Log To Console    URL Report is : ${url_report}

	#Send Report
    ${reportResponse}=    ReportAsgardApp    ${url_report}    ${valueKey}    ${ASGARD_COAPAP_IMAGE_RESPONSE_SUCCESS_20000}  

	#Check log detail and summary
	${identity}=    Set Variable    {"Imei":"${IMEI}","ThingID":"${ThingID}","Imsi":"${IMSI}"}		
	${custom}=    Set Variable    {"Imei":["${IMEI}"],"url":"coapapis.magellan.svc.cluster.local${ASGARD_COAPAPI_URL_REPORT}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","Imsi":["${IMSI}"],"ThingID":["${ThingID}"]}
	${body}=    Set Variable    {"ThingToken":"${thingToken}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","Payloads":${valueKey},"UnixTimestampMs":[tid]}
    ${endPointName_detail_list}    Create List    ${ENDPOINTNAME_CUSTOMER}    ${ENDPOINTNAME_ACCOUNT}    ${ENDPOINTNAME_THINGS}  
	AsgardAPI Log Report    1    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${createResponse}    ${thingToken}    ${valueKey}    ${identity}    ${custom}    ${body}    ${endPointName_detail_list}    ${VALUE_SENSORKEY}

	#Inquiry for verify DB   
	Verify DB Check Data : Sensor    ${accessToken}   ${AccountId}    ${ThingID}     ${valueKey} 
    [Teardown]    Generic Test Case Teardown    Report    ${createResponse}    ${EMPTY}

