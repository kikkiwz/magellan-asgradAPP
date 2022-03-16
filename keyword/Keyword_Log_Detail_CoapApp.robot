*** Keywords ***	
################################################################-- Have EndPointName --################################################################
#-------------------------------------------- CoapAPP Register Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Register : RequestObject Have EndPointName --------------------------------------------#	
Check RequestObject Success CoapAPP Register
	[Arguments]    ${dataResponse}    ${imsi}    ${ipAddress}    ${tid}    ${urlCmdName}
	#"{\"url\":\"[urlCmdName]\",\"method\":\"POST\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"body\":{\"Imsi\":\"[IMSI]\",\"IpAddress\":\"[IPADDRESS]\"}}"
	${replaceUrlCmdName}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_REGISTER}    [urlCmdName]    ${urlCmdName}
	${replacexAis}=    Replace String    ${replaceUrlCmdName}    [tid]    ${tid}
	${replaceIMSI}=    Replace String    ${replacexAis}    [IMSI]    ${imsi}
	${replaceIPAddress}=    Replace String    ${replaceIMSI}    [IPADDRESS]    ${ipAddress}
	${requestObject}=    Replace String To Object    ${replaceIPAddress}
	#Log To Console    requestObjectRegister${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}
#-------------------------------------------- CoapAPP Register : ResponseObject Success Have EndPointName --------------------------------------------#		    
Check ResponseObject Success CoapAPP Register
    [Arguments]    ${code}    ${description}    ${dataResponse}
	#"\"{\\\"ThingToken\\\":\\\"[ThingToken]\\\",\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""
	#${thingToken} received from Set Global Variable
	${replaceThingToken}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_CMDNAME_REGISTER}    [ThingToken]    ${thingToken}
	${replaceCode}=    Replace String    ${replaceThingToken}    [Code]    ${code}
	${replaceDescriptionCmdName}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
	${responseObject}=    Replace String To Object    ${replaceDescriptionCmdName}
	#Log To Console    responseObjectRegister${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}

#-------------------------------------------- CoapAPP Report Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Report : RequestObject Have EndPointName --------------------------------------------#	
Check RequestObject Success CoapAPP Report
	[Arguments]    ${dataResponse}    ${thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload}
	#"{\"url\":\"[urlCmdName]\",\"method\":\"POST\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"body\":{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\",\"Payloads\":[Payload],\"UnixTimestampMs\":[tid]}}"
	${replaceUrlCmdName}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_REPORT}    [urlCmdName]    ${urlCmdName}
	${replacexAis}=    Replace String    ${replaceUrlCmdName}    [tid]    ${tid}
	${replaceThingToken}=    Replace String    ${replacexAis}    [ThingToken]    ${thingToken}
	${replaceIPAddress}=    Replace String    ${replaceThingToken}    [IPADDRESS]    ${ipAddress}
	${replacePayload}=    Replace String    ${replaceIPAddress}    [Payload]    ${payload}
	${requestObject}=    Replace String To Object    ${replacePayload}
	Log    ${replaceUrlCmdName} is ${replaceUrlCmdName}    
	Log    ${replacexAis} is ${replacexAis}
	Log    ${replaceThingToken} is ${replaceThingToken}  
	Log    ${replaceIPAddress} is ${replaceIPAddress}  
	Log    ${replacePayload} is ${replacePayload}    
	Log    ${requestObject} is ${requestObject}
	#Log To Console    requestObject${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}	
#-------------------------------------------- CoapAPP Report : ResponseObject Success Have EndPointName --------------------------------------------#		    
Check ResponseObject Success CoapAPP Report
    [Arguments]    ${code}    ${description}    ${dataResponse}  
	#"\"{\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""
	${replaceCode}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_CMDNAME_REPORT}    [Code]    ${code}
	${replaceDescription}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
	${responseObject}=    Replace String To Object    ${replaceDescription}
	Log    ${replaceCode} is ${replaceCode}    
	Log    ${replaceDescription} is ${replaceDescription}
	Log    ${responseObject} is ${responseObject}  
	#Log To Console    responseObjectReport${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}

