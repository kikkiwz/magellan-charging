*** Keywords ***	
Post Search Log
    [Arguments]    ${url}    ${valueSearch}    ${value_applicationName}    
	${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    kbn-version=7.5.1 
    #${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    Host=azmagellancd001-iot.southeastasia.cloudapp.azure.com:30380    kbn-version=7.5.1    Origin=http://azmagellancd001-iot.southeastasia.cloudapp.azure.com:30380    
	#Log To Console    ${headers}
	
	#return valueDateGte,valueDateLte (RANGE_SEARCH 15 minutes)
	${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    ${RANGE_SEARCH}    ${TIME_STRING_MINUTES}
	#${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    50    ${TIME_STRING_MINUTES}
	#Log To Console    setRange${setRange}
	${setRangeGTE}=    Set variable    ${setRange}[0]
	${setRangeLTE}=    Set variable    ${setRange}[1]
	#Log To Console    setRangeGTE${setRangeGTE}
	#Log To Console    setRangeLTE${setRangeLTE}
	
	${multiMatchType}=    Set Variable If    '${valueSearch}'=='${ASGARD_COAPAPI_VALUE_TST_F4_0_2_003_DATASEARCH}'    phrase
...    '${value_applicationName}'=='${VALUE_APPLICATIONNAME_CHARGING}'    phrase	
	...    '${valueSearch}'!='${ASGARD_COAPAPI_VALUE_TST_F4_0_2_003_DATASEARCH}'    best_fields	
	
    ${data}=    Evaluate    {"version":"true","size":500,"sort":[{"@timestamp_es":{"order":"desc","unmapped_type":"boolean"}}],"_source":{"excludes":[]},"aggs":{"2":{"date_histogram":{"field":"@timestamp_es","fixed_interval":"30s","time_zone":"Asia/Bangkok","min_doc_count":1}}},"stored_fields":["*"],"script_fields":{},"docvalue_fields":[{"field":"@timestamp_es","format":"date_time"},{"field":"cauldron.custom1.activityLog.endTime","format":"date_time"},{"field":"cauldron.custom1.activityLog.startTime","format":"date_time"},{"field":"time","format":"date_time"}],"query":{"bool":{"must":[],"filter":[{"multi_match":{"type":"${multiMatchType}","query":"${valueSearch}","lenient":"true"}},{"range":{"@timestamp_es":{"format":"strict_date_optional_time","gte":"${setRangeGTE}","lte":"${setRangeLTE}"}}}],"should":[],"must_not":[]}},"highlight":{"pre_tags":["@kibana-highlighted-field@"],"post_tags":["@/kibana-highlighted-field@"],"fields":{"*":{}},"fragment_size":2147483647}}
    #Log To Console    ${data}
	#Log To Console    ${url}
    ${res}=    Post Api Request    ${url}    ${EMPTY}    ${headers}    ${data}
	#Log To Console    ${res}
	Sleep    5s
	[return]    ${res}
	
Get tid for Search Log
    [Arguments]    ${value_applicationName}    ${imsi_thingToken}    ${endPointName}
	#Log To Console    value_applicationName${value_applicationName}	
	#Log To Console    imsi_thingToken${imsi_thingToken}	
	${resLog}=    Post Search Log    ${URL_STAGING_AZURE_CAULDRON}    ${imsi_thingToken}    ${value_applicationName}
	Sleep    5s
	#Log To Console    resLog${resLog}	
	${total}=    Set variable    ${resLog['hits']['total']}
	#Log To Console    total${total}  
	@{valArrData}=    Create List
	FOR    ${i}    IN RANGE    ${total}
	    #Log To Console    ${i}  
	    ${valLog}=    Set variable    ${resLo g['hits']['hits'][${i}]['_source']['cauldron']}
	    #Log To Console    applicationName${valLog['applicationName']}
	    #Log To Console    valLog${valLog}
		
	    ${applicationName}=    Set variable    ${valLog['applicationName']}
	    #Log To Console    applicationName${applicationName}
  
		Run Keyword If    '${applicationName}'=='${value_applicationName}' and '${imsi_thingToken}'!='${ASGARD_COAPAPI_VALUE_TST_F4_0_2_003_DATASEARCH}'    Append To List    ${valArrData}    ${valLog}        #Add data to array set at valArrData
		Run Keyword If    '${imsi_thingToken}'=='${ASGARD_COAPAPI_VALUE_TST_F4_0_2_003_DATASEARCH}'    Append To List    ${valArrData}    ${valLog}        #Add data to array set at valArrData
		
	    #Exit For Loop
	END
	#Log To Console    tivalArrDatad${valArrData}
    ${tid}=    Set variable    ${valArrData[0]['tid']}
	#Log To Console    tid${tid}
	${sessionId}=    Set variable    ${valArrData[0]['sessionId']}
	#Log To Console    tid${tid}
    [return]    ${tid}    ${sessionId}
	
Data Log Response
    [Arguments]    ${value_applicationName}    ${imsi_thingToken}    ${endPointName}
	#Log To Console    imsi${imsi_thingToken}	
	Sleep    2s
	${resTid}=    Get tid for Search Log    ${value_applicationName}    ${imsi_thingToken}    ${endPointName}
	
	${getTidSessionId}=    Set Variable If	'${value_applicationName}'=='${VALUE_APPLICATIONNAME_CHARGING}'    ${resTid}[1]    
	...    '${value_applicationName}'!='${VALUE_APPLICATIONNAME_CHARGING}'    ${resTid}[0]
	#${resTid}=    Get tid for Search Log    ${value_applicationName}    ${imsi_thingToken}    ${endPointName}
	#Log To Console    resTid${resTid}	
	#Log To Console    getTidSessionId${getTidSessionId}	
   
	${resLog}=    Post Search Log    ${URL_STAGING_AZURE_CAULDRON}    ${getTidSessionId}    ${value_applicationName}
    #Log To Console    resLog${resLog}	
	Sleep    5s
		
	${total}=    Set variable    ${resLog['hits']['total']}
	#Log To Console    total${total}
	
    @{valArrData}=    Create List
	@{valArrDetail}=    Create List
	@{valArrSummary}=    Create List
	FOR    ${i}    IN RANGE    ${total}
	    #Log To Console    ${i}  
	    ${valLog}=    Set variable    ${resLog['hits']['hits'][${i}]['_source']['log']}
	    #Log To Console    valLog${valLog}

	    #r use for parameter / have in data 
	    ${dataResponse}=    Evaluate    json.loads(r'''${valLog}''')    json
	    #Log To Console    dataResponse${dataResponse}
	
	    ${applicationName}=    Set variable    ${dataResponse['applicationName']}
	    #Log To Console    applicationName${applicationName}
		${logType}=    Set variable    ${dataResponse['logType']}
	    #Log To Console    logType${logType}

	    Run Keyword If    '${applicationName}'=='${value_applicationName}'    Append To List    ${valArrData}    ${dataResponse}    #Add data to array set at valArrData
		Run Keyword If    '${applicationName}'=='${value_applicationName}' and '${logType}'=='${VALUE_DETAIL}'   Append To List    ${valArrDetail}    ${dataResponse}    #Add data to array set at valArrDetail
		Run Keyword If    '${applicationName}'=='${value_applicationName}' and '${logType}'=='${VALUE_SUMMARY}'   Append To List    ${valArrSummary}    ${dataResponse}    #Add data to array set at valArrSummary
		
    END
	#Log To Console    valArrData${valArrData}  
	#Log To Console    valArrDetail${valArrDetail}  
	#Log To Console    valArrSummary${valArrSummary}  
    [return]    ${valArrData}    ${valArrDetail}    ${valArrSummary}    ${resTid}[0]    ${resTid}[1]

Check Log Detail 
    [Arguments]    ${code}    ${description}     ${data}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey} 

    #Log To Console    data${data} 
	
	${dataLogDetail}=    Log Detail Check EndPointName    ${data}
	#value ArrDetail Have EndPointName
	${valArrDetailHaveEndPointName}=    Set Variable    ${dataLogDetail}[0]
	#value ArrDetail Not Have EndPointName
	${valArrDetailNotHaveEndPointName}=    Set Variable    ${dataLogDetail}[1]
	
	Check Log Detail Have EndPointName    ${code}    ${description}     ${valArrDetailHaveEndPointName}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${SensorKey} 
	Run Keyword If    '${applicationName}'!='${VALUE_APPLICATIONNAME_COAPAPI}'    Check Log Detail Have EndPointName    ${code}    ${description}     ${valArrDetailHaveEndPointName}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${SensorKey} 
    Check Log Detail App Do Not Have EndPointName    ${code}    ${description}     ${valArrDetailNotHaveEndPointName}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey} 

	#Log To Console    thingTokenthingToken${thingToken} 	
    #[return]    ${thingToken} 
	
