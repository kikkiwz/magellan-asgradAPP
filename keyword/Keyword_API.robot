*** Keywords ***
#==============================================================================
#                       Mainflow Create Data 
#==============================================================================
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
    [Return]    ${IMSI}    ${accessToken}    ${ThingToken}    ${ThingID_MGCORE}    ${IMEI}    ${AccountId}    ${PartnerId}    ${ThingIdentifier}    ${ThingID_MGCentric}    ${random_Sensor}


CreateData For Charging
    [Arguments]    ${MobileNo} 
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
	#Inquiry Accound
	${responseInquiryAccount}=    Inquiry Account    ${URL}    ${accessToken}    ${MobileNo}
	${accoundId}=    Set Variable    ${responseInquiryAccount}[0]
    #Activate Thing
    ${ThingID_MGCORE}    ActivateThing    ${accessToken}    ${accoundId}    ${IMSI}    ${ThingIdentifier}    ${IMEI}   
	#random_Sensor
	${random_Sensor}=    Evaluate    random.randint(100, 999)    random
	Create ThingStateInfo    ${accessToken}    ${ThingID_MGCORE}    ${accoundId}    ${VALUE_SENSORKEY}    ${random_Sensor}
    #Find ThingId
	${resultInquiryThing}=    InquiryThingMGCore    ${accessToken}    ${ThingID_MGCORE}    ${accoundId}		
    ${resultInquiryThing_IMSI}=    Get From Dictionary    ${resultInquiryThing}     ${FIELD_IMSI}
    ${ThingToken}=    Get From Dictionary    ${resultInquiryThing}     ${FIELD_THINGTOKEN}
	${SensorKey}=    Get From Dictionary    ${resultInquiryThing}     ${FIELD_THINGTOKEN}
    [Return]    ${resultInquiryThing_IMSI}    ${accessToken}    ${ThingToken}    ${ThingID_MGCORE}    ${IMEI}    ${accoundId}    ${PartnerId}    ${ThingIdentifier}    ${ThingID_MGCentric}    ${random_Sensor}

