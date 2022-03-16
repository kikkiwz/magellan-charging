*** Variables ***
#Staging Azure Cauldron 
${URL_STAGING_AZURE_CAULDRON}    http://azmagellancd001-iot.southeastasia.cloudapp.azure.com:30380/elasticsearch/application*/_search?rest_total_hits_as_int=true&ignore_unavailable=true&ignore_throttled=true&preference=1611028262011&timeout=30000ms

#valueSearch: MQTT
${VALUE_SEARCH_REGISTER_MQTT}    register.get.sim.v1.
${VALUE_SEARCH_CONFIG_MQTT}    config.update.sim.v1.
${VALUE_SEARCH_REPORT_MQTT}    report.update.sim.v1.
${VALUE_SEARCH_DELTA_MQTT}    delta.get.sim.v1.

#log
#applicationName : CoapAPP
${VALUE_APPLICATIONNAME_COAPAPP}    Asgard.Coap.APP
#applicationName : CoapAPI
${VALUE_APPLICATIONNAME_COAPAPI}    Asgard.Coap.APIs
#applicationName : MQTT
${VALUE_APPLICATIONNAME_MQTT}    Asgard.Mqtt.V1.APP
#applicationName : Charging
${VALUE_APPLICATIONNAME_CHARGING}    Insight.Charging.APIs

#namespace
#${VALUE_LOG_NAMESPACE}    Magellan
${VALUE_LOG_NAMESPACE}    magellanstaging 
  
#containerId : CoapAPP
${VALUE_LOG_CONTAINERID_COAPAPP}    coapapp-v11
#containerId : CoapAPI
${VALUE_LOG_CONTAINERID_COAPAPI}    coapapis-v11
#containerId : MQTT
${VALUE_LOG_CONTAINERID_MQTT}    mqttv1app-v11
#containerId : Charging
${VALUE_LOG_CONTAINERID_CHARGING}    chargingapis-v11

#-------------------------------------------- Detail Log --------------------------------------------#
#endPointName : Asgard CoapAPP CoapAPI
${DETAIL_ENDPOINTNAME_COAPAPISERVICE}    CoapApiService

#${Api}

#endPointName : Asgard MQTT
${DETAIL_ENDPOINTNAME_RABBITMQ}    RabbitMQ

#endPointName : Charging
${DETAIL_ENDPOINTNAME_ROCSSERVICE}    RocsService

#log Detail
${VALUE_DETAIL}    Detail  
#field log Detail
${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}    systemTimestamp   
${FIELD_LOG_DETAIL_LOGTYPE}    logType  
${FIELD_LOG_DETAIL_LOGLEVEL}    logLevel  
${FIELD_LOG_DETAIL_NAMESPACE}    namespace  
${FIELD_LOG_DETAIL_APPLICATIONNAME}    applicationName  
${FIELD_LOG_DETAIL_CONTAINERID}    containerId
${FIELD_LOG_DETAIL_SESSIONID}    sessionId  
${FIELD_LOG_DETAIL_TID}    tid 
${FIELD_LOG_DETAIL_CUSTOM1}    custom1   
${FIELD_LOG_DETAIL_CUSTOM2}    custom2   
${FIELD_LOG_DETAIL_ENDPOINTNAME}    endPointName
${FIELD_LOG_DETAIL_REQUESTOBJECT}    requestObject
${FIELD_LOG_DETAIL_URL}    url
${FIELD_LOG_DETAIL_HEADERS}    headers
${FIELD_LOG_DETAIL_XAISORDERREF}    x-ais-OrderRef
${FIELD_LOG_DETAIL_BODY}    body
${FIELD_LOG_DETAIL_IMSI}    Imsi
${FIELD_LOG_DETAIL_IPADDRESS}    IpAddress        
${FIELD_LOG_DETAIL_RESPONSEOBJECT}    responseObject
${FIELD_LOG_DETAIL_THINGTOKEN}    ThingToken
${FIELD_LOG_DETAIL_OPERATIONSTATUS}    OperationStatus
${FIELD_LOG_DETAIL_OPERATIONSTATUS_CODE}    Code
${FIELD_LOG_DETAIL_OPERATIONSTATUS_DESCRIPTION}    Description
${FIELD_LOG_DETAIL_ACTIVITYLOG}    activityLog
${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME}    startTime
${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}    endTime
${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}    processTime

${VALUE_LOG_DETAIL_LOGLEVEL}    INFO  
${VALUE_LOG_DETAIL_CUSTOM2}    ${NONE}
${VALUE_LOG_DETAIL_VERSION}    v1

