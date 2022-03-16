*** Settings ***
#Documentation     TST_F2_1_0_006
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
    ${getDataRequest}=    Config Request CreateData for get IMSI Staging
	#set data use cross testcase
	Set Global Variable    ${getData}    ${getDataRequest}
	
	#set IMSI
	${setIMSI}=    Set Variable    ${getData}[4]
	Set Global Variable    ${IMSI}    ${setIMSI}

Register Device in all parameter success [20000]
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

Remove Data Account
	#Log To Console    ${getData}
	#accessToken,PartnerId,AccountId
	Remove AccountName    ${URL_STAGING}    ${getData}[0]    ${getData}[1]    ${getData}[2]
	
Config : Get Device Detail all parameter success [40400]
	#Select Dropdrown Function 
	Select Dropdrown Function    ${ASGARD_COAPAP_IMAGE_DDL_FUNCTION_CONFIG}
	
	#because find input url not found so click header 
	Click    MagellanClient_header.png
	
	#Replace Parameters Url IMSI or Token and IP 
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL_STAGING}    ${ASGARD_COAPAPP_URL_CONFIG}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	#Log To Console    url${url}
	
	#Url
	Input Url    ${ASGARD_COAPAP_IMAGE_TXT_URL_CONFIG}    ${url}    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}
	
	#Click Send button
	Click    ${ASGARD_COAPAP_IMAGE_BTN_SEND}
	#Check Success popup
	Check Matched    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}
    #Click OK button
	Click    ${ASGARD_COAPAP_IMAGE_BTN_OK}
	
	#check Response 40300
	Check Matched    ${ASGARD_COAPAP_IMAGE_RESPONSE_ERROR_40300}
	
	Capture Screen   
	
	Close Program

Config : Check Detail log [EDR] and Summary Log [CDR]
    #Log To Console    thingToken${thingToken}
	#/config/sim/v1/token/IP
	${pathUrl}=    Replace Parameters Path    ${ASGARD_COAPAPP_URL_CONFIG}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	
	${identity}=    Set Variable    {"Imei":"${IMSI}","ThingID":"${getData}[3]","Imsi":"${IMSI}"}		
	${custom}=    Evaluate    {'Imei':['${IMSI}'],'url':'coapapis.magellanstaging.svc.cluster.local' + '${ASGARD_COAPAPI_URL_CONFIG}','IpAddress':'${ASGARD_COAPAPP_IP_ADDRESS}','Imsi':['${IMSI}'],'ThingID':['${getData}[3]']}
	${body}=    Set Variable    {"ThingToken":"${thingToken}","IpAddress":"${ASGARD_COAPAPP_IP_ADDRESS}"}
	
	#resultCode_summary[40400],resultDesc_summary[The requested operation could not be found.],Code_detail[40400],Description_detail[The requested operation could not be found.],applicationName[Asgard.Coap.APIs],pathUrl[/config/sim/v1/token/IP],urlCmdName[/api/v1/Config],thingToken,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[Get_Config],endPointName[null],logLevel[INFO],custom,SensorKey
    Check Log Response    ${VALUE_LOG_CODE_40400}    ${VALUE_DESCRIPTION_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${VALUE_LOG_CODE_40400}    ${VALUE_DESCRIPTION_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${VALUE_APPLICATIONNAME_COAPAPI}    ${pathUrl}    ${ASGARD_COAPAPI_URL_CONFIG}    ${thingToken}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPI}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_GET_CONFIG}    ${EMPTY}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${custom}    ${getData}[7]       
	