#-------------------------------------------- CoapAPP Config Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Config : RequestObject Have EndPointName --------------------------------------------#	
Check RequestObject Success CoapAPP Config
	[Arguments]    ${dataResponse}    ${thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload}
	#"{\"url\":\"[urlCmdName]\",\"method\":\"GET\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"queryString\":{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\"}}"
	#"{\"url\":\"[urlCmdName]\",\"method\":\"GET\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"queryString\":[queryString]}"
	
	#"url":"api/v1/Config?ThingToken=3a154161-03c1-4119-87cf-131995dae81e&IpAddress=1.2.3.4&Sensor=Max"
	#"url":"api/v1/Config?ThingToken=d1b348dc-455b-4578-9d88-ef8f21a3467d&IpAddress=1.2.3.4"
	
	#"queryString":{"ThingToken":"3a154161-03c1-4119-87cf-131995dae81e","IpAddress":"1.2.3.4"}}
	#"queryString":{"ThingToken":"3a154161-03c1-4119-87cf-131995dae81e","IpAddress":"1.2.3.4","Sensor":"Max"}}
	
	${splitUrl} =    Split String    ${urlCmdName}    &    2
	#Log To Console    splitUrl${splitUrl}
	${data_count}=    Get Length    ${splitUrl}
	#Log To Console    data_count${data_count}
	${setSensor}=    Set Variable If    ${data_count} == 3    ${splitUrl}[2]    ${EMPTY}     
	${removeSensor}=    Remove String    ${setSensor}    Sensor=   
	${valueSensor}=    Set Variable    ${removeSensor}
	#Log To Console    valueSensor${valueSensor}
	
	#{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\"}
	${replaceThingToken}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_QUERYSTRING_CONFIG}    [ThingToken]    ${thingToken}
	${replaceIPAddress}=    Replace String    ${replaceThingToken}    [IPADDRESS]    ${ipAddress}
	
	#{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\",\"Sensor\":\"[Sensor]\"}
	${replaceThingTokenSensor}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_QUERYSTRING_SENSOR_CONFIG}    [ThingToken]    ${thingToken}
	${replaceIPAddressSensor}=    Replace String    ${replaceThingTokenSensor}    [IPADDRESS]    ${ipAddress}
	${replaceSensor}=    Replace String    ${replaceIPAddressSensor}    [Sensor]    ${valueSensor}
	
	${valQueryString}=    Set Variable If    ${data_count} == 2    ${replaceIPAddress}    ${replaceSensor}
	#Log To Console    var1Payload${var1Payload}
	${replaceUrlCmdName}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_CONFIG}    [urlCmdName]    ${urlCmdName}
	${replacexAis}=    Replace String    ${replaceUrlCmdName}    [tid]    ${tid}
	${replaceQueryString}=    Replace String    ${replacexAis}    [queryString]    ${valQueryString}
	${requestObject}=    Replace String To Object    ${replaceQueryString}
	#Log To Console    requestObjectConfig${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}		
