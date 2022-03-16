*** Settings ***
Library    SikuliLibrary
#Library    OperatingSystem
Library    Collections
Library    String
Library    DateTime
Library    Process
Library    BuiltIn
Library    JSONLibrary
Library    MongoDBLibrary
Library    MQTTLibrary

Resource    ../keyword/Keyword_Request.robot
Resource    ../keyword/Keyword_API.robot
Resource    ../keyword/Keyword_RemoveData.robot
Resource    ../keyword/Keyword_Log.robot
Resource    ../keyword/Keyword_Log_Summary.robot
Resource    ../keyword/Keyword_Log_Detail_CoapApp.robot
Resource    ../keyword/Keyword_Log_Detail_CoapApi.robot
Resource    ../keyword/Keyword_Log_Detail_MQTT.robot
Resource    ../keyword/Keyword_Log_Detail_HTTP.robot
Resource    ../keyword/Keyword_Log_Detail_Charging.robot
Resource    ../keyword/Keyword_VerifyDB.robot
Resource    ../keyword/Keyword_Mainflow_AsgardApp.robot
Resource    ../keyword/Keyword_Mainflow_AsgardApi.robot
Resource    ../keyword/Keyword_Mainflow_AsgardMQTT.robot
Resource    ../keyword/Keyword_Mainflow_AsgardHTTP.robot
Resource    ../keyword/Keyword_MongoDB.robot
#Library Document
#https://robotframework.org/robotframework/latest/libraries/BuiltIn.html
#https://robotframework.org/robotframework/latest/libraries/String.html
#https://robotframework.org/robotframework/latest/libraries/Collections.html
#https://robotframework-thailand.github.io/robotframework-jsonlibrary/JSONLibrary.html

*** Keywords ***
####################################################
Add Needed Image Path
    Add Image Path    ${IMAGE_DIR}

Open Simulator  
    Log To Console    === Open App =====
	Add Image Path    ${CURDIR}${IMAGE_PATH_ASGARD_COAPAPP}
	Log To Console    Current Path : ${CURDIR}${IMAGE_PATH_ASGARD_COAPAPP}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Open Program 
    #Select Dropdrown ENV
	Log To Console    Do : ${ASGARD_COAPAPP_IMAGE_DDL}
    ${status_dropdown}=    Run Keyword And Return Status    Click     ${ASGARD_COAPAPP_CHOOSE_IMAGE_DDL}     5
	Run Keyword If    '${status_dropdown}'=='False'   Select Dropdrown ENV    ${ASGARD_COAPAPP_IMAGE_DDL}
	Run Keyword If    '${status_dropdown}'=='True'    Log To Console    Dropdrown ENV ${ASGARD_COAPAPP_CHOOSE_IMAGE_DDL} is open

Replace Text
    [Arguments]    ${string}    ${search_for}    ${Ireplace_withP}
	
	${replaceUrl}=    Replace String    ${string}    ${search_for}    ${replace_with}
	Log To Console    ${text}
	[RETURN]    ${text}
	
Replace Parameters Url Path
	[Arguments]    ${url}    ${urlPath}    ${ParametersField}    ${value_ParametersField}    ${ParametersField_ipAddress}    ${value_ipAddress}
	${replaceParametersUrl}=    Replace String    ${urlPath}    ${ParametersField}    ${value_ParametersField}
	#Log To Console    replaceUrl${replaceParametersUrl}
    ${replaceIPAddressUrl}=    Replace String    ${replaceParametersUrl}    ${ParametersField_ipAddress}    ${value_ipAddress}
	#Log To Console    replaceUrl${replaceIPAddressUrl}
	${url}=    Set Variable    ${url}${replaceIPAddressUrl}
	#Log To Console    ${url}
	[return]    ${url}
	
Replace Parameters Path
	[Arguments]    ${urlPath}    ${ParametersField}    ${value_ParametersField}    ${ParametersField_ipAddress}    ${value_ipAddress}
	${replaceParametersUrl}=    Replace String    ${urlPath}    ${ParametersField}    ${value_ParametersField}
	#Log To Console    replaceUrl${replaceParametersUrl}
    ${replaceIPAddressUrl}=    Replace String    ${replaceParametersUrl}    ${ParametersField_ipAddress}    ${value_ipAddress}
	#Log To Console    replaceUrl${replaceIPAddressUrl}
	${path}=    Set Variable    ${replaceIPAddressUrl}
	#Log To Console    ${path}
	[return]    ${path}	

