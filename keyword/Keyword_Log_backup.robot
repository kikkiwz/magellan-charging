*** Keywords ***	
Post Search Log
    [Arguments]    ${url}    ${valueSearch}
	${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    kbn-version=7.5.1 
    #${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    Host=azmagellancd001-iot.southeastasia.cloudapp.azure.com:30380    kbn-version=7.5.1    Origin=http://azmagellancd001-iot.southeastasia.cloudapp.azure.com:30380    
	#Log To Console    ${headers}
	
	#return valueDateGte,valueDateLte (RANGE_SEARCH 15 minutes)
	#${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    ${RANGE_SEARCH}    ${TIME_STRING_MINUTES}
	${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    50    ${TIME_STRING_MINUTES}
	#Log To Console    setRange${setRange}
	${setRangeGTE}=    Set variable    ${setRange}[0]
	${setRangeLTE}=    Set variable    ${setRange}[1]
	#Log To Console    setRangeGTE${setRangeGTE}
	#Log To Console    setRangeLTE${setRangeLTE}
				
    ${data}=    Evaluate    {"version":"true","size":500,"sort":[{"@timestamp_es":{"order":"desc","unmapped_type":"boolean"}}],"_source":{"excludes":[]},"aggs":{"2":{"date_histogram":{"field":"@timestamp_es","fixed_interval":"30s","time_zone":"Asia/Bangkok","min_doc_count":1}}},"stored_fields":["*"],"script_fields":{},"docvalue_fields":[{"field":"@timestamp_es","format":"date_time"},{"field":"cauldron.custom1.activityLog.endTime","format":"date_time"},{"field":"cauldron.custom1.activityLog.startTime","format":"date_time"},{"field":"time","format":"date_time"}],"query":{"bool":{"must":[],"filter":[{"multi_match":{"type":"best_fields","query":"${valueSearch}","lenient":"true"}},{"range":{"@timestamp_es":{"format":"strict_date_optional_time","gte":"${setRangeGTE}","lte":"${setRangeLTE}"}}}],"should":[],"must_not":[]}},"highlight":{"pre_tags":["@kibana-highlighted-field@"],"post_tags":["@/kibana-highlighted-field@"],"fields":{"*":{}},"fragment_size":2147483647}}
    Log To Console    ${data}
	#Log To Console    ${url}
    ${res}=    Post Api Request    ${url}    ${EMPTY}    ${headers}    ${data}
	#Log To Console    ${res}
	Sleep    5s
	[return]    ${res}
	
Get tid for Search Log
    [Arguments]    ${value_applicationName}    ${imsi_thingToken}    ${endPointName}
	#Log To Console    value_applicationName${value_applicationName}	
	#Log To Console    imsi_thingToken${imsi_thingToken}	
	${resLog}=    Post Search Log    ${URL_STAGING_AZURE_CAULDRON}    ${imsi_thingToken}
	Sleep    5s
	#Log To Console    resLog${resLog}	
	${total}=    Set variable    ${resLog['hits']['total']}
	#Log To Console    total${total}  
	@{valArrData}=    Create List
	FOR    ${i}    IN RANGE    ${total}
	    #Log To Console    ${i}  
	    ${valLog}=    Set variable    ${resLog['hits']['hits'][${i}]['_source']['cauldron']}
	    #Log To Console    applicationName${valLog['applicationName']}
	    #Log To Console    valLog${valLog}
		
	    ${applicationName}=    Set variable    ${valLog['applicationName']}
	    #Log To Console    applicationName${applicationName}
  
		Run Keyword If    '${applicationName}'=='${value_applicationName}'    Append To List    ${valArrData}    ${valLog}        #Add data to array set at valArrData
		
	    #Exit For Loop
	END
	#Log To Console    tivalArrDatad${valArrData}
    ${tid}=    Set variable    ${valArrData[0]['tid']}
	#Log To Console    tid${tid}
    [return]    ${tid}
	
Data Log Response
    [Arguments]    ${value_applicationName}    ${imsi_thingToken}    ${endPointName}
	#Log To Console    imsi${imsi_thingToken}	
	Sleep    2s
	${resTid}=    Get tid for Search Log    ${value_applicationName}    ${imsi_thingToken}    ${endPointName}
	#Log To Console    resTid${resTid}	
	${resLog}=    Post Search Log    ${URL_STAGING_AZURE_CAULDRON}    ${resTid}
    #Log To Console    resLog${resLog}	
	Sleep    5s
		
	${total}=    Set variable    ${resLog['hits']['total']}
	Log To Console    total${total}
	
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
	Log To Console    valArrDetail${valArrDetail}  
	Log To Console    valArrSummary${valArrSummary}  
    [return]    ${valArrData}    ${valArrDetail}    ${valArrSummary}    ${resTid}

Check Log Detail 
    [Arguments]    ${code}    ${description}     ${data}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}

    #Log To Console    data${data} 
	
	${dataLogDetail}=    Log Detail Check EndPointName    ${data}
	#value ArrDetail Have EndPointName
	${valArrDetailHaveEndPointName}=    Set Variable    ${dataLogDetail}[0]
	#value ArrDetail Not Have EndPointName
	${valArrDetailNotHaveEndPointName}=    Set Variable    ${dataLogDetail}[1]
	
	${thingToken}=    Check Log Detail Have EndPointName    ${code}    ${description}     ${valArrDetailHaveEndPointName}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}
    Check Log Detail App Do Not Have EndPointName    ${code}    ${description}     ${valArrDetailNotHaveEndPointName}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}
    
	#Log To Console    thingTokenthingToken${thingToken} 	
    [return]    ${thingToken} 
	
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
	Log To Console    data${data} 
	#json.loads 2 round because data have \\
	${resp_json}=    Evaluate    json.loads(r'''${data}''')    json
	Log To Console    resp_json${resp_json}
	${resp_json2}=    Evaluate    json.loads(r'''${resp_json}''')    json
	Log To Console    resp_json2${resp_json2}
	${setThingToken}=    Set Variable    ${resp_json2['${field}']}   
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
    [Arguments]    ${code}    ${description}     ${data}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}
    ${data_count}=    Get Length    ${data}
	#Log To Console    data_count${data_count}  
	FOR    ${i}    IN RANGE    ${data_count}
		
		Log To Console    ${data[${i}]['custom1']['requestObject']}
		Log To Console    ${data[${i}]['custom1']['endPointName']}
		Log To Console    ${code}
		
		${thingToken}=    Run Keyword If    '${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}'=='${cmdName}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Set ThingToken CoapAPP    ${data[${i}]['custom1']['responseObject']}    ThingToken     	
		${thingToken}=    Run Keyword If    '${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}'=='${cmdName}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Set ThingToken MQTT    ${data[${i}]['custom1']['requestObject']}    body   
	
		#Log To Console    ${thingToken}  
		
	    ${dataResponse}=    Set Variable    ${data[${i}]}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}']    ${data[${i}]['systemTimestamp']}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGTYPE}']    ${VALUE_DETAIL} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGLEVEL}']    ${logLevel} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_NAMESPACE}']    ${namespace}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_APPLICATIONNAME}']    ${applicationName}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CONTAINERID}']    ${containerId}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SESSIONID}']    ${tid}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_TID}']    ${tid}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME}']    ${data[${i}]['custom1']['activityLog']['startTime']} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}']    ${data[${i}]['custom1']['activityLog']['endTime']}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}']    ${data[${i}]['custom1']['activityLog']['processTime']}
        Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM2}']    ${VALUE_LOG_DETAIL_CUSTOM2}
    
	    #Custom
	    #Check endPointName
		#Log To Console    ${data[${i}]['custom1']['endPointName']}
	    #Run Keyword If    '${DETAIL_ENDPOINTNAME_SIMREGISTER}'=='${data[${i}]['custom1']['endPointName']}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ENDPOINTNAME}']    ${endPointName}
		Run Keyword If    '${DETAIL_ENDPOINTNAME_COAPAPISERVICE}'=='${data[${i}]['custom1']['endPointName']}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ENDPOINTNAME}']    ${endPointName}
		#Run Keyword If    '${DETAIL_ENDPOINTNAME_SIMREPORT}'=='${data[${i}]['custom1']['endPointName']}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ENDPOINTNAME}']    ${endPointName}
		
		#MQTT
		#Run Keyword If    '${DETAIL_ENDPOINTNAME_RABBITMQ}'=='${data[${i}]['custom1']['endPointName']}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ENDPOINTNAME}']    ${endPointName}
		        
		#Check requestObject responseObject  
		Check Log Detail Custom RequestObject and ResponseObject    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload} 
		#Run Keyword If    '${DETAIL_ENDPOINTNAME_SIMREGISTER}'=='${data[${i}]['custom1']['endPointName']}' and '${endPointName}'=='${data[${i}]['custom1']['endPointName']}'    Check Log Detail Custom RequestObject and ResponseObject CmdName    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${imsi_thingToken}    ${tid}    ${urlCmdName}    ${endPointName}    ${payload} 
		#Run Keyword If    '${DETAIL_ENDPOINTNAME_COAPAPISERVICE}'=='${data[${i}]['custom1']['endPointName']}'    Check Log Detail Custom RequestObject and ResponseObject App    ${code}    ${dataResponse}    ${pathUrl}    ${payload}    ${imsi_thingToken}    ${endPointName}     
		#Run Keyword If    '${DETAIL_ENDPOINTNAME_SIMREPORT}'=='${data[${i}]['custom1']['endPointName']}'  and '${endPointName}'=='${data[${i}]['custom1']['endPointName']}'    Check Log Detail Custom RequestObject and ResponseObject CmdName    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${imsi_thingToken}    ${tid}    ${urlCmdName}    ${endPointName}    ${payload}    
		#Run Keyword If    Check Log Detail Custom RequestObject and ResponseObject App    ${code}    ${dataResponse}    ${pathUrl}    ${payload}    ${imsi_thingToken}    ${endPointName}     
	 
	    #Run Keyword If    '${DETAIL_ENDPOINTNAME_SIMREGISTER}'=='${data[${i}]['custom1']['endPointName']}' and '${endPointName}'=='${data[${i}]['custom1']['endPointName']}'    Check Log Detail Custom RequestObject and ResponseObject CmdName    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${thingToken}    ${tid}    ${urlCmdName}    ${endPointName}    ${payload} 
		#Run Keyword If    '${DETAIL_ENDPOINTNAME_SIMREPORT}'=='${data[${i}]['custom1']['endPointName']}' and '${endPointName}'=='${data[${i}]['custom1']['endPointName']}'    Check Log Detail Custom RequestObject and ResponseObject CmdName    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${imsi_thingToken}    ${tid}    ${urlCmdName}    ${endPointName}    ${payload}    
		
	END
    [return]    ${thingToken}
	