#------------------------------------------- CoapAPP Config : ResponseObject Success Have EndPointName --------------------------------------------#		    
Check ResponseObject Success CoapAPP Config
    [Arguments]    ${code}    ${description}    ${dataResponse}    ${urlCmdName}  
	#"\"{\\\"Datas\\\":[Datas],\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""
	#"Datas":{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\",\\\"Max\\\":\\\"[valueMax]\\\"}
	#"Datas":{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\"}
	#"Datas":{\\\"Max\\\":\\\"[valueMax]\\\"}
	
	${splitUrl} =    Split String    ${urlCmdName}    &    2
	#Log To Console    splitUrl${splitUrl}
	${data_count}=    Get Length    ${splitUrl}
	#Log To Console    data_count${data_count}
	
	${setSensor}=    Set Variable If    ${data_count} == 3    ${splitUrl}[2]    ${EMPTY}     
	${removeSensor}=    Remove String    ${setSensor}    Sensor=   
    ${valueSensor}=    Set Variable    ${removeSensor}
    #Log To Console    valueSensor${valueSensor}
	
	#{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\",\\\"Max\\\":\\\"[valueMax]\\\"}
	${replaceRefreshTimeAll}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_DATASALL_CONFIG}    [valueRefreshTime]    ${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}
	${replaceMaxAll}=    Replace String    ${replaceRefreshTimeAll}    [valueMax]    ${VALUE_CONFIGINFO_KEY_MAX_VALUE}
	
	#{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\"}
	${replaceRefreshTime}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_DATASREFRESHTIME_CONFIG}    [valueRefreshTime]    ${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}
	
	#{\\\"Max\\\":\\\"[valueMax]\\\"}
	${replaceMax}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_DATASMAX_CONFIG}    [valueMax]    ${VALUE_CONFIGINFO_KEY_MAX_VALUE}		
	
	${valDatas}=    Set Variable If    ${data_count} == 2    ${replaceMaxAll}
	...    ${data_count} == 3 and "${valueSensor}" == "${VALUE_CONFIGINFO_KEY_MAX}"     ${replaceMax}
	...    ${data_count} == 3 and "${valueSensor}" == "${VALUE_CONFIGINFO_KEY_REFRESHTIME}"     ${replaceRefreshTime} 
	#Log To Console    valDatas${valDatas}
	
	${replaceCode}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_CMDNAME_CONFIG}    [Code]    ${code}
	${replaceDescription}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
	${replaceDatas}=    Replace String    ${replaceDescription}    [Datas]    ${valDatas}
	${responseObject}=    Replace String To Object    ${replaceDatas}
	#Log To Console    responseObjectConfig${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
	
#-------------------------------------------- CoapAPP Delta Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Delta : RequestObject Have EndPointName --------------------------------------------#	
Check RequestObject Success CoapAPP Delta
	[Arguments]    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload}
	#"{\"url\":\"[urlCmdName]\",\"method\":\"GET\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"queryString\":{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\"}}"
	
	#"url":"api/v1/Delta?ThingToken=07b8df19-c85c-4381-9eae-3563aa6724ed&IpAddress=1.2.3.4\"
	#"url":"api/v1/Delta?ThingToken=8ba1f4bb-0ffc-42f9-b234-ceca95f171c1&IpAddress=1.2.3.4&Sensor=Temp"
	
	#"queryString":{"ThingToken":"3a154161-03c1-4119-87cf-131995dae81e","IpAddress":"1.2.3.4"}}
	#"queryString":{"ThingToken":"3a154161-03c1-4119-87cf-131995dae81e","IpAddress":"1.2.3.4","Sensor":"Temp"}}
	
	${splitUrl} =    Split String    ${urlCmdName}    &    2
	#Log To Console    splitUrl${splitUrl}
	${data_count}=    Get Length    ${splitUrl}
	#Log To Console    data_count${data_count}
	${setSensor}=    Set Variable If    ${data_count} == 3    ${splitUrl}[2]    ${EMPTY}     
	${removeSensor}=    Remove String    ${setSensor}    Sensor=   
	${valueSensor}=    Set Variable    ${removeSensor}
	#Log To Console    valueSensor${valueSensor}
	
	#{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\"}
	${replaceThingToken}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_QUERYSTRING_DELTA}    [ThingToken]    ${imsi_thingToken}
	${replaceIPAddress}=    Replace String    ${replaceThingToken}    [IPADDRESS]    ${ipAddress}
	
	#{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\",\"Sensor\":\"[Sensor]\"}
	${replaceThingTokenSensor}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_QUERYSTRING_SENSOR_DELTA}    [ThingToken]    ${imsi_thingToken}
	${replaceIPAddressSensor}=    Replace String    ${replaceThingTokenSensor}    [IPADDRESS]    ${ipAddress}
	${replaceSensor}=    Replace String    ${replaceIPAddressSensor}    [Sensor]    ${valueSensor}
	
	${valQueryString}=    Set Variable If    ${data_count} == 2    ${replaceIPAddress}    ${replaceSensor}
	#Log To Console    var1Payload${var1Payload}
	${replaceUrlCmdName}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_CONFIG}    [urlCmdName]    ${urlCmdName}
	${replacexAis}=    Replace String    ${replaceUrlCmdName}    [tid]    ${tid}
	${replaceQueryString}=    Replace String    ${replacexAis}    [queryString]    ${valQueryString}
	${requestObject}=    Replace String To Object    ${replaceQueryString}
	#Log To Console    requestObjectDelta${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}		