Replace Parameters
	[Arguments]    ${urlPath}    ${ParametersField}    ${value_ParametersField}
	${replaceParametersUrl}=    Replace String    ${urlPath}    ${ParametersField}    ${value_ParametersField}
	#Log To Console    replaceUrl${replaceParametersUrl}
	${path}=    Set Variable    ${replaceParametersUrl}
	#Log To Console    ${path}
	[return]    ${path}	
	
Check Matched
    [Arguments]    ${image}
	Set Min Similarity    0.99
	${index}=    Set Variable    
    FOR    ${index}    IN RANGE    1    5
	    ${valueCheck}=    Exists    ${image}    2
	    Run Keyword If    ${valueCheck} == True    Exit For Loop
	    Run Keyword If    ${valueCheck} == False    Log To Console    ${\n}Failed!! Retry Check Again!!#${index}	     
	    ${index}=    Evaluate    ${index} + 1
    END
	[return]    ${valueCheck}	

Check Matched Result
    [Arguments]    ${image}
	Set Min Similarity    0.99
	Exists    ${image}    2
	#Run Keyword If    ${valueCheck} == True   Log    Pass    #Log    'PASS'
    #...    ELSE   FAIL    msg=Not Matched

Open Program  
    Add Image Path    ${CURDIR}${IMAGE_PATH_ASGARD_COAPAPP}
	#Open Directory
	#Add Image Path    ${CURDIR}${IMAGE_PATH_ASGARD_COAPAPP}
	#Log    ${CURDIR}${IMAGE_PATH_ASGARD_COAPAPP}
	${result_folder_header}=    Run Keyword And Return Status    Wait Until Screen Contain    ${ASGARD_COAPAP_IMAGE_THING_SIMULATOR}    5  
	Run Keyword If	'${result_folder_header}' == 'True'    Click    ${ASGARD_COAPAP_IMAGE_THING_SIMULATOR}
	Run Keyword If	'${result_folder_header}' == 'False'    Click    Thing-Simulator-Portable1_V3.1.0.png
	${result}=    Run Keyword And Return Status    Wait Until Screen Contain    ${ASGARD_COAPAP_IMAGE_THING_SIMULATOR}    5   
	Run Keyword If	'${result}' == 'True'    Double Click    ${ASGARD_COAPAP_IMAGE_THING_SIMULATOR}
	Run Keyword If	'${result}' == 'False'    Double Click    Thing_Simulator_2.png
	#Run Keyword If	'${result}' == 'False'    Log To Console    ${\n} Retry Open Application "${ASGARD_COAPAP_IMAGE_THING_SIMULATOR}" Failed!!
	Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Screen Contain    ${ASGARD_COAPAP_IMAGE_MAGELLANCLIENT_HEADER}    5

Open Program MQTT  
    Add Image Path    ${CURDIR}${IMAGE_PATH_ASGARD_MQTT}
    Double Click    ${ASGARD_MQTT_IMAGE_MQTTSPY}
	Wait Until Screen Contain    ${ASGARD_MQTT_IMAGE_MQTTSPY_HEADER}    5

Select Dropdrown ENV
    [Arguments]    ${value_selectd}
    Exists     ${ASGARD_COAPAPP_IMAGE_DDL_ENV_IOT_DOCKERAZURE}     5
	Click    ${ASGARD_COAPAPP_IMAGE_DDL_ENV_IOT_DOCKERAZURE}
    Exists     ${value_selectd}     5
	Click    ${value_selectd}
	
Select Dropdrown Function
    [Arguments]    ${value_selectd}
	Click    ${ASGARD_COAPAPP_IMAGE_DDL_FUNCTION_REPORT}
	Click    ${value_selectd}	

Select Dropdrown Function1
    [Arguments]    ${value_before_selectd}    ${value_selectd}
	Click    ${value_before_selectd}
	Click    ${value_selectd}	

Clear Input  
    [Arguments]    ${img_input}
    Double Click    ${img_input}
	Press Special Key    DELETE	


Clear Input Again
    Log To Console    Check Empty URL
	Press Special Key    CTRL	
    Type With Modifiers    a    KEY_CTRL
	#Press Special Key    type("a", Key.CTRL)	
	Press Special Key    DELETE	
    #${status_url2}=    Run Keyword And Return Status    Exists     ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}     5
	#Run Keyword If    '${status_url2}'=='False'    Clear Input Again    

Input Url 
    [Arguments]    ${img_url}    ${url}    ${img_url_null}
	Exists     ${img_url}     5
	Clear Input    ${img_url}

	#Check Input Again
	sleep    2s
	Log To Console    Do : ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}
    ${status}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}     5
	Run Keyword If    '${status}'=='False'    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Clear Input Again    
	sleep    2s
	Input Text    ${img_url_null}    ${url} 