#-------------------------------------------- CoapAPP --------------------------------------------#
#value log Detail : CoapAPP
#Regiter
#\"url\":\"coap://localhost/register/sim/v1/615529797345463/1.2.3.4\"
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_APP_REGISTER}    "{\"url\":\"coap://localhost[valuePathUrl]\"}"

#\"url\":\"api/v1/Register\",\"method\":\"POST\",\"headers\":{\"x-ais-OrderRef\":\"1611649971871\",\"x-ais-SessionId\":\"1611649971871\"},\"body\":{\"Imsi\":\"615529797345463\",\"IpAddress\":\"1.2.3.4\"}
#old "{\"url\":\"http://coapapis.magellanstaging.svc.cluster.local[urlCmdName]\",\"headers\":{\"x-ais-OrderRef\":\"[x-ais-OrderRef]\"},\"body\":{\"Imsi\":\"[IMSI]\",\"IpAddress\":\"[IPADDRESS]\"}}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_REGISTER}    "{\"url\":\"[urlCmdName]\",\"method\":\"POST\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"body\":{\"Imsi\":\"[IMSI]\",\"IpAddress\":\"[IPADDRESS]\"}}"
#\"{\\\"ThingToken\\\":\\\"dd290e4c-ebde-4ec8-b8a2-1d8d79d36f5a\\\",\\\"OperationStatus\\\":{\\\"Code\\\":\\\"20000\\\",\\\"DeveloperMessage\\\":\\\"The requested operation was successfully.\\\"}}\"
#old "{\"ThingToken\":\"[ThingToken]\",\"OperationStatus\":{\"Code\":\"[Code]\",\"Description\":\"[Description]\"}}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_CMDNAME_REGISTER}    "\"{\\\"ThingToken\\\":\\\"[ThingToken]\\\",\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""

#Report
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_APP_REPORT}    "{\"url\":\"coap://localhost[valuePathUrl]\",\"body\":[body]}"

#{\"url\":\"api/v1/Report\",\"method\":\"POST\",\"headers\":{\"x-ais-OrderRef\":\"1611650009180\",\"x-ais-SessionId\":\"1611650009180\"},\"body\":{\"ThingToken\":\"dd290e4c-ebde-4ec8-b8a2-1d8d79d36f5a\",\"IpAddress\":\"1.2.3.4\",\"Payloads\":{\"Temp\":\"919\"},\"UnixTimestampMs\":1611650009180}}
#old "{\"url\":\"http://coapapis.magellanstaging.svc.cluster.local[urlCmdName]\",\"headers\":{\"x-ais-OrderRef\":\"[x-ais-OrderRef]\"},\"body\":{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\",\"Version\":\"[Version]\",\"UnixTimestampMs\":[UnixTimestampMs],\"Payload\":[Payload]}}"	  \"Payloads\":
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_REPORT}    "{\"url\":\"[urlCmdName]\",\"method\":\"POST\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"body\":{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\",\"Payloads\":[Payload],\"UnixTimestampMs\":[tid]}}"
#\"{\\\"OperationStatus\\\":{\\\"Code\\\":\\\"20000\\\",\\\"DeveloperMessage\\\":\\\"The requested operation was successfully.\\\"}}\"
#old "{\"OperationStatus\":{\"Code\":\"[Code]\",\"Description\":\"[Description]\"}}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_CMDNAME_REPORT}    "\"{\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""

#Config
#\"url\":\"coap://localhost/config/sim/v1/3343d87d-dc27-4fdb-a488-62113dc69f20/1.2.3.4\"
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_APP_CONFIG}    "{\"url\":\"coap://localhost[valuePathUrl]\"}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_APP_CONFIG}    "\"[requestObject]\""

