*** Variables ***
#-------------------------------------------- InquiryThing --------------------------------------------#	

#path url InquiryThing
${URL_INQUIRYTHING}    /api/v1/Thing/InquiryThing

#header InquiryThing
${HEADER_X_AIS_ORDERREF_INQUIRYTHING}    InquiryThing_
${HEADER_X_AIS_ORDERDESC_INQUIRYTHING}    InquiryThing

#request name
${INQUIRYTHING}    InquiryThing

#response description
${VALUE_DESCRIPTION_INQUIRYTHING_SUCCESS}    InquiryThing is Success

#-------------------------------------------- InquiryConfigGroup --------------------------------------------#	

#path url InquiryConfigGroup
${URL_INQUIRYCONFIGGROUP}    /api/v1/ConfigGroup/InquiryConfigGroup

#header InquiryConfigGroup
${HEADER_X_AIS_ORDERREF_INQUIRYCONFIGGROUP}    InquiryConfigGroup_
${HEADER_X_AIS_ORDERDESC_INQUIRYCONFIGGROUP}    InquiryConfigGroup

#request name
${INQUIRYCONFIGGROUP}    InquiryConfigGroup

#response description
${VALUE_DESCRIPTION_INQUIRYCONFIGGROUP_SUCCESS}    InquiryConfigGroup is Success

#-------------------------------------------- InquiryAccount --------------------------------------------#	

#path url InquiryAccount
${URL_INQUIRYACCOUNT}    /api/v1/Account/InquiryAccount

#header InquiryAccount
${HEADER_X_AIS_ORDERREF_INQUIRYACCOUNT}    InquiryAccount_
${HEADER_X_AIS_ORDERDESC_INQUIRYACCOUNT}    InquiryAccount

#request name
#เบอร์ IOT and STG
#9400631802
#9400631821
#9400631721
#9400631722
#9400631661
#9400631662
#9400631663
${MobileNo}    9400631821
${MobileNo_Terminate}    9400631721
${INQUIRYACCOUNT}    InquiryAccount
#response description
${VALUE_DESCRIPTION_INQUIRYACCOUNT_SUCCESS}    InquiryAccount is Success