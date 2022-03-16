*** Keywords ***
Update Account
    [Arguments]    ${url}    ${accessToken}    ${PartnerId}    ${AccountId}    ${AccountName}    ${ExpireDate}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVEACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVEACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  
	Log To Console    headers${headers}
				
    ${data}=    Evaluate    {"PartnerID": "${PartnerId}","AccountId": "${AccountId}","AccountName": "${AccountName}","ExpireDate": "${ExpireDate}","ClearExpireDate": "false"}   
    Log To Console    data${data}

    ${res}=    Put Api Request    ${url}${PROVISIONINGAPIS}    ${URL_UPDATEACCOUNT}    ${headers}    ${data}
	Log To Console    res${res}
	Response ResultCode Should Have    ${res}    ${UPDATEACCOUNT}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	