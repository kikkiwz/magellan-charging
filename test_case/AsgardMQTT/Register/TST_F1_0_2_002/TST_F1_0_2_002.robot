*** Settings ***
#Documentation     TST_F1_0_2_002
Test Setup    Add Needed Image Path
Resource    ../../../../variables/Variables.robot    
Resource    ../../../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
Create Data get
    #set variable ${IMAGE_DIR} for set folder img
	${path}=    Normalize path    ${CURDIR}${IMAGE_PATH_ASGARD_MQTT}
	Set Global Variable    ${IMAGE_DIR}    ${path}
		
	#set IMSI
	${setIMSI}=    Set Variable    ${ASGARD_MQTT_VALUE_TST_F1_0_2_002_IMSI}
	Set Global Variable    ${IMSI}    ${setIMSI}
	
	#set username in Security Tab
	${setUsername}=    Set Variable    ${ASGARD_MQTT_TAB_SECURITY_USERNAME_SIM}${IMSI}
	Set Global Variable    ${USERNAME}    ${setUsername}
#   Log To Console    setUsername${setUsername}

Connect Program
	Open Program    ${ASGARD_MQTT_IMAGE_MQTTSPY}    ${ASGARD_MQTT_IMAGE_MQTTSPY_HEADER}	
	#Click Menu Connection
	Click    ${ASGARD_MQTT_IMAGE_MENU_CONNECTIONS}
	#Click Menu Connections -> New Connection
	Click    ${ASGARD_MQTT_IMAGE_MENU_CONNECTIONS_NEWCONNECTION}
	
	#Connection Name
	Input Value    ${ASGARD_MQTT_IMAGE_TXT_CONNECTIONNAME_DATA}    ${ASGARD_MQTT_IMAGE_TXT_CONNECTIONNAME_DATA}    ${ASGARD_MQTT_VALUE_CONNECTION_NAME}     
	
	#Click Security Tab
	Click    ${ASGARD_MQTT_IMAGE_TAB_SECURITY}
	#Click Checkbox Enable User Authentication
	Click    ${ASGARD_MQTT_IMAGE_CHK_ENABLE_USER_AUTH}
	
	#Click Redio Username Predefined
	Click    ${ASGARD_MQTT_IMAGE_RDI_USERNAME_PREDEFINED}
	Input Text    ${ASGARD_MQTT_IMAGE_TXT_USERNAME_PREDEFINED}    ${USERNAME}
	#Click Redio Password Predefined
	Click    ${ASGARD_MQTT_IMAGE_RDI_PASSWORD_PREDEFINED}
	Input Text    ${ASGARD_MQTT_IMAGE_TXT_PASSWORD_PREDEFINED}    ${ASGARD_MQTT_TAB_SECURITY_PASSWORD}
	
	#Click Connectivity Tab
	Click    ${ASGARD_MQTT_IMAGE_TAB_CONNECTIVITY}
	#Server URI
	Input Value And Clear    ${ASGARD_MQTT_IMAGE_TXT_SERVERURL_DATA}    ${ASGARD_MQTT_IMAGE_TXT_SERVERURL_NULL}    ${ASGARD_MQTT_VALUE_SERVERURL}     
	#Client Id
	Input Value    ${ASGARD_MQTT_IMAGE_TXT_CLIENTID_DATA}    ${ASGARD_MQTT_IMAGE_TXT_CLIENTID_DATA}    ${ASGARD_MQTT_VALUE_CLIENTID}     

	#Click Open Connection button
	Click    ${ASGARD_MQTT_IMAGE_BTN_OPENCONNECTION}
	Click    ${ASGARD_MQTT_IMAGE_BTN_YES_POPUP_UNSAVECHANGESDETECTED}
	Click    ${ASGARD_MQTT_IMAGE_BTN_OK_POPUP_CANNOTSAVECONFIGFILE}
	
	#Check Error Connect
	Wait Until Screen Contain    ${ASGARD_MQTT_IMAGE_TAB_STATUS_CONNECT_ERROR}    10

	Capture Screen
	
	Close Program
