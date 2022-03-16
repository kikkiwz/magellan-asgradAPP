*** Keywords ***	
#-------------------------------------------- Check Log Summary --------------------------------------------#		
Check Log Summary
    [Arguments]    ${resultCode}    ${resultDesc}    ${data}    ${tid}    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}    ${pathUrl}
	Log To Console    ${\n}============== Check Log Summary ==============${\n}
	${dataResponse}=    Set Variable    ${data[0]} 
    Log    ${dataResponse}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_SYSTEMTIMESTAP}']    ${data[0]['systemTimestamp']}    ${FIELD_LOG_SUMMARY_SYSTEMTIMESTAP}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_LOGTYPE}']    ${VALUE_SUMMARY}    ${FIELD_LOG_SUMMARY_LOGTYPE}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_NAMESPACE}']    ${namespace}    ${FIELD_LOG_SUMMARY_NAMESPACE}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_APPLICATIONNAME}']    ${applicationName}    ${FIELD_LOG_SUMMARY_APPLICATIONNAME}
	#Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CONTAINERID}']    ${containerId}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_SESSIONID}']    ${data[0]['sessionId']}    ${FIELD_LOG_SUMMARY_SESSIONID}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_TID}']    ${data[0]['tid']}    ${FIELD_LOG_SUMMARY_TID}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_IDENTITY}']    ${identity}    ${FIELD_LOG_SUMMARY_IDENTITY}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CMDNAME}']    ${cmdName}    ${FIELD_LOG_SUMMARY_CMDNAME} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_RESULTCODE}']    ${resultCode}    ${FIELD_LOG_SUMMARY_RESULTCODE} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_RESULTDESC}']    ${resultDesc}    ${FIELD_LOG_SUMMARY_RESULTDESC}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_REQTIMESTAP}']    ${data[0]['reqTimestamp']}    ${FIELD_LOG_SUMMARY_REQTIMESTAP} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_RESTIMESTAMP}']    ${data[0]['resTimestamp']}    ${FIELD_LOG_SUMMARY_RESTIMESTAMP}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_USAGETIME}']    ${data[0]['usageTime']}    ${FIELD_LOG_SUMMARY_USAGETIME} 
	${result}=    Check Custom None    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CUSTOM}'] 
	${status_custom_null}=    Set Variable    ${result}[0]
	${custom_actual}=    Set Variable    ${result}[1]
	${status_customdata}=    Check Field None    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CUSTOM}']['${FIELD_LOG_SUMMARY_CUSTOMDATA}']
	${status_endpointSummary}=    Check Field None    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CUSTOM}']['${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}']
	#Register check customdata and endPointSummary
	#check step MQTT Register
	# Run Keyword If    '${VALUE_APPLICATIONNAME_MQTT}'=='${applicationName}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}'    Check customData and endPointSummary Register    ${custom}    ${dataResponse}
	#check step HTTP Register
	Run Keyword If    '${VALUE_APPLICATIONNAME_HTTP}'=='${applicationName}' and '${status_custom_null}'=='True'    Data Should Be Equal    ${custom}    ${custom_actual}    ${FIELD_LOG_SUMMARY_CUSTOM}
	Run Keyword If    '${VALUE_APPLICATIONNAME_HTTP}'=='${applicationName}' and '${status_custom_null}'=='False' and '${status_customdata}'=='True'    Check customData    ${custom}    ${dataResponse}
	Run Keyword If    '${VALUE_APPLICATIONNAME_HTTP}'=='${applicationName}' and '${status_custom_null}'=='False' and '${status_endpointSummary}'=='True'    Check endPointSummary    ${custom}    ${dataResponse}    ${pathUrl}    ${cmdName}   

	Run Keyword If    '${VALUE_APPLICATIONNAME_COAPAPI}'=='${applicationName}' and '${status_custom_null}'=='True'    Data Should Be Equal    ${custom}    ${custom_actual}    ${FIELD_LOG_SUMMARY_CUSTOM}
	Run Keyword If    '${VALUE_APPLICATIONNAME_COAPAPI}'=='${applicationName}' and '${status_custom_null}'=='False' and '${status_customdata}'=='True'    Check customData    ${custom}    ${dataResponse}
	Run Keyword If    '${VALUE_APPLICATIONNAME_COAPAPI}'=='${applicationName}' and '${status_custom_null}'=='False' and '${status_endpointSummary}'=='True'    Check endPointSummary    ${custom}    ${dataResponse}    ${pathUrl}    ${cmdName}
	#check step Charging HTTP 
	Run Keyword If    '${VALUE_APPLICATIONNAME_HTTP}'=='${applicationName}' and '${status_custom_null}'=='True'    Data Should Be Equal    ${custom}    ${custom_actual}    ${FIELD_LOG_SUMMARY_CUSTOM}
	#check step Charging Coap
	Run Keyword If    '${VALUE_APPLICATIONNAME_CHARGING}'=='${applicationName}' and '${status_custom_null}'=='False' and '${status_endpointSummary}'=='True'    Check endPointSummary    ${custom}    ${dataResponse}    ${pathUrl}    ${cmdName}   
		
