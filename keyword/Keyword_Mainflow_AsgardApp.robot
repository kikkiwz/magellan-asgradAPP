*** Keywords ***
####################################################
#                 Register
####################################################
RegisterSuccess
    [Arguments]    ${getData}
	#Set IMSI
	${IMSI}=    Set Variable    ${getData}[0]
    #Replace URL Register 
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL}    ${ASGARD_COAPAPP_URL_REGISTER}    ${ASGARD_COAPAPP_FIELD_IMSI}    ${IMSI}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	Log To Console    Register Url is : ${url}
	#Register Success
    ${registerResponse}=    RegisterAsgardApp    ${url}
	ConnectMongodb
	${Json_Search}=    Set Variable    {"ThingSecret":"${IMSI}"}
	${result}=    Search By Select Fields    ${MGCORE_DBNAME}    ${MGCORE_COLLECTION_THING}    ${Json_Search}    ThingToken
	${thingToken}=    Get From Dictionary    ${result}    ThingToken
	Disconnect From Mongodb
	[Return]    ${thingToken}


RegisterAsgardApp
    [Arguments]    ${URL}
	#Open simulator
    Add Image Path    ${CURDIR}${IMAGE_PATH_ASGARD_COAPAPP}
	Log To Console    ${CURDIR}${IMAGE_PATH_ASGARD_COAPAPP}
    ${status_open_program}=    Run Keyword And Return Status    Wait Until Screen Contain    ${ASGARD_COAPAP_IMAGE_MAGELLANCLIENT_HEADER}     5
	Run Keyword If    '${status_open_program}'=='True'    Log To Console    Program is running
	Run Keyword If    '${status_open_program}'=='False'    Open Simulator

	#Select Dropdrown Function 
	Log To Console    Do : ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_REPORT}
    ${status_dropdown}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_REPORT}     5
    ${status_dropdownConfig}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_CONFIG}     5
    ${status_dropdownDelta}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_DELTA}     5
	${value_before_selectd}=    Set Variable If    '${status_dropdownConfig}'=='True' and '${status_dropdownDelta}'=='False'    ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_CONFIG} 
	...    '${status_dropdownConfig}'=='False' and '${status_dropdownDelta}'=='True'    ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_DELTA}

	${value_selectd}=    Set Variable If    '${status_dropdownConfig}'=='True' and '${status_dropdownDelta}'=='False'    ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_REPORT2} 
	...    '${status_dropdownConfig}'=='False' and '${status_dropdownDelta}'=='True'    ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_REPORT1}

	Run Keyword If    '${status_dropdown}'=='False'   Select Dropdrown Function1    ${value_before_selectd}    ${value_selectd}
	Run Keyword If    '${status_dropdown}'=='True'    Log To Console    Select Dropdrown Function ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_REPORT} is open


	#Input Url
    ${status_url}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAP_IMAGE_TXT_URL}     5
    ${status_url1}=    Run Keyword And Return Status    Wait Until Screen Contain     txt_url2.png     5
	Run Keyword If    '${status_url}'=='True'    Input Url    ${ASGARD_COAPAP_IMAGE_TXT_URL}    ${URL}    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}
	Run Keyword If    '${status_url}'=='False'    Input Url    txt_url2.png    ${URL}    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}

	#Payload
    ${status_playload_null}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NULL}     5	
    ${status_playload_notnull}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NOT_NULL}     5	
	${playload_notnull}=    Set Variable If    '${status_playload_notnull}'=='True'    ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NOT_NULL} 
	...    '${status_playload_notnull}'=='False'    ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NOT_NULL1}

    Log To Console    Do : ${playload_notnull}
    ${status_playload}=    Run Keyword And Return Status    Wait Until Screen Contain     ${playload_notnull}     5
	Run Keyword If    '${status_playload}'=='True' or '${status_playload_null}'=='False'    Clear Input    ${playload_notnull}


	#Click Send button
	Log To Console    Do : ${ASGARD_COAPAP_IMAGE_BTN_SEND}
	Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Click    ${ASGARD_COAPAP_IMAGE_BTN_SEND}
	#Check Success popup
	Log To Console    Do : ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}
	Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Check Matched    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}	
	${result}=    Run Keyword And Return Status    Click    ${ASGARD_COAPAP_IMAGE_BTN_OK}
	Capture Screen		
	[Return]    ${result}

