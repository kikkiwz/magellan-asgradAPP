*** Variables ***
#-------------------------------------------- signin --------------------------------------------#	
#path url signin
${URL_SIGNIN}    /api/v1/auth/signin

#header Signin
${HEADER_X_AIS_ORDERREF_SIGNIN}    Signin_
${HEADER_X_AIS_ORDERDESC_SIGNIN}    User Authentication


#response description
${VALUE_DESCRIPTION_SINGNIN_SUCCESS}    SignInProcess is Success

#request name
${SINGNIN}    Signin

#-------------------------------------------- ValidateToken --------------------------------------------#	
#path url ValidateToken
${URL_VALIDATETOKEN}    /api/v1/auth/ValidateToken

#header ValidateToken
${HEADER_X_AIS_ORDERREF_VALIDATETOKEN}    ValidateToken_
${HEADER_X_AIS_ORDERDESC_VALIDATETOKEN}    ValidateToken

#response description
${VALUE_DESCRIPTION_VALIDATETOKEN_SUCCESS}    ValidateTokenProcess is Success

#request name
${VALIDATETOKEN}    ValidateToken
#-------------------------------------------- Partner --------------------------------------------#	
#path url CreatePartner
${URL_CREATEPARTNER}    /api/v1/Partner/CreatePartner

#header CreatePartner
${HEADER_X_AIS_ORDERREF_CREATEPARTNER}    CreatePartner_
${HEADER_X_AIS_ORDERDESC_CREATEPARTNER}    CreatePartner

#value Create Partner
${VALUE_PARTNERNAME}    SC_
${VALUE_MERCHANTCONTACT}    Jida_TestMerchantContact@ais.co.th
${VALUE_CPID}    Jida_TesCPID@ais.co.th
${VALUE_ACCOUNTNAME}    Jida_TestAccountname
${VALUE_CONFIGGROUPNAME}    Sensor_TestThingGroupName

#response description
${VALUE_DESCRIPTION_CREATEPARTNER_SUCCESS}    CreatePartner is Success

#request name
${CREATEPARTNER}    CreatePartner
#-------------------------------------------- Account --------------------------------------------#	
#path url CreateAccount
${URL_CREATEACCOUNT}    /api/v1/Account/CreateAccount

#header CreateAccount
${HEADER_X_AIS_ORDERREF_CREATEACCOUNT}    CreateAccount_
${HEADER_X_AIS_ORDERDESC_CREATEACCOUNT}    CreateAccount

#response description
${VALUE_DESCRIPTION_CREATEACCOUNT_SUCCESS}    CreateAccount is Success

#request name
${CREATEACCOUNT}    CreateAccount
#-------------------------------------------- CreateThing --------------------------------------------#	
#path url CreateThing
${URL_CREATETHING}    /api/v1/Thing/CreateThing

#header CreateThing
${HEADER_X_AIS_ORDERREF_CREATETHING}    CreateThing_
${HEADER_X_AIS_ORDERDESC_CREATETHING}    CreateThing

#value Create CreateThing
${VALUE_THINGNAME}    ThingName

#response description
${VALUE_DESCRIPTION_CREATETHING_SUCCESS}    CreateThing is Success

#request name
${CREATETHING}    CreateThing


#-------------------------------------------- CreateThingStateInfo --------------------------------------------#	
#path url CreateThingStateInfo
${URL_CREATETHINGSTATEINFO}    /api/v1/Thing/CreateThingStateInfo

#header CreateThingStateInfo
${HEADER_X_AIS_ORDERREF_CREATETHINGSTATEINFO}    CreateThingStateInfo_
${HEADER_X_AIS_ORDERDESC_CREATETHINGSTATEINFO}    CreateThingStateInfo

#value Create ThingStateInfo
${VALUE_SENSORKEY}    Temp
${VALUE_SENSORKEY_CHARGING}    AA
${VALUE_TYPE}    Report

#response description
${VALUE_DESCRIPTION_CREATETHINGSTATEINFO_SUCCESS}    CreateThingStateInfo is Success

#request name
${CREATETHINGSTATEINFO}    CreateThingStateInfo
#-------------------------------------------- ConfigGroup --------------------------------------------#	
#path url CreateConfigGroup
${URL_CREATECONFIGGROUP}    /api/v1/ConfigGroup/CreateConfigGroup

#header CreateConfigGroup
${HEADER_X_AIS_ORDERREF_CREATECONFIGGROUP}    CreateConfigGroup_
${HEADER_X_AIS_ORDERDESC_CREATECONFIGGROUP}    CreateConfigGroup

