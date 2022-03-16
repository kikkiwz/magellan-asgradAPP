*** Keywords ***
####################################################
#                 Mainflow Verify DB
####################################################
Verify DB Check Data : ThingToken
	[Arguments]    ${getData}    ${thingToken}
	#accessToken,PartnerId,AccountId,ThingID,IMSI,ThingToken,Type,SensorKey,random_Sensor,AccountName
	${IMSI}=    Set Variable    ${getData}[4]
	${expect_thingToken}=    Set Variable    ${getData}[5]
	${actual_thingToken}=    Set Variable
	${Json_Search}=    Set Variable    {"IMEI" : "${IMSI}"} 
	# search data base
	ConnectMongodb
	${result}=    Search By Select Fields    ${MGCORE_DBNAME}    ${MGCORE_COLLECTION_THING}    ${Json_Search}    ThingToken,IMEI
	${actual_thingToken}=    Get From Dictionary    ${result}    ThingToken
	Disconnect From Mongodb
	# verify DB  
    Run Keyword And Continue On Failure    Should Not Be Equal    ${expect_thingToken}    ${actual_thingToken} 

Verify DB Check Data : Sensor
	[Arguments]    ${accessToken}   ${AccountId}    ${ThingID}    ${valueKey}
	#accessToken,AccountId,ThingID,thingToken
	Request Verify DB Check Data Report     ${accessToken}   ${AccountId}    ${ThingID}    ${valueKey}

Verify DB Check Data : Config [RefreshTime and Max]
	[Arguments]        ${accessToken}   ${AccountId}    ${ThingID}
	#accessToken,AccountId,ThingID,Sensor
	${dataCheck}=    Set Variable    {"${VALUE_CONFIGINFO_KEY_REFRESHTIME}":"${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}","${VALUE_CONFIGINFO_KEY_MAX}":"${VALUE_CONFIGINFO_KEY_MAX_VALUE}"}
	Request Verify DB Check Data Config    ${accessToken}   ${AccountId}    ${ThingID}    ${dataCheck}  

Verify DB Delta : Sensor
	[Arguments]    ${createResponse}    ${valueKey}
	${accessToken}=    Set Variable    ${createResponse}[1]
	${ThingID}=    Set Variable    ${createResponse}[3]
	${AccountId}=    Set Variable    ${createResponse}[5]
	#accessToken,AccountId,ThingID,Sensor
	Request Verify DB Check Data Delta     ${accessToken}   ${AccountId}    ${ThingID}    ${valueKey}
	


####################################################
#                 Function Verify DB
####################################################

Request Verify DB Check Data Report
	#accessToken,AccountId,ThingID,Sensor
    [Arguments]    ${accessToken}   ${AccountId}    ${ThingID}    ${sensor}
	
	${dataInquiryThing}=    Inquiry Thing    ${URL}    ${accessToken}    ${AccountId}    ${ThingID}   
	#Log To Console    ${dataInquiryThing}
	${thingInfo}=    Set Variable    ${dataInquiryThing['ThingInfo']}
	#Log To Console    ${thingInfo} 
	
	${data_count}=    Get Length    ${thingInfo}
	#Log To Console    data_count${data_count}  
	FOR    ${i}    IN RANGE    ${data_count}
	    ${dataResponse}=    Set Variable    ${thingInfo[${i}]}
		Log    ${dataResponse}
		${jsonLoadSensor}=    Evaluate    json.loads(r'''${sensor}''')    json
	    Log To Console    sensor${sensor}
	   
	    Check Json Data Should Be Equal    ${dataResponse}    ['StateInfo']['Report']    ${jsonLoadSensor}    StateInfo.Report
	END	
	
Request Verify DB Check Data Delta
	#accessToken,AccountId,ThingID,Sensor
    [Arguments]    ${accessToken}   ${AccountId}    ${ThingID}    ${sensor}
	
	${dataInquiryThing}=    Inquiry Thing    ${URL}    ${accessToken}    ${AccountId}    ${ThingID}   
	#Log To Console    ${dataInquiryThing}
	${thingInfo}=    Set Variable    ${dataInquiryThing['ThingInfo']}
	#Log To Console    ${thingInfo} 
	
	${data_count}=    Get Length    ${thingInfo}
	#Log To Console    data_count${data_count}  
	FOR    ${i}    IN RANGE    ${data_count}
	    ${dataResponse}=    Set Variable    ${thingInfo[${i}]}
		
		${jsonLoadSensor}=    Evaluate    json.loads(r'''${sensor}''')    json
	    #Log To Console    sensor${sensor}
	   
	    Check Json Data Should Be Equal    ${dataResponse}    ['StateInfo']['Delta']    ${jsonLoadSensor}    StateInfo.Delta
	END	
	
