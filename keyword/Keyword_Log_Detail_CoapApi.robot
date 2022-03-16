*** Keywords ***	
################################################################-- Have EndPointName --################################################################
#-------------------------------------------- CoapAPI Report Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPI Report : RequestObject Have EndPointName --------------------------------------------#	
Check RequestObject Success CoapAPI Report
	[Arguments]    ${dataResponse}    ${urlCmdName}    ${tid}    ${body}    ${thingToken}
	${replaceDataBody}=    Replace String    ${body}    [tid]    ${tid}
	#Log To Console    body${replaceDataBody}
    ${listAsString}=    Evaluate    json.dumps(${replaceDataBody})    json
	${resp_json}=    Evaluate    json.loads(r'''${listAsString}''')    json
	#Log To Console    headers
	${bodyToString}=    Convert JSON To String    ${resp_json['Payloads']}
	
	${valBody}=    Convert JSON To String    ${bodyToString}
	#Log To Console    valBody${valBody}
	${bodyRemoveSpace}=    Remove String    ${valBody}    ${SPACE}  
    #"{\"url\":\"internalreport.pub.v1.[ThingToken]\",\"headers\":{\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[tid]\",\"timestamp_in_ms\":\"[tid]\",\"x_protocol\":\"CoAP\"},\"body\":\"[body]\"}"
	${replaceUrlCmdName}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPI_CMDNAME_REPORT}    [ThingToken]    ${thingToken}
	${replaceBody}=    Replace String    ${replaceUrlCmdName}    [body]    ${bodyRemoveSpace}
	${replacexAis}=    Replace String    ${replaceBody}    [tid]    ${tid}
	${requestObject}=    Replace String To Object    ${replacexAis}
	#Log To Console    requestObjectCoapAPIReport${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}
	
##############################################################################################################################################################

################################################################-- Do Not Have EndPointName --################################################################
#-------------------------------------------- CoapAPI Register Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPI Register : RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success CoapAPI Register
	[Arguments]    ${dataResponse}    ${tid}    ${urlCmdName}    ${payload_body}    ${identity}    ${custom}    
	#"{\"url\":\"[valuePathUrl]\",\"method\":\"POST\",\"headers\":{\"Content-Type\":\"[ContentType]\",\"Host\":\"[Host]\",\"Content-Length\":\"[ContentLength]\",\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[tid]\",\"x-forwarded-proto\":\"[xForwardedProto]\",\"x-request-id\":\"[xRequestId]\",\"x-b3-traceid\":\"[xB3Traceid]\",\"x-b3-spanid\":\"[xB3Spanid]\",\"x-b3-sampled\":\"[xB3Sampled]\",\"identity\":\"[identity]\",\"custom\":\"[custom]\"},\"queryString\":{},\"routeParamteters\":{},\"body\":[body]}"
	${resp_json}=    Evaluate    json.loads(r'''${dataResponse['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']}''')    json
	#Log To Console    headers${resp_json['headers']['Content-Length']}
	
	${replaceValuePathUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPI_APP_REGISTER}    [valuePathUrl]    ${urlCmdName}
	#body
	${replacebody}=    Replace String    ${replaceValuePathUrl}    [body]    "${payload_body}"
	${replacexAis}=    Replace String    ${replacebody}    [tid]    ${tid}
	${replaceHost}=    Replace String    ${replacexAis}    [Host]    ${resp_json['headers']['Host']}
	${replaceContentType}=    Replace String    ${replaceHost}    [ContentType]    ${resp_json['headers']['Content-Type']}
	${replaceContentLength}=    Replace String    ${replaceContentType}    [ContentLength]    ${resp_json['headers']['Content-Length']}
	${replacexForwardedProto}=    Replace String    ${replaceContentLength}    [xForwardedProto]    ${resp_json['headers']['x-forwarded-proto']}
	${replacexRequestId}=    Replace String    ${replacexForwardedProto}    [xRequestId]    ${resp_json['headers']['x-request-id']}
	${replacexB3Traceid}=    Replace String    ${replacexRequestId}    [xB3Traceid]    ${resp_json['headers']['x-b3-traceid']}
	${replacexB3Spanid}=    Replace String    ${replacexB3Traceid}    [xB3Spanid]    ${resp_json['headers']['x-b3-spanid']}
	${replacexB3Sampled}=    Replace String    ${replacexB3Spanid}    [xB3Sampled]    ${resp_json['headers']['x-b3-sampled']}
	#identity
	${identityToString}=    Convert JSON To String    ${identity}  
	${replaceIdentity}=    Replace String    ${replacexB3Sampled}    [identity]    ${identityToString}
	#custom
	${setCustomToString}=    Set Variable    ${custom}
	${customJsonToString}=    Convert JSON To String    ${setCustomToString}
	#${customToString}=    Convert JSON To String    ${customJsonToString}
	${customRemoveSpace}=    Remove String    ${customJsonToString}    ${SPACE}  
	${replaceCustom}=    Replace String    ${replaceIdentity}    [custom]    ${customRemoveSpace}
	${requestObject}=    Replace String To Object    ${replaceCustom}
	#Log To Console    requestObjectCoapAPIRegister${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}
