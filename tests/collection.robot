*** Settings ***
Library    String
Library    SeleniumLibrary

*** Test Cases ***
Run a search for a vinyl record and verify there are results
    Open Browser                      url=https://vinyl-collector.vercel.app/  browser=chrome
    Input Text                        id:artistTextBox   tame impala
    Input Text                        id:albumTextBox    currents
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
    Go To                             url=https://vinyl-collector.vercel.app/
    Wait Until Page Contains Element  id:collection
    ${text}=  Get Text                xpath://*[@id="collection"]//div[@data-slot='item-title']
    Should Be Equal As Strings        ${text}  Tame Impala - Currents

Remove a record in the collection
    Click Button                      xpath=//button[text()="Remove from Collection"]
    Wait Until Page Contains Element  xpath://*[@id="collection"]/p
    ${text}=  Get Text                xpath://*[@id="collection"]/p
    Should Be Equal As Strings        ${text}  Your record collection will appear here once you start adding albums from your search results.
    Close Browser