#====================================================================================
#										API 
#====================================================================================
# CENTRIC : Create a Thing
CreateThingCentricNotHaveWorker
    #prepare data
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	${random_number}=    generate random string    6    [NUMBERS]
	#ThingName
    ${ThingName}=    Set Variable    ${VALUE_THINGNAME_CENTRIC}${random_number}
    #ThingIdentifier
	${randomThingIdentifier1}=    Evaluate    random.randint(1000000, 9999999)    random
	${randomThingIdentifier2}=    Evaluate    random.randint(100000, 999999)    random
	${ThingIdentifier}=    Set Variable    ${THINGIDENTIFIER_PREFIX}${randomThingIdentifier1}${randomThingIdentifier2}
	#ThingSecret
	${randomThingSecret1}=    Evaluate    random.randint(10000000, 99999999)    random
	${randomThingSecret2}=    Evaluate    random.randint(1000000, 9999999)    random
	${ThingSecret}=    Set Variable    ${randomThingSecret1}${randomThingSecret2}
    #IMEI
	${randomIM1}=    Evaluate    random.randint(10000000, 99999999)    random
	${randomIM2}=    Evaluate    random.randint(1000000, 9999999)    random
	${IMEI}=    Set Variable    ${randomIM1}${randomIM2}  
	#set header
	${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEWORKERCENTRIC}${current_timestamp}  
	Log    ${headers}
	#set body
    ${data}=    Evaluate    {"ConnectivityType": "NBIOT","ThingName" : "${ThingName}","ThingIdentifier": "${ThingIdentifier}","ThingSecret": "${ThingSecret}","IMEI": "${IMEI}"}   
    Log    ${data}
    #send api
    ${res}=    Post Api Request    ${URL_CENTRIC}${CENTRICAPIS}    ${URL_CREATETHING_CENTRIC}    ${headers}    ${data}
	Log    ${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${OPERATION_STATUS_CREATETHING}
    Log    ${operationStatus}	
    ${ThingInfo}=    Get From Dictionary    ${res}     ${FIELD_THINGINFO}   
	${ThingID}=    Get From Dictionary    ${ThingInfo}     ${FIELD_THINGID}    
	${IMEI}=    Get From Dictionary    ${ThingInfo}     ${FIELD_IMEI}     	

# CENTRIC : Import Thing
ImportThingCentric
    #prepare data
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	${random_number}=    generate random string    6    [NUMBERS]
	#ThingName
    ${ThingName}=    Set Variable    ${VALUE_THINGNAME_IMPORT_CENTRIC}${random_number}
    #ThingIdentifier
	${randomThingIdentifier1}=    Evaluate    random.randint(1000000, 9999999)    random
	${randomThingIdentifier2}=    Evaluate    random.randint(100000, 999999)    random
	${ThingIdentifier}=    Set Variable    ${THINGIDENTIFIER_PREFIX}${randomThingIdentifier1}${randomThingIdentifier2}
	#ThingSecret
	${randomThingSecret1}=    Evaluate    random.randint(10000000, 99999999)    random
	${randomThingSecret2}=    Evaluate    random.randint(1000000, 9999999)    random
	${ThingSecret}=    Set Variable    ${randomThingSecret1}${randomThingSecret2}
	#set header
	${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEWORKERCENTRIC}${current_timestamp}  
	Log    ${headers}
	#set body
    ${data}=    Evaluate    [{"ConnectivityType": "NBIOT","ThingName" : "${ThingName}","ThingIdentifier": "${ThingIdentifier}","ThingSecret": "${ThingSecret}"}]   
    Log    ${data}
    #send api
    ${res}=    Post Api Request    ${URL_CENTRIC}${CENTRICAPIS}    ${URL_IMPORTTHING_CENTRIC}    ${headers}    ${data}
	Log    ${res}
    #check response
	${resultCode}=    Get From Dictionary    ${res}[0]     ${FIELD_RESULTCODE_IMPORT_THING}
	Log    ${resultCode}
	${resultCode_final}    Convert To String    ${resultCode}
	Should Be Equal    ${resultCode_final}    ${RESULTCODE_IMPORTTHING}
    Log    ${resultCode_final}	
	${ConnectivityType}=    Get From Dictionary    ${res}[0]     ${FIELD_CONNECTIVITY}
	${ThingName}=    Get From Dictionary    ${res}[0]     ${FIELD_THINGNAME}
	${ThingIdentifier}=    Get From Dictionary    ${res}[0]     ${FIELD_THINGIDEN}  
	${ThingSecret}=    Get From Dictionary    ${res}[0]     ${FIELD_THINGSECRET}  	
	[return]    ${ConnectivityType}    ${ThingName}    ${ThingIdentifier}    ${ThingSecret}


# CENTRIC : Mapping IMEI
MappingIMEICentric
    [Arguments]    ${ConnectivityType}    ${ThingName}    ${ThingIdentifier}    ${ThingSecret}
    #prepare data
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    #IMEI
	${randomIM1}=    Evaluate    random.randint(10000000, 99999999)    random
	${randomIM2}=    Evaluate    random.randint(1000000, 9999999)    random
	${IMEI}=    Set Variable    ${randomIM1}${randomIM2} 
	#set header
	${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEWORKERCENTRIC}${current_timestamp}  
	Log    ${headers}
	#set body
    ${data}=    Evaluate    [{"ConnectivityType": "${ConnectivityType}","ThingName" : "${ThingName}","ThingIdentifier": "${ThingIdentifier}","ThingSecret": "${ThingSecret}","IMEI": "${IMEI}"}]   
    Log    ${data}
    #send api
    ${res}=    Post Api Request    ${URL_CENTRIC}${CENTRICAPIS}    ${URL_MAPPING_IMEI_CENTRIC}    ${headers}    ${data}
	Log    ${res}
    #check response
	${resultCode}=    Get From Dictionary    ${res}[0]     ${FIELD_RESULTCODE_IMPORT_THING}
	${resultCode_final}    Convert To String    ${resultCode}
	Log    ${resultCode_final}
	Log    ${RESULTCODE_MAPPINGIMEI}
	Should Be Equal    ${resultCode_final}    ${RESULTCODE_MAPPINGIMEI}
    Log    ${resultCode_final}	     	
	#[return]    ${GetResponse_ThingID}    ${GetResponse_IMSI}    ${GetResponse_ThingToken}

# CENTRIC : Create A Worker
CreateAWorkerCentric
    #prepare data
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	${random_number}=    generate random string    6    [NUMBERS]
	#WorkerName
    ${WorkerName}=    Set Variable    ${VALUE_WORKERNAME_ENTRIC}${random_number}
	#set header
	${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEWORKERCENTRIC}${current_timestamp}  
	Log    ${headers}
	#set body
    ${data}=    Evaluate    {"WorkerName": "${WorkerName}","ServerProperties": {"ServerIP": "127.0.2.2","ServerPort": "8080","ServerDomain": "Worker001.com"},"WorkerState": "Terminated "}
    Log    ${data}
    #send api
    ${res}=    Post Api Request    ${URL_CENTRIC}${CENTRICAPIS}    ${URL_CREATEWORKER_CENTRIC}    ${headers}    ${data}
	Log    ${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${OPERATION_STATUS_CREATEWORKER}
    Log    ${operationStatus}	
    ${WorkersInfo}=    Get From Dictionary    ${res}     ${FIELD_WORKERSINFO}   
	${WorkerId}=    Get From Dictionary    ${WorkersInfo}     ${FIELD_WORKERID}    
	[Return]    ${WorkerId}  

# CENTRIC : Assign Thing To Worker
AssignThingToWorkerCentric
    [Arguments]    ${WorkerID}    ${ThingID}
	${URL_ASSIGN_THING_CENTRIC}=    Set Variable    api/v1/Workers/${WorkerID}/Thing/Assign
    #prepare data
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	#set header
	${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEWORKERCENTRIC}${current_timestamp}  
	Log    ${headers}
	#set body
    ${data}=    Evaluate    [{"ThingId": "${ThingID}"}]   
    Log    ${data}
    #send api
    ${res}=    Post Api Request    ${URL_CENTRIC}${CENTRICAPIS}    ${URL_ASSIGN_THING_CENTRIC}    ${headers}    ${data}
	Log    ${res}
    #check response
	${resultCode}=    Get From Dictionary    ${res}[0]     ${FIELD_RESULTCODE_IMPORT_THING}
	Log    ${resultCode}
	${resultCode_final}    Convert To String    ${resultCode}
	Should Be Equal    ${resultCode_final}    ${RESULTCODE_IMPORTTHING}
    Log    ${resultCode_final}	     	
	#[return]    ${GetResponse_ThingID}    ${GetResponse_IMSI}    ${GetResponse_ThingToken}


# MGCORE : Activate Thing
ActivateThing
    [Arguments]    ${accessToken}    ${AccountId}    ${IMSI}    ${ICCID}    ${IMEI}
    #prepare data
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	#set header
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_ACTIVATETHING}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_ACTIVATETHING}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}    Accept=${HEADER_ACCEPT}    
	Log    ${headers}
	#set body
    ${data}=    Evaluate    [{"IMSI": "${IMSI}","ICCID" : "${ICCID}","IMEI": "${IMEI}"}]   
    Log    ${data}
    #send api
    ${res}=    Post Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_ACTIVATE_THING_CENTRIC}    ${headers}    ${data}
	Log    ${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${OPERATION_STATUS_ACTIVATE_THING}
    Log    ${operationStatus}	
    ${ActivateThing}=    Get From Dictionary    ${res}     ${FIELD_ACTIVATE_THING}  
	${Status}=    Get From Dictionary    ${ActivateThing}[0]     ${FIELD_STATUS}
	Should Be Equal    ${Status}    Success   
	${ThingID}=    Get From Dictionary    ${ActivateThing}[0]     ${FIELD_THINGID}       	
	[return]    ${ThingID}

# MGCORE : Signin
Signin
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_SIGNIN}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_SIGNIN}    Accept=${HEADER_ACCEPT}  
    ${data}=    Evaluate    {"username": "${SIGNIN_USERNAME}","password": "${SIGNIN_PASSOWORD}"}   
	${res}=    Post Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_SIGNIN}    ${headers}    ${data}
	
	Response ResultCode Should Have    ${res}    ${SINGNIN}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	#accessToken
	${accessToken}=    Get From Dictionary    ${res}     ${FIELD_ACCESSTOKEN}
	#Log To Console    ${accessToken}
	[return]    ${accessToken}

