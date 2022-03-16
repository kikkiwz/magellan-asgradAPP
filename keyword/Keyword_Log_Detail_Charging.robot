*** Keywords ***	
#use all not have endpointName (register,report,config,delta)
Check RequestObject Charging HTTP 
	[Arguments]    ${dataResponse}    ${pathUrl}    ${payload_body}    ${imsi_thingToken}
	#"{\"url\":\"[valuePathUrl]\",\"method\":\"POST\",\"headers\":{\"Content-Type\":\"[ContentType]\",\"Host\":\"[Host]\",\"Content-Length\":\"[ContentLength]\",\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[sessionid]\",\"x-forwarded-proto\":\"[xForwardedProto]\",\"x-request-id\":\"[xRequestId]\",\"x-b3-traceid\":\"[xB3Traceid]\",\"x-b3-spanid\":\"[xB3Spanid]\",\"x-b3-parentspanid\":\"[xB3Parentspanid]\",\"x-b3-sampled\":\"[xB3Sampled]\"},\"queryString\":{},\"routeParamteters\":{\"ThingId\":\"[ThingId]\"},\"body\":{\"Payload\":[body]}}"${resp_json}=    Evaluate    json.loads(r'''${dataResponse['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']}''')    json

    #search thingId
    Connect To Mongodb    mongodb://admin:ais.co.th@52.163.210.190:27018/mgcore?authSource=admin
    #search mongoDB
    ${result_thing}=    Search Some Record    mgcore    things    {"ThingToken": "${imsi_thingToken}"}
 	${thingId}=    Get From Dictionary    ${result_thing}    _id
 	${thingId_str}=    Convert To String    ${thingId}
    Disconnect From Mongodb

	${resp_json}=    Evaluate    json.loads(r'''${dataResponse['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']}''')    json
	#Log To Console    headers${resp_json['headers']['Content-Length']}
	#{"systemTimestamp":"11/10/2021 10:36:22.252","logType":"Detail","logLevel":"INFO","namespace":"magellan","applicationName":"Insight.Charging.APIs","containerId":"chargingapis-v385","sessionId":"1633923382161","tid":"AsgardHTTPREPORT_11102021103621","custom1":{"requestObject":"{\"url\":\"/api/v1/Charging/6163b135fd1f66000132f556\",\"method\":\"POST\",\"headers\":{\"Content-Type\":\"application/json\",\"Host\":\"chargingapis.magellan.svc.cluster.local\",\"Content-Length\":\"619\",\"x-ais-orderref\":\"AsgardHTTPREPORT_11102021103621\",\"x-ais-sessionid\":\"1633923382161\",\"x-forwarded-proto\":\"http\",\"x-request-id\":\"96c34072-ca78-4405-9f61-2e96f47fd645\",\"x-b3-traceid\":\"37001c236e5aeb37f187cc59e89d6568\",\"x-b3-spanid\":\"3cc02b9a75920a6d\",\"x-b3-parentspanid\":\"f187cc59e89d6568\",\"x-b3-sampled\":\"0\"},\"queryString\":{},\"routeParameters\":{\"ThingId\":\"6163b135fd1f66000132f556\"},\"body\":{\"Payload\":{\"Lamp1inkitchenBrightness\":\"On111111\",\"Lamp2inkitchenBrightness\":1555555555,\"Lamp3inkitchenBrightness\":1555555555,\"Lamp4inkitchenBrightness\":1555555555,\"Lamp5inkitchenBrightness\":1555555555,\"Lamp6inkitchenBrightness\":1555555555,\"Lamp7inkitchenBrightness\":11555555555,\"Lamp8inkitchenBrightness\":1555555555,\"Lamp9inkitchenBrightness\":1555555555,\"Lamp10inkitchenBrightness\":1555555555,\"Lamp11inkitchenBrightness\":1555555555,\"minPercent\":111,\"maxPercent\":21111,\"minPercent111\":111111111111,\"maxPercent222\":21111111111111,\"maxPercent333\":2111111111111,\"maxPercent444\":2111111222222,\"Timestamp\":\"11102021103621\"}}}","responseObject":"[{\"UsageUnit\":\"1057\",\"HeaderbyBinarySize\":\"450\",\"PayloadbyBinarySize\":\"607\",\"TotalbyBinarySize\":\"1057\",\"MinSize\":\"1024\",\"MaxSize\":\"4096\"}]","activityLog":{"startTime":"2021-10-11T10:36:22.2525696+07:00","endTime":"2021-10-11T10:36:23.3298028+07:00","processTime":1077.2332}},"custom2":null}
	${replaceValuePathUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_CHARGING_COAPAPP_APP_REPORT}    [valuePathUrl]    ${pathUrl}
	#body
	Log    payload expect "${payload_body}"
	Log    payload actual ${resp_json['body']['Payload']}
	${replacebody}=    Replace String    ${replaceValuePathUrl}    [body]    "${payload_body}"
	${replaceThingId}=    Replace String    ${replacebody}    [ThingId]    ${thingId_str}
	${replaceOrderref}=    Replace String    ${replaceThingId}    [tid]    ${resp_json['headers']['x-ais-orderref']}
	${replaceSessionid}=    Replace String    ${replaceOrderref}    [sessionid]    ${resp_json['headers']['x-ais-sessionid']}
	${replaceHost}=    Replace String    ${replaceSessionid}    [Host]    ${resp_json['headers']['Host']}
	${replaceContentType}=    Replace String    ${replaceHost}    [ContentType]    ${resp_json['headers']['Content-Type']}
	${replaceContentLength}=    Replace String    ${replaceContentType}    [ContentLength]    ${resp_json['headers']['Content-Length']}
	${replacexForwardedProto}=    Replace String    ${replaceContentLength}    [xForwardedProto]    ${resp_json['headers']['x-forwarded-proto']}
	${replacexRequestId}=    Replace String    ${replacexForwardedProto}    [xRequestId]    ${resp_json['headers']['x-request-id']}
	${replacexB3Traceid}=    Replace String    ${replacexRequestId}    [xB3Traceid]    ${resp_json['headers']['x-b3-traceid']}
	${replacexB3Spanid}=    Replace String    ${replacexB3Traceid}    [xB3Spanid]    ${resp_json['headers']['x-b3-spanid']}
	${replacexB3Parentspanid}=    Replace String    ${replacexB3Spanid}    [xB3Parentspanid]    ${resp_json['headers']['x-b3-parentspanid']}
	${replacexB3Sampled}=    Replace String    ${replacexB3Parentspanid}    [xB3Sampled]    ${resp_json['headers']['x-b3-sampled']}
	${requestObject}=    Replace String To Object    ${replacexB3Sampled}
	#Log To Console    requestObjectCoapAPIReport${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}
	