Log Detail Check EndPointName
    [Arguments]    ${data}
	${data_count}=    Get Length    ${data}
	#Log To Console    data_count${data_count}
    @{valArrDetailHaveEndPointName}=    Create List
	@{valArrDetailNotHaveEndPointName}=    Create List
    FOR    ${i}    IN RANGE    ${data_count}
	    ${keyCustom1}=    Set Variable   @{data[${i}]['custom1']}
		#Log To Console    ${keyCustom1}    
		${checkKeyEndPointName}=    Get Matches    ${keyCustom1}    endPointName
		${countKeyEndPointName}=    Get Length    ${checkKeyEndPointName}
		#Log To Console    checkKeyEndPointName${checkKeyEndPointName} 
		#Log To Console    countKeyEndPointName${countKeyEndPointName} 
		Run Keyword If    ${countKeyEndPointName}==1    Append To List    ${valArrDetailHaveEndPointName}    ${data}[${i}]    #Add data to array set at valArrData
		Run Keyword If    ${countKeyEndPointName}==0    Append To List    ${valArrDetailNotHaveEndPointName}    ${data}[${i}]    #Add data to array set at valArrData
		
		#${data[${i}]['custom1']['endPointName']}
	END	
	#Log To Console    valArrDetailHaveEndPointName${valArrDetailHaveEndPointName}  
	#Log To Console    valArrDetailNotHaveEndPointName${valArrDetailNotHaveEndPointName}  
	[return]    ${valArrDetailHaveEndPointName}    ${valArrDetailNotHaveEndPointName}