Input Url2 
    [Arguments]    ${srcImage}    ${targetImage}    ${url}    ${img_url_null}
	Exists     ${srcImage}     5
	Exists     ${targetImage}     5
	Drag And Drop    ${srcImage}    ${targetImage}
	Press Special Key    DELETE
	Input Text    ${img_url_null}    ${url} 

Input Payload 
    [Arguments]    ${value}
	Clear Input    ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD}
	Input Text    ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NULL}    ${value}

Input Payload Textarea Null 
    [Arguments]    ${value}
    ${status_playload_null}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NULL}     5	
    ${status_playload_notnull}=    Run Keyword And Return Status    Wait Until Screen Contain     ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NOT_NULL}     5	
	${playload_notnull}=    Set Variable If    '${status_playload_notnull}'=='True' and '${status_playload_null}'=='False'     ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NOT_NULL} 
	...    '${status_playload_notnull}'=='False' and '${status_playload_null}'=='False'    ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NOT_NULL1}
	...    '${status_playload_null}'=='True'    ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NULL}
	Input Text    ${playload_notnull}    ${value}

Close Program
    Click    ${ASGARD_IMAGE_BTN_CLOSE}
	
Input Value
    [Arguments]    ${img_txt_data}    ${txt}
	Exists     ${img_txt_data}     5
	Double Click    ${img_txt_data}
	Input Text    ${img_txt_data}    ${txt}

Input Value And Clear
    [Arguments]    ${img_txt_data}    ${img_txt_data_all}    ${txt}
	Exists     ${img_txt_data}     5
	#Double Click    ${img_txt_data}
	Clear Input    ${img_txt_data}
	Input Text    ${img_txt_data_all}    ${txt}

Input Value And Delete
    [Arguments]    ${img_txt_data}    ${txt}
	Exists     ${img_txt_data}     5
	Double Click    ${img_txt_data}
	Clear Input    ${img_txt_data}
	Input Text    ${img_txt_data}    ${txt}


#for use check log and verify DB check data 
Check Json Data Should Be Equal
	[Arguments]    ${JsonData}    ${field}    ${expected}    ${fieldName}
	
	#json.dumps use for parameter convert ' to "
	${listAsString}=    Evaluate    json.dumps(${JsonData})    json
	#r use for parameter / have in data
	${resp_json}=    Evaluate    json.loads(r'''${listAsString}''')    json
	#Log To Console    resp_json${resp_json}	
    #Should Be Equal    ${resp_json['${field}']}    ${expected}
	#Log To Console    resp_json${resp_json${field}}
	Log Many    ${listAsString}	
	Log To Console    ${fieldName} : ${expected} = ${resp_json${field}}
    Run Keyword And Continue On Failure    Should Be Equal    ${expected}    ${resp_json${field}}    error=${field}	

Check Custom None
	[Arguments]    ${JsonData}    ${field}
	#json.dumps use for parameter convert ' to "
	${listAsString}=    Evaluate    json.dumps(${JsonData})    json
	#r use for parameter / have in data
	${resp_json}=    Evaluate    json.loads(r'''${listAsString}''')    json
    ${data}=    Set Variable    ${resp_json${field}}
    ${status}=    Run Keyword And Return Status    Should Be Equal As Strings    ${data}    None
    ${result}=    Set Variable If    '${status}'=='True'    None
	...    '${status}'!='True'    ${resp_json}	
    [Return]    ${status}    ${result}

Check Field None
	[Arguments]    ${JsonData}    ${field}
	#json.dumps use for parameter convert ' to "
	${listAsString}=    Evaluate    json.dumps(${JsonData})    json
	#r use for parameter / have in data
	${resp_json}=    Evaluate    json.loads(r'''${listAsString}''')    json
    ${data}=    Run Keyword And Return Status    Set Variable    ${resp_json${field}}
    [Return]    ${data}

Data Should Be Equal
	[Arguments]    ${expect}    ${actual}    ${field}
	Log To Console    ${field} : ${expect} = ${actual}
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${expect}    ${actual}    error=${field}    strip_spaces=True	


Teardown Message
    [Arguments]    ${message}
    Log    Failed!!!	
  
Generic Test Case Teardown
    [Arguments]    ${Flow}    ${Data}    ${groupId}
    # Catch of Try Catch Finally
    Run Keyword If Test Failed    Test Case Catch 
    # Finally of Try Catch Finally
    #  RKITS is only executed when test passed.
    Run Keyword If Test Passed    Test Case Finally
	Run Keyword If	"${Flow}" == "Register" or "${Flow}" == "Report" or "${Flow}" == "Delta"    Run Keyword    Rollback Data    ${Data}
	Run Keyword If	"${Flow}" == "Config"    Rollback Data Config    ${Data}    ${groupId}
	Run Keyword If	"${Flow}" == "Charging Register"    Rollback Data Charging    ${Data}
    #Close Program

