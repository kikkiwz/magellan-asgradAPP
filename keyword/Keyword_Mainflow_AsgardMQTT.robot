*** Keywords ***
####################################################
#                 Simulator
####################################################
MQTTConnect
    [Arguments]    ${IMSI}
    #Subscribe and get messages
	${Username}=    Set Variable    Sim.${IMSI}
	LOG    Username : Sim.${IMSI}
	LOG    Pass : ${Pass}
    Set Username And Password    ${Username}    ${Pass}
	${result}=    Run Keyword And Return Status    connect   ${ASGARD_MQTT_VALUE_SERVERURL}    client_id=${ASGARD_MQTT_VALUE_CLIENTID}    clean_session=True
	[Return]    ${result}

MQTTDisconnect
    disconnect

MQTTRegister
    [Arguments]    ${IMSI}
    MQTTConnect    ${IMSI}
    Subscribe   topic=register/get/sim/v1/${IMSI}    qos=1   timeout=5   limit=1   
    publish  topic=register/update/sim/v1/${IMSI}/${IPAddress}
    ${messages}=    Subscribe   topic=register/get/sim/v1/${IMSI}    qos=1   timeout=5   limit=1
    ${ThingToken_MQTT}=    Get From List    ${messages}    0
    MQTTDisconnect
	Log To Console    ${\n}============ Send MQTT Register =====================
	Log To Console    ${\n}Subscribe : topic=register/get/sim/v1/${IMSI}
	Log To Console    Publish : topic=register/update/sim/v1/${IMSI}/${IPAddress}
	Log To Console    Response:${messages}${\n}
	[Return]    ${ThingToken_MQTT}

MQTTReport
    [Arguments]    ${IMSI}    ${valueKey}
    MQTTConnect    ${IMSI}
	#Register
    Subscribe   topic=register/get/sim/v1/${IMSI}    qos=1   timeout=5   limit=1   
    publish  topic=register/update/sim/v1/${IMSI}/${IpAddress} 
    ${messages_register}=    Subscribe   topic=register/get/sim/v1/${IMSI}    qos=1   timeout=5   limit=1
    ${ThingToken_MQTT}=    Get From List    ${messages_register}    0
    #Report  
    ${messages_report}=    publish  topic=report/update/sim/v1/${ThingToken_MQTT}/${IpAddress}   message=${valueKey}
    MQTTDisconnect
	Log To Console    ${\n}============ Send MQTT Register =====================
	Log To Console    ${\n}Subscribe : topic=register/get/sim/v1/${IMSI}
	Log To Console    Publish : topic=register/update/sim/v1/${IMSI}/${IPAddress}
	Log To Console    Response:${messages_report}${\n}
	Log To Console    ${\n}============ Send MQTT Report =====================
	Log To Console    Publish : topic=report/update/sim/v1/${ThingToken_MQTT}/${IpAddress} 
	Log To Console    message=${valueKey}
	[Return]    ${ThingToken_MQTT}  

MQTTConfig
    [Arguments]    ${IMSI}    ${SensorName}    ${Type}
    MQTTConnect    ${IMSI}
	#Register
    Subscribe   topic=register/get/sim/v1/${IMSI}    qos=1   timeout=5   limit=1   
    publish  topic=register/update/sim/v1/${IMSI}/${IpAddress} 
    ${messages}=    Subscribe   topic=register/get/sim/v1/${IMSI}    qos=1   timeout=5   limit=1
    ${ThingToken_MQTT}=    Get From List    ${messages}    0
	Log To Console    ${\n}============ Send MQTT Register =====================
	Log To Console    ${\n}Subscribe : topic=register/get/sim/v1/${IMSI}
	Log To Console    Publish : topic=register/update/sim/v1/${IMSI}/${IPAddress}
	Log To Console    Response:${messages}${\n}
	Log To Console    ${\n}============ Send MQTT Config =====================
    #Config  
	${publish_type1}=    Set Variable    config/update/sim/v1/${ThingToken_MQTT}/${IpAddress}
	${publish_type2}=    Set Variable    config/update/sim/v1/${ThingToken_MQTT}/${IpAddress}/${SensorName}	
    Subscribe   topic=config/get/sim/v1/${ThingToken_MQTT}/${SensorName}    qos=1   timeout=5   limit=1 
    #publish
	Run Keyword If    ${Type}==1    Run Keyword    publish    topic=${publish_type1}
	Run Keyword If    ${Type}==1    Run Keyword    Log To Console    Publish : topic=${publish_type1}
    Run Keyword If    ${Type}==2    Run Keyword    publish    topic=${publish_type2}	
	Run Keyword If    ${Type}==2    Run Keyword    Log To Console    Publish : topic=${publish_type2}
    ${messages_config}=    Subscribe   topic=config/get/sim/v1/${ThingToken_MQTT}/${SensorName}     qos=1   timeout=5   limit=1
    ${SensorValue}=    Run Keyword And Ignore Error    Get From List    ${messages_config}    0
    MQTTDisconnect
	Log To Console    Subscribe : topic=config/get/sim/v1/${ThingToken_MQTT}/${SensorName}
	Log To Console    Response : ${SensorValue}
	[Return]    ${ThingToken_MQTT}    ${SensorValue}  

