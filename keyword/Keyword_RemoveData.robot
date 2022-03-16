*** Keywords ***
Remove Partner
    [Arguments]    ${url}    ${accessToken}    ${PartnerId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVEPARTNER}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVEPARTNER}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
				
    ${data}=    Evaluate    {"PartnerId": "${PartnerId}"}   
    #Log To Console    ${data}

    ${res}=    Delete Api Request    ${url}${PROVISIONINGAPIS}    ${URL_REMOVEPARTNER}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${REMOVEPARTNER}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
Remove AccountName
    [Arguments]    ${url}    ${accessToken}    ${PartnerId}    ${AccountId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVEACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVEACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
				
    ${data}=    Evaluate    {"PartnerID": "${PartnerId}","AccountId": "${AccountId}"}   
    #Log To Console    ${data}

    ${res}=    Delete Api Request    ${url}${PROVISIONINGAPIS}    ${URL_REMOVEACCOUNT}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${REMOVEACCOUNT}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}

Remove Thing
    [Arguments]    ${url}    ${accessToken}    ${ThingID}    ${AccountId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVETHING}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVETHING}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
		
    ${data}=    Evaluate    {"ThingId": "${ThingID}"}   
    #Log To Console    ${data}

    ${res}=    Delete Api Request    ${url}${PROVISIONINGAPIS}    ${URL_REMOVETHING}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${REMOVETHING}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}

Remove ThingStateInfo
    [Arguments]    ${url}    ${accessToken}    ${ThingId}    ${AccountId}    ${Type}    ${SensorKey}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVETHINGSTATEINFO}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVETHINGSTATEINFO}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}

    ${data}=    Evaluate    {"ThingId": "${ThingId}","stateType": "${Type}", "stateKey": "${SensorKey}"}   
    #Log To Console    ${data}

    ${res}=    Delete Api Request    ${url}${PROVISIONINGAPIS}    ${URL_REMOVETHINGSTATEINFO}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${REMOVETHINGSTATEINFO}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}


Remove ThingFromAccount
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${ThingId}    
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVETHINGFROMACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVETHINGFROMACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}

    ${data}=    Evaluate    {"ThingId": ["${ThingID}"]}   
    #Log To Console    ${data}

    ${res}=    Delete Api Request    ${url}${PROVISIONINGAPIS}    ${URL_REMOVETHINGFROMACCOUNT}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${REMOVETHINGFROMACCOUNT}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
Remove ConfigGroup
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${ConfigGroupId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVECONFIGGROUP}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVECONFIGGROUP}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}

    ${data}=    Evaluate    {"ConfigGroupId": "${ConfigGroupId}"}   
    #Log To Console    ${data}

    ${res}=    Delete Api Request    ${url}${PROVISIONINGAPIS}    ${URL_REMOVECONFIGGROUP}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${REMOVECONFIGGROUP}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
		
		
Request Remove Data Staging
	#accessToken,PartnerId,AccountId,ThingID,Type,SensorKey
    [Arguments]    ${accessToken}    ${PartnerId}    ${AccountId}    ${ThingID}    ${Type}    ${SensorKey}
	${postRemoveThingStateInfo}=    Remove ThingStateInfo    ${URL_STAGING}    ${accessToken}    ${ThingID}    ${AccountId}    ${Type}    ${SensorKey}
	${postRemoveThing}=    Remove Thing    ${URL_STAGING}    ${accessToken}    ${ThingID}    ${AccountId}
	${postRemoveAccount}=    Remove AccountName    ${URL_STAGING}    ${accessToken}    ${PartnerId}    ${AccountId}
	${postRemovePartner}=    Remove Partner    ${URL_STAGING}    ${accessToken}    ${PartnerId}
	
Config Request RemoveData Staging
    #accessToken,PartnerId,AccountId,ThingID,Type,SensorKey,ConfigGroupId
    [Arguments]    ${accessToken}    ${PartnerId}    ${AccountId}    ${ThingID}    ${Type}    ${SensorKey}    ${ConfigGroupId}
	${postRemoveConfigGroup}=    Remove ConfigGroup    ${URL_STAGING}    ${accessToken}    ${AccountId}    ${ConfigGroupId}
	${postRemoveThingStateInfo}=    Remove ThingStateInfo    ${URL_STAGING}    ${accessToken}    ${ThingID}    ${AccountId}    ${Type}    ${SensorKey}
	${postRemoveThing}=    Remove Thing    ${URL_STAGING}    ${accessToken}    ${ThingID}    ${AccountId}
	${postRemoveAccount}=    Remove AccountName    ${URL_STAGING}    ${accessToken}    ${PartnerId}    ${AccountId}
	${postRemovePartner}=    Remove Partner    ${URL_STAGING}    ${accessToken}    ${PartnerId}