${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_DATASALL_CONFIG}    {\\\"${VALUE_CONFIGINFO_KEY_REFRESHTIME}\\\":\\\"[valueRefreshTime]\\\",\\\"${VALUE_CONFIGINFO_KEY_MAX}\\\":\\\"[valueMax]\\\"}
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_DATASREFRESHTIME_CONFIG}    {\\\"${VALUE_CONFIGINFO_KEY_REFRESHTIME}\\\":\\\"[valueRefreshTime]\\\"}
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_DATASMAX_CONFIG}    {\\\"${VALUE_CONFIGINFO_KEY_MAX}\\\":\\\"[valueMax]\\\"}

${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_QUERYSTRING_CONFIG}    {\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\"}
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_QUERYSTRING_SENSOR_CONFIG}    {\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\",\"Sensor\":\"[Sensor]\"}

#{\"url\":\"api/v1/Config?ThingToken=3343d87d-dc27-4fdb-a488-62113dc69f20&IpAddress=1.2.3.4\",\"method\":\"GET\",\"headers\":{\"x-ais-OrderRef\":\"1611674843378\",\"x-ais-SessionId\":\"1611674843378\"},\"queryString\":{\"ThingToken\":\"3343d87d-dc27-4fdb-a488-62113dc69f20\",\"IpAddress\":\"1.2.3.4\"}}
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_CONFIG}    "{\"url\":\"[urlCmdName]\",\"method\":\"GET\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"queryString\":[queryString]}"
#\"{\\\"Datas\\\":{\\\"RefreshTime\\\":\\\"On\\\",\\\"Max\\\":\\\"99\\\"},\\\"OperationStatus\\\":{\\\"Code\\\":\\\"20000\\\",\\\"DeveloperMessage\\\":\\\"The requested operation was successfully.\\\"}}\"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_CMDNAME_CONFIG}    "\"{\\\"Datas\\\":[Datas],\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""

#Delta
#"url":"coap://localhost/delta/sim/v1/c61e7b2e-888b-4bdd-8e7b-43bc54aa9363111/1.2.3.4"
#"url":"coap://localhost/delta/sim/v1/c61e7b2e-888b-4bdd-8e7b-43bc54aa9363111/1.2.3.4?Temp"
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_APP_DELTA}    "{\"url\":\"coap://localhost[valuePathUrl]\"}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_APP_DELTA}    "\"[requestObject]\""

${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_QUERYSTRING_DELTA}    {\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\"}
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_QUERYSTRING_SENSOR_DELTA}    {\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\",\"Sensor\":\"[Sensor]\"}

#{\"url\":\"api/v1/Delta?ThingToken=08c19858-3595-432e-905d-88e4c75d05f3&IpAddress=1.2.3.4\",\"method\":\"GET\",\"headers\":{\"x-ais-OrderRef\":\"1611657800041\",\"x-ais-SessionId\":\"1611657800041\"},\"queryString\":{\"ThingToken\":\"08c19858-3595-432e-905d-88e4c75d05f3\",\"IpAddress\":\"1.2.3.4\"}}
#api/v1/Delta?ThingToken=c61e7b2e-888b-4bdd-8e7b-43bc54aa9363111&IpAddress=1.2.3.4&Sensor=Temp
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPP_CMDNAME_DELTA}    "{\"url\":\"[urlCmdName]\",\"method\":\"GET\",\"headers\":{\"x-ais-OrderRef\":\"[tid]\",\"x-ais-SessionId\":\"[tid]\"},\"queryString\":{\"ThingToken\":\"[ThingToken]\",\"IpAddress\":\"[IPADDRESS]\"}}"
#\"{\\\"Datas\\\":{\\\"Temp\\\":\\\"815\\\"},\\\"OperationStatus\\\":{\\\"Code\\\":\\\"20000\\\",\\\"DeveloperMessage\\\":\\\"The requested operation was successfully.\\\"}}\"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_CMDNAME_DELTA}    "\"{\\\"Datas\\\":{\\\"[SensorKey]\\\":\\\"[random_Sensor]\\\"},\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""

#Error
#\"{\\\"OperationStatus\\\":{\\\"Code\\\":\\\"40400\\\",\\\"DeveloperMessage\\\":\\\"The requested operation could not be found.\\\"}}\"
#old "{\"ThingToken\":null,\"OperationStatus\":{\"Code\":\"[Code]\",\"Description\":\"[Description]\"}}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPP_CMDNAME_ERROR}    "\"{\\\"OperationStatus\\\":{\\\"Code\\\":\\\"[Code]\\\",\\\"DeveloperMessage\\\":\\\"[DeveloperMessage]\\\"}}\""