MQTTDelta
    [Arguments]    ${IMSI}    ${SensorName}    ${Type}
    MQTTConnect    ${IMSI}
	#Register
    Subscribe   topic=register/get/sim/v1/${IMSI}    qos=1   timeout=5   limit=1   
    publish  topic=register/update/sim/v1/${IMSI}/${IpAddress} 
    ${messages}=    Subscribe   topic=register/get/sim/v1/${IMSI}    qos=1   timeout=5   limit=1
    ${ThingToken_MQTT}=    Get From List    ${messages}    0
    #Delta  
	Subscribe   topic=delta/get/${ThingToken_MQTT}/${SensorName}     qos=1   timeout=5   limit=1
	publish    topic=report/update/sim/v1/${ThingToken_MQTT}/${IpAddress}/${SensorName} 
    ${result}=    Subscribe   topic=delta/get/${ThingToken_MQTT}/${SensorName}     qos=1   timeout=5   limit=1
    Log    ${result} 
    MQTTDisconnect
	Log To Console    ${\n}============ Send MQTT Register =====================
	Log To Console    ${\n}Subscribe : topic=register/get/sim/v1/${IMSI}
	Log To Console    Publish : topic=register/update/sim/v1/${IMSI}/${IPAddress}
	Log To Console    Response:${messages}${\n}
	Log To Console    ${\n}============ Send MQTT Report =====================
	Log To Console    Publish : topic=report/update/sim/v1/${ThingToken_MQTT}/${IpAddress}/${SensorName} 
	Log To Console    Subscribe : topic=delta/get/${ThingToken_MQTT}/${SensorName} 
	Log To Console    message=${result}
	[Return]    ${ThingToken_MQTT}


MQTTCharging
    [Arguments]    ${IMSI}    ${valueKey}
    MQTTConnect    ${IMSI}
	#Register
    Subscribe   topic=register/get/sim/v1/${IMSI}    qos=1   timeout=5   limit=1   
    publish  topic=register/update/sim/v1/${IMSI}/${IpAddress} 
    ${messages}=    Subscribe   topic=register/get/sim/v1/${IMSI}    qos=1   timeout=5   limit=1
    ${ThingToken_MQTT}=    Get From List    ${messages}    0
    #Report  
    ${messages_report}=    publish  topic=report/update/sim/v1/${ThingToken_MQTT}/${IpAddress}   message=${valueKey}
    MQTTDisconnect
	Log To Console    ${\n}============ Send MQTT Register =====================
	Log To Console    ${\n}Subscribe : topic=register/get/sim/v1/${IMSI}
	Log To Console    Publish : topic=register/update/sim/v1/${IMSI}/${IPAddress}
	Log To Console    Response:${messages}${\n}
	Log To Console    ${\n}============ Send MQTT Report =====================
	Log To Console    Publish : topic=report/update/sim/v1/${ThingToken_MQTT}/${IpAddress} 
	Log To Console    Response:${messages_report}${\n}
	[Return]    ${ThingToken_MQTT}  


