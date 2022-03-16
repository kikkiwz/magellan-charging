*** Settings ***
#Documentation     TST_F3_1_1_004
Test Setup    Add Needed Image Path
Resource    ../../../../variables/Variables.robot    
Resource    ../../../../keyword/Keyword.robot

*** Test Cases ***
################### Post ###################
Create Data get
    #set variable ${IMAGE_DIR} for set folder img
	${path}=    Normalize path    ${CURDIR}${IMAGE_PATH_ASGARD_MQTT}
	Set Global Variable    ${IMAGE_DIR}    ${path}
	
    #getDataRequest position data=[#accessToken,AccountId,ThingID,IMSI,ThingToken,Type,SensorKey,random_Sensor,AccountName]
    ${getDataRequest}=    Charging Request CreateData for get IMSI Staging Report
	#set data use cross testcase
	Set Global Variable    ${getData}    ${getDataRequest}
	
	#set IMSI
	#${setIMSI}=    Set Variable    948867257516675
	${setIMSI}=    Set Variable    ${getData}[3]
	Set Global Variable    ${IMSI}    ${setIMSI}
	
	#${IMSI}=    Set Variable    12345
	#set username in Security Tab
	${setUsername}=    Set Variable    ${ASGARD_MQTT_TAB_SECURITY_USERNAME_SIM}${IMSI}
	Set Global Variable    ${USERNAME}    ${setUsername}
    #Log To Console    setUsername${setUsername}


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
	
	#Check Success Connect
	Wait Until Screen Contain    ${ASGARD_MQTT_IMAGE_STATUS_CONNECT_SUCCESS}    10
	Click    ${ASGARD_MQTT_IMAGE_STATUS_CONNECT_SUCCESS}
	
User Register in all parameter success [20000]	
	#Replace Parameters Url IMSI and IP 
	${urlPulishRegister}=    Replace Parameters Path    ${ASGARD_MQTT_URL_REGISTER_TOPIC_PUBLISH}    ${ASGARD_MQTT_FIELD_IMSI}    ${IMSI}    ${ASGARD_MQTT_FIELD_IPADDRESS}    ${ASGARD_MQTT_IP_ADDRESS}
	#Log To Console    urlPulishRegister${urlPulishRegister}
	
	#Pulish Topic
	Input Text    ${ASGARD_MQTT_IMAGE_TXT_PUBLISH_TOPIC}    ${urlPulishRegister}
	
	#Replace Parameters Url IMSI
	${urlSubscriptionRegister}=    Replace Parameters    ${ASGARD_MQTT_URL_REGISTER_TOPIC_SUBSCRIPTION}    ${ASGARD_MQTT_FIELD_IMSI}    ${IMSI}
	#Log To Console    urlSubscriptionRegister${urlSubscriptionRegister}	
	#Click new subscription
	Click    ${ASGARD_MQTT_IMAGE_TAB_NEW_SUBSCRIPTION}
	#Subscription Topic
	Input Text    ${ASGARD_MQTT_IMAGE_TXT_SUBSCRIPTION_TOPIC}    ${urlSubscriptionRegister}
	Click    ${ASGARD_MQTT_IMAGE_BTN_SUBSCRIBE}
	Click    ${ASGARD_MQTT_IMAGE_PATH_SUBSCRIPTION_REGISTER}
	Click    ${ASGARD_MQTT_IMAGE_BTN_PUBLISH}
	
	#Check Success
	Wait Until Screen Contain    ${ASGARD_MQTT_IMAGE_TAB_STATUS_CONNECT_SUCCESS}    10
	
	Capture Screen   
	
