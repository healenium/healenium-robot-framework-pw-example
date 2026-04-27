*** Settings ***
Documentation     A test suite with a single Gherkin style test.
...
...               This test is functionally identical to the example in
...               valid_login.robot file.
Resource          resource.robot
Test Teardown     Close Browser

*** Test Cases ***
Example Test
    Open Remote Chrome Browser
    When Find Element by XPath   //*[@id='change:name']
    And Find Element by ID  Submit
    Then Find Element by XPath   //*[@id='change:name']