Check customData and endPointSummary Register	
    [Arguments]    ${custom}    ${dataResponse}  
	${json_custom}=    Convert String to JSON    ${custom}
	${customdata}=    Set Variable    ${json_custom['customData']}
	Log    ${customdata}
	${endPointSummary}=    Set Variable    ${json_custom['endPointSummary']}
	Log    ${endPointSummary}
	#ดึงค่า processTime จาก response ที่ได้
	${dataResponse_processTime_value1}=    Set Variable     ${dataResponse['${FIELD_LOG_SUMMARY_CUSTOM}']['${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}'][0]['processTime']}     
	${dataResponse_processTime_value2}=    Set Variable    ${dataResponse['${FIELD_LOG_SUMMARY_CUSTOM}']['${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}'][1]['processTime']}
	${endPointSummary_update_step1}=    Update Value To Json    ${json_custom['${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}'][0]}    processTime    ${dataResponse_processTime_value1}
	${endPointSummary_update_step2}=    Update Value To Json    ${json_custom['${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}'][1]}    processTime    ${dataResponse_processTime_value2}
	Log    ${endPointSummary_update_step1}
	Log    ${endPointSummary_update_step2}
	#check customdata
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CUSTOM}']['${FIELD_LOG_SUMMARY_CUSTOMDATA}']     ${customdata}    ${FIELD_LOG_SUMMARY_CUSTOM}.${FIELD_LOG_SUMMARY_CUSTOMDATA} 
	#check endPointSummary
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CUSTOM}']['${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}'][0]     ${endPointSummary_update_step1}    ${FIELD_LOG_SUMMARY_CUSTOM}.${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CUSTOM}']['${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}'][1]     ${endPointSummary_update_step2}    ${FIELD_LOG_SUMMARY_CUSTOM}.${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY} 

Check CustomData	
   [Arguments]    ${custom}    ${dataResponse}
	Log To Console    ${\n}============ check customData${\n}
	${json_custom}=    Convert String to JSON    ${custom}
	Log    ${json_custom}
	#check customdata
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CUSTOM}']['${FIELD_LOG_SUMMARY_CUSTOMDATA}']     ${json_custom}    ${FIELD_LOG_SUMMARY_CUSTOM}.${FIELD_LOG_SUMMARY_CUSTOMDATA}   

Check endPointSummary 	
   [Arguments]    ${custom}    ${dataResponse}    ${pathUrl}    ${cmdName}
	#--------- Check customData--------------
	Log To Console    ${\n}============ check endPointSummary${\n}
	#expect
	Log    ${pathUrl}
	#Log To Console    splitUrl${splitUrl}
	${endPointSummary_expect}=    Set Variable If    
	...    '${pathUrl}'=='${URL_AsgardHTTPRegister}' or '${cmdName}'=='Register'    ${ENDPOINT_SUMMARY_REGISTER}
	...    '${pathUrl}'=='${URL_AsgardHTTPReport}' or '${cmdName}'=='Report'        ${ENDPOINT_SUMMARY_REPORT}
	...    '${pathUrl}'=='${URL_AsgardHTTPConfig}' or '${cmdName}'=='Config'        ${ENDPOINT_SUMMARY_CONFIG}
	...    '${pathUrl}'=='${URL_AsgardHTTPDelta}' or '${cmdName}'=='Delta'        ${ENDPOINT_SUMMARY_DELTA}
	...    '${cmdName}'=='PostCharging'    ${ENDPOINT_SUMMARY_Charging}
	${endPointSummary_expect_json}=    Convert String to JSON    ${endPointSummary_expect}
    #{endPointSummary_expect_json_lass}=    Set Variable    ${endPointSummary_expect_json['endPointSummary']}
	Log    endPointSummary Expect = ${endPointSummary_expect_json}   
    Log    dataResponse Actual = ${dataResponse} 
    #Loop Check Step in Summary
	${data_count}=    Get Length    ${dataResponse['${FIELD_LOG_SUMMARY_CUSTOM}']['${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}']} 
	FOR    ${i}    IN RANGE    ${data_count} 
        ${processTime_value1}=    Set Variable     ${dataResponse['${FIELD_LOG_SUMMARY_CUSTOM}']['${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}'][${${i}}]['processTime']} 
	    ${endPointSummary_expect_final}=    Update Value To Json    ${endPointSummary_expect_json['${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}'][${i}]}    processTime    ${processTime_value1}
	    Log    ${endPointSummary_expect_final}
		Log To Console    ${\n}============ check endPointSummary step#${i}${\n}
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CUSTOM}']['${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}'][${i}]     ${endPointSummary_expect_final}    ${FIELD_LOG_SUMMARY_CUSTOM}.${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}
	END