Register : Check Detail log [EDR] and Summary Log [CDR]

    #Log To Console    IMSI${IMSI}
	#register/update/sim/v1/IMSI/IPAddress
	${pathUrlReplace}=    Replace Parameters Path    ${ASGARD_MQTT_URL_REGISTER_TOPIC_PUBLISH}    ${ASGARD_MQTT_FIELD_IMSI}    ${IMSI}    ${ASGARD_MQTT_FIELD_IPADDRESS}    ${ASGARD_MQTT_IP_ADDRESS}
	${pathUrl}=    Replace String    ${pathUrlReplace}    /    . 
	#Log To Console    pathUrl${pathUrl}
	#register/get/sim/v1/IMSI
	${urlCmdNameReplace}=    Replace String    ${ASGARD_MQTT_URL_REGISTER_TOPIC_SUBSCRIPTION}    ${ASGARD_MQTT_FIELD_IMSI}    ${IMSI}
	${urlCmdName}=    Replace String    ${urlCmdNameReplace}    /    .
	
	${identity}=    Set Variable    {"ThingID":"${getData}[2]","Imei":"${IMSI}","Imsi":"${IMSI}"}		
	${custom}=    Evaluate    {'Imsi': ['${IMSI}'], 'Imei': ['${IMSI}'], 'ThingID': ['${getData}[2]']}
	${body}=    Set Variable    ""
	
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[Register is Success],applicationName[Asgard.Mqtt.V1.APP],pathUrl[/register/sim/v1/IMSI/IPAddress],urlCmdName[/api/v1/Sim/Register],imsi,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity,cmdName[register],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
    MQTT Check Log Response    ${VALUE_LOG_CODE_20000}    ${VALUE_LOG_SUMMARY_RESULTDESC_20000_REQUESTED_OPERATION_SUCCESSFULLY}    ${VALUE_LOG_CODE_20000}    ${VALUE_DESCRIPTION_REGISTER_SUCCESS}    ${VALUE_APPLICATIONNAME_MQTT}    ${pathUrl}    ${urlCmdName}    ${IMSI}    ${ASGARD_MQTT_IP_ADDRESS}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_MQTT}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_SEARCH_REGISTER_MQTT}    ${custom}    ${getData}[7] 
    #Log To Console    logthingToken${thingToken}
		
User Report in all parameter success [20000]	
	#Click Disconnect
	#Click    ${ASGARD_MQTT_IMAGE_TAB_STATUS_CONNECT_SUCCESS}
	Right Click    ${ASGARD_MQTT_IMAGE_TAB_STATUS_CONNECT_SUCCESS}
	Click    ${ASGARD_MQTT_IMAGE_MENU_DISCONNECT_ANDKEEPTAB}
	
	#Click Connect
	Right Click    ${ASGARD_MQTT_IMAGE_TAB_STATUS_DISCONNECT}
	Click    ${ASGARD_MQTT_IMAGE_MENU_CONNECT_RECONNECT}

	Sleep    1s
	
	#Pulish Topic
	${urlPulishReport}=    Replace Parameters Path    ${ASGARD_MQTT_URL_REPORT_TOPIC_PUBLISH}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}    ${ASGARD_MQTT_FIELD_IPADDRESS}    ${ASGARD_MQTT_IP_ADDRESS}
	#Log To Console    urlPulishReport${urlPulishReport}
	Click    ${ASGARD_MQTT_IMAGE_TXT_PUBLISH_TOPIC_REGISTER}
    Type With Modifiers    a    KEY_CTRL
	Type With Modifiers    x    KEY_CTRL
	Input Text    ${ASGARD_MQTT_IMAGE_TXT_PUBLISH_TOPIC_AFTERCLEAR}    ${urlPulishReport}
	
    #Pulish Data {"${SensorKey}": "${random_Sensor_App}"}
	#random_Sensor_Report
	#${random_Sensor_App}=    Evaluate    random.randint(100, 999)    random
	#Set Global Variable    ${randomSensorApp}    ${random_Sensor_App}
	${setValueKey}=    Set Variable    {"${getData}[6]":"${CHARGING_ASGARD_MQTT__VALUE_TST_F3_1_1_004_SENSOR}"}
	#set data use cross testcase
	Set Global Variable    ${valueKey}    ${setValueKey}
	
	Input Text    ${ASGARD_MQTT_IMAGE_TXT_PUBLISH_DATA}    ${valueKey}
	Click    ${ASGARD_MQTT_IMAGE_BTN_PUBLISH}
		
	#Check Success
	Wait Until Screen Contain    ${ASGARD_MQTT_IMAGE_TAB_STATUS_CONNECT_SUCCESS}    10
	
	Capture Screen   
	
	Close Program

