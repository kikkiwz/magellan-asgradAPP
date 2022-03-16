*** Keywords ***	
Post Search Log
    [Arguments]    ${url}    ${valueSearch}    ${value_applicationName}    
	${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    Authorization=${HEADER_AUTHENTICATION}    kbn-version=7.5.1  
    #${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    Host=azmagellancd001-iot.southeastasia.cloudapp.azure.com:30380    kbn-version=7.5.1    Origin=http://azmagellancd001-iot.southeastasia.cloudapp.azure.com:30380    
	# Log To Console    ${headers}
	
	#return valueDateGte,valueDateLte (RANGE_SEARCH 15 minutes)
	${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    ${RANGE_SEARCH}    ${TIME_STRING_MINUTES}
	#${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    50    ${TIME_STRING_MINUTES}
	#Log To Console    setRange${setRange}
	${setRangeGTE}=    Set variable    ${setRange}[0]
	${setRangeLTE}=    Set variable    ${setRange}[1]
	#Log To Console    setRangeGTE${setRangeGTE}
	#Log To Console    setRangeLTE${setRangeLTE}

	Log    valueSearch${valueSearch}
	# Log To Console    valueSearch${valueSearch}
	
	${multiMatchType}=    Set Variable    best_fields
	# ${multiMatchType}=    Set Variable If    '${valueSearch}'=='${ASGARD_COAPAPI_VALUE_TST_F4_0_2_003_DATASEARCH}'    phrase
    # ...    '${value_applicationName}'=='${VALUE_APPLICATIONNAME_CHARGING}'    phrase	
	# ...    '${valueSearch}'!='${ASGARD_COAPAPI_VALUE_TST_F4_0_2_003_DATASEARCH}'    best_fields	
	
    ${data}=    Evaluate    {"version":"true","size":500,"sort":[{"@timestamp_es":{"order":"desc","unmapped_type":"boolean"}}],"_source":{"excludes":[]},"aggs":{"2":{"date_histogram":{"field":"@timestamp_es","fixed_interval":"30s","time_zone":"Asia/Bangkok","min_doc_count":1}}},"stored_fields":["*"],"script_fields":{},"docvalue_fields":[{"field":"@timestamp_es","format":"date_time"},{"field":"cauldron.custom1.activityLog.endTime","format":"date_time"},{"field":"cauldron.custom1.activityLog.startTime","format":"date_time"},{"field":"time","format":"date_time"}],"query":{"bool":{"must":[],"filter":[{"multi_match":{"type":"${multiMatchType}","query":"${valueSearch}","lenient":"true"}},{"range":{"@timestamp_es":{"format":"strict_date_optional_time","gte":"${setRangeGTE}","lte":"${setRangeLTE}"}}}],"should":[],"must_not":[]}},"highlight":{"pre_tags":["@kibana-highlighted-field@"],"post_tags":["@/kibana-highlighted-field@"],"fields":{"*":{}},"fragment_size":2147483647}}
    # Log To Console    ${data}
	# Log To Console    ${url}
    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}    ${EMPTY}    ${headers}    ${data}
	Log    ${res}
	# Log To Console    ${res}
	Sleep    10s
	[return]    ${res}


Get tid for Search Log
    [Arguments]    ${value_applicationName}    ${imsi_thingToken}    ${endPointName}
	#Log To Console    value_applicationName${value_applicationName}	
	#Log To Console    imsi_thingToken${imsi_thingToken}	
	${resLog}=    Post Search Log    ${URL_GET_LOG}    ${imsi_thingToken}    ${value_applicationName}    
	Sleep    5s
	Log    resLog${resLog}	
	${total}=    Set variable    ${resLog['hits']['total']}
	#Log To Console    total${total}  
	@{valArrData}=    Create List
	FOR    ${i}    IN RANGE    ${total}
	    #Log To Console    ${i}  
	    ${valLog}=    Set variable    ${resLo g['hits']['hits'][${i}]['_source']['cauldron']}
	    #Log To Console    applicationName${valLog['applicationName']}
	    #Log To Console    valLog${valLog}
		
	    ${applicationName}=    Set variable    ${valLog['applicationName']}
	    #Log To Console    applicationName${applicationName}
  
		Run Keyword If    '${applicationName}'=='${value_applicationName}' and '${imsi_thingToken}'!='${ASGARD_COAPAPI_VALUE_TST_F4_0_2_003_DATASEARCH}'    Append To List    ${valArrData}    ${valLog}        #Add data to array set at valArrData
		Run Keyword If    '${imsi_thingToken}'=='${ASGARD_COAPAPI_VALUE_TST_F4_0_2_003_DATASEARCH}'    Append To List    ${valArrData}    ${valLog}        #Add data to array set at valArrData
	#Exit For Loop
	END
	#Log To Console    tivalArrDatad${valArrData}
    ${tid}=    Set variable    ${valArrData[0]['tid']}
	#Log To Console    tid${tid}
	${sessionId}=    Set variable    ${valArrData[0]['sessionId']}
	#Log To Console    tid${tid}
    [return]    ${tid}    ${sessionId}
	
Data Log Response
    [Arguments]    ${value_applicationName}    ${imsi_thingToken}    ${endPointName}
	#Log To Console    imsi${imsi_thingToken}	
	Sleep    5s
	${resTid}=    Get tid for Search Log    ${value_applicationName}    ${imsi_thingToken}    ${endPointName}
	
	${getTidSessionId}=    Set Variable If	'${value_applicationName}'=='${VALUE_APPLICATIONNAME_CHARGING}'    ${resTid}[1]    
	...    '${value_applicationName}'!='${VALUE_APPLICATIONNAME_CHARGING}'    ${resTid}[0]
	#${resTid}=    Get tid for Search Log    ${value_applicationName}    ${imsi_thingToken}    ${endPointName}
	#Log To Console    resTid${resTid}	
	#Log To Console    getTidSessionId${getTidSessionId}	
    ${tid}=    Set Variable    ${resTid}[0]
	${resLog}=   Post Search Log    ${URL_GET_LOG}    ${getTidSessionId}    ${value_applicationName}
    Log    resLog${resLog}	
	Sleep    5s
		
	${total}=    Set variable    ${resLog['hits']['total']}
	#Log To Console    total${total}
	
    @{valArrData}=    Create List
	@{valArrDetail}=    Create List
	@{valArrSummary}=    Create List
	FOR    ${i}    IN RANGE    ${total}
	    #Log To Console    ${i}  
	    ${valLog}=    Set variable    ${resLog['hits']['hits'][${i}]['_source']['log']}
	    #Log To Console    valLog${valLog}

	    #r use for parameter / have in data 
	    ${dataResponse}=    Evaluate    json.loads(r'''${valLog}''')    json
	    Log    dataResponse = ${dataResponse}
	
	    ${applicationName}=    Set variable    ${dataResponse['applicationName']}
	    Log    applicationName = ${applicationName}
		${logType}=    Set variable    ${dataResponse['logType']}
	    Log    logType = ${logType}

	    Run Keyword If    '${applicationName}'=='${value_applicationName}'    Append To List    ${valArrData}    ${dataResponse}    #Add data to array set at valArrData
		Run Keyword If    '${applicationName}'=='${value_applicationName}' and '${logType}'=='${VALUE_DETAIL}'    Append To List    ${valArrDetail}    ${dataResponse}    #Add data to array set at valArrDetail
		Run Keyword If    '${applicationName}'=='${value_applicationName}' and '${logType}'=='${VALUE_SUMMARY}'   Append To List    ${valArrSummary}    ${dataResponse}    #Add data to array set at valArrSummary
		
    END
	#Log To Console    valArrData${valArrData}  
	#Log To Console    valArrDetail${valArrDetail}  
	#Log To Console    valArrSummary${valArrSummary}  
    [return]    ${valArrData}    ${valArrDetail}    ${valArrSummary}    ${resTid}[0]    ${resTid}[1]

#=============================== New ==========================================
#ค้นหา log kibana ด้วย orderRef และ applicationName
Post Search Log New
    [Arguments]    ${orderRef}    ${applicationName}
	${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    Authorization=${HEADER_AUTHENTICATION}    kbn-version=7.5.1  
	Log    ${headers}	
	#return valueDateGte,valueDateLte (RANGE_SEARCH 15 minutes)
	Sleep    5s
	${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    ${RANGE_SEARCH}    ${TIME_STRING_DAYS}
	#${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    50    ${TIME_STRING_MINUTES}
	#Log To Console    setRange${setRange}
	${setRangeGTE}=    Set variable    ${setRange}[0]
	${setRangeLTE}=    Set variable    ${setRange}[1]
    ${data}=    Evaluate    {"version":"true","size":500,"sort":[{"@timestamp_es":{"order":"desc","unmapped_type":"boolean"}}],"_source":{"excludes":[]},"aggs":{"2":{"date_histogram":{"field":"@timestamp_es","fixed_interval":"30m","time_zone":"Asia/Bangkok","min_doc_count":1}}},"stored_fields":["*"],"script_fields":{},"docvalue_fields":[{"field":"@timestamp_es","format":"date_time"},{"field":"cauldron.custom1.activityLog.endTime","format":"date_time"},{"field":"cauldron.custom1.activityLog.startTime","format":"date_time"},{"field":"cauldron.custom2.timeStamp","format":"date_time"},{"field":"time","format":"date_time"}],"query":{"bool":{"must":[],"filter":[{"bool":{"filter":[{"multi_match":{"type":"best_fields","query":"${orderRef}","lenient":"true"}},{"multi_match":{"type":"phrase","query":"MQTTAPP","lenient":"true"}}]}},{"range":{"@timestamp_es":{"format":"strict_date_optional_time","gte":"${setRangeGTE}","lte":"${setRangeLTE}"}}}],"should":[],"must_not":[]}},"highlight":{"pre_tags":["@kibana-highlighted-field@"],"post_tags":["@/kibana-highlighted-field@"],"fields":{"*":{}},"fragment_size":2147483647}}
	Log    ${data}
    # Send Search Log To Kibana หาด้วย orderRef และ application name
	${resLog}=    Wait Until Keyword Succeeds    5x    10s    Post Api Request    ${URL_GET_LOG}    ${EMPTY}    ${headers}    ${data}
	Log    ${resLog}
    ${total}=    Set variable    ${resLog['hits']['total']}
	#Log To Console    total${total}  
	@{valArrData}=    Create List
	@{valArrDetail}=    Create List
	@{valArrSummary}=    Create List
    # แยกระหว่าง log Summary และ Detail
	FOR    ${i}    IN RANGE    ${total}
	    ${valLog}=    Set variable    ${resLog['hits']['hits'][${i}]['_source']['log']}
	    ${dataResponse}=    Evaluate    json.loads(r'''${valLog}''')    json
	    Log    dataResponse = ${dataResponse}
		${logType}=    Set variable    ${dataResponse['logType']}
	    Log    logType = ${logType}
        Append To List    ${valArrData}    ${valLog}        #Add data to array set at valArrData
		Run Keyword If    '${logType}'=='${VALUE_DETAIL}'    Append To List    ${valArrDetail}    ${dataResponse}    #Add data to array set at valArrDetail
		Run Keyword If    '${logType}'=='${VALUE_SUMMARY}'   Append To List    ${valArrSummary}    ${dataResponse}    #Add data to array set at valArrSummary
	#Exit For Loop
	END
	Log    Log All : ${valArrData}
	Log    Log Detail : ${valArrDetail}  
	Log    Log Summary : ${valArrSummary} 
	${valArrData_list}=    Get From List    ${valArrData}    0
	${valArrData_json}=    Convert String to JSON    ${valArrData_list}
    ${tid}=    Get Value From Json    ${valArrData_json}    tid
	#Log To Console    tid${tid}
	${sessionId}=    Get Value From Json    ${valArrData_json}    sessionId 
	[Return]    ${valArrData}    ${valArrDetail}    ${valArrSummary}    ${tid}[0]    ${sessionId}[0] 

Post Search Log Charging
    [Arguments]    ${orderRef}    ${applicationName}
	${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    Authorization=${HEADER_AUTHENTICATION}    kbn-version=7.5.1  
	Log    ${headers}	
	#return valueDateGte,valueDateLte (RANGE_SEARCH 15 minutes)
	Sleep    5s
	${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    ${RANGE_SEARCH}    ${TIME_STRING_DAYS}
	#${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    50    ${TIME_STRING_MINUTES}
	#Log To Console    setRange${setRange}
	${setRangeGTE}=    Set variable    ${setRange}[0]
	${setRangeLTE}=    Set variable    ${setRange}[1]
    ${data}=    Evaluate    {"version": "true", "size": 500, "sort": [{"@timestamp_es": {"order": "desc", "unmapped_type": "boolean"}}], "_source": {"excludes": []}, "aggs": {"2": {"date_histogram": {"field": "@timestamp_es", "fixed_interval": "30m", "time_zone": "Asia/Bangkok", "min_doc_count": 1}}}, "stored_fields": ["*"], "script_fields": {}, "docvalue_fields": [{"field": "@timestamp_es", "format": "date_time"}, {"field": "cauldron.custom1.activityLog.endTime", "format": "date_time"}, {"field": "cauldron.custom1.activityLog.startTime", "format": "date_time"}, {"field": "cauldron.custom2.timeStamp", "format": "date_time"}, {"field": "time", "format": "date_time"}], "query": {"bool": {"must": [], "filter":[{"bool":{"filter":[{"multi_match":{"type":"phrase","query":"${orderRef}"}},{"bool":{"should":[{"multi_match":{"type":"best_fields","query":"${applicationName}"}},{"multi_match":{"type":"best_fields","query":"Insight.Charging.APIs"}}],"minimum_should_match":1}}]}}, {"range": {"@timestamp_es": {"format": "strict_date_optional_time", "gte": "2021-10-13T09:54:42.000Z", "lte": "2021-10-14T09:54:42.000Z"}}}], "should": [], "must_not": []}}, "highlight": {"pre_tags": ["@kibana-highlighted-field@"], "post_tags": ["@/kibana-highlighted-field@"], "fields": {"*": {}}, "fragment_size": 2147483647}}
	#${data}=    Evaluate    {"version":"true","size":500,"sort":[{"@timestamp_es":{"order":"desc","unmapped_type":"boolean"}}],"_source":{"excludes":[]},"aggs":{"2":{"date_histogram":{"field":"@timestamp_es","fixed_interval":"30m","time_zone":"Asia/Bangkok","min_doc_count":1}}},"stored_fields":["*"],"script_fields":{},"docvalue_fields":[{"field":"@timestamp_es","format":"date_time"},{"field":"cauldron.custom1.activityLog.endTime","format":"date_time"},{"field":"cauldron.custom1.activityLog.startTime","format":"date_time"},{"field":"cauldron.custom2.timeStamp","format":"date_time"},{"field":"time","format":"date_time"}],"query":{"bool":{"must":[],"filter":[{"bool":{"filter":[{"multi_match":{"type":"best_fields","query":"${orderRef}","lenient":"true"}}]}},{"range":{"@timestamp_es":{"format":"strict_date_optional_time","gte":"${setRangeGTE}","lte":"${setRangeLTE}"}}}],"should":[],"must_not":[]}},"highlight":{"pre_tags":["@kibana-highlighted-field@"],"post_tags":["@/kibana-highlighted-field@"],"fields":{"*":{}},"fragment_size":2147483647}}
	Log    ${data}
    # Send Search Log To Kibana หาด้วย orderRef และ application name
	${resLog}=    Post Api Request    ${URL_GET_LOG}    ${EMPTY}    ${headers}    ${data}
	Log    ${resLog}
   ${total}=    Set variable    ${resLog['hits']['total']}
	#Log To Console    total${total}  
	@{valArrData}=    Create List
	@{valArrDetail}=    Create List
	@{valArrSummary}=    Create List
    # แยกระหว่าง log Summary และ Detail
	FOR    ${i}    IN RANGE    ${total}
	    ${valLog}=    Set variable    ${resLog['hits']['hits'][${i}]['_source']['log']}
	    ${dataResponse}=    Evaluate    json.loads(r'''${valLog}''')    json
	    Log    dataResponse = ${dataResponse}
		${logType}=    Set variable    ${dataResponse['logType']}
		${applicationName_response}=    Set variable    ${dataResponse['applicationName']}
	    Log    logType = ${logType}
        Append To List    ${valArrData}    ${valLog}        #Add data to array set at valArrData
		Run Keyword If    '${logType}'=='${VALUE_DETAIL}'    Append To List    ${valArrDetail}    ${dataResponse}    #Add data to array set at valArrDetail
		Run Keyword If    '${logType}'=='${VALUE_SUMMARY}'   Append To List    ${valArrSummary}    ${dataResponse}    #Add data to array set at valArrSummary
	#Exit For Loop
	END
	Log    Log All : ${valArrData}
	Log    Log Detail : ${valArrDetail}  
	Log    Log Summary : ${valArrSummary} 
	${length}=    Get Length    ${valArrSummary}
	${valArrSummary_json}=    Run Keyword And Ignore Error    Get From List    ${valArrSummary}    0
	${valArrDetail_json}=    Run Keyword And Ignore Error    Get From List    ${valArrDetail}    0
	${valArrSummary_json}=    Set Variable If    '${length}'=='0'    ${valArrDetail_json}
	...    ${valArrSummary_json}
	#${valArrSummary_str}=    Convert To String    ${valArrSummary_list}
	#${valArrSummary_json}=    Convert String to JSON    ${valArrSummary_list}
    ${tid}=    Get Value From Json    ${valArrSummary_json}[1]    tid
	#Log To Console    tid${tid}
	${sessionId}=    Get Value From Json    ${valArrSummary_json}[1]    sessionId 

    #-----------search with sessionId again
	Sleep    5s
	${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    ${RANGE_SEARCH}    ${TIME_STRING_DAYS}
	#${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    50    ${TIME_STRING_MINUTES}
	#Log To Console    setRange${setRange}
	${setRangeGTE}=    Set variable    ${setRange}[0]
	${setRangeLTE}=    Set variable    ${setRange}[1]
    ${data_SearchWithSessionId}=    Evaluate    {"version":"true","size":500,"sort":[{"@timestamp_es":{"order":"desc","unmapped_type":"boolean"}}],"_source":{"excludes":[]},"aggs":{"2":{"date_histogram":{"field":"@timestamp_es","fixed_interval":"30m","time_zone":"Asia/Bangkok","min_doc_count":1}}},"stored_fields":["*"],"script_fields":{},"docvalue_fields":[{"field":"@timestamp_es","format":"date_time"},{"field":"cauldron.custom1.activityLog.endTime","format":"date_time"},{"field":"cauldron.custom1.activityLog.startTime","format":"date_time"},{"field":"cauldron.custom2.timeStamp","format":"date_time"},{"field":"time","format":"date_time"}],"query":{"bool":{"must":[],"filter":[{"bool":{"filter":[{"multi_match":{"type":"best_fields","query":"${sessionId}","lenient":"true"}},{"multi_match":{"type":"phrase","query":"${applicationName}","lenient":"true"}}]}},{"range":{"@timestamp_es":{"format":"strict_date_optional_time","gte":"${setRangeGTE}","lte":"${setRangeLTE}"}}}],"should":[],"must_not":[]}},"highlight":{"pre_tags":["@kibana-highlighted-field@"],"post_tags":["@/kibana-highlighted-field@"],"fields":{"*":{}},"fragment_size":2147483647}}
	Log    ${data_SearchWithSessionId}
    # Send Search Log To Kibana หาด้วย orderRef และ application name
	${resLog_SearchWithSessionId}=    Post Api Request    ${URL_GET_LOG}    ${EMPTY}    ${headers}    ${data_SearchWithSessionId}
	Log    ${resLog_SearchWithSessionId}
    ${total_SearchWithSessionId}=    Set variable    ${resLog_SearchWithSessionId['hits']['total']}
	#Log To Console    total${total}  
	@{valArrData_SearchWithSessionId}=    Create List
	@{valArrDetail_SearchWithSessionId}=    Create List
	@{valArrSummary_SearchWithSessionId}=    Create List
    # แยกระหว่าง log Summary และ Detail
	FOR    ${i}    IN RANGE    ${total_SearchWithSessionId}
	    ${valLog_SearchWithSessionId}=    Set variable    ${resLog_SearchWithSessionId['hits']['hits'][${i}]['_source']['log']}
	    ${dataResponse}=    Evaluate    json.loads(r'''${valLog_SearchWithSessionId}''')    json
	    Log    dataResponse = ${dataResponse}
		${logType}=    Set variable    ${dataResponse['logType']}
	    Log    logType = ${logType}
        Append To List    ${valArrData_SearchWithSessionId}    ${valLog_SearchWithSessionId}        #Add data to array set at valArrData
		Run Keyword If    '${logType}'=='${VALUE_DETAIL}'    Append To List    ${valArrDetail_SearchWithSessionId}    ${dataResponse}    #Add data to array set at valArrDetail
		Run Keyword If    '${logType}'=='${VALUE_SUMMARY}'   Append To List    ${valArrSummary_SearchWithSessionId}    ${dataResponse}    #Add data to array set at valArrSummary
	#Exit For Loop
	END
	Log    Log All : ${valArrData_SearchWithSessionId}
	Log    Log Detail : ${valArrDetail_SearchWithSessionId}  
	Log    Log Summary : ${valArrSummary_SearchWithSessionId} 
	${valArrDetail_list_SearchWithSessionId}=    Get From List    ${valArrDetail_SearchWithSessionId}    1
	#${valArrDetail_json_SearchWithSessionId}=    Convert String to JSON    ${valArrDetail_list_SearchWithSessionId}
    ${tid_haveEndpoint}=    Get Value From Json    ${valArrDetail_list_SearchWithSessionId}    tid
	#Log To Console    tid${tid}
	#${sessionId}=    Get Value From Json    ${valArrData_json_SearchWithSessionId}    sessionId 
	Log    ${tid}[0]
	Log    ${sessionId}[0]
	[Return]    ${valArrData_SearchWithSessionId}    ${valArrDetail_SearchWithSessionId}    ${valArrSummary_SearchWithSessionId}    ${tid_haveEndpoint}[0]    ${sessionId}[0] 

Post Search Log Charging For Coapp
    [Arguments]    ${orderRef}    ${applicationName}
	${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    Authorization=${HEADER_AUTHENTICATION}    kbn-version=7.5.1  
	Log    ${headers}	
	#return valueDateGte,valueDateLte (RANGE_SEARCH 15 minutes)
	Sleep    5s
	${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    ${RANGE_SEARCH}    ${TIME_STRING_DAYS}
	#${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    50    ${TIME_STRING_MINUTES}
	#Log To Console    setRange${setRange}
	${setRangeGTE}=    Set variable    ${setRange}[0]
	${setRangeLTE}=    Set variable    ${setRange}[1]
    ${data}=    Evaluate    {"version":"true","size":500,"sort":[{"@timestamp_es":{"order":"desc","unmapped_type":"boolean"}}],"_source":{"excludes":[]},"aggs":{"2":{"date_histogram":{"field":"@timestamp_es","fixed_interval":"30s","time_zone":"Asia/Bangkok","min_doc_count":1}}},"stored_fields":["*"],"script_fields":{},"docvalue_fields":[{"field":"@timestamp_es","format":"date_time"},{"field":"cauldron.custom1.activityLog.endTime","format":"date_time"},{"field":"cauldron.custom1.activityLog.startTime","format":"date_time"},{"field":"cauldron.custom2.timeStamp","format":"date_time"},{"field":"time","format":"date_time"}],"query":{"bool":{"must":[],"filter":[{"bool":{"filter":[{"multi_match":{"type":"phrase","query":"${orderRef}","lenient":"true"}},{"multi_match":{"type":"best_fields","query":"CoapAPP","lenient":"true"}}]}},{"range":{"@timestamp_es":{"format":"strict_date_optional_time","gte":"${setRangeGTE}","lte":"${setRangeLTE}"}}}],"should":[],"must_not":[]}},"highlight":{"pre_tags":["@kibana-highlighted-field@"],"post_tags":["@/kibana-highlighted-field@"],"fields":{"*":{}},"fragment_size":2147483647}}
	#${data}=    Evaluate    {"version":"true","size":500,"sort":[{"@timestamp_es":{"order":"desc","unmapped_type":"boolean"}}],"_source":{"excludes":[]},"aggs":{"2":{"date_histogram":{"field":"@timestamp_es","fixed_interval":"30m","time_zone":"Asia/Bangkok","min_doc_count":1}}},"stored_fields":["*"],"script_fields":{},"docvalue_fields":[{"field":"@timestamp_es","format":"date_time"},{"field":"cauldron.custom1.activityLog.endTime","format":"date_time"},{"field":"cauldron.custom1.activityLog.startTime","format":"date_time"},{"field":"cauldron.custom2.timeStamp","format":"date_time"},{"field":"time","format":"date_time"}],"query":{"bool":{"must":[],"filter":[{"bool":{"filter":[{"multi_match":{"type":"best_fields","query":"${orderRef}","lenient":"true"}}]}},{"range":{"@timestamp_es":{"format":"strict_date_optional_time","gte":"${setRangeGTE}","lte":"${setRangeLTE}"}}}],"should":[],"must_not":[]}},"highlight":{"pre_tags":["@kibana-highlighted-field@"],"post_tags":["@/kibana-highlighted-field@"],"fields":{"*":{}},"fragment_size":2147483647}}
	Log    ${data}
    # Send Search Log To Kibana หาด้วย orderRef และ application name
	${resLog}=    Wait Until Keyword Succeeds    5x    10s    Post Api Request    ${URL_GET_LOG}    ${EMPTY}    ${headers}    ${data}
	Log    ${resLog}
   ${total}=    Set variable    ${resLog['hits']['total']}
	#Log To Console    total${total}  
	@{valArrData}=    Create List
	@{valArrDetail}=    Create List
	@{valArrSummary}=    Create List
    # แยกระหว่าง log Summary และ Detail
	FOR    ${i}    IN RANGE    ${total}
	    ${valLog}=    Set variable    ${resLog['hits']['hits'][${i}]['_source']['log']}
	    ${dataResponse}=    Evaluate    json.loads(r'''${valLog}''')    json
	    Log    dataResponse = ${dataResponse}
		${logType}=    Set variable    ${dataResponse['logType']}
		${applicationName_response}=    Set variable    ${dataResponse['applicationName']}
	    Log    logType = ${logType}
        Append To List    ${valArrData}    ${valLog}        #Add data to array set at valArrData
		Run Keyword If    '${logType}'=='${VALUE_DETAIL}'    Append To List    ${valArrDetail}    ${dataResponse}    #Add data to array set at valArrDetail
		Run Keyword If    '${logType}'=='${VALUE_SUMMARY}'   Append To List    ${valArrSummary}    ${dataResponse}    #Add data to array set at valArrSummary
	#Exit For Loop
	END
	Log    Log All : ${valArrData}
	Log    Log Detail : ${valArrDetail}  
	Log    Log Summary : ${valArrSummary} 
	${length}=    Get Length    ${valArrSummary}
	${valArrSummary_json}=    Run Keyword And Ignore Error    Get From List    ${valArrSummary}    0
	${valArrDetail_json}=    Run Keyword And Ignore Error    Get From List    ${valArrDetail}    0
	${valArrSummary_json}=    Set Variable If    '${length}'=='0'    ${valArrDetail_json}
	...    ${valArrSummary_json}
	#${valArrSummary_str}=    Convert To String    ${valArrSummary_list}
	#${valArrSummary_json}=    Convert String to JSON    ${valArrSummary_list}
    ${tid}=    Get Value From Json    ${valArrSummary_json}[1]    tid
	#Log To Console    tid${tid}
	${sessionId}=    Get Value From Json    ${valArrSummary_json}[1]    sessionId 

    #-----------search with sessionId again
	Sleep    5s
	${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    ${RANGE_SEARCH}    ${TIME_STRING_DAYS}
	#${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    50    ${TIME_STRING_MINUTES}
	#Log To Console    setRange${setRange}
	${setRangeGTE}=    Set variable    ${setRange}[0]
	${setRangeLTE}=    Set variable    ${setRange}[1]
    ${data_SearchWithSessionId}=    Evaluate    {"version":"true","size":500,"sort":[{"@timestamp_es":{"order":"desc","unmapped_type":"boolean"}}],"_source":{"excludes":[]},"aggs":{"2":{"date_histogram":{"field":"@timestamp_es","fixed_interval":"30m","time_zone":"Asia/Bangkok","min_doc_count":1}}},"stored_fields":["*"],"script_fields":{},"docvalue_fields":[{"field":"@timestamp_es","format":"date_time"},{"field":"cauldron.custom1.activityLog.endTime","format":"date_time"},{"field":"cauldron.custom1.activityLog.startTime","format":"date_time"},{"field":"cauldron.custom2.timeStamp","format":"date_time"},{"field":"time","format":"date_time"}],"query":{"bool":{"must":[],"filter":[{"bool":{"filter":[{"multi_match":{"type":"best_fields","query":"${sessionId}","lenient":"true"}},{"multi_match":{"type":"phrase","query":"${applicationName}","lenient":"true"}}]}},{"range":{"@timestamp_es":{"format":"strict_date_optional_time","gte":"${setRangeGTE}","lte":"${setRangeLTE}"}}}],"should":[],"must_not":[]}},"highlight":{"pre_tags":["@kibana-highlighted-field@"],"post_tags":["@/kibana-highlighted-field@"],"fields":{"*":{}},"fragment_size":2147483647}}
	Log    ${data_SearchWithSessionId}
    # Send Search Log To Kibana หาด้วย orderRef และ application name
	${resLog_SearchWithSessionId}=    Post Api Request    ${URL_GET_LOG}    ${EMPTY}    ${headers}    ${data_SearchWithSessionId}
	Log    ${resLog_SearchWithSessionId}
    ${total_SearchWithSessionId}=    Set variable    ${resLog_SearchWithSessionId['hits']['total']}
	#Log To Console    total${total}  
	@{valArrData_SearchWithSessionId}=    Create List
	@{valArrDetail_SearchWithSessionId}=    Create List
	@{valArrSummary_SearchWithSessionId}=    Create List
    # แยกระหว่าง log Summary และ Detail
	FOR    ${i}    IN RANGE    ${total_SearchWithSessionId}
	    ${valLog_SearchWithSessionId}=    Set variable    ${resLog_SearchWithSessionId['hits']['hits'][${i}]['_source']['log']}
	    ${dataResponse}=    Evaluate    json.loads(r'''${valLog_SearchWithSessionId}''')    json
	    Log    dataResponse = ${dataResponse}
		${logType}=    Set variable    ${dataResponse['logType']}
	    Log    logType = ${logType}
        Append To List    ${valArrData_SearchWithSessionId}    ${valLog_SearchWithSessionId}        #Add data to array set at valArrData
		Run Keyword If    '${logType}'=='${VALUE_DETAIL}'    Append To List    ${valArrDetail_SearchWithSessionId}    ${dataResponse}    #Add data to array set at valArrDetail
		Run Keyword If    '${logType}'=='${VALUE_SUMMARY}'   Append To List    ${valArrSummary_SearchWithSessionId}    ${dataResponse}    #Add data to array set at valArrSummary
	#Exit For Loop
	END
	Log    Log All : ${valArrData_SearchWithSessionId}
	Log    Log Detail : ${valArrDetail_SearchWithSessionId}  
	Log    Log Summary : ${valArrSummary_SearchWithSessionId} 
	${valArrDetail_list_SearchWithSessionId}=    Get From List    ${valArrDetail_SearchWithSessionId}    1
	#${valArrDetail_json_SearchWithSessionId}=    Convert String to JSON    ${valArrDetail_list_SearchWithSessionId}
    ${tid_haveEndpoint}=    Get Value From Json    ${valArrDetail_list_SearchWithSessionId}    tid
	#Log To Console    tid${tid}
	#${sessionId}=    Get Value From Json    ${valArrData_json_SearchWithSessionId}    sessionId 
	Log    ${tid}[0]
	Log    ${sessionId}[0]
	[Return]    ${valArrData_SearchWithSessionId}    ${valArrDetail_SearchWithSessionId}    ${valArrSummary_SearchWithSessionId}    ${tid_haveEndpoint}[0]    ${sessionId}[0] 


Check Log Response New 
    #resultCode_summary[20000],resultDesc_summary[20000],Code_detail[20000],Description_detail[Register is Success],applicationName,pathUrl,urlCmdName,imsi_thingToken,ipAddress,payload,namespace,containerId,identity,cmdName,endPointName,logLevel,custom,SensorKey
    [Arguments]    ${code}    ${description}    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}    ${custom}    ${SensorKey}    ${requestObject}    ${responseObject}    ${method}    ${orderRef}    ${listEndPointNameDB}      
    #Log To Console    imsi_thingTokenimsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Post Search Log New    ${orderRef}    ${applicationName}
	Log    Log is ${dataLogResponse}
	Check Log Detail    ${code}    ${description}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey}    ${EMPTY}    ${dataLogResponse}[4]    ${requestObject}    ${responseObject}    ${method}    ${orderRef}    ${listEndPointNameDB}    
    Check Log Summary    ${code}    ${description}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}    ${pathUrl}

Check Log Response Charging 
    #resultCode_summary[20000],resultDesc_summary[20000],Code_detail[20000],Description_detail[Register is Success],applicationName,pathUrl,urlCmdName,imsi_thingToken,ipAddress,payload,namespace,containerId,identity,cmdName,endPointName,logLevel,custom,SensorKey
    [Arguments]    ${code}    ${description}    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}    ${custom}    ${SensorKey}    ${requestObject}    ${responseObject}    ${method}    ${orderRef}    ${listEndPointNameDB}    ${APP}      
    #Log To Console    imsi_thingTokenimsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Post Search Log Charging For Coapp    ${orderRef}    ${applicationName}   

	Log    Log is ${dataLogResponse}

	Check Log Detail    ${code}    ${description}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey}    ${EMPTY}    ${dataLogResponse}[4]    ${requestObject}    ${responseObject}    ${method}    ${orderRef}    ${listEndPointNameDB}    
    Check Log Summary    ${code}    ${description}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}    ${pathUrl}
    [Return]    ${dataLogResponse}[4]

Check Log Detail 
    [Arguments]    ${code}    ${description}     ${data}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey}    ${valueKey}     ${sessionId}    ${requestObject}    ${responseObject}    ${method}    ${orderRef}    ${listEndPointNameDB}        

    Log    data${data} 
	
	${dataLogDetail}=    Log Detail Check EndPointName    ${data}
    Log    ${dataLogDetail}    

	#value ArrDetail Have EndPointName
	${valArrDetailNotHaveEndPointName}=    Set Variable    ${dataLogDetail}[0]
	Log    ${valArrDetailNotHaveEndPointName}
	#value ArrDetail Not Have EndPointName
	${valArrDetailHaveEndPointName_NotDB}=    Set Variable    ${dataLogDetail}[1]
	Log    ${valArrDetailHaveEndPointName_NotDB}
	#value ArrDetail Not Have EndPointName
	${valArrDetailHaveEndPointNameDB}=    Set Variable    ${dataLogDetail}[2]
	Log    ${valArrDetailHaveEndPointNameDB}
	#EndPointName		
	Check Log Detail Have EndPointName    ${code}    ${description}     ${valArrDetailHaveEndPointName_NotDB}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${SensorKey}    ${sessionId}    ${orderRef} 
	Check Log Detail Have EndPointNameDB    ${code}    ${description}     ${valArrDetailHaveEndPointNameDB}    ${tid}    ${applicationName}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${sessionId}    ${requestObject}    ${responseObject}    ${listEndPointNameDB}
	#un Keyword If    '${applicationName}'!='${VALUE_APPLICATIONNAME_COAPAPI}'    Check Log Detail Have EndPointName    ${code}    ${description}     ${valArrDetailHaveEndPointName_NotDB}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${SensorKey} 
    Check Log Detail App Do Not Have EndPointName    ${code}    ${description}     ${valArrDetailNotHaveEndPointName}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey}    ${valueKey}    ${sessionId}    ${method}    ${orderRef}   

	#Log To Console    thingTokenthingToken${thingToken} 	
	#[Return]    ${thingToken}
	
Log Detail Check EndPointName
    [Arguments]    ${data}
	${data_count}=    Get Length    ${data}
	#Log To Console    data_count${data_count}
    @{valArrDetailHaveEndPointName}=    Create List
	@{valArrDetailNotHaveEndPointName}=    Create List
	@{valArrDetailHaveEndPointNameDB}=    Create List
    @{valArrDetailHaveEndPointName_NotDB}=    Create List
    @{listEndPointNameDB}=    Create List
    FOR    ${i}    IN RANGE    ${data_count}
	    ${keyCustom1}=    Set Variable   @{data[${i}]['custom1']}
		#Log To Console    ${keyCustom1}    
		${checkKeyEndPointName}=    Get Matches    ${keyCustom1}    endPointName
		${countKeyEndPointName}=    Get Length    ${checkKeyEndPointName}
		Log    checkKeyEndPointName = ${checkKeyEndPointName} 
		Log    countKeyEndPointName = ${countKeyEndPointName} 
		Run Keyword If    ${countKeyEndPointName}==1    Append To List    ${valArrDetailHaveEndPointName}    ${data}[${i}]    #Add data to array set at valArrData
		Run Keyword If    ${countKeyEndPointName}==0    Append To List    ${valArrDetailNotHaveEndPointName}    ${data}[${i}]    #Add data to array set at valArrData
		

		#${data[${i}]['custom1']['endPointName']}
	END	
	${data_count_detail}=    Get Length    ${valArrDetailHaveEndPointName}
    FOR    ${j}    IN RANGE    ${data_count_detail}
	    ${keyCustom1}=    Set Variable   @{data[${i}]['custom1']}
		${custom1}=    Get From Dictionary    ${valArrDetailHaveEndPointName}[${j}]    custom1
		${endPointName}=    Get From Dictionary    ${custom1}    endPointName
		${checkKeyEndPointNameDB_Maching}=    Get Regexp Matches    ${endPointName}    db.*
		${checkKeyEndPointNameDB_Maching_Count}=    Get Length    ${checkKeyEndPointNameDB_Maching}
		Log    checkKeyEndPointNameDB_Maching = ${checkKeyEndPointNameDB_Maching} 
		#Log To Console    countKeyEndPointName${countKeyEndPointName} 
		Run Keyword If    ${checkKeyEndPointNameDB_Maching_Count}!=0    Append To List    ${valArrDetailHaveEndPointNameDB}    ${valArrDetailHaveEndPointName}[${j}]    #Add data to array set at valArrData
		Run Keyword If    ${checkKeyEndPointNameDB_Maching_Count}==0    Append To List    ${valArrDetailHaveEndPointName_NotDB}    ${valArrDetailHaveEndPointName}[${j}]    #Add data to array set at valArrData
		Run Keyword If    ${checkKeyEndPointNameDB_Maching_Count}!=0    Append To List    ${listEndPointNameDB}    ${endPointName}
		Log    valArrDetailHaveEndPointNameDB = ${valArrDetailHaveEndPointNameDB} 
		Log    valArrDetailHaveEndPointName_NotDB = ${valArrDetailHaveEndPointName_NotDB} 		
		Log    valArrDetailHaveEndPointName_NotDB = ${endPointName}
		#${data[${i}]['custom1']['endPointName']}
	END	
	#Log To Console    valArrDetailHaveEndPointName${valArrDetailHaveEndPointName}  
	#Log To Console    valArrDetailNotHaveEndPointName${valArrDetailNotHaveEndPointName}  
	[return]    ${valArrDetailNotHaveEndPointName}    ${valArrDetailHaveEndPointName_NotDB}    ${valArrDetailHaveEndPointNameDB}    ${listEndPointNameDB}

Set ThingToken CoapAPP
    [Arguments]    ${data}    ${field}
	#Log To Console    data${data} 
	#json.loads 2 round because data have \\
	${resp_json}=    Evaluate    json.loads(r'''${data}''')    json
	#Log To Console    resp_json${resp_json}
	${resp_json2}=    Evaluate    json.loads(r'''${resp_json}''')    json
	#Log To Console    resp_json2${resp_json2}
	${setThingToken}=    Set Variable    ${resp_json2['${field}']}   
	Set Global Variable    ${thingToken}    ${setThingToken}    
	[return]    ${setThingToken}
	
Set ThingToken CoapAPI
    [Arguments]    ${data}    ${field}
	#Log To Console    data${data} 
	#json.loads 2 round because data have \\
	${resp_json}=    Evaluate    json.loads(r'''${data}''')    json
	#Log To Console    resp_json${resp_json}
	${setThingToken}=    Set Variable    ${resp_json['${field}']}   
	Set Global Variable    ${thingToken}    ${setThingToken}    
	[return]    ${setThingToken}
	
Set ThingToken MQTT
    [Arguments]    ${data}    ${field}
	#Log To Console    data${data} 	
	${resp_json}=    Evaluate    json.loads(r'''${data}''')    json
	#Log To Console    resp_json${resp_json}
	${setThingToken}=    Set Variable    ${resp_json['${field}']}   
	#Log To Console    setThingToken${setThingToken}
	Set Global Variable    ${thingToken}    ${setThingToken}    
	[return]    ${setThingToken}

#-------------------------------------------- Check Log Detail Have EndPointName --------------------------------------------#	
Check Log Detail Have EndPointName  
    [Arguments]    ${code}    ${description}    ${data}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${SensorKey}    ${sessionId}    ${orderRef} 
    Log    data = ${data}
	${data_count}=    Get Length    ${data}
	${thingToken}=    Set Variable
	${index}=    Set Variable    0
	FOR    ${i}    IN RANGE    ${data_count}
		Log To Console    ${\n}============== Log Detail Have EndPointName Not DB #${index} ==============${\n}
		#Log To Console    ${data[${i}]['custom1']['requestObject']}
		#Log To Console    ${data[${i}]['custom1']['endPointName']}
		#Log To Console    ${code}
		
		#for set thingToke
		Log To Console    ${code}
		Run Keyword If    '${VALUE_APPLICATIONNAME_COAPAPP}'=='${applicationName}' and '${code}'=='${CODE_20000}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}'    Set ThingToken CoapAPP    ${data[${i}]['custom1']['responseObject']}    ThingToken     	
		Run Keyword If    '${VALUE_APPLICATIONNAME_COAPAPI}'=='${applicationName}' and '${code}'=='${CODE_20000}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_POST_REGISTER}'    Set ThingToken CoapAPP    ${data[${i}]['custom1']['responseObject']}    ThingToken     	
		Run Keyword If    '${VALUE_APPLICATIONNAME_MQTT}'=='${applicationName}' and '${code}'=='${CODE_20000}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}'   Set ThingToken MQTT    ${data[${i}]['custom1']['requestObject']}    body   

		
	    ${dataResponse}=    Set Variable    ${data[${i}]}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}']    ${data[${i}]['systemTimestamp']}    ${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGTYPE}']    ${VALUE_DETAIL}    ${FIELD_LOG_DETAIL_LOGTYPE} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGLEVEL}']    ${logLevel}    ${FIELD_LOG_DETAIL_LOGLEVEL} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_NAMESPACE}']    ${namespace}    ${FIELD_LOG_DETAIL_NAMESPACE}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_APPLICATIONNAME}']    ${applicationName}    ${FIELD_LOG_DETAIL_APPLICATIONNAME}
		#Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CONTAINERID}']    ${containerId}    ${FIELD_LOG_DETAIL_CONTAINERID}
		${sessionId}=    Set Variable If    '${VALUE_APPLICATIONNAME_MQTT}'=='${applicationName}'    ${tid} 
		...    '${VALUE_APPLICATIONNAME_MQTT}'!='${applicationName}'    ${sessionId}  
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SESSIONID}']    ${sessionId}    ${FIELD_LOG_DETAIL_SESSIONID}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_TID}']    ${tid}    ${FIELD_LOG_DETAIL_TID}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME}']    ${data[${i}]['custom1']['activityLog']['startTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}']    ${data[${i}]['custom1']['activityLog']['endTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}']    ${data[${i}]['custom1']['activityLog']['processTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}
        Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM2}']    ${VALUE_LOG_DETAIL_CUSTOM2}    ${FIELD_LOG_DETAIL_CUSTOM2}
    
		#Custom
		#Check endPointName
		Run Keyword If    '${DETAIL_ENDPOINTNAME_COAPAPISERVICE}'=='${data[${i}]['custom1']['endPointName']}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ENDPOINTNAME}']    ${endPointName}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ENDPOINTNAME}
		#MQTT
		Log    '${data[${i}]['custom1']['endPointName']}' 
		Log    ${endPointName}
		Run Keyword If    '${DETAIL_ENDPOINTNAME_RABBITMQ}'=='${data[${i}]['custom1']['endPointName']}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ENDPOINTNAME}']    ${endPointName}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ENDPOINTNAME}
		Run Keyword If    '${DETAIL_ENDPOINTNAME_ROCSSERVICE}'=='${data[${i}]['custom1']['endPointName']}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ENDPOINTNAME}']    ${endPointName}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ENDPOINTNAME}
		#Check requestObject responseObject  
		Check Log Detail Custom RequestObject and ResponseObject    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload_body}    ${SensorKey}    ${applicationName}    ${pathUrl}    ${sessionId}    ${orderRef}   
	    ${index}=    Evaluate    ${index}+1
	END

