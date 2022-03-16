*** Variables ***
#-------------------------------------------- RemovePartner --------------------------------------------#	
#path url remove
${URL_REMOVEPARTNER}    /api/v1/Partner/RemovePartner

#header RemovePartner
${HEADER_X_AIS_ORDERREF_REMOVEPARTNER}    RemovePartner_
${HEADER_X_AIS_ORDERDESC_REMOVEPARTNER}    RemovePartner

#request name
${REMOVEPARTNER}    RemovePartner

#response description
${VALUE_DESCRIPTION_REMOVEPARTNER_SUCCESS}    RemovePartner is Success
#-------------------------------------------- RemoveAccount --------------------------------------------#	
#path url remove
${URL_REMOVEACCOUNT}    /api/v1/Account/RemoveAccount

#header RemoveAccount
${HEADER_X_AIS_ORDERREF_REMOVEACCOUNT}    RemoveAccount_
${HEADER_X_AIS_ORDERDESC_REMOVEACCOUNT}    RemoveAccount

#request name
${REMOVEACCOUNT}    RemoveAccount

#response description
${VALUE_DESCRIPTION_REMOVEACCOUNT_SUCCESS}    RemoveAccount is Success
#-------------------------------------------- RemoveThing --------------------------------------------#	
#path url remove
${URL_REMOVETHING}    /api/v1/Thing/RemoveThing

#header RemoveThing
${HEADER_X_AIS_ORDERREF_REMOVETHING}    RemoveThing_
${HEADER_X_AIS_ORDERDESC_REMOVETHING}    RemoveThing

#request name
${REMOVETHING}    RemoveThing

#response description
${VALUE_DESCRIPTION_REMOVETHING_SUCCESS}    RemoveThing is Success
#-------------------------------------------- RemoveThingStateInfo --------------------------------------------#	
#path url remove
${URL_REMOVETHINGSTATEINFO}    /api/v1/Thing/RemoveThingStateInfo

#header RemoveThingStateInfo
${HEADER_X_AIS_ORDERREF_REMOVETHINGSTATEINFO}    RemoveThingStateInfo_
${HEADER_X_AIS_ORDERDESC_REMOVETHINGSTATEINFO}    RemoveThingStateInfo

#value
${VALUE_STATETYPE}    Report 
${VALUE_STATEKEY}    Temp 
#${VALUE_STATEKEY}    AA 

#request name
${REMOVETHINGSTATEINFO}    RemoveThingStateInfo

#response description
${VALUE_DESCRIPTION_REMOVETHINGSTATEINFO_SUCCESS}    RemoveThingStateInfo is Success
#-------------------------------------------- RemoveThingFromAccount --------------------------------------------#	
#path url remove
${URL_REMOVETHINGFROMACCOUNT}    /api/v1/Thing/RemoveThingFromAccount

#header RemoveThingFromAccount
${HEADER_X_AIS_ORDERREF_REMOVETHINGFROMACCOUNT}    RemoveThingFromAccount_
${HEADER_X_AIS_ORDERDESC_REMOVETHINGFROMACCOUNT}    RemoveThingFromAccount

#request name
${REMOVETHINGFROMACCOUNT}    RemoveThingFromAccount

#response description
${VALUE_DESCRIPTION_REMOVETHINGFROMACCOUNT_SUCCESS}    RemoveThingFromAccount is Success
#-------------------------------------------- RemoveConfigGroup --------------------------------------------#	
#path url remove
${URL_REMOVECONFIGGROUP}    /api/v1/ConfigGroup/RemoveConfigGroup
	
#header RemoveConfigGroup
${HEADER_X_AIS_ORDERREF_REMOVECONFIGGROUP}    RemoveConfigGroup_
${HEADER_X_AIS_ORDERDESC_REMOVECONFIGGROUP}    RemoveConfigGroup

#request name
${REMOVECONFIGGROUP}    RemoveConfigGroup

#response description
${VALUE_DESCRIPTION_REMOVECONFIGGROUP_SUCCESS}    RemoveConfigGroup is Success

#-------------------------------------------- Other --------------------------------------------#
#Other field
${FIELD_OPERATIONSTATUS}    OperationStatus
${FIELD_CODE}    Code
${FIELD_DESCRIPTION}    Description
${FIELD_ACCESSTOKEN}    AccessToken    
${FIELD_PARTNERINFO}    PartnerInfo  
${FIELD_PARTNERID}    PartnerId  
${FIELD_ACCOUNTINFO}    AccountInfo  
${FIELD_ACCOUNTNAME}    AccountName  
${FIELD_ACCOUNTID}    AccountId  
${FIELD_THINGINFO}    ThingInfo  
${FIELD_THINGID}    ThingId 
${FIELD_IMSI}    IMSI   