#-------------------------------------------- Check Log Detail : RequestObject and ResponseObject Have EndPointName --------------------------------------------#		
Check Log Detail Custom RequestObject and ResponseObject
	[Arguments]    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload} 
	    #RequestObject : Coapp App [Register]
		Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}'    Check RequestObject Success CoapAPP Register    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}

		#ResponseObject : Coapp App [Register]
		Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject Success CoapAPP Register    ${code}    ${description}    ${dataResponse}
		Run Keyword If    '${code}'!='${VALUE_LOG_CODE_20000}'    Check ResponseObject Error    ${VALUE_LOG_DETAIL_REPONSEOBJECT_COAPAPP_CMDNAME_REGISTER_ERROR}    ${code}    ${description}    ${dataResponse}
        
		#RequestObject : Coapp App [Report]
		Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT}'    Check RequestObject Success CoapAPP Report    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload}
		#ResponseObject : Coapp App [Report]
		Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject Success CoapAPP Report    ${code}    ${description}    ${dataResponse}   
		
		#RequestObject : Coapp App [Config]
		Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}'    Check RequestObject Success CoapAPP Config    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload}
		#ResponseObject : Coapp App [Config]
		Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject Success CoapAPP Config    ${code}    ${description}    ${dataResponse}    ${urlCmdName}   
		
		#RequestObject : Coapp App [Delta]
		Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_DELTA}'    Check RequestObject Success CoapAPP Delta    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload}
		#ResponseObject : Coapp App [Delta]
		Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_DELTA}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject Success CoapAPP Delta    ${code}    ${description}    ${dataResponse}    ${payload}   
		

		#ResponseObject : MQTT [Register]
		#Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject Success Register    ${code}    ${description}    ${dataResponse}    ${thingToken}    
