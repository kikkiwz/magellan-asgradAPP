*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot



*** Test Cases ***
################### Post ###################
CoapApiConfig_TST_F2_0_2_005_Error_ThingTokenAlreadyExists
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
	...    14.Core : Create ConfigGroup
	...    15.Core : CoapApp Register
    ...    16.MongoDB : make data ThingToken Duplicate
	...    17.Core : CoapApp Config
	...    18.Verify Log
	...    19.Remove Thing
	...    20.Remove Account
	...    21.Remove Partner 
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
	${url_config}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_CONFIG}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS2}
	#Remove AccountName    ${URL}    ${createResponse}[0]    ${createResponse}[1]    ${createResponse}[2]
	#Send Config
    ${reportResponse}=    AsgardAPI ConfigAsgardApp    ${url_config}    ${ASGARD_COAPAP_IMAGE_RESPONSE_ERROR_40300}  
	#Check log detail and summary
	${identity}=    Set Variable    {"Imei":"${IMEI1}","ThingID":"${ThingID1}","Imsi":"${IMSI1}"}		
	${custom}=    Set Variable    {"Imei":["${IMEI1}"],"url":"coapapis.magellan.svc.cluster.local${ASGARD_COAPAPI_URL_CONFIG}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS2}","Imsi":["${IMSI1}"],"ThingID":["${ThingID1}"]}
	${body}=    Set Variable    {"ThingToken":"${thingToken}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS2}"}
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS} 
	AsgardAPI Log Config    1     ${CODE_40301}    ${RESULTDESC_REQUESTEDALREADYEXISTS_ERROR}    ${CODE_40301}    ${RESULTDESC_REQUESTEDALREADYEXISTS_ERROR}    ${createResponse_data2}    ${thingToken}    ${identity}    ${custom}    ${body}    ${endPointName_detail_list}    ${EMPTY}
    [Teardown]    Generic Test Case Teardown    Config    ${createResponse_data2}    ${groupId}