####################################################
#                 Report
####################################################
ReportAsgardApp
    [Arguments]    ${URL}    ${valueKey}    ${Result_Simulator}

	#Input Url
    ${status_url}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAP_IMAGE_TXT_URL_REGISTER}     5
    ${status_url1}=    Run Keyword And Return Status    Wait Until Screen Contain     txt_url2.png     5
	#${url_img}=    Set Variable If    '${status_url1}'=='True'    txt_url3.png
	#...    txt_url3.png
	#Log To Console    status_url = ${status_url}
	#Log To Console    status_url1 = ${status_url1}
	Run Keyword If    '${status_url}'=='True'    Input Url    ${ASGARD_COAPAP_IMAGE_TXT_URL_REGISTER}    ${URL}    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}

    ${status_url2}=    Run Keyword And Return Status    Wait Until Screen Contain     txt_url2.png     5	
	${url_2}=    Set Variable If    '${status_url2}'=='True'     txt_url2.png 
	...    '${status_url2}'=='False'    txt_url3.png

	Run Keyword If    '${status_url}'=='False'    Input Url    ${url_2}    ${URL}    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}

	#Payload
    ${status_playload_null}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NULL}     5	
    ${status_playload_notnull}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NOT_NULL}     5	
	${playload_notnull}=    Set Variable If    '${status_playload_notnull}'=='True' and '${status_playload_null}'=='False'     ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NOT_NULL} 
	...    '${status_playload_notnull}'=='False' and '${status_playload_null}'=='False'    ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NOT_NULL1}
	...    '${status_playload_null}'=='True'    ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NULL}

    Log To Console    Do : ${playload_notnull}
    ${status_playload}=    Run Keyword And Return Status    Wait Until Screen Contain     ${playload_notnull}     5
	Run Keyword If    '${status_playload}'=='True' and '${status_playload_null}'=='False'    Clear Input    ${playload_notnull}
	Run Keyword If    '${status_playload}'=='True' and '${status_playload_null}'=='False'    Input Payload Textarea Null     ${valueKey}
	Run Keyword If    '${status_playload_null}'=='True'    Input Payload Textarea Null     ${valueKey}	

	#Click Send button
	Log To Console    Do : ${ASGARD_COAPAP_IMAGE_BTN_SEND}
	Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Click    ${ASGARD_COAPAP_IMAGE_BTN_SEND}

	#Check Success popup
	Log To Console    Do : ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}
	Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Check Matched    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}	
	Log To Console    Do : ${ASGARD_COAPAP_IMAGE_BTN_OK}
	Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Click    ${ASGARD_COAPAP_IMAGE_BTN_OK}

	#check Response 20000
	${result}=    Run Keyword And Return Status    Check Matched Result    ${Result_Simulator}
	Capture Screen	
	[Return]    ${result}

####################################################
#                 Config
####################################################
ConfigAsgardApp
    [Arguments]    ${URL}    ${Result_Simulator}

	#Select Dropdrown Function 
	Log To Console    Do : ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_CONFIG}
    ${status_dropdown}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_CONFIG}     5
	Run Keyword If    '${status_dropdown}'=='False'   Select Dropdrown Function    ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CONFIG}
	Run Keyword If    '${status_dropdown}'=='True'    Log To Console    Select Dropdrown Function ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_CONFIG} is open

	#because find input url not found so click header 
	#Click    MagellanClient_header.png

	#Input Url
    ${status_url}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAP_IMAGE_TXT_URL_CONFIG}     5
    ${status_url1}=    Run Keyword And Return Status    Wait Until Screen Contain     txt_url2.png     5
	Run Keyword If    '${status_url}'=='True'    Input Url    ${ASGARD_COAPAP_IMAGE_TXT_URL_CONFIG}    ${URL}    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}
	Run Keyword If    '${status_url}'=='False'    Input Url    txt_url2.png    ${URL}    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}

	#Click Send button
	Log To Console    Do : ${ASGARD_COAPAP_IMAGE_BTN_SEND}
	Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Click    ${ASGARD_COAPAP_IMAGE_BTN_SEND}

	#Check Success popup
	Log To Console    Do : ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}
	Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Check Matched    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}	
	Log To Console    Do : ${ASGARD_COAPAP_IMAGE_BTN_OK}
	Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Click    ${ASGARD_COAPAP_IMAGE_BTN_OK}

	#check Response 20000
	${result}=    Run Keyword And Return Status    Check Matched Result    ${Result_Simulator}
	Capture Screen	
	[Return]    ${result}