Check Log Detail Have EndPointName DB
    [Arguments]    ${code}    ${description}     ${data}    ${tid}    ${applicationName}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${sessionId}    ${requestObject}    ${responseObject}   ${listEndPointNameDB}  
    ${data_count}=    Get Length    ${data}
	#Log To Console    data_count${data_count}  
	${thingToken}=    Set Variable
	${index}=    Set Variable    0
	FOR    ${i}    IN RANGE    ${data_count}
		Log To Console    ${\n}============== Log Detail Have EndPointName DB #${index} : ${listEndPointNameDB}[${index}] ==============${\n}
	    ${dataResponse}=    Set Variable    ${data[${i}]}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}']    ${data[${i}]['systemTimestamp']}    ${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGTYPE}']    ${VALUE_DETAIL}    ${FIELD_LOG_DETAIL_LOGTYPE} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGLEVEL}']    ${logLevel}    ${FIELD_LOG_DETAIL_LOGLEVEL} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_NAMESPACE}']    ${namespace}    ${FIELD_LOG_DETAIL_NAMESPACE}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_APPLICATIONNAME}']    ${applicationName}    ${FIELD_LOG_DETAIL_APPLICATIONNAME}
		#Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CONTAINERID}']    ${containerId}    ${FIELD_LOG_DETAIL_CONTAINERID}
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SESSIONID}']    ${sessionId}    ${FIELD_LOG_DETAIL_SESSIONID}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_TID}']    ${tid}    ${FIELD_LOG_DETAIL_TID}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ENDPOINTNAME}']   ${listEndPointNameDB}[${${index}}]    '${FIELD_LOG_DETAIL_CUSTOM1}'.'${FIELD_LOG_DETAIL_ENDPOINTNAME}
		#check request Object  
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}
		#check response Object  
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
        #check activityLog 
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME}']    ${data[${i}]['custom1']['activityLog']['startTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}']    ${data[${i}]['custom1']['activityLog']['endTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}']    ${data[${i}]['custom1']['activityLog']['processTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}
        #check custom2 
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM2}']    ${VALUE_LOG_DETAIL_CUSTOM2}    ${FIELD_LOG_DETAIL_CUSTOM2}
		#Check Log Detail Custom RequestObject and ResponseObject    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload_body}    ${SensorKey}    ${applicationName}    ${pathUrl}    ${sessionId}    ${orderRef}   
	    ${index}=    Evaluate    ${index}+1
	END


