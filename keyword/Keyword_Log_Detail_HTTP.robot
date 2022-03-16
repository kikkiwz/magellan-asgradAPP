*** Keywords ***	
#use all not have endpointName (register,report,config,delta)
Check RequestObject HTTP 
    [Arguments]    ${dataResponse}    ${pathUrl}    ${tid}    ${body_expect}    ${method_expect}    ${identity}    ${custom}     ${sessionId}    ${orderref}    
	Log To Console    ${\n}============== Check RequestObject HTTP ==============${\n}
	#--------- Prepare Data --------------
	Log    ${dataResponse}
	${custom1}=    Get From Dictionary    ${dataResponse}    custom1
	Log    ${custom1}
	${requestObject}=    Get From Dictionary    ${custom1}    requestObject
	Log    ${requestObject}
	${requestObject_str}=    Convert to String    ${requestObject}
	${requestObject_json}=    Convert String to JSON    ${requestObject_str}
	#{\"url\":\"[valuePathUrl]\",\"method\":\"[method]\",\"headers\":"{\"Content-Type\":\"application\/json\",\"Authorization\":\"[Authorization]\",\"Host\":\"[Host]\",\"x-ais-username\":\"[username]\",\"x-ais-orderref\":\"[orderref]\",\"x-ais-orderdesc\":\"[orderdesc]\",\"x-ais-SessionId\":\"[x-ais-SessionId]\"}",\"identity\":[identity],\"custom\":[custom]}
	${url}=    Get Value From Json    ${requestObject_json}    url    
	Log    ${url}[0]
	Log    ${pathUrl}
	${method}=    Get Value From Json    ${requestObject_json}    method    
	Log    ${method}[0]
	${header}=    Get Value From Json    ${requestObject_json}    headers 
	Log    ${header}[0]
	${header_host}=    Get Value From Json    ${header}[0]    Host   
	${header_x-ais-username}=    Get Value From Json    ${header}[0]    x-ais-username  
	${header_x-ais-orderref}=    Get Value From Json    ${header}[0]    x-ais-orderref  
	${header_x-ais-orderdesc}=    Get Value From Json    ${header}[0]    x-ais-orderdesc
	${header_x-ais-SessionId}=    Get Value From Json    ${header}[0]    x-ais-SessionId
	${header_identity}=    Get Value From Json    ${header}[0]    identity
	${header_custom}=    Get Value From Json    ${header}[0]    custom
	${header_identity_status}=    Get Length    ${header_identity}
	${header_custom_status}=    Get Length    ${header_custom}
	#--------- Check value--------------
	# expect,actual,field
	Data Should Be Equal    ${pathUrl}    ${url}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.${FIELD_LOG_DETAIL_URL}	
	Data Should Be Equal    ${method_expect}    ${method}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.${FIELD_LOG_DETAIL_METHOD}
	#check header
	Data Should Be Equal    ${HOST}    ${header_host}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.headers.HOST	
	Data Should Be Equal    ${HEADER_X_AIS_USERNAME_AISPARTNER}    ${header_x-ais-username}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.headers.x-ais-username	
	Data Should Be Equal    ${HEADER_X_AIS_ORDERDESC_AsgardHTTP}    ${header_x-ais-orderdesc}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.headers.x-ais-orderdesc	
	Data Should Be Equal    ${sessionId}    ${header_x-ais-SessionId}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.headers.x-ais-SessionId	
	Data Should Be Equal    ${orderref}    ${header_x-ais-orderref}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.headers.x-ais-orderref	
	Log    ${header_identity_status}
	Log    ${header_custom_status}
	Run Keyword If    ${header_identity_status}!=0 and ${header_custom_status}!=0    Check Indentity And Custom    ${header}    ${identity}    ${custom}
	#check body
    Run Keyword If    '${pathUrl}'=='${URL_AsgardHTTPReport}'    Check body    ${requestObject_json}    ${body_expect}
 
Check body
    [Arguments]    ${requestObject_json}    ${body_expect}
	${body}=    Get Value From Json    ${requestObject_json}    body 
	Log    ${body}[0]
	${Payload}=    Get Value From Json    ${body}[0]    Payload 
	Log    ${Payload}[0]
	${payload_expect}=    Convert String to JSON    ${body_expect}	
	Data Should Be Equal    ${payload_expect}    ${Payload}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.${FIELD_LOG_DETAIL_BODY}

Check Indentity And Custom
    [Arguments]    ${header}    ${identity}    ${custom}
	${header_identity}=    Get Value From Json    ${header}[0]    identity
	${header_custom}=    Get Value From Json    ${header}[0]    custom 
	Data Should Be Equal    ${identity}    ${header_identity}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.headers.identity	
	Data Should Be Equal    ${custom}    ${header_custom}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.headers.custom

