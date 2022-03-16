*** Keywords ***	
################################################################-- Have EndPointName --################################################################
#-------------------------------------------- MQTT Register Have EndPointName --------------------------------------------#	
#-------------------------------------------- MQTT Register : RequestObject Have EndPointName --------------------------------------------#	
Check RequestObject Success MQTT Register
	[Arguments]    ${dataResponse}    ${urlCmdName}
	#"{\"url\":\"[valuepathCmdUrl]\",\"body\":\"[body]\"}"
	${replaceUrlCmdName}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_MQTT_CMDNAME_REGISTER}    [urlCmdName]    ${urlCmdName}
	#${thingToken} received from Set Global Variable
	${replaceBody}=    Replace String    ${replaceUrlCmdName}    [body]    ${thingToken}
	${requestObject}=    Replace String To Object    ${replaceBody}
	#Log To Console    requestObjectRegister${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}

#-------------------------------------------- MQTT Report Have EndPointName --------------------------------------------#	
#-------------------------------------------- MQTT Report : RequestObject Have EndPointName --------------------------------------------#	
Check RequestObject Success MQTT Report
	[Arguments]    ${dataResponse}    ${urlCmdName}    ${tid}    ${body}
	
	${valBody}=    Convert JSON To String    ${body}    
	#Log To Console    valBody${valBody}

	#"{\"url\":\"internal[urlCmdName]\",\"headers\":{\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[tid]\",\"timestamp_in_ms\":\"[tid]\"},\"body\":\"[body]\"}"
	${replaceUrlCmdName}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_MQTT_CMDNAME_REPORT}    [urlCmdName]    ${urlCmdName}
	${replaceBody}=    Replace String    ${replaceUrlCmdName}    [body]    ${valBody}
	${replacexAis}=    Replace String    ${replaceBody}    [tid]    ${tid}
	${requestObject}=    Replace String To Object    ${replacexAis}
	#Log To Console    requestObjectReport${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}

#-------------------------------------------- MQTT Config Have EndPointName --------------------------------------------#	
#-------------------------------------------- MQTT Config : RequestObject Have EndPointName --------------------------------------------#	
Check RequestObject Success MQTT Config
	[Arguments]    ${dataResponse}    ${urlCmdName}    ${tid}    ${body}
	
	${resp_json}=    Evaluate    json.loads(r'''${dataResponse['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']}''')    json
	#Log To Console    resp_json${resp_json}
		
	${splitUrlResponse} =    Split String    ${resp_json['url']}    .    5
	#Log To Console    splitUrlResponse${splitUrlResponse}[5]

    ${urlCmdNameReplaceSensorName}=    Replace String    ${urlCmdName}    ${ASGARD_MQTT_FIELD_SENSORNAME}    ${splitUrlResponse}[5]
	
	${valBody}=    Set Variable If    "${splitUrlResponse}[5]" == "${VALUE_CONFIGINFO_KEY_REFRESHTIME}"    ${body['${VALUE_CONFIGINFO_KEY_REFRESHTIME}']}    ${body['${VALUE_CONFIGINFO_KEY_MAX}']}    
	#Log To Console    valBody${valBody}

	#"{\"url\":\"[urlCmdName]\",\"body\":\"[body]\"}"
	${replaceUrlCmdName}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_MQTT_CMDNAME_CONFIG}    [urlCmdName]    ${urlCmdNameReplaceSensorName}
	${replaceBody}=    Replace String    ${replaceUrlCmdName}    [body]    ${valBody}
	${requestObject}=    Replace String To Object    ${replaceBody}
	#Log To Console    requestObjectReport${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}
	
##############################################################################################################################################################
     	
################################################################-- Do Not Have EndPointName --################################################################

#-------------------------------------------- MQTT Register Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- MQTT Register : RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success MQTT Register 
    [Arguments]    ${dataResponse}    ${pathUrl}    ${tid}    ${body}
	#"{\"url\":\"[valuePathUrl]\",\"headers\":{\"x-mqtt-publish-qos\":\"0\",\"x-mqtt-dup\":\"False\",\"timestamp_in_ms\":\"[tid]\"},\"body\":[body]}"
	${replaceUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_MQTT_APP_REGISTER}    [valuePathUrl]    ${pathUrl}
	${replaceBody}=    Replace String    ${replaceUrl}    [body]    ${body}
	${replaceHeaders}=    Replace String    ${replaceBody}    [tid]    ${tid}
	${requestObject}=    Replace String To Object    ${replaceHeaders}
	#Log To Console    RegisterRequestObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}

	#-------------------------------------------- MQTT Report Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- MQTT Report : RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success MQTT Report 
    [Arguments]    ${dataResponse}    ${pathUrl}    ${tid}    ${body}    ${SensorKey}
	#{"${getData}[7]":"${getData}[8]"}
	
	${resp_json}=    Evaluate    json.loads(r'''${body}''')    json
	#Log To Console    resp_json${resp_json}
	${setBody}=    Evaluate    {"${SensorKey}": "${resp_json['${SensorKey}']}"}
	
	#Log To Console    setBodysetBodysetBody${setBody} 
	${valConvertBody}=    Convert JSON To String    ${setBody}    
	${valBody}=    Convert JSON To String    ${valConvertBody}    
	#Log To Console    valBody${valBody}

	#"{\"url\":\"[valuePathUrl]\",\"headers\":{\"x-mqtt-publish-qos\":\"0\",\"x-mqtt-dup\":\"False\",\"timestamp_in_ms\":\"[tid]\"},\"body\":\"[body]\"}"
	${replaceUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_MQTT_APP_REPORT}    [valuePathUrl]    ${pathUrl}
	${replaceBody}=    Replace String    ${replaceUrl}    [body]    ${valBody}
	${replaceHeaders}=    Replace String    ${replaceBody}    [tid]    ${tid}
	${requestObject}=    Replace String To Object    ${replaceHeaders}
	#Log To Console    ReportRequestObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}

#-------------------------------------------- MQTT Config Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- MQTT Config : RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success MQTT Config 
    [Arguments]    ${dataResponse}    ${pathUrl}    ${tid}
	#"{\"url\":\"[valuePathUrl]\",\"headers\":{\"x-mqtt-publish-qos\":\"0\",\"x-mqtt-dup\":\"False\",\"timestamp_in_ms\":\"[tid]\"},\"body\":\"\"}"
	${replaceUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_MQTT_APP_CONFIG}    [valuePathUrl]    ${pathUrl}
	${replaceHeaders}=    Replace String    ${replaceUrl}    [tid]    ${tid}
	${requestObject}=    Replace String To Object    ${replaceHeaders}
	#Log To Console    RegisterRequestObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}

############################################################################################################################################################## 
