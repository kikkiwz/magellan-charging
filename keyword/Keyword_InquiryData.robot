*** Keywords ***
Inquiry Thing
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${ThingID}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_INQUIRYTHING}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_INQUIRYTHING}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}    Accept=${HEADER_ACCEPT} 
	#Log To Console    headers${headers}
				
    ${data}=    Evaluate    {"ThingId": "${ThingID}"}   
    #Log To Console    data${data}

    ${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_INQUIRYTHING}    ${headers}    ${data}
	#Log To Console    res${res}
	Response ResultCode Should Have    ${res}    ${INQUIRYTHING}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	[return]    ${res}

Inquiry ConfigGroup
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${ThingID}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_INQUIRYCONFIGGROUP}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_INQUIRYCONFIGGROUP}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}     Accept=${HEADER_ACCEPT} 
	#Log To Console    headers${headers}
				
    ${data}=    Evaluate    {"ThingId": "${ThingID}"}   
    #Log To Console    data${data}

    ${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_INQUIRYCONFIGGROUP}    ${headers}    ${data}
	#Log To Console    res${res}
	Response ResultCode Should Have    ${res}    ${INQUIRYCONFIGGROUP}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	[return]    ${res}
	
Inquiry Account
    [Arguments]    ${url}    ${accessToken}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_INQUIRYACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_INQUIRYACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}     Accept=${HEADER_ACCEPT} 
	#Log To Console    headers${headers}
				
    ${data}=    Evaluate    {"AccountName": "${INQUIRYACCOUNT_ACCOUNTNAME}"}   
    #Log To Console    data${data}

    ${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_INQUIRYACCOUNT}    ${headers}    ${data}
	#Log To Console    res${res}
	Response ResultCode Should Have    ${res}    ${INQUIRYACCOUNT}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_AccountName
    ${PartnerInfo}=    Get From Dictionary    ${res}     ${FIELD_PARTNERINFO}   
    #Log To Console    ${PartnerInfo}	
	${AccountInfo}=    Get From Dictionary    ${PartnerInfo}[0]     ${FIELD_ACCOUNTINFO}  
	#Log To Console    ${AccountInfo}	
	${GetResponse_AccountName}=    Get From Dictionary    ${AccountInfo}[0]     ${FIELD_ACCOUNTNAME}    
	#Log To Console    ${GetResponse_AccountName}
	#GetResponse_AccountId
	${GetResponse_AccountId}=        Get From Dictionary    ${AccountInfo}[0]     ${FIELD_ACCOUNTID}    
    #Log To Console    ${GetResponse_AccountId} 
	
	[return]    ${GetResponse_AccountId}     ${GetResponse_AccountName}    