#-------------------------------------------- Check Log Detail : RequestObject and ResponseObject Have EndPointName --------------------------------------------#		
Check Log Detail Custom RequestObject and ResponseObject
	[Arguments]    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload_body}    ${SensorKey}    ${applicationName}    ${pathUrl}    ${sessionId}    ${orderRef}  
	Log    ${dataResponse}
	#-------------------------------------------- Coapp App --------------------------------------------#
	#RequestObject : Coapp App [Register]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}'    Check RequestObject Success CoapAPP Register    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}
	#ResponseObject : Coapp App [Register]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}' and '${code}'=='${CODE_20000}'    Check ResponseObject Success CoapAPP Register    ${code}    ${description}    ${dataResponse}
	
	#RequestObject : Coapp App [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT}'    Check RequestObject Success CoapAPP Report    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload_body}
	#ResponseObject : Coapp App [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT}' and '${code}'=='${CODE_20000}'    Check ResponseObject Success CoapAPP Report    ${code}    ${description}    ${dataResponse}   
	
	#RequestObject : Coapp App [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}'    Check RequestObject Success CoapAPP Config    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload_body}
	#ResponseObject : Coapp App [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}' and '${code}'=='${CODE_20000}'    Check ResponseObject Success CoapAPP Config    ${code}    ${description}    ${dataResponse}    ${urlCmdName}   
	
	#RequestObject : Coapp App [Delta]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_DELTA}'    Check RequestObject Success CoapAPP Delta    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload_body}
	#ResponseObject : Coapp App [Delta]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_DELTA}' and '${code}'=='${CODE_20000}'    Check ResponseObject Success CoapAPP Delta    ${code}    ${description}    ${dataResponse}    ${payload_body}   
	
	#Error !20000
	Run Keyword If    '${code}'!='${CODE_20000}'    Check ResponseObject Error    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_CMDNAME_ERROR}    ${code}    ${description}    ${dataResponse}
	
	#-------------------------------------------- Coapp Api --------------------------------------------#	

	#ResponseObject : Coapp Api [Report]
	Run Keyword If    '${VALUE_APPLICATIONNAME_COAPAPI}'=='${applicationName}' and '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_POST_REPORT}'    Check RequestObject Success CoapAPI Report    ${dataResponse}    ${urlCmdName}    ${tid}    ${payload_body}    ${imsi_thingToken}
	#ResponseObject : Coapp Api [Report]
	#Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_POST_REPORT}' and '${code}'=='${CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_CMDNAME_REPORT}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
	Run Keyword If    '${VALUE_APPLICATIONNAME_COAPAPI}'=='${applicationName}' and '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${code}'=='${CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_CMDNAME_REPORT}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
	
	#-------------------------------------------- MQTT --------------------------------------------#
	#ResponseObject : MQTT [Register]
	Run Keyword If    '${VALUE_APPLICATIONNAME_MQTT}'=='${applicationName}' and '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}'    Check RequestObject Success MQTT Register    ${dataResponse}    ${urlCmdName}
	#ResponseObject : MQTT [Register]
	Run Keyword If    '${VALUE_APPLICATIONNAME_MQTT}'=='${applicationName}' and '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}' and '${code}'=='${CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_CMDNAME_REGISTER}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
	
	#ResponseObject : MQTT [Report]
	Run Keyword If    '${VALUE_APPLICATIONNAME_MQTT}'=='${applicationName}' and '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT_MQTT}'    Check RequestObject Success MQTT Report    ${dataResponse}    ${urlCmdName}    ${tid}    ${payload_body}
	#ResponseObject : MQTT [Report]
	Run Keyword If    '${VALUE_APPLICATIONNAME_MQTT}'=='${applicationName}' and '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT_MQTT}' and '${code}'=='${CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_CMDNAME_REPORT}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
	
	
	#ResponseObject : MQTT [Config]
	Run Keyword If    '${VALUE_APPLICATIONNAME_MQTT}'=='${applicationName}' and '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT}'    Check RequestObject Success MQTT Config    ${dataResponse}    ${urlCmdName}    ${tid}    ${payload_body}
	#ResponseObject : MQTT [Config]
	Run Keyword If    '${VALUE_APPLICATIONNAME_MQTT}'=='${applicationName}' and '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT}' and '${code}'=='${CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_CMDNAME_REPORT}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
	
	#-------------------------------------------- HTTP --------------------------------------------#
	#RequestObject : HTTP [Report]
	Run Keyword If    '${VALUE_APPLICATIONNAME_HTTP}'=='${applicationName}' and '${pathUrl}'=='${URL_AsgardHTTPReport}'    Check RequestObject HTTP Have EndPointName    ${dataResponse}    ${payload_body}    ${pathUrl}    ${sessionId}    ${orderRef}    ${urlCmdName}
	#ResponseObject : HTTP [Report]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_HTTP}' and '${pathUrl}'=='${URL_AsgardHTTPReport}'    Check ResponseObject HTTP Report     ${dataResponse}    ${imsi_thingToken}    ${code}    ${description}

	#-------------------------------------------- Charging --------------------------------------------#
	#RequestObject : Charging [Report]
	Run Keyword If    '${VALUE_APPLICATIONNAME_CHARGING}'=='${applicationName}'    Check RequestObject Charging HTTP With EndpointName    ${dataResponse}    ${pathUrl}    ${payload_body}
	#ResponseObject : Charging [Report]
	Run Keyword If    '${VALUE_APPLICATIONNAME_CHARGING}'=='${applicationName}' and '${code}'=='${CODE_20000}'    Check ResponseObject App Success Charging HTTP With EndpointName     ${dataResponse}    ${code}    ${description}


