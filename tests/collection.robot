*** Settings ***
Library    String
Library    SeleniumLibrary

*** Variables ***
${BROWSER}    Chrome
${BASE_URL}   https://vinyl-collector.vercel.app/

*** Test Cases ***
Run a search for a vinyl record and verify there are results
    Open Headless Chrome To URL       ${BASE_URL}
    Wait Until Element Is Visible     id:artistTextBox   timeout=15s
    Input Text                        id:artistTextBox   tame impala
    Wait Until Element Is Visible     id:albumTextBox    timeout=15s
    Input Text                        id:albumTextBox    currents
    Wait Until Element Is Visible     xpath://button[text()="Search For Records"]
    Click Button                      xpath://button[text()="Search For Records"]
    Wait Until Page Contains Element  xpath=//div[@id='searchResults']//div[@role='list']
    Clear Element Text                id:artistTextBox
    Clear Element Text                id:albumTextBox

Run a search for a vinyl record that doesn't exist and verify there are no results
    Input Text                        id:artistTextBox   asdfasdf
    Input Text                        id:albumTextBox    asdfasdf
    Click Button                      xpath://button[text()="Search For Records"]
    Wait Until Page Contains Element  xpath://*[@id="searchResults"]/p
    ${text}=  Get Text                xpath://*[@id="searchResults"]/p
    Should Be Equal As Strings        ${text}  No results found
    Clear Element Text                id:artistTextBox
    Clear Element Text                id:albumTextBox

Run a search for a vinyl record and add to collection
    Input Text                        id:artistTextBox   tame impala
    Input Text                        id:albumTextBox    currents
    Click Button                      xpath://button[text()="Search For Records"]
    Wait Until Page Contains Element  xpath=//div[@id='searchResults']//div[@role='list']
    Click Button                      xpath://button[text()="Add to Collection"]
    Wait Until Page Contains Element  id:collection
    ${text}=  Get Text                xpath://*[@id="collection"]//div[@data-slot='item-title']
    Should Be Equal As Strings        ${text}  Tame Impala - Currents
    Clear Element Text                id:artistTextBox
    Clear Element Text                id:albumTextBox

Run a search using only the Artist field
    Input Text                        id:artistTextBox   the strokes
    Wait Until Page Contains Element  xpath=//div[@id='searchResults']//div[@role='list']
    Clear Element Text                id:artistTextBox

Run a search using only the Album field
    Input Text                        id:albumTextBox    room on fire
    Wait Until Page Contains Element  xpath=//div[@id='searchResults']//div[@role='list']
    Clear Element Text                id:albumTextBox

Verify that a record added to the collection is still there when the user leaves and returns to the page
    Go To                             url=https://www.google.com
    Go To                             url=${BASE_URL}
    Wait Until Page Contains Element  id:collection
    ${text}=  Get Text                xpath://*[@id="collection"]//div[@data-slot='item-title']
    Should Be Equal As Strings        ${text}  Tame Impala - Currents

Remove a record in the collection
    Click Button                      xpath=//button[text()="Remove from Collection"]
    Wait Until Page Contains Element  xpath://*[@id="collection"]/p
    ${text}=  Get Text                xpath://*[@id="collection"]/p
    Should Be Equal As Strings        ${text}  Your record collection will appear here once you start adding albums from your search results.
    Close Browser

*** Keywords ***
Open Headless Chrome To URL
    [Arguments]    ${url}
    Open Browser   ${url}    browser=chrome    options=add_argument("--headless=new"); add_argument("--window-size=1920,1080"); add_argument("--no-sandbox"); add_argument("--disable-dev-shm-usage") 