####################################################
#                 Delta
####################################################
DeltaAsgardApp
    [Arguments]    ${URL}    ${Result_Simulator}

	#Select Dropdrown Function 
	Log To Console    Do : ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_DELTA}
    ${status_dropdown}=    Run Keyword And Return Status    Click     ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_DELTA}     5
	Run Keyword If    '${status_dropdown}'=='False'   Select Dropdrown Function    ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_DELTA}
	Run Keyword If    '${status_dropdown}'=='True'    Log To Console    Select Dropdrown Function ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_CHOOSE_DELTA} is open

	#Input Url
    ${status_url}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAP_IMAGE_TXT_URL_DELTA}     5
    ${status_url1}=    Run Keyword And Return Status    Wait Until Screen Contain     txt_url2.png     5
	Run Keyword If    '${status_url}'=='True'    Input Url    ${ASGARD_COAPAP_IMAGE_TXT_URL_DELTA}    ${URL}    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}
	Run Keyword If    '${status_url}'=='False'    Input Url    txt_url2.png    ${URL}    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}


	#Click Send button
	Log To Console    Do : ${ASGARD_COAPAP_IMAGE_BTN_SEND}
	Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Click    ${ASGARD_COAPAP_IMAGE_BTN_SEND}

	#Check Success popup
	Log To Console    Do : ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}
	Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Check Matched    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}	
	Log To Console    Do : ${ASGARD_COAPAP_IMAGE_BTN_OK}
	Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Click    ${ASGARD_COAPAP_IMAGE_BTN_OK}
	
	#check Response 20000
	#${result}=    Run Keyword And Return Status    Check Matched Result    ${Result_Simulator}

	Capture Screen	
	#[Return]    ${result}

####################################################
#                 Verify Log
####################################################
Log CoapApp Register
	[Arguments]    ${code_detail}    ${desc_detail}    ${code_summary}    ${desc_summary}    ${getData}    ${IMSI}
	#/register/sim/v1/IMSI/IPAddress
	${pathUrl}=    Replace Parameters Path    ${ASGARD_COAPAPP_URL_REGISTER}    ${ASGARD_COAPAPP_FIELD_IMSI}    ${IMSI}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	${payload}=    Set Variable    null
	
	#resultCode_summary[20000],resultDesc_summary[OK],Code_detail[20000],Description_detail[The requested operation was successfully.],applicationName[Asgard.Coap.APP],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Register],imsi,ipAddress,payload[null],namespace[Magellan],containerId[coapapp-vXX ],identity[null],cmdName[Register],endPointName[CoapApiService],logLevel[INFO],custom,SensorKey
    Check Log Response    ${code_detail}    ${desc_detail}    ${code_summary}    ${desc_summary}    ${VALUE_APPLICATIONNAME_COAPAPP}    ${pathUrl}    ${ASGARD_COAPAPP_URL_COAPAPISERVICE_REGISTER}    ${IMSI}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${payload}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPP}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}    ${DETAIL_ENDPOINTNAME_COAPAPISERVICE}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${getData}[7]    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY} 
    ${thingToken}    Set Variable If    ${code_detail}==20000    ${thingToken}
	Log To Console    logthingToken${thingToken}
    [Return]    ${thingToken}

