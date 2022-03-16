*** Keywords ***
####################################################
#                 Verify Log
####################################################
Log HTTP Register
	[Arguments]    ${Code}    ${Description}    ${orderRef}    ${IMSI_OR_THINGTOKEN}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}     	
	Log To Console    ${\n}============== Start Check Log ==============${\n}	
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[Register is Success],applicationName[Asgard.Mqtt.V1.APP],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Sim/Register],imsi,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity,cmdName[register],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
    Check Log Response New     ${Code}    ${Description}    ${VALUE_APPLICATIONNAME_HTTP}    ${URL_AsgardHTTPRegister}    ${URL_AsgardHTTPRegister}    ${IMSI_OR_THINGTOKEN}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_HTTP}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_HTTP}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${custom}    ${VALUE_SENSORKEY}    ${REQUESTOBJECT_DETAIL_LOG_DB_INQUIRY}    ${RESPONSEOBJECT_DETAIL_LOG_DB_SUCCESS}    POST    ${orderRef}    ${endPointName_detail_list}  


Log HTTP Report
	[Arguments]    ${Code}    ${Description}    ${orderRef}    ${IMSI_OR_THINGTOKEN}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body} 
	Log To Console    ${\n}============== Start Check Log ==============${\n}
	${URL_AsgardHTTPReport_ChangeFormat}=    Set Variable    internalreport.pub.v1.${IMSI_OR_THINGTOKEN}  

	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[Register is Success],applicationName[Asgard.Mqtt.V1.APP],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Sim/Register],imsi,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity,cmdName[register],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
    Check Log Response New     ${Code}    ${Description}    ${VALUE_APPLICATIONNAME_HTTP}    ${URL_AsgardHTTPReport}    ${URL_AsgardHTTPReport_ChangeFormat}    ${IMSI_OR_THINGTOKEN}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_HTTP}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_REPORT_HTTP}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${custom}    ${VALUE_SENSORKEY}    ${REQUESTOBJECT_DETAIL_LOG_DB_INQUIRY}    ${RESPONSEOBJECT_DETAIL_LOG_DB_SUCCESS}    POST    ${orderRef}    ${endPointName_detail_list}  

Log HTTP Config
	[Arguments]    ${Code}    ${Description}    ${orderRef}    ${ThingToken}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body} 	
	Log To Console    ${\n}============== Start Check Log ==============${\n}
	${URL_AsgardHTTPConfig_ChangeFormat}=    Set Variable    internalreport.pub.v1.${ThingToken}  
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[Register is Success],applicationName[Asgard.Mqtt.V1.APP],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Sim/Register],imsi,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity,cmdName[register],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
    Check Log Response New     ${Code}    ${Description}    ${VALUE_APPLICATIONNAME_HTTP}    ${URL_AsgardHTTPConfig}    ${URL_AsgardHTTPConfig_ChangeFormat}    ${EMPTY}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_HTTP}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_HTTP}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${custom}    ${VALUE_SENSORKEY}    ${REQUESTOBJECT_DETAIL_LOG_DB_INQUIRY}    ${RESPONSEOBJECT_DETAIL_LOG_DB_SUCCESS}    GET    ${orderRef}    ${endPointName_detail_list}  

Log HTTP Delta
	[Arguments]    ${Code}    ${Description}    ${orderRef}    ${ThingToken}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body} 	
	Log To Console    ${\n}============== Start Check Log ==============${\n}
	${URL_AsgardHTTPDelta_ChangeFormat}=    Set Variable    internalreport.pub.v1.${ThingToken}  
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[Register is Success],applicationName[Asgard.Mqtt.V1.APP],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Sim/Register],imsi,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity,cmdName[register],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
    Check Log Response New     ${Code}    ${Description}    ${VALUE_APPLICATIONNAME_HTTP}    ${URL_AsgardHTTPDelta}    ${URL_AsgardHTTPDelta_ChangeFormat}    ${EMPTY}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_HTTP}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_DELTA_HTTP}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${custom}    ${VALUE_SENSORKEY}    ${REQUESTOBJECT_DETAIL_LOG_DB_INQUIRY}    ${RESPONSEOBJECT_DETAIL_LOG_DB_SUCCESS}    GET    ${orderRef}    ${endPointName_detail_list}  


Log HTTP Charging
	[Arguments]    ${Code}    ${Description}    ${orderRef}    ${IMSI_OR_THINGTOKEN}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}    ${ThingID} 
	Log To Console    ${\n}============== Start Check Log ==============${\n}
	${URL_AsgardHTTPReport_ChangeFormat}=    Set Variable    internalreport.pub.v1.${IMSI_OR_THINGTOKEN}  
    ${URL_Charging}=    Set Variable    /api/v1/Charging/${ThingID}
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[Register is Success],applicationName[Asgard.Mqtt.V1.APP],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Sim/Register],imsi,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity,cmdName[register],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
    ${session}=    Check Log Response Charging    ${Code}    ${Description}    ${VALUE_APPLICATIONNAME_CHARGING}    ${URL_Charging}    ${URL_AsgardHTTPReport_ChangeFormat}    ${IMSI_OR_THINGTOKEN}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_HTTP}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_POSTCHARGING}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${custom}    ${VALUE_SENSORKEY}    ${REQUESTOBJECT_DETAIL_LOG_DB_INQUIRY}    ${RESPONSEOBJECT_DETAIL_LOG_DB_SUCCESS}    POST    ${orderRef}    ${endPointName_detail_list}  
    [Return]    ${session}