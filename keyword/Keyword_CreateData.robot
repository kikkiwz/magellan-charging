*** Keywords ***
Signin
    [Arguments]    ${url}
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_SIGNIN}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_SIGNIN}    Accept=${HEADER_ACCEPT}  
    ${data}=    Evaluate    {"username": "${SIGNIN_USERNAME}","password": "${SIGNIN_PASSOWORD}"}   
	${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_SIGNIN}    ${headers}    ${data}
	Response ResultCode Should Have    ${res}    ${SINGNIN}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	#accessToken
	${accessToken}=    Get From Dictionary    ${res}     ${FIELD_ACCESSTOKEN}
	#Log To Console    ${accessToken}
	[return]    ${accessToken}

ValidateToken
    [Arguments]    ${url}    ${accessToken}
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_VALIDATETOKEN}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_VALIDATETOKEN}    Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
	
    ${data}=    Evaluate    {"AccessToken": "${accessToken}"}   
	${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_VALIDATETOKEN}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${VALIDATETOKEN}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
Create Partner
    [Arguments]    ${url}    ${accessToken}
    #Generate Random number
    ${random_number}=    generate random string    6    [NUMBERS]
	#PartnerName
	${PartnerName}=    Set Variable    ${VALUE_PARTNERNAME}${random_number}
	#MerchantContact
	${MerchantContact}=    Set Variable    ${VALUE_MERCHANTCONTACT}
	#CPID
	${CPID}=    Set Variable    ${VALUE_CPID}
	
	
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEPARTNER}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATEPARTNER}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
				
    ${data}=    Evaluate    {"PartnerName": "${PartnerName}","PartnerType": ["Supplier","Customer"],"PartnerDetail": {"MerchantContact": "${MerchantContact}","CPID": "${CPID}"},"Property": {"RouteEngine": "false"}}   
    #Log To Console    ${data}

    ${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATEPARTNER}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${CREATEPARTNER}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_PartnerId
    ${PartnerInfo}=    Get From Dictionary    ${res}     ${FIELD_PARTNERINFO}   
    #Log To Console    ${PartnerInfo}	
	${GetResponse_PartnerId}=    Get From Dictionary    ${PartnerInfo}     ${FIELD_PARTNERID}    
	#Log To Console    ${GetResponse_PartnerId}
    #AccountName
	${AccountName}=    Set Variable    ${VALUE_ACCOUNTNAME}${random_number}
    #Log To Console    ${AccountName} 
	#ConfigGroupName
	${ConfigGroupName}=    Set Variable    ${VALUE_CONFIGGROUPNAME}${random_number}
	#Log To Console    ${ConfigGroupName} 
	[return]    ${GetResponse_PartnerId}    ${AccountName}    ${ConfigGroupName}
	
Create AccountName
    [Arguments]    ${url}    ${accessToken}    ${PartnerId}    ${AccountName}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATEACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
				
    ${data}=    Evaluate    {"PartnerID": "${PartnerId}","AccountName": "${AccountName}"}   
    #Log To Console    ${data}

    ${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATEACCOUNT}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${CREATEACCOUNT}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_AccountName
    ${PartnerInfo}=    Get From Dictionary    ${res}     ${FIELD_PARTNERINFO}   
    #Log To Console    ${PartnerInfo}	
	${AccountInfo}=    Get From Dictionary    ${PartnerInfo}     ${FIELD_ACCOUNTINFO}  
	#Log To Console    ${AccountInfo}	
	${GetResponse_AccountName}=    Get From Dictionary    ${AccountInfo}[0]     ${FIELD_ACCOUNTNAME}    
	#Log To Console    ${GetResponse_AccountName}
	#GetResponse_AccountId
	${GetResponse_AccountId}=        Get From Dictionary    ${AccountInfo}[0]     ${FIELD_ACCOUNTID}    
    #Log To Console    ${GetResponse_AccountId} 
	
	[return]    ${GetResponse_AccountId}     ${GetResponse_AccountName}    

