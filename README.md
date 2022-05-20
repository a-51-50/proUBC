# proUBC

## Pre-requisites
Set up your companies organizations using the PRVD CLI and Provide Stack

## proUBC configuration
Activate the proUBC SICF node in transaction code SICF of your SAP system
Export the SSL certs from the PRVD APIs and upload them to the SAP system using transaction code STRUST. (You will encounter HTTP 407 errors without it!)


## Postman variables
sapuser : The SAP service account user id for proUBC integration
sappassword: Password to the SAP service account user for proUBC integration
sapbaseurl : Web dispatcher URL of the target SAP system
xsrftoken : Required authorization header for Post/Put API endpoints. Do a get call with the HTTP header X-CSRF-Token: Fetch and retrieve the corresponding response header value

## SAP roles and authorizations
TBD.

