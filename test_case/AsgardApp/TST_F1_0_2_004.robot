*** Settings ***
#Documentation     TST_F1_0_2_004
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
	
Report : Get Device Detail all parameter fail [40010]
   	#Replace Parameters Url IMSI or Token and IP 
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL_STAGING}    ${ASGARD_COAPAPP_URL_REPORT}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}${ASGARD_COAPAPP_VALUE_TST_F1_0_2_003_THINGTOKEN_INVALID}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	#Log To Console    url${url}
	
	#Url
	Input Url    ${ASGARD_COAPAP_IMAGE_TXT_URL_REGISTER}    ${url}    ${ASGARD_COAPAP_IMAGE_TXT_URL_NULL}
	#Payload
	#random_Sensor_Report
	${random_Sensor_App}=    Evaluate    random.randint(100, 999)    random
	Set Global Variable    ${randomSensorApp}    ${random_Sensor_App}
	Input Payload Textarea Null     ${randomSensorApp}
	
	#Click Send button
	Click    ${ASGARD_COAPAP_IMAGE_BTN_SEND}
	#Check Success popup
	Check Matched    ${ASGARD_COAPAP_IMAGE_POPUP_SUCCESS}
    #Click OK button
	Click    ${ASGARD_COAPAP_IMAGE_BTN_OK}
	
	#check Response 40100
	Check Matched    ${ASGARD_COAPAP_IMAGE_RESPONSE_ERROR_40010}
	
	Capture Screen   
	
	Close Program

Report : Check Detail log [EDR] and Summary Log [CDR]
	#Log To Console    thingToken${thingToken}
	#/report/sim/v1/Token/IPAddress
	${pathUrlReplace}=    Replace Parameters Path    ${ASGARD_COAPAPP_URL_REPORT}    ${ASGARD_COAPAPP_FIELD_TOKEN}    ${thingToken}${ASGARD_COAPAPP_VALUE_TST_F1_0_2_003_THINGTOKEN_INVALID}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_IP_ADDRESS}
	${pathUrl}=    Set Variable    ${pathUrlReplace}
	${payload}=    Set Variable    ${randomSensorApp}
	
	#resultCode_summary[40010],resultDesc_summary[InvalidPayload],Code_detail[40010],Description_detail[InvalidPayload],applicationName[CoapAPP],pathUrl[/report/sim/v1/Token/IPAddress],urlCmdName[api/v1/Report],thingToken,ipAddress,payload[null],namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[Report],endPointName[CoapApiService],logLevel[INFO],custom,SensorKey
    Check Log Response    ${VALUE_LOG_CODE_40010}    ${VALUE_DESCRIPTION_INVALIDPAYLOAD_ERROR}    ${VALUE_LOG_CODE_40010}    ${VALUE_DESCRIPTION_INVALIDPAYLOAD_ERROR}    ${VALUE_APPLICATIONNAME_COAPAPP}    ${pathUrl}    ${ASGARD_COAPAPP_URL_COAPAPISERVICE_REPORT}    ${thingToken}    ${ASGARD_COAPAPP_IP_ADDRESS}    ${payload}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPP}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_REPORT}    ${DETAIL_ENDPOINTNAME_COAPAPISERVICE}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${getData}[7]          
	
Remove Data

	#Log To Console    ${getData}
	#accessToken,PartnerId,AccountId,ThingID,Type,SensorKey
	Request RemoveData Staging    ${getData}[0]    ${getData}[1]    ${getData}[2]    ${getData}[3]    ${getData}[6]    ${getData}[7]