#		Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_RABBITMQ}' and '${code}'!='${VALUE_LOG_CODE_20000}'    Check ResponseObject Error    ${VALUE_LOG_DETAIL_REPONSEOBJECT_COAPAPP_CMDNAME_REGISTER_ERROR}    ${code}    ${description}    ${dataResponse}    ${thingToken}    ${payload}     
        
#-------------------------------------------- CoapAPP Register Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Register : CoapAPPRequestObject Have EndPointName --------------------------------------------#	
Check RequestObject Success CoapAPP Register
        [Arguments]    ${dataResponse}    ${imsi}    ${ipAddress}    ${tid}    ${urlCmdName}
		#"{\"url\":\"[urlCmdName]\",\"method\":\"POST\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"body\":{\"Imsi\":\"[IMSI]\",\"IpAddress\":\"[IPADDRESS]\"}}"
		${replaceUrlCmdName}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_REGISTER}    [urlCmdName]    ${urlCmdName}
		${replacexAis}=    Replace String    ${replaceUrlCmdName}    [tid]    ${tid}
		${replaceIMSI}=    Replace String    ${replacexAis}    [IMSI]    ${imsi}
	    ${replaceIPAddress}=    Replace String    ${replaceIMSI}    [IPADDRESS]    ${ipAddress}
	    ${requestObject}=    Replace String To Object    ${replaceIPAddress}
		Log To Console    requestObjectRegister${requestObject}
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}
#-------------------------------------------- CoapAPP Register : ResponseObject Success Have EndPointName --------------------------------------------#		    
Check ResponseObject Success CoapAPP Register
    [Arguments]    ${code}    ${description}    ${dataResponse}
		#"\"{\\\"ThingToken\\\":\\\"[ThingToken]\\\",\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""
	    #${thingToken} received from Set Global Variable
		${replaceThingToken}=    Replace String    ${VALUE_LOG_DETAIL_REPONSEOBJECT_COAPAPP_CMDNAME_REGISTER}    [ThingToken]    ${thingToken}
		${replaceCode}=    Replace String    ${replaceThingToken}    [Code]    ${code}
		${replaceDescriptionCmdName}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
		${responseObject}=    Replace String To Object    ${replaceDescriptionCmdName}
		Log To Console    responseObjectRegister${responseObject}
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}

