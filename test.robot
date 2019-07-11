*** Settings ***
Library       SeleniumLibrary
Library		  String

Test Setup     Open Browser To cieditweb
Test Teardown  Close Browser
*** Variables ***

${nome}      heroOfAutomation
${password}  standardPass
#Switch Browser

*** Test Cases ***
Test Magico
   Register To Ciediteb
   Login To Cieditweb
   Submit Yahoo Article
   sleep  10 s  #just to see the result

*** Keywords ***
Open Browser To cieditweb
    Open Browser                       http://www.ciediweb.it/automation_contest/   chrome  cieditweb
    Wait Until Page Contains Element   //span[@title='automationcontest']

Register To Ciediteb
    Open Registration
    Input Registration Data
    Submit Registration

Open Registration
    Click Element   //a[contains(@href,'registration')]
    Wait Until Page Contains Element  member-registration

Input Registration Data
    Wait Until Page Contains Element  jform_name
    ${email_part}=    generate random string    5
    ${email_part2}=   generate random string    5
    ${username}=      generate random string    5
    ${mail}=          catenate  SEPARATOR=  ${email_part}  @  ${email_part2}  .com
    input text   jform_name        ${nome}
    input text   jform_username    ${username}
    input text   jform_password1   ${password}
    input text   jform_password2   ${password}
    input text   jform_email1      ${mail}
    input text   jform_email2      ${mail}
    Set Test Variable              ${USERNAME}

Submit Registration
    wait until page contains element    //button[@type='submit']
    Click Element                       //button[@type='submit']

Login To Cieditweb
    Wait Until Page Contains Element  username
    input text     username    ${username}
    input text     password    ${password}
    Click Element  //button[@type='submit']
    Wait Until Page Contains Element  users-profile-core

Click Submit An Article
    Wait Until Page Contains Element  //a[contains(@href,'submit-an-article')]
    Click Element                     //a[contains(@href,'submit-an-article')]

Take Yahoo Article Text
    Open Browser    https://it.yahoo.com/   chrome  yahoo
    Close Cookie Message Yahoo
    wait until page contains element   //img[contains(@class, 'W(100%)')]
    click element                      //img[contains(@class, 'W(100%)')]
    wait until page contains element   //div[@class='body-wrapper']
    ${title}=   Get Text   modal-header
    ${text}=    Get Text               //div[@class='body-wrapper']
    Close Browser
    Switch Browser     cieditweb
    [Return]    ${text}   ${title}

Close Cookie Message Yahoo
    wait until page contains element   //button[@name='agree']
    click element                      //button[@name='agree']

Write Text In Joomla IFrame
    [Arguments]  ${text}
    Select Frame    id=jform_articletext_ifr
    Wait Until Page Contains Element    id=tinymce
    Wait Until Element Is Visible    id=tinymce
    Input Text    id=tinymce   ${text}
    Unselect Frame

Submit Yahoo Article
    Click Submit An Article
    ${text}   ${title}=    Take Yahoo Article Text
    Write Article Title    ${title}
    Write Text In Joomla IFrame     ${text}
    Click Pubblicazione Tab
    Select Blog Category
    Save Article

Submit Libero Article     #TODO
    Click Submit An Article
    Write Article Title   Libero
    Switch Browser     cieditweb

    Click Pubblicazione Tab
    Select Blog Category

Submit Corriere Article     #TODO
    Click Submit An Article
    Write Article Title   Corriere
    Switch Browser     cieditweb

    Click Pubblicazione Tab
    Select Blog Category

Write Article Title
    [Arguments]  ${title}
    wait until page contains element   jform_title
    input text   jform_title    caosmaker-${title}
    #Caosmaker - notizia
    #tab pubblicazione --> blog
    #salva

Click Pubblicazione Tab
    wait until page contains element  //a[@href='#publishing']
    click element                     //a[@href='#publishing']

Select Blog Category
    Wait Until Page Contains element    //a[@class='chzn-single']
    Click Element                       //a[@class='chzn-single']
    wait until page contains element    //li[@data-option-array-index='1']
    Click Element                       //li[@data-option-array-index='1']

Save Article
    wait until page contains element    //form[@id='adminForm']//button[@class='btn btn-primary']
    click element                       //form[@id='adminForm']//button[@class='btn btn-primary']
