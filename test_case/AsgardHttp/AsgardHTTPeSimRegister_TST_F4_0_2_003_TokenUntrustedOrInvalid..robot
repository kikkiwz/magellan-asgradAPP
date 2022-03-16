*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot
*** Test Cases ***

AsgardHTTPeSimRegister_TST_F4_0_2_003_TokenUntrustedOrInvalid.
    [Documentation]    Step is :    
    ...    1.Centric : Import Thing 
	...    2.Centric : MappingIMEI 
	...    3.MGCore : Signin 
    ...    4.MGCore : Create Partner
    ...    5.MGCore : Create AccountName
    ...    6.MGCore : ActivateThing
    ...    7.MGCore : AsgardHTTPeSimRegister
    ...    8.MGCore : Remove Account
    ...    9.MGCore & Centric : Remove Thing
    ...    10.MGCore : Remove Partner
	#=============Start Prepare data Report============== 
	# Create data 
    ${createResponse}=    CreateData   
	${IMSI}=    Set Variable    ${createResponse}[0]
	#=============End Prepare data Report==============
	# Register 
	${authen}=    Set Variable    
	${res}=    AsgardHTTPRegisterNoauth    ${authen}     ${OPERATION_STATUS_AsgardHTTPRegister_40103}
	# Check log detail and summary 
	${identity}=    Set Variable    ${EMPTY}	 
	${custom}=    Set Variable    ${NULL}	 
	${body}=    Set Variable    ${EMPTY}
	${orderRef}=    Set Variable    ${res}[1]
	${endPointName_detail_list}    Create List    ${ENDPOINTNAME_THINGS} 
	Log HTTP Register    ${CODE_40103}    ${RESULTDESC_THE_TOKEN_IS_UNTRUSTED_OR_INVALID}    ${orderRef}    ${IMSI}    ${endPointName_detail_list}    ${identity}    ${custom}    ${body}  
	[Teardown]    Generic Test Case Teardown    Register    ${createResponse}    ${EMPTY}


