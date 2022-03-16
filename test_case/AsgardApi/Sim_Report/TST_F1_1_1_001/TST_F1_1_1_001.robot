*** Settings ***
#Documentation     TST_F1_1_1_001
Test Setup    Add Needed Image Path

Resource    ../../../../variables/Variables.robot    
Resource    ../../../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
Create Data get IMSI
    #set variable ${IMAGE_DIR} for set folder img
	${path}=    Normalize path    ${CURDIR}${IMAGE_PATH_ASGARD_COAPAPP}
	Set Global Variable    ${IMAGE_DIR}    ${path}
	
    #getDataRequest position data=[accessToken,PartnerId,AccountId,ThingID,IMSI,ThingToken,Type,SensorKey,random_Sensor,AccountName]
    ${getDataRequest}=    Request CreateData for get IMSI Staging
	#set data use cross testcase
	Set Global Variable    ${getData}    ${getDataRequest}
	
	#set IMSI
	${setIMSI}=    Set Variable    ${getData}[4]
	Set Global Variable    ${IMSI}    ${setIMSI}
	
	#{"${VALUE_SENSORKEY}": "${random_Sensor_App}"}  
	#random_Sensor_Report
	${random_Sensor_App}=    Evaluate    random.randint(100, 999)    random
	Set Global Variable    ${randomSensorApp}    ${random_Sensor_App}
	${setValueKey}=    Set Variable    {"${getData}[7]":"${randomSensorApp}"}
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
	
	${identity}=    Set Variable    {"Imei":"${IMSI}","ThingID":"${getData}[3]","Imsi":"${IMSI}"}		
	${custom}=    Evaluate    {'Imei':['${IMSI}'],'url':'coapapis.magellanstaging.svc.cluster.local' + '${ASGARD_COAPAPI_URL_REGISTER}','Imsi':['${IMSI}'],'IpAddress':'${ASGARD_COAPAPP_IP_ADDRESS}','ThingID':['${getData}[3]']}
	${body}=    Set Variable    {"Imsi":"${IMSI}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}"}
    
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[The requested operation was successfully.],applicationName[Asgard.Coap.APIs],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Register],imsi,ipAddress,body,namespace[Magellan],containerId[coapapp-vXX ],identity[null],cmdName[Post_Register],endPointName[],logLevel[INFO],custom,SensorKey
    Check Log Response    ${VALUE_LOG_CODE_20000}    ${VALUE_LOG_SUMMARY_RESULTDESC_20000_REQUESTED_OPERATION_SUCCESSFULLY}    ${VALUE_LOG_CODE_20000}    ${VALUE_LOG_SUMMARY_RESULTDESC_20000_REQUESTED_OPERATION_SUCCESSFULLY}    ${VALUE_APPLICATIONNAME_COAPAPI}    ${pathUrl}    ${ASGARD_COAPAPI_URL_REGISTER}    ${IMSI}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPI}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_POST_REGISTER}    ${EMPTY}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${custom}    ${getData}[7]  
    #Log To Console    logthingToken${thingToken}
	
Report : Get Device Detail all parameter success [20000]
	#Replace Parameters Url IMSI or Token and IP 
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL_STAGING}    ${ASGARD_COAPAPP_URL_REPORT}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	#Log To Console    url${url}
	
	#Url
	Input Url    ${ASGARD_COAPAP_IMAGE_TXT_URL_REGISTER}    ${url}    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}
	#Payload
	Input Payload Textarea Null     ${valueKey}
	
	#Click Send button
	Click    ${ASGARD_COAPAP_IMAGE_BTN_SEND}
	#Check Success popup
	Check Matched    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}
    #Click OK button
	Click    ${ASGARD_COAPAP_IMAGE_BTN_OK}
	
	#check Response 20000
	Check Matched    ${ASGARD_COAPAP_IMAGE_RESPONSE_SUCCESS_20000}
	
	Capture Screen   
	
	Close Program

Report : Check Detail log [EDR] and Summary Log [CDR]
	#Log To Console    thingToken${thingToken}
	#/report/sim/v1/Token/IPAddress
	${pathUrl}=    Replace Parameters Path    ${ASGARD_COAPAPP_URL_REPORT}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	
	${identity}=    Set Variable    {"Imei":"${IMSI}","ThingID":"${getData}[3]","Imsi":"${IMSI}"}		
	${custom}=    Evaluate    {'Imei':['${IMSI}'],'url':'coapapis.magellanstaging.svc.cluster.local' + '${ASGARD_COAPAPI_URL_REPORT}','IpAddress':'${ASGARD_COAPAPP_IP_ADDRESS}','Imsi':['${IMSI}'],'ThingID':['${getData}[3]']}
	${body}=    Set Variable    {"ThingToken":"${thingToken}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}","Payloads":${valueKey},"UnixTimestampMs":[tid]}
	
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[The requested operation was successfully.],applicationName[Asgard.Coap.APIs],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Register],thingToken,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX ],identity[null],cmdName[Post_Report],endPointName[RabbitMQ],logLevel[INFO],custom,SensorKey
    Check Log Response    ${VALUE_LOG_CODE_20000}    ${VALUE_LOG_SUMMARY_RESULTDESC_20000_REQUESTED_OPERATION_SUCCESSFULLY}    ${VALUE_LOG_CODE_20000}    ${VALUE_LOG_SUMMARY_RESULTDESC_20000_REQUESTED_OPERATION_SUCCESSFULLY}    ${VALUE_APPLICATIONNAME_COAPAPI}    ${pathUrl}    ${ASGARD_COAPAPI_URL_REPORT}    ${thingToken}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPI}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_POST_REPORT}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${custom}    ${getData}[7] 
    #Log To Console    logthingToken${thingToken}
	
Verify DB Check Data : Sensor
	#accessToken,AccountId,ThingID,Sensor
	Request Verify DB Check Data Staging Report    ${getData}[0]    ${getData}[2]    ${getData}[3]    ${valueKey}
	
Remove Data

	#Log To Console    ${getData}
	#accessToken,PartnerId,AccountId,ThingID,Type,SensorKey
	Request RemoveData Staging    ${getData}[0]    ${getData}[1]    ${getData}[2]    ${getData}[3]    ${getData}[6]    ${getData}[7]

