class ZCL_ZDFILE_DPC_EXT definition
  public
  inheriting from ZCL_ZDFILE_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZDFILE_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
    DATA: ls_filename LIKE LINE OF it_key_tab,
          ls_fileinfo TYPE ztb_content,
          ls_media    TYPE ty_s_media_resource.

    READ TABLE it_key_tab INTO ls_filename INDEX 1.
    IF sy-subrc EQ 0.
      SELECT SINGLE *
        FROM ztb_content
          INTO ls_fileinfo
            WHERE filename EQ ls_filename-value.
      IF sy-subrc EQ 0.
        ls_media-value     = ls_fileinfo-filecontent.
        ls_media-mime_type = ls_fileinfo-filetype.

        copy_data_to_ref(
          EXPORTING
            is_data = ls_media
          CHANGING
            cr_data = er_stream
        ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~update_stream.
    DATA: ls_filename LIKE LINE OF it_key_tab,
          ls_fileinfo TYPE ztb_content.

    READ TABLE it_key_tab INTO ls_filename INDEX 1.
    IF sy-subrc EQ 0.
      CLEAR ls_fileinfo.

      ls_fileinfo-filename     = ls_filename-value.
      ls_fileinfo-creationdate = sy-datum.
      ls_fileinfo-creationtime = sy-uzeit.
      ls_fileinfo-filecontent  = is_media_resource-value.
      ls_fileinfo-filetype     = is_media_resource-mime_type.

      MODIFY ztb_content from ls_fileinfo.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
