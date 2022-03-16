*** Keywords ***	
#-------------------------------------------- Check Log Summary --------------------------------------------#		
Check Log Summary
    [Arguments]    ${resultCode}    ${resultDesc}    ${data}    ${tid}    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}

	#Log To Console    data${data}
	${dataResponse}=    Set Variable    ${data[0]} 

	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_SYSTEMTIMESTAP}']    ${data[0]['systemTimestamp']}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_LOGTYPE}']    ${VALUE_SUMMARY} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_NAMESPACE}']    ${namespace}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_APPLICATIONNAME}']    ${applicationName}
	#Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CONTAINERID}']    ${containerId}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_SESSIONID}']    ${data[0]['sessionId']}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_TID}']    ${data[0]['tid']}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_IDENTITY}']    ${identity}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CMDNAME}']    ${cmdName} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_RESULTCODE}']    ${resultCode} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_RESULTDESC}']    ${resultDesc}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CUSTOM}']    ${custom} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_REQTIMESTAP}']    ${data[0]['reqTimestamp']} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_RESTIMESTAMP}']    ${data[0]['resTimestamp']}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_USAGETIME}']    ${data[0]['usageTime']} 
	
	
Check Log Summary Charging
    [Arguments]    ${resultCode}    ${resultDesc}    ${data}    ${tid}    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}

	#Log To Console    data${data}
	${dataResponse}=    Set Variable    ${data[0]} 

	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_SYSTEMTIMESTAP}']    ${data[0]['systemTimestamp']}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_LOGTYPE}']    ${VALUE_SUMMARY} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_NAMESPACE}']    ${namespace}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_APPLICATIONNAME}']    ${applicationName}
	#Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CONTAINERID}']    ${containerId}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_SESSIONID}']    ${data[0]['sessionId']}
	#Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_TID}']    ${tid}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_IDENTITY}']    ${identity}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CMDNAME}']    ${cmdName} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_RESULTCODE}']    ${resultCode} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_RESULTDESC}']    ${resultDesc}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CUSTOM}']    ${custom} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_REQTIMESTAP}']    ${data[0]['reqTimestamp']} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_RESTIMESTAMP}']    ${data[0]['resTimestamp']}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_USAGETIME}']    ${data[0]['usageTime']} 