#-------------------------------------------- CoapAPP Report Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Report : RequestObject Have EndPointName --------------------------------------------#	
Check RequestObject Success CoapAPP Report
        [Arguments]    ${dataResponse}    ${thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload}
		#"{\"url\":\"[urlCmdName]\",\"method\":\"POST\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"body\":{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\",\"Payloads\":[Payload],\"UnixTimestampMs\":[tid]}}"
		${replaceUrlCmdName}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_REPORT}    [urlCmdName]    ${urlCmdName}
		${replacexAis}=    Replace String    ${replaceUrlCmdName}    [tid]    ${tid}
		${replaceThingToken}=    Replace String    ${replacexAis}    [ThingToken]    ${thingToken}
		${replaceIPAddress}=    Replace String    ${replaceThingToken}    [IPADDRESS]    ${ipAddress}
		${replacePayload}=    Replace String    ${replaceIPAddress}    [Payload]    ${payload}
		${requestObject}=    Replace String To Object    ${replacePayload}
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}	
#-------------------------------------------- CoapAPP Report : ResponseObject Success Have EndPointName --------------------------------------------#		    
Check ResponseObject Success CoapAPP Report
    [Arguments]    ${code}    ${description}    ${dataResponse}  
		#"\"{\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""
		${replaceCode}=    Replace String    ${VALUE_LOG_DETAIL_REPONSEOBJECT_COAPAPP_CMDNAME_REPORT}    [Code]    ${code}
		${replaceDescription}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
		${responseObject}=    Replace String To Object    ${replaceDescription}
		#Log To Console    responseObjectReport${responseObject}
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}

#-------------------------------------------- CoapAPP Config Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Config : RequestObject Have EndPointName --------------------------------------------#	
Check RequestObject Success CoapAPP Config
        [Arguments]    ${dataResponse}    ${thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload}
		#"{\"url\":\"[urlCmdName]\",\"method\":\"GET\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"queryString\":{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\"}}"
		#"{\"url\":\"[urlCmdName]\",\"method\":\"GET\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"queryString\":[queryString]}"
		
		#"url":"api/v1/Config?ThingToken=3a154161-03c1-4119-87cf-131995dae81e&IpAddress=1.2.3.4&Sensor=Max"
		#"url":"api/v1/Config?ThingToken=d1b348dc-455b-4578-9d88-ef8f21a3467d&IpAddress=1.2.3.4"
		
		#"queryString":{"ThingToken":"3a154161-03c1-4119-87cf-131995dae81e","IpAddress":"1.2.3.4"}}
		#"queryString":{"ThingToken":"3a154161-03c1-4119-87cf-131995dae81e","IpAddress":"1.2.3.4","Sensor":"Max"}}
		
		${splitUrl} =    Split String    ${urlCmdName}    &    2
        Log To Console    splitUrl${splitUrl}
		${data_count}=    Get Length    ${splitUrl}
		Log To Console    data_count${data_count}
		${setSensor}=    Set Variable If    ${data_count} == 3    ${splitUrl}[2]    ${EMPTY}     
	    ${removeSensor}=    Remove String    ${setSensor}    Sensor=   
        ${valueSensor}=    Set Variable    ${removeSensor}
		Log To Console    valueSensor${valueSensor}
		
		#{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\"}
		${replaceThingToken}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_QUERYSTRING_CONFIG}    [ThingToken]    ${thingToken}
		${replaceIPAddress}=    Replace String    ${replaceThingToken}    [IPADDRESS]    ${ipAddress}
		
		#{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\",\"Sensor\":\"[Sensor]\"}
		${replaceThingTokenSensor}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_QUERYSTRING_SENSOR_CONFIG}    [ThingToken]    ${thingToken}
		${replaceIPAddressSensor}=    Replace String    ${replaceThingTokenSensor}    [IPADDRESS]    ${ipAddress}
		${replaceSensor}=    Replace String    ${replaceIPAddressSensor}    [Sensor]    ${valueSensor}
		
		${valQueryString}=    Set Variable If    ${data_count} == 2    ${replaceIPAddress}    ${replaceSensor}
	    #Log To Console    var1Payload${var1Payload}
		${replaceUrlCmdName}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_CONFIG}    [urlCmdName]    ${urlCmdName}
		${replacexAis}=    Replace String    ${replaceUrlCmdName}    [tid]    ${tid}
		${replaceQueryString}=    Replace String    ${replacexAis}    [queryString]    ${valQueryString}
		${requestObject}=    Replace String To Object    ${replaceQueryString}
		Log To Console    requestObjectConfig${requestObject}
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}		
#------------------------------------------- CoapAPP Config : ResponseObject Success Have EndPointName --------------------------------------------#		    
Check ResponseObject Success CoapAPP Config
    [Arguments]    ${code}    ${description}    ${dataResponse}    ${urlCmdName}  
	#"\"{\\\"Datas\\\":[Datas],\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""
	#"Datas":{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\",\\\"Max\\\":\\\"[valueMax]\\\"}
	#"Datas":{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\"}
	#"Datas":{\\\"Max\\\":\\\"[valueMax]\\\"}
	
	${splitUrl} =    Split String    ${urlCmdName}    &    2
	Log To Console    splitUrl${splitUrl}
	${data_count}=    Get Length    ${splitUrl}
	Log To Console    data_count${data_count}
	
	${setSensor}=    Set Variable If    ${data_count} == 3    ${splitUrl}[2]    ${EMPTY}     
	${removeSensor}=    Remove String    ${setSensor}    Sensor=   
    ${valueSensor}=    Set Variable    ${removeSensor}
    Log To Console    valueSensor${valueSensor}
	
	#{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\",\\\"Max\\\":\\\"[valueMax]\\\"}
	${replaceRefreshTimeAll}=    Replace String    ${VALUE_LOG_DETAIL_REPONSEOBJECT_COAPAPP_DATASALL_CONFIG}    [valueRefreshTime]    ${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}
	${replaceMaxAll}=    Replace String    ${replaceRefreshTimeAll}    [valueMax]    ${VALUE_CONFIGINFO_KEY_MAX_VALUE}
	
	#{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\"}
	${replaceRefreshTime}=    Replace String    ${VALUE_LOG_DETAIL_REPONSEOBJECT_COAPAPP_DATASREFRESHTIME_CONFIG}    [valueRefreshTime]    ${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}
	
	#{\\\"Max\\\":\\\"[valueMax]\\\"}
	${replaceMax}=    Replace String    ${VALUE_LOG_DETAIL_REPONSEOBJECT_COAPAPP_DATASMAX_CONFIG}    [valueMax]    ${VALUE_CONFIGINFO_KEY_MAX_VALUE}		
	
	${valDatas}=    Set Variable If    ${data_count} == 2    ${replaceMaxAll}
	...    ${data_count} == 3 and "${valueSensor}" == "${VALUE_CONFIGINFO_KEY_MAX}"     ${replaceMax}
	...    ${data_count} == 3 and "${valueSensor}" == "${VALUE_CONFIGINFO_KEY_REFRESHTIME}"     ${replaceRefreshTime} 
	Log To Console    valDatas${valDatas}
	
	${replaceCode}=    Replace String    ${VALUE_LOG_DETAIL_REPONSEOBJECT_COAPAPP_CMDNAME_CONFIG}    [Code]    ${code}
	${replaceDescription}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
	${replaceDatas}=    Replace String    ${replaceDescription}    [Datas]    ${valDatas}
	${responseObject}=    Replace String To Object    ${replaceDatas}
	Log To Console    responseObjectConfig${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}
	