#use all have endpointName (register,report,config,delta)
Check RequestObject Charging HTTP With EndpointName
	[Arguments]    ${dataResponse}    ${pathUrl}    ${payload_body}
	#{"url":"api/v3/rocs/metering-method","method":"POST","headers":{"x-tid":"MG20211011145415592401","Authorization":"Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjZsNnVHMjZQSm8ifQ.eyJpc3MiOiJzcmYuYWlzLmNvLnRoL2FkbWQiLCJzdWIiOiJ0b2tlbl9jbGllbnRfY3JlZGVudGlhbHMiLCJhdWQiOiJpUWZ0RTF3cXJHS0JVRDhJT3hZWlJESHlTUlpwZ01YbDV4RE1YTFhzMVpBPSIsImV4cCI6MTYzODE2NDY0MSwiaWF0IjoxNjMyOTA4NjQxLCJqdGkiOiJqQlg4N2paMHMwNExXU3Vlb1AxTmVxIiwiY2xpZW50IjoiTXpVeU1qVXNUV0ZuWld4c1lXNThRbUZqYTJWdVpId3pMakF1TUE9PSIsInNzaWQiOiJKNmI1cVN3b2ZScUFFeEdDbTZEUmNkIn0.Vc4UeywcETYhjjEc082MpJX0YeFugKgnZlPJ4jmH_naK2siTJ7itF_DLlwKk11Qs5Ok3rohZqNXICrCGyJriA0jw92qk246FjDdSq4XmUsrAmmGFwylgn8h-sQVHEBVvLwsnQ3XktDLmmuF6BT0GQrkTOTslHvuD12eMM6Fl1b4"},"body":{"command":"usageMonitoring","sessionId":"1633938855924","tid":"MG20211011145415592401","rtid":"MG20211011145415592401","actualTime":"20211011145415","app":null,"clientId":null,"userType":"msisdn","userValue":"9400631821","resourceId":null,"resourceName":"Magellan Transaction P1","requestUnit":"1057","usageUnit":"1057"}}
    Log    ${dataResponse}
	${resp_json}=    Evaluate    json.loads(r'''${dataResponse['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']}''')    json

	${replaceValuePathUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_CHARGING_WITHENDPOINT}    [valuePathUrl]    ${URL_ROCS}
	${replaceXTID}=    Replace String    ${replaceValuePathUrl}    [x-tid]    ${resp_json['headers']['x-tid']}
	${replaceAuthorization}=    Replace String    ${replaceXTID}    [Authorization]    ${resp_json['headers']['Authorization']}
	${replacesessionId}=    Replace String    ${replaceAuthorization}    [sessionId]    ${resp_json['body']['sessionId']}
	${replacetid}=    Replace String    ${replacesessionId}    [tid]    ${resp_json['body']['tid']}
	${replacertid}=    Replace String    ${replacetid}    [rtid]    ${resp_json['body']['rtid']}
	${replaceactualTime}=    Replace String    ${replacertid}    [actualTime]    ${resp_json['body']['actualTime']}
	${replaceuserValue}=    Replace String    ${replaceactualTime}    [userValue]    ${resp_json['body']['userValue']}
	${replacerequestUnit}=    Replace String    ${replaceuserValue}    [requestUnit]    ${resp_json['body']['requestUnit']}
	${replaceusageUnit}=    Replace String    ${replacerequestUnit}    [usageUnit]    ${resp_json['body']['usageUnit']}
	${requestObject}=    Replace String To Object    ${replaceusageUnit}
	#Log To Console    requestObjectCoapAPIReport${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}
	