#register
Check ResponseObject HTTP Register 
    [Arguments]    ${dataResponse}    ${ThingToken_expect}    ${Code}    ${Desc} 
	Log To Console    ${\n}============== Check ResponseObject ==============${\n}
	#--------- Prepare Data --------------
	Log    ${dataResponse}
	${custom1}=    Get From Dictionary    ${dataResponse}    custom1
	Log    ${custom1}
	${responseObject}=    Get From Dictionary    ${custom1}    responseObject
	Log    ${responseObject}
	${responseObject_str}=    Convert to String    ${responseObject}
	${responseObject_json}=    Convert String to JSON    ${responseObject_str}
	${OperationStatus}=    Get Value From Json    ${responseObject_json}    OperationStatus  
	${OperationStatus_Code}=    Get Value From Json    ${OperationStatus}[0]    Code 
	${OperationStatus_Desc}=    Get Value From Json    ${OperationStatus}[0]    DeveloperMessage   
	Log    ${OperationStatus}[0]
    Data Should Be Equal    ${Code}    ${OperationStatus_Code}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}.${FIELD_LOG_DETAIL_OPERATIONSTATUS_CODE}
	Data Should Be Equal    ${Desc}    ${OperationStatus_Desc}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}.${FIELD_LOG_DETAIL_OPERATIONSTATUS_DESCRIPTION}
    Run Keyword If    '${Code}'=='20000'    Check ThingToken    ${responseObject_json}    ${ThingToken_expect}

Check ThingToken
    [Arguments]    ${responseObject_json}    ${ThingToken_expect}
	${ThingToken}=    Get Value From Json    ${responseObject_json}    ThingToken    
	Log    ${ThingToken}[0]
	#--------- Check value--------------
	# expect,actual,field
	Data Should Be Equal    ${ThingToken_expect}    ${ThingToken}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}.${FIELD_LOG_DETAIL_THINGTOKEN}	


#===== Report : Log Detail No Have EnpointName
Check RequestObject HTTP Have EndPointName
    [Arguments]    ${dataResponse}    ${body_expect}    ${pathUrl}    ${sessionId}    ${orderRef}    ${urlCmdName}
	Log To Console    ${\n}============== Check RequestObject ==============${\n}
	#--------- Prepare Data --------------
	Log    ${dataResponse}
	${custom1}=    Get From Dictionary    ${dataResponse}    custom1
	Log    ${custom1}
	${endPointName}=    Get From Dictionary    ${custom1}    endPointName
	Log    ${endPointName}
	${requestObject}=    Get From Dictionary    ${custom1}    requestObject
	Log    ${requestObject}
	${requestObject_str}=    Convert to String    ${requestObject}
	${requestObject_json}=    Convert String to JSON    ${requestObject_str}
	#{\"url\":\"[valuePathUrl]\",\"method\":\"[method]\",\"headers\":"{\"Content-Type\":\"application\/json\",\"Authorization\":\"[Authorization]\",\"Host\":\"[Host]\",\"x-ais-username\":\"[username]\",\"x-ais-orderref\":\"[orderref]\",\"x-ais-orderdesc\":\"[orderdesc]\",\"x-ais-SessionId\":\"[x-ais-SessionId]\"}",\"identity\":[identity],\"custom\":[custom]}
	${url}=    Get Value From Json    ${requestObject_json}    url    
	Log    ${url}[0]
	Log    ${urlCmdName}
	${header}=    Get Value From Json    ${requestObject_json}    headers 
	Log    ${header}[0]
	${header_x-ais-orderref}=    Get Value From Json    ${header}[0]    x-ais-orderref 
	${header_x-ais-SessionId}=    Get Value From Json    ${header}[0]    x-ais-sessionid
	${body}=    Get Value From Json    ${requestObject_json}    body
	Log    ${body}[0]
	#--------- Check value--------------
	# expect,actual,field
	Data Should Be Equal    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${endPointName}   ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ENDPOINTNAME}
	Data Should Be Equal    ${urlCmdName}    ${url}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.${FIELD_LOG_DETAIL_URL}	
	#check header
    Data Should Be Equal    ${sessionId}    ${header_x-ais-SessionId}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.headers.x-ais-sessionid	
	Data Should Be Equal    ${orderRef}    ${header_x-ais-orderref}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.headers.x-ais-orderref	
	Data Should Be Equal    ${body_expect}    ${body}[0]   ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}.${FIELD_LOG_DETAIL_BODY}		

#report
Check ResponseObject HTTP Report 
    [Arguments]    ${dataResponse}    ${ThingToken_expect}    ${Code}    ${Desc}
	Log To Console    ${\n}============== Check ResponseObject ==============${\n}
	#--------- Prepare Data --------------
	Log    ${dataResponse}
	${custom1}=    Get From Dictionary    ${dataResponse}    custom1
	Log    ${custom1}
	${responseObject}=    Get From Dictionary    ${custom1}    responseObject
	Log    ${responseObject}
	${responseObject_str}=    Convert to String    ${responseObject}
	${responseObject_json}=    Convert String to JSON    ${responseObject_str}
	#--------- Check value--------------
	# expect,actual,field

	Run Keyword If    '${responseObject_str}'!='""'    Check Code    ${responseObject_json}    ${Code}    ${Desc}
	Run Keyword If    '${responseObject_str}'=='""'    Data Should Be Equal    ${EMPTY}    ${responseObject_json}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}	