Not RemoveAccount Request Remove Data Staging
	#accessToken,PartnerId,AccountId,ThingID,Type,SensorKey
    [Arguments]    ${accessToken}    ${PartnerId}    ${AccountId}    ${ThingID}    ${Type}    ${SensorKey}
	#${postRemoveThingStateInfo}=    Remove ThingStateInfo    ${URL_STAGING}    ${accessToken}    ${ThingID}    ${AccountId}    ${Type}    ${SensorKey}
	#${postRemoveThing}=    Remove Thing    ${URL_STAGING}    ${accessToken}    ${ThingID}    ${AccountId}
	#${postRemoveAccount}=    Remove AccountName    ${URL_STAGING}    ${accessToken}    ${PartnerId}    ${AccountId}
	${postRemovePartner}=    Remove Partner    ${URL_STAGING}    ${accessToken}    ${PartnerId}

Not RemoveThingFromAccount Request RemoveData Staging
	#accessToken,PartnerId,AccountId,ThingID,Type,SensorKey
    [Arguments]    ${accessToken}    ${PartnerId}    ${AccountId}    ${ThingID}    ${Type}    ${SensorKey}
	#${postRemoveThingStateInfo}=    Remove ThingStateInfo    ${URL_STAGING}    ${accessToken}    ${ThingID}    ${AccountId}    ${Type}    ${SensorKey}
	#${postRemoveThing}=    Remove Thing    ${URL_STAGING}    ${accessToken}    ${ThingID}    ${AccountId}
	${postRemoveAccount}=    Remove AccountName    ${URL_STAGING}    ${accessToken}    ${PartnerId}    ${AccountId}
	${postRemovePartner}=    Remove Partner    ${URL_STAGING}    ${accessToken}    ${PartnerId}
	
Not RemoveAccount Config Request RemoveData Staging
    #accessToken,PartnerId,AccountId,ThingID,Type,SensorKey,ConfigGroupId
    [Arguments]    ${accessToken}    ${PartnerId}    ${AccountId}    ${ThingID}    ${Type}    ${SensorKey}    ${ConfigGroupId}
	${postRemoveConfigGroup}=    Remove ConfigGroup    ${URL_STAGING}    ${accessToken}    ${AccountId}    ${ConfigGroupId}
	#${postRemoveThingStateInfo}=    Remove ThingStateInfo    ${URL_STAGING}    ${accessToken}    ${ThingID}    ${AccountId}    ${Type}    ${SensorKey}
	#${postRemoveThing}=    Remove Thing    ${URL_STAGING}    ${accessToken}    ${ThingID}    ${AccountId}
	#${postRemoveAccount}=    Remove AccountName    ${URL_STAGING}    ${accessToken}    ${PartnerId}    ${AccountId}
	#${postRemovePartner}=    Remove Partner    ${URL_STAGING}    ${accessToken}    ${PartnerId}

Not RemoveThingFromAccount Config Request RemoveData Staging
    #accessToken,PartnerId,AccountId,ThingID,Type,SensorKey,ConfigGroupId
    [Arguments]    ${accessToken}    ${PartnerId}    ${AccountId}    ${ThingID}    ${Type}    ${SensorKey}    ${ConfigGroupId}
	${postRemoveConfigGroup}=    Remove ConfigGroup    ${URL_STAGING}    ${accessToken}    ${AccountId}    ${ConfigGroupId}
	#${postRemoveThingStateInfo}=    Remove ThingStateInfo    ${URL_STAGING}    ${accessToken}    ${ThingID}    ${AccountId}    ${Type}    ${SensorKey}
	#${postRemoveThing}=    Remove Thing    ${URL_STAGING}    ${accessToken}    ${ThingID}    ${AccountId}
	${postRemoveAccount}=    Remove AccountName    ${URL_STAGING}    ${accessToken}    ${PartnerId}    ${AccountId}
	${postRemovePartner}=    Remove Partner    ${URL_STAGING}    ${accessToken}    ${PartnerId}

