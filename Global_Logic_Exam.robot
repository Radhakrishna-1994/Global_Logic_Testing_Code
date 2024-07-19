*** Settings ***
Documentation    API Automation
Library    RequestsLibrary
Library    JSONLibrary

*** Variables ***

${Base_URL}     https://httpbin.org/
${endpoint}    /create_user
${endpoints}    /delay/{delay_time}
${non_existent_endpoint}    /non_existent_endpoint
${endpoint_2}    /protected/resource
${username}    your_username
${password}    your_password
*** Test Cases ***

Validate GET Request Response Code
    Create Session      krishna     ${Base_URL}
    ${response}    GET On Session    krishna    /#/HTTP_Methods/get_get
    ${headers}    Create Dictionary    Accept=application/json
    Should Be Equal As Numbers    ${response.status_code}    200

Validate POST Request and Response Data
    Create Session      krishna     ${Base_URL}${endpoint}
    ${headers}    Create Dictionary    Content-Type=application/json
    ${payload}    Create Dictionary    username=myusername    password=mypassword
    ${response}    POST On Session    krishna    json=${payload}    headers=${headers}
    ${response_data}    Convert To Dictionary    ${response.content}    ensure_ascii=False
    Log    Response Data: ${response_data}
    Should Contain Key    ${response_data}    id
    Should Contain Key    ${response_data}    username
    ${username}    Get From Dictionary    ${response_data}    username
    Should Be Equal    ${username}    myusername

Validate Delayed Response
    ${delay_time}    Set Variable    5    # Set delay time in seconds
    Create Session      krishna     ${base_url}${endpoints}/${delay_time}
    ${response}    GET On Session    krishna
    Log    Response Status Code: ${response.status_code}
    Should Be Equal As Numbers    ${response.status_code}    200

Negative Scenario - Access Non-existent Endpoint
    Create Session      krishna    ${base_url}${non_existent_endpoint}
    ${response}    GET On Session    krishna
    Log    Response Status Code: ${response.status_code}
    Should Be Equal As Numbers    ${response.status_code}    404

Simulate Unauthorized Access
    Create Session      krishna    ${base_url}${endpoint}
    ${response}    GET On Session    krishna    auth=(${username}, ${password})
    Log    Response Status Code: ${response.status_code}
    Should Be Equal As Numbers    ${response.status_code}    401

*** Keywords ***
Provided precondition
    Setup system under test