*** Keywords ***			
################################################################-- Do Not Have EndPointName --################################################################
#-------------------------------------------- Charging CoapAPP Report Do Not Have EndPointName --------------------------------------------#	
#-------------------------------------------- Charging CoapAPP Report : RequestObject Do Not Have EndPointName --------------------------------------------#	
Check RequestObject App Success Charging CoapAPP Report
	[Arguments]    ${dataResponse}    ${pathUrl}    ${payload_body}    ${thingId}
	#"{\"url\":\"[valuePathUrl]\",\"method\":\"POST\",\"headers\":{\"Content-Type\":\"[ContentType]\",\"Host\":\"[Host]\",\"Content-Length\":\"[ContentLength]\",\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[sessionid]\",\"x-forwarded-proto\":\"[xForwardedProto]\",\"x-request-id\":\"[xRequestId]\",\"x-b3-traceid\":\"[xB3Traceid]\",\"x-b3-spanid\":\"[xB3Spanid]\",\"x-b3-parentspanid\":\"[xB3Parentspanid]\",\"x-b3-sampled\":\"[xB3Sampled]\"},\"queryString\":{},\"routeParamteters\":{\"ThingId\":\"[ThingId]\"},\"body\":{\"Payload\":[body]}}"${resp_json}=    Evaluate    json.loads(r'''${dataResponse['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']}''')    json

	${resp_json}=    Evaluate    json.loads(r'''${dataResponse['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']}''')    json
	#Log To Console    headers${resp_json['headers']['Content-Length']}
	
	${replaceValuePathUrl}=    Replace String    ${VALUE_LOG_DETAIL_REQUESTOBJECT_CHARGING_COAPAPP_APP_REPORT}    [valuePathUrl]    ${pathUrl}
	#body
	${replacebody}=    Replace String    ${replaceValuePathUrl}    [body]    "${payload_body}"
	${replaceThingId}=    Replace String    ${replacebody}    [ThingId]    ${thingId}
	${replaceOrderref}=    Replace String    ${replaceThingId}    [tid]    ${resp_json['headers']['x-ais-orderref']}
	${replaceSessionid}=    Replace String    ${replaceOrderref}    [sessionid]    ${resp_json['headers']['x-ais-sessionid']}
	${replaceHost}=    Replace String    ${replaceSessionid}    [Host]    ${resp_json['headers']['Host']}
	${replaceContentType}=    Replace String    ${replaceHost}    [ContentType]    ${resp_json['headers']['Content-Type']}
	${replaceContentLength}=    Replace String    ${replaceContentType}    [ContentLength]    ${resp_json['headers']['Content-Length']}
	${replacexForwardedProto}=    Replace String    ${replaceContentLength}    [xForwardedProto]    ${resp_json['headers']['x-forwarded-proto']}
	${replacexRequestId}=    Replace String    ${replacexForwardedProto}    [xRequestId]    ${resp_json['headers']['x-request-id']}
	${replacexB3Traceid}=    Replace String    ${replacexRequestId}    [xB3Traceid]    ${resp_json['headers']['x-b3-traceid']}
	${replacexB3Spanid}=    Replace String    ${replacexB3Traceid}    [xB3Spanid]    ${resp_json['headers']['x-b3-spanid']}
	${replacexB3Parentspanid}=    Replace String    ${replacexB3Spanid}    [xB3Parentspanid]    ${resp_json['headers']['x-b3-parentspanid']}
	${replacexB3Sampled}=    Replace String    ${replacexB3Parentspanid}    [xB3Sampled]    ${resp_json['headers']['x-b3-sampled']}
	${requestObject}=    Replace String To Object    ${replacexB3Sampled}
	#Log To Console    requestObjectCoapAPIReport${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}
	
#-------------------------------------------- Charging CoapAPP Report : ResponseObject Success Do Not Have EndPointName --------------------------------------------#		    
Check ResponseObject App Success Charging CoapAPP Report
    [Arguments]    ${code}    ${description}    ${dataResponse}  
	#"\"{\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""
	${replaceCode}=    Replace String    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_CHARGING_COAPAPP_REPORT}    [Code]    ${code}
	${replaceDescription}=    Replace String    ${replaceCode}    [DeveloperMessage]    ${description}
	${responseObject}=    Replace String To Object    ${replaceDescription}
	#Log To Console    responseObjectReport${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}
##############################################################################################################################################################