#value Create ConfigGroup
#"ConfigInfo": {"RefreshTime": "On","Max": "99"}
${VALUE_CONFIGINFO_KEY_REFRESHTIME}    RefreshTime
${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}    On
${VALUE_CONFIGINFO_KEY_MAX}    Max
${VALUE_CONFIGINFO_KEY_MAX_VALUE}    99
#response description
${VALUE_DESCRIPTION_CREATECONFIGGROUP_SUCCESS}    CreateConfigGroup is Success

#request name
${CREATECONFIGGROUP}    CreateConfigGroup
#-------------------------------------------- Control --------------------------------------------#	
#path url Control
${URL_CREATECONTROLTHING}    /api/v1/Control/Thing

#header CreateControlthing
${HEADER_X_AIS_ORDERREF_CREATECONTROLTHING}    CreateControlthing_
${HEADER_X_AIS_ORDERDESC_CREATECONTROLTHING}    CreateControlthing
#response description
${VALUE_DESCRIPTION_CREATECONTROLTHING_SUCCESS}    ControlOneThing is Success

#request name
${CREATECONTROLTHING}    CreateControlthing



#-------------------------------------------- Other --------------------------------------------#	
#Other field
${FIELD_ACCESSTOKEN}    AccessToken    
${FIELD_PARTNERINFO}    PartnerInfo  
${FIELD_PARTNERID}    PartnerId  
${FIELD_ACCOUNTINFO}    AccountInfo  
${FIELD_ACCOUNTNAME}    AccountName  
${FIELD_ACCOUNTID}    AccountId  
${FIELD_THINGINFO}    ThingInfo  
${FIELD_THINGID}    ThingId 
${FIELD_IMSI}    IMSI   
${FIELD_THINGTOKEN}    ThingToken   
${FIELD_CONFIGGROUPINFO}    ConfigGroupInfo   
${FIELD_CONFIGGROUPID}    ConfigGroupId   
${FIELD_CONNECTIVITY}    ConnectivityType
${FIELD_THINGNAME}    ThingName
${FIELD_THINGIDEN}    ThingIdentifier
${FIELD_THINGSECRET}    ThingSecret
${FIELD_IMEI}    IMEI
${FIELD_WORKERSINFO}    WorkersInfo
${FIELD_WORKERID}    WorkerId
${FIELD_OPERATION_STATUS}    OperationStatus
${FIELD_RESULTCODE_IMPORT_THING}    Status
${FIELD_ACTIVATE_THING}    ActivateThing
${FIELD_STATUS}    Status
${FIELD_STATEINFO}    StateInfo
${FIELD_STATEINFO_REPORT}    Report
${FIELD_CUSTOMDETAILS}    CustomDetails
${FIELD_PAYLOAD}    Payload
#-------------------------------------------- CreateThing Centric --------------------------------------------#	
${URL_CREATETHING_CENTRIC}    /api/v1/Things
${HEADER_X_AIS_ORDERREF_CREATETHING_CENTRIC}    CreateThing_
${VALUE_THINGNAME_CENTRIC}    ThingNameCentric
${VALUE_CONECTIVITYTYPE_NBIOT}    NBIOT
${THINGIDENTIFIER_PREFIX}    896603
${VALUE_DESCRIPTION_CREATETHING_SUCCESS_CENTRIC}    CreateThing is Success
${CREATETHING_CENTRIC}    CreateThing
${OPERATION_STATUS_CREATETHING}    {'Code': '20000', 'DeveloperMessage': 'The requested operation was successfully.'}
#-------------------------------------------- DeleteThing Centric --------------------------------------------#	
${URL_DELETETHING_CENTRIC}    /api/v1/Things
${HEADER_X_AIS_ORDERREF_DELETETHING_CENTRIC}    DeleteThing_
${VALUE_THINGNAME_CENTRIC}    ThingNameCentric
${VALUE_CONECTIVITYTYPE_NBIOT}    NBIot
${THINGIDENTIFIER_PREFIX}    896603
${VALUE_DESCRIPTION_CREATETHING_SUCCESS_CENTRIC}    CreateThing is Success
${CREATETHING_CENTRIC}    CreateThing
${OPERATION_STATUS_CREATETHING}    {'Code': '20000', 'DeveloperMessage': 'The requested operation was successfully.'}
#-------------------------------------------- CreateWorker Centric --------------------------------------------#	
${URL_CREATEWORKER_CENTRIC}    /api/v1/Workers
${HEADER_X_AIS_ORDERREF_CREATEWORKERCENTRIC}    CreateWorker_
${VALUE_DESCRIPTION_CREATETHING_SUCCESS_CENTRIC}    CreateThing is Success
${VALUE_WORKERNAME_ENTRIC}    WORKERNameCentric
${OPERATION_STATUS_CREATEWORKER}    {'Code': '20000', 'DeveloperMessage': 'The requested operation was successfully.'}
#-------------------------------------------- Import Thing Centric --------------------------------------------#
${URL_IMPORTTHING_CENTRIC}    /api/v1/Things/Import
${VALUE_CONECTIVITYTYPE_IMPORT_SIM3G}    SIM3G
${VALUE_THINGNAME_IMPORT_CENTRIC}    ThingNameIMPORTCentric
${RESULTCODE_IMPORTTHING}    20100
#-------------------------------------------- MAPPING IMEI Centric --------------------------------------------#
${URL_MAPPING_IMEI_CENTRIC}    /api/v1/Things/Mapping/IMEI
${RESULTCODE_MAPPINGIMEI}    20000
#-------------------------------------------- Activate Thing --------------------------------------------#
${URL_ACTIVATE_THING_CENTRIC}    /api/v1/Thing/ActivateThing
${OPERATION_STATUS_ACTIVATE_THING}    {'Code': '20000', 'Description': 'ActivateThing is Success'}
#header CreatePartner
${HEADER_X_AIS_ORDERREF_ACTIVATETHING}    ActivateThing_
${HEADER_X_AIS_ORDERDESC_ACTIVATETHING}    ActivateThing
#-------------------------------------------- InquiryThing --------------------------------------------#
${URL_INQUIRYTHING}    /api/v1/Thing/InquiryThing
${OPERATION_STATUS_INQUIRYTHING}    {'Code': '20000', 'Description': 'InquiryThing is Success'}
#-------------------------------------------- AsgardHTTP--------------------------------------------#	
${URL_AsgardHTTPRegister}    /api/register/sim/v1
${URL_AsgardHTTPReport}    /api/report/sim/v1
${URL_AsgardHTTPConfig}    /api/config/sim/v1
${URL_AsgardHTTPDelta}    /api/delta/sim/v1
${URL_AsgardHTTPCharging}    /api/v1/Charging
${HEADER_X_AIS_ORDERREF_AsgardHTTP_REGISTER}    AsgardHTTPREGISTER_
${HEADER_X_AIS_ORDERREF_AsgardHTTP_REPORT}    AsgardHTTPREPORT_
${HEADER_X_AIS_ORDERREF_AsgardHTTP_CONFIG}    AsgardHTTPCONFIG_
${HEADER_X_AIS_ORDERREF_AsgardHTTP_DELTA}    AsgardHTTPDELTA_
${HEADER_X_AIS_ORDERDESC_AsgardHTTP}    AsgardHTTP