####################################################
#                 Verify Log
####################################################
Log MQTT Register
	[Arguments]    ${ThingID}    ${IMSI}    ${IMEI}
	Log To Console    ${\n}============== Start Check Log ==============${\n}
    #Log To Console    IMSI${IMSI}
	#register/update/sim/v1/IMSI/IPAddress
	${pathUrlReplace}=    Replace Parameters Path    ${ASGARD_MQTT_URL_REGISTER_TOPIC_PUBLISH}    ${ASGARD_MQTT_FIELD_IMSI}    ${IMSI}    ${ASGARD_MQTT_FIELD_IPADDRESS}    ${IPAddress}
	${pathUrl}=    Replace String    ${pathUrlReplace}    /    . 
	#Log To Console    pathUrl${pathUrl}
	#register/get/sim/v1/IMSI
	${urlCmdNameReplace}=    Replace String    ${ASGARD_MQTT_URL_REGISTER_TOPIC_SUBSCRIPTION}    ${ASGARD_MQTT_FIELD_IMSI}    ${IMSI}
	${urlCmdName}=    Replace String    ${urlCmdNameReplace}    /    .
	
	${identity}=    Set Variable    {"ThingID":"${ThingID}","Imei":"${IMEI}","Imsi":"${IMSI}"}		 
	# ${custom}=    Set Variable    {"customData":{"Imsi": ["${IMSI}"], "Imei": ["${IMEI}"], "ThingID": ["${ThingID}"]},"endPointSummary":[{"no":"1","endPointName":"db.ThingsCollection","endPointURL":null,"responseStatus":"20000:Inquiry was Success","processTime":null},{"no":"2","endPointName":"db.ThingsCollection","endPointURL":null,"responseStatus":"20000:Update was Success","processTime":null}]}    	 
	${custom}=    Set Variable    {"customData":{"Imsi": ["${IMSI}"], "Imei": ["${IMEI}"], "ThingID": ["${ThingID}"]}}    	 	 
	${body}=    Set Variable    ""
	
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[Register is Success],applicationName[Asgard.Mqtt.V1.APP],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Sim/Register],imsi,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity,cmdName[register],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
    MQTT Check Log Response    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${CODE_20000}    ${VALUE_DESCRIPTION_REGISTER_SUCCESS}    ${VALUE_APPLICATIONNAME_MQTT}    ${pathUrl}    ${urlCmdName}    ${IMSI}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_MQTT}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_SEARCH_REGISTER_MQTT}    ${custom}    ${VALUE_SENSORKEY} 


Log MQTT Report
	[Arguments]    ${sensorKey}    ${thingToken}    ${valueKey}
	Log To Console    ${\n}============== Start Check Log ==============${\n}
    #Log To Console    IMSI${IMSI}
	#report/update/sim/v1/ThingToken/IPAddress
	${pathUrlReplace}=    Replace Parameters Path    ${ASGARD_MQTT_URL_REPORT_TOPIC_PUBLISH}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}    ${ASGARD_MQTT_FIELD_IPADDRESS}    ${IPAddress}
	${pathUrl}=    Replace String    ${pathUrlReplace}    /    .

	#internalreport/pub/v1/ThingToken    
	#internalreport.pub.v1.e34b0974-ef45-4f82-bab8-82382a84a427
	${urlCmdNameReplace}=    Replace String    ${ASGARD_MQTT_URL_REPORT_TOPIC_SUBSCRIPTION_LOG}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}
	${urlCmdName}=    Replace String    ${urlCmdNameReplace}    /    .

    ${body}=    Set Variable    ${valueKey}
	
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[Register is Success],applicationName[Asgard.Mqtt.V1.APP],pathUrl[report/update/sim/v1/ThingToken/IPAddress],urlCmdName[internalreport/pub/v1/ThingToken],ThingToken,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[report],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
    MQTT Check Log Response    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${CODE_20000}    ${VALUE_DESCRIPTION_REGISTER_SUCCESS}    ${VALUE_APPLICATIONNAME_MQTT}    ${pathUrl}    ${urlCmdName}    ${thingToken}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_MQTT}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_REPORT_MQTT}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_SEARCH_REPORT_MQTT}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${sensorKey} 
    #Log To Console    logthingToken${thingToken}
    