Check Code
    [Arguments]    ${responseObject_json}    ${Code}    ${Desc}
	#--------- Check value--------------
	# expect,actual,field
	${OperationStatus}=    Get Value From Json    ${responseObject_json}    OperationStatus  
	${OperationStatus_Code}=    Get Value From Json    ${OperationStatus}[0]    Code 
	${OperationStatus_Desc}=    Get Value From Json    ${OperationStatus}[0]    DeveloperMessage  
	Data Should Be Equal    ${Code}    ${OperationStatus_Code}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}.${FIELD_LOG_DETAIL_OPERATIONSTATUS_CODE}
	Data Should Be Equal    ${Desc}    ${OperationStatus_Desc}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}.${FIELD_LOG_DETAIL_OPERATIONSTATUS_DESCRIPTION}


# ChecK ResponseObject HTTP Config
Check ResponseObject HTTP Config 
    [Arguments]    ${dataResponse}    ${payload_expect}    ${Code}    ${Desc} 
	Log To Console    ${\n}============== Check ResponseObject ==============${\n}
	#--------- Prepare Data --------------
	Log    ${dataResponse}
	${custom1}=    Get From Dictionary    ${dataResponse}    custom1
	Log    ${custom1}
	${responseObject}=    Get From Dictionary    ${custom1}    responseObject
	Log    ${responseObject}
	${responseObject_str}=    Convert to String    ${responseObject}
	${responseObject_json}=    Convert String to JSON    ${responseObject_str}
	${OperationStatus}=    Get Value From Json    ${responseObject_json}    OperationStatus  
	${OperationStatus_Code}=    Get Value From Json    ${OperationStatus}[0]    Code 
	${OperationStatus_Desc}=    Get Value From Json    ${OperationStatus}[0]    DeveloperMessage   
	Log    ${OperationStatus}[0]
    Data Should Be Equal    ${Code}    ${OperationStatus_Code}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}.${FIELD_LOG_DETAIL_OPERATIONSTATUS_CODE}
	Data Should Be Equal    ${Desc}    ${OperationStatus_Desc}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}.${FIELD_LOG_DETAIL_OPERATIONSTATUS_DESCRIPTION}
    Run Keyword If    '${Code}'=='20000'    Check Config    ${responseObject_json}    ${payload_expect}

Check Config
    [Arguments]    ${responseObject_json}    ${payload_expect}
	${Config}=    Get Value From Json    ${responseObject_json}    Config    
	Log    ${Config}[0]
	${Config_Expect}=    Convert String To Json    ${payload_expect}
	#--------- Check value--------------
	# expect,actual,field
	Data Should Be Equal    ${Config_Expect}    ${Config}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}.${FIELD_LOG_DETAIL_CONFIG}	

# ChecK ResponseObject HTTP Delta
Check ResponseObject HTTP Delta 
    [Arguments]    ${dataResponse}    ${payload_expect}    ${Code}    ${Desc} 
	Log To Console    ${\n}============== Check ResponseObject ==============${\n}
	#--------- Prepare Data --------------
	Log    ${dataResponse}
	${custom1}=    Get From Dictionary    ${dataResponse}    custom1
	Log    ${custom1}
	${responseObject}=    Get From Dictionary    ${custom1}    responseObject
	Log    ${responseObject}
	${responseObject_str}=    Convert to String    ${responseObject}
	${responseObject_json}=    Convert String to JSON    ${responseObject_str}
	${OperationStatus}=    Get Value From Json    ${responseObject_json}    OperationStatus  
	${OperationStatus_Code}=    Get Value From Json    ${OperationStatus}[0]    Code 
	${OperationStatus_Desc}=    Get Value From Json    ${OperationStatus}[0]    DeveloperMessage   
	Log    ${OperationStatus}[0]
    Data Should Be Equal    ${Code}    ${OperationStatus_Code}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}.${FIELD_LOG_DETAIL_OPERATIONSTATUS_CODE}
	Data Should Be Equal    ${Desc}    ${OperationStatus_Desc}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}.${FIELD_LOG_DETAIL_OPERATIONSTATUS_DESCRIPTION}
    Run Keyword If    '${Code}'=='20000'    Check Delta    ${responseObject_json}    ${payload_expect}

Check Delta
    [Arguments]    ${responseObject_json}    ${payload_expect}
	${Delta}=    Get Value From Json    ${responseObject_json}    Delta    
	Log    ${Delta}[0]
	${Delta_Expect}=    Convert String To Json    ${payload_expect}
	#--------- Check value--------------
	# expect,actual,field
	Data Should Be Equal    ${Delta_Expect}    ${Delta}[0]    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}.${FIELD_LOG_DETAIL_DELTA}	