Test Case Catch
    #Run Keyword And Ignore Error    Close Program
    Log To Console    Test Case Catch : Rollback!!
  
Test Case Finally
    #Run Keyword And Ignore Error    Close Program
    Log To Console    Test Case Finally

Open Directory
    #Add Needed Image Path
    #set variable ${IMAGE_DIR} for set folder img
	Add Image Path    ${CURDIR}${IMAGE_PATH_ASGARD_COAPAPP}
    sleep    1s
	Exists     search.png     5
    Click    search.png
    Double Click    input_search.png
	SikuliLibrary.Input Text    input_search.png    file explorer
	Click    File_Explorer.png
	Add Image Path    ${CURDIR}${path_Thing-Simulator-Portable_V3.1.0}
	${path_simulator}=    Normalize path    ${CURDIR}${path_Thing-Simulator-Portable_V3.1.0}
	Log    ${path_simulator}
	SikuliLibrary.Input Text    Quick_access.png    ${path_simulator}
    Click    enter.png

Click Button
    [Arguments]    ${IMG}
	Exists     ${IMG}     5
	Click    ${IMG}

#==============================================================================
#                       Date Time
#==============================================================================
#H : hour
#M : minute
#S : s
#Mo : month
#Y : year
#format
#${MDYYYY_ADDSUB}    %m/%d/%Y
#${DDMMYYYY_ADDSUB}    %d/%m/%Y
#${MDYYYY_NOW}    {dt:%m}/{dt:%d}/{dt:%Y}
#${DDMMYYYY_NOW}    {dt:%d}/{dt:%m}/{dt:%Y}
#ex. 10/03/2020
Change format date now
    [Arguments]    ${format}
	#change format
	${now}    Evaluate  '${format}'.format(dt=datetime.datetime.now())    modules=datetime
	#Log To Console    now${now}
	[return]    ${now}

#ex. 23/09/2020 -> 24/10/2020 add 31 days
Value Add date now
    [Arguments]    ${format}    ${day} 
	#${getTime}=    Get Text    ${locator} 
	
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	${addDate}=      Add Time To Date      ${currentDate}      ${day} days
    ${valueDate}      Convert Date      ${addDate}      result_format=${format}
	#Log To Console    valueDate${valueDate}
	
	[return]    ${valueDate}
	
Value Minus date now
    [Arguments]    ${format}    ${day} 
	#${getTime}=    Get Text    ${locator} 
		
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	${subtractDate}=      Subtract Time From Date      ${currentDate}      ${day} days
    ${valueDate}      Convert Date      ${subtractDate}      result_format=${format}
	
	[return]    ${valueDate}
	
Value Minus Time Current Date and Change Format
    [Arguments]    ${format}    ${time}    ${timeString} 
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	${subtractDate}=      Subtract Time From Date      ${currentDate}      ${time} ${timeString}
	#Log To Console    subtractDate${subtractDate}
    ${valueDate}      Convert Date      ${subtractDate}      result_format=${format}
	
	[return]    ${valueDate}

Value Minus Time Current Date Not Change Format
    [Arguments]    ${time}    ${timeString} 			
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	${subtractDate}=      Subtract Time From Date      ${currentDate}      ${time} ${timeString}
	#Log To Console    subtractDate${subtractDate}
 
	[return]    ${subtractDate}
		
#Gte -> Lte
Rang Get Value Minus Time Current Date and Change Format
    [Arguments]    ${format}    ${time}    ${timeString} 
		
	${date}=      Get Current Date      UTC      exclude_millis=yes
	${currentDate}=      Add Time To Date      ${date}    -1 hour
	${tomorrowDate}=      Add Time To Date      ${currentDate}    1 days
	#${subtractDate1}=      Subtract Time From Date      ${currentDate}      15 ${timeString}
	#${subtractDate}=      Subtract Time From Date      ${currentDate}      ${time} ${timeString}
	#Log To Console    subtractDate${subtractDate}
    
	${valueDateGte}      Convert Date      ${currentDate}      result_format=${format}
	${valueDateLte}      Convert Date      ${tomorrowDate}      result_format=${format}
	#Log To Console    valueDateGte${valueDateGte}
	#Log To Console    valueDateLte${valueDateLte}
	[return]    ${valueDateGte}    ${valueDateLte}    

Get Values
    [Arguments]    ${data}    ${field}
	Log    ${data}
	${data_dict}=    Convert To Dictionary    ${data}
	${result}=    Get From Dictionary    ${data_dict}    ${field}
	[Return]    ${result}

