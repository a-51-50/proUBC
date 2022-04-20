INTERFACE Z100085_zif_privacy PUBLIC.
* Generated by abap-openapi-client
* Privacy, 1.0

* Component schema: CreatecircuitRequest, object
  TYPES: BEGIN OF createcircuitrequest,
           identifier TYPE string,
           proving_scheme TYPE string,
           curve TYPE string,
           provider TYPE string,
           name TYPE string,
         END OF createcircuitrequest.

* Component schema: ProveRequest, object
  TYPES: BEGIN OF proverequest,
           identifier TYPE string,
           proving_scheme TYPE string,
           curve TYPE string,
           provider TYPE string,
           name TYPE string,
         END OF proverequest.

* Component schema: Witness, object
  TYPES: BEGIN OF witness,
           x TYPE string,
           y TYPE string,
         END OF witness.

* Component schema: VerifyRequest, object
  TYPES: BEGIN OF verifyrequest,
           witness TYPE witness,
           proof TYPE string,
         END OF verifyrequest.

* GET - "List circuits"
* Operation id: Listcircuits
* Response: 200
  METHODS listcircuits
    RAISING cx_static_check.

* POST - "Create circuit"
* Operation id: Createcircuit
* Response: 200
* Body ref: #/components/schemas/CreatecircuitRequest
  METHODS createcircuit
    IMPORTING
      body TYPE createcircuitrequest
    RAISING cx_static_check.

* POST - "Verify"
* Operation id: Verify
* Parameter: circuit_id, required, path
* Response: 200
* Body ref: #/components/schemas/VerifyRequest
  METHODS verify
    IMPORTING
      circuit_id TYPE string
      body TYPE verifyrequest
    RAISING cx_static_check.

ENDINTERFACE.