# MGCORE : ValidateToken
ValidateToken
    [Arguments]    ${accessToken}
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_VALIDATETOKEN}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_VALIDATETOKEN}    Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
	
    ${data}=    Evaluate    {"AccessToken": "${accessToken}"}   
	${res}=    Post Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_VALIDATETOKEN}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${VALIDATETOKEN}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}

# MGCORE : Create Partner	
Create Partner
    [Arguments]    ${accessToken}
    #Generate Random number
    ${random_number}=    generate random string    6    [NUMBERS]
	#PartnerName
	${PartnerName}=    Set Variable    ${VALUE_PARTNERNAME}${random_number}
	#MerchantContact
	${MerchantContact}=    Set Variable    ${VALUE_MERCHANTCONTACT}
	#CPID
	${CPID}=    Set Variable    ${VALUE_CPID}
	
	
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEPARTNER}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATEPARTNER}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
				
    ${data}=    Evaluate    {"PartnerName": "${PartnerName}","PartnerType": ["Supplier","Customer"],"PartnerDetail": {"MerchantContact": "${MerchantContact}","CPID": "${CPID}"},"Property": {"RouteEngine": "false"}}   
    #Log To Console    ${data}

    ${res}=    Post Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_CREATEPARTNER}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${CREATEPARTNER}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_PartnerId
    ${PartnerInfo}=    Get From Dictionary    ${res}     ${FIELD_PARTNERINFO}   
    #Log To Console    ${PartnerInfo}	
	${GetResponse_PartnerId}=    Get From Dictionary    ${PartnerInfo}     ${FIELD_PARTNERID}    
	#Log To Console    ${GetResponse_PartnerId}
    #AccountName
	${AccountName}=    Set Variable    ${VALUE_ACCOUNTNAME}${random_number}
    #Log To Console    ${AccountName} 
	#ConfigGroupName
	${ConfigGroupName}=    Set Variable    ${VALUE_CONFIGGROUPNAME}${random_number}
	#Log To Console    ${ConfigGroupName} 
	[return]    ${GetResponse_PartnerId}