#-------------------------------------------- CoapAPI Register : ResponseObject Success Do Not Have EndPointName --------------------------------------------#		    
Check ResponseObject App Success CoapAPI Register
    [Arguments]    ${code}    ${description}    ${dataResponse}
	#"{"ThingToken":"[ThingToken]","OperationStatus":{"Code":"[Code]","DeveloperMessage":[DeveloperMessage]
	#${thingToken} received from Set Global Variable	
	${replaceThingToken}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_REGISTER}    [ThingToken]    ${thingToken}
	${replaceCode}=    Replace String    ${replaceThingToken}    [Code]    ${code}
	${replaceDeveloperMessage}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
	${responseObject}=    Replace String To Object    ${replaceDeveloperMessage}
	#Log To Console    responseObjectCoapAPIRegister${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}

#-------------------------------------------- CoapAPI Report Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPI Report : RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success CoapAPI Report
	[Arguments]    ${dataResponse}    ${tid}    ${urlCmdName}    ${payload_body}    ${identity}    ${custom}    
	#"{\"url\":\"[valuePathUrl]\",\"method\":\"POST\",\"headers\":{\"Content-Type\":\"[ContentType]\",\"Host\":\"[Host]\",\"Content-Length\":\"[ContentLength]\",\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[tid]\",\"x-forwarded-proto\":\"[xForwardedProto]\",\"x-request-id\":\"[xRequestId]\",\"x-b3-traceid\":\"[xB3Traceid]\",\"x-b3-spanid\":\"[xB3Spanid]\",\"x-b3-sampled\":\"[xB3Sampled]\",\"identity\":\"[identity]\",\"custom\":\"[custom]\"},\"queryString\":{},\"routeParamteters\":{},\"body\":[body]}"
	${resp_json}=    Evaluate    json.loads(r'''${dataResponse['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']}''')    json
	#Log To Console    headers${resp_json['headers']['Content-Length']}
	
	${replaceValuePathUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPI_APP_REPORT}    [valuePathUrl]    ${urlCmdName}
	#body
	${replacebody}=    Replace String    ${replaceValuePathUrl}    [body]    "${payload_body}"
	${replacexAis}=    Replace String    ${replacebody}    [tid]    ${tid}
	${replaceHost}=    Replace String    ${replacexAis}    [Host]    ${resp_json['headers']['Host']}
	${replaceContentType}=    Replace String    ${replaceHost}    [ContentType]    ${resp_json['headers']['Content-Type']}
	${replaceContentLength}=    Replace String    ${replaceContentType}    [ContentLength]    ${resp_json['headers']['Content-Length']}
	${replacexForwardedProto}=    Replace String    ${replaceContentLength}    [xForwardedProto]    ${resp_json['headers']['x-forwarded-proto']}
	${replacexRequestId}=    Replace String    ${replacexForwardedProto}    [xRequestId]    ${resp_json['headers']['x-request-id']}
	${replacexB3Traceid}=    Replace String    ${replacexRequestId}    [xB3Traceid]    ${resp_json['headers']['x-b3-traceid']}
	${replacexB3Spanid}=    Replace String    ${replacexB3Traceid}    [xB3Spanid]    ${resp_json['headers']['x-b3-spanid']}
	${replacexB3Sampled}=    Replace String    ${replacexB3Spanid}    [xB3Sampled]    ${resp_json['headers']['x-b3-sampled']}
	#identity
	${identityToString}=    Convert JSON To String    ${identity}  
	${replaceIdentity}=    Replace String    ${replacexB3Sampled}    [identity]    ${identityToString}
	#custom
	${setCustomToString}=    Set Variable    ${custom}
	${customJsonToString}=    Convert JSON To String    ${setCustomToString}
	#${customToString}=    Convert JSON To String    ${customJsonToString}
	${customRemoveSpace}=    Remove String    ${customJsonToString}    ${SPACE}  
	${replaceCustom}=    Replace String    ${replaceIdentity}    [custom]    ${customRemoveSpace}
	${requestObject}=    Replace String To Object    ${replaceCustom}
	#Log To Console    requestObjectCoapAPIReport${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}