Set ThingToken CoapAPP
    [Arguments]    ${data}    ${field}
	#Log To Console    data${data} 
	#json.loads 2 round because data have \\
	${resp_json}=    Evaluate    json.loads(r'''${data}''')    json
	#Log To Console    resp_json${resp_json}
	${resp_json2}=    Evaluate    json.loads(r'''${resp_json}''')    json
	#Log To Console    resp_json2${resp_json2}
	${setThingToken}=    Set Variable    ${resp_json2['${field}']}   
	Set Global Variable    ${thingToken}    ${setThingToken}    
	[return]    ${setThingToken}
	
Set ThingToken CoapAPI
    [Arguments]    ${data}    ${field}
	#Log To Console    data${data} 
	#json.loads 2 round because data have \\
	${resp_json}=    Evaluate    json.loads(r'''${data}''')    json
	#Log To Console    resp_json${resp_json}
	${setThingToken}=    Set Variable    ${resp_json['${field}']}   
	Set Global Variable    ${thingToken}    ${setThingToken}    
	[return]    ${setThingToken}
	
Set ThingToken MQTT
    [Arguments]    ${data}    ${field}
	#Log To Console    data${data} 	
	${resp_json}=    Evaluate    json.loads(r'''${data}''')    json
	#Log To Console    resp_json${resp_json}
	${setThingToken}=    Set Variable    ${resp_json['${field}']}   
	#Log To Console    setThingToken${setThingToken}
	Set Global Variable    ${thingToken}    ${setThingToken}    
	[return]    ${setThingToken}