#-------------------------------------------- CoapAPP Delta Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Delta : RequestObject Have EndPointName --------------------------------------------#	
Check RequestObject Success CoapAPP Delta
        [Arguments]    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${payload}
		#"{\"url\":\"[urlCmdName]\",\"method\":\"GET\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"queryString\":{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\"}}"
		
		#"url":"api/v1/Delta?ThingToken=07b8df19-c85c-4381-9eae-3563aa6724ed&IpAddress=1.2.3.4\"
		#"url":"api/v1/Delta?ThingToken=8ba1f4bb-0ffc-42f9-b234-ceca95f171c1&IpAddress=1.2.3.4&Sensor=Temp"
		
		#"queryString":{"ThingToken":"3a154161-03c1-4119-87cf-131995dae81e","IpAddress":"1.2.3.4"}}
		#"queryString":{"ThingToken":"3a154161-03c1-4119-87cf-131995dae81e","IpAddress":"1.2.3.4","Sensor":"Temp"}}
		
		${splitUrl} =    Split String    ${urlCmdName}    &    2
        Log To Console    splitUrl${splitUrl}
		${data_count}=    Get Length    ${splitUrl}
		Log To Console    data_count${data_count}
		${setSensor}=    Set Variable If    ${data_count} == 3    ${splitUrl}[2]    ${EMPTY}     
	    ${removeSensor}=    Remove String    ${setSensor}    Sensor=   
        ${valueSensor}=    Set Variable    ${removeSensor}
		Log To Console    valueSensor${valueSensor}
		
		#{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\"}
		${replaceThingToken}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_QUERYSTRING_DELTA}    [ThingToken]    ${imsi_thingToken}
		${replaceIPAddress}=    Replace String    ${replaceThingToken}    [IPADDRESS]    ${ipAddress}
		
		#{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\",\"Sensor\":\"[Sensor]\"}
		${replaceThingTokenSensor}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_QUERYSTRING_SENSOR_DELTA}    [ThingToken]    ${imsi_thingToken}
		${replaceIPAddressSensor}=    Replace String    ${replaceThingTokenSensor}    [IPADDRESS]    ${ipAddress}
		${replaceSensor}=    Replace String    ${replaceIPAddressSensor}    [Sensor]    ${valueSensor}
		
		${valQueryString}=    Set Variable If    ${data_count} == 2    ${replaceIPAddress}    ${replaceSensor}
	    #Log To Console    var1Payload${var1Payload}
		${replaceUrlCmdName}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_CONFIG}    [urlCmdName]    ${urlCmdName}
		${replacexAis}=    Replace String    ${replaceUrlCmdName}    [tid]    ${tid}
		${replaceQueryString}=    Replace String    ${replacexAis}    [queryString]    ${valQueryString}
		${requestObject}=    Replace String To Object    ${replaceQueryString}
		Log To Console    requestObjectDelta${requestObject}
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}		
#------------------------------------------- CoapAPP Delta : ResponseObject Success Have EndPointName --------------------------------------------#		    
Check ResponseObject Success CoapAPP Delta
    [Arguments]    ${code}    ${description}    ${dataResponse}    ${payload} 
	#"\"{\\\"Datas\\\":[Datas],\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""
	#"Datas":{\\\"Temp\\\":\\\"883\\\"}
	
	${valDatas}=    Convert JSON To String    ${payload}    
	Log To Console    valDatas${valDatas}
	
	${replaceCode}=    Replace String    ${VALUE_LOG_DETAIL_REPONSEOBJECT_COAPAPP_CMDNAME_CONFIG}    [Code]    ${code}
	${replaceDescription}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
	${replaceDatas}=    Replace String    ${replaceDescription}    [Datas]    ${valDatas}
	
	${responseObject}=    Replace String To Object    ${replaceDatas}
	Log To Console    responseObjectDelta${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}