#--------------------------------------------  ResponseObject Error Have EndPointName --------------------------------------------#
Check ResponseObject Error  
    [Arguments]    ${value}    ${code}    ${description}    ${dataResponse}
	
	#${code}=    Set Variable    ${code}
	${code} =	Set Variable If    '${code}'=='${CODE_40300}'    ${CODE_40400}
	...    '${code}'!='${CODE_40300}'    ${code}
	#Log To Console    code${code}

	${replaceCodeCmdName}=    Replace String    ${value}    [Code]    ${code}
	${replaceDescriptionCmdName}=    Replace String    ${replaceCodeCmdName}    [DeveloperMessage]    ${description}

	${responseObject}=    Replace String To Object    ${replaceDescriptionCmdName}
	#Log To Console    responseObjectError${responseObject}
			
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
		
#-------------------------------------------- Check Log Detail Do Not Have EndPointName --------------------------------------------#		
Check Log Detail App Do Not Have EndPointName
    [Arguments]    ${code}    ${description}     ${data}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey}    ${valueKey}    ${sessionId}    ${method}    ${orderRef} 
    ${data_count}=    Get Length    ${data}
	${index}=    Set Variable    0  
	FOR    ${i}    IN RANGE    ${data_count}
		Log To Console    ${\n}============== Log Detail Not Have EndPointName #${index} ==============${\n}	 
	    ${dataResponse}=    Set Variable    ${data[${i}]}
		Log    ${dataResponse} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}']    ${data[${i}]['systemTimestamp']}    ${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGTYPE}']    ${VALUE_DETAIL}    ${FIELD_LOG_DETAIL_LOGTYPE}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGLEVEL}']    ${logLevel}    ${FIELD_LOG_DETAIL_LOGLEVEL}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_NAMESPACE}']    ${namespace}    ${FIELD_LOG_DETAIL_NAMESPACE}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_APPLICATIONNAME}']    ${applicationName}    ${FIELD_LOG_DETAIL_APPLICATIONNAME}
		#Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CONTAINERID}']    ${containerId}    ${FIELD_LOG_DETAIL_CONTAINERID}
		${sessionId}=    Set Variable If    '${VALUE_APPLICATIONNAME_MQTT}'=='${applicationName}'    ${tid} 
		...    '${VALUE_APPLICATIONNAME_MQTT}'!='${applicationName}'    ${sessionId}  
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SESSIONID}']    ${sessionId}    ${FIELD_LOG_DETAIL_SESSIONID}
		Log    ${cmdName}
		#${tid}=    Set Variable If    '${VALUE_APPLICATIONNAME_CHARGING}'=='${applicationName}'    ${sessionId} 
		#...    ${tid}  
		#Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_TID}']    ${tid}    ${FIELD_LOG_DETAIL_TID}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME}']    ${data[${i}]['custom1']['activityLog']['startTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}']    ${data[${i}]['custom1']['activityLog']['endTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}']    ${data[${i}]['custom1']['activityLog']['processTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}
        Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM2}']    ${VALUE_LOG_DETAIL_CUSTOM2}    ${FIELD_LOG_DETAIL_CUSTOM2}

		#for set thingToken
		Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_POST_REGISTER}' and '${code}'=='${CODE_20000}'    Run Keyword    Set ThingToken CoapAPI    ${data[${i}]['custom1']['responseObject']}    ThingToken     	
		#Log To Console    thingToken${thingToken}
		
		Check Log Detail Custom RequestObject and ResponseObject App    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload_body}    ${pathUrl}    ${identity}    ${custom}    ${SensorKey}    ${applicationName}    ${valueKey}    ${method}    ${sessionId}    ${orderRef} 
        ${index}=    Evaluate    ${index}+1				
	END
