*** Settings ***
#Documentation     TST_F3_1_1_002
Test Setup    Add Needed Image Path

Resource    ../../../../variables/Variables.robot    
Resource    ../../../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
Create Data get IMSI
    #set variable ${IMAGE_DIR} for set folder img
	${path}=    Normalize path    ${CURDIR}${IMAGE_PATH_ASGARD_COAPAPP}
	Set Global Variable    ${IMAGE_DIR}    ${path}
	
    #getDataRequest position data=[accessToken,PartnerId,AccountId,ThingID,IMSI,ThingToken,Type,SensorKey,random_Sensor,AccountName,random_Sensor_App]
    ${getDataRequest}=    Register Request CreateData for get IMSI Staging
	#set data use cross testcase
	Set Global Variable    ${getData}    ${getDataRequest}
	
	#set IMSI
	${setIMSI}=    Set Variable    ${getData}[4]
	Set Global Variable    ${IMSI}    ${setIMSI}
	
	#{"${VALUE_SENSORKEY}": "${random_Sensor_App}"}  
	${setValueKey}=    Set Variable    {"${getData}[7]":"${getData}[10]"}
	#set data use cross testcase
	Set Global Variable    ${valueKey}    ${setValueKey}
	
Register : Device in all parameter success [20000]
	#Replace Parameters Url IMSI or Token and IP 
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL_STAGING}    ${ASGARD_COAPAPP_URL_REGISTER}    ${ASGARD_COAPAPP_FIELD_IMSI}    ${IMSI}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	#Log To Console    url${url}
	
	Open Program    ${ASGARD_COAPAP_IMAGE_THING_SIMULATOR}    ${ASGARD_COAPAP_IMAGE_MAGELLANCLIENT_HEADER}	
	#Select Dropdrown ENV 
	Select Dropdrown ENV    ${ASGARD_COAPAP_IMAGE_DDL_ENV_STAGING_CAULDRONAZUE}
	#Url
	Input Url    ${ASGARD_COAPAP_IMAGE_TXT_URL}    ${url}    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}
	#Payload
	Clear Input    ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD}
	
	#Click Send button
	Click    ${ASGARD_COAPAP_IMAGE_BTN_SEND}
	#Check Success popup
	Check Matched    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}
    #Click OK button
	Click    ${ASGARD_COAPAP_IMAGE_BTN_OK}
	
	Capture Screen   

Register : Check Detail log [EDR] and Summary Log [CDR]
    #Log To Console    IMSI${IMSI}
	#/register/sim/v1/IMSI/IPAddress
	${pathUrl}=    Replace Parameters Path    ${ASGARD_COAPAPP_URL_REGISTER}    ${ASGARD_COAPAPP_FIELD_IMSI}    ${IMSI}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	${payload}=    Set Variable    null
	
	#resultCode_summary[20000],resultDesc_summary[OK],Code_detail[20000],Description_detail[The requested operation was successfully.],applicationName[Asgard.Coap.APP],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Register],imsi,ipAddress,payload[null],namespace[Magellan],containerId[coapapp-vXX ],identity[null],cmdName[Register],endPointName[CoapApiService],logLevel[INFO],custom,SensorKey
    Check Log Response    ${VALUE_LOG_CODE_20000}    ${VALUE_LOG_SUMMARY_RESULTDESC_OK}    ${VALUE_LOG_CODE_20000}    ${VALUE_LOG_SUMMARY_RESULTDESC_20000_REQUESTED_OPERATION_SUCCESSFULLY}    ${VALUE_APPLICATIONNAME_COAPAPP}    ${pathUrl}    ${ASGARD_COAPAPP_URL_COAPAPISERVICE_REGISTER}    ${IMSI}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${payload}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPP}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}    ${DETAIL_ENDPOINTNAME_COAPAPISERVICE}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${getData}[7] 
    #Log To Console    logthingToken${thingToken}
	
Delta : Get Device Detail all parameter success [20000]
	#Select Dropdrown Function 
	Select Dropdrown Function    ${ASGARD_COAPAP_IMAGE_DDL_FUNCTION_DELTA}
	
	#Replace Parameters Url IMSI or Token and IP 
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL_STAGING}    ${ASGARD_COAPAPP_URL_DELTA}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	#Log To Console    url${url}
	
	#Url
	Input Url    ${ASGARD_COAPAP_IMAGE_TXT_URL_DELTA}    ${url}?${getData}[7]    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}
	#Click Send button
	Click    ${ASGARD_COAPAP_IMAGE_BTN_SEND}
	#Check Success popup
	Check Matched    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}
    #Click OK button
	Click    ${ASGARD_COAPAP_IMAGE_BTN_OK}
	
	Capture Screen   
	
	Close Program

Delta : Check Detail log [EDR] and Summary Log [CDR]
#    Log To Console    thingToken${thingToken}
	#/delta/sim/v1/Token/IPAddress
	${pathUrlReplace}=    Replace Parameters Path    ${ASGARD_COAPAPP_URL_DELTA}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	${pathUrl}=    Set Variable    ${pathUrlReplace}?${getData}[7]
	
	#{"${VALUE_SENSORKEY}": "${random_Sensor}"}  
	${valueKey}=    Set Variable    {"${getData}[7]":"${getData}[10]"}	
	${payload}=    Set Variable    ${valueKey}
	
	#api/v1/Delta?ThingToken=8ba1f4bb-0ffc-42f9-b234-ceca95f171c1&IpAddress=1.2.3.4&Sensor=Temp
	${urlCmdName}=    Set Variable    ${ASGARD_COAPAPP_URL_COAPAPISERVICE_DELTA}?ThingToken=${thingToken}&IpAddress=${ASGARD_COAPAPP_IP_ADDRESS}&Sensor=${getData}[7]

	#resultCode_summary[20000],resultDesc_summary[OK],Code_detail[20000],Description_detail[The requested operation was successfully.],applicationName[CoapAPP],pathUrl[/delta/sim/v1/Token/IPAddress],urlCmdName[api/v1/Delta],thingToken,ipAddress,payload[null],namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[Delta],endPointName[CoapApiService],logLevel[INFO],custom,SensorKey
    Check Log Response    ${VALUE_LOG_CODE_20000}    ${VALUE_LOG_SUMMARY_RESULTDESC_OK}    ${VALUE_LOG_CODE_20000}    ${VALUE_LOG_SUMMARY_RESULTDESC_20000_REQUESTED_OPERATION_SUCCESSFULLY}    ${VALUE_APPLICATIONNAME_COAPAPP}    ${pathUrl}    ${urlCmdName}    ${thingToken}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${payload}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPP}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_DELTA}    ${DETAIL_ENDPOINTNAME_COAPAPISERVICE}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${getData}[7] 

Verify DB Check Data : Sensor
	#accessToken,AccountId,ThingID,Sensor
	Request Verify DB Check Data Staging Delta    ${getData}[0]    ${getData}[2]    ${getData}[3]    ${valueKey}
	
Remove Data
	#Log To Console    ${getData}
	#accessToken,PartnerId,AccountId,ThingID,Type,SensorKey
	Request RemoveData Staging    ${getData}[0]    ${getData}[1]    ${getData}[2]    ${getData}[3]    ${getData}[6]    ${getData}[7]