#--------------------------------------------  ResponseObject Error --------------------------------------------#
Check ResponseObject Error  
    [Arguments]    ${value}    ${code}    ${description}    ${dataResponse}
	
	#${code}=    Set Variable    ${code}
	${code} =	Set Variable If    '${code}'=='${VALUE_LOG_CODE_40300}'    ${VALUE_LOG_CODE_40400}
	...    '${code}'!='${VALUE_LOG_CODE_40300}'    ${code}
	#Log To Console    code${code}

	${replaceCodeCmdName}=    Replace String    ${value}    [Code]    ${code}
	${replaceDescriptionCmdName}=    Replace String    ${replaceCodeCmdName}    [DeveloperMessage]    ${description}

	${responseObject}=    Replace String To Object    ${replaceDescriptionCmdName}
	Log To Console    responseObjectError${responseObject}
			
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}
		
#-------------------------------------------- Check Log Detail Do Not Have EndPointName --------------------------------------------#		
Check Log Detail App Do Not Have EndPointName
    [Arguments]    ${code}    ${description}     ${data}    ${tid}    ${applicationName}     ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}
    ${data_count}=    Get Length    ${data}
	#Log To Console    data_count${data_count}  
	FOR    ${i}    IN RANGE    ${data_count}
	
	    ${dataResponse}=    Set Variable    ${data[${i}]}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}']    ${data[${i}]['systemTimestamp']}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGTYPE}']    ${VALUE_DETAIL} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGLEVEL}']    ${logLevel} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_NAMESPACE}']    ${namespace}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_APPLICATIONNAME}']    ${applicationName}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CONTAINERID}']    ${containerId}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SESSIONID}']    ${tid}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_TID}']    ${tid}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME}']    ${data[${i}]['custom1']['activityLog']['startTime']} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}']    ${data[${i}]['custom1']['activityLog']['endTime']}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}']    ${data[${i}]['custom1']['activityLog']['processTime']}
        Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM2}']    ${VALUE_LOG_DETAIL_CUSTOM2}

		Check Log Detail Custom RequestObject and ResponseObject App    ${code}    ${description}    ${dataResponse}    ${imsi_thingToken}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload}    ${pathUrl} 
				
	END