Create Thing
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${AccountName}    
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATETHING}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATETHING}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
		
    #random_IM
	${randomIM1}=    Evaluate    random.randint(10000000, 99999999)    random
	${randomIM2}=    Evaluate    random.randint(1000000, 9999999)    random
	${random_IM}=    Set Variable    ${randomIM1} ${randomIM2}
	#Log To Console    ${random_IM} 
	
	#random_ICCID
	${randomICCID1}=    Evaluate    random.randint(1000000, 9999999)    random
	${randomICCID2}=    Evaluate    random.randint(100000, 999999)    random
	${random_ICCID}=    Set Variable    ${randomICCID1} ${randomICCID2}
	#Log To Console    ${random_ICCID} 
	
	#ThingName
    ${random_number}=    generate random string    6    [NUMBERS]
	${ThingName}=    Set Variable    ${VALUE_THINGNAME}${random_number}
    #Log To Console    ${ThingName} 
	 
    ${data}=    Evaluate    {"ThingName": "${ThingName}","IMEI": "${random_IM}","IMSI": "${random_IM}","ICCID": "${random_ICCID}","RouteUrl": ["http://10.12.3.4:2019/api/information/AddInformation"],"RouteInfo": {"MIMO_ID": "606edada","MIMO_SerialNo": 5466758878},"RouteFlag": {"ThingName": "true","ThingToken": "true","IMEI": "true","ICCID": "true","RouteInfo": "true"}}   
    #Log To Console    ${data}

    ${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATETHING}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${CREATETHING}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_ThingID
    ${ThingInfo}=    Get From Dictionary    ${res}     ${FIELD_THINGINFO}   
    #Log To Console    ${ThingInfo}	
	${GetResponse_ThingID}=    Get From Dictionary    ${ThingInfo}     ${FIELD_THINGID}    
	#Log To Console    ${GetResponse_ThingID}
	${GetResponse_IMSI}=    Get From Dictionary    ${ThingInfo}     ${FIELD_IMSI}    
	#Log To Console    ${GetResponse_IMSI}
	${GetResponse_ThingToken}=    Get From Dictionary    ${ThingInfo}     ${FIELD_THINGTOKEN}  
	#Log To Console    ${GetResponse_ThingToken}
	
	[return]    ${GetResponse_ThingID}    ${GetResponse_IMSI}    ${GetResponse_ThingToken}
	
Create ThingStateInfo
    [Arguments]    ${url}    ${accessToken}    ${ThingId}    ${AccountId}    ${SensorKey}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATETHINGSTATEINFO}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATETHINGSTATEINFO}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
		
    #random_Sensor
	${random_Sensor}=    Evaluate    random.randint(100, 999)    random
	#${random_Sensor}=    Set Variable    ${randomSensor1}
	#Log To Console    ${random_Sensor} 
	 
    ${data}=    Evaluate    {"ThingId": ["${ThingId}"],"Type": "${VALUE_TYPE}", "Sensor": {"${SensorKey}": "${random_Sensor}"}}   
    #Log To Console    ${data}

    ${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATETHINGSTATEINFO}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${CREATETHINGSTATEINFO}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	[return]    ${VALUE_TYPE}    ${SensorKey}    ${random_Sensor}  

Create ControlThing
    [Arguments]    ${url}    ${accessToken}    ${ThingId}    ${AccountId}    ${SensorKey}    ${random_Sensor}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATECONTROLTHING}${current_timestamp}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}
	#Log To Console    ${headers}
	#{"${VALUE_SENSORKEY}": "${random_Sensor_App}"}  
	#random_Sensor_Report
	${random_Sensor_App}=    Evaluate    random.randint(100, 999)    random
	#Set Global Variable    ${randomSensorApp}    ${random_Sensor_App}
			 
    ${data}=    Evaluate    {"ThingId": "${ThingId}", "Sensors": {"${SensorKey}": "${random_Sensor_App}"}}   
    #Log To Console    ${data}

    ${res}=    Post Api Request    ${url}${CONTROLAPIS}    ${URL_CREATECONTROLTHING}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${CREATECONTROLTHING}    ${FIELD_OPERATIONSTATUS_LOWCASE}    ${FIELD_CODE_LOWCASE}    ${FIELD_DESCRIPTION_LOWCASE}
		
	[return]    ${random_Sensor_App}  
	
Create ConfigGroup
    [Arguments]    ${url}    ${accessToken}    ${ThingId}    ${AccountId}    ${ConfigGroupName}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATECONFIGGROUP}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATECONFIGGROUP}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
	#"ConfigInfo": {"RefreshTime": "On","Max": "99"}	 
    ${data}=    Evaluate    {"ConfigName": "${ConfigGroupName}","ThingId": ["${ThingId}"], "ConfigInfo": {"${VALUE_CONFIGINFO_KEY_REFRESHTIME}": "${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}","${VALUE_CONFIGINFO_KEY_MAX}": "${VALUE_CONFIGINFO_KEY_MAX_VALUE}"}}   
    #Log To Console    ${data}

    ${res}=    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATECONFIGGROUP}    ${headers}    ${data}
	#Log To Console    ${res}
	Response ResultCode Should Have    ${res}    ${CREATECONFIGGROUP}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_ConfigGroupInfo
    ${ConfigGroupInfo}=    Get From Dictionary    ${res}     ${FIELD_CONFIGGROUPINFO}   
    #Log To Console    ${ConfigGroupInfo}	
	${GetResponse_ConfigGroupId}=    Get From Dictionary    ${ConfigGroupInfo}     ${FIELD_CONFIGGROUPID}    
    #Log To Console    GetResponse_ConfigGroupId${GetResponse_ConfigGroupId}	
	[return]    ${GetResponse_ConfigGroupId}
	
