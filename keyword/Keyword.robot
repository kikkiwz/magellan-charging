*** Settings ***
Library    SikuliLibrary
Library    Collections
Library    String
Library    DateTime
Library    OperatingSystem
Library    Process
Library    BuiltIn
Library    JSONLibrary

Resource    ../keyword/Keyword_Request.robot
Resource    ../keyword/Keyword_Datetime.robot
Resource    ../keyword/Keyword_CreateData.robot
Resource    ../keyword/Keyword_RemoveData.robot
Resource    ../keyword/Keyword_UpdateData.robot
Resource    ../keyword/Keyword_InquiryData.robot
Resource    ../keyword/Keyword_Log.robot
Resource    ../keyword/Keyword_Log_Summary.robot
Resource    ../keyword/Keyword_Log_Detail_CoapApp.robot
Resource    ../keyword/Keyword_Log_Detail_CoapApi.robot
Resource    ../keyword/Keyword_Log_Detail_MQTT.robot
Resource    ../keyword/Keyword_Log_Detail_Charging.robot
Resource    ../keyword/Keyword_VerifyDB.robot

#Library Document
#https://robotframework.org/robotframework/latest/libraries/BuiltIn.html
#https://robotframework.org/robotframework/latest/libraries/String.html
#https://robotframework.org/robotframework/latest/libraries/Collections.html
#https://robotframework-thailand.github.io/robotframework-jsonlibrary/JSONLibrary.html

*** Keywords ***
####################################################
Add Needed Image Path
    Add Image Path    ${IMAGE_DIR}
	
Replace Text
    [Arguments]    ${string}    ${search_for}    ${Ireplace_withP}
	
	${replaceUrl}=    Replace String    ${string}    ${search_for}    ${replace_with}
	Log To Console    ${text}
	[RETURN]    ${text}
	
Replace Parameters Url Path
	[Arguments]    ${url}    ${urlPath}    ${ParametersField}    ${value_ParametersField}    ${ParametersField_ipAddress}    ${value_ipAddress}
	${replaceParametersUrl}=    Replace String    ${urlPath}    ${ParametersField}    ${value_ParametersField}
	#Log To Console    replaceUrl${replaceParametersUrl}
    ${replaceIPAddressUrl}=    Replace String    ${replaceParametersUrl}    ${ParametersField_ipAddress}    ${value_ipAddress}
	#Log To Console    replaceUrl${replaceIPAddressUrl}
	${url}=    Set Variable    ${url}${replaceIPAddressUrl}
	#Log To Console    ${url}
	[return]    ${url}
	
Replace Parameters Path
	[Arguments]    ${urlPath}    ${ParametersField}    ${value_ParametersField}    ${ParametersField_ipAddress}    ${value_ipAddress}
	${replaceParametersUrl}=    Replace String    ${urlPath}    ${ParametersField}    ${value_ParametersField}
	#Log To Console    replaceUrl${replaceParametersUrl}
    ${replaceIPAddressUrl}=    Replace String    ${replaceParametersUrl}    ${ParametersField_ipAddress}    ${value_ipAddress}
	#Log To Console    replaceUrl${replaceIPAddressUrl}
	${path}=    Set Variable    ${replaceIPAddressUrl}
	#Log To Console    ${path}
	[return]    ${path}	

Replace Parameters
	[Arguments]    ${urlPath}    ${ParametersField}    ${value_ParametersField}
	${replaceParametersUrl}=    Replace String    ${urlPath}    ${ParametersField}    ${value_ParametersField}
	#Log To Console    replaceUrl${replaceParametersUrl}
	${path}=    Set Variable    ${replaceParametersUrl}
	#Log To Console    ${path}
	[return]    ${path}	
	
Check Matched
    [Arguments]    ${image}
	Set Min Similarity    0.99
	${valueCheck}=    Exists    ${image}    2
	Run Keyword If    ${valueCheck} == True   Log    Pass    #Log    'PASS'
    ...    ELSE   FAIL    msg=Not Matched

Open Program  
    [Arguments]    ${program}    ${textApp}
    Double Click    ${program}
	Wait Until Screen Contain    ${textApp}    5

Select Dropdrown ENV
    [Arguments]    ${value_selectd}
	Click    ${ASGARD_COAPAP_IMAGE_DDL_ENV_IOT_DOCKERAZURE}
	Click    ${value_selectd}
	
Select Dropdrown Function
    [Arguments]    ${value_selectd}
	Click    ${ASGARD_COAPAP_IMAGE_DDL_FUNCTION_REPORT}
	Click    ${value_selectd}	
Clear Input  
    [Arguments]    ${img_input}
    Double Click    ${img_input}
	Type With Modifiers    x    KEY_CTRL	
		
Input Url 
    [Arguments]    ${img_url}    ${url}    ${img_url_null}
	Clear Input    ${img_url}
	Input Text    ${img_url_null}    ${url} 
	
Input Payload 
    [Arguments]    ${value}
	Clear Input    ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD}
	Input Text    ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NULL}    ${value}

Input Payload Textarea Null 
    [Arguments]    ${value}
	Input Text    ${ASGARD_COAPAP_IMAGE_TXTAREA_PAYLOAD_NULL}    ${value}
	
Close Program
    Click    ${ASGARD_IMAGE_BTN_CLOSE}
	
Input Value
    [Arguments]    ${img_txt_data}    ${img_txt_data_all}    ${txt}
	Double Click    ${img_txt_data}
	Input Text    ${img_txt_data_all}    ${txt}

Input Value And Clear
    [Arguments]    ${img_txt_data}    ${img_txt_data_all}    ${txt}
	#Double Click    ${img_txt_data}
	Clear Input    ${img_txt_data}
	Input Text    ${img_txt_data_all}    ${txt}
	
#for use check log and verify DB check data 
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
	
	