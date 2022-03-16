*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot


*** Test Cases ***
CoapApiReport_TST_F1_0_2_002_Error_ThingtokenInvalid
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
	...    10.Verify Log
	...    11.Remove Thing
	...    12.Remove Account
	...    13.Remove Partner 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${AccountId}=    Set Variable    ${createResponse}[5]
	${random_Sensor_App}=    Evaluate    random.randint(100, 999)    random
	${SensorValue}=    Set Variable    SCTest.${randomSensorApp}
    #random_Sensor_Report
	${valueKey}=    Set Variable    {"${VALUE_SENSORKEY}":"${SensorValue}"}

	#Register
	${thingToken}=    AsgardAPI RegisterSuccess    ${createResponse}

	#Replace Parameters Url IMSI or Token and IP 
	${url_report}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_REPORT}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}${ASGARD_COAPAPI_VALUE_TST_F1_0_2_002_THINGTOKEN_INVALID}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Log To Console    URL Report is : ${url_report}

	#Send Report
    ${reportResponse}=    AsgardAPI ReportAsgardApp    ${url_report}    ${valueKey}    ${ASGARD_COAPAP_IMAGE_RESPONSE_ERROR_40300}   

	#Check log detail and summary
	${identity}=    Set Variable    {"Imei":null,"ThingID":null,"Imsi":null}		
	${custom}=    Set Variable    {"Imei":null,"url":"coapapis.magellan.svc.cluster.local${ASGARD_COAPAPI_URL_REPORT}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","Imsi":null,"ThingID":null}
	${body}=    Set Variable    {"ThingToken":"${thingToken}${ASGARD_COAPAPI_VALUE_TST_F1_0_2_002_THINGTOKEN_INVALID}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","Payloads":${valueKey},"UnixTimestampMs":[tid]}	
    ${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS}  
	
	AsgardAPI Log Report    1    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${createResponse}    ${thingToken}${ASGARD_COAPAPI_VALUE_TST_F1_0_2_002_THINGTOKEN_INVALID}    ${valueKey}    ${identity}    ${custom}    ${body}    ${endPointName_detail_list}    ${VALUE_SENSORKEY}
    [Teardown]    Generic Test Case Teardown    Report    ${createResponse}    ${EMPTY}



