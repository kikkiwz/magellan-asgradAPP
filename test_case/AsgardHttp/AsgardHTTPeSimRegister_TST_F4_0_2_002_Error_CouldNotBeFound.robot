*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
*** Test Cases ***

AsgardHTTPeSimRegister_TST_F4_0_2_002_Error_CouldNotBeFound
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : AsgardHTTPeSimRegister
    ...    8.MGCore & Centric : Remove Thing
    ...    9.MGCore : Remove Account
    ...    10.MGCore : Remove Partner
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	${random_num}=    Evaluate    random.randint(100, 999)    random
	#=============End Prepare data Report==============
	# Register 
	${authen}=    Set Variable    ${IMSI}${random_num}:${IPAddress}
	${res}=    AsgardHTTPRegister    ${authen}$    ${OPERATION_STATUS_AsgardHTTPRegister_40400}
	# Check log detail and summary 
	${identity}=    Set Variable    {"Imei":null,"ThingId":null,"Imsi":"${IMSI}${random_num}"}		 
	${custom}=    Set Variable    {"Imsi":["${IMSI}${random_num}"],"url":"${HOST}${URL_AsgardHTTPRegister}","Imei":null,"ThingId":null}   	 
	${body}=    Set Variable    ""
	${orderRef}=    Set Variable    ${res}[1]
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS} 
	Log HTTP Register    ${CODE_40400}    ${RESULTDESC_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${orderRef}    ${IMSI}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}  
	[Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}