# MGCORE : Create AccountName
Create AccountName
    [Arguments]    ${accessToken}    ${PartnerId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATEACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
	${randomSensorApp}=    Evaluate    random.randint(100000, 999999)    random			
    ${data}=    Evaluate    {"PartnerID": "${PartnerId}","AccountName": "TestAccoutNameAutomate_${randomSensorApp}"}   
    Log   ${data}
    ${res}=    Post Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_CREATEACCOUNT}    ${headers}    ${data}
	Log    ${res}
	Response ResultCode Should Have    ${res}    ${CREATEACCOUNT}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_AccountName
    ${PartnerInfo}=    Get From Dictionary    ${res}     ${FIELD_PARTNERINFO}   
    #Log To Console    ${PartnerInfo}	
	${AccountInfo}=    Get From Dictionary    ${PartnerInfo}     ${FIELD_ACCOUNTINFO}  
	#Log To Console    ${AccountInfo}	
	#GetResponse_AccountId
	${GetResponse_AccountId}=     Get From Dictionary    ${AccountInfo}[0]     ${FIELD_ACCOUNTID}    
    #Log To Console    ${GetResponse_AccountId} 
	
	[return]    ${GetResponse_AccountId}

# MGCORE : Create ThingStateInfo
Create ThingStateInfo
    [Arguments]    ${accessToken}    ${ThingId}    ${AccountId}    ${SensorKey}    ${random_Sensor}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATETHINGSTATEINFO}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATETHINGSTATEINFO}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
	#${random_Sensor}=    Set Variable    ${randomSensor1}
	#Log To Console    ${random_Sensor} 
	 
    ${data}=    Evaluate    {"ThingId": ["${ThingId}"],"Type": "${VALUE_TYPE}", "Sensor": {"${SensorKey}": "${random_Sensor}"}}   
    #Log To Console    ${data}

    ${res}=    Post Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_CREATETHINGSTATEINFO}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${CREATETHINGSTATEINFO}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	[return]    ${VALUE_TYPE}    ${SensorKey}    ${random_Sensor}  

# MGCORE : Create ControlThing
Create ControlThing
    [Arguments]    ${accessToken}    ${ThingId}    ${AccountId}    ${SensorKey}    ${random_Sensor}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATECONTROLTHING}${current_timestamp}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}			 
    ${data}=    Evaluate    {"ThingId": "${ThingId}", "Sensors": {"${SensorKey}": "${random_Sensor}"}}   
    #Log To Console    ${data}

    ${res}=    Post Api Request    ${URL}${CONTROLAPIS}    ${URL_CREATECONTROLTHING}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${CREATECONTROLTHING}    ${FIELD_OPERATIONSTATUS_LOWCASE}    ${FIELD_CODE_LOWCASE}    ${FIELD_DESCRIPTION_LOWCASE}
		
	[return]    ${random_Sensor}  

# MGCORE : Create ConfigGroup	
CreateConfigGroup
    [Arguments]    ${accessToken}    ${ThingId}    ${AccountId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATECONFIGGROUP}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATECONFIGGROUP}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
	#ConfigGroupName
	${random_number}=    Evaluate    random.randint(1000, 9999)    random	
    ${ConfigGroupName}=    Set Variable    ${CREATECONFIGGROUP}${random_number}
	#"ConfigInfo": {"RefreshTime": "On","Max": "99"}	 
    ${data}=    Evaluate    {"ConfigName": "${ConfigGroupName}","ThingId": ["${ThingId}"], "ConfigInfo": {"${VALUE_CONFIGINFO_KEY_REFRESHTIME}": "${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}","${VALUE_CONFIGINFO_KEY_MAX}": "${VALUE_CONFIGINFO_KEY_MAX_VALUE}"}}   
    #Log To Console    ${data}

    ${res}=    Post Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_CREATECONFIGGROUP}    ${headers}    ${data}
	Log    ${res}
	Response ResultCode Should Have    ${res}    ${CREATECONFIGGROUP}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	#GetResponse_ConfigGroupInfo
    ${ConfigGroupInfo}=    Get From Dictionary    ${res}     ${FIELD_CONFIGGROUPINFO}   
    #Log To Console    ${ConfigGroupInfo}	
	${GetResponse_ConfigGroupId}=    Get From Dictionary    ${ConfigGroupInfo}     ${FIELD_CONFIGGROUPID}    
    #Log To Console    GetResponse_ConfigGroupId${GetResponse_ConfigGroupId}	
	[return]    ${GetResponse_ConfigGroupId}    ${ConfigGroupName}

