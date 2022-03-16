*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot


*** Test Cases ***
################### Post ###################
CoapApiReport_TST_F1_0_2_004_Error_ThingIdentifieAlreadyExists
    [Documentation]    Step is :    
	...    1.Core : Signin
	...    2.Core : Create Partner
	...    3.Core : Create Account
	...    4.Centric : ImportThing
	...    5.Centric : MappingIMEI
	...    6.Core : ActivateThingCore
	...    7.Core : Signin
	...    8.Core : Create Partner
	...    9.Core : Create Account
	...    10.Centric : ImportThing
	...    11.Centric : MappingIMEI
	...    12.Core : ActivateThingCore
	...    13.Core : CreateThingStateInfo
    ...    14.MongoDB : make data ThingToken Duplicate
	...    15.Core : CoapApp Register
	...    16.Verify Log
	...    17.Remove Thing
	...    18.Remove Account
	...    19.Remove Partner
	# Create data1 
    ${createResponse_data1}=    CreateData   
	${IMSI1}=    Set Variable    ${createResponse_data1}[0]
	${accessToken1}=    Set Variable    ${createResponse_data1}[1]
	${ThingID1}=    Set Variable    ${createResponse_data1}[3]
	${IMEI1}=    Set Variable    ${createResponse_data1}[4]
	${AccountId1}=    Set Variable    ${createResponse_data1}[5]
	${ThingIdentifier1}=    Set Variable    ${createResponse_data1}[7]

	# Create data2 
    ${createResponse_data2}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse_data2}[0]
	${accessToken}=    Set Variable    ${createResponse_data2}[1]
	${ThingID}=    Set Variable    ${createResponse_data2}[3]
	${IMEI}=    Set Variable    ${createResponse_data2}[4]
	${AccountId}=    Set Variable    ${createResponse_data2}[5]
	${ThingIdentifier}=    Set Variable    ${createResponse_data2}[7]
	#Create ConfigGroup
    ${resultCreateConfigGroup}=    CreateConfigGroup    ${accessToken}    ${ThingID}    ${AccountId}
	${groupId}=    Set Variable    ${resultCreateConfigGroup}[0]
	${groupName}=    Set Variable    ${resultCreateConfigGroup}[1]
	${random_Sensor}=    Evaluate    random.randint(100, 999)    random
	${valueKey}=    Set Variable    {"${VALUE_SENSORKEY}":"${random_Sensor}"}
    #Register
	${thingToken}=    AsgardAPI RegisterSuccess    ${createResponse_data2} 

	#update ThingIdentifier createdata1
	ConnectMongodb
	${queryJSON}=    Set Variable    {"ThingSecret" : "${IMSI1}"}
	${updateJSON_ThingToken}=    Set Variable    {"$set": {"ThingToken":"${thingToken}"}}	
	#dbName, dbCollName, queryJSON, updateJSON, upsert=False
	${result}=    Retrieve And Update One Mongodb Record    ${MGCORE_DBNAME}    ${MGCORE_COLLECTION_THING}    ${queryJSON}    ${updateJSON_ThingToken}    returnBeforeDocument=False   
	Disconnect From Mongodb
 	
	#Replace Parameters Url IMSI or Token and IP 
	${url_report}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_REPORT}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS2}
	Log To Console    URL Report is : ${url_report}

	#Send Report
    ${reportResponse}=    AsgardAPI ReportAsgardApp    ${url_report}?${VALUE_SENSORKEY}    ${random_Sensor}    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}   
	#Check log detail and summary
	${identity}=    Set Variable    {"Imei":"${IMEI1}","ThingID":"${ThingID1}","Imsi":"${IMSI1}"}		
	${custom}=    Set Variable    {"Imei":["${IMEI1}"],"url":"coapapis.magellan.svc.cluster.local${ASGARD_COAPAPI_URL_REPORT}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS2}","Imsi":["${IMSI1}"],"ThingID":["${ThingID1}"]}
	${body}=    Set Variable    {"ThingToken":"${thingToken}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS2}","Payloads":${valueKey},"UnixTimestampMs":[tid]}
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS}   	
	AsgardAPI Log Report    1    ${CODE_40301}    ${RESULTDESC_REQUESTEDALREADYEXISTS_ERROR}    ${CODE_40301}    ${RESULTDESC_REQUESTEDALREADYEXISTS_ERROR}    ${createResponse_data2}    ${thingToken}    ${valueKey}    ${identity}    ${custom}    ${body}    ${endPointName_detail_list}    ${VALUE_SENSORKEY}
    [Teardown]    Generic Test Case Teardown    Report    ${createResponse_data2}    ${EMPTY}