#-------------------------------------------- CoapAPI --------------------------------------------#
#value log Detail : CoapAPI
#"{\"url\":\"/api/v1/Register\",\"method\":\"POST\",\"headers\":{\"Content-Type\":\"application/json\",\"Host\":\"coapapis.magellanstaging.svc.cluster.local\",\"Content-Length\":\"48\",\"x-ais-orderref\":\"1612407166218\",\"x-ais-sessionid\":\"1612407166218\",\"x-forwarded-proto\":\"http\",\"x-request-id\":\"e3d62ef0-1ebb-4a0e-b46e-fc2bc64c35f7\",\"x-b3-traceid\":\"e9ae38fb6ebc177caf672f79169c681d\",\"x-b3-spanid\":\"af672f79169c681d\",\"x-b3-sampled\":\"0\",\"identity\":\"{\\\"Imei\\\":\\\"136917648290402\\\",\\\"ThingID\\\":\\\"601b61712b49a30001e25383\\\",\\\"Imsi\\\":\\\"136917648290402\\\"}\",\"custom\":\"{\\\"Imei\\\":[\\\"136917648290402\\\"],\\\"url\\\":\\\"coapapis.magellanstaging.svc.cluster.local/api/v1/Register\\\",\\\"Imsi\\\":[\\\"136917648290402\\\"],\\\"IpAddress\\\":\\\"1.2.3.4\\\",\\\"ThingID\\\":[\\\"601b61712b49a30001e25383\\\"]}\"},\"queryString\":{},\"routeParamteters\":{},\"body\":{\"Imsi\":\"136917648290402\",\"IpAddress\":\"1.2.3.4\"}}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPI_APP_REGISTER}    "{\"url\":\"[valuePathUrl]\",\"method\":\"POST\",\"headers\":{\"Content-Type\":\"[ContentType]\",\"Host\":\"[Host]\",\"Content-Length\":\"[ContentLength]\",\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[tid]\",\"x-forwarded-proto\":\"[xForwardedProto]\",\"x-request-id\":\"[xRequestId]\",\"x-b3-traceid\":\"[xB3Traceid]\",\"x-b3-spanid\":\"[xB3Spanid]\",\"x-b3-sampled\":\"[xB3Sampled]\",\"identity\":\"[identity]\",\"custom\":\"[custom]\"},\"queryString\":{},\"routeParamteters\":{},\"body\":[body]}"
#"{\"ThingToken\":\"83bc0472-2f51-4f77-a72e-b66d46787cc6\",\"OperationStatus\":{\"Code\":\"20000\",\"DeveloperMessage\":\"The requested operation was successfully.\"}}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_REGISTER}    "{"ThingToken":"[ThingToken]","OperationStatus":{"Code":"[Code]","DeveloperMessage":"[DeveloperMessage]"}}"

#Report
#"{\"url\":\"internalreport.pub.v1.ed53e335-0d02-4487-9d66-e9ee5d323afd\",\"headers\":{\"x-ais-orderref\":\"1612435612798\",\"x-ais-sessionid\":\"1612435612798\",\"timestamp_in_ms\":\"1612435612798\",\"x_protocol\":\"CoAP\"},\"body\":\"{\\\"Temp\\\":\\\"358\\\"}\"}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPI_CMDNAME_REPORT}    "{\"url\":\"internalreport.pub.v1.[ThingToken]\",\"headers\":{\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[tid]\",\"timestamp_in_ms\":\"[tid]\",\"x_protocol\":\"CoAP\"},\"body\":\"[body]\"}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_CMDNAME_REPORT}    ""

#"{\"url\":\"/api/v1/Register\",\"method\":\"POST\",\"headers\":{\"Content-Type\":\"application/json\",\"Host\":\"coapapis.magellanstaging.svc.cluster.local\",\"Content-Length\":\"48\",\"x-ais-orderref\":\"1612407166218\",\"x-ais-sessionid\":\"1612407166218\",\"x-forwarded-proto\":\"http\",\"x-request-id\":\"e3d62ef0-1ebb-4a0e-b46e-fc2bc64c35f7\",\"x-b3-traceid\":\"e9ae38fb6ebc177caf672f79169c681d\",\"x-b3-spanid\":\"af672f79169c681d\",\"x-b3-sampled\":\"0\",\"identity\":\"{\\\"Imei\\\":\\\"136917648290402\\\",\\\"ThingID\\\":\\\"601b61712b49a30001e25383\\\",\\\"Imsi\\\":\\\"136917648290402\\\"}\",\"custom\":\"{\\\"Imei\\\":[\\\"136917648290402\\\"],\\\"url\\\":\\\"coapapis.magellanstaging.svc.cluster.local/api/v1/Register\\\",\\\"Imsi\\\":[\\\"136917648290402\\\"],\\\"IpAddress\\\":\\\"1.2.3.4\\\",\\\"ThingID\\\":[\\\"601b61712b49a30001e25383\\\"]}\"},\"queryString\":{},\"routeParamteters\":{},\"body\":{\"Imsi\":\"136917648290402\",\"IpAddress\":\"1.2.3.4\"}}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPI_APP_REPORT}    "{\"url\":\"[valuePathUrl]\",\"method\":\"POST\",\"headers\":{\"Content-Type\":\"[ContentType]\",\"Host\":\"[Host]\",\"Content-Length\":\"[ContentLength]\",\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[tid]\",\"x-forwarded-proto\":\"[xForwardedProto]\",\"x-request-id\":\"[xRequestId]\",\"x-b3-traceid\":\"[xB3Traceid]\",\"x-b3-spanid\":\"[xB3Spanid]\",\"x-b3-sampled\":\"[xB3Sampled]\",\"identity\":\"[identity]\",\"custom\":\"[custom]\"},\"queryString\":{},\"routeParamteters\":{},\"body\":[body]}"
#"{\"OperationStatus\":{\"Code\":\"20000\",\"DeveloperMessage\":\"The requested operation was successfully.\"}}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_REPORT}    "{\"OperationStatus\":{\"Code\":\"[Code]\",\"DeveloperMessage\":\"[DeveloperMessage]\"}}"