# MGCORE : Inquiry ThingMGCore
InquiryThingMGCore
    [Arguments]    ${accessToken}    ${ThingId}    ${AccountId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATECONFIGGROUP}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATECONFIGGROUP}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
	#"ConfigInfo": {"RefreshTime": "On","Max": "99"}	 
    ${data}=    Evaluate    {"ThingId": "${ThingId}"}   
    #Log To Console    ${data}

    ${res}=    Post Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_INQUIRYTHING}    ${headers}    ${data}
	Log    ${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${OPERATION_STATUS_INQUIRYTHING}
    Log    ${operationStatus}	
    ${ThingInfo}=    Get From Dictionary    ${res}     ${FIELD_THINGINFO}    	
	[return]    ${ThingInfo}[0]


# CENTRIC : Delete a Thing
DeleteThingCentric
    [Arguments]    ${ThingId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_DELETETHING_CENTRIC}${current_timestamp}  
	Log    ${headers} 
    ${res}=    Delete With Param    ${URL_CENTRIC}${CENTRICAPIS}    ${URL_DELETETHING_CENTRIC}    ${headers}    ${ThingId}
	Log    ${res}
	Log To Console  DeleteThingCentric : ${res}

# MGCORE : Remove Partner
Remove Partner
    [Arguments]    ${accessToken}    ${PartnerId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVEPARTNER}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVEPARTNER}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
				
    ${data}=    Evaluate    {"PartnerId": "${PartnerId}"}   
    #Log To Console    ${data}

    ${res}=    Delete Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_REMOVEPARTNER}    ${headers}    ${data}
	Log    ${res}
	Log To Console  DeletePartner : ${res}

# MGCORE : Remove AccountName	
Remove AccountName
    [Arguments]    ${accessToken}    ${PartnerId}    ${AccountId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVEACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVEACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
				
    ${data}=    Evaluate    {"PartnerID": "${PartnerId}","AccountId": "${AccountId}"}   
    #Log To Console    ${data}

    ${res}=    Delete Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_REMOVEACCOUNT}    ${headers}    ${data}
	Log    ${res}
	Log To Console  DeleteAccount : ${res}

# MGCORE : Remove Thing
Remove Thing
    [Arguments]    ${accessToken}    ${ThingID}    ${AccountId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVETHING}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVETHING}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
		
    ${data}=    Evaluate    {"ThingId": "${ThingID}"}   
    #Log To Console    ${data}

    ${res}=    Delete Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_REMOVETHING}    ${headers}    ${data}
	Log    ${res}
	Log To Console  DeleteThingMGCore : ${res}

Remove ThingStateInfo
    [Arguments]    ${url}    ${accessToken}    ${ThingId}    ${AccountId}    ${Type}    ${SensorKey}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVETHINGSTATEINFO}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVETHINGSTATEINFO}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}

    ${data}=    Evaluate    {"ThingId": "${ThingId}","stateType": "${Type}", "stateKey": "${SensorKey}"}   
    #Log To Console    ${data}
    ${res}=    Delete Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_REMOVETHINGSTATEINFO}    ${headers}    ${data}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${REMOVETHINGSTATEINFO}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}


Remove ThingFromAccount
    [Arguments]    ${accessToken}    ${AccountId}    ${ThingId}    
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVETHINGFROMACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVETHINGFROMACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}

    ${data}=    Evaluate    {"ThingId": ["${ThingID}"]}   
    #Log To Console    ${data}

    ${res}=    Delete Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_REMOVETHINGFROMACCOUNT}    ${headers}    ${data}
	#Log To Console    ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${REMOVETHINGFROMACCOUNT}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
Remove ConfigGroup
    [Arguments]    ${accessToken}    ${AccountId}    ${ConfigGroupId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVECONFIGGROUP}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVECONFIGGROUP}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}

    ${data}=    Evaluate    {"ConfigGroupId": "${ConfigGroupId}"}   
    #Log To Console    ${data}

    ${res}=    Delete Api Request    ${URL}${PROVISIONINGAPIS}    ${URL_REMOVECONFIGGROUP}    ${headers}    ${data}
	Log    ${res}
	Log To Console  DeleteConfigGroup : ${res}