Log CoapApp Report
	[Arguments]    ${code_detail}    ${desc_detail}    ${code_summary}    ${desc_summary}    ${Type}    ${getData}    ${thingToken}    ${payload}
	#/report/sim/v1/Token/IPAddress
	${pathUrl_Type1}=    Replace Parameters Path    ${ASGARD_COAPAPP_URL_REPORT}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	${temp}=    Set Variable   ${VALUE_SENSORKEY}   
	${pathUrl_Type2}=    Set Variable    ${pathUrl_Type1}?${temp}
	#resultCode_summary[20000],resultDesc_summary[OK],Code_detail[20000],Description_detail[The requested operation was successfully.],applicationName[CoapAPP],pathUrl[/report/sim/v1/Token/IPAddress],urlCmdName[api/v1/Report],thingToken,ipAddress,payload[null],namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[Report],endPointName[CoapApiService],logLevel[INFO],custom,SensorKey	
	Run Keyword If	${Type} == 1    Check Log Response    ${code_detail}    ${desc_detail}    ${code_summary}    ${desc_summary}    ${VALUE_APPLICATIONNAME_COAPAPP}    ${pathUrl_Type1}    ${ASGARD_COAPAPP_URL_COAPAPISERVICE_REPORT}    ${thingToken}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${payload}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPP}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_REPORT}    ${DETAIL_ENDPOINTNAME_COAPAPISERVICE}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${VALUE_SENSORKEY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}           
	Run Keyword If	${Type} == 2    Check Log Response    ${code_detail}    ${desc_detail}    ${code_summary}    ${desc_summary}    ${VALUE_APPLICATIONNAME_COAPAPP}    ${pathUrl_Type2}    ${ASGARD_COAPAPP_URL_COAPAPISERVICE_REPORT}    ${thingToken}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${payload}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPP}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_REPORT}    ${DETAIL_ENDPOINTNAME_COAPAPISERVICE}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${VALUE_SENSORKEY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}           

Log CoapApp Config
	[Arguments]    ${code_detail}    ${desc_detail}    ${code_summary}    ${desc_summary}    ${Type}    ${getData}    ${thingToken} 
    #Log To Console    thingToken${thingToken}
	#/config/sim/v1/token/IP
	${pathUrl_Type1}=    Replace Parameters Path    ${ASGARD_COAPAPP_URL_CONFIG}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}

	${pathUrl_Type2}=    Set Variable    ${pathUrl_Type1}?${VALUE_ConfigInfo_KEY_MAX}
	${payload}=    Set Variable    null	
	#api/v1/Config?ThingToken=d1b348dc-455b-4578-9d88-ef8f21a3467d&IpAddress=1.2.3.4
	${urlCmdName_type1}=    Set Variable    ${ASGARD_COAPAPP_URL_COAPAPISERVICE_CONFIG}?ThingToken=${thingToken}&IpAddress=${ASGARD_COAPAPP_IP_ADDRESS}
	${urlCmdName_type2}=    Set Variable    ${ASGARD_COAPAPP_URL_COAPAPISERVICE_CONFIG}?ThingToken=${thingToken}&IpAddress=${ASGARD_COAPAPP_IP_ADDRESS}&Sensor=${VALUE_ConfigInfo_KEY_MAX}

	#resultCode_summary[20000],resultDesc_summary[OK],Code_detail[20000],Description_detail[The requested operation was successfully.],applicationName[Asgard.Coap.APP],pathUrl[/config/sim/v1/token/IP],urlCmdName[api/v1/Config],thingToken,ipAddress,payload[null],namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[Config],endPointName[CoapApiService],logLevel[INFO],custom,SensorKey
	Run Keyword If	${Type} == 1    Check Log Response    ${code_detail}    ${desc_detail}    ${code_summary}    ${desc_summary}    ${VALUE_APPLICATIONNAME_COAPAPP}    ${pathUrl_Type1}    ${urlCmdName_type1}    ${thingToken}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${payload}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPP}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}    ${DETAIL_ENDPOINTNAME_COAPAPISERVICE}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${getData}[7]    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
	Run Keyword If	${Type} == 2    Check Log Response    ${code_detail}    ${desc_detail}    ${code_summary}    ${desc_summary}    ${VALUE_APPLICATIONNAME_COAPAPP}    ${pathUrl_Type2}    ${urlCmdName_type2}    ${thingToken}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${payload}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPP}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}    ${DETAIL_ENDPOINTNAME_COAPAPISERVICE}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${getData}[7]    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}