#-------------------------------------------- Check Log Detail : RequestObject and ResponseObject --------------------------------------------#		
Check Log Detail Custom RequestObject and ResponseObject App
	[Arguments]    ${code}    ${description}    ${dataResponse}    ${imsi}    ${ipAddress}    ${tid}    ${urlCmdName}    ${cmdName}    ${endPointName}    ${payload}    ${pathUrl} 
	#RequestObject : Coapp App [Register]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check RequestObject App Success CoapAPP Register    ${dataResponse}    ${pathUrl}
	#ResponseObject : Coapp App [Register]
	#${thingToken} received from Set Global Variable
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    "${thingToken}"
	
	#RequestObject : Coapp App [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check RequestObject App Success CoapAPP Report    ${dataResponse}    ${pathUrl}    ${payload}
	#ResponseObject : Coapp App [Report]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_REPORT}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    "${code}"
	
	#RequestObject : Coapp App [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check RequestObject App Success CoapAPP Config    ${dataResponse}    ${pathUrl}
	#ResponseObject : Coapp App [Config]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject App Success CoapAPP Config    ${dataResponse}    ${urlCmdName}
	
	#RequestObject : Coapp App [Delta]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_DELTA}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check RequestObject App Success CoapAPP Delta    ${dataResponse}    ${pathUrl}
	#ResponseObject : Coapp App [Delta]
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_COAPAPISERVICE}' and '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_DELTA}' and '${code}'=='${VALUE_LOG_CODE_20000}'    Check ResponseObject App Success CoapAPP Delta    ${dataResponse}    ${payload}
	
	
	
	#!20000
	Run Keyword If    '${code}'!='${VALUE_LOG_CODE_20000}'    Check Json Data Should Be Equal    ${dataResponse}     ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    "${code}"

#-------------------------------------------- CoapAPP Register Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Register : CoapAPPRequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success CoapAPP Register 
    [Arguments]    ${dataResponse}    ${pathUrl}
	#"{\"url\":\"coap://localhost[valuePathUrl]\"}"
	${replaceUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_APP_REGISTER}    [valuePathUrl]    ${pathUrl}
	${requestObject}=    Replace String To Object    ${replaceUrl}
	Log To Console    RegisterRequestObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}

#-------------------------------------------- CoapAPP Report Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Report : CoapAPPRequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success CoapAPP Report
	[Arguments]    ${dataResponse}    ${pathUrl}    ${payload}
	#"{\"url\":\"coap://localhost[valuePathUrl]\",\"body\":[body]}"
	${resp_json}=    Evaluate    json.loads(r'''${payload}''')    json
	${payloadValue}=    Set Variable    ${resp_json['${VALUE_SENSORKEY}']}
	
	#Log To Console    ReportrequestObjectApp
	${splitUrl} =    Split String    ${pathUrl}    ?    1
	#Log To Console    splitUrl${splitUrl}
	${data_count}=    Get Length    ${splitUrl}
	#Log To Console    data_count${data_count}
	${replacePayloadToString}=    Convert JSON To String    ${payload}   
	${valPayload}=    Set Variable If    ${data_count} == 1    ${replacePayloadToString}    ${payloadValue}
	#Log To Console    valPayload${valPayload}
	
	#Log To Console    replacePayloadToString${replacePayloadToString}
	${replaceUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_APP_REPORT}    [valuePathUrl]    ${pathUrl}
	${replaceBody}=    Replace String    ${replaceUrl}    [body]    "${valPayload}"
	${requestObject}=    Replace String To Object    ${replaceBody}
	Log To Console    ReportRequestObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}

#-------------------------------------------- CoapAPP Config Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Config : CoapAPP RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success CoapAPP Config
	[Arguments]    ${dataResponse}    ${pathUrl}
	#"{\"url\":\"coap://localhost[valuePathUrl]\"}"
	${replaceUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_APP_CONFIG}    [valuePathUrl]    ${pathUrl}
	${requestObject}=    Replace String To Object    ${replaceUrl}
	Log To Console    ConfigRequestObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}
#-------------------------------------------- CoapAPP Config : CoapAPP ResponseObject Do Not Have EndPointName --------------------------------------------#	
Check ResponseObject App Success CoapAPP Config
	[Arguments]    ${dataResponse}    ${urlCmdName}
	#"\"[requestObject]\""
	
	${splitUrl} =    Split String    ${urlCmdName}    &    2
	Log To Console    splitUrl${splitUrl}
	${data_count}=    Get Length    ${splitUrl}
	Log To Console    data_count${data_count}
	#Log To Console    splitUrl${splitUrl}[2]
	${setSensor}=    Set Variable If    ${data_count} == 3    ${splitUrl}[2]    ${EMPTY}     
	${removeSensor}=    Remove String    ${setSensor}    Sensor=   
    ${valueSensor}=    Set Variable    ${removeSensor}
    Log To Console    valueSensor${valueSensor}
	#{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\",\\\"Max\\\":\\\"[valueMax]\\\"}
	${replaceRefreshTimeAll}=    Replace String    ${VALUE_LOG_DETAIL_REPONSEOBJECT_COAPAPP_DATASALL_CONFIG}    [valueRefreshTime]    ${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}
	${replaceMaxAll}=    Replace String    ${replaceRefreshTimeAll}    [valueMax]    ${VALUE_CONFIGINFO_KEY_MAX_VALUE}
	
	#{\\\"RefreshTime\\\":\\\"[valueRefreshTime]\\\"}
	${replaceRefreshTime}=    Replace String    ${VALUE_LOG_DETAIL_REPONSEOBJECT_COAPAPP_DATASREFRESHTIME_CONFIG}    [valueRefreshTime]    ${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}
	
	#{\\\"Max\\\":\\\"[valueMax]\\\"}
	${replaceMax}=    Replace String    ${VALUE_LOG_DETAIL_REPONSEOBJECT_COAPAPP_DATASMAX_CONFIG}    [valueMax]    ${VALUE_CONFIGINFO_KEY_MAX_VALUE}		
	
	${valRequestObject}=    Set Variable If    ${data_count} == 2    ${replaceMaxAll}
	...    ${data_count} == 3 and "${valueSensor}" == "${VALUE_CONFIGINFO_KEY_MAX}"     ${replaceMax}
	...    ${data_count} == 3 and "${valueSensor}" == "${VALUE_CONFIGINFO_KEY_REFRESHTIME}"     ${replaceRefreshTime} 
	Log To Console    valRequestObject${valRequestObject}
	
	${replaceRequestObject}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_APP_CONFIG}    [requestObject]    ${valRequestObject}
	${requestObject}=    Replace String To Object    ${replaceRequestObject}
	Log To Console    ConfigResponseObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${requestObject}