Inquiry Thing
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${ThingID}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_INQUIRYTHING}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_INQUIRYTHING}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}    Accept=${HEADER_ACCEPT} 
	#Log To Console    headers${headers}				
    ${data}=    Evaluate    {"ThingId": "${ThingID}"}   
    #Log To Console    data${data}
    ${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_INQUIRYTHING}    ${headers}    ${data}
	#Log To Console    res${res}
	Response ResultCode Should Have    ${res}    ${INQUIRYTHING}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	[return]    ${res}

Inquiry ConfigGroup
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${ThingID}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_INQUIRYCONFIGGROUP}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_INQUIRYCONFIGGROUP}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}     Accept=${HEADER_ACCEPT} 
	#Log To Console    headers${headers}				
    ${data}=    Evaluate    {"ThingId": "${ThingID}"}   
    #Log To Console    data${data}
    ${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_INQUIRYCONFIGGROUP}    ${headers}    ${data}
	#Log To Console    res${res}
	Response ResultCode Should Have    ${res}    ${INQUIRYCONFIGGROUP}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	[return]    ${res}
	
Inquiry Account
    [Arguments]    ${url}    ${accessToken}    ${MobileNo}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_INQUIRYACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_INQUIRYACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}     Accept=${HEADER_ACCEPT} 
	#Log To Console    headers${headers}				
    ${data}=    Evaluate    {"AccountName": "${MobileNo}"}   
    #Log To Console    data${data}
    ${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_INQUIRYACCOUNT}    ${headers}    ${data}
	#Log To Console    res${res}
	Response ResultCode Should Have    ${res}    ${INQUIRYACCOUNT}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}	
	#GetResponse_AccountName
    ${PartnerInfo}=    Get From Dictionary    ${res}     ${FIELD_PARTNERINFO}   
    #Log To Console    ${PartnerInfo}	
	${AccountInfo}=    Get From Dictionary    ${PartnerInfo}[0]     ${FIELD_ACCOUNTINFO}  
	#Log To Console    ${AccountInfo}	
	${GetResponse_AccountName}=    Get From Dictionary    ${AccountInfo}[0]     ${FIELD_ACCOUNTNAME}    
	#Log To Console    ${GetResponse_AccountName}
	#GetResponse_AccountId
	${GetResponse_AccountId}=    Get From Dictionary    ${AccountInfo}[0]     ${FIELD_ACCOUNTID}    
    #Log To Console    ${GetResponse_AccountId} 
	[return]    ${GetResponse_AccountId}     ${GetResponse_AccountName}    




Update Account
    [Arguments]    ${url}    ${accessToken}    ${PartnerId}    ${AccountId}    ${AccountName}    ${ExpireDate}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVEACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVEACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  
	Log To Console    headers${headers}
				
    ${data}=    Evaluate    {"PartnerID": "${PartnerId}","AccountId": "${AccountId}","AccountName": "${AccountName}","ExpireDate": "${ExpireDate}","ClearExpireDate": "false"}   
    Log To Console    data${data}

    ${res}=    Put Api Request    ${url}${PROVISIONINGAPIS}    ${URL_UPDATEACCOUNT}    ${headers}    ${data}
	Log To Console    res${res}
	Response ResultCode Should Have    ${res}    ${UPDATEACCOUNT}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}


#==============================================================================
#                       API Asgard HTTP
#==============================================================================