#-------------------------------------------- Charging : ResponseObject Success Do Not Have EndPointName --------------------------------------------#		    
Check ResponseObject App Success Charging HTTP 
    [Arguments]    ${code}    ${description}    ${dataResponse} 

	#{"systemTimestamp":"11/10/2021 10:36:22.252","logType":"Detail","logLevel":"INFO","namespace":"magellan","applicationName":"Insight.Charging.APIs","containerId":"chargingapis-v385","sessionId":"1633923382161","tid":"AsgardHTTPREPORT_11102021103621","custom1":{"requestObject":"{\"url\":\"/api/v1/Charging/6163b135fd1f66000132f556\",\"method\":\"POST\",\"headers\":{\"Content-Type\":\"application/json\",\"Host\":\"chargingapis.magellan.svc.cluster.local\",\"Content-Length\":\"619\",\"x-ais-orderref\":\"AsgardHTTPREPORT_11102021103621\",\"x-ais-sessionid\":\"1633923382161\",\"x-forwarded-proto\":\"http\",\"x-request-id\":\"96c34072-ca78-4405-9f61-2e96f47fd645\",\"x-b3-traceid\":\"37001c236e5aeb37f187cc59e89d6568\",\"x-b3-spanid\":\"3cc02b9a75920a6d\",\"x-b3-parentspanid\":\"f187cc59e89d6568\",\"x-b3-sampled\":\"0\"},\"queryString\":{},\"routeParameters\":{\"ThingId\":\"6163b135fd1f66000132f556\"},\"body\":{\"Payload\":{\"Lamp1inkitchenBrightness\":\"On111111\",\"Lamp2inkitchenBrightness\":1555555555,\"Lamp3inkitchenBrightness\":1555555555,\"Lamp4inkitchenBrightness\":1555555555,\"Lamp5inkitchenBrightness\":1555555555,\"Lamp6inkitchenBrightness\":1555555555,\"Lamp7inkitchenBrightness\":11555555555,\"Lamp8inkitchenBrightness\":1555555555,\"Lamp9inkitchenBrightness\":1555555555,\"Lamp10inkitchenBrightness\":1555555555,\"Lamp11inkitchenBrightness\":1555555555,\"minPercent\":111,\"maxPercent\":21111,\"minPercent111\":111111111111,\"maxPercent222\":21111111111111,\"maxPercent333\":2111111111111,\"maxPercent444\":2111111222222,\"Timestamp\":\"11102021103621\"}}}","responseObject":"[{\"UsageUnit\":\"1057\",\"HeaderbyBinarySize\":\"450\",\"PayloadbyBinarySize\":\"607\",\"TotalbyBinarySize\":\"1057\",\"MinSize\":\"1024\",\"MaxSize\":\"4096\"}]","activityLog":{"startTime":"2021-10-11T10:36:22.2525696+07:00","endTime":"2021-10-11T10:36:23.3298028+07:00","processTime":1077.2332}},"custom2":null}
	${resp_json}=    Evaluate    json.loads(r'''${dataResponse['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']}''')    json
    Log    ${resp_json}


	${replaceUsageUnit}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_CHARGING_COAPAPP_REPORT}    [UsageUnit]    ${resp_json[0]['UsageUnit']}
	${replaceUsageHeaderbyBinarySize}=    Replace String    ${replaceUsageUnit}    [HeaderbyBinarySize]    ${resp_json[0]['HeaderbyBinarySize']}
	${replaceUsagePayloadbyBinarySize}=    Replace String    ${replaceUsageHeaderbyBinarySize}    [PayloadbyBinarySize]    ${resp_json[0]['PayloadbyBinarySize']}
	${replaceUsageTotalbyBinarySize}=    Replace String    ${replaceUsagePayloadbyBinarySize}    [TotalbyBinarySize]    ${resp_json[0]['TotalbyBinarySize']}
	${replaceUsageMinSize}=    Replace String    ${replaceUsageTotalbyBinarySize}    [MinSize]    ${resp_json[0]['MinSize']}
	${replaceUsageMaxSize}=    Replace String    ${replaceUsageMinSize}    [MaxSize]    ${resp_json[0]['MaxSize']}
	${responseObject}=    Replace String To Object    [${replaceUsageMaxSize}]
	Log    responseObject${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}


Check ResponseObject App Success Charging HTTP With EndpointName 
    [Arguments]    ${dataResponse}    ${code}    ${description} 
    Log    ${dataResponse}
	#{\\"command\\":\\"usageMonitoring\\",\\"sessionId\\":\\"1633938855924\\",\\"tid\\":\\"MG20211011145415592401\\",\\"rtid\\":\\"MG20211011145415592401\\",\\"status\\":\\"200\\",             \\"devMessage\\":\\"SUCCESS\\"}
	${resp_json}=    Evaluate    json.loads(r'''${dataResponse['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']}''')    json
    Log    ${resp_json}
 
    Log To Console    ========================${resp_json}
	${resp_json_lass}=    Convert String To Json    ${resp_json}

	${replacesessionId}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_CHARGING_WITHENDPOINT_SUCCESS}    [sessionId]    ${resp_json_lass['sessionId']}
	${replacetid}=    Replace String    ${replacesessionId}    [tid]    ${resp_json_lass['tid']}
	${replacertid}=    Replace String    ${replacetid}    [rtid]    ${resp_json_lass['rtid']}
	${responseObject}=    Replace String To Object    "${replacertid}"
	Log    responseObject${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}