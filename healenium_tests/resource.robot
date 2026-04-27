*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               Uses Browser (Playwright) against Healenium Playwright proxy.
...               The proxy WebSocket is not a Selenium WebDriver URL.
...               ${BROWSER} must match the remote (Healenium examples use chromium, not firefox).
Library           Browser    WITH NAME    PWB

*** Variables ***
${TEST_PAGE}      https://healenium.github.io/healenium-test-env/index.html
${BROWSER}        chromium
${PROXY_URL}      ws://localhost:8095/hlm-playwright-proxy

*** Keywords ***
Open Remote Chrome Browser
    PWB.Connect To Browser    ${PROXY_URL}    ${BROWSER}    timeout=1m
    PWB.New Page    ${TEST_PAGE}

Close Browser
    PWB.Close Browser

Find Element by XPath
    [Arguments]    ${xpath}
    PWB.Wait For Elements State    xpath=${xpath}    visible

Find Element by ID
    [Arguments]    ${id}
    PWB.Click    id=${id}
