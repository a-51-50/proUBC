CLASS z100085_zcl_idocapi_segmentapi DEFINITION
  PUBLIC
  INHERITING FROM cl_rest_resource
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS if_rest_resource~get
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z100085_ZCL_IDOCAPI_SEGMENTAPI IMPLEMENTATION.


  METHOD if_rest_resource~get.
*CALL METHOD SUPER->IF_REST_RESOURCE~GET
*    .

    DATA: lv_selectedbasictype TYPE string,
          ls_basictypes        TYPE z100085_zif_idocapi_typelist=>ty_basictype,
          ls_responsedata      TYPE z100085_zif_idocapi_typelist=>ty_basictype_w_segments,
          LV_IDOCTYPE          TYPE LEDID_IDOCTYPE.

    DATA(lt_uriattributes) = mo_request->get_uri_attributes( ).
    READ TABLE lt_uriattributes WITH KEY name = 'basictypeid' ASSIGNING FIELD-SYMBOL(<fs_basictype>).
    IF sy-subrc = 0.
      lv_selectedbasictype = <fs_basictype>-value.
      LV_IDOCTYPE = LV_SELECTEDBASICTYPE.
    ENDIF.

    "lV_selectedbasictype = 'ORDERS05'.

    "get the selected idoc Basic type
    SELECT SINGLE  a~idoctyp,
            b~descrp,
            a~presp,
            a~pwork,
            a~plast,
            a~closed,
            a~released,
            a~pretyp,
            a~generated,
            a~credate,
            a~cretime,
            a~ldate,
            a~ltime,
            a~applrel
      FROM edbas AS a
      LEFT OUTER JOIN edbast AS b ON a~idoctyp = b~idoctyp
                                  AND b~langua = 'E'
      WHERE a~idoctyp = @lv_selectedbasictype
    INTO @lS_basictypes.

    ls_responsedata-basictype = ls_basictypes.

    GET PARAMETER ID 'SEG' FIELD data(l_segtyp).
    GET PARAMETER ID 'IDC' FIELD data(l_idoctyp).
    GET PARAMETER ID 'CIM' FIELD data(l_cimtyp).
    GET PARAMETER ID 'EDIDEF_OBJTYP' FIELD data(l_type). "settings from we30
    GET PARAMETER ID 'EDD' FIELD data(l_object).
    GET PARAMETER ID 'EDI_SELDOCU' FIELD data(l_recsel). "record selection

    data: lv_idoc_type type LEDID_IDOC_TYPE,
          lt_IDOC_STRUCT TYPE LEDID_T_IDOC_STRUCT,
          lt_SEGMENTS TYPE LEDID_T_SEGMENT,
          lt_SEGMENT_STRUCT TYPE LEDID_T_SEGMENT_STRUCT.

    "get the idoc segments
    CALL FUNCTION 'IDOC_TYPE_COMPLETE_READ'
      EXPORTING
        struct_type    = 'B'
        idoctype       = LV_IDOCTYPE
        release        = ''
        applrel        = ''
        version        = '3'
      IMPORTING
        idoc_type      = lv_idoc_type
      TABLES
        idoc_struct    = lt_idoc_struct
        segments       = lt_segments
        segment_struct = lt_segment_struct
      EXCEPTIONS
        OTHERS         = 1.

     ls_responsedata-idocstruct = lt_idoc_struct.
     ls_responsedata-idocsegments = lt_segments.
     ls_responsedata-segmentstruct = lt_segment_struct.

    "create the json HTTP response
     DATA(lo_entity) = mo_response->create_entity( ).
     lo_entity->set_content_type( if_rest_media_type=>gc_appl_json ).
     lo_entity->set_string_data( /ui2/cl_json=>serialize( exporting data = ls_responsedata pretty_name = /ui2/cl_json=>pretty_mode-low_case ) ).
     mo_response->set_status( cl_rest_status_code=>gc_success_ok ).
  ENDMETHOD.
ENDCLASS.