Request CreateData for get IMSI Staging
    #signin return accessToken
    ${accessToken}=    Signin    ${URL_STAGING}
	${postCreatePartner}=    Create Partner    ${URL_STAGING}    ${accessToken}
	${postCreateAccount}=    Create AccountName    ${URL_STAGING}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1] 
	${postCreateThing}=    Create Thing    ${URL_STAGING}    ${accessToken}    ${postCreateAccount}[0]    ${postCreateAccount}[1] 
	${postCreateThingStateInfo}=    Create ThingStateInfo    ${URL_STAGING}    ${accessToken}    ${postCreateThing}[0]    ${postCreateAccount}[0]    ${VALUE_SENSORKEY} 
	
	#accessToken,PartnerId,AccountId,ThingID,IMSI,ThingToken,Type,SensorKey,random_Sensor,AccountName
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateThing}[0]    ${postCreateThing}[1]    ${postCreateThing}[2]    ${postCreateThingStateInfo}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2]    ${postCreateAccount}[1]
	
Register Request CreateData for get IMSI Staging
    #signin return accessToken
    ${accessToken}=    Signin    ${URL_STAGING}
	${postCreatePartner}=    Create Partner    ${URL_STAGING}    ${accessToken}
	${postCreateAccount}=    Create AccountName    ${URL_STAGING}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1] 
	${postCreateThing}=    Create Thing    ${URL_STAGING}    ${accessToken}    ${postCreateAccount}[0]    ${postCreateAccount}[1] 
	${postCreateThingStateInfo}=    Create ThingStateInfo    ${URL_STAGING}    ${accessToken}    ${postCreateThing}[0]    ${postCreateAccount}[0]    ${VALUE_SENSORKEY} 
	${postCreateControlThing}=    Create ControlThing    ${URL_STAGING}    ${accessToken}    ${postCreateThing}[0]    ${postCreateAccount}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2] 
	#Log To Console
	#accessToken,PartnerId,AccountId,ThingID,IMSI,ThingToken,Type,SensorKey,random_Sensor,AccountName,random_Sensor_App
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateThing}[0]    ${postCreateThing}[1]    ${postCreateThing}[2]    ${postCreateThingStateInfo}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2]    ${postCreateAccount}[1]    ${postCreateControlThing}

Config Request CreateData for get IMSI Staging
    #signin return accessToken
    ${accessToken}=    Signin    ${URL_STAGING}
	${postCreatePartner}=    Create Partner    ${URL_STAGING}    ${accessToken}
	${postCreateAccount}=    Create AccountName    ${URL_STAGING}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1] 
	${postCreateThing}=    Create Thing    ${URL_STAGING}    ${accessToken}    ${postCreateAccount}[0]    ${postCreateAccount}[1] 
	${postCreateThingStateInfo}=    Create ThingStateInfo    ${URL_STAGING}    ${accessToken}    ${postCreateThing}[0]    ${postCreateAccount}[0]    ${VALUE_SENSORKEY} 
	${postCreateConfigGroup}=    Create ConfigGroup    ${URL_STAGING}    ${accessToken}    ${postCreateThing}[0]    ${postCreateAccount}[0]    ${postCreatePartner}[2] 
	
	#accessToken,PartnerId,AccountId,ThingID,IMSI,ThingToken,Type,SensorKey,random_Sensor,ConfigGroupId,AccountName
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateThing}[0]    ${postCreateThing}[1]    ${postCreateThing}[2]    ${postCreateThingStateInfo}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2]    ${postCreateConfigGroup}    ${postCreateAccount}[1]
	
Charging Request CreateData for get IMSI Staging Report
    #signin return accessToken
    ${accessToken}=    Signin    ${URL_STAGING}
	${postValidateToken}=    ValidateToken    ${URL_STAGING}    ${accessToken}
	${postInquiryAccount}=    Inquiry Account    ${URL_STAGING}    ${accessToken}
	${postCreateThing}=    Create Thing    ${URL_STAGING}    ${accessToken}    ${postInquiryAccount}[0]    ${postInquiryAccount}[1] 
	${postCreateThingStateInfo}=    Create ThingStateInfo    ${URL_STAGING}    ${accessToken}    ${postCreateThing}[0]    ${postInquiryAccount}[0]    ${VALUE_SENSORKEY_CHARGING} 
	
	#accessToken,AccountId,ThingID,IMSI,ThingToken,Type,SensorKey,random_Sensor,AccountName
    [return]    ${accessToken}    ${postInquiryAccount}[0]    ${postCreateThing}[0]    ${postCreateThing}[1]    ${postCreateThing}[2]    ${postCreateThingStateInfo}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2]    ${postInquiryAccount}[1]
	