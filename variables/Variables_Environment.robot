*** Variables ***
#===================================================================
# Provisioning
#===================================================================
#STAGING
#${URL}    https://mg-staging.siamimo.com
#${SIGNIN_USERNAME}    QATest_003
#${SIGNIN_PASSOWORD}    bnZkZm5nZXJnbGtkanZlaWdqbmVvZGtsZA==
#${VALUE_LOG_NAMESPACE}    Magellan 
#IOT
${URL}    https://mg-iot.siamimo.com
${HOST}    mg-iot.siamimo.com
${HOST_CHARGING}    chargingapis.magellan.svc.cluster.local
${URL_CENTRIC}    https://mgcentric-iot.siamimo.com
${SIGNIN_USERNAME}    QA_SC
${SIGNIN_PASSOWORD}    VGVzdDEyMzQ=
${VALUE_LOG_NAMESPACE}    magellan
${CONNECT_MONGODB}    mongodb://admin:ais.co.th@52.163.210.190:27018/mgcore?authSource=admin
${PROVISIONINGAPIS}    /provisioningapis
${HTTPAIS}    /httpapis
${CENTRICAPIS}    /centricapis
${CONTROLAPIS}    /controlapis
${URL_ROCS}    api/v3/rocs/metering-method
#===================================================================
# MQTT
#===================================================================
#STG
#${ASGARD_MQTT_VALUE_CONNECTION_NAME}    52.139.231.235
#${ASGARD_MQTT_VALUE_SERVERURL}    52.139.231.235    
#${ASGARD_MQTT_VALUE_CLIENTID}    StagingAzureCloudron 
#${ASGARD_MQTT_IMAGE_STATUS_CONNECT_SUCCESS}    statusConnect_success.png
#${ASGARD_MQTT_IMAGE_TAB_STATUS_CONNECT_SUCCESS}    tab_statusConnect_success.png
#${ASGARD_MQTT_IMAGE_TAB_STATUS_CONNECT_ERROR}    statusConnect_error.png
#${VALUE_APPLICATIONNAME_COAPAPI}    Asgard.Coap.APIs
#${VALUE_APPLICATIONNAME_MQTT}    Asgard.Mqtt.V1.APP
#${VALUE_APPLICATIONNAME_CHARGING}    Insight.Charging.APIs

#IOT
${ASGARD_MQTT_VALUE_CONNECTION_NAME}    52.139.225.243
${ASGARD_MQTT_VALUE_SERVERURL}    52.139.225.243    
${ASGARD_MQTT_VALUE_CLIENTID}    IOTAzureCloudron  
${ASGARD_MQTT_IMAGE_STATUS_CONNECT_SUCCESS}    statusConnect_IOT_success.png 
${ASGARD_MQTT_IMAGE_TAB_STATUS_CONNECT_SUCCESS}    tab_statusConnect_IOT_success.png
${ASGARD_MQTT_IMAGE_TAB_STATUS_CONNECT_ERROR}    statusConnect_IOT_error.png
${VALUE_APPLICATIONNAME_COAPAPI}    CoapAPIs
${VALUE_APPLICATIONNAME_MQTT}    MqttAPP
${VALUE_APPLICATIONNAME_CHARGING}    Insight.Charging.APIs
${VALUE_APPLICATIONNAME_HTTP}    HttpAPIs
${IPAddress}    1.2.3.4
${Pass}    1.2.3.4
#URL

#===================================================================
# Adgard
#===================================================================
#STAGING	
#${ASGARD_COAPAPP_URL}    coap://52.139.231.235:5683
#${ASGARD_COAPAPP_IMAGE_DDL}    ddl_Staging_CauldronAzue.png
#${URL_GET_LOG}    https://mg-staging.siamimo.com:30380/elasticsearch/application*/_search?rest_total_hits_as_int=true&ignore_unavailable=true&ignore_throttled=true&preference=1620900474581&timeout=30000ms
#${VALUE_APPLICATIONNAME_COAPAPP}    Asgard.Coap.APP
#IOT
${ASGARD_COAPAPP_URL}    coap://52.139.225.243:5683
${ASGARD_COAPAPP_IMAGE_DDL}    ddl_IoT_Cauldorn_Azure.png
${ASGARD_COAPAPP_CHOOSE_IMAGE_DDL}    ddl_Choose_IoT_Cauldorn_Azure.png
${URL_GET_LOG}    https://mg-iot.siamimo.com:30380/elasticsearch/application*/_search?rest_total_hits_as_int=true&ignore_unavailable=true&ignore_throttled=true&preference=1620900474581&timeout=30000ms
${VALUE_APPLICATIONNAME_COAPAPP}    CoapAPP
${ASGARD_COAPAPP_IP_ADDRESS}    1.2.3.4
${ASGARD_COAPAPP_IP_ADDRESS2}    1.2.3.10
#===================================================================
# DB
#===================================================================
#IOT
#STG
#All
${MGCORE_DBNAME}    mgcore
${MGCENTRIC_DBNAME}    mgcentric
${MGCORE_COLLECTION_THING}    things
${MGCENTRIC_COLLECTION_THING}    things