#-------------------------------------------- Check Log Detail : RequestObject and ResponseObject --------------------------------------------#		
Check Log Detail Custom RequestObject and ResponseObject App
	[Arguments]    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload_body}    ${pathUrl}    ${identity}    ${custom}    ${SensorKey}    ${applicationName}    ${valueKey}    ${method}    ${sessionId}    ${orderRef}   
	#-------------------------------------------- Coapp App --------------------------------------------#	
	#RequestObject : Coapp App [Register]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}'    Check RequestObject App Success CoapAPP Register    ${dataResponse}    ${pathUrl}
	#ResponseObject : Coapp App [Register]
	#${thingToken} received from Set Global Variable
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}' and '${code}'=='${CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    "${thingToken}"    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
	
	#RequestObject : Coapp App [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT}'    Check RequestObject App Success CoapAPP Report    ${dataResponse}    ${pathUrl}    ${payload_body}    ${SensorKey}
	#ResponseObject : Coapp App [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT}' and '${code}'=='${CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    "${code}"    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
	
	#RequestObject : Coapp App [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}'    Check RequestObject App Success CoapAPP Config    ${dataResponse}    ${pathUrl}
	#ResponseObject : Coapp App [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}' and '${code}'=='${CODE_20000}'    Check ResponseObject App Success CoapAPP Config    ${dataResponse}    ${urlCmdName} 
	
	#RequestObject : Coapp App [Delta]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_DELTA}'    Check RequestObject App Success CoapAPP Delta    ${dataResponse}    ${pathUrl}
	#ResponseObject : Coapp App [Delta]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_DELTA}' and '${code}'=='${CODE_20000}'    Check ResponseObject App Success CoapAPP Delta    ${dataResponse}    ${payload_body}    ${SensorKey}    ${urlCmdName}        
	
	#ResponseObject : Coapp App [Error !20000]
	Run Keyword If    '${code}'!='${CODE_20000}' and '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    "${code}"    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
	
	#-------------------------------------------- Coapp Api --------------------------------------------#	
	#RequestObject : Coapp Api [Register]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_POST_REGISTER}'    Check RequestObject App Success CoapAPI Register    ${dataResponse}    ${tid}    ${urlCmdName}    ${payload_body}    ${identity}    ${custom}    
	#ResponseObject : Coapp Api [Register]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_POST_REGISTER}' and '${code}'=='${CODE_20000}'    Check ResponseObject App Success CoapAPI Register    ${code}    ${description}    ${dataResponse}
	
	#RequestObject : Coapp Api [Report]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_POST_REPORT}'    Check RequestObject App Success CoapAPI Report    ${dataResponse}    ${tid}    ${urlCmdName}    ${payload_body}    ${identity}    ${custom}    
	#ResponseObject : Coapp Api [Report]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_POST_REPORT}' and '${code}'=='${CODE_20000}'    Check ResponseObject App Success CoapAPI Report    ${code}    ${description}    ${dataResponse}
	
	#RequestObject : Coapp Api [Config]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_GET_CONFIG}'    Check RequestObject App Success CoapAPI Config    ${dataResponse}    ${tid}    ${urlCmdName}    ${payload_body}    ${identity}    ${custom}    
	#ResponseObject : Coapp Api [Config]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_GET_CONFIG}' and '${code}'=='${CODE_20000}'    Check ResponseObject App Success CoapAPI Config    ${code}    ${description}    ${dataResponse}    ${pathUrl}

	#RequestObject : Coapp Api [Delta]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_GET_DELTA}'    Check RequestObject App Success CoapAPI Delta    ${dataResponse}    ${tid}    ${urlCmdName}    ${payload_body}    ${identity}    ${custom}    
	#ResponseObject : Coapp Api [Delta]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_GET_DELTA}' and '${code}'=='${CODE_20000}'    Check ResponseObject App Success CoapAPI Delta    ${code}    ${description}    ${dataResponse}    ${pathUrl}    ${valueKey}

	#ResponseObject : Coapp Api [Error !20000]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${code}'!='${CODE_20000}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_POST_REGISTER}'    Check ResponseObject Error App    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_ERROR}    ${code}    ${description}    ${dataResponse}    ${endPointName}
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${code}'!='${CODE_20000}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_POST_REPORT}'    Check ResponseObject Error App    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_ERROR}    ${code}    ${description}    ${dataResponse}    ${endPointName}
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${code}'!='${CODE_20000}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_GET_CONFIG}'    Check ResponseObject Error App    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_ERROR}    ${code}    ${description}    ${dataResponse}    ${endPointName}
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_COAPAPI}' and '${code}'!='${CODE_20000}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_GET_DELTA}'    Check ResponseObject Error App    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_ERROR}    ${code}    ${description}    ${dataResponse}    ${endPointName}
	
	
	#-------------------------------------------- MQTT --------------------------------------------#
	#RequestObject : MQTT [Register]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_MQTT}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}'    Check RequestObject App Success MQTT Register    ${dataResponse}    ${pathUrl}    ${tid}    ${payload_body}
	#ResponseObject : MQTT [Register]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_MQTT}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}' and '${code}'=='${CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_APP_REGISTER}     ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}
	#RequestObject : MQTT [Report]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_MQTT}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT_MQTT}'    Check RequestObject App Success MQTT Report    ${dataResponse}    ${pathUrl}    ${tid}    ${payload_body}    ${SensorKey}
	#ResponseObject : MQTT [Report]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_MQTT}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT_MQTT}' and '${code}'=='${CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_APP_REPORT}     ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}	
	#RequestObject : MQTT [Config]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_MQTT}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT}'    Check RequestObject App Success MQTT Config    ${dataResponse}    ${pathUrl}    ${tid}
	#ResponseObject : MQTT [Config]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_MQTT}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT}' and '${code}'=='${CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_APP_REPORT}     ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}	
	#ResponseObject : MQTT [Error !20000]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_MQTT}' and '${code}'!='${CODE_20000}' and '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_APP_ERROR}     ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}

	#-------------------------------------------- HTTP --------------------------------------------#
	Log    ${pathUrl}
	#RequestObject : HTTP [Register,Report,Config,Delta]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_HTTP}'    Check RequestObject HTTP    ${dataResponse}    ${pathUrl}    ${tid}    ${payload_body}    ${method}    ${identity}    ${custom}    ${sessionId}    ${orderRef}
	#ResponseObject : HTTP [Register]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_HTTP}' and '${pathUrl}'=='${URL_AsgardHTTPRegister}'    Check ResponseObject HTTP Register     ${dataResponse}    ${imsi_thingToken}    ${code}    ${description}
	#ResponseObject : HTTP [Report]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_HTTP}' and '${code}'=='${CODE_20000}' and '${pathUrl}'=='${URL_AsgardHTTPReport}'    Check ResponseObject HTTP Report     ${dataResponse}    ${imsi_thingToken}    ${code}    ${description}
	#ResponseObject : MQTT [Config]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_HTTP}' and '${pathUrl}'=='${URL_AsgardHTTPConfig}'    Check ResponseObject HTTP Config     ${dataResponse}    ${payload_body}    ${code}    ${description}
	#ResponseObject : MQTT [Delta]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_HTTP}' and '${pathUrl}'=='${URL_AsgardHTTPDelta}'    Check ResponseObject HTTP Delta     ${dataResponse}    ${payload_body}    ${code}    ${description}
	
	#-------------------------------------------- Charging --------------------------------------------#
	#RequestObject : Charging Coapp App [Report]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_CHARGING}'    Check RequestObject Charging HTTP    ${dataResponse}    ${pathUrl}    ${payload_body}    ${imsi_thingToken}
	#ResponseObject : Charging Coapp App [Report]
	Run Keyword If    '${applicationName}'=='${VALUE_APPLICATIONNAME_CHARGING}' and '${code}'=='${CODE_20000}'    Check ResponseObject App Success Charging HTTP     ${code}    ${description}    ${dataResponse}
	 