#-------------------------------------------- Check Log Detail Have EndPointName --------------------------------------------#	
Check Log Detail Have EndPointName  
    [Arguments]    ${code}    ${description}     ${data}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${SensorKey} 
    ${data_count}=    Get Length    ${data}
	#Log To Console    data_count${data_count}  
	FOR    ${i}    IN RANGE    ${data_count}
		
		#Log To Console    ${data[${i}]['custom1']['requestObject']}
		#Log To Console    ${data[${i}]['custom1']['endPointName']}
		#Log To Console    ${code}
		
		#for set thingToken
		Run Keyword If    '${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}'=='${cmdName}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Set ThingToken CoapAPP    ${data[${i}]['custom1']['responseObject']}    ThingToken     	
		Run Keyword If    '${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}'=='${cmdName}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Set ThingToken MQTT    ${data[${i}]['custom1']['requestObject']}    body   
		#Log To Console    ${thingToken}  
		
	    ${dataResponse}=    Set Variable    ${data[${i}]}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}']    ${data[${i}]['systemTimestamp']}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGTYPE}']    ${VALUE_DETAIL} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGLEVEL}']    ${logLevel} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_NAMESPACE}']    ${namespace}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_APPLICATIONNAME}']    ${applicationName}
	    #Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CONTAINERID}']    ${containerId}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SESSIONID}']    ${data[${i}]['sessionId']}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_TID}']    ${data[${i}]['tid']}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME}']    ${data[${i}]['custom1']['activityLog']['startTime']} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}']    ${data[${i}]['custom1']['activityLog']['endTime']}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}']    ${data[${i}]['custom1']['activityLog']['processTime']}
        Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM2}']    ${VALUE_LOG_DETAIL_CUSTOM2}
    
	    #Custom
	    #Check endPointName
		Run Keyword If    '${DETAIL_ENDPOINTNAME_COAPAPISERVICE}'=='${data[${i}]['custom1']['endPointName']}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ENDPOINTNAME}']    ${endPointName}

		#MQTT
		Run Keyword If    '${DETAIL_ENDPOINTNAME_RABBITMQ}'=='${data[${i}]['custom1']['endPointName']}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ENDPOINTNAME}']    ${endPointName}
		        
		#Check requestObject responseObject  
		Check Log Detail Custom RequestObject and ResponseObject    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload_body}    ${SensorKey} 

	END
    #[return]    ${thingToken}
	
