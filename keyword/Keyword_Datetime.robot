*** Settings ***
Library    Collections
Library    String

*** Keywords ***
#H : hour
#M : minute
#S : s
#Mo : month
#Y : year
#format
#${MDYYYY_ADDSUB}    %m/%d/%Y
#${DDMMYYYY_ADDSUB}    %d/%m/%Y
#${MDYYYY_NOW}    {dt:%m}/{dt:%d}/{dt:%Y}
#${DDMMYYYY_NOW}    {dt:%d}/{dt:%m}/{dt:%Y}
#ex. 10/03/2020
Change format date now
    [Arguments]    ${format}
	#change format
	${now}    Evaluate  '${format}'.format(dt=datetime.datetime.now())    modules=datetime
	#Log To Console    now${now}
	[return]    ${now}

#ex. 23/09/2020 -> 24/10/2020 add 31 days
Value Add date now
    [Arguments]    ${format}    ${day} 
	#${getTime}=    Get Text    ${locator} 
	
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	${addDate}=      Add Time To Date      ${currentDate}      ${day} days
    ${valueDate}      Convert Date      ${addDate}      result_format=${format}
	#Log To Console    valueDate${valueDate}
	
	[return]    ${valueDate}
	
Value Minus date now
    [Arguments]    ${format}    ${day} 
	#${getTime}=    Get Text    ${locator} 
		
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	${subtractDate}=      Subtract Time From Date      ${currentDate}      ${day} days
    ${valueDate}      Convert Date      ${subtractDate}      result_format=${format}
	
	[return]    ${valueDate}
	
Value Minus Time Current Date and Change Format
    [Arguments]    ${format}    ${time}    ${timeString} 
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	${subtractDate}=      Subtract Time From Date      ${currentDate}      ${time} ${timeString}
	#Log To Console    subtractDate${subtractDate}
    ${valueDate}      Convert Date      ${subtractDate}      result_format=${format}
	
	[return]    ${valueDate}

Value Minus Time Current Date Not Change Format
    [Arguments]    ${time}    ${timeString} 			
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	${subtractDate}=      Subtract Time From Date      ${currentDate}      ${time} ${timeString}
	#Log To Console    subtractDate${subtractDate}
 
	[return]    ${subtractDate}
		
#Gte -> Lte
Rang Get Value Minus Time Current Date and Change Format
    [Arguments]    ${format}    ${time}    ${timeString} 
		
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	#${subtractDate1}=      Subtract Time From Date      ${currentDate}      15 ${timeString}
	${subtractDate}=      Subtract Time From Date      ${currentDate}      ${time} ${timeString}
	#Log To Console    subtractDate${subtractDate}
    
	${valueDateGte}      Convert Date      ${subtractDate}      result_format=${format}
	${valueDateLte}      Convert Date      ${currentDate}      result_format=${format}
	#Log To Console    valueDateGte${valueDateGte}
	#Log To Console    valueDateLte${valueDateLte}
	[return]    ${valueDateGte}    ${valueDateLte}    
	