Report : Check Summary Log [CDR]
    #Log To Console    IMSI${IMSI}
	#report/update/sim/v1/ThingToken/IPAddress
	${pathUrlReplace}=    Replace Parameters Path    ${ASGARD_MQTT_URL_REPORT_TOPIC_PUBLISH}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}    ${ASGARD_MQTT_FIELD_IPADDRESS}    ${ASGARD_MQTT_IP_ADDRESS}
	${pathUrl}=    Replace String    ${pathUrlReplace}    /    .
	
	#internalreport/pub/v1/ThingToken    
	#internalreport.pub.v1.e34b0974-ef45-4f82-bab8-82382a84a427
	${urlCmdNameReplace}=    Replace String    ${ASGARD_MQTT_URL_REPORT_TOPIC_SUBSCRIPTION_LOG}    ${ASGARD_MQTT_FIELD_TOKEN}    ${thingToken}
	${urlCmdName}=    Replace String    ${urlCmdNameReplace}    /    .

    ${body}=    Set Variable    {"${getData}[6]":"${CHARGING_ASGARD_MQTT__VALUE_TST_F3_1_1_004_SENSOR}"}
	#${body}=    Set Variable    {\"GPSPHP\":\"13.7806276,100.5439577\",\"GPSARI\":\"13.7806476,100.5439477\",\"Temperature\":27.31,\"Humidity\":51.03,\"Iluminate\":0,\"Battery\":95,\"Timestamp\":\"2021-02-25T13:24:08.1000001+07:00\",\"Radio*PCI\":87,\"Radio*RSRP\":-101,\"Radio*RSRQ\":-10,\"Radio*SNR\":5}
	
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[Register is Success],applicationName[Asgard.Mqtt.V1.APP],pathUrl[report/update/sim/v1/ThingToken/IPAddress],urlCmdName[internalreport/pub/v1/ThingToken],ThingToken,ipAddress,body,namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[report],endPointName[RabbitMQ],logLevel[INFO],valueSearchText,custom,SensorKey
    MQTT Check Log Response Charging    ${VALUE_LOG_CODE_20000}    ${VALUE_LOG_SUMMARY_RESULTDESC_20000_REQUESTED_OPERATION_SUCCESSFULLY}    ${VALUE_LOG_CODE_20000}    ${VALUE_DESCRIPTION_REGISTER_SUCCESS}    ${VALUE_APPLICATIONNAME_MQTT}    ${pathUrl}    ${urlCmdName}    ${ThingToken}    ${ASGARD_MQTT_IP_ADDRESS}    ${body}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_MQTT}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_REPORT_MQTT}    ${DETAIL_ENDPOINTNAME_RABBITMQ}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_SEARCH_REPORT_MQTT}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${getData}[7] 
    #Log To Console    logthingToken${thingToken}

Chariging : Check Detail log [EDR] and Summary Log [CDR]
	${pathUrl}=    Set Variable    ${CHARGING_URL}${getData}[2]
	${payload}=    Set Variable    ${valueKey}
	
	#Chariging
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully.],Code_detail[20000],Description_detail[The requested operation was successfully.],applicationName[Insight.Charging.APIs],pathUrl[],urlCmdName[],thingToken,ipAddress,payload[null],namespace[magellanstaging],containerId[coapapp-vXX],identity[null],cmdName[PostCharging],endPointName[RocsService],logLevel[INFO],custom,SensorKey
	Check Log Response    ${VALUE_LOG_CODE_20000}    ${VALUE_LOG_SUMMARY_RESULTDESC_20000_REQUESTED_OPERATION_SUCCESSFULLY}    ${VALUE_LOG_CODE_20000}    ${VALUE_LOG_SUMMARY_RESULTDESC_20000_REQUESTED_OPERATION_SUCCESSFULLY}    ${VALUE_APPLICATIONNAME_CHARGING}    ${pathUrl}    ${EMPTY}    ${getData}[2]    ${ASGARD_COAPAPP_IP_ADDRESS}    ${payload}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_CHARGING}    ${VALUE_LOG_SUMMARY_IDENTITY}    ${VALUE_LOG_SUMMARY_CMDNAME_POSTCHARGING}    ${DETAIL_ENDPOINTNAME_ROCSSERVICE}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${VALUE_LOG_SUMMARY_CUSTOM}    ${getData}[6]          
	
Verify DB Check Data : Sensor
	#accessToken,AccountId,ThingID,Sensor
	Request Verify DB Check Data Staging Report    ${getData}[0]    ${getData}[1]    ${getData}[2]    ${valueKey}
	