Request Verify DB Check Data Config
	#accessToken,AccountId,ThingID,Sensor
    [Arguments]    ${accessToken}   ${AccountId}    ${ThingID}    ${dataCheck}
	
	${dataInquiryConfigGroup}=    Inquiry ConfigGroup    ${URL}    ${accessToken}    ${AccountId}    ${ThingID}   
	#Log To Console    ${dataInquiryConfigGroup}
	${thingInfo}=    Set Variable    ${dataInquiryConfigGroup['ConfigGroupInfo']}
	#Log To Console    ${thingInfo} 
	
	${data_count}=    Get Length    ${thingInfo}
	#Log To Console    data_count${data_count}  
	FOR    ${i}    IN RANGE    ${data_count}
	    ${dataResponse}=    Set Variable    ${thingInfo[${i}]}
		
		${jsonLoaddataCheck}=    Evaluate    json.loads(r'''${dataCheck}''')    json
	    #Log To Console    dataCheck${dataCheck}
	   
	    Check Json Data Should Be Equal    ${dataResponse}    ['ConfigInfo']    ${jsonLoaddataCheck}    ConfigInfo
	END	


Request Verify DB Check historiesdata
    [Arguments]    ${ThingId}    ${AccountId}    ${OrderRef}    ${Sensor}    ${MobileNo}  
    Log To Console    ${\n}${\n}========== Check DB historiesdata ===============
    #search historiesdata
    ${result_historiesdata}=    Search Some Record    mgcore    historiesdata    {"OrderRef": "${OrderRef}","RemoveStatus" : false}
	Log    ${result_historiesdata}
	${historiesdataId}=    Get From Dictionary    ${result_historiesdata}    _id
	${historiesdata_createdDateTime}=    Get From Dictionary    ${result_historiesdata}    CreatedDateTime
	${historiesdata_lastUpdatedTimestamp}=    Get From Dictionary    ${result_historiesdata}    LastUpdatedTimestamp
	${historiesdata_accountId}=    Get From Dictionary    ${result_historiesdata}    AccountId
	${historiesdata_thingId}=    Get From Dictionary    ${result_historiesdata}    ThingId
	${historiesdata_orderRef}=    Get From Dictionary    ${result_historiesdata}    OrderRef
	${historiesdata_sensor}=    Get From Dictionary    ${result_historiesdata}    Sensors
	${historiesdata_documentSize}=    Get From Dictionary    ${result_historiesdata}    DocumentSize
	${historiesdata_dBThingDataSize}=    Get From Dictionary    ${result_historiesdata}    DBThingDataSize
	${historiesdata_rawThingDataSize}=    Get From Dictionary    ${result_historiesdata}    RawThingDataSize
	${historiesdata_thingDataSize}=    Get From Dictionary    ${result_historiesdata}    ThingDataSize
	${historiesdata_customersId}=    Get From Dictionary    ${result_historiesdata}    CustomerId
	${historiesdata_tenantId}=    Get From Dictionary    ${result_historiesdata}    TenantId
    #search customers
    ${result_customers}=    Search Some Record    mgcore    customers    {"CustomerName": "${MobileNo}","RemoveStatus" : false}
	Log    ${result_customers}
	${customersId}=    Get From Dictionary    ${result_customers}    _id

    #search tenants
    ${result_tenant}=    Search Some Record    mgcore    tenants    {"TenantName": "${MobileNo}","RemoveStatus" : false}
	Log    ${result_tenant}
	${tenantId}=    Get From Dictionary    ${result_tenant}    _id

    #check DB
	#{'_id': ObjectId('6164140a3bd89900018c8cdf'), 'RemoveStatus': False, 'CreatedDateTime': datetime.datetime(2021, 10, 11, 10, 38, 2, 977000), 'LastUpdatedTimestamp': datetime.datetime(2021, 10, 11, 10, 38, 2, 10000), 'AccountId': ObjectId('61641044ac02c988c09b2dff'), 'ThingId': ObjectId('6164140944f13b00017485c6'), 'OrderRef': 'AsgardHTTPREPORT_11102021173801', 'Protocol': 'HTTP', 'EventType': 'Report', 'Sensors': {'Lamp1inkitchenBrightness': 'On111111', 'Lamp2inkitchenBrightness': 1555555555, 'Lamp3inkitchenBrightness': 1555555555, 'Lamp4inkitchenBrightness': 1555555555, 'Lamp5inkitchenBrightness': 1555555555, 'Lamp6inkitchenBrightness': 1555555555, 'Lamp7inkitchenBrightness': 11555555555.0, 'Lamp8inkitchenBrightness': 1555555555, 'Lamp9inkitchenBrightness': 1555555555, 'Lamp10inkitchenBrightness': 1555555555, 'Lamp11inkitchenBrightness': 1555555555, 'minPercent': 111, 'maxPercent': 21111, 'minPercent111': 111111111111.0, 'maxPercent222': 21111111111111.0, 'maxPercent333': 2111111111111.0, 'maxPercent444': 2111111222222.0, 'Timestamp': 11102021173801.0}, 'DocumentSize': 752, 'DBThingDataSize': 789, 'RawThingDataSize': 699, 'ThingDataSize': 1157, 'CustomerId': ObjectId('6127324368dafb0001b3f672'), 'TenantId': ObjectId('6127324368dafb0001b3f67b')}
	${historiesdataId_str}=    Convert To String    ${historiesdataId}
	Should Not Be Empty    ${historiesdataId_str}
	${historiesdata_createdDateTime_str}=    Convert To String    ${historiesdata_createdDateTime}
	Should Not Be Empty    ${historiesdata_createdDateTime_str}
	${historiesdata_lastUpdatedTimestamp_str}=    Convert To String    ${historiesdata_lastUpdatedTimestamp}
	Should Not Be Empty    ${historiesdata_lastUpdatedTimestamp_str}
	${historiesdata_documentSize_str}=    Convert To String    ${historiesdata_documentSize}
	Should Not Be Empty    ${historiesdata_documentSize_str}
	${historiesdata_dBThingDataSize_str}=    Convert To String    ${historiesdata_dBThingDataSize}
	Should Not Be Empty    ${historiesdata_dBThingDataSize_str}
	${historiesdata_rawThingDataSize_str}=    Convert To String    ${historiesdata_rawThingDataSize}
	Should Not Be Empty    ${historiesdata_rawThingDataSize_str}
	${historiesdata_thingDataSize_str}=    Convert To String    ${historiesdata_thingDataSize}
	Should Not Be Empty    ${historiesdata_thingDataSize_str}
	${historiesdata_thingDataSize_str}=    Convert To String    ${historiesdata_thingDataSize}
	Should Not Be Empty    ${historiesdata_thingDataSize_str}
	Data Should Be Equal    ${AccountId}    ${historiesdata_accountId}    AccountId
	Data Should Be Equal    ${ThingId}    ${historiesdata_thingId}    ThingId
	Data Should Be Equal    ${OrderRef}    ${historiesdata_orderRef}    OrderRef
	Data Should Be Equal    ${Sensor}    ${historiesdata_sensor}    Sensor    
	Data Should Be Equal    ${customersId}    ${historiesdata_customersId}    CustomersId
	Data Should Be Equal    ${tenantId}    ${historiesdata_tenantId}    TenantId




