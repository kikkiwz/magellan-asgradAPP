*** Variables ***

#-------------------------------------------- Value Connection --------------------------------------------#	
${ASGARD_MQTT_TAB_SECURITY_USERNAME_SIM}    Sim.
${ASGARD_MQTT_TAB_SECURITY_PASSWORD}    1.2.3.4
#-------------------------------------------- Value Connection --------------------------------------------#	

#-------------------------------------------- Image --------------------------------------------#	
#image Asgrad MQTT
${ASGARD_MQTT_IMAGE_MQTTSPY}    mqtt_spy.png
${ASGARD_MQTT_IMAGE_MQTTSPY_HEADER}    mqtt_spy_header.png
${ASGARD_MQTT_IMAGE_MENU_CONNECTIONS}    menu_connections.png
${ASGARD_MQTT_IMAGE_MENU_CONNECTIONS_NEWCONNECTION}    menu_connections_newConnection.png
${ASGARD_MQTT_IMAGE_TXT_CONNECTIONNAME}    txt_connectionName.png 
${ASGARD_MQTT_IMAGE_TXT_CONNECTIONNAME_DATA}    txt_connectionName_data.png 
${ASGARD_MQTT_IMAGE_TXT_CONNECTIONNAME_DATA_NULL}    txt_connectionName_data_null.png 
#Security tab
${ASGARD_MQTT_IMAGE_TAB_SECURITY}    tab_security.png 
${ASGARD_MQTT_IMAGE_CHK_ENABLE_USER_AUTH}    chk_enable_user_authentication.png 
${ASGARD_MQTT_IMAGE_RDI_USERNAME_PREDEFINED}    rdi_username_predefined.png 
${ASGARD_MQTT_IMAGE_TXT_USERNAME_PREDEFINED}    txt_username_predefined.png 
${ASGARD_MQTT_IMAGE_RDI_PASSWORD_PREDEFINED}    rdi_password_predefined.png 
${ASGARD_MQTT_IMAGE_TXT_PASSWORD_PREDEFINED}    txt_password_predefined.png 
#Connectivity tab
${ASGARD_MQTT_IMAGE_TAB_CONNECTIVITY}    tab_connectivity.png 
${ASGARD_MQTT_IMAGE_TXT_SERVERURL_DATA}    txt_serverUrl_data.png 
${ASGARD_MQTT_IMAGE_TXT_SERVERURL_DATA_TEXTALL}    txt_serverUrl_data_textAll.png 
${ASGARD_MQTT_IMAGE_TXT_SERVERURL_NULL}    txt_serverUrl_null.png 
${ASGARD_MQTT_IMAGE_TXT_CLIENTID_DATA}    txt_clientId_data.png 


${ASGARD_MQTT_IMAGE_BTN_OPENCONNECTION}    btn_OpenConnection.png
${ASGARD_MQTT_IMAGE_BTN_YES_POPUP_UNSAVECHANGESDETECTED}    btn_Yes_popup_unsavedChangesDetected.png
${ASGARD_MQTT_IMAGE_BTN_OK_POPUP_CANNOTSAVECONFIGFILE}    btn_ok_popup_cannotSaveConfigFile.png


#publish page
${ASGARD_MQTT_IMAGE_TXT_PUBLISH_TOPIC}    txt_publish_topic.png
${ASGARD_MQTT_IMAGE_BTN_PUBLISH}    btn_publish.png
${ASGARD_MQTT_IMAGE_TAB_NEW_SUBSCRIPTION}    tab_new_subscription.png
${ASGARD_MQTT_IMAGE_TXT_SUBSCRIPTION_TOPIC}    txt_subscription_topic.png
${ASGARD_MQTT_IMAGE_BTN_SUBSCRIBE}    btn_subscribe.png

${ASGARD_MQTT_IMAGE_PATH_SUBSCRIPTION_REGISTER}    path_subscription_register.png
${ASGARD_MQTT_IMAGE_MENU_DISCONNECT_ANDKEEPTAB}    menu_disconnect_andkeeptab.png


${ASGARD_MQTT_IMAGE_TAB_STATUS_DISCONNECT}    status_disconnect.png
${ASGARD_MQTT_IMAGE_MENU_CONNECT_RECONNECT}    menu_connect_reconnect.png
${ASGARD_MQTT_IMAGE_TXT_PUBLISH_TOPIC_REGISTER}    txt_publish_topic_register.png
${ASGARD_MQTT_IMAGE_TXT_PUBLISH_TOPIC_REGISTER_ALL}    txt_publish_topic_register_all.png
${ASGARD_MQTT_IMAGE_TXT_PUBLISH_TOPIC_AFTERCLEAR}    txt_publish_topic_afterclear.png
${ASGARD_MQTT_IMAGE_TXT_SUBSCRIPTION_TOPIC_REGISTER}    txt_subscription_topic_register.png
${ASGARD_MQTT_IMAGE_TXT_SUBSCRIPTION_TOPIC_REGISTER_ALL}    txt_subscription_topic_register_all.png
${ASGARD_MQTT_IMAGE_TXT_SUBSCRIPTION_TOPIC_NULL}    txt_subscription_topic_null.png

${ASGARD_MQTT_IMAGE_PATH_SUBSCRIPTION_CONFIG}    path_subscription_config.png


${ASGARD_MQTT_IMAGE_TXT_PUBLISH_DATA}    txt_publish_data_null.png
#802912922218235
#b4d66aee-0f3d-4b5b-84a6-c3bcf1819549


#-------------------------------------------- Data --------------------------------------------#
#utl Path
${ASGARD_MQTT_URL_REGISTER_TOPIC_PUBLISH}    register/update/sim/v1/IMSI/IPAddress
${ASGARD_MQTT_URL_REGISTER_TOPIC_SUBSCRIPTION}    register/get/sim/v1/IMSI
${ASGARD_MQTT_URL_CONFIG_TOPIC_PUBLISH}    config/update/sim/v1/ThingToken/IPAddress
${ASGARD_MQTT_URL_CONFIG_TOPIC_SUBSCRIPTION}    config/get/sim/v1/ThingToken/SensorName
${ASGARD_MQTT_URL_REPORT_TOPIC_PUBLISH}    report/update/sim/v1/ThingToken/IPAddress
${ASGARD_MQTT_URL_REPORT_TOPIC_SUBSCRIPTION_LOG}    internalreport/pub/v1/ThingToken    
${ASGARD_MQTT_URL_DELTA_TOPIC_SUBSCRIPTION}    delta/get/sim/v1/ThingToken/SensorName


${ASGARD_MQTT_FIELD_TOKEN}    ThingToken
${ASGARD_MQTT_FIELD_IPADDRESS}    IPAddress
${ASGARD_MQTT_FIELD_IMSI}    IMSI
${ASGARD_MQTT_FIELD_SENSORNAME}    SensorName

#TST_F1_0_2_002
${ASGARD_MQTT_VALUE_TST_F1_0_2_002_IMSI}    20003
#TST_F3_0_2_003
${ASGARD_MQTT_VALUE_TST_F3_0_2_003_URL_SENSORNAME_INVALID}    refeee
 
#TST_F4_0_2_002
${ASGARD_MQTT_VALUE_TST_F4_0_2_002_SENSORNAME}    SA
