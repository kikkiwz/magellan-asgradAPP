*** Keywords ***
####################################################
#                 Mainflow Remove Data
####################################################
Rollback Data
	#accessToken,PartnerId,AccountId,ThingID_MGCORE,ThingID_MGCentric
	[Arguments]    ${getData}
	Log To Console    ${\n}============== Rollback Data ==============${\n}
	${accessToken}=    Set Variable    ${getData}[1]
	${ThingID_MGCORE}=    Set Variable    ${getData}[3]
	${AccountId}=    Set Variable    ${getData}[5]
	${PartnerId}=    Set Variable    ${getData}[6]
	${ThingID_MGCentric}=    Set Variable    ${getData}[8]
	Run Keyword And Continue On Failure    DeleteThingCentric    ${ThingID_MGCentric}
	Run Keyword And Continue On Failure    Remove Thing    ${accessToken}    ${ThingID_MGCORE}    ${AccountId}
	Run Keyword And Continue On Failure    Remove AccountName    ${accessToken}    ${PartnerId}    ${AccountId}
	Run Keyword And Continue On Failure    Remove Partner    ${accessToken}    ${PartnerId}

Rollback Data Charging
	#accessToken,PartnerId,AccountId,ThingID_MGCORE,ThingID_MGCentric
	[Arguments]    ${getData}
	Log To Console    ${\n}============== Rollback Data ==============${\n}
	${accessToken}=    Set Variable    ${getData}[1]
	${ThingID_MGCORE}=    Set Variable    ${getData}[3]
	${AccountId}=    Set Variable    ${getData}[5]
	${PartnerId}=    Set Variable    ${getData}[6]
	${ThingID_MGCentric}=    Set Variable    ${getData}[8]
	Run Keyword And Continue On Failure    DeleteThingCentric    ${ThingID_MGCentric}
	Run Keyword And Continue On Failure    Remove Thing    ${accessToken}    ${ThingID_MGCORE}    ${AccountId}



Rollback Data Config
	#accessToken,PartnerId,AccountId,ThingID,Type,SensorKey
	[Arguments]    ${getData}    ${groupId}
	Log To Console    ${\n}============== Rollback Data ==============${\n}
	${accessToken}=    Set Variable    ${getData}[1]
	${ThingID_MGCORE}=    Set Variable    ${getData}[3]
	${AccountId}=    Set Variable    ${getData}[5]
	${PartnerId}=    Set Variable    ${getData}[6]
	${ThingID_MGCentric}=    Set Variable    ${getData}[8]
	Run Keyword And Continue On Failure    DeleteThingCentric    ${ThingID_MGCentric}
	Run Keyword And Continue On Failure    Remove ConfigGroup   ${accessToken}    ${AccountId}    ${groupId}
	Run Keyword And Continue On Failure    Remove Thing    ${accessToken}    ${ThingID_MGCORE}    ${AccountId}
	Run Keyword And Continue On Failure    Remove AccountName    ${accessToken}    ${PartnerId}    ${AccountId}
	Run Keyword And Continue On Failure    Remove Partner    ${accessToken}    ${PartnerId}

	
	
Config Request RemoveData
    #accessToken,PartnerId,AccountId,ThingID,Type,SensorKey,ConfigGroupId
    [Arguments]    ${accessToken}    ${PartnerId}    ${AccountId}    ${ThingID}    ${Type}    ${SensorKey}    ${ConfigGroupId}
	${postRemoveConfigGroup}=    Remove ConfigGroup    ${URL}    ${accessToken}    ${AccountId}    ${ConfigGroupId}
	${postRemoveThingStateInfo}=    Remove ThingStateInfo    ${URL}    ${accessToken}    ${ThingID}    ${AccountId}    ${Type}    ${SensorKey}
	${postRemoveThing}=    Remove Thing    ${URL}    ${accessToken}    ${ThingID}    ${AccountId}
	${postRemoveAccount}=    Remove AccountName    ${URL}    ${accessToken}    ${PartnerId}    ${AccountId}
	${postRemovePartner}=    Remove Partner    ${URL}    ${accessToken}    ${PartnerId}