Request Verify DB Check chargingtransactions
    [Arguments]    ${ThingId}    ${AccountId}    ${OrderRef}    ${MobileNo}  
    Log To Console    ${\n}${\n}========== Check DB chargingtransactions ===============
    #search chargingtransactions
    ${result_chargingtransactions}=    Search Some Record    mgcore    chargingtransactions    {"OrderRef": "${orderRef}","RemoveStatus" : false}
	Log    ${result_chargingtransactions}
	${chargingtransactionsId}=    Get From Dictionary    ${result_chargingtransactions}    _id
	${chargingtransactions_createdDateTime}=    Get From Dictionary    ${result_chargingtransactions}    CreatedDateTime
	${chargingtransactions_lastUpdatedTimestamp}=    Get From Dictionary    ${result_chargingtransactions}    LastUpdatedTimestamp
	${chargingtransactions_customersId}=    Get From Dictionary    ${result_chargingtransactions}    CustomerId
	${chargingtransactions_tenantId}=    Get From Dictionary    ${result_chargingtransactions}    TenantId
	${chargingtransactions_accountId}=    Get From Dictionary    ${result_chargingtransactions}    AccountId
	${chargingtransactions_thingId}=    Get From Dictionary    ${result_chargingtransactions}    ThingId
	${chargingtransactions_purchaseValue}=    Get From Dictionary    ${result_chargingtransactions}    PurchaseValue
	${chargingtransactions_purchaseName}=    Get From Dictionary    ${result_chargingtransactions}    PurchaseName
	${chargingtransactions_PurchaseType}=    Get From Dictionary    ${result_chargingtransactions}    PurchaseType
	${chargingtransactions_PurchaseId}=    Get From Dictionary    ${result_chargingtransactions}    PurchaseId
	${chargingtransactions_ChargingUnit}=    Get From Dictionary    ${result_chargingtransactions}    ChargingUnit
	${chargingtransactions_ChargingDateTime}=    Get From Dictionary    ${result_chargingtransactions}    ChargingDateTime
	${chargingtransactions_orderRef}=    Get From Dictionary    ${result_chargingtransactions}    OrderRef
	${chargingtransactions_SessionId}=    Get From Dictionary    ${result_chargingtransactions}    SessionId
	${chargingtransactions_UsageUnit}=    Get From Dictionary    ${result_chargingtransactions}    UsageUnit
	${chargingtransactions_HeaderbyBinarySize}=    Get From Dictionary    ${result_chargingtransactions}    HeaderbyBinarySize
	${chargingtransactions_PayloadbyBinarySize}=    Get From Dictionary    ${result_chargingtransactions}    PayloadbyBinarySize
	${chargingtransactions_TotalbyBinarySize}=    Get From Dictionary    ${result_chargingtransactions}    TotalbyBinarySize
	${chargingtransactions_MinSize}=    Get From Dictionary    ${result_chargingtransactions}    MinSize
	${chargingtransactions_MaxSize}=    Get From Dictionary    ${result_chargingtransactions}    MaxSize

    #search customers
    ${result_customers}=    Search Some Record    mgcore    customers    {"CustomerName": "${MobileNo}","RemoveStatus" : false}
	Log    ${result_customers}
	${customersId}=    Get From Dictionary    ${result_customers}    _id

    #search tenants
    ${result_tenant}=    Search Some Record    mgcore    tenants    {"TenantName": "${MobileNo}","RemoveStatus" : false}
	Log    ${result_tenant}
	${tenantId}=    Get From Dictionary    ${result_tenant}    _id

    #check DB
    ${chargingtransactionsId_str}=    Convert To String    ${chargingtransactionsId}
	Should Not Be Empty    ${chargingtransactionsId_str}
	${chargingtransactions_createdDateTime_str}=    Convert To String    ${chargingtransactions_createdDateTime}
	Should Not Be Empty    ${chargingtransactions_createdDateTime_str}
	${chargingtransactions_lastUpdatedTimestamp_str}=    Convert To String    ${chargingtransactions_lastUpdatedTimestamp}
	Should Not Be Empty    ${chargingtransactions_lastUpdatedTimestamp_str}
	Should Not Be Empty    ${chargingtransactions_PurchaseId}
	${chargingtransactions_ChargingUnit_str}=    Convert To String    ${chargingtransactions_ChargingUnit}
	Should Not Be Empty    ${chargingtransactions_ChargingUnit_str}
	${chargingtransactions_ChargingDateTime_str}=    Convert To String    ${chargingtransactions_ChargingDateTime}
	Should Not Be Empty    ${chargingtransactions_ChargingDateTime_str}
	Should Not Be Empty    ${chargingtransactions_SessionId}
	Should Not Be Empty    ${chargingtransactions_UsageUnit}
	Should Not Be Empty    ${chargingtransactions_HeaderbyBinarySize}
	Should Not Be Empty    ${chargingtransactions_PayloadbyBinarySize}
	Should Not Be Empty    ${chargingtransactions_TotalbyBinarySize}
	Should Not Be Empty    ${chargingtransactions_MinSize}
	Should Not Be Empty    ${chargingtransactions_MaxSize}

	Data Should Be Equal    ${customersId}    ${chargingtransactions_customersId}    CustomersId
	Data Should Be Equal    ${tenantId}    ${chargingtransactions_tenantId}    TenantId
	Data Should Be Equal    ${AccountId}    ${chargingtransactionsaccountId}    AccountId
	Data Should Be Equal    ${ThingId}    ${chargingtransactions_thingId}    ThingId
	Data Should Be Equal    ${MobileNo}    ${chargingtransactions_PurchaseValue}    PurchaseValue
	Data Should Be Equal    Magellan Transaction P1    ${chargingtransactions_purchaseName}    PurchaseName
	Data Should Be Equal    Transaction    ${chargingtransactions_PurchaseType}    PurchaseType
	Data Should Be Equal    ${OrderRef}    ${chargingtransactions_orderRef}    OrderRef