#Config
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_DATASALL_CONFIG}    {"${VALUE_CONFIGINFO_KEY_REFRESHTIME}":"[valueRefreshTime]","${VALUE_CONFIGINFO_KEY_MAX}":"[valueMax]"}
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_DATASREFRESHTIME_CONFIG}    {"${VALUE_CONFIGINFO_KEY_REFRESHTIME}":"[valueRefreshTime]"}
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_DATASMAX_CONFIG}    {"${VALUE_CONFIGINFO_KEY_MAX}":"[valueMax]"}

#"{\"url\":\"/api/v1/Config\",\"method\":\"GET\",\"headers\":{\"Host\":\"coapapis.magellanstaging.svc.cluster.local\",\"Content-Length\":\"0\",\"x-ais-orderref\":\"1612407166218\",\"x-ais-sessionid\":\"1612407166218\",\"x-forwarded-proto\":\"http\",\"x-request-id\":\"e3d62ef0-1ebb-4a0e-b46e-fc2bc64c35f7\",\"x-b3-traceid\":\"e9ae38fb6ebc177caf672f79169c681d\",\"x-b3-spanid\":\"af672f79169c681d\",\"x-b3-sampled\":\"0\",\"identity\":\"{\\\"Imei\\\":\\\"136917648290402\\\",\\\"ThingID\\\":\\\"601b61712b49a30001e25383\\\",\\\"Imsi\\\":\\\"136917648290402\\\"}\",\"custom\":\"{\\\"Imei\\\":[\\\"136917648290402\\\"],\\\"url\\\":\\\"coapapis.magellanstaging.svc.cluster.local/api/v1/Register\\\",\\\"IpAddress\\\":\\\"1.2.3.4\\\",\\\"Imsi\\\":[\\\"136917648290402\\\"],\\\"ThingID\\\":[\\\"601b61712b49a30001e25383\\\"]}\"},\"queryString\":{\"ThingToken\":\"56510508-ef77-4ea4-a8d0-4face060c036\",\"IpAddress\":\"1.2.3.4\"},\"routeParamteters\":{}}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPI_APP_CONFIG}    "{\"url\":\"[valuePathUrl]\",\"method\":\"GET\",\"headers\":{\"Host\":\"[Host]\",\"Content-Length\":\"[ContentLength]\",\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[tid]\",\"x-forwarded-proto\":\"[xForwardedProto]\",\"x-request-id\":\"[xRequestId]\",\"x-b3-traceid\":\"[xB3Traceid]\",\"x-b3-spanid\":\"[xB3Spanid]\",\"x-b3-sampled\":\"[xB3Sampled]\",\"identity\":\"[identity]\",\"custom\":\"[custom]\"},\"queryString\":[queryString],\"routeParamteters\":{}}"
#"{\"Datas\":{\"RefreshTime\":\"On\",\"Max\":\"99\"},\"OperationStatus\":{\"Code\":\"20000\",\"DeveloperMessage\":\"The requested operation was successfully.\"}}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_CONFIG}    "{\"Datas\":[Datas],\"OperationStatus\":{\"Code\":\"[Code]\",\"DeveloperMessage\":\"[DeveloperMessage]\"}}"