# MGCORE : Asgard HTTP Register
AsgardHTTPRegister
    [Arguments]    ${authen}    ${expect_operationStatus}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	# Base64(IMSI:IPAddress)
	${accessToken}=    Evaluate    base64.b64encode(bytes('${authen}','utf-8'))
	${OrderRef}=    Set Variable    ${HEADER_X_AIS_ORDERREF_AsgardHTTP_REGISTER}${current_timestamp}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${OrderRef}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_AsgardHTTP}    Authorization=Basic ${accessToken}    Accept=${HEADER_ACCEPT}  
    Log To Console    ${\n} Url is : ${\n}${URL}${HTTPAIS}${URL_AsgardHTTPRegister}
	Log To Console    ${\n} Header is : ${\n}${headers}
    ${res}=    Post Api Request    ${URL}${HTTPAIS}    ${URL_AsgardHTTPRegister}    ${headers}    ${EMPTY}
	Log    ${res}
	Log To Console    ${\n}Response is : ${\n}${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${expect_operationStatus}
    Log    ${operationStatus_final}	 	
	[return]    ${res}    ${OrderRef}


AsgardHTTPRegisterNoauth
    [Arguments]    ${authen}    ${expect_operationStatus}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	# Base64(IMSI:IPAddress)
	${accessToken}=    Evaluate    base64.b64encode(bytes('${authen}','utf-8'))
	${OrderRef}=    Set Variable    ${HEADER_X_AIS_ORDERREF_AsgardHTTP_REGISTER}${current_timestamp}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${OrderRef}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_AsgardHTTP}    Accept=${HEADER_ACCEPT}  #Authorization=Basic ${accessToken}     
    Log To Console    ${\n} Url is : ${\n}${URL}${HTTPAIS}/${URL_AsgardHTTPRegister}
	Log To Console    ${\n} Header is : ${\n}${headers}
    ${res}=    Post Api Request    ${URL}${HTTPAIS}    ${URL_AsgardHTTPRegister}    ${headers}    ${EMPTY}
	Log    ${res}
	Log To Console    ${\n}Response is : ${\n}${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${expect_operationStatus}
    Log    ${operationStatus_final}	 	
	[return]    ${res}    ${OrderRef}

# MGCORE : Asgard HTTP Report
AsgardHTTPReport
    [Arguments]    ${authen}    ${expect_operationStatus}    ${Sensor_Key}    ${Sensor_Value}    ${Timestamp}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	# Base64(IMSI:IPAddress)
	${accessToken}=    Evaluate    base64.b64encode(bytes('${authen}','utf-8'))
	${OrderRef}=    Set Variable    ${HEADER_X_AIS_ORDERREF_AsgardHTTP_REPORT}${current_timestamp}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${OrderRef}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_AsgardHTTP}    Authorization=Basic ${accessToken}    Accept=${HEADER_ACCEPT}  
    
	Log To Console    ${\n} Url is : ${\n}${URL}${HTTPAIS}/${URL_AsgardHTTPReport}
	Log To Console    ${\n} Header is : ${\n}${headers}
	${data}=    Evaluate    {"Payload": {"${Sensor_Key}":"${Sensor_Value}", "Timestamp": "${Timestamp}"}}  
	Log To Console    ${\n} Body is : ${\n}${data} 
    ${res}=    Post Api Request    ${URL}${HTTPAIS}    ${URL_AsgardHTTPReport}    ${headers}    ${data}
	Log    ${res}
	Log To Console    ${\n}Response is : ${\n}${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${expect_operationStatus}
    Log    ${operationStatus_final}	 	
	[return]    ${res}    ${OrderRef}    ${data}

AsgardHTTPReportNoauth
    [Arguments]    ${authen}    ${expect_operationStatus}    ${Sensor_Key}    ${Sensor_Value}    ${Timestamp}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	# Base64(IMSI:IPAddress)
	${accessToken}=    Evaluate    base64.b64encode(bytes('${authen}','utf-8'))
	${OrderRef}=    Set Variable    ${HEADER_X_AIS_ORDERREF_AsgardHTTP_REPORT}${current_timestamp}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${OrderRef}   x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_AsgardHTTP}    Accept=${HEADER_ACCEPT}  #Authorization=Basic ${accessToken}     
    Log To Console    ${\n} Url is : ${\n}${URL}${HTTPAIS}/${URL_AsgardHTTPReport}
	Log To Console    ${\n} Header is : ${\n}${headers}
	${data}=    Evaluate    {"Payload": {"${Sensor_Key}":"${Sensor_Value}", "Timestamp": "${${Timestamp}}"}}  
	Log To Console    ${\n} Body is : ${\n}${data} 
    ${res}=    Post Api Request    ${URL}${HTTPAIS}    ${URL_AsgardHTTPReport}    ${headers}    ${data}
	Log    ${res}
	Log To Console    ${\n}Response is : ${\n}${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${expect_operationStatus}
    Log    ${operationStatus_final}	 	
	[return]    ${res}    ${OrderRef}

# MGCORE : Asgard HTTP Config
AsgardHTTPConfig
    [Arguments]    ${authen}    ${expect_operationStatus}    ${Sensor_Key}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	# Base64(IMSI:IPAddress)
	${accessToken}=    Evaluate    base64.b64encode(bytes('${authen}','utf-8'))
	${OrderRef}=    Set Variable    ${HEADER_X_AIS_ORDERREF_AsgardHTTP_CONFIG}${current_timestamp}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${OrderRef}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_AsgardHTTP}    Authorization=Basic ${accessToken}    Accept=${HEADER_ACCEPT}  
    Log To Console    ${\n} Url is : ${\n}${URL}${HTTPAIS}/${URL_AsgardHTTPConfig}
	Log To Console    ${\n} Header is : ${\n}${headers}
    ${res}=    Get Api Request    ${URL}${HTTPAIS}    ${URL_AsgardHTTPConfig}?Sensor=${Sensor_Key}    ${headers}
	Log    ${res}
	Log To Console    ${\n}Response is : ${\n}${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${expect_operationStatus}
    Log    ${operationStatus_final}	 	
	[return]    ${res}    ${OrderRef}

# MGCORE : Asgard HTTP Config
AsgardHTTPConfigNoauth
    [Arguments]    ${authen}    ${expect_operationStatus}    ${Sensor_Key}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	# Base64(IMSI:IPAddress)
	${accessToken}=    Evaluate    base64.b64encode(bytes('${authen}','utf-8'))
	${OrderRef}=    Set Variable    ${HEADER_X_AIS_ORDERREF_AsgardHTTP_CONFIG}${current_timestamp}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${OrderRef}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_AsgardHTTP}    Accept=${HEADER_ACCEPT}  #Authorization=Basic ${accessToken}  
    Log To Console    ${\n} Url is : ${\n}${URL}${HTTPAIS}/${URL_AsgardHTTPConfig}
	Log To Console    ${\n} Header is : ${\n}${headers}
    ${res}=    Get Api Request    ${URL}${HTTPAIS}    ${URL_AsgardHTTPConfig}?Sensor=${Sensor_Key}    ${headers}
	Log    ${res}
	Log To Console    ${\n}Response is : ${\n}${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${expect_operationStatus}
    Log    ${operationStatus_final}	 	
	[return]    ${res}    ${OrderRef}

# MGCORE : Asgard HTTP Config
AsgardHTTPDelta
    [Arguments]    ${authen}    ${expect_operationStatus}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	# Base64(IMSI:IPAddress)
	${accessToken}=    Evaluate    base64.b64encode(bytes('${authen}','utf-8'))
	${OrderRef}=    Set Variable    ${HEADER_X_AIS_ORDERREF_AsgardHTTP_CONFIG}${current_timestamp}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${OrderRef}   x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_AsgardHTTP}    Authorization=Basic ${accessToken}    Accept=${HEADER_ACCEPT}  
    Log To Console    ${\n} Url is : ${\n}${URL}${HTTPAIS}/${URL_AsgardHTTPDelta}
	Log To Console    ${\n} Header is : ${\n}${headers}
    ${res}=    Get Api Request    ${URL}${HTTPAIS}    ${URL_AsgardHTTPDelta}?Sensor    ${headers}
	Log    ${res}
	Log To Console    ${\n}Response is : ${\n}${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${expect_operationStatus}
    Log    ${operationStatus_final}	 	
	[return]    ${res}    ${OrderRef}

# MGCORE : Asgard HTTP Config
AsgardHTTPDeltaNoauth
    [Arguments]    ${authen}    ${expect_operationStatus}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	# Base64(IMSI:IPAddress)
	${accessToken}=    Evaluate    base64.b64encode(bytes('${authen}','utf-8'))
	${OrderRef}=    Set Variable    ${HEADER_X_AIS_ORDERREF_AsgardHTTP_CONFIG}${current_timestamp}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${OrderRef}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_AsgardHTTP}    Accept=${HEADER_ACCEPT}     #Authorization=Basic ${accessToken}     
    Log To Console    ${\n} Url is : ${\n}${URL}${HTTPAIS}/${URL_AsgardHTTPDelta}
	Log To Console    ${\n} Header is : ${\n}${headers}
    ${res}=    Get Api Request    ${URL}${HTTPAIS}    ${URL_AsgardHTTPDelta}?Sensor    ${headers}
	Log    ${res}
	Log To Console    ${\n}Response is : ${\n}${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${expect_operationStatus}
    Log    ${operationStatus_final}	 	
	[return]    ${res}    ${OrderRef}

# MGCORE : Asgard HTTP Charging
AsgardHTTPCharging
    [Arguments]    ${authen}    ${expect_operationStatus}    ${data}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	# Base64(IMSI:IPAddress)
	${accessToken}=    Evaluate    base64.b64encode(bytes('${authen}','utf-8'))
	${OrderRef}=    Set Variable    ${HEADER_X_AIS_ORDERREF_AsgardHTTP_REPORT}${current_timestamp}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${OrderRef}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_AsgardHTTP}    Authorization=Basic ${accessToken}    Accept=${HEADER_ACCEPT}  
    
	Log To Console    ${\n} Url is : ${\n}${URL}${HTTPAIS}/${URL_AsgardHTTPReport}
	Log To Console    ${\n} Header is : ${\n}${headers}
	Log To Console    ${\n} Body is : ${\n}${data} 
    ${res}=    Post Api Request    ${URL}${HTTPAIS}    ${URL_AsgardHTTPReport}    ${headers}    ${data}
	Log    ${res}
	Log To Console    ${\n}Response is : ${\n}${res}
    #check response
	${operationStatus}=    Get From Dictionary    ${res}     ${FIELD_OPERATION_STATUS}
	Log    ${operationStatus}
	${operationStatus_final}    Convert To String    ${operationStatus}
	Should Be Equal    ${operationStatus_final}    ${expect_operationStatus}
    Log    ${operationStatus_final}	 	
	[return]    ${res}    ${OrderRef}    ${data}