#-------------------------------------------- Check Log Detail : RequestObject and ResponseObject Have EndPointName --------------------------------------------#		
Check Log Detail Custom RequestObject and ResponseObject
	[Arguments]    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload_body}    ${SensorKey}  
	#-------------------------------------------- Coapp App --------------------------------------------#
	#RequestObject : Coapp App [Register]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}'    Check RequestObject Success CoapAPP Register    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}
	#ResponseObject : Coapp App [Register]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject Success CoapAPP Register    ${code}    ${description}    ${dataResponse}
	
	#RequestObject : Coapp App [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT}'    Check RequestObject Success CoapAPP Report    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload_body}
	#ResponseObject : Coapp App [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject Success CoapAPP Report    ${code}    ${description}    ${dataResponse}   
	
	#RequestObject : Coapp App [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}'    Check RequestObject Success CoapAPP Config    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload_body}
	#ResponseObject : Coapp App [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject Success CoapAPP Config    ${code}    ${description}    ${dataResponse}    ${urlCmdName}   
	
	#RequestObject : Coapp App [Delta]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_DELTA}'    Check RequestObject Success CoapAPP Delta    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload_body}
	#ResponseObject : Coapp App [Delta]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_DELTA}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject Success CoapAPP Delta    ${code}    ${description}    ${dataResponse}    ${payload_body}   
	
	#Error !20000
	Run Keyword If    '${code}'!='${VALUE_LOG_CODE_20000}'    Check ResponseObject Error    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_CMDNAME_ERROR}    ${code}    ${description}    ${dataResponse}
	
	#-------------------------------------------- Coapp Api --------------------------------------------#	
	
	#ResponseObject : Coapp Api [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_POST_REPORT}'    Check RequestObject Success CoapAPI Report    ${dataResponse}    ${urlCmdName}    ${tid}    ${payload_body}
	#ResponseObject : Coapp Api [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_POST_REPORT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_CMDNAME_REPORT}
	
	#-------------------------------------------- MQTT --------------------------------------------#
	#ResponseObject : MQTT [Register]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}'    Check RequestObject Success MQTT Register    ${dataResponse}    ${urlCmdName}
	#ResponseObject : MQTT [Register]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_CMDNAME_REGISTER}
	
	#ResponseObject : MQTT [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT_MQTT}'    Check RequestObject Success MQTT Report    ${dataResponse}    ${urlCmdName}    ${tid}    ${payload_body}
	#ResponseObject : MQTT [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT_MQTT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_CMDNAME_REPORT}
	
	
	#ResponseObject : MQTT [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT}'    Check RequestObject Success MQTT Config    ${dataResponse}    ${urlCmdName}    ${tid}    ${payload_body}
	#ResponseObject : MQTT [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_CMDNAME_REPORT}
	
#--------------------------------------------  ResponseObject Error Have EndPointName --------------------------------------------#
Check ResponseObject Error  
    [Arguments]    ${value}    ${code}    ${description}    ${dataResponse}
	
	#${code}=    Set Variable    ${code}
	${code} =	Set Variable If    '${code}'=='${VALUE_LOG_CODE_40300}'    ${VALUE_LOG_CODE_40400}
	...    '${code}'!='${VALUE_LOG_CODE_40300}'    ${code}
	#Log To Console    code${code}

	${replaceCodeCmdName}=    Replace String    ${value}    [Code]    ${code}
	${replaceDescriptionCmdName}=    Replace String    ${replaceCodeCmdName}    [DeveloperMessage]    ${description}

	${responseObject}=    Replace String To Object    ${replaceDescriptionCmdName}
	#Log To Console    responseObjectError${responseObject}
			
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}
		
#-------------------------------------------- Check Log Detail Do Not Have EndPointName --------------------------------------------#		
Check Log Detail App Do Not Have EndPointName
    [Arguments]    ${code}    ${description}     ${data}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey} 
    ${data_count}=    Get Length    ${data}
	#Log To Console    data_count${data_count}  
	FOR    ${i}    IN RANGE    ${data_count}
	
	    ${dataResponse}=    Set Variable    ${data[${i}]}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}']    ${data[${i}]['systemTimestamp']}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGTYPE}']    ${VALUE_DETAIL} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGLEVEL}']    ${logLevel} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_NAMESPACE}']    ${namespace}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_APPLICATIONNAME}']    ${applicationName}
	    #Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CONTAINERID}']    ${containerId}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SESSIONID}']    ${data[${i}]['sessionId']}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_TID}']    ${data[${i}]['tid']}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME}']    ${data[${i}]['custom1']['activityLog']['startTime']} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}']    ${data[${i}]['custom1']['activityLog']['endTime']}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}']    ${data[${i}]['custom1']['activityLog']['processTime']}
        Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM2}']    ${VALUE_LOG_DETAIL_CUSTOM2}

		#for set thingToken
		Run Keyword If    '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_POST_REGISTER}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Set ThingToken CoapAPI    ${data[${i}]['custom1']['responseObject']}    ThingToken     	
		#Log To Console    thingToken${thingToken}
		
		Check Log Detail Custom RequestObject and ResponseObject App    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload_body}    ${pathUrl}    ${identity}    ${custom}    ${SensorKey}
				
	END