#--------------------------------------------  ResponseObject Error Have EndPointName --------------------------------------------#
Check ResponseObject Error App  
    [Arguments]    ${value}    ${code}    ${description}    ${dataResponse}    ${endPointName}
	
	#${code}=    Set Variable    ${code}
	${code} =	Set Variable If    '${code}'=='${CODE_40300}'    ${CODE_40400}
	...    '${code}'!='${CODE_40300}'    ${code}
	#Log To Console    code${code}

	${value} =	Set Variable If    '${endPointName}'=='${ASGARD_COAPAPI_VALUE_TST_F2_1_0_008_SENSOR_INVALID}'    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_GET_ERROR}
	...    '${endPointName}'!='${ASGARD_COAPAPI_VALUE_TST_F2_1_0_008_SENSOR_INVALID}'   ${value}
	
	${value} =	Set Variable If    '${endPointName}'=='${ASGARD_COAPAPI_VALUE_TST_F3_1_0_008_SENSOR_INVALID}'    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_GET_ERROR}
	...    '${endPointName}'!='${ASGARD_COAPAPI_VALUE_TST_F3_1_0_008_SENSOR_INVALID}'   ${value}
	
	
	${replaceCodeCmdName}=    Replace String    ${value}    [Code]    ${code}
	${replaceDescriptionCmdName}=    Replace String    ${replaceCodeCmdName}    [DeveloperMessage]    ${description}

	${responseObject}=    Replace String To Object    ${replaceDescriptionCmdName}
	#Log To Console    responseObject${responseObject}
			
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}