Log MQTT Config
	[Arguments]    ${ThingID}    ${thingToken}    ${IMSI}    ${IMEI}    ${Filter_SensorKey}    ${Type}
	Log To Console    ${\n}============== Start Check Log ==============${\n}
    #Log To Console    IMSI${IMSI}
	#config/update/sim/v1/ThingToken/IPAddress
	${pathUrlReplace}=    Replace Parameters Path    ${ASGARD_MQTT_URL_CONFIG_TOPIC_PUBLISH}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}    ${ASGARD_MQTT_FIELD_IPADDRESS}    ${IPAddress}
    ${pathUrl_Type1}=    Replace String    ${pathUrlReplace}    /    .
	${pathUrl_Type2}=    Set Variable    ${pathUrl_Type1}.${Filter_SensorKey}    

	#config/get/sim/v1/ThingToken/SensorName
	${urlCmdNameReplaceThingToken}=    Replace String    ${ASGARD_MQTT_URL_CONFIG_TOPIC_SUBSCRIPTION}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}
	${urlCmdName}=    Replace String    ${urlCmdNameReplaceThingToken}    /    .
	
	${identity}=    Set Variable    {"ThingID":"${ThingID}","Imei":"${IMEI}","Imsi":"${IMSI}"}		
	${custom}=    Evaluate    {'Imsi': ['${IMSI}'], 'Imei': ['${IMSI}'], 'ThingID': ['${ThingID}']}
	${body}=    Evaluate    {"${VALUE_CONFIGINFO_KEY_REFRESHTIME}":"${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}","${VALUE_CONFIGINFO_KEY_MAX}":"${VALUE_CONFIGINFO_KEY_MAX_VALUE}"}	

	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[Register is Success],applicationName[Asgard.Mqtt.V1.APP],pathUrl[config/update/sim/v1/ThingToken/IPAddress],urlCmdName[config/get/sim/v1/ThingToken/SensorName],ThingToken,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[register],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
	Run Keyword If	${Type} == 1    MQTT Check Log Response    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${CODE_20000}    ${VALUE_DESCRIPTION_REGISTER_SUCCESS}    ${VALUE_APPLICATIONNAME_MQTT}    ${pathUrl_Type1}    ${urlCmdName}    ${ThingToken}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_MQTT}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_SEARCH_CONFIG_MQTT}    ${custom}    ${VALUE_SENSORKEY}                
	Run Keyword If	${Type} == 2    MQTT Check Log Response    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${CODE_20000}    ${VALUE_DESCRIPTION_REGISTER_SUCCESS}    ${VALUE_APPLICATIONNAME_MQTT}    ${pathUrl_Type2}    ${urlCmdName}    ${ThingToken}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_MQTT}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_SEARCH_CONFIG_MQTT}    ${custom}    ${VALUE_SENSORKEY}                


Log MQTT Config Error
	[Arguments]    ${Type}    ${ResultCode}    ${ResultDesc}    ${Code}    ${Desc}    ${SensorKey_Real}    ${thingToken}    ${SensorKey_Invalid}    ${identity}    ${custom}    ${body}
    Log To Console    ${\n}============== Start Check Log ==============${\n}
	#Log To Console    IMSI${IMSI}
	#config/update/sim/v1/ThingToken/IPAddress
	${pathUrlReplace}=    Replace Parameters Path    ${ASGARD_MQTT_URL_CONFIG_TOPIC_PUBLISH}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}    ${ASGARD_MQTT_FIELD_IPADDRESS}    ${IPAddress}
	${pathUrl}=    Replace String    ${pathUrlReplace}${SensorKey_Invalid}    /    .

	#config/get/sim/v1/ThingToken/SensorName
	${urlCmdNameReplaceThingToken}=    Replace String    ${ASGARD_MQTT_URL_CONFIG_TOPIC_SUBSCRIPTION}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}
	${urlCmdNameReplaceSensorName}=    Replace String    ${urlCmdNameReplaceThingToken}    ${ASGARD_MQTT_FIELD_SENSORNAME}    ${VALUE_CONFIGINFO_KEY_REFRESHTIME}
	${urlCmdName}=    Replace String    ${urlCmdNameReplaceSensorName}    /    .
	${payload}=    Set Variable    null
	#Log to Console    ${pathUrl}
	#Log to Console    ${urlCmdName}

	#resultCode_summary[40300],resultDesc_summary[OnlineConfigs not found.],Code_detail[40300],Description_detail[],applicationName[Asgard.Mqtt.V1.APP],pathUrl[config/update/sim/v1/ThingToken/IPAddress],urlCmdName[config/get/sim/v1/ThingToken/SensorName],ThingToken,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[register],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
	Run Keyword If	${Type} == 1    MQTT Check Log Response    ${ResultCode}    ${ResultDesc}    ${Code}    ${Desc}    ${VALUE_APPLICATIONNAME_MQTT}    ${pathUrl}    ${urlCmdName}    ${ThingToken}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_MQTT}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT_Error}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_SEARCH_CONFIG_MQTT}    ${custom}    ${SensorKey_Real}            