#------------------------------------------- CoapAPP Delta : ResponseObject Success Have EndPointName --------------------------------------------#		    
Check ResponseObject Success CoapAPP Delta
    [Arguments]    ${code}    ${description}    ${dataResponse}    ${payload} 
	#"\"{\\\"Datas\\\":[Datas],\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""
	#"Datas":{\\\"Temp\\\":\\\"883\\\"}

	${valDatas}=    Convert JSON To String    ${payload}    
	#Log To Console    valDatas${valDatas}
	
	${replaceCode}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_CMDNAME_CONFIG}    [Code]    ${code}
	${replaceDescription}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
	${replaceDatas}=    Replace String    ${replaceDescription}    [Datas]    ${valDatas}
	
	${responseObject}=    Replace String To Object    ${replaceDatas}
	#Log To Console    responseObjectDelta${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}


##############################################################################################################################################################
		
################################################################-- Do Not Have EndPointName --################################################################

#-------------------------------------------- CoapAPP Register Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Register : RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success CoapAPP Register 
    [Arguments]    ${dataResponse}    ${pathUrl}
	#"{\"url\":\"coap://localhost[valuePathUrl]\"}"
	${replaceUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_APP_REGISTER}    [valuePathUrl]    ${pathUrl}
	${requestObject}=    Replace String To Object    ${replaceUrl}
	#Log To Console    RegisterRequestObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}

#-------------------------------------------- CoapAPP Report Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Report : RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success CoapAPP Report
	[Arguments]    ${dataResponse}    ${pathUrl}    ${payload}    ${SensorKey}
	#"{\"url\":\"coap://localhost[valuePathUrl]\",\"body\":[body]}"
	${resp_json}=    Evaluate    json.loads(r'''${payload}''')    json
	${splitUrl} =    Split String    ${pathUrl}    ?    1
	Log    splitUrl${splitUrl}
	${data_count}=    Get Length    ${splitUrl}
	Log    data_count${data_count}
	${replacePayloadToString}=    Convert JSON To String    ${payload}   
    ${data}=    Get Data From PlayLoad    ${payload}    ${SensorKey}
	${valPayload}=    Set Variable If    ${data_count} != 1    ${data}
	...    ${replacePayloadToString}	
	${replaceUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_APP_REPORT}    [valuePathUrl]    ${pathUrl}
	${replaceBody}=    Replace String    ${replaceUrl}    [body]    "${valPayload}"
	${requestObject}=    Replace String To Object    ${replaceBody}
	#Log To Console    1requestObject${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}

Get Data From PlayLoad
	[Arguments]    ${payload}    ${SensorKey}
	${resp_json}=    Evaluate    json.loads(r'''${payload}''')    json
	${replacePayloadToString}=    Convert JSON To String    ${payload}
	${valPayload}=    Set Variable    ${resp_json['${SensorKey}']}
	[Return]    ${valPayload}


#-------------------------------------------- CoapAPP Config Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Config : RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success CoapAPP Config
	[Arguments]    ${dataResponse}    ${pathUrl}
	#"{\"url\":\"coap://localhost[valuePathUrl]\"}"
	${replaceUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_APP_CONFIG}    [valuePathUrl]    ${pathUrl}
	${requestObject}=    Replace String To Object    ${replaceUrl}
	#Log To Console    ConfigRequestObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}