Check Log Response 
    #resultCode_summary[20000],resultDesc_summary[20000],Code_detail[20000],Description_detail[Register is Success],applicationName,pathUrl,urlCmdName,imsi_thingToken,ipAddress,payload,namespace,containerId,identity,cmdName,endPointName,logLevel,custom,SensorKey
    [Arguments]    ${resultCode_summary}    ${resultDesc_summary}    ${code_detail}    ${description_detail}    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}    ${custom}    ${SensorKey}    ${requestObject}    ${responseObject}    ${method}    ${orderRef}    ${listEndPointNameDB}      
    #Log To Console    imsi_thingTokenimsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Data Log Response    ${applicationName}    ${imsi_thingToken}    ${endPointName}
	Log    Log is ${dataLogResponse}
	Check Log Detail    ${code_detail}    ${description_detail}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey}    ${EMPTY}    ${dataLogResponse}[4]    ${requestObject}    ${responseObject}    ${method}    ${orderRef}    ${listEndPointNameDB}    
    Check Log Summary    ${resultCode_summary}    ${resultDesc_summary}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}    ${pathUrl}


Coap API Check Log Response 
    #resultCode_summary[20000],resultDesc_summary[20000],Code_detail[20000],Description_detail[Register is Success],applicationName,pathUrl,urlCmdName,imsi_thingToken,ipAddress,payload,namespace,containerId,identity,cmdName,endPointName,logLevel,custom,SensorKey
    [Arguments]    ${resultCode_summary}    ${resultDesc_summary}    ${code_detail}    ${description_detail}    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}    ${custom}    ${SensorKey}    ${valueKey}    ${requestObject}    ${responseObject}    ${method}    ${orderRef}    ${listEndPointNameDB}        
    #Log To Console    imsi_thingTokenimsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Data Log Response    ${applicationName}    ${imsi_thingToken}    ${endPointName}
	Log    Log is ${dataLogResponse}
	Log    Log is ${valueKey}
	Check Log Detail    ${code_detail}    ${description_detail}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey}    ${valueKey}    ${dataLogResponse}[4]    ${requestObject}    ${responseObject}    ${method}    ${orderRef}    ${listEndPointNameDB} 
    Check Log Summary    ${resultCode_summary}    ${resultDesc_summary}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}    ${pathUrl}
    #Log To Console    thingToken${thingToken}
    #return thingToken from set global variable