#-------------------------------------------- CoapAPI Report : ResponseObject Success Do Not Have EndPointName --------------------------------------------#		    
Check ResponseObject App Success CoapAPI Report
    [Arguments]    ${code}    ${description}    ${dataResponse}
	#"{\"OperationStatus\":{\"Code\":\"[Code]\",\"DeveloperMessage\":\"[DeveloperMessage]\"}}"
	#${thingToken} received from Set Global Variable	
	${replaceCode}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_REPORT}    [Code]    ${code}
	${replaceDeveloperMessage}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
	${responseObject}=    Replace String To Object    ${replaceDeveloperMessage}
	#Log To Console    responseObjectCoapAPIReport${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}

#-------------------------------------------- CoapAPI Config Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPI Config : RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success CoapAPI Config
	[Arguments]    ${dataResponse}    ${tid}    ${urlCmdName}    ${payload_body}    ${identity}    ${custom}    
	#"{\"url\":\"[valuePathUrl]\",\"method\":\"GET\",\"headers\":{\"Host\":\"[Host]\",\"Content-Length\":\"[ContentLength]\",\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[tid]\",\"x-forwarded-proto\":\"[xForwardedProto]\",\"x-request-id\":\"[xRequestId]\",\"x-b3-traceid\":\"[xB3Traceid]\",\"x-b3-spanid\":\"[xB3Spanid]\",\"x-b3-sampled\":\"[xB3Sampled]\",\"identity\":\"[identity]\",\"custom\":\"[custom]\"},\"queryString\":[queryString],\"routeParamteters\":{}}"
	${resp_json}=    Evaluate    json.loads(r'''${dataResponse['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']}''')    json
	#Log To Console    headers${resp_json['headers']['Content-Length']}
	
	${replaceValuePathUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPI_APP_CONFIG}    [valuePathUrl]    ${urlCmdName}
	#body
	${replacebody}=    Replace String    ${replaceValuePathUrl}    [queryString]    "${payload_body}"
	${replacexAis}=    Replace String    ${replacebody}    [tid]    ${tid}
	${replaceHost}=    Replace String    ${replacexAis}    [Host]    ${resp_json['headers']['Host']}
	${replaceContentLength}=    Replace String    ${replaceHost}    [ContentLength]    ${resp_json['headers']['Content-Length']}
	${replacexForwardedProto}=    Replace String    ${replaceContentLength}    [xForwardedProto]    ${resp_json['headers']['x-forwarded-proto']}
	${replacexRequestId}=    Replace String    ${replacexForwardedProto}    [xRequestId]    ${resp_json['headers']['x-request-id']}
	${replacexB3Traceid}=    Replace String    ${replacexRequestId}    [xB3Traceid]    ${resp_json['headers']['x-b3-traceid']}
	${replacexB3Spanid}=    Replace String    ${replacexB3Traceid}    [xB3Spanid]    ${resp_json['headers']['x-b3-spanid']}
	${replacexB3Sampled}=    Replace String    ${replacexB3Spanid}    [xB3Sampled]    ${resp_json['headers']['x-b3-sampled']}
	#identity
	${identityToString}=    Convert JSON To String    ${identity}  
	${replaceIdentity}=    Replace String    ${replacexB3Sampled}    [identity]    ${identityToString}
	#custom
	${setCustomToString}=    Set Variable    ${custom}
	${customJsonToString}=    Convert JSON To String    ${setCustomToString}
	#${customToString}=    Convert JSON To String    ${customJsonToString}
	${customRemoveSpace}=    Remove String    ${customJsonToString}    ${SPACE}  
	${replaceCustom}=    Replace String    ${replaceIdentity}    [custom]    ${customRemoveSpace}
	${requestObject}=    Replace String To Object    ${replaceCustom}
	#Log To Console    requestObjectCoapAPIConfig${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}
