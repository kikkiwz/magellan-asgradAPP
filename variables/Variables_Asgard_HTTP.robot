*** Variables ***
#------ Asgard HTTP

#endPointSummary of log summar
${ENDPOINT_SUMMARY_REGISTER}    { "endPointSummary":[{"no":"1","endPointName":"db.ThingsCollection","endPointURL":null,"responseStatus":"20000:Inquiry was Success","processTime":null},{"no":"2","endPointName":"db.AccountsCollection","endPointURL":null,"responseStatus":"20000:Inquiry was Success","processTime":null},{"no":"3","endPointName":"db.ThingsCollection","endPointURL":null,"responseStatus":"20000:UpdateThing was Success","processTime":null}]}
${ENDPOINT_SUMMARY_REPORT}    { "endPointSummary":[{"no": "1", "endPointName": "db.ThingsCollection", "endPointURL": null, "responseStatus": "20000:Inquiry was Success", "processTime": null}, {"no": "2", "endPointName": "db.AccountsCollection", "endPointURL": null, "responseStatus": "20000:Inquiry was Success", "processTime": null}, {"no": "3", "endPointName": "db.CustomersCollection", "endPointURL": null, "responseStatus": "20000:Inquiry was Success", "processTime": null}]}
${ENDPOINT_SUMMARY_CONFIG}    { "endPointSummary":[{"no":"1","endPointName":"db.ThingsCollection","endPointURL":null,"responseStatus":"20000:Inquiry was Success","processTime":null},{"no":"2","endPointName":"db.AccountsCollection","endPointURL":null,"responseStatus":"20000:Inquiry was Success","processTime":null},{"no":"3","endPointName":"db.OnlineConfigsCollection","endPointURL":null,"responseStatus":"20000:Inquiry was Success","processTime":null}]}
${ENDPOINT_SUMMARY_DELTA}    { "endPointSummary":[{"no":"1","endPointName":"db.ThingsCollection","endPointURL":null,"responseStatus":"20000:Inquiry was Success","processTime":null},{"no":"2","endPointName":"db.AccountsCollection","endPointURL":null,"responseStatus":"20000:Inquiry was Success","processTime":null},{"no":"3","endPointName":"db.ThingsCollection","endPointURL":null,"responseStatus":"20000:Inquiry was Success","processTime":null}]}
${ENDPOINT_SUMMARY_Charging}    {"endPointSummary": [{"no": "1", "endPointName": "rOCS", "endPointURL": "api/v3/rocs/metering-method", "responseStatus": "20000:CallMertering was The requested operation was successfully.", "processTime": null}]}

#field name endPoint NameDB
${ENDPOINTNAME_CUSTOMER}    db.CustomersCollection 
${ENDPOINTNAME_ACCOUNT}    db.AccountsCollection
${ENDPOINTNAME_THINGS}    db.ThingsCollection
${ENDPOINTNAME_ONLINECONFIG}    db.OnlineConfigsCollection

#request and response
${REQUESTOBJECT_DETAIL_LOG_DB_INQUIRY}=    {}    
${RESPONSEOBJECT_DETAIL_LOG_DB_SUCCESS}=    {"StatusCode":20000,"Description":"Success"} 



