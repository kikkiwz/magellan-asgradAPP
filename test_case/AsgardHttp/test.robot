*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
*** Test Cases ***
################### Post ###################

CreateData
     #1.import thing ที่ centric 
    ${response_impor_thing}=    ImportThingCentric
    ${ConnectivityType}=    Set Variable    ${response_impor_thing}[0] 
	${ThingName}=    Set Variable    ${response_impor_thing}[1]
	${ThingIdentifier}=    Set Variable    ${response_impor_thing}[2]
	${ThingSecret}=    Set Variable    ${response_impor_thing}[3]  
    #2.mapping thing ที่ centric
    MappingIMEICentric    ${ConnectivityType}    ${ThingName}    ${ThingIdentifier}    ${ThingSecret}
    Connect To Mongodb    mongodb://admin:ais.co.th@52.163.210.190:27018/mgcore?authSource=admin
    #search mongoDB
    ${result_thing}=    Search Some Record    mgcentric    things    {"ThingIdentifier": "${ThingIdentifier}"}
 	${ThingID_MGCentric}=    Get From Dictionary    ${result_thing}    _id
 	${IMEI}=    Get From Dictionary    ${result_thing}    ${FIELD_IMEI}
 	${IMSI}=    Get From Dictionary    ${result_thing}    ${FIELD_THINGSECRET}
    Disconnect From Mongodb
    #3.activate thing ที่ core

    #Sign in
    ${accessToken}=    Signin
    #Create Partner   
	${postCreatePartner}=    Create Partner    ${accessToken}
    #Create Account
    ${PartnerId}=    Set Variable    ${postCreatePartner}
	${postCreateAccount}=    Create AccountName    ${accessToken}    ${PartnerId}
    #Activate Thing
    ${AccountId}=    Set Variable    ${postCreateAccount} 
    ${ThingID_MGCORE}    ActivateThing    ${accessToken}    ${AccountId}    ${IMSI}    ${ThingIdentifier}    ${IMEI}   
	#random_Sensor
	${random_Sensor}=    Evaluate    random.randint(100, 999)    random
	Create ThingStateInfo    ${accessToken}    ${ThingID_MGCORE}    ${AccountId}    ${VALUE_SENSORKEY}    ${random_Sensor}
    #Find ThingId
	${resultInquiryThing}=    InquiryThingMGCore    ${accessToken}    ${ThingID_MGCORE}    ${AccountId}		
    ${IMSI}=    Get From Dictionary    ${resultInquiryThing}     ${FIELD_IMSI}
    ${ThingToken}=    Get From Dictionary    ${resultInquiryThing}     ${FIELD_THINGTOKEN}
	${SensorKey}=    Get From Dictionary    ${resultInquiryThing}     ${FIELD_THINGTOKEN}


	