#-------------------------------------------- CoapAPI Config : ResponseObject Success Do Not Have EndPointName --------------------------------------------#	
Check ResponseObject App Success CoapAPI Config
    [Arguments]    ${code}    ${description}    ${dataResponse}    ${pathUrl}
	#"{\"Datas\":[Datas],\"OperationStatus\":{\"Code\":\"[Code]\",\"DeveloperMessage\":\"[DeveloperMessage]\"}}"
	
	${splitUrl} =    Split String    ${pathUrl}    ?    2
	#Log To Console    splitUrl${splitUrl}
	${data_count}=    Get Length    ${splitUrl}
	#Log To Console    data_count${data_count}
	${setSensor}=    Set Variable If    ${data_count} == 2    ${splitUrl}[1]    ${EMPTY}     
	#${removeSensor}=    Remove String    ${setSensor}    Sensor=   
    ${valueSensor}=    Set Variable    ${setSensor}
    #Log To Console    valueSensor${valueSensor}
	#{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\",\\\"Max\\\":\\\"[valueMax]\\\"}
	${replaceRefreshTimeAll}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_DATASALL_CONFIG}    [valueRefreshTime]    ${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}
	${replaceMaxAll}=    Replace String    ${replaceRefreshTimeAll}    [valueMax]    ${VALUE_CONFIGINFO_KEY_MAX_VALUE}
	
	#{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\"}
	${replaceRefreshTime}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_DATASREFRESHTIME_CONFIG}    [valueRefreshTime]    ${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}
	
	#{\\\"Max\\\":\\\"[valueMax]\\\"}
	${replaceMax}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_DATASMAX_CONFIG}    [valueMax]    ${VALUE_CONFIGINFO_KEY_MAX_VALUE}		
	
	${valRequestObject}=    Set Variable If    ${data_count} == 1    ${replaceMaxAll}
	...    ${data_count} == 2 and "${valueSensor}" == "${VALUE_CONFIGINFO_KEY_MAX}"     ${replaceMax}
	...    ${data_count} == 2 and "${valueSensor}" == "${VALUE_CONFIGINFO_KEY_REFRESHTIME}"     ${replaceRefreshTime} 
	#Log To Console    valRequestObject${valRequestObject}
	
	
	${replaceCode}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_CONFIG}    [Code]    ${code}
	${replaceDeveloperMessage}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
	${replaceDatas}=    Replace String    ${replaceDeveloperMessage}    [Datas]    ${valRequestObject}
	${responseObject}=    Replace String To Object    ${replaceDatas}
	#Log To Console    responseObjectCoapAPIConfig${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}

