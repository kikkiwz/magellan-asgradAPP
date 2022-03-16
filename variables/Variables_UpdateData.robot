*** Variables ***
#path url update
${URL_UPDATEACCOUNT}    /api/v1/Account/UpdateAccount

#header UpdateAccount
${HEADER_X_AIS_ORDERREF_UPDATEACCOUNT}    UpdateAccount_
${HEADER_X_AIS_ORDERDESC_UPDATEACCOUNT}    UpdateAccount

#request name
${UPDATEACCOUNT}    UpdateAccount

#response description
${VALUE_DESCRIPTION_UPDATEACCOUNT_SUCCESS}    UpdateAccount is Success
