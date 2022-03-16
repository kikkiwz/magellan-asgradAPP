*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
CoapApiRegister_TST_F4_1_1_001_Success
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
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${IMEI}=    Set Variable    ${createResponse}[4]
	${AccountId}=    Set Variable    ${createResponse}[5]
	${PartnerId}=    Set Variable    ${createResponse}[6]

    #Replace Parameters Url IMSI or Token and IP 
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_REGISTER}    ${ASGARD_COAPAPP_FIELD_IMSI}    ${IMSI}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Log To Console    Register Url is : ${url}

	#Register and check log
    ${thingToken}=    AsgardAPI RegisterSuccess    ${createResponse}

	#Check log detail and summary
	${identity}=    Set Variable    {"Imei":"${IMEI}","ThingID":"${ThingID}","Imsi":"${IMSI}"}		
	${custom}=    Set Variable    {"Imei":["${IMEI}"],"url":"coapapis.magellan.svc.cluster.local${ASGARD_COAPAPI_URL_REGISTER}","Imsi":["${IMSI}"],"IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","ThingID":["${ThingID}"]}
	${body}=    Set Variable    {"Imsi":"${IMSI}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}"}
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_ACCOUNT}    ${ENDPOINTNAME_THINGS}    ${ENDPOINTNAME_THINGS}   	
	AsgardAPI Log Register    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${createResponse}    ${IMSI}    ${identity}    ${custom}    ${body}    ${endPointName_detail_list}

	#Inquiry for verify DB   
	Verify DB Check Data : ThingToken    ${createResponse}    ${thingToken}  
    [Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}

 

