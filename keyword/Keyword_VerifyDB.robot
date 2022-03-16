*** Keywords ***
Request Verify DB Check Data Staging Register
	#accessToken,AccountId,ThingID,thingToken
    [Arguments]    ${accessToken}   ${AccountId}    ${ThingID}    ${thingToken}
	
	${dataInquiryThing}=    Inquiry Thing    ${URL_STAGING}    ${accessToken}    ${AccountId}    ${ThingID}   
	#Log To Console    ${dataInquiryThing}
	${thingInfo}=    Set Variable    ${dataInquiryThing['ThingInfo']}
	#Log To Console    ${thingInfo} 
	
	${data_count}=    Get Length    ${thingInfo}
	#Log To Console    data_count${data_count}  
	FOR    ${i}    IN RANGE    ${data_count}
	    ${dataResponse}=    Set Variable    ${thingInfo[${i}]}
	    Check Json Data Should Be Equal    ${dataResponse}    ['ThingToken']    ${thingToken}
	END

Request Verify DB Check Data Staging Report
	#accessToken,AccountId,ThingID,Sensor
    [Arguments]    ${accessToken}   ${AccountId}    ${ThingID}    ${sensor}
	
	${dataInquiryThing}=    Inquiry Thing    ${URL_STAGING}    ${accessToken}    ${AccountId}    ${ThingID}   
	#Log To Console    ${dataInquiryThing}
	${thingInfo}=    Set Variable    ${dataInquiryThing['ThingInfo']}
	#Log To Console    ${thingInfo} 
	
	${data_count}=    Get Length    ${thingInfo}
	#Log To Console    data_count${data_count}  
	FOR    ${i}    IN RANGE    ${data_count}
	    ${dataResponse}=    Set Variable    ${thingInfo[${i}]}
		
		${jsonLoadSensor}=    Evaluate    json.loads(r'''${sensor}''')    json
	    #Log To Console    sensor${sensor}
	   
	    Check Json Data Should Be Equal    ${dataResponse}    ['StateInfo']['Report']    ${jsonLoadSensor}
	END	
	
Request Verify DB Check Data Staging Delta
	#accessToken,AccountId,ThingID,Sensor
    [Arguments]    ${accessToken}   ${AccountId}    ${ThingID}    ${sensor}
	
	${dataInquiryThing}=    Inquiry Thing    ${URL_STAGING}    ${accessToken}    ${AccountId}    ${ThingID}   
	#Log To Console    ${dataInquiryThing}
	${thingInfo}=    Set Variable    ${dataInquiryThing['ThingInfo']}
	#Log To Console    ${thingInfo} 
	
	${data_count}=    Get Length    ${thingInfo}
	#Log To Console    data_count${data_count}  
	FOR    ${i}    IN RANGE    ${data_count}
	    ${dataResponse}=    Set Variable    ${thingInfo[${i}]}
		
		${jsonLoadSensor}=    Evaluate    json.loads(r'''${sensor}''')    json
	    #Log To Console    sensor${sensor}
	   
	    Check Json Data Should Be Equal    ${dataResponse}    ['StateInfo']['Delta']    ${jsonLoadSensor}
	END	
	
Request Verify DB Check Data Staging Config
	#accessToken,AccountId,ThingID,Sensor
    [Arguments]    ${accessToken}   ${AccountId}    ${ThingID}    ${dataCheck}
	
	${dataInquiryConfigGroup}=    Inquiry ConfigGroup    ${URL_STAGING}    ${accessToken}    ${AccountId}    ${ThingID}   
	#Log To Console    ${dataInquiryConfigGroup}
	${thingInfo}=    Set Variable    ${dataInquiryConfigGroup['ConfigGroupInfo']}
	#Log To Console    ${thingInfo} 
	
	${data_count}=    Get Length    ${thingInfo}
	#Log To Console    data_count${data_count}  
	FOR    ${i}    IN RANGE    ${data_count}
	    ${dataResponse}=    Set Variable    ${thingInfo[${i}]}
		
		${jsonLoaddataCheck}=    Evaluate    json.loads(r'''${dataCheck}''')    json
	    #Log To Console    dataCheck${dataCheck}
	   
	    Check Json Data Should Be Equal    ${dataResponse}    ['ConfigInfo']    ${jsonLoaddataCheck}
	END	