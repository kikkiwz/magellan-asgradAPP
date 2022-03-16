*** Keywords ***
ConnectMongodb
    ${username}=    Set Variable    admin
    ${pass}=    Set Variable    ais.co.th
    ${ip}=    Set Variable    52.163.210.190:27018
    ${authSource}=    Set Variable    admin
    ${db}=    Set Variable    mongodb://${username}:${pass}@${ip}/mgcore?authSource=${authSource}
    Connect To Mongodb    ${db}    

Search Some Record
    [Arguments]    ${dbName}    ${dbCollName}    ${json_data}
    Log    ${json_data}  
    ${result}=    Retrieve Some Mongodb Records    dbName=${dbName}    dbCollName=${dbCollName}    recordJSON=${json_data}    returnDocuments=True
    Log    ${result}
    #ได้ record เดียวเสมอ, convert dict กลับไปถ้าจะดึงค่าให้ใช้  ${result}=    Get From Dictionary    ${dict}    ชื่อฟิลด์ 
    ${dict}=    Convert To Dictionary    ${result}[0]
    [Return]    ${dict} 

Search By Select Fields
    [Arguments]    ${dbName}    ${dbCollName}    ${json_data}    ${value_fields}
    Log    ${json_data}  
    ${result}=    Retrieve Mongodb Records With Desired Fields    dbName=${dbName}    dbCollName=${dbCollName}    recordJSON=${json_data}    fields=${value_fields}    return__id=False    returnDocuments=True    
    Log    ${result}
	${dict}=    Convert To Dictionary    ${result}[0]
    [Return]    ${dict} 

SearchCountShopByUsername
    ${date}=    Get Date
    Log    { "$and": [ { "username": { "$eq": "${username}" } }, { "date": { "$eq": "${date}" } } ] } 
    ${search_shop}=    Retrieve Mongodb Records With Desired Fields    dbName=${dbName}    dbCollName=${dbcol_insert}    recordJSON={ "$and": [ { "username": { "$eq": "${username}" } }, { "date": { "$eq": "${date}" } } ] }    fields=shopName    return__id=False    returnDocuments=Ture
    ${length}=    Get Length    ${search_shop}
    [Return]    ${length}

InSertShop
    [Arguments]    ${shop_nanme}    ${shop_type}    ${shop_category_final}    ${msg}
    ${date}=    Get Date
    Save Mongodb Records     omni-automate    ${dbcol_insert}    {"shopName" : "${shop_nanme}","shopCategory" : "${shop_category_final}","shopType" : "${shop_type}","date" : "${date}","username" : "${username}","msg" : "${msg}"}
    Log To Console    Insert Success : ${shop_nanme},${shop_type},${shop_category_final},${date},${username}