#-------------------------------------------- CoapAPP Delta Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- CoapAPP Delta : CoapAPP RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success CoapAPP Delta
	[Arguments]    ${dataResponse}    ${pathUrl}
	#"{\"url\":\"coap://localhost[valuePathUrl]\"}"
	${replaceUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_APP_CONFIG}    [valuePathUrl]    ${pathUrl}
	${requestObject}=    Replace String To Object    ${replaceUrl}
	Log To Console    DeltaRequestObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}
#-------------------------------------------- CoapAPP Delta : CoapAPP ResponseObject Do Not Have EndPointName --------------------------------------------#	
Check ResponseObject App Success CoapAPP Delta
	[Arguments]    ${dataResponse}    ${payload}
	#"\"[requestObject]\""
	  
	#${valConvertStringToJSON}=    Convert String to JSON    ${payload}  
	${requestObject}=    Convert JSON To String    ${payload}    
	
	#${requestObject}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_APP_CONFIG}    [requestObject]    ${valRequestObject}
	#${requestObject}=    Replace String To Object    ${replaceRequestObject}
	Log To Console    DeltaResponseObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${requestObject}
		
Check Log Response 
    #resultCode_summary[20000],resultDesc_summary[20000],Code_detail[20000],Description_detail[Register is Success],applicationName,pathUrl,urlCmdName,imsi_thingToken,ipAddress,payload,namespace,containerId,identity,cmdName,endPointName,logLevel
    [Arguments]    ${resultCode_summary}    ${resultDesc_summary}    ${code_detail}    ${description_detail}    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}
    #Log To Console    imsi_thingTokenimsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Data Log Response    ${applicationName}    ${imsi_thingToken}    ${endPointName}
	
	Check Log Detail    ${code_detail}    ${description_detail}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}
    Check Log Summary    ${resultCode_summary}    ${resultDesc_summary}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}
    #Log To Console    thingTokenthingTokenthingToken${thingToken}
    #return thingToken from set global variable
	
MQTT Check Log Response  
    #resultCode_summary[20000],resultDesc_summary[20000],Code_detail[20000],Description_detail[Register is Success],applicationName,pathUrl,urlCmdName,imsi_thingToken,ipAddress,payload,namespace,containerId,identity,cmdName,endPointNameSimRegister,endPointNameCoapAPP,logLevel,valueSearchText
    [Arguments]    ${resultCode_summary}    ${resultDesc_summary}    ${code_detail}    ${description_detail}    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}    ${valueSearchText}    
    #Log To Console    imsi_thingTokenimsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Data Log Response    ${applicationName}    ${valueSearchText}${imsi_thingToken}    ${endPointName}
	
	Check Log Detail    ${code_detail}    ${description_detail}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${urlCmdName}    ${imsi_thingToken}    ${ipAddress}    ${payload}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}
    Check Log Summary    ${resultCode_summary}    ${resultDesc_summary}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}
    #Log To Console    thingTokenthingTokenthingToken${thingToken}
    #return thingToken from set global variable
	
Replace String To Object
    [Arguments]    ${string}
    
	${replStringToJsonStart}=    Replace String    ${string}    "{    {
	${replStringToJsonEnd}=    Replace String    ${replStringToJsonStart}    }"    }
	[RETURN]    ${replStringToJsonEnd}
	
Check Json Data Should Be Equal
	[Arguments]    ${JsonData}    ${field}    ${expected}
	
	#json.dumps use for parameter convert ' to "
	${listAsString}=    Evaluate    json.dumps(${JsonData})    json
	#r use for parameter / have in data
	${resp_json}=    Evaluate    json.loads(r'''${listAsString}''')    json
	#Log To Console    resp_json${resp_json}	
    #Should Be Equal    ${resp_json['${field}']}    ${expected}
	#Log To Console    resp_json${resp_json${field}}	
	#Log To Console    expected${expected}	
    Should Be Equal    ${resp_json${field}}    ${expected}    error=${field}