#-------------------------------------------- Check Log Detail : RequestObject and ResponseObject --------------------------------------------#		
Check Log Detail Custom RequestObject and ResponseObject App
	[Arguments]    ${code}    ${description}    ${dataResponse}    ${imsi}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload_body}    ${pathUrl}    ${identity}    ${custom}    ${SensorKey} 
	#-------------------------------------------- Coapp App --------------------------------------------#	
	#RequestObject : Coapp App [Register]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}'    Check RequestObject App Success CoapAPP Register    ${dataResponse}    ${pathUrl}
	#ResponseObject : Coapp App [Register]
	#${thingToken} received from Set Global Variable
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    "${thingToken}"
	
	#RequestObject : Coapp App [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT}'    Check RequestObject App Success CoapAPP Report    ${dataResponse}    ${pathUrl}    ${payload_body}    ${SensorKey}
	#ResponseObject : Coapp App [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    "${code}"
	
	#RequestObject : Coapp App [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}'    Check RequestObject App Success CoapAPP Config    ${dataResponse}    ${pathUrl}
	#ResponseObject : Coapp App [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject App Success CoapAPP Config    ${dataResponse}    ${urlCmdName}
	
	#RequestObject : Coapp App [Delta]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_DELTA}'    Check RequestObject App Success CoapAPP Delta    ${dataResponse}    ${pathUrl}
	#ResponseObject : Coapp App [Delta]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_DELTA}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject App Success CoapAPP Delta    ${dataResponse}    ${payload_body}
	
	#ResponseObject : Coapp App [Error !20000]
	Run Keyword If    '${code}'!='${VALUE_LOG_CODE_20000}' and '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    "${code}"
	
	#-------------------------------------------- Coapp Api --------------------------------------------#	
	#RequestObject : Coapp Api [Register]
	Run Keyword If    '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_POST_REGISTER}'    Check RequestObject App Success CoapAPI Register    ${dataResponse}    ${tid}    ${urlCmdName}    ${payload_body}    ${identity}    ${custom}    
	#ResponseObject : Coapp Api [Register]
	Run Keyword If    '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_POST_REGISTER}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject App Success CoapAPI Register    ${code}    ${description}    ${dataResponse}
	
	#RequestObject : Coapp Api [Report]
	Run Keyword If    '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_POST_REPORT}'    Check RequestObject App Success CoapAPI Report    ${dataResponse}    ${tid}    ${urlCmdName}    ${payload_body}    ${identity}    ${custom}    
	#ResponseObject : Coapp Api [Report]
	Run Keyword If    '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_POST_REPORT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject App Success CoapAPI Report    ${code}    ${description}    ${dataResponse}
	
	#RequestObject : Coapp Api [Config]
	Run Keyword If    '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_GET_CONFIG}'    Check RequestObject App Success CoapAPI Config    ${dataResponse}    ${tid}    ${urlCmdName}    ${payload_body}    ${identity}    ${custom}    
	#ResponseObject : Coapp Api [Config]
	Run Keyword If    '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_GET_CONFIG}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject App Success CoapAPI Config    ${code}    ${description}    ${dataResponse}    ${pathUrl}

	#RequestObject : Coapp Api [Delta]
	Run Keyword If    '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_GET_DELTA}'    Check RequestObject App Success CoapAPI Delta    ${dataResponse}    ${tid}    ${urlCmdName}    ${payload_body}    ${identity}    ${custom}    
	#ResponseObject : Coapp Api [Delta]
	Run Keyword If    '${cmdName}' == '${VALUE_LOG_SUMMARY_CMDNAME_GET_DELTA}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject App Success CoapAPI Delta    ${code}    ${description}    ${dataResponse}    ${pathUrl}

	#ResponseObject : Coapp Api [Error !20000]
	Run Keyword If    '${code}'!='${VALUE_LOG_CODE_20000}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_POST_REGISTER}'    Check ResponseObject Error App    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_ERROR}    ${code}    ${description}    ${dataResponse}    ${endPointName}
	Run Keyword If    '${code}'!='${VALUE_LOG_CODE_20000}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_POST_REPORT}'    Check ResponseObject Error App    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_ERROR}    ${code}    ${description}    ${dataResponse}    ${endPointName}
	Run Keyword If    '${code}'!='${VALUE_LOG_CODE_20000}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_GET_CONFIG}'    Check ResponseObject Error App    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_ERROR}    ${code}    ${description}    ${dataResponse}    ${endPointName}
	Run Keyword If    '${code}'!='${VALUE_LOG_CODE_20000}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_GET_DELTA}'    Check ResponseObject Error App    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_ERROR}    ${code}    ${description}    ${dataResponse}    ${endPointName}
	
	
	#-------------------------------------------- MQTT --------------------------------------------#
	#RequestObject : MQTT [Register]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}'    Check RequestObject App Success MQTT Register    ${dataResponse}    ${pathUrl}    ${tid}    ${payload_body}
	#ResponseObject : MQTT [Register]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_APP_REGISTER}
	
	#RequestObject : MQTT [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT_MQTT}'    Check RequestObject App Success MQTT Report    ${dataResponse}    ${pathUrl}    ${tid}    ${payload_body}    ${SensorKey}
	#ResponseObject : MQTT [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT_MQTT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_APP_REPORT}
	
	#RequestObject : MQTT [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT}'    Check RequestObject App Success MQTT Config    ${dataResponse}    ${pathUrl}    ${tid}
	#ResponseObject : MQTT [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_APP_REPORT}
	
	#ResponseObject : MQTT [Error !20000]
	Run Keyword If    '${code}'!='${VALUE_LOG_CODE_20000}' and '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_APP_ERROR}

	#-------------------------------------------- Charging --------------------------------------------#
	#RequestObject : Charging Coapp App [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_ROCSSERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_POSTCHARGING}'    Check RequestObject App Success Charging CoapAPP Report    ${dataResponse}    ${pathUrl}    ${payload_body}    ${imsi}
	#ResponseObject : Charging Coapp App [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_ROCSSERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_POSTCHARGING}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject App Success Charging CoapAPP Report    ${code}    ${description}    ${dataResponse}
	 