${OPERATION_STATUS_AsgardHTTPRegister_20000}    {'Code': '20000', 'DeveloperMessage': 'The requested operation was successfully.'}
${OPERATION_STATUS_AsgardHTTPRegister_40400}    {'Code': '40400', 'DeveloperMessage': 'The requested operation could not be found.'}
${OPERATION_STATUS_AsgardHTTPRegister_40103}    {'Code': '40103', 'DeveloperMessage': 'The token is Untrusted or Invalid.'}
${OPERATION_STATUS_AsgardHTTPRegister_40401}    {'Code': '40401', 'DeveloperMessage': 'The requested operation has been terminated.'}

#-------------------------------------------- Charging--------------------------------------------#	
# db customer = {"_id":ObjectId("60d3eed22d077d0001a75b1e"),"RemoveStatus":false,"CreatedDateTime":ISODate("2021-06-24T02:32:50.171Z"),"LastUpdatedTimestamp":ISODate("2021-06-24T02:32:50.171Z"),"CustomerName":"9400631662","CustomerType":"Enterprise","PurchaseInfo":{"PurchaseKey":"MSISDN","PurchaseValue":"9400631662","PurchaseName":"Magellan Transaction P1","PurchaseType":"Transaction","PurchaseState":"Active"},"ChargingStatus":"Enable"}
# db tenant = {"_id":ObjectId("60d3eed22d077d0001a75b1f"),"RemoveStatus":false,"CreatedDateTime":ISODate("2021-06-24T02:32:50.173Z"),"LastUpdatedTimestamp":ISODate("2021-06-24T02:32:50.173Z"),"CustomerId":ObjectId("60d3eed22d077d0001a75b1e"),"TenantName":"9400631662","TenantType":["Customer"]}
# db accounts = {"_id":ObjectId("602369f81fbd3f00016a056a"),"RemoveStatus":false,"CreatedDateTime":ISODate("2021-02-10T05:07:04.560Z"),"LastUpdatedTimestamp":ISODate("2021-02-10T05:07:04.560Z"),"TenantId":ObjectId("60d3eed22d077d0001a75b1f"),"AccountName":"9400631662","CustomDetails":{}} 
${PARTNERID}    6127324368dafb0001b3f67b
${ACCOUNTID}    6127324368dafb0001b3f67e