Log CoapApp Delta
	[Arguments]    ${code_detail}    ${desc_detail}    ${code_summary}    ${desc_summary}    ${Type}    ${getData}    ${thingToken}    ${valueKey}        
    #Log To Console    thingToken${thingToken}
	#/config/sim/v1/token/IP
	${pathUrl_Type1}=    Replace Parameters Path    ${ASGARD_COAPAPP_URL_DELTA}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	${pathUrl_Type2}=    Set Variable    ${pathUrl_Type1}?${VALUE_SENSORKEY}
	${payload}=    Set Variable    ${valueKey}

	#api/v1/Delta?ThingToken=07b8df19-c85c-4381-9eae-3563aa6724ed&IpAddress=1.2.3.4
	${urlCmdName_type1}=    Set Variable    ${ASGARD_COAPAPP_URL_COAPAPISERVICE_DELTA}?ThingToken=${thingToken}&IpAddress=${ASGARD_COAPAPP_IP_ADDRESS}
	${urlCmdName_type2}=    Set Variable    ${ASGARD_COAPAPP_URL_COAPAPISERVICE_DELTA}?ThingToken=${thingToken}&IpAddress=${ASGARD_COAPAPP_IP_ADDRESS}&Sensor=${VALUE_SENSORKEY}

	#resultCode_summary[20000],resultDesc_summary[OK],Code_detail[20000],Description_detail[The requested operation was successfully.],applicationName[CoapAPP],pathUrl[/delta/sim/v1/Token/IPAddress],urlCmdName[api/v1/Delta],thingToken,ipAddress,payload[null],namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[Delta],endPointName[CoapApiService],logLevel[INFO],custom,SensorKey
	Run Keyword If	${Type} == 1    Check Log Response    ${code_detail}    ${desc_detail}    ${code_summary}    ${desc_summary}    ${VALUE_APPLICATIONNAME_COAPAPP}    ${pathUrl_Type1}    ${urlCmdName_type1}    ${thingToken}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${payload}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPP}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_DELTA}    ${DETAIL_ENDPOINTNAME_COAPAPISERVICE}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${getData}[7]    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY} 
	#resultCode_summary[20000],resultDesc_summary[OK],Code_detail[20000],Description_detail[The requested operation was successfully.],applicationName[CoapAPP],pathUrl[/delta/sim/v1/Token/IPAddress],urlCmdName[api/v1/Delta],thingToken,ipAddress,payload[null],namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[Delta],endPointName[CoapApiService],logLevel[INFO],custom,SensorKey
	Run Keyword If	${Type} == 2    Check Log Response    ${code_detail}    ${desc_detail}    ${code_summary}    ${desc_summary}    ${VALUE_APPLICATIONNAME_COAPAPP}    ${pathUrl_Type2}    ${urlCmdName_type2}    ${thingToken}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${payload}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPP}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_DELTA}    ${DETAIL_ENDPOINTNAME_COAPAPISERVICE}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${getData}[7]    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}


Log COAP Charging
	[Arguments]    ${Code}    ${Description}    ${orderRef}    ${IMSI_OR_THINGTOKEN}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}    ${ThingID}    ${APP} 
	Log To Console    ${\n}============== Start Check Log ==============${\n}
	${URL_AsgardHTTPReport_ChangeFormat}=    Set Variable    internalreport.pub.v1.${IMSI_OR_THINGTOKEN}  
    ${URL_Charging}=    Set Variable    /api/v1/Charging/${ThingID}
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[Register is Success],applicationName[Asgard.Mqtt.V1.APP],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Sim/Register],imsi,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity,cmdName[register],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
    ${session}=    Check Log Response Charging    ${Code}    ${Description}    ${VALUE_APPLICATIONNAME_CHARGING}    ${URL_Charging}    ${URL_AsgardHTTPReport_ChangeFormat}    ${IMSI_OR_THINGTOKEN}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPP}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_POSTCHARGING}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${custom}    ${VALUE_SENSORKEY}    ${REQUESTOBJECT_DETAIL_LOG_DB_INQUIRY}    ${RESPONSEOBJECT_DETAIL_LOG_DB_SUCCESS}    POST    ${orderRef}    ${endPointName_detail_list}    ${APP}  
    [Return]    ${session}