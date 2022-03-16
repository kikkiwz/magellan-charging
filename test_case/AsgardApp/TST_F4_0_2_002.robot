*** Settings ***
#Documentation     TST_F4_0_2_002
Test Setup    Add Needed Image Path

Resource    ../../../../variables/Variables.robot    
Resource    ../../../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
Create Data get IMSI
    #set variable ${IMAGE_DIR} for set folder img
	${path}=    Normalize path    ${CURDIR}${IMAGE_PATH_ASGARD_COAPAPP}
	Set Global Variable    ${IMAGE_DIR}    ${path}
	
	#set IMSI
	${setIMSI}=    Set Variable    ${ASGARD_COAPAPP_VALUE_TST_F4_0_2_002_IMSI}
	Set Global Variable    ${IMSI}    ${setIMSI}
	
Register : Device Detail all parameter fail [40300]
    
	#Replace Parameters Url IMSI or Token and IP 
	${url}=    Replace Parameters Url Path     ${ASGARD_COAPAPP_URL_STAGING}    ${ASGARD_COAPAPP_URL_REGISTER}    ${ASGARD_COAPAPP_FIELD_IMSI}    ${IMSI}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_VALUE_TST_F4_0_2_002_IPADDRESS}
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
	
	#check Response 40300
	Check Matched    ${ASGARD_COAPAP_IMAGE_RESPONSE_ERROR_40300}
	
	Capture Screen
	
	Close Program
	
Register : Check Detail log [EDR] and Summary Log [CDR]
	#/register/sim/v1/IMSI/IPAddress
	${pathUrl}=    Replace Parameters Path    ${ASGARD_COAPAPP_URL_REGISTER}    ${ASGARD_COAPAPP_FIELD_IMSI}    ${IMSI}    ${ASGARD_COAPAPP_FIELD_IPADDRESS}    ${ASGARD_COAPAPP_VALUE_TST_F4_0_2_002_IPADDRESS}
	${payload}=    Set Variable    null
	
	#resultCode_summary[40300],resultDesc_summary[Forbidden],Code_detail[40300],Description_detail[The requested operation could not be found.],applicationName[CoapAPP],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Sim/Register],imsi,ipAddress,payload[null],namespace[magellanstaging],containerId[coapapp-v26 ],identity[null],cmdName[Register],endPointName[CoapApiService],logLevel[INFO],custom,SensorKey
    Check Log Response    ${VALUE_LOG_CODE_40300}    ${VALUE_DESCRIPTION_FORBIDDEN_ERROR}    ${VALUE_LOG_CODE_40300}    ${VALUE_DESCRIPTION_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    ${VALUE_APPLICATIONNAME_COAPAPP}    ${pathUrl}    ${ASGARD_COAPAPP_URL_COAPAPISERVICE_REGISTER}    ${IMSI}    ${ASGARD_COAPAPP_VALUE_TST_F4_0_2_002_IPADDRESS}    ${payload}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_COAPAPP}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}    ${DETAIL_ENDPOINTNAME_COAPAPISERVICE}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${EMPTY} 

  