# MQTT CheckLog
MQTT Check Log Response  
    #resultCode_summary[20000],resultDesc_summary[20000],Code_detail[20000],Description_detail[Register is Success],applicationName,pathUrl,urlCmdName,imsi_thingToken,ipAddress,body,namespace,containerId,identity,cmdName,endPointNameSimRegister,endPointNameCoapAPP,logLevel,valueSearchText,custom,SensorKey
    [Arguments]    ${resultCode_summary}    ${resultDesc_summary}    ${code_detail}    ${description_detail}    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${body}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}    ${valueSearchText}    ${custom}    ${SensorKey}     
    #Log To Console    imsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Data Log Response    ${applicationName}    ${valueSearchText}${imsi_thingToken}    ${endPointName}
	
	#${thingToken}=    Check Log Detail    ${code_detail}    ${description_detail}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey}    ${EMPTY} 
	Check Log Detail    ${code_detail}    ${description_detail}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey}    ${EMPTY}    ${EMPTY}     ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    Check Log Summary    ${resultCode_summary}    ${resultDesc_summary}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}    ${EMPTY}
    #Log To Console    thingToken${thingToken}
    #[Return]    ${thingToken}

MQTT Check Log Response Delta  
    #resultCode_summary[20000],resultDesc_summary[20000],Code_detail[20000],Description_detail[Register is Success],applicationName,pathUrl,urlCmdName,imsi_thingToken,ipAddress,body,namespace,containerId,identity,cmdName,endPointNameSimRegister,endPointNameCoapAPP,logLevel,valueSearchText,custom,SensorKey
    [Arguments]    ${resultCode_summary}    ${resultDesc_summary}    ${code_detail}    ${description_detail}    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${body}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}    ${valueSearchText}    ${custom}    ${SensorKey}    ${ValueKey}     
    #Log To Console    imsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Data Log Response    ${applicationName}    ${imsi_thingToken}    ${endPointName}
	
	Check Log Detail    ${code_detail}    ${description_detail}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey}    ${ValueKey}    ${EMPTY}     ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY} 
    Check Log Summary    ${resultCode_summary}    ${resultDesc_summary}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}    ${EMPTY}
    #Log To Console    thingToken${thingToken}
    #[Return]    ${thingToken}

MQTT Check Log Response Charging  
    #resultCode_summary[20000],resultDesc_summary[20000],Code_detail[20000],Description_detail[Register is Success],applicationName,pathUrl,urlCmdName,imsi_thingToken,ipAddress,body,namespace,containerId,identity,cmdName,endPointNameSimRegister,endPointNameCoapAPP,logLevel,valueSearchText,custom,SensorKey
    [Arguments]    ${resultCode_summary}    ${resultDesc_summary}    ${code_detail}    ${description_detail}    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${ThingToken}    ${ipAddress}    ${body}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}    ${valueSearchText}    ${custom}    ${SensorKey}     
    #Log To Console    imsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Data Log Response    ${applicationName}    ${valueSearchText}${imsi_thingToken}    ${endPointName}
	
	#Check Log Detail    ${code_detail}    ${description_detail}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey} 
    Check Log Summary    ${resultCode_summary}    ${resultDesc_summary}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}
    #Log To Console    thingToken${thingToken}
    #return thingToken from set global variable

Replace String To Object
    [Arguments]    ${string}
    
	${replStringToJsonStart}=    Replace String    ${string}    "{    {
	${replStringToJsonEnd}=    Replace String    ${replStringToJsonStart}    }"    }
	[RETURN]    ${replStringToJsonEnd}
	
#Check Json Data Should Be Equal
#	[Arguments]    ${JsonData}    ${field}    ${expected}
	
	#json.dumps use for parameter convert ' to "
#	${listAsString}=    Evaluate    json.dumps(${JsonData})    json
	#r use for parameter / have in data
#	${resp_json}=    Evaluate    json.loads(r'''${listAsString}''')    json
	#Log To Console    resp_json${resp_json}	
    #Should Be Equal    ${resp_json['${field}']}    ${expected}
	#Log To Console    resp_json${resp_json${field}}	
	#Log To Console    expected${expected}	
#    Should Be Equal    ${resp_json${field}}    ${expected}    error=${field}
