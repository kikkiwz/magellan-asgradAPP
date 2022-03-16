*** Settings ***
Resource    ../variables/Variables_Request.robot   
Resource    ../variables/Variables_Datetime.robot 
Resource    ../variables/Variables_CreateData.robot 
Resource    ../variables/Variables_RemoveData.robot 
Resource    ../variables/Variables_UpdateData.robot 
Resource    ../variables/Variables_InquiryData.robot 
Resource    ../variables/Variables_Asgard_APP_API.robot 
Resource    ../variables/Variables_Asgard_MQTT.robot 
Resource    ../variables/Variables_Log.robot 
Resource    ../variables/Variables_Environment.robot
Resource    ../variables/Variables_ResultCode.robot
Resource    ../variables/Variables_Asgard_HTTP.robot

*** Variables ***
${timeout}    0.5 second
${delay}    0.3
${retry}    5x   
${retry_interval}    5s

#Initial variable
${IMAGE_DIR}
#path folder image
${IMAGE_PATH}    /../img/img
${IMAGE_PATH_ASGARD_COAPAPP}    /../img/img_Asgard_APP
${IMAGE_PATH_ASGARD_COAPAPI}    /../img/img_Asgard_API
${IMAGE_PATH_ASGARD_MQTT}    /../img/img_Asgard_MQTT
${ASGARD_IMAGE_BTN_CLOSE}    close.png
${path_Thing-Simulator-Portable_V3.1.0}    /../Thing-Simulator-Portable_V3.1.0  