#--------------------------------------------  ResponseObject Error Have EndPointName --------------------------------------------#
Check ResponseObject Error App  
    [Arguments]    ${value}    ${code}    ${description}    ${dataResponse}    ${endPointName}
	
	#${code}=    Set Variable    ${code}
	${code} =	Set Variable If    '${code}'=='${VALUE_LOG_CODE_40300}'    ${VALUE_LOG_CODE_40400}
	...    '${code}'!='${VALUE_LOG_CODE_40300}'    ${code}
	#Log To Console    code${code}

	${value} =	Set Variable If    '${endPointName}'=='${ASGARD_COAPAPI_VALUE_TST_F2_1_0_008_SENSOR_INVALID}'    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_GET_ERROR}
	...    '${endPointName}'!='${ASGARD_COAPAPI_VALUE_TST_F2_1_0_008_SENSOR_INVALID}'   ${value}
	
	${value} =	Set Variable If    '${endPointName}'=='${ASGARD_COAPAPI_VALUE_TST_F3_1_0_008_SENSOR_INVALID}'    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_GET_ERROR}
	...    '${endPointName}'!='${ASGARD_COAPAPI_VALUE_TST_F3_1_0_008_SENSOR_INVALID}'   ${value}
	
	
	${replaceCodeCmdName}=    Replace String    ${value}    [Code]    ${code}
	${replaceDescriptionCmdName}=    Replace String    ${replaceCodeCmdName}    [DeveloperMessage]    ${description}

	${responseObject}=    Replace String To Object    ${replaceDescriptionCmdName}
	#Log To Console    responseObject${responseObject}
			
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}