Log MQTT Config Error 004
	[Arguments]    ${IMSI}
	Log To Console    ${\n}============== Start Check Log ==============${\n}
    #Log To Console    IMSI${IMSI}
	#config/update/sim/v1/ThingToken/IPAddress
	${pathUrlReplace}=    Replace Parameters Path    ${ASGARD_MQTT_URL_CONFIG_TOPIC_PUBLISH}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}    ${ASGARD_MQTT_FIELD_IPADDRESS}    ${IPAddress}
	${pathUrl}=    Replace String    ${pathUrlReplace}    /    .
	
	#config/get/sim/v1/ThingToken/SensorName
	${urlCmdNameReplaceThingToken}=    Replace String    ${ASGARD_MQTT_URL_CONFIG_TOPIC_SUBSCRIPTION}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}
	${urlCmdNameReplaceSensorName}=    Replace String    ${urlCmdNameReplaceThingToken}    ${ASGARD_MQTT_FIELD_SENSORNAME}    ${VALUE_CONFIGINFO_KEY_REFRESHTIME}
	${urlCmdName}=    Replace String    ${urlCmdNameReplaceSensorName}    /    .
	${payload}=    Set Variable    null
	${randomSensorApp}=    Evaluate    random.randint(100, 999)    random
	${valueKey}=    Set Variable    {"${getData}[7]": "${randomSensorApp}"}
	${identity}=    Set Variable    {"ThingID":"${getData}[3]","Imei":"${IMSI}","Imsi":"${IMSI}"}		
	${custom}=    Evaluate    {"customData":{"Imsi":['${IMSI}'],"Imei":['${IMSI}'],"ThingID":['${getData}[3]']}}
	${body}=    Evaluate    {"${VALUE_CONFIGINFO_KEY_REFRESHTIME}":"${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}","${VALUE_CONFIGINFO_KEY_MAX}":"${VALUE_CONFIGINFO_KEY_MAX_VALUE}"}	

	#resultCode_summary[40400],resultDesc_summary[OnlineConfigs not found.],Code_detail[40400],Description_detail[],applicationName[Asgard.Mqtt.V1.APP],pathUrl[config/update/sim/v1/ThingToken/IPAddress],urlCmdName[config/get/sim/v1/ThingToken/SensorName],ThingToken,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[config],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
    MQTT Check Log Response    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${EMPTY}    ${EMPTY}    ${VALUE_APPLICATIONNAME_MQTT}    ${pathUrl}    ${urlCmdName}    ${ThingToken}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_MQTT}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_SEARCH_CONFIG_MQTT}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${getData}[7]            
	

Log MQTT Delta
	[Arguments]    ${sensorKey}    ${thingToken}    ${valueKey}    ${IMSI} 
	Log To Console    ${\n}============== Start Check Log ==============${\n}   
    #Log To Console    IMSI${IMSI}
	#report/update/sim/v1/ThingToken/IPAddress
	${pathUrlReplace}=    Replace Parameters Path    ${ASGARD_MQTT_URL_REPORT_TOPIC_PUBLISH}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}    ${ASGARD_MQTT_FIELD_IPADDRESS}    ${IPAddress}
	${pathUrl}=    Replace String    ${pathUrlReplace}/${sensorKey}    /    .
	
	#delta/sim/v1/ThingToken/SensorName
	${urlCmdNameReplaceThingToken}=    Replace String    ${ASGARD_MQTT_URL_REPORT_TOPIC_SUBSCRIPTION_LOG}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}
	${urlCmdNameReplaceSensorName}=    Replace String    ${urlCmdNameReplaceThingToken}    ${ASGARD_MQTT_FIELD_SENSORNAME}    ${sensorKey}
	${urlCmdName}=    Replace String    ${urlCmdNameReplaceSensorName}    /    .
	
	#${identity}=    Set Variable    {"ThingID":"${getData}[3]","Imei":"${IMSI}","Imsi":"${IMSI}"}		
	#${custom}=    Evaluate    {'Imsi': ['${IMSI}'], 'Imei': ['${IMSI}'], 'ThingID': ['${getData}[3]']}
	${body}=    Set Variable    ${valueKey}	
	
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[Register is Success],applicationName[Asgard.Mqtt.V1.APP],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Sim/Register],ThingToken,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[report],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
    MQTT Check Log Response Delta    ${CODE_20000}    ${RESULTDESC_THE_REQUESTED_OPERATION_SUCCESSFULLY}    ${CODE_20000}    ${VALUE_DESCRIPTION_REGISTER_SUCCESS}    ${VALUE_APPLICATIONNAME_MQTT}    ${pathUrl}    ${urlCmdName}    ${thingToken}    ${IPAddress}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_MQTT}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_REPORT_MQTT}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_SEARCH_REPORT_MQTT}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${sensorKey}    ${valueKey}                
    #Log To Console    logthingToken${thingToken}