#-------------------------------------------- CoapAPI Delta Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPI Delta : RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success CoapAPI Delta
	[Arguments]    ${dataResponse}    ${tid}    ${urlCmdName}    ${payload_body}    ${identity}    ${custom}    
	#"{\"url\":\"[valuePathUrl]\",\"method\":\"GET\",\"headers\":{\"Host\":\"[Host]\",\"Content-Length\":\"[ContentLength]\",\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[tid]\",\"x-forwarded-proto\":\"[xForwardedProto]\",\"x-request-id\":\"[xRequestId]\",\"x-b3-traceid\":\"[xB3Traceid]\",\"x-b3-spanid\":\"[xB3Spanid]\",\"x-b3-sampled\":\"[xB3Sampled]\",\"identity\":\"[identity]\",\"custom\":\"[custom]\"},\"queryString\":[queryString],\"routeParamteters\":{}}"
	${resp_json}=    Evaluate    json.loads(r'''${dataResponse['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']}''')    json
	#Log To Console    headers${resp_json['headers']['Content-Length']}
	
	${replaceValuePathUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPI_APP_CONFIG}    [valuePathUrl]    ${urlCmdName}
	#body
	${replacebody}=    Replace String    ${replaceValuePathUrl}    [queryString]    "${payload_body}"
	${replacexAis}=    Replace String    ${replacebody}    [tid]    ${tid}
	${replaceHost}=    Replace String    ${replacexAis}    [Host]    ${resp_json['headers']['Host']}
	${replaceContentLength}=    Replace String    ${replaceHost}    [ContentLength]    ${resp_json['headers']['Content-Length']}
	${replacexForwardedProto}=    Replace String    ${replaceContentLength}    [xForwardedProto]    ${resp_json['headers']['x-forwarded-proto']}
	${replacexRequestId}=    Replace String    ${replacexForwardedProto}    [xRequestId]    ${resp_json['headers']['x-request-id']}
	${replacexB3Traceid}=    Replace String    ${replacexRequestId}    [xB3Traceid]    ${resp_json['headers']['x-b3-traceid']}
	${replacexB3Spanid}=    Replace String    ${replacexB3Traceid}    [xB3Spanid]    ${resp_json['headers']['x-b3-spanid']}
	${replacexB3Sampled}=    Replace String    ${replacexB3Spanid}    [xB3Sampled]    ${resp_json['headers']['x-b3-sampled']}
	#identity
	${identityToString}=    Convert JSON To String    ${identity}  
	${replaceIdentity}=    Replace String    ${replacexB3Sampled}    [identity]    ${identityToString}
	#custom
	${setCustomToString}=    Set Variable    ${custom}
	${customJsonToString}=    Convert JSON To String    ${setCustomToString}
	#${customToString}=    Convert JSON To String    ${customJsonToString}
	${customRemoveSpace}=    Remove String    ${customJsonToString}    ${SPACE}  
	${replaceCustom}=    Replace String    ${replaceIdentity}    [custom]    ${customRemoveSpace}
	${requestObject}=    Replace String To Object    ${replaceCustom}
	#Log To Console    requestObjectCoapAPIDelta${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}
#-------------------------------------------- CoapAPI Delta : ResponseObject Success Do Not Have EndPointName --------------------------------------------#	
Check ResponseObject App Success CoapAPI Delta
    [Arguments]    ${code}    ${description}    ${dataResponse}    ${pathUrl}    ${valueKey}
	#"{\"Datas\":[Datas],\"OperationStatus\":{\"Code\":\"[Code]\",\"DeveloperMessage\":\"[DeveloperMessage]\"}}"
		
	${replaceCode}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_DELTA}    [Code]    ${code}
	${replaceDeveloperMessage}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
	#${valueKey} received from Set Global Variable
    Log    ${valueKey}
	${replaceDatas}=    Replace String    ${replaceDeveloperMessage}    [Datas]    ${valueKey}
	${responseObject}=    Replace String To Object    ${replaceDatas}
	#Log To Console    responseObjectCoapAPIDelta${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