Check Log Response 
    #resultCode_summary[20000],resultDesc_summary[20000],Code_detail[20000],Description_detail[Register is Success],applicationName,pathUrl,urlCmdName,imsi_thingToken,ipAddress,payload,namespace,containerId,identity,cmdName,endPointName,logLevel,custom,SensorKey
    [Arguments]    ${resultCode_summary}    ${resultDesc_summary}    ${code_detail}    ${description_detail}    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}    ${custom}    ${SensorKey}    
    #Log To Console    imsi_thingTokenimsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Data Log Response    ${applicationName}    ${imsi_thingToken}    ${endPointName}
	
	Check Log Detail    ${code_detail}    ${description_detail}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload_body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey} 
    Check Log Summary    ${resultCode_summary}    ${resultDesc_summary}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}
    #Log To Console    thingToken${thingToken}
    #return thingToken from set global variable
	
MQTT Check Log Response  
    #resultCode_summary[20000],resultDesc_summary[20000],Code_detail[20000],Description_detail[Register is Success],applicationName,pathUrl,urlCmdName,imsi_thingToken,ipAddress,body,namespace,containerId,identity,cmdName,endPointNameSimRegister,endPointNameCoapAPP,logLevel,valueSearchText,custom,SensorKey
    [Arguments]    ${resultCode_summary}    ${resultDesc_summary}    ${code_detail}    ${description_detail}    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${body}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}    ${valueSearchText}    ${custom}    ${SensorKey}     
    #Log To Console    imsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Data Log Response    ${applicationName}    ${valueSearchText}${imsi_thingToken}    ${endPointName}
	
	Check Log Detail    ${code_detail}    ${description_detail}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey} 
    Check Log Summary    ${resultCode_summary}    ${resultDesc_summary}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}
    #Log To Console    thingToken${thingToken}
    #return thingToken from set global variable

MQTT Check Log Response Charging  
    #resultCode_summary[20000],resultDesc_summary[20000],Code_detail[20000],Description_detail[Register is Success],applicationName,pathUrl,urlCmdName,imsi_thingToken,ipAddress,body,namespace,containerId,identity,cmdName,endPointNameSimRegister,endPointNameCoapAPP,logLevel,valueSearchText,custom,SensorKey
    [Arguments]    ${resultCode_summary}    ${resultDesc_summary}    ${code_detail}    ${description_detail}    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${body}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}    ${valueSearchText}    ${custom}    ${SensorKey}     
    #Log To Console    imsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Data Log Response    ${applicationName}    ${valueSearchText}${imsi_thingToken}    ${endPointName}
	
	#Check Log Detail    ${code_detail}    ${description_detail}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${identity}    ${custom}    ${SensorKey} 
    Check Log Summary    ${resultCode_summary}    ${resultDesc_summary}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}
    #Log To Console    thingToken${thingToken}
    #return thingToken from set global variable

Replace String To Object
    [Arguments]    ${string}
    
	${replStringToJsonStart}=    Replace String    ${string}    "{    {
	${replStringToJsonEnd}=    Replace String    ${replStringToJsonStart}    }"    }
	[RETURN]    ${replStringToJsonEnd}
	
#Check Json Data Should Be Equal
#	[Arguments]    ${JsonData}    ${field}    ${expected}
	
	#json.dumps use for parameter convert ' to "
#	${listAsString}=    Evaluate    json.dumps(${JsonData})    json
	#r use for parameter / have in data
#	${resp_json}=    Evaluate    json.loads(r'''${listAsString}''')    json
	#Log To Console    resp_json${resp_json}	
    #Should Be Equal    ${resp_json['${field}']}    ${expected}
	#Log To Console    resp_json${resp_json${field}}	
	#Log To Console    expected${expected}	
#    Should Be Equal    ${resp_json${field}}    ${expected}    error=${field}