#Delta
#"{\"url\":\"/api/v1/Config\",\"method\":\"GET\",\"headers\":{\"Host\":\"coapapis.magellanstaging.svc.cluster.local\",\"Content-Length\":\"0\",\"x-ais-orderref\":\"1612407166218\",\"x-ais-sessionid\":\"1612407166218\",\"x-forwarded-proto\":\"http\",\"x-request-id\":\"e3d62ef0-1ebb-4a0e-b46e-fc2bc64c35f7\",\"x-b3-traceid\":\"e9ae38fb6ebc177caf672f79169c681d\",\"x-b3-spanid\":\"af672f79169c681d\",\"x-b3-sampled\":\"0\",\"identity\":\"{\\\"Imei\\\":\\\"136917648290402\\\",\\\"ThingID\\\":\\\"601b61712b49a30001e25383\\\",\\\"Imsi\\\":\\\"136917648290402\\\"}\",\"custom\":\"{\\\"Imei\\\":[\\\"136917648290402\\\"],\\\"url\\\":\\\"coapapis.magellanstaging.svc.cluster.local/api/v1/Register\\\",\\\"IpAddress\\\":\\\"1.2.3.4\\\",\\\"Imsi\\\":[\\\"136917648290402\\\"],\\\"ThingID\\\":[\\\"601b61712b49a30001e25383\\\"]}\"},\"queryString\":{\"ThingToken\":\"56510508-ef77-4ea4-a8d0-4face060c036\",\"IpAddress\":\"1.2.3.4\"},\"routeParamteters\":{}}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_COAPAPI_APP_DELTA}    "{\"url\":\"[valuePathUrl]\",\"method\":\"GET\",\"headers\":{\"Host\":\"[Host]\",\"Content-Length\":\"[ContentLength]\",\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[tid]\",\"x-forwarded-proto\":\"[xForwardedProto]\",\"x-request-id\":\"[xRequestId]\",\"x-b3-traceid\":\"[xB3Traceid]\",\"x-b3-spanid\":\"[xB3Spanid]\",\"x-b3-sampled\":\"[xB3Sampled]\",\"identity\":\"[identity]\",\"custom\":\"[custom]\"},\"queryString\":[queryString],\"routeParamteters\":{}}"
#\"{\\\"Datas\\\":{\\\"Temp\\\":\\\"815\\\"},\\\"OperationStatus\\\":{\\\"Code\\\":\\\"20000\\\",\\\"DeveloperMessage\\\":\\\"The requested operation was successfully.\\\"}}\"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_DELTA}    "{\"Datas\":[Datas],\"OperationStatus\":{\"Code\":\"[Code]\",\"DeveloperMessage\":\"[DeveloperMessage]\"}}"


#Error
#\"{\\\"OperationStatus\\\":{\\\"Code\\\":\\\"40400\\\",\\\"DeveloperMessage\\\":\\\"The requested operation could not be found.\\\"}}\"
#old "{\"ThingToken\":null,\"OperationStatus\":{\"Code\":\"[Code]\",\"Description\":\"[Description]\"}}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_ERROR}    "{"OperationStatus":{"Code":"[Code]","DeveloperMessage":"[DeveloperMessage]"}}"
#Error Config and Delta
#"{\"Datas\":null,\"OperationStatus\":{\"Code\":\"40400\",\"DeveloperMessage\":\"The requested operation could not be found.\"}}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_COAPAPI_APP_GET_ERROR}    "{"Datas":null,"OperationStatus":{"Code":"[Code]","DeveloperMessage":"[DeveloperMessage]"}}"


#-------------------------------------------- MQTT --------------------------------------------#
#value log Detail : MQTT
#Register
#"{\"url\":\"register.update.sim.v1.274612129709455.1.2.3.4\",\"headers\":{\"x-mqtt-publish-qos\":\"0\",\"x-mqtt-dup\":\"False\",\"timestamp_in_ms\":\"1612322699307\"},\"body\":\"\"}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_MQTT_APP_REGISTER}    "{\"url\":\"[valuePathUrl]\",\"headers\":{\"x-mqtt-publish-qos\":\"0\",\"x-mqtt-dup\":\"False\",\"timestamp_in_ms\":\"[tid]\"},\"body\":[body]}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_APP_REGISTER}    ""

#"{\"url\":\"register.get.sim.v1.948867257516675\",\"body\":\"9dd0ef30-a20d-4e24-a709-af15776bd663\"}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_MQTT_CMDNAME_REGISTER}    "{\"url\":\"[urlCmdName]\",\"body\":\"[body]\"}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_CMDNAME_REGISTER}    ""
#${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_CMDNAME_REGISTER_ERROR}    "{\"ThingToken\":null,\"OperationStatus\":{\"Code\":\"[Code]\",\"Description\":\"[Description]\"}}"

#Report
#"{\"url\":\"report.update.sim.v1.e34b0974-ef45-4f82-bab8-82382a84a427.1.2.3.4\",\"headers\":{\"x-mqtt-publish-qos\":\"0\",\"x-mqtt-dup\":\"False\",\"timestamp_in_ms\":\"1612322699307\"},\"body\":\"{\\\"Temp\\\":\\\"898\\\"}\"}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_MQTT_APP_REPORT}    "{\"url\":\"[valuePathUrl]\",\"headers\":{\"x-mqtt-publish-qos\":\"0\",\"x-mqtt-dup\":\"False\",\"timestamp_in_ms\":\"[tid]\"},\"body\":\"[body]\"}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_APP_REPORT}    ""