#-------------------------------------------- CoapAPP Config : ResponseObject Do Not Have EndPointName --------------------------------------------#	
Check ResponseObject App Success CoapAPP Config
	[Arguments]    ${dataResponse}    ${urlCmdName}
	#"\"[requestObject]\""
	${splitUrl} =    Split String    ${urlCmdName}    &    2
	#Log To Console    splitUrl${splitUrl}
	${data_count}=    Get Length    ${splitUrl}
	#Log To Console    data_count${data_count}
	${setSensor}=    Set Variable If    ${data_count} == 3    ${splitUrl}[2]    ${EMPTY}     
	${removeSensor}=    Remove String    ${setSensor}    Sensor=   
    ${valueSensor}=    Set Variable    ${removeSensor}
    #Log To Console    valueSensor${valueSensor}
	#{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\",\\\"Max\\\":\\\"[valueMax]\\\"}
	${replaceRefreshTimeAll}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_DATASALL_CONFIG}    [valueRefreshTime]    ${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}
	${replaceMaxAll}=    Replace String    ${replaceRefreshTimeAll}    [valueMax]    ${VALUE_CONFIGINFO_KEY_MAX_VALUE}
	
	#{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\"}
	${replaceRefreshTime}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_DATASREFRESHTIME_CONFIG}    [valueRefreshTime]    ${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}
	
	#{\\\"Max\\\":\\\"[valueMax]\\\"}
	${replaceMax}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_DATASMAX_CONFIG1}    [valueMax]    ${VALUE_CONFIGINFO_KEY_MAX_VALUE}		
	#${replaceMax}=    Set Variable    ${VALUE_CONFIGINFO_KEY_MAX_VALUE}

	${valRequestObject}=    Set Variable If    ${data_count} == 2    ${replaceMaxAll}
	...    ${data_count} == 3 and "${valueSensor}" == "${VALUE_CONFIGINFO_KEY_MAX}"     "${VALUE_CONFIGINFO_KEY_MAX_VALUE}"
	...    ${data_count} == 3 and "${valueSensor}" == "${VALUE_CONFIGINFO_KEY_REFRESHTIME}"     ${replaceRefreshTime} 
    

	${result_type1}=    Case1    ${valRequestObject}
	${result_type2}=    Case2    ${valRequestObject}
	${requestObject}=    Set Variable If    ${data_count} == 2    ${result_type1}
	...    ${data_count} == 3    ${result_type2} 
	
    #Log To Console    ConfigResponseObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}

#-------------------------------------------- CoapAPP Delta Do Not Have EndPointName --------------------------------------------#	
#--------------- My Keyword --------
Case1
    [Arguments]    ${valRequestObject}
    ${replaceRequestObject}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_APP_CONFIG}    [requestObject]    ${valRequestObject}
	${requestObject}=    Replace String To Object    ${replaceRequestObject}   
	[return]    ${requestObject}

Case2
    [Arguments]    ${valRequestObject}
    ${requestObject}=    Set Variable    ${valRequestObject} 
	[return]    ${requestObject}

#-------------------------------------------- CoapAPP Delta : RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success CoapAPP Delta
	[Arguments]    ${dataResponse}    ${pathUrl}
	#"{\"url\":\"coap://localhost[valuePathUrl]\"}"
	${replaceUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_APP_CONFIG}    [valuePathUrl]    ${pathUrl}
	${requestObject}=    Replace String To Object    ${replaceUrl}
	#Log To Console    DeltaRequestObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ['${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}

#-------------------------------------------- CoapAPP Delta : ResponseObject Do Not Have EndPointName --------------------------------------------#	
Check ResponseObject App Success CoapAPP Delta
	[Arguments]    ${dataResponse}    ${payload}    ${vaalueSensor}    ${urlCmdName}
	#"\"[requestObject]\""
	${splitUrl} =    Split String    ${urlCmdName}    &    2
	#Log To Console    splitUrl${splitUrl}
	${data_count}=    Get Length    ${splitUrl}
    Log To Console   ====================================================== ${payload}
    ${data}=  Converting a JSON File    ${payload}
    Log To Console   ====================================================== ${data['Temp']}

	${result_type1}=    Delta Case1    ${payload}
	${result_type2}=    Set Variable    "${data['Temp']}"
	${requestObject}=    Set Variable If    ${data_count} == 2    ${result_type1}
	...    ${data_count} == 3    ${result_type2} 
	#"\"[requestObject]\""
	#${requestObject}=    Convert JSON To String    ${payload}    
	#Log To Console    DeltaResponseObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
		
##############################################################################################################################################################
Converting a JSON File
	[Arguments]    ${payload}
    ${MY_DATA_TABLE_VALUES}    evaluate  json.loads('''${payload}''')    json
    [Return]  ${MY_DATA_TABLE_VALUES}

Delta Case1
    [Arguments]    ${payload}
    ${requestObject}=    Convert JSON To String    ${payload}
	[Return]  ${requestObject}