Not RemoveAccount Request Remove Data Sging
	#accessToken,PartnerId,AccountId,ThingID,Type,SensorKey
    [Arguments]    ${accessToken}    ${PartnerId}    ${AccountId}    ${ThingID}    ${Type}    ${SensorKey}
	#${postRemoveThingStateInfo}=    Remove ThingStateInfo    ${URL}    ${accessToken}    ${ThingID}    ${AccountId}    ${Type}    ${SensorKey}
	#${postRemoveThing}=    Remove Thing    ${URL}    ${accessToken}    ${ThingID}    ${AccountId}
	#${postRemoveAccount}=    Remove AccountName    ${URL}    ${accessToken}    ${PartnerId}    ${AccountId}
	${postRemovePartner}=    Remove Partner    ${URL}    ${accessToken}    ${PartnerId}

Not RemoveThingFromAccount Request RemoveData
	#accessToken,PartnerId,AccountId,ThingID,Type,SensorKey
    [Arguments]    ${accessToken}    ${PartnerId}    ${AccountId}    ${ThingID}    ${Type}    ${SensorKey}
	#${postRemoveThingStateInfo}=    Remove ThingStateInfo    ${URL}    ${accessToken}    ${ThingID}    ${AccountId}    ${Type}    ${SensorKey}
	#${postRemoveThing}=    Remove Thing    ${URL}    ${accessToken}    ${ThingID}    ${AccountId}
	${postRemoveAccount}=    Remove AccountName    ${URL}    ${accessToken}    ${PartnerId}    ${AccountId}
	${postRemovePartner}=    Remove Partner    ${URL}    ${accessToken}    ${PartnerId}
	
Not RemoveAccount Config Request RemoveData
    #accessToken,PartnerId,AccountId,ThingID,Type,SensorKey,ConfigGroupId
    [Arguments]    ${accessToken}    ${PartnerId}    ${AccountId}    ${ThingID}    ${Type}    ${SensorKey}    ${ConfigGroupId}
	${postRemoveConfigGroup}=    Remove ConfigGroup    ${URL}    ${accessToken}    ${AccountId}    ${ConfigGroupId}
	#${postRemoveThingStateInfo}=    Remove ThingStateInfo    ${URL}    ${accessToken}    ${ThingID}    ${AccountId}    ${Type}    ${SensorKey}
	#${postRemoveThing}=    Remove Thing    ${URL}    ${accessToken}    ${ThingID}    ${AccountId}
	#${postRemoveAccount}=    Remove AccountName    ${URL}    ${accessToken}    ${PartnerId}    ${AccountId}
	#${postRemovePartner}=    Remove Partner    ${URL}    ${accessToken}    ${PartnerId}

Not RemoveThingFromAccount Config Request RemoveData
    #accessToken,PartnerId,AccountId,ThingID,Type,SensorKey,ConfigGroupId
    [Arguments]    ${accessToken}    ${PartnerId}    ${AccountId}    ${ThingID}    ${Type}    ${SensorKey}    ${ConfigGroupId}
	${postRemoveConfigGroup}=    Remove ConfigGroup    ${URL}    ${accessToken}    ${AccountId}    ${ConfigGroupId}
	#${postRemoveThingStateInfo}=    Remove ThingStateInfo    ${URL}    ${accessToken}    ${ThingID}    ${AccountId}    ${Type}    ${SensorKey}
	#${postRemoveThing}=    Remove Thing    ${URL}    ${accessToken}    ${ThingID}    ${AccountId}
	${postRemoveAccount}=    Remove AccountName    ${URL}    ${accessToken}    ${PartnerId}    ${AccountId}
	${postRemovePartner}=    Remove Partner    ${URL}    ${accessToken}    ${PartnerId}