#"{\"url\":\"internalreport.pub.v1.5b49fcc6-49e9-4816-97df-588912d27a7e\",\"headers\":{\"x-ais-orderref\":\"1611634104939\",\"x-ais-sessionid\":\"1611634104939\",\"timestamp_in_ms\":\"1611634104939\"},\"body\":\"{\\\"Temp\\\":\\\"544\\\"}\"}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_MQTT_CMDNAME_REPORT}    "{\"url\":\"[urlCmdName]\",\"headers\":{\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[tid]\",\"timestamp_in_ms\":\"[tid]\"},\"body\":\"[body]\"}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_CMDNAME_REPORT}    ""

#Config
#"{\"url\":\"register.update.sim.v1.274612129709455.1.2.3.4\",\"headers\":{\"x-mqtt-publish-qos\":\"0\",\"x-mqtt-dup\":\"False\",\"timestamp_in_ms\":\"1612322699307\"},\"body\":\"\"}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_MQTT_APP_CONFIG}    "{\"url\":\"[valuePathUrl]\",\"headers\":{\"x-mqtt-publish-qos\":\"0\",\"x-mqtt-dup\":\"False\",\"timestamp_in_ms\":\"[tid]\"},\"body\":\"\"}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_APP_CONFIG}    ""

#\"url\":\"config.get.sim.v1.25938072-25de-4d6c-8b38-a7f37ab6bd01.RefreshTime\",\"body\":\"On\"
#\"url\":\"config.get.sim.v1.25938072-25de-4d6c-8b38-a7f37ab6bd01.Max\",\"body\":\"99\"
${VALUE_LOG_DETAIL_REQUESTOBJECT_MQTT_CMDNAME_CONFIG}    "{\"url\":\"[urlCmdName]\",\"body\":\"[body]\"}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_CMDNAME_CONFIG}    ""

#Error
${VALUE_LOG_DETAIL_RESPONSEOBJECT_MQTT_APP_ERROR}    ""


#-------------------------------------------- Charging --------------------------------------------#
#value log Detail : CoapAPP Charging
#Report
#"{\"url\":\"/api/v1/Charging/603605f824ef380001b9f108\",\"method\":\"POST\",\"headers\":{\"Content-Type\":\"application/json\",\"Host\":\"chargingapis.magellanstaging.svc.cluster.local\",\"Content-Length\":\"24\",\"x-ais-orderref\":\"ReportHTTP_202102241402448\",\"x-ais-sessionid\":\"1614153212381\",\"x-forwarded-proto\":\"http\",\"x-request-id\":\"a0841c07-c230-4f1c-8b48-71d83243564b\",\"x-b3-traceid\":\"d46d3e9a2b05b26895e83d80b50c8737\",\"x-b3-spanid\":\"01039a2b17e0a6cc\",\"x-b3-parentspanid\":\"95e83d80b50c8737\",\"x-b3-sampled\":\"0\"},\"queryString\":{},\"routeParamteters\":{\"ThingId\":\"603605f824ef380001b9f108\"},\"body\":{\"Payload\":{\"AA\":\"903\"}}}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_CHARGING_COAPAPP_APP_REPORT}    "{\"url\":\"[valuePathUrl]\",\"method\":\"POST\",\"headers\":{\"Content-Type\":\"[ContentType]\",\"Host\":\"[Host]\",\"Content-Length\":\"[ContentLength]\",\"x-ais-orderref\":\"[tid]\",\"x-ais-sessionid\":\"[sessionid]\",\"x-forwarded-proto\":\"[xForwardedProto]\",\"x-request-id\":\"[xRequestId]\",\"x-b3-traceid\":\"[xB3Traceid]\",\"x-b3-spanid\":\"[xB3Spanid]\",\"x-b3-parentspanid\":\"[xB3Parentspanid]\",\"x-b3-sampled\":\"[xB3Sampled]\"},\"queryString\":{},\"routeParamteters\":{\"ThingId\":\"[ThingId]\"},\"body\":{\"Payload\":[body]}}"
#"{\"OperationStatus\":{\"Code\":\"20000\",\"DeveloperMessage\":\"The requested operation was successfully.\"}}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_CHARGING_COAPAPP_REPORT}    "{\"OperationStatus\":{\"Code\":\"[Code]\",\"DeveloperMessage\":\"[DeveloperMessage]\"}}"

#-------------------------------------------- Summary Log --------------------------------------------#
${VALUE_SUMMARY}    Summary 
#field log Summary
${FIELD_LOG_SUMMARY_SYSTEMTIMESTAP}    systemTimestamp   
${FIELD_LOG_SUMMARY_LOGTYPE}    logType  
${FIELD_LOG_SUMMARY_NAMESPACE}    namespace
${FIELD_LOG_SUMMARY_APPLICATIONNAME}    applicationName
${FIELD_LOG_SUMMARY_CONTAINERID}    containerId
${FIELD_LOG_SUMMARY_SESSIONID}    sessionId
${FIELD_LOG_SUMMARY_TID}    tid 
${FIELD_LOG_SUMMARY_IDENTITY}    identity 
${FIELD_LOG_SUMMARY_CMDNAME}    cmdName  
${FIELD_LOG_SUMMARY_RESULTCODE}    resultCode  
${FIELD_LOG_SUMMARY_RESULTDESC}    resultDesc
${FIELD_LOG_SUMMARY_CUSTOM}    custom
${FIELD_LOG_SUMMARY_REQTIMESTAP}    reqTimestamp 
${FIELD_LOG_SUMMARY_RESTIMESTAMP}    resTimestamp  
${FIELD_LOG_SUMMARY_USAGETIME}    usageTime 

#value log summary  cmdName: CoapAPP
${VALUE_LOG_SUMMARY_CMDNAME_REGISTER}    Register
${VALUE_LOG_SUMMARY_CMDNAME_REPORT}    Report
${VALUE_LOG_SUMMARY_CMDNAME_CONFIG}    Config
${VALUE_LOG_SUMMARY_CMDNAME_DELTA}    Delta

#value log summary  cmdName: CoapAPI
${VALUE_LOG_SUMMARY_CMDNAME_POST_REGISTER}    Post_Register
${VALUE_LOG_SUMMARY_CMDNAME_POST_REPORT}    Post_Report
${VALUE_LOG_SUMMARY_CMDNAME_GET_CONFIG}    Get_Config
${VALUE_LOG_SUMMARY_CMDNAME_GET_DELTA}    Get_Delta

#value log summary cmdName: MQTT
${VALUE_LOG_SUMMARY_CMDNAME_REGISTER_MQTT}    register
${VALUE_LOG_SUMMARY_CMDNAME_CONFIG_MQTT}    config
${VALUE_LOG_SUMMARY_CMDNAME_REPORT_MQTT}    report
${VALUE_LOG_SUMMARY_CMDNAME_DELTA_MQTT}    delta

#value log summary  cmdName: Charging
${VALUE_LOG_SUMMARY_CMDNAME_POSTCHARGING}    PostCharging

#${VALUE_LOG_SUMMARY_IDENTITY}    ${NONE}
${VALUE_LOG_SUMMARY_IDENTITY}    


${VALUE_LOG_CODE_20000}    20000
${VALUE_LOG_CODE_40300}    40300
${VALUE_LOG_CODE_40400}    40400
${VALUE_LOG_CODE_40301}    40301
${VALUE_LOG_CODE_40305}    40305
${VALUE_LOG_CODE_40010}    40010

${VALUE_LOG_SUMMARY_RESULTDESC_OK}    OK

#MQTT
${VALUE_LOG_SUMMARY_RESULTDESC_20000_REQUESTED_OPERATION_SUCCESSFULLY}    The requested operation was successfully.

${VALUE_LOG_SUMMARY_CUSTOM}    ${NONE}

#response description CoapAPP
${VALUE_DESCRIPTION_REGISTER_SUCCESS}    Register is Success
${VALUE_DESCRIPTION_REPORT_SUCCESS}     Report is Success
${VALUE_DESCRIPTION_IS_SUCCESS}     is Success



${VALUE_DESCRIPTION_THEIMSITHINGTOKENISNOTFOUND_ERROR}    The Imsi/ThingToken is Not Found
${VALUE_DESCRIPTION_FORBIDDEN_ERROR}    Forbidden
${VALUE_DESCRIPTION_INVALIDPAYLOAD_ERROR}    InvalidPayload

${VALUE_DESCRIPTION_REQUESTED_OPERATION_COULDNOTBEFOUND_ERROR}    The requested operation could not be found.

${VALUE_DESCRIPTION_THEOPERATIONHASALREADYEXPIRED_ERROR}    The operation has already expired.
${VALUE_DESCRIPTION_THETHINGIDENTIFIERREQUESTEDALREADYEXISTS_ERROR}    The ThingIdentifier requested already exists.
${VALUE_DESCRIPTION_THETHINGTOKENREQUESTEDALREADYEXISTS_ERROR}    The thingToken requested already exists.



#response description MQTT Error
${VALUE_DESCRIPTION_ONLINECONFIGSNOTFOUND_ERROR}    OnlineConfigs not found.

