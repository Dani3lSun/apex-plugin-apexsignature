prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.2'
,p_default_workspace_id=>1821022212039223
,p_default_application_id=>107
,p_default_id_offset=>413866556122768620
,p_default_owner=>'APEX_PLUGINS'
);
end;
/
 
prompt APPLICATION 107 - APEX_PLUGINS
--
-- Application Export:
--   Application:     107
--   Name:            APEX_PLUGINS
--   Date and Time:   12:12 Wednesday July 24, 2024
--   Exported By:     SCHENKEL
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 2103297446797417892
--   Manifest End
--   Version:         23.2.2
--   Instance ID:     218219292993011
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/region_type/de_danielh_apexsignature
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(2103297446797417892)
,p_plugin_type=>'REGION TYPE'
,p_name=>'DE.DANIELH.APEXSIGNATURE'
,p_display_name=>'APEX Signature'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*-------------------------------------',
' * APEX Signature',
' * Version: 1.2 (09.07.2024)',
' * Author:  Daniel Hochleitner',
' *-------------------------------------',
'*/',
'FUNCTION render_apexsignature(p_region              IN apex_plugin.t_region,',
'                              p_plugin              IN apex_plugin.t_plugin,',
'                              p_is_printer_friendly IN BOOLEAN)',
'  RETURN apex_plugin.t_region_render_result IS',
'  -- plugin attributes',
'  l_width              NUMBER := p_region.attribute_01;',
'  l_height             NUMBER := p_region.attribute_02;',
'  l_line_minwidth      VARCHAR2(50) := p_region.attribute_03;',
'  l_line_maxwidth      VARCHAR2(50) := p_region.attribute_04;',
'  l_background_color   VARCHAR2(100) := p_region.attribute_05;',
'  l_pen_color          VARCHAR2(100) := p_region.attribute_06;',
'  l_logging            VARCHAR2(50) := p_region.attribute_08;',
'  l_clear_btn_selector VARCHAR2(100) := p_region.attribute_09;',
'  l_save_btn_selector  VARCHAR2(100) := p_region.attribute_10;',
'  l_alert_text         VARCHAR2(200) := p_region.attribute_11;',
'  l_show_spinner       VARCHAR2(50) := p_region.attribute_12;',
'  l_image_format       VARCHAR2(50) := p_region.attribute_13;',
'  l_trim_canvas        VARCHAR2(50) := p_region.attribute_14;',
'',
'  -- other variables',
'  l_region_id              VARCHAR2(200);',
'  l_canvas_id              VARCHAR2(200);',
'  l_background_color_esc   VARCHAR2(100);',
'  l_pen_color_esc          VARCHAR2(100);',
'  l_clear_btn_selector_esc VARCHAR2(100);',
'  l_save_btn_selector_esc  VARCHAR2(100);',
'  l_alert_text_esc         VARCHAR2(200);',
'  -- js/css file vars',
'  l_signaturepad_js  VARCHAR2(50);',
'  l_apexsignature_js VARCHAR2(50);',
'  --',
'BEGIN',
'  -- Debug',
'  IF apex_application.g_debug THEN',
'    apex_plugin_util.debug_region(p_plugin => p_plugin,',
'                                  p_region => p_region);',
'    -- set js/css filenames',
'    l_apexsignature_js := ''apexsignature'';',
'    l_signaturepad_js  := ''signature_pad'';',
'  ELSE',
'    l_apexsignature_js := ''apexsignature.min'';',
'    l_signaturepad_js  := ''signature_pad.min'';',
'  END IF;',
'  -- set variables and defaults',
'  l_region_id    := apex_escape.html_attribute(p_region.static_id ||',
'                                               ''_signature'');',
'  l_canvas_id    := l_region_id || ''_canvas'';',
'  l_logging      := nvl(l_logging,',
'                        ''false'');',
'  l_show_spinner := nvl(l_show_spinner,',
'                        ''false'');',
'  l_trim_canvas := nvl(l_trim_canvas,',
'                        ''true'');',
'  l_image_format := nvl(l_image_format,',
'                        ''false'');',
'',
'  -- escape input',
'  l_background_color_esc   := sys.htf.escape_sc(l_background_color);',
'  l_pen_color_esc          := sys.htf.escape_sc(l_pen_color);',
'  l_clear_btn_selector_esc := sys.htf.escape_sc(l_clear_btn_selector);',
'  l_save_btn_selector_esc  := sys.htf.escape_sc(l_save_btn_selector);',
'  l_alert_text_esc         := sys.htf.escape_sc(l_alert_text);',
'  																  ',
'  --',
'  -- add div and canvas for signature pad',
'  sys.htp.p(''<div id="'' || l_region_id || ''"><canvas id="'' || l_canvas_id ||',
'            ''" width="'' || l_width || ''" height="'' || l_height ||',
'            ''" style="border: solid; border-radius: 4px; box-shadow: 0 0 5px rgba(0, 0, 0, 0.02) inset;"></canvas></div>'');',
'  --',
'  -- add signaturepad and apexsignature js files                          ',
'  apex_javascript.add_library(p_name           => l_signaturepad_js,',
'                              p_directory      => p_plugin.file_prefix ||',
'                                                  ''js/'',',
'                              p_version        => NULL,',
'                              p_skip_extension => FALSE);',
'  --',
'  apex_javascript.add_library(p_name           => l_apexsignature_js,',
'                              p_directory      => p_plugin.file_prefix ||',
'                                                  ''js/'',',
'                              p_version        => NULL,',
'                              p_skip_extension => FALSE);',
' ',
'  -- onload code',
'  apex_javascript.add_onload_code(p_code => ''apexSignature.apexSignatureFnc('' ||',
'                                            apex_javascript.add_value(p_region.static_id) || ''{'' ||',
'                                            apex_javascript.add_attribute(''ajaxIdentifier'',',
'                                                                          apex_plugin.get_ajax_identifier) ||',
'                                            apex_javascript.add_attribute(''ajaxItemsToSubmit'',',
'                                                                          p_region.ajax_items_to_submit) ||                              ',
'                                            apex_javascript.add_attribute(''canvasId'',',
'                                                                          l_canvas_id) ||',
'                                            apex_javascript.add_attribute(''lineMinWidth'',',
'                                                                          l_line_minwidth) ||',
'                                            apex_javascript.add_attribute(''lineMaxWidth'',',
'                                                                          l_line_maxwidth) ||',
'                                            apex_javascript.add_attribute(''backgroundColor'',',
'                                                                          l_background_color_esc) ||',
'                                            apex_javascript.add_attribute(''penColor'',',
'                                                                          l_pen_color_esc) ||',
'                                            apex_javascript.add_attribute(''clearButton'',',
'                                                                          l_clear_btn_selector_esc) ||',
'                                            apex_javascript.add_attribute(''saveButton'',',
'                                                                          l_save_btn_selector_esc) ||',
'                                            apex_javascript.add_attribute(''emptyAlert'',',
'                                                                          l_alert_text_esc) ||	',
'                                            apex_javascript.add_attribute(''trimCanvas'',',
'                                                                          l_trim_canvas,',
'                                                                          FALSE) ||						  ',
'                                            apex_javascript.add_attribute(''showSpinner'',',
'                                                                          l_show_spinner,',
'                                                                          FALSE) ||',
'                                            apex_javascript.add_attribute(''imageFormat'',',
'                                                                          l_image_format,',
'                                                                          FALSE,',
'                                                                          FALSE) || ''},'' ||',
'                                            apex_javascript.add_value(l_logging,',
'                                                                      FALSE) || '');'');',
'  --',
'  RETURN NULL;',
'  --',
'END render_apexsignature;',
'--',
'--',
'-- AJAX function',
'--',
'--',
'FUNCTION ajax_apexsignature(p_region IN apex_plugin.t_region,',
'                            p_plugin IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_region_ajax_result IS',
'  --',
'  -- plugin attributes',
'  l_result     apex_plugin.t_region_ajax_result;',
'  l_plsql_code p_region.attribute_07%TYPE := p_region.attribute_07;',
'',
'  --',
'BEGIN',
'',
'  -- replace imageFormat in plsql code',
'  if p_region.attribute_13 = ''image/jpeg'' then',
'    l_plsql_code := replace(replace(l_plsql_code, ''.png'',''.jpeg''),''image/png'',''image/jpeg'');',
'  end if;',
'',
'  -- execute PL/SQL',
'  apex_plugin_util.execute_plsql_code(p_plsql_code => l_plsql_code);',
'  --',
'  --',
'  RETURN NULL;',
'  --',
'END ajax_apexsignature;'))
,p_default_escape_mode=>'HTML'
,p_api_version=>1
,p_render_function=>'render_apexsignature'
,p_ajax_function=>'ajax_apexsignature'
,p_standard_attributes=>'AJAX_ITEMS_TO_SUBMIT'
,p_substitute_attributes=>false
,p_subscribe_plugin_settings=>true
,p_help_text=>'APEX Signature allows you to draw smooth signatures into a HTML5 canvas and enables you to save the resulting image into database.'
,p_version_identifier=>'1.2'
,p_about_url=>'https://github.com/Dani3lSun/apex-plugin-apexsignature'
,p_files_version=>1050
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(2103368005322484747)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Width'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'600'
,p_is_translatable=>false
,p_help_text=>'Width of signature area'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(2103368311079486931)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Height'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'400'
,p_is_translatable=>false
,p_help_text=>'Height of signature area'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(2103368544866539069)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Line minWidth'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'0.5'
,p_is_translatable=>false
,p_help_text=>'Minimum width of a line. Defaults to 0.5'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(2103368932297542205)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Line maxWidth'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'2.5'
,p_is_translatable=>false
,p_help_text=>'Maximum width of a line. Defaults to 2.5'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(2103369144299634885)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Background Color'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'rgba(255,255,255,0)'
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'rgba(0,0,0,0) - transparent black<br>',
'rgb(255,255,255) - opaque white<br>',
'#FFFFFF - white<br>',
'red'))
,p_help_text=>'Background color of signature area. Defaults to "rgba(0,0,0,0)"'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(2103369477854641269)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Pen color'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'black'
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'black<br>',
'#FFFFFF<br>',
'red'))
,p_help_text=>'Color used to draw the lines. Defaults to "black"'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(2103370111143664287)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'PLSQL Code'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  --',
'  l_collection_name VARCHAR2(100);',
'  l_clob            CLOB;',
'  l_blob            BLOB;',
'  l_filename        VARCHAR2(100);',
'  l_mime_type       VARCHAR2(100);',
'  l_token           VARCHAR2(32000);',
'  --',
'BEGIN',
'  -- get defaults',
'',
'  l_filename  := ''signature_'' ||',
'                 to_char(SYSDATE,',
'                         ''YYYYMMDDHH24MISS'') || ''.png'';',
'						 -- Please don''t change the .png ending. It will automatically be replaced ',
'						 -- by the correct extension according to the selected Image Format',
'',
'  -- Please don''t change the mimetype. It will automatically be replaced by the correct one, according to the selected Image Format',
'  l_mime_type := ''image/png'';',
'  -- build CLOB from f01 30k Array',
'  dbms_lob.createtemporary(l_clob,',
'                           FALSE,',
'                           dbms_lob.session);',
'',
'  FOR i IN 1 .. apex_application.g_f01.count LOOP',
'    l_token := wwv_flow.g_f01(i);',
'  ',
'    IF length(l_token) > 0 THEN',
'      dbms_lob.writeappend(l_clob,',
'                           length(l_token),',
'                           l_token);',
'    END IF;',
'  END LOOP;',
'  --',
'  -- convert base64 CLOB to BLOB (mimetype: image/png)',
'  l_blob := apex_web_service.clobbase642blob(p_clob => l_clob);',
'  --',
'  -- create own collection (here starts custom part (for example a Insert statement))',
'  -- collection name',
'  l_collection_name := ''APEX_SIGNATURE'';',
'  -- check if exist',
'  IF NOT',
'      apex_collection.collection_exists(p_collection_name => l_collection_name) THEN',
'    apex_collection.create_collection(l_collection_name);',
'  END IF;',
'  -- add collection member (only if BLOB not null)',
'  IF dbms_lob.getlength(lob_loc => l_blob) IS NOT NULL THEN',
'    apex_collection.add_member(p_collection_name => l_collection_name,',
'                               p_c001            => l_filename, -- filename',
'                               p_c002            => l_mime_type, -- mime_type',
'                               p_d001            => SYSDATE, -- date created',
'                               p_blob001         => l_blob); -- BLOB img content',
'  END IF;',
'  --',
'END;'))
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT c001    AS filename,<br>',
'       c002    AS mime_type,<br>',
'       d001    AS date_created,<br>',
'       blob001 AS img_content<br>',
'  FROM apex_collections<br>',
' WHERE collection_name = ''APEX_SIGNATURE'';'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PLSQL code which saves the resulting image to database tables or collections.<br>',
'Default to Collection "APEX_SIGNATURE".<br>',
'Column c001 => filename<br>',
'Column c002 => mime_type<br>',
'Column d001 => date created<br>',
'Column blob001 => BLOB of image<br>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(2103370414300666279)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>130
,p_prompt=>'Logging'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'false'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Whether to log events in the console.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(2103370706427666903)
,p_plugin_attribute_id=>wwv_flow_imp.id(2103370414300666279)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(2103371105735667393)
,p_plugin_attribute_id=>wwv_flow_imp.id(2103370414300666279)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(2103388980195396559)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Clear Button JQuery Selector'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#MY_BUTTON_STATIC_ID<br>',
'.my_button_class<br>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'JQuery Selector to identify the "Clear Button" to clear signature area.<br>',
'This selector is internally used for "onclick" event.'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(2103389613941400235)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Save Button JQuery Selector'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#MY_BUTTON_STATIC_ID<br>',
'.my_button_class<br>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'JQuery Selector to identify the "Save Button" to save signature into Database.<br>',
'This selector is internally used for "onclick" event.'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(2103397171305567719)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Save empty Signature Alert text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Signature must have a value'
,p_is_translatable=>false
,p_help_text=>'Alert text when a User tries to save a empty signature.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(2103417963934772095)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Show WaitSpinner'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'false'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Show/Hide wait spinner when saving image into database'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(2103418571525772634)
,p_plugin_attribute_id=>wwv_flow_imp.id(2103417963934772095)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(2103419041842773093)
,p_plugin_attribute_id=>wwv_flow_imp.id(2103417963934772095)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(413881369721803808)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>80
,p_prompt=>'Image Format'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'image/png'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Allows to switch between jpeg and png image format.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(413884519180804755)
,p_plugin_attribute_id=>wwv_flow_imp.id(413881369721803808)
,p_display_sequence=>10
,p_display_value=>'PNG'
,p_return_value=>'image/png'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(413884912927805957)
,p_plugin_attribute_id=>wwv_flow_imp.id(413881369721803808)
,p_display_sequence=>20
,p_display_value=>'JPEG'
,p_return_value=>'image/jpeg'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(413897536176815067)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Trim Whitespace'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'true'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(413900516179815667)
,p_plugin_attribute_id=>wwv_flow_imp.id(413897536176815067)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(413900905459816175)
,p_plugin_attribute_id=>wwv_flow_imp.id(413897536176815067)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(2103395587260551710)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_name=>'apexsignature-cleared'
,p_display_name=>'Signature cleared'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(2103396304439551711)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_name=>'apexsignature-error-db'
,p_display_name=>'Signature saved to DB Error'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(2103395929171551711)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_name=>'apexsignature-saved-db'
,p_display_name=>'Signature saved to DB'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '76617220617065785369676E61747572653D7B7061727365426F6F6C65616E3A66756E6374696F6E2865297B766172206E3B72657475726E2274727565223D3D652E746F4C6F7765724361736528292626286E3D2130292C2266616C7365223D3D652E74';
wwv_flow_imp.g_varchar2_table(2) := '6F4C6F7765724361736528292626286E3D2131292C227472756522213D652E746F4C6F77657243617365282926262266616C736522213D652E746F4C6F7765724361736528292626286E3D766F69642030292C6E7D2C636C6F623241727261793A66756E';
wwv_flow_imp.g_varchar2_table(3) := '6374696F6E28652C6E2C61297B6C6F6F70436F756E743D4D6174682E666C6F6F7228652E6C656E6774682F6E292B313B666F7228766172206F3D303B6F3C6C6F6F70436F756E743B6F2B2B29612E7075736828652E736C696365286E2A6F2C6E2A286F2B';
wwv_flow_imp.g_varchar2_table(4) := '312929293B72657475726E20617D2C64617461555249326261736536343A66756E6374696F6E2865297B72657475726E20652E73756273747228652E696E6465784F6628222C22292B31297D2C736176653244623A66756E6374696F6E28652C6E2C612C';
wwv_flow_imp.g_varchar2_table(5) := '6F297B76617220743D617065785369676E61747572652E64617461555249326261736536342861292C693D5B5D3B693D617065785369676E61747572652E636C6F6232417272617928742C3365342C69292C617065782E7365727665722E706C7567696E';
wwv_flow_imp.g_varchar2_table(6) := '28652E616A61784964656E7469666965722C7B6630313A692C706167654974656D733A766F69642030213D3D652E616A61784974656D73546F5375626D69743F652E616A61784974656D73546F5375626D69742E73706C697428222C22293A6E756C6C7D';
wwv_flow_imp.g_varchar2_table(7) := '2C7B64617461547970653A2268746D6C222C737563636573733A66756E6374696F6E2865297B24282223222B6E292E747269676765722822617065787369676E61747572652D73617665642D6462222C4A534F4E2E706172736528657C7C227B7D222929';
wwv_flow_imp.g_varchar2_table(8) := '2C6F28297D2C6572726F723A66756E6374696F6E28652C61297B24282223222B6E292E747269676765722822617065787369676E61747572652D6572726F722D646222292C636F6E736F6C652E6C6F672822736176653244623A20617065782E73657276';
wwv_flow_imp.g_varchar2_table(9) := '65722E706C7567696E204552524F523A222C61292C6F28297D7D297D2C617065785369676E6174757265466E633A66756E6374696F6E28652C6E2C61297B766172206F3D6E2C743D646F63756D656E742E676574456C656D656E7442794964286F2E6361';
wwv_flow_imp.g_varchar2_table(10) := '6E7661734964292C693D617065785369676E61747572652E7061727365426F6F6C65616E2861292C723D7061727365496E74286F2E6C696E654D696E5769647468292C6C3D7061727365496E74286F2E6C696E654D61785769647468292C733D6F2E636C';
wwv_flow_imp.g_varchar2_table(11) := '656172427574746F6E2C633D6F2E73617665427574746F6E2C673D6F2E656D707479416C6572742C703D617065785369676E61747572652E7061727365426F6F6C65616E286F2E73686F775370696E6E6572292C753D742E77696474682C763D742E6865';
wwv_flow_imp.g_varchar2_table(12) := '696768742C783D7061727365496E7428646F63756D656E742E646F63756D656E74456C656D656E742E636C69656E745769647468292C643D7061727365496E7428646F63756D656E742E646F63756D656E74456C656D656E742E636C69656E7448656967';
wwv_flow_imp.g_varchar2_table(13) := '6874292C6D3D617065785369676E61747572652E7061727365426F6F6C65616E286F2E7472696D43616E766173292C533D6F2E696D616765466F726D61742C683D22696D6167652F6A706567223D3D533F6F2E6261636B67726F756E64436F6C6F722E72';
wwv_flow_imp.g_varchar2_table(14) := '65706C616365282272676261222C2272676222292E7265706C616365282F2C285C642B285C2E5C642B293F5C2929242F2C222922293A6F2E6261636B67726F756E64436F6C6F723B69262628636F6E736F6C652E6C6F672822617065785369676E617475';
wwv_flow_imp.g_varchar2_table(15) := '7265466E633A20764F7074696F6E732E616A61784964656E7469666965723A222C6F2E616A61784964656E746966696572292C636F6E736F6C652E6C6F672822617065785369676E6174757265466E633A20764F7074696F6E732E616A61784974656D73';
wwv_flow_imp.g_varchar2_table(16) := '546F5375626D69743A222C6F2E616A61784974656D73546F5375626D6974292C636F6E736F6C652E6C6F672822617065785369676E6174757265466E633A20764F7074696F6E732E63616E76617349643A222C6F2E63616E7661734964292C636F6E736F';
wwv_flow_imp.g_varchar2_table(17) := '6C652E6C6F672822617065785369676E6174757265466E633A20764F7074696F6E732E6C696E654D696E57696474683A222C6F2E6C696E654D696E5769647468292C636F6E736F6C652E6C6F672822617065785369676E6174757265466E633A20764F70';
wwv_flow_imp.g_varchar2_table(18) := '74696F6E732E6C696E654D617857696474683A222C6F2E6C696E654D61785769647468292C636F6E736F6C652E6C6F672822617065785369676E6174757265466E633A20764F7074696F6E732E6261636B67726F756E64436F6C6F723A222C68292C636F';
wwv_flow_imp.g_varchar2_table(19) := '6E736F6C652E6C6F672822617065785369676E6174757265466E633A20764F7074696F6E732E70656E436F6C6F723A222C6F2E70656E436F6C6F72292C636F6E736F6C652E6C6F672822617065785369676E6174757265466E633A20764F7074696F6E73';
wwv_flow_imp.g_varchar2_table(20) := '2E73617665427574746F6E3A222C6F2E73617665427574746F6E292C636F6E736F6C652E6C6F672822617065785369676E6174757265466E633A20764F7074696F6E732E636C656172427574746F6E3A222C6F2E636C656172427574746F6E292C636F6E';
wwv_flow_imp.g_varchar2_table(21) := '736F6C652E6C6F672822617065785369676E6174757265466E633A20764F7074696F6E732E656D707479416C6572743A222C6F2E656D707479416C657274292C636F6E736F6C652E6C6F672822617065785369676E6174757265466E633A20764F707469';
wwv_flow_imp.g_varchar2_table(22) := '6F6E732E73686F775370696E6E65723A222C6F2E73686F775370696E6E6572292C636F6E736F6C652E6C6F672822617065785369676E6174757265466E633A2070526567696F6E49643A222C65292C636F6E736F6C652E6C6F672822617065785369676E';
wwv_flow_imp.g_varchar2_table(23) := '6174757265466E633A207643616E76617357696474683A222C75292C636F6E736F6C652E6C6F672822617065785369676E6174757265466E633A207643616E7661734865696768743A222C76292C636F6E736F6C652E6C6F672822617065785369676E61';
wwv_flow_imp.g_varchar2_table(24) := '74757265466E633A2076436C69656E7457696474683A222C78292C636F6E736F6C652E6C6F672822617065785369676E6174757265466E633A20764369656E744865696768743A222C76292C636F6E736F6C652E6C6F672822617065785369676E617475';
wwv_flow_imp.g_varchar2_table(25) := '7265466E633A20765472696D43616E7661733A222C6D292C636F6E736F6C652E6C6F672822617065785369676E6174757265466E633A2076496D616765466F726D61743A222C5329292C753E78262628742E77696474683D782D3630292C763E64262628';
wwv_flow_imp.g_varchar2_table(26) := '742E6865696768743D642D3630293B76617220663D6E6577205369676E617475726550616428742C7B6D696E57696474683A722C6D617857696474683A6C2C6261636B67726F756E64436F6C6F723A682C70656E436F6C6F723A6F2E70656E436F6C6F72';
wwv_flow_imp.g_varchar2_table(27) := '7D293B242873292E636C69636B282866756E6374696F6E28297B662E636C65617228292C24282223222B65292E747269676765722822617065787369676E61747572652D636C656172656422297D29292C242863292E636C69636B282866756E6374696F';
wwv_flow_imp.g_varchar2_table(28) := '6E28297B69662821313D3D3D662E6973456D7074792829297B6966287029766172206E3D617065782E7574696C2E73686F775370696E6E65722824282223222B6529293B76617220613B613D6D3F22696D6167652F6A706567223D3D533F662E7472696D';
wwv_flow_imp.g_varchar2_table(29) := '576869746573706163652853293A662E7472696D5768697465737061636528293A22696D6167652F6A706567223D3D533F662E746F4461746155524C2853293A662E746F4461746155524C28292C617065785369676E61747572652E7361766532446228';
wwv_flow_imp.g_varchar2_table(30) := '6F2C652C612C2866756E6374696F6E28297B662E636C65617228292C7026266E2E72656D6F766528297D29297D656C736520616C6572742867297D29297D7D3B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(413909371773831155)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_file_name=>'js/apexsignature.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2166756E6374696F6E28742C65297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B5D2C2866756E6374696F6E28297B72657475726E20742E5369676E61747572655061643D652829';
wwv_flow_imp.g_varchar2_table(2) := '7D29293A226F626A656374223D3D747970656F66206578706F7274733F6D6F64756C652E6578706F7274733D6528293A742E5369676E61747572655061643D6528297D28746869732C2866756E6374696F6E28297B0A2F2A210A202A205369676E617475';
wwv_flow_imp.g_varchar2_table(3) := '7265205061642076352E302E32207C2068747470733A2F2F6769746875622E636F6D2F737A696D656B2F7369676E61747572655F7061640A202A20286329203230323420537A796D6F6E204E6F77616B207C2052656C656173656420756E646572207468';
wwv_flow_imp.g_varchar2_table(4) := '65204D4954206C6963656E73650A202A2F0A636C61737320747B636F6E7374727563746F7228742C652C692C6E297B69662869734E614E2874297C7C69734E614E286529297468726F77206E6577204572726F722860506F696E7420697320696E76616C';
wwv_flow_imp.g_varchar2_table(5) := '69643A2028247B747D2C20247B657D2960293B746869732E783D2B742C746869732E793D2B652C746869732E70726573737572653D697C7C302C746869732E74696D653D6E7C7C446174652E6E6F7728297D64697374616E6365546F2874297B72657475';
wwv_flow_imp.g_varchar2_table(6) := '726E204D6174682E73717274284D6174682E706F7728746869732E782D742E782C32292B4D6174682E706F7728746869732E792D742E792C3229297D657175616C732874297B72657475726E20746869732E783D3D3D742E782626746869732E793D3D3D';
wwv_flow_imp.g_varchar2_table(7) := '742E792626746869732E70726573737572653D3D3D742E70726573737572652626746869732E74696D653D3D3D742E74696D657D76656C6F6369747946726F6D2874297B72657475726E20746869732E74696D65213D3D742E74696D653F746869732E64';
wwv_flow_imp.g_varchar2_table(8) := '697374616E6365546F2874292F28746869732E74696D652D742E74696D65293A307D7D636C61737320657B7374617469632066726F6D506F696E747328742C69297B636F6E7374206E3D746869732E63616C63756C617465436F6E74726F6C506F696E74';
wwv_flow_imp.g_varchar2_table(9) := '7328745B305D2C745B315D2C745B325D292E63322C733D746869732E63616C63756C617465436F6E74726F6C506F696E747328745B315D2C745B325D2C745B335D292E63313B72657475726E206E6577206528745B315D2C6E2C732C745B325D2C692E73';
wwv_flow_imp.g_varchar2_table(10) := '746172742C692E656E64297D7374617469632063616C63756C617465436F6E74726F6C506F696E747328652C692C6E297B636F6E737420733D652E782D692E782C6F3D652E792D692E792C723D692E782D6E2E782C683D692E792D6E2E792C613D28652E';
wwv_flow_imp.g_varchar2_table(11) := '782B692E78292F322C633D28652E792B692E79292F322C643D28692E782B6E2E78292F322C6C3D28692E792B6E2E79292F322C753D4D6174682E7371727428732A732B6F2A6F292C763D4D6174682E7371727428722A722B682A68292C5F3D762F28752B';
wwv_flow_imp.g_varchar2_table(12) := '76292C703D642B28612D64292A5F2C673D6C2B28632D6C292A5F2C6D3D692E782D702C773D692E792D673B72657475726E7B63313A6E6577207428612B6D2C632B77292C63323A6E6577207428642B6D2C6C2B77297D7D636F6E7374727563746F722874';
wwv_flow_imp.g_varchar2_table(13) := '2C652C692C6E2C732C6F297B746869732E7374617274506F696E743D742C746869732E636F6E74726F6C323D652C746869732E636F6E74726F6C313D692C746869732E656E64506F696E743D6E2C746869732E737461727457696474683D732C74686973';
wwv_flow_imp.g_varchar2_table(14) := '2E656E6457696474683D6F7D6C656E67746828297B6C657420742C652C693D303B666F72286C6574206E3D303B6E3C3D31303B6E2B3D31297B636F6E737420733D6E2F31302C6F3D746869732E706F696E7428732C746869732E7374617274506F696E74';
wwv_flow_imp.g_varchar2_table(15) := '2E782C746869732E636F6E74726F6C312E782C746869732E636F6E74726F6C322E782C746869732E656E64506F696E742E78292C723D746869732E706F696E7428732C746869732E7374617274506F696E742E792C746869732E636F6E74726F6C312E79';
wwv_flow_imp.g_varchar2_table(16) := '2C746869732E636F6E74726F6C322E792C746869732E656E64506F696E742E79293B6966286E3E30297B636F6E7374206E3D6F2D742C733D722D653B692B3D4D6174682E73717274286E2A6E2B732A73297D743D6F2C653D727D72657475726E20697D70';
wwv_flow_imp.g_varchar2_table(17) := '6F696E7428742C652C692C6E2C73297B72657475726E20652A28312D74292A28312D74292A28312D74292B332A692A28312D74292A28312D74292A742B332A6E2A28312D74292A742A742B732A742A742A747D7D636C61737320697B636F6E7374727563';
wwv_flow_imp.g_varchar2_table(18) := '746F7228297B7472797B746869732E5F65743D6E6577204576656E745461726765747D63617463682874297B746869732E5F65743D646F63756D656E747D7D6164644576656E744C697374656E657228742C652C69297B746869732E5F65742E61646445';
wwv_flow_imp.g_varchar2_table(19) := '76656E744C697374656E657228742C652C69297D64697370617463684576656E742874297B72657475726E20746869732E5F65742E64697370617463684576656E742874297D72656D6F76654576656E744C697374656E657228742C652C69297B746869';
wwv_flow_imp.g_varchar2_table(20) := '732E5F65742E72656D6F76654576656E744C697374656E657228742C652C69297D7D636C617373206E20657874656E647320697B636F6E7374727563746F7228742C653D7B7D297B76617220692C732C6F3B737570657228292C746869732E63616E7661';
wwv_flow_imp.g_varchar2_table(21) := '733D742C746869732E5F64726177696E675374726F6B653D21312C746869732E5F6973456D7074793D21302C746869732E5F6C617374506F696E74733D5B5D2C746869732E5F646174613D5B5D2C746869732E5F6C61737456656C6F636974793D302C74';
wwv_flow_imp.g_varchar2_table(22) := '6869732E5F6C61737457696474683D302C746869732E5F68616E646C654D6F757365446F776E3D743D3E7B746869732E5F69734C656674427574746F6E5072657373656428742C213029262621746869732E5F64726177696E675374726F6B6526267468';
wwv_flow_imp.g_varchar2_table(23) := '69732E5F7374726F6B65426567696E28746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E74287429297D2C746869732E5F68616E646C654D6F7573654D6F76653D743D3E7B746869732E5F69734C656674427574746F6E';
wwv_flow_imp.g_varchar2_table(24) := '5072657373656428742C2130292626746869732E5F64726177696E675374726F6B653F746869732E5F7374726F6B654D6F766555706461746528746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E74287429293A746869';
wwv_flow_imp.g_varchar2_table(25) := '732E5F7374726F6B65456E6428746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E742874292C2131297D2C746869732E5F68616E646C654D6F75736555703D743D3E7B746869732E5F69734C656674427574746F6E5072';
wwv_flow_imp.g_varchar2_table(26) := '65737365642874297C7C746869732E5F7374726F6B65456E6428746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E74287429297D2C746869732E5F68616E646C65546F75636853746172743D743D3E7B31213D3D742E74';
wwv_flow_imp.g_varchar2_table(27) := '6172676574546F75636865732E6C656E6774687C7C746869732E5F64726177696E675374726F6B657C7C28742E63616E63656C61626C652626742E70726576656E7444656661756C7428292C746869732E5F7374726F6B65426567696E28746869732E5F';
wwv_flow_imp.g_varchar2_table(28) := '746F7563684576656E74546F5369676E61747572654576656E7428742929297D2C746869732E5F68616E646C65546F7563684D6F76653D743D3E7B313D3D3D742E746172676574546F75636865732E6C656E677468262628742E63616E63656C61626C65';
wwv_flow_imp.g_varchar2_table(29) := '2626742E70726576656E7444656661756C7428292C746869732E5F64726177696E675374726F6B653F746869732E5F7374726F6B654D6F766555706461746528746869732E5F746F7563684576656E74546F5369676E61747572654576656E7428742929';
wwv_flow_imp.g_varchar2_table(30) := '3A746869732E5F7374726F6B65456E6428746869732E5F746F7563684576656E74546F5369676E61747572654576656E742874292C213129297D2C746869732E5F68616E646C65546F756368456E643D743D3E7B303D3D3D742E746172676574546F7563';
wwv_flow_imp.g_varchar2_table(31) := '6865732E6C656E677468262628742E63616E63656C61626C652626742E70726576656E7444656661756C7428292C746869732E63616E7661732E72656D6F76654576656E744C697374656E65722822746F7563686D6F7665222C746869732E5F68616E64';
wwv_flow_imp.g_varchar2_table(32) := '6C65546F7563684D6F7665292C746869732E5F7374726F6B65456E6428746869732E5F746F7563684576656E74546F5369676E61747572654576656E7428742929297D2C746869732E5F68616E646C65506F696E746572446F776E3D743D3E7B74686973';
wwv_flow_imp.g_varchar2_table(33) := '2E5F69734C656674427574746F6E50726573736564287429262621746869732E5F64726177696E675374726F6B65262628742E70726576656E7444656661756C7428292C746869732E5F7374726F6B65426567696E28746869732E5F706F696E74657245';
wwv_flow_imp.g_varchar2_table(34) := '76656E74546F5369676E61747572654576656E7428742929297D2C746869732E5F68616E646C65506F696E7465724D6F76653D743D3E7B746869732E5F69734C656674427574746F6E5072657373656428742C2130292626746869732E5F64726177696E';
wwv_flow_imp.g_varchar2_table(35) := '675374726F6B653F28742E70726576656E7444656661756C7428292C746869732E5F7374726F6B654D6F766555706461746528746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E7428742929293A746869732E5F737472';
wwv_flow_imp.g_varchar2_table(36) := '6F6B65456E6428746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E742874292C2131297D2C746869732E5F68616E646C65506F696E74657255703D743D3E7B746869732E5F69734C656674427574746F6E507265737365';
wwv_flow_imp.g_varchar2_table(37) := '642874297C7C28742E70726576656E7444656661756C7428292C746869732E5F7374726F6B65456E6428746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E7428742929297D2C746869732E76656C6F6369747946696C74';
wwv_flow_imp.g_varchar2_table(38) := '65725765696768743D652E76656C6F6369747946696C7465725765696768747C7C2E372C746869732E6D696E57696474683D652E6D696E57696474687C7C2E352C746869732E6D617857696474683D652E6D617857696474687C7C322E352C746869732E';
wwv_flow_imp.g_varchar2_table(39) := '7468726F74746C653D6E756C6C213D3D28693D652E7468726F74746C65292626766F69642030213D3D693F693A31362C746869732E6D696E44697374616E63653D6E756C6C213D3D28733D652E6D696E44697374616E6365292626766F69642030213D3D';
wwv_flow_imp.g_varchar2_table(40) := '733F733A352C746869732E646F7453697A653D652E646F7453697A657C7C302C746869732E70656E436F6C6F723D652E70656E436F6C6F727C7C22626C61636B222C746869732E6261636B67726F756E64436F6C6F723D652E6261636B67726F756E6443';
wwv_flow_imp.g_varchar2_table(41) := '6F6C6F727C7C227267626128302C302C302C3029222C746869732E636F6D706F736974654F7065726174696F6E3D652E636F6D706F736974654F7065726174696F6E7C7C22736F757263652D6F766572222C746869732E63616E766173436F6E74657874';
wwv_flow_imp.g_varchar2_table(42) := '4F7074696F6E733D6E756C6C213D3D286F3D652E63616E766173436F6E746578744F7074696F6E73292626766F69642030213D3D6F3F6F3A7B7D2C746869732E5F7374726F6B654D6F76655570646174653D746869732E7468726F74746C653F66756E63';
wwv_flow_imp.g_varchar2_table(43) := '74696F6E28742C653D323530297B6C657420692C6E2C732C6F3D302C723D6E756C6C3B636F6E737420683D28293D3E7B6F3D446174652E6E6F7728292C723D6E756C6C2C693D742E6170706C79286E2C73292C727C7C286E3D6E756C6C2C733D5B5D297D';
wwv_flow_imp.g_varchar2_table(44) := '3B72657475726E2066756E6374696F6E282E2E2E61297B636F6E737420633D446174652E6E6F7728292C643D652D28632D6F293B72657475726E206E3D746869732C733D612C643C3D307C7C643E653F2872262628636C65617254696D656F7574287229';
wwv_flow_imp.g_varchar2_table(45) := '2C723D6E756C6C292C6F3D632C693D742E6170706C79286E2C73292C727C7C286E3D6E756C6C2C733D5B5D29293A727C7C28723D77696E646F772E73657454696D656F757428682C6429292C697D7D286E2E70726F746F747970652E5F7374726F6B6555';
wwv_flow_imp.g_varchar2_table(46) := '70646174652C746869732E7468726F74746C65293A6E2E70726F746F747970652E5F7374726F6B655570646174652C746869732E5F6374783D742E676574436F6E7465787428223264222C746869732E63616E766173436F6E746578744F7074696F6E73';
wwv_flow_imp.g_varchar2_table(47) := '292C746869732E636C65617228292C746869732E6F6E28297D636C65617228297B636F6E73747B5F6374783A742C63616E7661733A657D3D746869733B742E66696C6C5374796C653D746869732E6261636B67726F756E64436F6C6F722C742E636C6561';
wwv_flow_imp.g_varchar2_table(48) := '725265637428302C302C652E77696474682C652E686569676874292C742E66696C6C5265637428302C302C652E77696474682C652E686569676874292C746869732E5F646174613D5B5D2C746869732E5F726573657428746869732E5F676574506F696E';
wwv_flow_imp.g_varchar2_table(49) := '7447726F75704F7074696F6E732829292C746869732E5F6973456D7074793D21307D66726F6D4461746155524C28742C653D7B7D297B72657475726E206E65772050726F6D697365282828692C6E293D3E7B636F6E737420733D6E657720496D6167652C';
wwv_flow_imp.g_varchar2_table(50) := '6F3D652E726174696F7C7C77696E646F772E646576696365506978656C526174696F7C7C312C723D652E77696474687C7C746869732E63616E7661732E77696474682F6F2C683D652E6865696768747C7C746869732E63616E7661732E6865696768742F';
wwv_flow_imp.g_varchar2_table(51) := '6F2C613D652E784F66667365747C7C302C633D652E794F66667365747C7C303B746869732E5F726573657428746869732E5F676574506F696E7447726F75704F7074696F6E732829292C732E6F6E6C6F61643D28293D3E7B746869732E5F6374782E6472';
wwv_flow_imp.g_varchar2_table(52) := '6177496D61676528732C612C632C722C68292C6928297D2C732E6F6E6572726F723D743D3E7B6E2874297D2C732E63726F73734F726967696E3D22616E6F6E796D6F7573222C732E7372633D742C746869732E5F6973456D7074793D21317D29297D746F';
wwv_flow_imp.g_varchar2_table(53) := '4461746155524C28743D22696D6167652F706E67222C65297B72657475726E22696D6167652F7376672B786D6C223D3D3D743F28226F626A65637422213D747970656F662065262628653D766F69642030292C60646174613A696D6167652F7376672B78';
wwv_flow_imp.g_varchar2_table(54) := '6D6C3B6261736536342C247B62746F6128746869732E746F535647286529297D60293A28226E756D62657222213D747970656F662065262628653D766F69642030292C746869732E63616E7661732E746F4461746155524C28742C6529297D6F6E28297B';
wwv_flow_imp.g_varchar2_table(55) := '746869732E63616E7661732E7374796C652E746F756368416374696F6E3D226E6F6E65222C746869732E63616E7661732E7374796C652E6D73546F756368416374696F6E3D226E6F6E65222C746869732E63616E7661732E7374796C652E757365725365';
wwv_flow_imp.g_varchar2_table(56) := '6C6563743D226E6F6E65223B636F6E737420743D2F4D6163696E746F73682F2E74657374286E6176696761746F722E757365724167656E74292626226F6E746F756368737461727422696E20646F63756D656E743B77696E646F772E506F696E74657245';
wwv_flow_imp.g_varchar2_table(57) := '76656E74262621743F746869732E5F68616E646C65506F696E7465724576656E747328293A28746869732E5F68616E646C654D6F7573654576656E747328292C226F6E746F756368737461727422696E2077696E646F772626746869732E5F68616E646C';
wwv_flow_imp.g_varchar2_table(58) := '65546F7563684576656E74732829297D6F666628297B746869732E63616E7661732E7374796C652E746F756368416374696F6E3D226175746F222C746869732E63616E7661732E7374796C652E6D73546F756368416374696F6E3D226175746F222C7468';
wwv_flow_imp.g_varchar2_table(59) := '69732E63616E7661732E7374796C652E7573657253656C6563743D226175746F222C746869732E63616E7661732E72656D6F76654576656E744C697374656E65722822706F696E746572646F776E222C746869732E5F68616E646C65506F696E74657244';
wwv_flow_imp.g_varchar2_table(60) := '6F776E292C746869732E63616E7661732E72656D6F76654576656E744C697374656E657228226D6F757365646F776E222C746869732E5F68616E646C654D6F757365446F776E292C746869732E63616E7661732E72656D6F76654576656E744C69737465';
wwv_flow_imp.g_varchar2_table(61) := '6E65722822746F7563687374617274222C746869732E5F68616E646C65546F7563685374617274292C746869732E5F72656D6F76654D6F766555704576656E744C697374656E65727328297D7472696D5768697465737061636528743D22696D6167652F';
wwv_flow_imp.g_varchar2_table(62) := '706E6722297B76617220653D646F63756D656E742E637265617465456C656D656E74282263616E76617322292C693D652E676574436F6E746578742822326422293B652E77696474683D746869732E63616E7661732E77696474682C652E686569676874';
wwv_flow_imp.g_varchar2_table(63) := '3D746869732E63616E7661732E6865696768742C692E64726177496D61676528746869732E63616E7661732C302C30293B766172206E2C732C6F2C723D652E77696474682C683D652E6865696768742C613D7B783A5B5D2C793A5B5D7D2C633D692E6765';
wwv_flow_imp.g_varchar2_table(64) := '74496D6167654461746128302C302C652E77696474682C652E686569676874293B666F7228733D303B733C683B732B2B29666F72286E3D303B6E3C723B6E2B2B296F3D342A28732A722B6E292C28632E646174615B6F2B335D3E30262622696D6167652F';
wwv_flow_imp.g_varchar2_table(65) := '706E67223D3D747C7C323535213D632E646174615B6F5D2626323535213D632E646174615B6F2B315D2626323535213D632E646174615B6F2B325D262622696D6167652F6A706567223D3D7429262628612E782E70757368286E292C612E792E70757368';
wwv_flow_imp.g_varchar2_table(66) := '287329293B612E782E736F7274282866756E6374696F6E28742C65297B72657475726E20742D657D29292C612E792E736F7274282866756E6374696F6E28742C65297B72657475726E20742D657D29293B76617220643D612E782E6C656E6774682D313B';
wwv_flow_imp.g_varchar2_table(67) := '723D612E785B645D2D612E785B305D2C683D612E795B645D2D612E795B305D3B766172206C3D692E676574496D6167654461746128612E785B305D2C612E795B305D2C722C68293B72657475726E20652E77696474683D722C652E6865696768743D682C';
wwv_flow_imp.g_varchar2_table(68) := '692E707574496D61676544617461286C2C302C30292C652E746F4461746155524C2874297D5F6765744C697374656E657246756E6374696F6E7328297B76617220743B636F6E737420653D77696E646F772E646F63756D656E743D3D3D746869732E6361';
wwv_flow_imp.g_varchar2_table(69) := '6E7661732E6F776E6572446F63756D656E743F77696E646F773A6E756C6C213D3D28743D746869732E63616E7661732E6F776E6572446F63756D656E742E64656661756C7456696577292626766F69642030213D3D743F743A746869732E63616E766173';
wwv_flow_imp.g_varchar2_table(70) := '2E6F776E6572446F63756D656E743B72657475726E7B6164644576656E744C697374656E65723A652E6164644576656E744C697374656E65722E62696E642865292C72656D6F76654576656E744C697374656E65723A652E72656D6F76654576656E744C';
wwv_flow_imp.g_varchar2_table(71) := '697374656E65722E62696E642865297D7D5F72656D6F76654D6F766555704576656E744C697374656E65727328297B636F6E73747B72656D6F76654576656E744C697374656E65723A747D3D746869732E5F6765744C697374656E657246756E6374696F';
wwv_flow_imp.g_varchar2_table(72) := '6E7328293B742822706F696E7465726D6F7665222C746869732E5F68616E646C65506F696E7465724D6F7665292C742822706F696E7465727570222C746869732E5F68616E646C65506F696E7465725570292C7428226D6F7573656D6F7665222C746869';
wwv_flow_imp.g_varchar2_table(73) := '732E5F68616E646C654D6F7573654D6F7665292C7428226D6F7573657570222C746869732E5F68616E646C654D6F7573655570292C742822746F7563686D6F7665222C746869732E5F68616E646C65546F7563684D6F7665292C742822746F756368656E';
wwv_flow_imp.g_varchar2_table(74) := '64222C746869732E5F68616E646C65546F756368456E64297D6973456D70747928297B72657475726E20746869732E5F6973456D7074797D66726F6D4461746128742C7B636C6561723A653D21307D3D7B7D297B652626746869732E636C65617228292C';
wwv_flow_imp.g_varchar2_table(75) := '746869732E5F66726F6D4461746128742C746869732E5F6472617743757276652E62696E642874686973292C746869732E5F64726177446F742E62696E64287468697329292C746869732E5F646174613D746869732E5F646174612E636F6E6361742874';
wwv_flow_imp.g_varchar2_table(76) := '297D746F4461746128297B72657475726E20746869732E5F646174617D5F69734C656674427574746F6E5072657373656428742C65297B72657475726E20653F313D3D3D742E627574746F6E733A313D3D283126742E627574746F6E73297D5F706F696E';
wwv_flow_imp.g_varchar2_table(77) := '7465724576656E74546F5369676E61747572654576656E742874297B72657475726E7B6576656E743A742C747970653A742E747970652C783A742E636C69656E74582C793A742E636C69656E74592C70726573737572653A22707265737375726522696E';
wwv_flow_imp.g_varchar2_table(78) := '20743F742E70726573737572653A307D7D5F746F7563684576656E74546F5369676E61747572654576656E742874297B636F6E737420653D742E6368616E676564546F75636865735B305D3B72657475726E7B6576656E743A742C747970653A742E7479';
wwv_flow_imp.g_varchar2_table(79) := '70652C783A652E636C69656E74582C793A652E636C69656E74592C70726573737572653A652E666F7263657D7D5F676574506F696E7447726F75704F7074696F6E732874297B72657475726E7B70656E436F6C6F723A7426262270656E436F6C6F722269';
wwv_flow_imp.g_varchar2_table(80) := '6E20743F742E70656E436F6C6F723A746869732E70656E436F6C6F722C646F7453697A653A74262622646F7453697A6522696E20743F742E646F7453697A653A746869732E646F7453697A652C6D696E57696474683A742626226D696E57696474682269';
wwv_flow_imp.g_varchar2_table(81) := '6E20743F742E6D696E57696474683A746869732E6D696E57696474682C6D617857696474683A742626226D6178576964746822696E20743F742E6D617857696474683A746869732E6D617857696474682C76656C6F6369747946696C7465725765696768';
wwv_flow_imp.g_varchar2_table(82) := '743A7426262276656C6F6369747946696C74657257656967687422696E20743F742E76656C6F6369747946696C7465725765696768743A746869732E76656C6F6369747946696C7465725765696768742C636F6D706F736974654F7065726174696F6E3A';
wwv_flow_imp.g_varchar2_table(83) := '74262622636F6D706F736974654F7065726174696F6E22696E20743F742E636F6D706F736974654F7065726174696F6E3A746869732E636F6D706F736974654F7065726174696F6E7D7D5F7374726F6B65426567696E2874297B69662821746869732E64';
wwv_flow_imp.g_varchar2_table(84) := '697370617463684576656E74286E657720437573746F6D4576656E742822626567696E5374726F6B65222C7B64657461696C3A742C63616E63656C61626C653A21307D29292972657475726E3B636F6E73747B6164644576656E744C697374656E65723A';
wwv_flow_imp.g_varchar2_table(85) := '657D3D746869732E5F6765744C697374656E657246756E6374696F6E7328293B73776974636828742E6576656E742E74797065297B63617365226D6F757365646F776E223A6528226D6F7573656D6F7665222C746869732E5F68616E646C654D6F757365';
wwv_flow_imp.g_varchar2_table(86) := '4D6F7665292C6528226D6F7573657570222C746869732E5F68616E646C654D6F7573655570293B627265616B3B6361736522746F7563687374617274223A652822746F7563686D6F7665222C746869732E5F68616E646C65546F7563684D6F7665292C65';
wwv_flow_imp.g_varchar2_table(87) := '2822746F756368656E64222C746869732E5F68616E646C65546F756368456E64293B627265616B3B6361736522706F696E746572646F776E223A652822706F696E7465726D6F7665222C746869732E5F68616E646C65506F696E7465724D6F7665292C65';
wwv_flow_imp.g_varchar2_table(88) := '2822706F696E7465727570222C746869732E5F68616E646C65506F696E7465725570297D746869732E5F64726177696E675374726F6B653D21303B636F6E737420693D746869732E5F676574506F696E7447726F75704F7074696F6E7328292C6E3D4F62';
wwv_flow_imp.g_varchar2_table(89) := '6A6563742E61737369676E284F626A6563742E61737369676E287B7D2C69292C7B706F696E74733A5B5D7D293B746869732E5F646174612E70757368286E292C746869732E5F72657365742869292C746869732E5F7374726F6B65557064617465287429';
wwv_flow_imp.g_varchar2_table(90) := '7D5F7374726F6B655570646174652874297B69662821746869732E5F64726177696E675374726F6B652972657475726E3B696628303D3D3D746869732E5F646174612E6C656E6774682972657475726E20766F696420746869732E5F7374726F6B654265';
wwv_flow_imp.g_varchar2_table(91) := '67696E2874293B746869732E64697370617463684576656E74286E657720437573746F6D4576656E7428226265666F72655570646174655374726F6B65222C7B64657461696C3A747D29293B636F6E737420653D746869732E5F637265617465506F696E';
wwv_flow_imp.g_varchar2_table(92) := '7428742E782C742E792C742E7072657373757265292C693D746869732E5F646174615B746869732E5F646174612E6C656E6774682D315D2C6E3D692E706F696E74732C733D6E2E6C656E6774683E3026266E5B6E2E6C656E6774682D315D2C6F3D212173';
wwv_flow_imp.g_varchar2_table(93) := '2626652E64697374616E6365546F2873293C3D746869732E6D696E44697374616E63652C723D746869732E5F676574506F696E7447726F75704F7074696F6E732869293B69662821737C7C21737C7C216F297B636F6E737420743D746869732E5F616464';
wwv_flow_imp.g_varchar2_table(94) := '506F696E7428652C72293B733F742626746869732E5F64726177437572766528742C72293A746869732E5F64726177446F7428652C72292C6E2E70757368287B74696D653A652E74696D652C783A652E782C793A652E792C70726573737572653A652E70';
wwv_flow_imp.g_varchar2_table(95) := '726573737572657D297D746869732E64697370617463684576656E74286E657720437573746F6D4576656E74282261667465725570646174655374726F6B65222C7B64657461696C3A747D29297D5F7374726F6B65456E6428742C653D2130297B746869';
wwv_flow_imp.g_varchar2_table(96) := '732E5F72656D6F76654D6F766555704576656E744C697374656E65727328292C746869732E5F64726177696E675374726F6B65262628652626746869732E5F7374726F6B655570646174652874292C746869732E5F64726177696E675374726F6B653D21';
wwv_flow_imp.g_varchar2_table(97) := '312C746869732E64697370617463684576656E74286E657720437573746F6D4576656E742822656E645374726F6B65222C7B64657461696C3A747D2929297D5F68616E646C65506F696E7465724576656E747328297B746869732E5F64726177696E6753';
wwv_flow_imp.g_varchar2_table(98) := '74726F6B653D21312C746869732E63616E7661732E6164644576656E744C697374656E65722822706F696E746572646F776E222C746869732E5F68616E646C65506F696E746572446F776E297D5F68616E646C654D6F7573654576656E747328297B7468';
wwv_flow_imp.g_varchar2_table(99) := '69732E5F64726177696E675374726F6B653D21312C746869732E63616E7661732E6164644576656E744C697374656E657228226D6F757365646F776E222C746869732E5F68616E646C654D6F757365446F776E297D5F68616E646C65546F756368457665';
wwv_flow_imp.g_varchar2_table(100) := '6E747328297B746869732E63616E7661732E6164644576656E744C697374656E65722822746F7563687374617274222C746869732E5F68616E646C65546F7563685374617274297D5F72657365742874297B746869732E5F6C617374506F696E74733D5B';
wwv_flow_imp.g_varchar2_table(101) := '5D2C746869732E5F6C61737456656C6F636974793D302C746869732E5F6C61737457696474683D28742E6D696E57696474682B742E6D61785769647468292F322C746869732E5F6374782E66696C6C5374796C653D742E70656E436F6C6F722C74686973';
wwv_flow_imp.g_varchar2_table(102) := '2E5F6374782E676C6F62616C436F6D706F736974654F7065726174696F6E3D742E636F6D706F736974654F7065726174696F6E7D5F637265617465506F696E7428652C692C6E297B636F6E737420733D746869732E63616E7661732E676574426F756E64';
wwv_flow_imp.g_varchar2_table(103) := '696E67436C69656E745265637428293B72657475726E206E6577207428652D732E6C6566742C692D732E746F702C6E2C286E65772044617465292E67657454696D652829297D5F616464506F696E7428742C69297B636F6E73747B5F6C617374506F696E';
wwv_flow_imp.g_varchar2_table(104) := '74733A6E7D3D746869733B6966286E2E707573682874292C6E2E6C656E6774683E32297B333D3D3D6E2E6C656E67746826266E2E756E7368696674286E5B305D293B636F6E737420743D746869732E5F63616C63756C6174654375727665576964746873';
wwv_flow_imp.g_varchar2_table(105) := '286E5B315D2C6E5B325D2C69292C733D652E66726F6D506F696E7473286E2C74293B72657475726E206E2E736869667428292C737D72657475726E206E756C6C7D5F63616C63756C617465437572766557696474687328742C652C69297B636F6E737420';
wwv_flow_imp.g_varchar2_table(106) := '6E3D692E76656C6F6369747946696C7465725765696768742A652E76656C6F6369747946726F6D2874292B28312D692E76656C6F6369747946696C746572576569676874292A746869732E5F6C61737456656C6F636974792C733D746869732E5F737472';
wwv_flow_imp.g_varchar2_table(107) := '6F6B655769647468286E2C69292C6F3D7B656E643A732C73746172743A746869732E5F6C61737457696474687D3B72657475726E20746869732E5F6C61737456656C6F636974793D6E2C746869732E5F6C61737457696474683D732C6F7D5F7374726F6B';
wwv_flow_imp.g_varchar2_table(108) := '65576964746828742C65297B72657475726E204D6174682E6D617828652E6D617857696474682F28742B31292C652E6D696E5769647468297D5F6472617743757276655365676D656E7428742C652C69297B636F6E7374206E3D746869732E5F6374783B';
wwv_flow_imp.g_varchar2_table(109) := '6E2E6D6F7665546F28742C65292C6E2E61726328742C652C692C302C322A4D6174682E50492C2131292C746869732E5F6973456D7074793D21317D5F64726177437572766528742C65297B636F6E737420693D746869732E5F6374782C6E3D742E656E64';
wwv_flow_imp.g_varchar2_table(110) := '57696474682D742E737461727457696474682C733D322A4D6174682E6365696C28742E6C656E6774682829293B692E626567696E5061746828292C692E66696C6C5374796C653D652E70656E436F6C6F723B666F72286C657420693D303B693C733B692B';
wwv_flow_imp.g_varchar2_table(111) := '3D31297B636F6E7374206F3D692F732C723D6F2A6F2C683D722A6F2C613D312D6F2C633D612A612C643D632A613B6C6574206C3D642A742E7374617274506F696E742E783B6C2B3D332A632A6F2A742E636F6E74726F6C312E782C6C2B3D332A612A722A';
wwv_flow_imp.g_varchar2_table(112) := '742E636F6E74726F6C322E782C6C2B3D682A742E656E64506F696E742E783B6C657420753D642A742E7374617274506F696E742E793B752B3D332A632A6F2A742E636F6E74726F6C312E792C752B3D332A612A722A742E636F6E74726F6C322E792C752B';
wwv_flow_imp.g_varchar2_table(113) := '3D682A742E656E64506F696E742E793B636F6E737420763D4D6174682E6D696E28742E737461727457696474682B682A6E2C652E6D61785769647468293B746869732E5F6472617743757276655365676D656E74286C2C752C76297D692E636C6F736550';
wwv_flow_imp.g_varchar2_table(114) := '61746828292C692E66696C6C28297D5F64726177446F7428742C65297B636F6E737420693D746869732E5F6374782C6E3D652E646F7453697A653E303F652E646F7453697A653A28652E6D696E57696474682B652E6D61785769647468292F323B692E62';
wwv_flow_imp.g_varchar2_table(115) := '6567696E5061746828292C746869732E5F6472617743757276655365676D656E7428742E782C742E792C6E292C692E636C6F73655061746828292C692E66696C6C5374796C653D652E70656E436F6C6F722C692E66696C6C28297D5F66726F6D44617461';
wwv_flow_imp.g_varchar2_table(116) := '28652C692C6E297B666F7228636F6E73742073206F662065297B636F6E73747B706F696E74733A657D3D732C6F3D746869732E5F676574506F696E7447726F75704F7074696F6E732873293B696628652E6C656E6774683E3129666F72286C6574206E3D';
wwv_flow_imp.g_varchar2_table(117) := '303B6E3C652E6C656E6774683B6E2B3D31297B636F6E737420733D655B6E5D2C723D6E6577207428732E782C732E792C732E70726573737572652C732E74696D65293B303D3D3D6E2626746869732E5F7265736574286F293B636F6E737420683D746869';
wwv_flow_imp.g_varchar2_table(118) := '732E5F616464506F696E7428722C6F293B6826266928682C6F297D656C736520746869732E5F7265736574286F292C6E28655B305D2C6F297D7D746F535647287B696E636C7564654261636B67726F756E64436F6C6F723A743D21317D3D7B7D297B636F';
wwv_flow_imp.g_varchar2_table(119) := '6E737420653D746869732E5F646174612C693D4D6174682E6D61782877696E646F772E646576696365506978656C526174696F7C7C312C31292C6E3D746869732E63616E7661732E77696474682F692C733D746869732E63616E7661732E686569676874';
wwv_flow_imp.g_varchar2_table(120) := '2F692C6F3D646F63756D656E742E637265617465456C656D656E744E532822687474703A2F2F7777772E77332E6F72672F323030302F737667222C2273766722293B6966286F2E7365744174747269627574652822786D6C6E73222C22687474703A2F2F';
wwv_flow_imp.g_varchar2_table(121) := '7777772E77332E6F72672F323030302F73766722292C6F2E7365744174747269627574652822786D6C6E733A786C696E6B222C22687474703A2F2F7777772E77332E6F72672F313939392F786C696E6B22292C6F2E736574417474726962757465282276';
wwv_flow_imp.g_varchar2_table(122) := '696577426F78222C6030203020247B6E7D20247B737D60292C6F2E73657441747472696275746528227769647468222C6E2E746F537472696E672829292C6F2E7365744174747269627574652822686569676874222C732E746F537472696E672829292C';
wwv_flow_imp.g_varchar2_table(123) := '742626746869732E6261636B67726F756E64436F6C6F72297B636F6E737420743D646F63756D656E742E637265617465456C656D656E7428227265637422293B742E73657441747472696275746528227769647468222C223130302522292C742E736574';
wwv_flow_imp.g_varchar2_table(124) := '4174747269627574652822686569676874222C223130302522292C742E736574417474726962757465282266696C6C222C746869732E6261636B67726F756E64436F6C6F72292C6F2E617070656E644368696C642874297D72657475726E20746869732E';
wwv_flow_imp.g_varchar2_table(125) := '5F66726F6D4461746128652C2828742C7B70656E436F6C6F723A657D293D3E7B636F6E737420693D646F63756D656E742E637265617465456C656D656E7428227061746822293B696628212869734E614E28742E636F6E74726F6C312E78297C7C69734E';
wwv_flow_imp.g_varchar2_table(126) := '614E28742E636F6E74726F6C312E79297C7C69734E614E28742E636F6E74726F6C322E78297C7C69734E614E28742E636F6E74726F6C322E792929297B636F6E7374206E3D604D20247B742E7374617274506F696E742E782E746F46697865642833297D';
wwv_flow_imp.g_varchar2_table(127) := '2C247B742E7374617274506F696E742E792E746F46697865642833297D204320247B742E636F6E74726F6C312E782E746F46697865642833297D2C247B742E636F6E74726F6C312E792E746F46697865642833297D20247B742E636F6E74726F6C322E78';
wwv_flow_imp.g_varchar2_table(128) := '2E746F46697865642833297D2C247B742E636F6E74726F6C322E792E746F46697865642833297D20247B742E656E64506F696E742E782E746F46697865642833297D2C247B742E656E64506F696E742E792E746F46697865642833297D603B692E736574';
wwv_flow_imp.g_varchar2_table(129) := '417474726962757465282264222C6E292C692E73657441747472696275746528227374726F6B652D7769647468222C28322E32352A742E656E645769647468292E746F4669786564283329292C692E73657441747472696275746528227374726F6B6522';
wwv_flow_imp.g_varchar2_table(130) := '2C65292C692E736574417474726962757465282266696C6C222C226E6F6E6522292C692E73657441747472696275746528227374726F6B652D6C696E65636170222C22726F756E6422292C6F2E617070656E644368696C642869297D7D292C2828742C7B';
wwv_flow_imp.g_varchar2_table(131) := '70656E436F6C6F723A652C646F7453697A653A692C6D696E57696474683A6E2C6D617857696474683A737D293D3E7B636F6E737420723D646F63756D656E742E637265617465456C656D656E742822636972636C6522292C683D693E303F693A286E2B73';
wwv_flow_imp.g_varchar2_table(132) := '292F323B722E736574417474726962757465282272222C682E746F537472696E672829292C722E73657441747472696275746528226378222C742E782E746F537472696E672829292C722E73657441747472696275746528226379222C742E792E746F53';
wwv_flow_imp.g_varchar2_table(133) := '7472696E672829292C722E736574417474726962757465282266696C6C222C65292C6F2E617070656E644368696C642872297D29292C6F2E6F7574657248544D4C7D7D72657475726E206E7D29293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(827726081162349287)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_file_name=>'js/signature_pad.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2866756E6374696F6E2028726F6F742C20666163746F727929207B0A2020202069662028747970656F6620646566696E65203D3D3D202766756E6374696F6E2720262620646566696E652E616D6429207B0A2020202020202F2F20414D442E2052656769';
wwv_flow_imp.g_varchar2_table(2) := '7374657220617320616E20616E6F6E796D6F7573206D6F64756C6520756E6C65737320616D644D6F64756C654964206973207365740A202020202020646566696E65285B5D2C2066756E6374696F6E202829207B0A202020202020202072657475726E20';
wwv_flow_imp.g_varchar2_table(3) := '28726F6F745B275369676E6174757265506164275D203D20666163746F72792829293B0A2020202020207D293B0A202020207D20656C73652069662028747970656F66206578706F727473203D3D3D20276F626A6563742729207B0A2020202020202F2F';
wwv_flow_imp.g_varchar2_table(4) := '204E6F64652E20446F6573206E6F7420776F726B20776974682073747269637420436F6D6D6F6E4A532C206275740A2020202020202F2F206F6E6C7920436F6D6D6F6E4A532D6C696B6520656E7669726F6E6D656E7473207468617420737570706F7274';
wwv_flow_imp.g_varchar2_table(5) := '206D6F64756C652E6578706F7274732C0A2020202020202F2F206C696B65204E6F64652E0A2020202020206D6F64756C652E6578706F727473203D20666163746F727928293B0A202020207D20656C7365207B0A202020202020726F6F745B275369676E';
wwv_flow_imp.g_varchar2_table(6) := '6174757265506164275D203D20666163746F727928293B0A202020207D0A20207D28746869732C2066756E6374696F6E202829207B0A0A2F2A210A202A205369676E6174757265205061642076352E302E32207C2068747470733A2F2F6769746875622E';
wwv_flow_imp.g_varchar2_table(7) := '636F6D2F737A696D656B2F7369676E61747572655F7061640A202A20286329203230323420537A796D6F6E204E6F77616B207C2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A2F0A0A636C61737320506F696E7420';
wwv_flow_imp.g_varchar2_table(8) := '7B0A20202020636F6E7374727563746F7228782C20792C2070726573737572652C2074696D6529207B0A20202020202020206966202869734E614E287829207C7C2069734E614E28792929207B0A2020202020202020202020207468726F77206E657720';
wwv_flow_imp.g_varchar2_table(9) := '4572726F722860506F696E7420697320696E76616C69643A2028247B787D2C20247B797D2960293B0A20202020202020207D0A2020202020202020746869732E78203D202B783B0A2020202020202020746869732E79203D202B793B0A20202020202020';
wwv_flow_imp.g_varchar2_table(10) := '20746869732E7072657373757265203D207072657373757265207C7C20303B0A2020202020202020746869732E74696D65203D2074696D65207C7C20446174652E6E6F7728293B0A202020207D0A2020202064697374616E6365546F2873746172742920';
wwv_flow_imp.g_varchar2_table(11) := '7B0A202020202020202072657475726E204D6174682E73717274284D6174682E706F7728746869732E78202D2073746172742E782C203229202B204D6174682E706F7728746869732E79202D2073746172742E792C203229293B0A202020207D0A202020';
wwv_flow_imp.g_varchar2_table(12) := '20657175616C73286F7468657229207B0A202020202020202072657475726E2028746869732E78203D3D3D206F746865722E782026260A202020202020202020202020746869732E79203D3D3D206F746865722E792026260A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(13) := '20746869732E7072657373757265203D3D3D206F746865722E70726573737572652026260A202020202020202020202020746869732E74696D65203D3D3D206F746865722E74696D65293B0A202020207D0A2020202076656C6F6369747946726F6D2873';
wwv_flow_imp.g_varchar2_table(14) := '7461727429207B0A202020202020202072657475726E20746869732E74696D6520213D3D2073746172742E74696D650A2020202020202020202020203F20746869732E64697374616E6365546F28737461727429202F2028746869732E74696D65202D20';
wwv_flow_imp.g_varchar2_table(15) := '73746172742E74696D65290A2020202020202020202020203A20303B0A202020207D0A7D0A0A636C6173732042657A696572207B0A202020207374617469632066726F6D506F696E747328706F696E74732C2077696474687329207B0A20202020202020';
wwv_flow_imp.g_varchar2_table(16) := '20636F6E7374206332203D20746869732E63616C63756C617465436F6E74726F6C506F696E747328706F696E74735B305D2C20706F696E74735B315D2C20706F696E74735B325D292E63323B0A2020202020202020636F6E7374206333203D2074686973';
wwv_flow_imp.g_varchar2_table(17) := '2E63616C63756C617465436F6E74726F6C506F696E747328706F696E74735B315D2C20706F696E74735B325D2C20706F696E74735B335D292E63313B0A202020202020202072657475726E206E65772042657A69657228706F696E74735B315D2C206332';
wwv_flow_imp.g_varchar2_table(18) := '2C2063332C20706F696E74735B325D2C207769647468732E73746172742C207769647468732E656E64293B0A202020207D0A202020207374617469632063616C63756C617465436F6E74726F6C506F696E74732873312C2073322C20733329207B0A2020';
wwv_flow_imp.g_varchar2_table(19) := '202020202020636F6E737420647831203D2073312E78202D2073322E783B0A2020202020202020636F6E737420647931203D2073312E79202D2073322E793B0A2020202020202020636F6E737420647832203D2073322E78202D2073332E783B0A202020';
wwv_flow_imp.g_varchar2_table(20) := '2020202020636F6E737420647932203D2073322E79202D2073332E793B0A2020202020202020636F6E7374206D31203D207B20783A202873312E78202B2073322E7829202F20322E302C20793A202873312E79202B2073322E7929202F20322E30207D3B';
wwv_flow_imp.g_varchar2_table(21) := '0A2020202020202020636F6E7374206D32203D207B20783A202873322E78202B2073332E7829202F20322E302C20793A202873322E79202B2073332E7929202F20322E30207D3B0A2020202020202020636F6E7374206C31203D204D6174682E73717274';
wwv_flow_imp.g_varchar2_table(22) := '28647831202A20647831202B20647931202A20647931293B0A2020202020202020636F6E7374206C32203D204D6174682E7371727428647832202A20647832202B20647932202A20647932293B0A2020202020202020636F6E73742064786D203D206D31';
wwv_flow_imp.g_varchar2_table(23) := '2E78202D206D322E783B0A2020202020202020636F6E73742064796D203D206D312E79202D206D322E793B0A2020202020202020636F6E7374206B203D206C32202F20286C31202B206C32293B0A2020202020202020636F6E737420636D203D207B2078';
wwv_flow_imp.g_varchar2_table(24) := '3A206D322E78202B2064786D202A206B2C20793A206D322E79202B2064796D202A206B207D3B0A2020202020202020636F6E7374207478203D2073322E78202D20636D2E783B0A2020202020202020636F6E7374207479203D2073322E79202D20636D2E';
wwv_flow_imp.g_varchar2_table(25) := '793B0A202020202020202072657475726E207B0A20202020202020202020202063313A206E657720506F696E74286D312E78202B2074782C206D312E79202B207479292C0A20202020202020202020202063323A206E657720506F696E74286D322E7820';
wwv_flow_imp.g_varchar2_table(26) := '2B2074782C206D322E79202B207479292C0A20202020202020207D3B0A202020207D0A20202020636F6E7374727563746F72287374617274506F696E742C20636F6E74726F6C322C20636F6E74726F6C312C20656E64506F696E742C2073746172745769';
wwv_flow_imp.g_varchar2_table(27) := '6474682C20656E64576964746829207B0A2020202020202020746869732E7374617274506F696E74203D207374617274506F696E743B0A2020202020202020746869732E636F6E74726F6C32203D20636F6E74726F6C323B0A2020202020202020746869';
wwv_flow_imp.g_varchar2_table(28) := '732E636F6E74726F6C31203D20636F6E74726F6C313B0A2020202020202020746869732E656E64506F696E74203D20656E64506F696E743B0A2020202020202020746869732E73746172745769647468203D20737461727457696474683B0A2020202020';
wwv_flow_imp.g_varchar2_table(29) := '202020746869732E656E645769647468203D20656E6457696474683B0A202020207D0A202020206C656E6774682829207B0A2020202020202020636F6E7374207374657073203D2031303B0A20202020202020206C6574206C656E677468203D20303B0A';
wwv_flow_imp.g_varchar2_table(30) := '20202020202020206C65742070783B0A20202020202020206C65742070793B0A2020202020202020666F7220286C65742069203D20303B2069203C3D2073746570733B2069202B3D203129207B0A202020202020202020202020636F6E73742074203D20';
wwv_flow_imp.g_varchar2_table(31) := '69202F2073746570733B0A202020202020202020202020636F6E7374206378203D20746869732E706F696E7428742C20746869732E7374617274506F696E742E782C20746869732E636F6E74726F6C312E782C20746869732E636F6E74726F6C322E782C';
wwv_flow_imp.g_varchar2_table(32) := '20746869732E656E64506F696E742E78293B0A202020202020202020202020636F6E7374206379203D20746869732E706F696E7428742C20746869732E7374617274506F696E742E792C20746869732E636F6E74726F6C312E792C20746869732E636F6E';
wwv_flow_imp.g_varchar2_table(33) := '74726F6C322E792C20746869732E656E64506F696E742E79293B0A2020202020202020202020206966202869203E203029207B0A20202020202020202020202020202020636F6E7374207864696666203D206378202D2070783B0A202020202020202020';
wwv_flow_imp.g_varchar2_table(34) := '20202020202020636F6E7374207964696666203D206379202D2070793B0A202020202020202020202020202020206C656E677468202B3D204D6174682E73717274287864696666202A207864696666202B207964696666202A207964696666293B0A2020';
wwv_flow_imp.g_varchar2_table(35) := '202020202020202020207D0A2020202020202020202020207078203D2063783B0A2020202020202020202020207079203D2063793B0A20202020202020207D0A202020202020202072657475726E206C656E6774683B0A202020207D0A20202020706F69';
wwv_flow_imp.g_varchar2_table(36) := '6E7428742C2073746172742C2063312C2063322C20656E6429207B0A202020202020202072657475726E20287374617274202A2028312E30202D207429202A2028312E30202D207429202A2028312E30202D207429290A2020202020202020202020202B';
wwv_flow_imp.g_varchar2_table(37) := '2028332E30202A206331202A2028312E30202D207429202A2028312E30202D207429202A2074290A2020202020202020202020202B2028332E30202A206332202A2028312E30202D207429202A2074202A2074290A2020202020202020202020202B2028';
wwv_flow_imp.g_varchar2_table(38) := '656E64202A2074202A2074202A2074293B0A202020207D0A7D0A0A636C617373205369676E61747572654576656E74546172676574207B0A20202020636F6E7374727563746F722829207B0A2020202020202020747279207B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(39) := '2020746869732E5F6574203D206E6577204576656E7454617267657428293B0A20202020202020207D0A2020202020202020636174636820286572726F7229207B0A202020202020202020202020746869732E5F6574203D20646F63756D656E743B0A20';
wwv_flow_imp.g_varchar2_table(40) := '202020202020207D0A202020207D0A202020206164644576656E744C697374656E657228747970652C206C697374656E65722C206F7074696F6E7329207B0A2020202020202020746869732E5F65742E6164644576656E744C697374656E657228747970';
wwv_flow_imp.g_varchar2_table(41) := '652C206C697374656E65722C206F7074696F6E73293B0A202020207D0A2020202064697370617463684576656E74286576656E7429207B0A202020202020202072657475726E20746869732E5F65742E64697370617463684576656E74286576656E7429';
wwv_flow_imp.g_varchar2_table(42) := '3B0A202020207D0A2020202072656D6F76654576656E744C697374656E657228747970652C2063616C6C6261636B2C206F7074696F6E7329207B0A2020202020202020746869732E5F65742E72656D6F76654576656E744C697374656E65722874797065';
wwv_flow_imp.g_varchar2_table(43) := '2C2063616C6C6261636B2C206F7074696F6E73293B0A202020207D0A7D0A0A66756E6374696F6E207468726F74746C6528666E2C2077616974203D2032353029207B0A202020206C65742070726576696F7573203D20303B0A202020206C65742074696D';
wwv_flow_imp.g_varchar2_table(44) := '656F7574203D206E756C6C3B0A202020206C657420726573756C743B0A202020206C65742073746F726564436F6E746578743B0A202020206C65742073746F726564417267733B0A20202020636F6E7374206C61746572203D202829203D3E207B0A2020';
wwv_flow_imp.g_varchar2_table(45) := '20202020202070726576696F7573203D20446174652E6E6F7728293B0A202020202020202074696D656F7574203D206E756C6C3B0A2020202020202020726573756C74203D20666E2E6170706C792873746F726564436F6E746578742C2073746F726564';
wwv_flow_imp.g_varchar2_table(46) := '41726773293B0A2020202020202020696620282174696D656F757429207B0A20202020202020202020202073746F726564436F6E74657874203D206E756C6C3B0A20202020202020202020202073746F72656441726773203D205B5D3B0A202020202020';
wwv_flow_imp.g_varchar2_table(47) := '20207D0A202020207D3B0A2020202072657475726E2066756E6374696F6E2077726170706572282E2E2E6172677329207B0A2020202020202020636F6E7374206E6F77203D20446174652E6E6F7728293B0A2020202020202020636F6E73742072656D61';
wwv_flow_imp.g_varchar2_table(48) := '696E696E67203D2077616974202D20286E6F77202D2070726576696F7573293B0A202020202020202073746F726564436F6E74657874203D20746869733B0A202020202020202073746F72656441726773203D20617267733B0A20202020202020206966';
wwv_flow_imp.g_varchar2_table(49) := '202872656D61696E696E67203C3D2030207C7C2072656D61696E696E67203E207761697429207B0A2020202020202020202020206966202874696D656F757429207B0A20202020202020202020202020202020636C65617254696D656F75742874696D65';
wwv_flow_imp.g_varchar2_table(50) := '6F7574293B0A2020202020202020202020202020202074696D656F7574203D206E756C6C3B0A2020202020202020202020207D0A20202020202020202020202070726576696F7573203D206E6F773B0A202020202020202020202020726573756C74203D';
wwv_flow_imp.g_varchar2_table(51) := '20666E2E6170706C792873746F726564436F6E746578742C2073746F72656441726773293B0A202020202020202020202020696620282174696D656F757429207B0A2020202020202020202020202020202073746F726564436F6E74657874203D206E75';
wwv_flow_imp.g_varchar2_table(52) := '6C6C3B0A2020202020202020202020202020202073746F72656441726773203D205B5D3B0A2020202020202020202020207D0A20202020202020207D0A2020202020202020656C736520696620282174696D656F757429207B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(53) := '202074696D656F7574203D2077696E646F772E73657454696D656F7574286C617465722C2072656D61696E696E67293B0A20202020202020207D0A202020202020202072657475726E20726573756C743B0A202020207D3B0A7D0A0A636C617373205369';
wwv_flow_imp.g_varchar2_table(54) := '676E617475726550616420657874656E6473205369676E61747572654576656E74546172676574207B0A20202020636F6E7374727563746F722863616E7661732C206F7074696F6E73203D207B7D29207B0A2020202020202020766172205F612C205F62';
wwv_flow_imp.g_varchar2_table(55) := '2C205F633B0A2020202020202020737570657228293B0A2020202020202020746869732E63616E766173203D2063616E7661733B0A2020202020202020746869732E5F64726177696E675374726F6B65203D2066616C73653B0A20202020202020207468';
wwv_flow_imp.g_varchar2_table(56) := '69732E5F6973456D707479203D20747275653B0A2020202020202020746869732E5F6C617374506F696E7473203D205B5D3B0A2020202020202020746869732E5F64617461203D205B5D3B0A2020202020202020746869732E5F6C61737456656C6F6369';
wwv_flow_imp.g_varchar2_table(57) := '7479203D20303B0A2020202020202020746869732E5F6C6173745769647468203D20303B0A2020202020202020746869732E5F68616E646C654D6F757365446F776E203D20286576656E7429203D3E207B0A202020202020202020202020696620282174';
wwv_flow_imp.g_varchar2_table(58) := '6869732E5F69734C656674427574746F6E50726573736564286576656E742C207472756529207C7C20746869732E5F64726177696E675374726F6B6529207B0A2020202020202020202020202020202072657475726E3B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(59) := '7D0A202020202020202020202020746869732E5F7374726F6B65426567696E28746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E74286576656E7429293B0A20202020202020207D3B0A2020202020202020746869732E';
wwv_flow_imp.g_varchar2_table(60) := '5F68616E646C654D6F7573654D6F7665203D20286576656E7429203D3E207B0A2020202020202020202020206966202821746869732E5F69734C656674427574746F6E50726573736564286576656E742C207472756529207C7C2021746869732E5F6472';
wwv_flow_imp.g_varchar2_table(61) := '6177696E675374726F6B6529207B0A20202020202020202020202020202020746869732E5F7374726F6B65456E6428746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E74286576656E74292C2066616C7365293B0A2020';
wwv_flow_imp.g_varchar2_table(62) := '202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A202020202020202020202020746869732E5F7374726F6B654D6F766555706461746528746869732E5F706F696E7465724576656E74546F5369676E6174757265';
wwv_flow_imp.g_varchar2_table(63) := '4576656E74286576656E7429293B0A20202020202020207D3B0A2020202020202020746869732E5F68616E646C654D6F7573655570203D20286576656E7429203D3E207B0A20202020202020202020202069662028746869732E5F69734C656674427574';
wwv_flow_imp.g_varchar2_table(64) := '746F6E50726573736564286576656E742929207B0A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A202020202020202020202020746869732E5F7374726F6B65456E6428746869732E5F706F696E746572';
wwv_flow_imp.g_varchar2_table(65) := '4576656E74546F5369676E61747572654576656E74286576656E7429293B0A20202020202020207D3B0A2020202020202020746869732E5F68616E646C65546F7563685374617274203D20286576656E7429203D3E207B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(66) := '696620286576656E742E746172676574546F75636865732E6C656E67746820213D3D2031207C7C20746869732E5F64726177696E675374726F6B6529207B0A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D';
wwv_flow_imp.g_varchar2_table(67) := '0A202020202020202020202020696620286576656E742E63616E63656C61626C6529207B0A202020202020202020202020202020206576656E742E70726576656E7444656661756C7428293B0A2020202020202020202020207D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(68) := '202020746869732E5F7374726F6B65426567696E28746869732E5F746F7563684576656E74546F5369676E61747572654576656E74286576656E7429293B0A20202020202020207D3B0A2020202020202020746869732E5F68616E646C65546F7563684D';
wwv_flow_imp.g_varchar2_table(69) := '6F7665203D20286576656E7429203D3E207B0A202020202020202020202020696620286576656E742E746172676574546F75636865732E6C656E67746820213D3D203129207B0A2020202020202020202020202020202072657475726E3B0A2020202020';
wwv_flow_imp.g_varchar2_table(70) := '202020202020207D0A202020202020202020202020696620286576656E742E63616E63656C61626C6529207B0A202020202020202020202020202020206576656E742E70726576656E7444656661756C7428293B0A2020202020202020202020207D0A20';
wwv_flow_imp.g_varchar2_table(71) := '20202020202020202020206966202821746869732E5F64726177696E675374726F6B6529207B0A20202020202020202020202020202020746869732E5F7374726F6B65456E6428746869732E5F746F7563684576656E74546F5369676E61747572654576';
wwv_flow_imp.g_varchar2_table(72) := '656E74286576656E74292C2066616C7365293B0A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A202020202020202020202020746869732E5F7374726F6B654D6F766555706461746528746869732E5F74';
wwv_flow_imp.g_varchar2_table(73) := '6F7563684576656E74546F5369676E61747572654576656E74286576656E7429293B0A20202020202020207D3B0A2020202020202020746869732E5F68616E646C65546F756368456E64203D20286576656E7429203D3E207B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(74) := '2020696620286576656E742E746172676574546F75636865732E6C656E67746820213D3D203029207B0A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A202020202020202020202020696620286576656E';
wwv_flow_imp.g_varchar2_table(75) := '742E63616E63656C61626C6529207B0A202020202020202020202020202020206576656E742E70726576656E7444656661756C7428293B0A2020202020202020202020207D0A202020202020202020202020746869732E63616E7661732E72656D6F7665';
wwv_flow_imp.g_varchar2_table(76) := '4576656E744C697374656E65722827746F7563686D6F7665272C20746869732E5F68616E646C65546F7563684D6F7665293B0A202020202020202020202020746869732E5F7374726F6B65456E6428746869732E5F746F7563684576656E74546F536967';
wwv_flow_imp.g_varchar2_table(77) := '6E61747572654576656E74286576656E7429293B0A20202020202020207D3B0A2020202020202020746869732E5F68616E646C65506F696E746572446F776E203D20286576656E7429203D3E207B0A202020202020202020202020696620282174686973';
wwv_flow_imp.g_varchar2_table(78) := '2E5F69734C656674427574746F6E50726573736564286576656E7429207C7C20746869732E5F64726177696E675374726F6B6529207B0A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A20202020202020';
wwv_flow_imp.g_varchar2_table(79) := '20202020206576656E742E70726576656E7444656661756C7428293B0A202020202020202020202020746869732E5F7374726F6B65426567696E28746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E74286576656E7429';
wwv_flow_imp.g_varchar2_table(80) := '293B0A20202020202020207D3B0A2020202020202020746869732E5F68616E646C65506F696E7465724D6F7665203D20286576656E7429203D3E207B0A2020202020202020202020206966202821746869732E5F69734C656674427574746F6E50726573';
wwv_flow_imp.g_varchar2_table(81) := '736564286576656E742C207472756529207C7C2021746869732E5F64726177696E675374726F6B6529207B0A20202020202020202020202020202020746869732E5F7374726F6B65456E6428746869732E5F706F696E7465724576656E74546F5369676E';
wwv_flow_imp.g_varchar2_table(82) := '61747572654576656E74286576656E74292C2066616C7365293B0A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A2020202020202020202020206576656E742E70726576656E7444656661756C7428293B';
wwv_flow_imp.g_varchar2_table(83) := '0A202020202020202020202020746869732E5F7374726F6B654D6F766555706461746528746869732E5F706F696E7465724576656E74546F5369676E61747572654576656E74286576656E7429293B0A20202020202020207D3B0A202020202020202074';
wwv_flow_imp.g_varchar2_table(84) := '6869732E5F68616E646C65506F696E7465725570203D20286576656E7429203D3E207B0A20202020202020202020202069662028746869732E5F69734C656674427574746F6E50726573736564286576656E742929207B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(85) := '2020202072657475726E3B0A2020202020202020202020207D0A2020202020202020202020206576656E742E70726576656E7444656661756C7428293B0A202020202020202020202020746869732E5F7374726F6B65456E6428746869732E5F706F696E';
wwv_flow_imp.g_varchar2_table(86) := '7465724576656E74546F5369676E61747572654576656E74286576656E7429293B0A20202020202020207D3B0A2020202020202020746869732E76656C6F6369747946696C746572576569676874203D206F7074696F6E732E76656C6F6369747946696C';
wwv_flow_imp.g_varchar2_table(87) := '746572576569676874207C7C20302E373B0A2020202020202020746869732E6D696E5769647468203D206F7074696F6E732E6D696E5769647468207C7C20302E353B0A2020202020202020746869732E6D61785769647468203D206F7074696F6E732E6D';
wwv_flow_imp.g_varchar2_table(88) := '61785769647468207C7C20322E353B0A2020202020202020746869732E7468726F74746C65203D20285F61203D206F7074696F6E732E7468726F74746C652920213D3D206E756C6C202626205F6120213D3D20766F69642030203F205F61203A2031363B';
wwv_flow_imp.g_varchar2_table(89) := '0A2020202020202020746869732E6D696E44697374616E6365203D20285F62203D206F7074696F6E732E6D696E44697374616E63652920213D3D206E756C6C202626205F6220213D3D20766F69642030203F205F62203A20353B0A202020202020202074';
wwv_flow_imp.g_varchar2_table(90) := '6869732E646F7453697A65203D206F7074696F6E732E646F7453697A65207C7C20303B0A2020202020202020746869732E70656E436F6C6F72203D206F7074696F6E732E70656E436F6C6F72207C7C2027626C61636B273B0A2020202020202020746869';
wwv_flow_imp.g_varchar2_table(91) := '732E6261636B67726F756E64436F6C6F72203D206F7074696F6E732E6261636B67726F756E64436F6C6F72207C7C20277267626128302C302C302C3029273B0A2020202020202020746869732E636F6D706F736974654F7065726174696F6E203D206F70';
wwv_flow_imp.g_varchar2_table(92) := '74696F6E732E636F6D706F736974654F7065726174696F6E207C7C2027736F757263652D6F766572273B0A2020202020202020746869732E63616E766173436F6E746578744F7074696F6E73203D20285F63203D206F7074696F6E732E63616E76617343';
wwv_flow_imp.g_varchar2_table(93) := '6F6E746578744F7074696F6E732920213D3D206E756C6C202626205F6320213D3D20766F69642030203F205F63203A207B7D3B0A2020202020202020746869732E5F7374726F6B654D6F7665557064617465203D20746869732E7468726F74746C650A20';
wwv_flow_imp.g_varchar2_table(94) := '20202020202020202020203F207468726F74746C65285369676E61747572655061642E70726F746F747970652E5F7374726F6B655570646174652C20746869732E7468726F74746C65290A2020202020202020202020203A205369676E61747572655061';
wwv_flow_imp.g_varchar2_table(95) := '642E70726F746F747970652E5F7374726F6B655570646174653B0A2020202020202020746869732E5F637478203D2063616E7661732E676574436F6E7465787428273264272C20746869732E63616E766173436F6E746578744F7074696F6E73293B0A20';
wwv_flow_imp.g_varchar2_table(96) := '20202020202020746869732E636C65617228293B0A2020202020202020746869732E6F6E28293B0A202020207D0A20202020636C6561722829207B0A2020202020202020636F6E7374207B205F6374783A206374782C2063616E766173207D203D207468';
wwv_flow_imp.g_varchar2_table(97) := '69733B0A20202020202020206374782E66696C6C5374796C65203D20746869732E6261636B67726F756E64436F6C6F723B0A20202020202020206374782E636C6561725265637428302C20302C2063616E7661732E77696474682C2063616E7661732E68';
wwv_flow_imp.g_varchar2_table(98) := '6569676874293B0A20202020202020206374782E66696C6C5265637428302C20302C2063616E7661732E77696474682C2063616E7661732E686569676874293B0A2020202020202020746869732E5F64617461203D205B5D3B0A20202020202020207468';
wwv_flow_imp.g_varchar2_table(99) := '69732E5F726573657428746869732E5F676574506F696E7447726F75704F7074696F6E732829293B0A2020202020202020746869732E5F6973456D707479203D20747275653B0A202020207D0A2020202066726F6D4461746155524C286461746155726C';
wwv_flow_imp.g_varchar2_table(100) := '2C206F7074696F6E73203D207B7D29207B0A202020202020202072657475726E206E65772050726F6D69736528287265736F6C76652C2072656A65637429203D3E207B0A202020202020202020202020636F6E737420696D616765203D206E657720496D';
wwv_flow_imp.g_varchar2_table(101) := '61676528293B0A202020202020202020202020636F6E737420726174696F203D206F7074696F6E732E726174696F207C7C2077696E646F772E646576696365506978656C526174696F207C7C20313B0A202020202020202020202020636F6E7374207769';
wwv_flow_imp.g_varchar2_table(102) := '647468203D206F7074696F6E732E7769647468207C7C20746869732E63616E7661732E7769647468202F20726174696F3B0A202020202020202020202020636F6E737420686569676874203D206F7074696F6E732E686569676874207C7C20746869732E';
wwv_flow_imp.g_varchar2_table(103) := '63616E7661732E686569676874202F20726174696F3B0A202020202020202020202020636F6E737420784F6666736574203D206F7074696F6E732E784F6666736574207C7C20303B0A202020202020202020202020636F6E737420794F6666736574203D';
wwv_flow_imp.g_varchar2_table(104) := '206F7074696F6E732E794F6666736574207C7C20303B0A202020202020202020202020746869732E5F726573657428746869732E5F676574506F696E7447726F75704F7074696F6E732829293B0A202020202020202020202020696D6167652E6F6E6C6F';
wwv_flow_imp.g_varchar2_table(105) := '6164203D202829203D3E207B0A20202020202020202020202020202020746869732E5F6374782E64726177496D61676528696D6167652C20784F66667365742C20794F66667365742C2077696474682C20686569676874293B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(106) := '2020202020207265736F6C766528293B0A2020202020202020202020207D3B0A202020202020202020202020696D6167652E6F6E6572726F72203D20286572726F7229203D3E207B0A2020202020202020202020202020202072656A656374286572726F';
wwv_flow_imp.g_varchar2_table(107) := '72293B0A2020202020202020202020207D3B0A202020202020202020202020696D6167652E63726F73734F726967696E203D2027616E6F6E796D6F7573273B0A202020202020202020202020696D6167652E737263203D206461746155726C3B0A202020';
wwv_flow_imp.g_varchar2_table(108) := '202020202020202020746869732E5F6973456D707479203D2066616C73653B0A20202020202020207D293B0A202020207D0A20202020746F4461746155524C2874797065203D2027696D6167652F706E67272C20656E636F6465724F7074696F6E732920';
wwv_flow_imp.g_varchar2_table(109) := '7B0A202020202020202073776974636820287479706529207B0A202020202020202020202020636173652027696D6167652F7376672B786D6C273A0A2020202020202020202020202020202069662028747970656F6620656E636F6465724F7074696F6E';
wwv_flow_imp.g_varchar2_table(110) := '7320213D3D20276F626A6563742729207B0A2020202020202020202020202020202020202020656E636F6465724F7074696F6E73203D20756E646566696E65643B0A202020202020202020202020202020207D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(111) := '72657475726E2060646174613A696D6167652F7376672B786D6C3B6261736536342C247B62746F6128746869732E746F53564728656E636F6465724F7074696F6E7329297D603B0A20202020202020202020202064656661756C743A0A20202020202020';
wwv_flow_imp.g_varchar2_table(112) := '20202020202020202069662028747970656F6620656E636F6465724F7074696F6E7320213D3D20276E756D6265722729207B0A2020202020202020202020202020202020202020656E636F6465724F7074696F6E73203D20756E646566696E65643B0A20';
wwv_flow_imp.g_varchar2_table(113) := '2020202020202020202020202020207D0A2020202020202020202020202020202072657475726E20746869732E63616E7661732E746F4461746155524C28747970652C20656E636F6465724F7074696F6E73293B0A20202020202020207D0A202020207D';
wwv_flow_imp.g_varchar2_table(114) := '0A202020206F6E2829207B0A2020202020202020746869732E63616E7661732E7374796C652E746F756368416374696F6E203D20276E6F6E65273B0A2020202020202020746869732E63616E7661732E7374796C652E6D73546F756368416374696F6E20';
wwv_flow_imp.g_varchar2_table(115) := '3D20276E6F6E65273B0A2020202020202020746869732E63616E7661732E7374796C652E7573657253656C656374203D20276E6F6E65273B0A2020202020202020636F6E7374206973494F53203D202F4D6163696E746F73682F2E74657374286E617669';
wwv_flow_imp.g_varchar2_table(116) := '6761746F722E757365724167656E742920262620276F6E746F75636873746172742720696E20646F63756D656E743B0A20202020202020206966202877696E646F772E506F696E7465724576656E7420262620216973494F5329207B0A20202020202020';
wwv_flow_imp.g_varchar2_table(117) := '2020202020746869732E5F68616E646C65506F696E7465724576656E747328293B0A20202020202020207D0A2020202020202020656C7365207B0A202020202020202020202020746869732E5F68616E646C654D6F7573654576656E747328293B0A2020';
wwv_flow_imp.g_varchar2_table(118) := '2020202020202020202069662028276F6E746F75636873746172742720696E2077696E646F7729207B0A20202020202020202020202020202020746869732E5F68616E646C65546F7563684576656E747328293B0A2020202020202020202020207D0A20';
wwv_flow_imp.g_varchar2_table(119) := '202020202020207D0A202020207D0A202020206F66662829207B0A2020202020202020746869732E63616E7661732E7374796C652E746F756368416374696F6E203D20276175746F273B0A2020202020202020746869732E63616E7661732E7374796C65';
wwv_flow_imp.g_varchar2_table(120) := '2E6D73546F756368416374696F6E203D20276175746F273B0A2020202020202020746869732E63616E7661732E7374796C652E7573657253656C656374203D20276175746F273B0A2020202020202020746869732E63616E7661732E72656D6F76654576';
wwv_flow_imp.g_varchar2_table(121) := '656E744C697374656E65722827706F696E746572646F776E272C20746869732E5F68616E646C65506F696E746572446F776E293B0A2020202020202020746869732E63616E7661732E72656D6F76654576656E744C697374656E657228276D6F75736564';
wwv_flow_imp.g_varchar2_table(122) := '6F776E272C20746869732E5F68616E646C654D6F757365446F776E293B0A2020202020202020746869732E63616E7661732E72656D6F76654576656E744C697374656E65722827746F7563687374617274272C20746869732E5F68616E646C65546F7563';
wwv_flow_imp.g_varchar2_table(123) := '685374617274293B0A2020202020202020746869732E5F72656D6F76654D6F766555704576656E744C697374656E65727328293B0A202020207D0A202020207472696D576869746573706163652874797065203D2027696D6167652F706E672729207B0A';
wwv_flow_imp.g_varchar2_table(124) := '20202020202020202F2F204669727374206475706C6963617465207468652063616E76617320746F206E6F7420616C74657220746865206F726967696E616C0A20202020202020207661722063726F7070656443616E766173203D20646F63756D656E74';
wwv_flow_imp.g_varchar2_table(125) := '2E637265617465456C656D656E74282763616E76617327292C0A202020202020202063726F70706564437478202020203D2063726F7070656443616E7661732E676574436F6E746578742827326427293B0A0A202020202020202063726F707065644361';
wwv_flow_imp.g_varchar2_table(126) := '6E7661732E776964746820203D20746869732E63616E7661732E77696474683B0A202020202020202063726F7070656443616E7661732E686569676874203D20746869732E63616E7661732E6865696768743B0A202020202020202063726F7070656443';
wwv_flow_imp.g_varchar2_table(127) := '74782E64726177496D61676528746869732E63616E7661732C20302C2030293B0A0A20202020202020202F2F204E65787420646F207468652061637475616C2063726F7070696E670A202020202020202076617220772020202020202020203D2063726F';
wwv_flow_imp.g_varchar2_table(128) := '7070656443616E7661732E77696474682C0A202020202020202020202020682020202020202020203D2063726F7070656443616E7661732E6865696768742C0A202020202020202020202020706978202020202020203D207B783A5B5D2C20793A5B5D7D';
wwv_flow_imp.g_varchar2_table(129) := '2C0A202020202020202020202020696D61676544617461203D2063726F707065644374782E676574496D6167654461746128302C302C63726F7070656443616E7661732E77696474682C63726F7070656443616E7661732E686569676874292C0A202020';
wwv_flow_imp.g_varchar2_table(130) := '202020202020202020782C20792C20696E6465783B0A0A2020202020202020666F72202879203D20303B2079203C20683B20792B2B29207B0A202020202020202020202020666F72202878203D20303B2078203C20773B20782B2B29207B0A2020202020';
wwv_flow_imp.g_varchar2_table(131) := '2020202020202020202020696E646578203D202879202A2077202B207829202A20343B0A2020202020202020202020202020202069662028696D616765446174612E646174615B696E6465782B335D203E20302026262074797065203D3D2027696D6167';
wwv_flow_imp.g_varchar2_table(132) := '652F706E6727207C7C20696D616765446174612E646174615B696E6465785D20213D2032353520262620696D616765446174612E646174615B696E6465782B315D20213D2032353520262620696D616765446174612E646174615B696E6465782B325D20';
wwv_flow_imp.g_varchar2_table(133) := '213D203235352026262074797065203D3D2027696D6167652F6A7065672729207B0A20202020202020202020202020202020202020207069782E782E707573682878293B0A20202020202020202020202020202020202020207069782E792E7075736828';
wwv_flow_imp.g_varchar2_table(134) := '79293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D0A20202020202020207069782E782E736F72742866756E6374696F6E28612C62297B72657475726E20612D627D293B0A20202020202020';
wwv_flow_imp.g_varchar2_table(135) := '207069782E792E736F72742866756E6374696F6E28612C62297B72657475726E20612D627D293B0A2020202020202020766172206E203D207069782E782E6C656E6774682D313B0A0A202020202020202077203D207069782E785B6E5D202D207069782E';
wwv_flow_imp.g_varchar2_table(136) := '785B305D3B0A202020202020202068203D207069782E795B6E5D202D207069782E795B305D3B0A202020202020202076617220637574203D2063726F707065644374782E676574496D61676544617461287069782E785B305D2C207069782E795B305D2C';
wwv_flow_imp.g_varchar2_table(137) := '20772C2068293B20202020202020200A0A202020202020202063726F7070656443616E7661732E7769647468203D20773B0A202020202020202063726F7070656443616E7661732E686569676874203D20683B0A202020202020202063726F7070656443';
wwv_flow_imp.g_varchar2_table(138) := '74782E707574496D61676544617461286375742C20302C2030293B0A20202020202020200A202020202020202072657475726E2063726F7070656443616E7661732E746F4461746155524C2874797065293B0A202020207D0A202020205F6765744C6973';
wwv_flow_imp.g_varchar2_table(139) := '74656E657246756E6374696F6E732829207B0A2020202020202020766172205F613B0A2020202020202020636F6E73742063616E76617357696E646F77203D2077696E646F772E646F63756D656E74203D3D3D20746869732E63616E7661732E6F776E65';
wwv_flow_imp.g_varchar2_table(140) := '72446F63756D656E740A2020202020202020202020203F2077696E646F770A2020202020202020202020203A20285F61203D20746869732E63616E7661732E6F776E6572446F63756D656E742E64656661756C74566965772920213D3D206E756C6C2026';
wwv_flow_imp.g_varchar2_table(141) := '26205F6120213D3D20766F69642030203F205F61203A20746869732E63616E7661732E6F776E6572446F63756D656E743B0A202020202020202072657475726E207B0A2020202020202020202020206164644576656E744C697374656E65723A2063616E';
wwv_flow_imp.g_varchar2_table(142) := '76617357696E646F772E6164644576656E744C697374656E65722E62696E642863616E76617357696E646F77292C0A20202020202020202020202072656D6F76654576656E744C697374656E65723A2063616E76617357696E646F772E72656D6F766545';
wwv_flow_imp.g_varchar2_table(143) := '76656E744C697374656E65722E62696E642863616E76617357696E646F77292C0A20202020202020207D3B0A202020207D0A202020205F72656D6F76654D6F766555704576656E744C697374656E6572732829207B0A2020202020202020636F6E737420';
wwv_flow_imp.g_varchar2_table(144) := '7B2072656D6F76654576656E744C697374656E6572207D203D20746869732E5F6765744C697374656E657246756E6374696F6E7328293B0A202020202020202072656D6F76654576656E744C697374656E65722827706F696E7465726D6F7665272C2074';
wwv_flow_imp.g_varchar2_table(145) := '6869732E5F68616E646C65506F696E7465724D6F7665293B0A202020202020202072656D6F76654576656E744C697374656E65722827706F696E7465727570272C20746869732E5F68616E646C65506F696E7465725570293B0A20202020202020207265';
wwv_flow_imp.g_varchar2_table(146) := '6D6F76654576656E744C697374656E657228276D6F7573656D6F7665272C20746869732E5F68616E646C654D6F7573654D6F7665293B0A202020202020202072656D6F76654576656E744C697374656E657228276D6F7573657570272C20746869732E5F';
wwv_flow_imp.g_varchar2_table(147) := '68616E646C654D6F7573655570293B0A202020202020202072656D6F76654576656E744C697374656E65722827746F7563686D6F7665272C20746869732E5F68616E646C65546F7563684D6F7665293B0A202020202020202072656D6F76654576656E74';
wwv_flow_imp.g_varchar2_table(148) := '4C697374656E65722827746F756368656E64272C20746869732E5F68616E646C65546F756368456E64293B0A202020207D0A202020206973456D7074792829207B0A202020202020202072657475726E20746869732E5F6973456D7074793B0A20202020';
wwv_flow_imp.g_varchar2_table(149) := '7D0A2020202066726F6D4461746128706F696E7447726F7570732C207B20636C656172203D2074727565207D203D207B7D29207B0A202020202020202069662028636C65617229207B0A202020202020202020202020746869732E636C65617228293B0A';
wwv_flow_imp.g_varchar2_table(150) := '20202020202020207D0A2020202020202020746869732E5F66726F6D4461746128706F696E7447726F7570732C20746869732E5F6472617743757276652E62696E642874686973292C20746869732E5F64726177446F742E62696E64287468697329293B';
wwv_flow_imp.g_varchar2_table(151) := '0A2020202020202020746869732E5F64617461203D20746869732E5F646174612E636F6E63617428706F696E7447726F757073293B0A202020207D0A20202020746F446174612829207B0A202020202020202072657475726E20746869732E5F64617461';
wwv_flow_imp.g_varchar2_table(152) := '3B0A202020207D0A202020205F69734C656674427574746F6E50726573736564286576656E742C206F6E6C7929207B0A2020202020202020696620286F6E6C7929207B0A20202020202020202020202072657475726E206576656E742E627574746F6E73';
wwv_flow_imp.g_varchar2_table(153) := '203D3D3D20313B0A20202020202020207D0A202020202020202072657475726E20286576656E742E627574746F6E732026203129203D3D3D20313B0A202020207D0A202020205F706F696E7465724576656E74546F5369676E61747572654576656E7428';
wwv_flow_imp.g_varchar2_table(154) := '6576656E7429207B0A202020202020202072657475726E207B0A2020202020202020202020206576656E743A206576656E742C0A202020202020202020202020747970653A206576656E742E747970652C0A202020202020202020202020783A20657665';
wwv_flow_imp.g_varchar2_table(155) := '6E742E636C69656E74582C0A202020202020202020202020793A206576656E742E636C69656E74592C0A20202020202020202020202070726573737572653A202770726573737572652720696E206576656E74203F206576656E742E7072657373757265';
wwv_flow_imp.g_varchar2_table(156) := '203A20302C0A20202020202020207D3B0A202020207D0A202020205F746F7563684576656E74546F5369676E61747572654576656E74286576656E7429207B0A2020202020202020636F6E737420746F756368203D206576656E742E6368616E67656454';
wwv_flow_imp.g_varchar2_table(157) := '6F75636865735B305D3B0A202020202020202072657475726E207B0A2020202020202020202020206576656E743A206576656E742C0A202020202020202020202020747970653A206576656E742E747970652C0A202020202020202020202020783A2074';
wwv_flow_imp.g_varchar2_table(158) := '6F7563682E636C69656E74582C0A202020202020202020202020793A20746F7563682E636C69656E74592C0A20202020202020202020202070726573737572653A20746F7563682E666F7263652C0A20202020202020207D3B0A202020207D0A20202020';
wwv_flow_imp.g_varchar2_table(159) := '5F676574506F696E7447726F75704F7074696F6E732867726F757029207B0A202020202020202072657475726E207B0A20202020202020202020202070656E436F6C6F723A2067726F7570202626202770656E436F6C6F722720696E2067726F7570203F';
wwv_flow_imp.g_varchar2_table(160) := '2067726F75702E70656E436F6C6F72203A20746869732E70656E436F6C6F722C0A202020202020202020202020646F7453697A653A2067726F75702026262027646F7453697A652720696E2067726F7570203F2067726F75702E646F7453697A65203A20';
wwv_flow_imp.g_varchar2_table(161) := '746869732E646F7453697A652C0A2020202020202020202020206D696E57696474683A2067726F757020262620276D696E57696474682720696E2067726F7570203F2067726F75702E6D696E5769647468203A20746869732E6D696E57696474682C0A20';
wwv_flow_imp.g_varchar2_table(162) := '20202020202020202020206D617857696474683A2067726F757020262620276D617857696474682720696E2067726F7570203F2067726F75702E6D61785769647468203A20746869732E6D617857696474682C0A20202020202020202020202076656C6F';
wwv_flow_imp.g_varchar2_table(163) := '6369747946696C7465725765696768743A2067726F7570202626202776656C6F6369747946696C7465725765696768742720696E2067726F75700A202020202020202020202020202020203F2067726F75702E76656C6F6369747946696C746572576569';
wwv_flow_imp.g_varchar2_table(164) := '6768740A202020202020202020202020202020203A20746869732E76656C6F6369747946696C7465725765696768742C0A202020202020202020202020636F6D706F736974654F7065726174696F6E3A2067726F75702026262027636F6D706F73697465';
wwv_flow_imp.g_varchar2_table(165) := '4F7065726174696F6E2720696E2067726F75700A202020202020202020202020202020203F2067726F75702E636F6D706F736974654F7065726174696F6E0A202020202020202020202020202020203A20746869732E636F6D706F736974654F70657261';
wwv_flow_imp.g_varchar2_table(166) := '74696F6E2C0A20202020202020207D3B0A202020207D0A202020205F7374726F6B65426567696E286576656E7429207B0A2020202020202020636F6E73742063616E63656C6C6564203D2021746869732E64697370617463684576656E74286E65772043';
wwv_flow_imp.g_varchar2_table(167) := '7573746F6D4576656E742827626567696E5374726F6B65272C207B2064657461696C3A206576656E742C2063616E63656C61626C653A2074727565207D29293B0A20202020202020206966202863616E63656C6C656429207B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(168) := '202072657475726E3B0A20202020202020207D0A2020202020202020636F6E7374207B206164644576656E744C697374656E6572207D203D20746869732E5F6765744C697374656E657246756E6374696F6E7328293B0A20202020202020207377697463';
wwv_flow_imp.g_varchar2_table(169) := '6820286576656E742E6576656E742E7479706529207B0A2020202020202020202020206361736520276D6F757365646F776E273A0A202020202020202020202020202020206164644576656E744C697374656E657228276D6F7573656D6F7665272C2074';
wwv_flow_imp.g_varchar2_table(170) := '6869732E5F68616E646C654D6F7573654D6F7665293B0A202020202020202020202020202020206164644576656E744C697374656E657228276D6F7573657570272C20746869732E5F68616E646C654D6F7573655570293B0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(171) := '2020202020627265616B3B0A202020202020202020202020636173652027746F7563687374617274273A0A202020202020202020202020202020206164644576656E744C697374656E65722827746F7563686D6F7665272C20746869732E5F68616E646C';
wwv_flow_imp.g_varchar2_table(172) := '65546F7563684D6F7665293B0A202020202020202020202020202020206164644576656E744C697374656E65722827746F756368656E64272C20746869732E5F68616E646C65546F756368456E64293B0A20202020202020202020202020202020627265';
wwv_flow_imp.g_varchar2_table(173) := '616B3B0A202020202020202020202020636173652027706F696E746572646F776E273A0A202020202020202020202020202020206164644576656E744C697374656E65722827706F696E7465726D6F7665272C20746869732E5F68616E646C65506F696E';
wwv_flow_imp.g_varchar2_table(174) := '7465724D6F7665293B0A202020202020202020202020202020206164644576656E744C697374656E65722827706F696E7465727570272C20746869732E5F68616E646C65506F696E7465725570293B0A2020202020202020202020202020202062726561';
wwv_flow_imp.g_varchar2_table(175) := '6B3B0A20202020202020207D0A2020202020202020746869732E5F64726177696E675374726F6B65203D20747275653B0A2020202020202020636F6E737420706F696E7447726F75704F7074696F6E73203D20746869732E5F676574506F696E7447726F';
wwv_flow_imp.g_varchar2_table(176) := '75704F7074696F6E7328293B0A2020202020202020636F6E7374206E6577506F696E7447726F7570203D204F626A6563742E61737369676E284F626A6563742E61737369676E287B7D2C20706F696E7447726F75704F7074696F6E73292C207B20706F69';
wwv_flow_imp.g_varchar2_table(177) := '6E74733A205B5D207D293B0A2020202020202020746869732E5F646174612E70757368286E6577506F696E7447726F7570293B0A2020202020202020746869732E5F726573657428706F696E7447726F75704F7074696F6E73293B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(178) := '746869732E5F7374726F6B65557064617465286576656E74293B0A202020207D0A202020205F7374726F6B65557064617465286576656E7429207B0A20202020202020206966202821746869732E5F64726177696E675374726F6B6529207B0A20202020';
wwv_flow_imp.g_varchar2_table(179) := '202020202020202072657475726E3B0A20202020202020207D0A202020202020202069662028746869732E5F646174612E6C656E677468203D3D3D203029207B0A202020202020202020202020746869732E5F7374726F6B65426567696E286576656E74';
wwv_flow_imp.g_varchar2_table(180) := '293B0A20202020202020202020202072657475726E3B0A20202020202020207D0A2020202020202020746869732E64697370617463684576656E74286E657720437573746F6D4576656E7428276265666F72655570646174655374726F6B65272C207B20';
wwv_flow_imp.g_varchar2_table(181) := '64657461696C3A206576656E74207D29293B0A2020202020202020636F6E737420706F696E74203D20746869732E5F637265617465506F696E74286576656E742E782C206576656E742E792C206576656E742E7072657373757265293B0A202020202020';
wwv_flow_imp.g_varchar2_table(182) := '2020636F6E7374206C617374506F696E7447726F7570203D20746869732E5F646174615B746869732E5F646174612E6C656E677468202D20315D3B0A2020202020202020636F6E7374206C617374506F696E7473203D206C617374506F696E7447726F75';
wwv_flow_imp.g_varchar2_table(183) := '702E706F696E74733B0A2020202020202020636F6E7374206C617374506F696E74203D206C617374506F696E74732E6C656E677468203E2030202626206C617374506F696E74735B6C617374506F696E74732E6C656E677468202D20315D3B0A20202020';
wwv_flow_imp.g_varchar2_table(184) := '20202020636F6E73742069734C617374506F696E74546F6F436C6F7365203D206C617374506F696E740A2020202020202020202020203F20706F696E742E64697374616E6365546F286C617374506F696E7429203C3D20746869732E6D696E4469737461';
wwv_flow_imp.g_varchar2_table(185) := '6E63650A2020202020202020202020203A2066616C73653B0A2020202020202020636F6E737420706F696E7447726F75704F7074696F6E73203D20746869732E5F676574506F696E7447726F75704F7074696F6E73286C617374506F696E7447726F7570';
wwv_flow_imp.g_varchar2_table(186) := '293B0A202020202020202069662028216C617374506F696E74207C7C2021286C617374506F696E742026262069734C617374506F696E74546F6F436C6F73652929207B0A202020202020202020202020636F6E7374206375727665203D20746869732E5F';
wwv_flow_imp.g_varchar2_table(187) := '616464506F696E7428706F696E742C20706F696E7447726F75704F7074696F6E73293B0A20202020202020202020202069662028216C617374506F696E7429207B0A20202020202020202020202020202020746869732E5F64726177446F7428706F696E';
wwv_flow_imp.g_varchar2_table(188) := '742C20706F696E7447726F75704F7074696F6E73293B0A2020202020202020202020207D0A202020202020202020202020656C73652069662028637572766529207B0A20202020202020202020202020202020746869732E5F6472617743757276652863';
wwv_flow_imp.g_varchar2_table(189) := '757276652C20706F696E7447726F75704F7074696F6E73293B0A2020202020202020202020207D0A2020202020202020202020206C617374506F696E74732E70757368287B0A2020202020202020202020202020202074696D653A20706F696E742E7469';
wwv_flow_imp.g_varchar2_table(190) := '6D652C0A20202020202020202020202020202020783A20706F696E742E782C0A20202020202020202020202020202020793A20706F696E742E792C0A2020202020202020202020202020202070726573737572653A20706F696E742E7072657373757265';
wwv_flow_imp.g_varchar2_table(191) := '2C0A2020202020202020202020207D293B0A20202020202020207D0A2020202020202020746869732E64697370617463684576656E74286E657720437573746F6D4576656E74282761667465725570646174655374726F6B65272C207B2064657461696C';
wwv_flow_imp.g_varchar2_table(192) := '3A206576656E74207D29293B0A202020207D0A202020205F7374726F6B65456E64286576656E742C2073686F756C64557064617465203D207472756529207B0A2020202020202020746869732E5F72656D6F76654D6F766555704576656E744C69737465';
wwv_flow_imp.g_varchar2_table(193) := '6E65727328293B0A20202020202020206966202821746869732E5F64726177696E675374726F6B6529207B0A20202020202020202020202072657475726E3B0A20202020202020207D0A20202020202020206966202873686F756C645570646174652920';
wwv_flow_imp.g_varchar2_table(194) := '7B0A202020202020202020202020746869732E5F7374726F6B65557064617465286576656E74293B0A20202020202020207D0A2020202020202020746869732E5F64726177696E675374726F6B65203D2066616C73653B0A202020202020202074686973';
wwv_flow_imp.g_varchar2_table(195) := '2E64697370617463684576656E74286E657720437573746F6D4576656E742827656E645374726F6B65272C207B2064657461696C3A206576656E74207D29293B0A202020207D0A202020205F68616E646C65506F696E7465724576656E74732829207B0A';
wwv_flow_imp.g_varchar2_table(196) := '2020202020202020746869732E5F64726177696E675374726F6B65203D2066616C73653B0A2020202020202020746869732E63616E7661732E6164644576656E744C697374656E65722827706F696E746572646F776E272C20746869732E5F68616E646C';
wwv_flow_imp.g_varchar2_table(197) := '65506F696E746572446F776E293B0A202020207D0A202020205F68616E646C654D6F7573654576656E74732829207B0A2020202020202020746869732E5F64726177696E675374726F6B65203D2066616C73653B0A2020202020202020746869732E6361';
wwv_flow_imp.g_varchar2_table(198) := '6E7661732E6164644576656E744C697374656E657228276D6F757365646F776E272C20746869732E5F68616E646C654D6F757365446F776E293B0A202020207D0A202020205F68616E646C65546F7563684576656E74732829207B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(199) := '746869732E63616E7661732E6164644576656E744C697374656E65722827746F7563687374617274272C20746869732E5F68616E646C65546F7563685374617274293B0A202020207D0A202020205F7265736574286F7074696F6E7329207B0A20202020';
wwv_flow_imp.g_varchar2_table(200) := '20202020746869732E5F6C617374506F696E7473203D205B5D3B0A2020202020202020746869732E5F6C61737456656C6F63697479203D20303B0A2020202020202020746869732E5F6C6173745769647468203D20286F7074696F6E732E6D696E576964';
wwv_flow_imp.g_varchar2_table(201) := '7468202B206F7074696F6E732E6D6178576964746829202F20323B0A2020202020202020746869732E5F6374782E66696C6C5374796C65203D206F7074696F6E732E70656E436F6C6F723B0A2020202020202020746869732E5F6374782E676C6F62616C';
wwv_flow_imp.g_varchar2_table(202) := '436F6D706F736974654F7065726174696F6E203D206F7074696F6E732E636F6D706F736974654F7065726174696F6E3B0A202020207D0A202020205F637265617465506F696E7428782C20792C20707265737375726529207B0A2020202020202020636F';
wwv_flow_imp.g_varchar2_table(203) := '6E73742072656374203D20746869732E63616E7661732E676574426F756E64696E67436C69656E745265637428293B0A202020202020202072657475726E206E657720506F696E742878202D20726563742E6C6566742C2079202D20726563742E746F70';
wwv_flow_imp.g_varchar2_table(204) := '2C2070726573737572652C206E6577204461746528292E67657454696D652829293B0A202020207D0A202020205F616464506F696E7428706F696E742C206F7074696F6E7329207B0A2020202020202020636F6E7374207B205F6C617374506F696E7473';
wwv_flow_imp.g_varchar2_table(205) := '207D203D20746869733B0A20202020202020205F6C617374506F696E74732E7075736828706F696E74293B0A2020202020202020696620285F6C617374506F696E74732E6C656E677468203E203229207B0A202020202020202020202020696620285F6C';
wwv_flow_imp.g_varchar2_table(206) := '617374506F696E74732E6C656E677468203D3D3D203329207B0A202020202020202020202020202020205F6C617374506F696E74732E756E7368696674285F6C617374506F696E74735B305D293B0A2020202020202020202020207D0A20202020202020';
wwv_flow_imp.g_varchar2_table(207) := '2020202020636F6E737420776964746873203D20746869732E5F63616C63756C6174654375727665576964746873285F6C617374506F696E74735B315D2C205F6C617374506F696E74735B325D2C206F7074696F6E73293B0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(208) := '20636F6E7374206375727665203D2042657A6965722E66726F6D506F696E7473285F6C617374506F696E74732C20776964746873293B0A2020202020202020202020205F6C617374506F696E74732E736869667428293B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(209) := '72657475726E2063757276653B0A20202020202020207D0A202020202020202072657475726E206E756C6C3B0A202020207D0A202020205F63616C63756C6174654375727665576964746873287374617274506F696E742C20656E64506F696E742C206F';
wwv_flow_imp.g_varchar2_table(210) := '7074696F6E7329207B0A2020202020202020636F6E73742076656C6F63697479203D206F7074696F6E732E76656C6F6369747946696C746572576569676874202A20656E64506F696E742E76656C6F6369747946726F6D287374617274506F696E742920';
wwv_flow_imp.g_varchar2_table(211) := '2B0A2020202020202020202020202831202D206F7074696F6E732E76656C6F6369747946696C74657257656967687429202A20746869732E5F6C61737456656C6F636974793B0A2020202020202020636F6E7374206E65775769647468203D2074686973';
wwv_flow_imp.g_varchar2_table(212) := '2E5F7374726F6B6557696474682876656C6F636974792C206F7074696F6E73293B0A2020202020202020636F6E737420776964746873203D207B0A202020202020202020202020656E643A206E657757696474682C0A2020202020202020202020207374';
wwv_flow_imp.g_varchar2_table(213) := '6172743A20746869732E5F6C61737457696474682C0A20202020202020207D3B0A2020202020202020746869732E5F6C61737456656C6F63697479203D2076656C6F636974793B0A2020202020202020746869732E5F6C6173745769647468203D206E65';
wwv_flow_imp.g_varchar2_table(214) := '7757696474683B0A202020202020202072657475726E207769647468733B0A202020207D0A202020205F7374726F6B6557696474682876656C6F636974792C206F7074696F6E7329207B0A202020202020202072657475726E204D6174682E6D6178286F';
wwv_flow_imp.g_varchar2_table(215) := '7074696F6E732E6D61785769647468202F202876656C6F63697479202B2031292C206F7074696F6E732E6D696E5769647468293B0A202020207D0A202020205F6472617743757276655365676D656E7428782C20792C20776964746829207B0A20202020';
wwv_flow_imp.g_varchar2_table(216) := '20202020636F6E737420637478203D20746869732E5F6374783B0A20202020202020206374782E6D6F7665546F28782C2079293B0A20202020202020206374782E61726328782C20792C2077696474682C20302C2032202A204D6174682E50492C206661';
wwv_flow_imp.g_varchar2_table(217) := '6C7365293B0A2020202020202020746869732E5F6973456D707479203D2066616C73653B0A202020207D0A202020205F6472617743757276652863757276652C206F7074696F6E7329207B0A2020202020202020636F6E737420637478203D2074686973';
wwv_flow_imp.g_varchar2_table(218) := '2E5F6374783B0A2020202020202020636F6E737420776964746844656C7461203D2063757276652E656E645769647468202D2063757276652E737461727457696474683B0A2020202020202020636F6E737420647261775374657073203D204D6174682E';
wwv_flow_imp.g_varchar2_table(219) := '6365696C2863757276652E6C656E677468282929202A20323B0A20202020202020206374782E626567696E5061746828293B0A20202020202020206374782E66696C6C5374796C65203D206F7074696F6E732E70656E436F6C6F723B0A20202020202020';
wwv_flow_imp.g_varchar2_table(220) := '20666F7220286C65742069203D20303B2069203C206472617753746570733B2069202B3D203129207B0A202020202020202020202020636F6E73742074203D2069202F206472617753746570733B0A202020202020202020202020636F6E737420747420';
wwv_flow_imp.g_varchar2_table(221) := '3D2074202A20743B0A202020202020202020202020636F6E737420747474203D207474202A20743B0A202020202020202020202020636F6E73742075203D2031202D20743B0A202020202020202020202020636F6E7374207575203D2075202A20753B0A';
wwv_flow_imp.g_varchar2_table(222) := '202020202020202020202020636F6E737420757575203D207575202A20753B0A2020202020202020202020206C65742078203D20757575202A2063757276652E7374617274506F696E742E783B0A20202020202020202020202078202B3D2033202A2075';
wwv_flow_imp.g_varchar2_table(223) := '75202A2074202A2063757276652E636F6E74726F6C312E783B0A20202020202020202020202078202B3D2033202A2075202A207474202A2063757276652E636F6E74726F6C322E783B0A20202020202020202020202078202B3D20747474202A20637572';
wwv_flow_imp.g_varchar2_table(224) := '76652E656E64506F696E742E783B0A2020202020202020202020206C65742079203D20757575202A2063757276652E7374617274506F696E742E793B0A20202020202020202020202079202B3D2033202A207575202A2074202A2063757276652E636F6E';
wwv_flow_imp.g_varchar2_table(225) := '74726F6C312E793B0A20202020202020202020202079202B3D2033202A2075202A207474202A2063757276652E636F6E74726F6C322E793B0A20202020202020202020202079202B3D20747474202A2063757276652E656E64506F696E742E793B0A2020';
wwv_flow_imp.g_varchar2_table(226) := '20202020202020202020636F6E7374207769647468203D204D6174682E6D696E2863757276652E73746172745769647468202B20747474202A20776964746844656C74612C206F7074696F6E732E6D61785769647468293B0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(227) := '20746869732E5F6472617743757276655365676D656E7428782C20792C207769647468293B0A20202020202020207D0A20202020202020206374782E636C6F73655061746828293B0A20202020202020206374782E66696C6C28293B0A202020207D0A20';
wwv_flow_imp.g_varchar2_table(228) := '2020205F64726177446F7428706F696E742C206F7074696F6E7329207B0A2020202020202020636F6E737420637478203D20746869732E5F6374783B0A2020202020202020636F6E7374207769647468203D206F7074696F6E732E646F7453697A65203E';
wwv_flow_imp.g_varchar2_table(229) := '20300A2020202020202020202020203F206F7074696F6E732E646F7453697A650A2020202020202020202020203A20286F7074696F6E732E6D696E5769647468202B206F7074696F6E732E6D6178576964746829202F20323B0A20202020202020206374';
wwv_flow_imp.g_varchar2_table(230) := '782E626567696E5061746828293B0A2020202020202020746869732E5F6472617743757276655365676D656E7428706F696E742E782C20706F696E742E792C207769647468293B0A20202020202020206374782E636C6F73655061746828293B0A202020';
wwv_flow_imp.g_varchar2_table(231) := '20202020206374782E66696C6C5374796C65203D206F7074696F6E732E70656E436F6C6F723B0A20202020202020206374782E66696C6C28293B0A202020207D0A202020205F66726F6D4461746128706F696E7447726F7570732C206472617743757276';
wwv_flow_imp.g_varchar2_table(232) := '652C2064726177446F7429207B0A2020202020202020666F722028636F6E73742067726F7570206F6620706F696E7447726F75707329207B0A202020202020202020202020636F6E7374207B20706F696E7473207D203D2067726F75703B0A2020202020';
wwv_flow_imp.g_varchar2_table(233) := '20202020202020636F6E737420706F696E7447726F75704F7074696F6E73203D20746869732E5F676574506F696E7447726F75704F7074696F6E732867726F7570293B0A20202020202020202020202069662028706F696E74732E6C656E677468203E20';
wwv_flow_imp.g_varchar2_table(234) := '3129207B0A20202020202020202020202020202020666F7220286C6574206A203D20303B206A203C20706F696E74732E6C656E6774683B206A202B3D203129207B0A2020202020202020202020202020202020202020636F6E7374206261736963506F69';
wwv_flow_imp.g_varchar2_table(235) := '6E74203D20706F696E74735B6A5D3B0A2020202020202020202020202020202020202020636F6E737420706F696E74203D206E657720506F696E74286261736963506F696E742E782C206261736963506F696E742E792C206261736963506F696E742E70';
wwv_flow_imp.g_varchar2_table(236) := '726573737572652C206261736963506F696E742E74696D65293B0A2020202020202020202020202020202020202020696620286A203D3D3D203029207B0A202020202020202020202020202020202020202020202020746869732E5F726573657428706F';
wwv_flow_imp.g_varchar2_table(237) := '696E7447726F75704F7074696F6E73293B0A20202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020636F6E7374206375727665203D20746869732E5F616464506F696E7428706F696E742C20706F696E';
wwv_flow_imp.g_varchar2_table(238) := '7447726F75704F7074696F6E73293B0A202020202020202020202020202020202020202069662028637572766529207B0A2020202020202020202020202020202020202020202020206472617743757276652863757276652C20706F696E7447726F7570';
wwv_flow_imp.g_varchar2_table(239) := '4F7074696F6E73293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A2020202020202020202020207D0A202020202020202020202020656C7365207B0A2020202020202020202020202020202074';
wwv_flow_imp.g_varchar2_table(240) := '6869732E5F726573657428706F696E7447726F75704F7074696F6E73293B0A2020202020202020202020202020202064726177446F7428706F696E74735B305D2C20706F696E7447726F75704F7074696F6E73293B0A2020202020202020202020207D0A';
wwv_flow_imp.g_varchar2_table(241) := '20202020202020207D0A202020207D0A20202020746F535647287B20696E636C7564654261636B67726F756E64436F6C6F72203D2066616C7365207D203D207B7D29207B0A2020202020202020636F6E737420706F696E7447726F757073203D20746869';
wwv_flow_imp.g_varchar2_table(242) := '732E5F646174613B0A2020202020202020636F6E737420726174696F203D204D6174682E6D61782877696E646F772E646576696365506978656C526174696F207C7C20312C2031293B0A2020202020202020636F6E7374206D696E58203D20303B0A2020';
wwv_flow_imp.g_varchar2_table(243) := '202020202020636F6E7374206D696E59203D20303B0A2020202020202020636F6E7374206D617858203D20746869732E63616E7661732E7769647468202F20726174696F3B0A2020202020202020636F6E7374206D617859203D20746869732E63616E76';
wwv_flow_imp.g_varchar2_table(244) := '61732E686569676874202F20726174696F3B0A2020202020202020636F6E737420737667203D20646F63756D656E742E637265617465456C656D656E744E532827687474703A2F2F7777772E77332E6F72672F323030302F737667272C20277376672729';
wwv_flow_imp.g_varchar2_table(245) := '3B0A20202020202020207376672E7365744174747269627574652827786D6C6E73272C2027687474703A2F2F7777772E77332E6F72672F323030302F73766727293B0A20202020202020207376672E7365744174747269627574652827786D6C6E733A78';
wwv_flow_imp.g_varchar2_table(246) := '6C696E6B272C2027687474703A2F2F7777772E77332E6F72672F313939392F786C696E6B27293B0A20202020202020207376672E736574417474726962757465282776696577426F78272C2060247B6D696E587D20247B6D696E597D20247B6D6178587D';
wwv_flow_imp.g_varchar2_table(247) := '20247B6D6178597D60293B0A20202020202020207376672E73657441747472696275746528277769647468272C206D6178582E746F537472696E672829293B0A20202020202020207376672E7365744174747269627574652827686569676874272C206D';
wwv_flow_imp.g_varchar2_table(248) := '6178592E746F537472696E672829293B0A202020202020202069662028696E636C7564654261636B67726F756E64436F6C6F7220262620746869732E6261636B67726F756E64436F6C6F7229207B0A202020202020202020202020636F6E737420726563';
wwv_flow_imp.g_varchar2_table(249) := '74203D20646F63756D656E742E637265617465456C656D656E7428277265637427293B0A202020202020202020202020726563742E73657441747472696275746528277769647468272C20273130302527293B0A20202020202020202020202072656374';
wwv_flow_imp.g_varchar2_table(250) := '2E7365744174747269627574652827686569676874272C20273130302527293B0A202020202020202020202020726563742E736574417474726962757465282766696C6C272C20746869732E6261636B67726F756E64436F6C6F72293B0A202020202020';
wwv_flow_imp.g_varchar2_table(251) := '2020202020207376672E617070656E644368696C642872656374293B0A20202020202020207D0A2020202020202020746869732E5F66726F6D4461746128706F696E7447726F7570732C202863757276652C207B2070656E436F6C6F72207D29203D3E20';
wwv_flow_imp.g_varchar2_table(252) := '7B0A202020202020202020202020636F6E73742070617468203D20646F63756D656E742E637265617465456C656D656E7428277061746827293B0A202020202020202020202020696620282169734E614E2863757276652E636F6E74726F6C312E782920';
wwv_flow_imp.g_varchar2_table(253) := '26260A202020202020202020202020202020202169734E614E2863757276652E636F6E74726F6C312E79292026260A202020202020202020202020202020202169734E614E2863757276652E636F6E74726F6C322E78292026260A202020202020202020';
wwv_flow_imp.g_varchar2_table(254) := '202020202020202169734E614E2863757276652E636F6E74726F6C322E792929207B0A20202020202020202020202020202020636F6E73742061747472203D20604D20247B63757276652E7374617274506F696E742E782E746F46697865642833297D2C';
wwv_flow_imp.g_varchar2_table(255) := '247B63757276652E7374617274506F696E742E792E746F46697865642833297D2060202B0A2020202020202020202020202020202020202020604320247B63757276652E636F6E74726F6C312E782E746F46697865642833297D2C247B63757276652E63';
wwv_flow_imp.g_varchar2_table(256) := '6F6E74726F6C312E792E746F46697865642833297D2060202B0A202020202020202020202020202020202020202060247B63757276652E636F6E74726F6C322E782E746F46697865642833297D2C247B63757276652E636F6E74726F6C322E792E746F46';
wwv_flow_imp.g_varchar2_table(257) := '697865642833297D2060202B0A202020202020202020202020202020202020202060247B63757276652E656E64506F696E742E782E746F46697865642833297D2C247B63757276652E656E64506F696E742E792E746F46697865642833297D603B0A2020';
wwv_flow_imp.g_varchar2_table(258) := '2020202020202020202020202020706174682E736574417474726962757465282764272C2061747472293B0A20202020202020202020202020202020706174682E73657441747472696275746528277374726F6B652D7769647468272C20286375727665';
wwv_flow_imp.g_varchar2_table(259) := '2E656E645769647468202A20322E3235292E746F4669786564283329293B0A20202020202020202020202020202020706174682E73657441747472696275746528277374726F6B65272C2070656E436F6C6F72293B0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(260) := '2020706174682E736574417474726962757465282766696C6C272C20276E6F6E6527293B0A20202020202020202020202020202020706174682E73657441747472696275746528277374726F6B652D6C696E65636170272C2027726F756E6427293B0A20';
wwv_flow_imp.g_varchar2_table(261) := '2020202020202020202020202020207376672E617070656E644368696C642870617468293B0A2020202020202020202020207D0A20202020202020207D2C2028706F696E742C207B2070656E436F6C6F722C20646F7453697A652C206D696E5769647468';
wwv_flow_imp.g_varchar2_table(262) := '2C206D61785769647468207D29203D3E207B0A202020202020202020202020636F6E737420636972636C65203D20646F63756D656E742E637265617465456C656D656E742827636972636C6527293B0A202020202020202020202020636F6E7374207369';
wwv_flow_imp.g_varchar2_table(263) := '7A65203D20646F7453697A65203E2030203F20646F7453697A65203A20286D696E5769647468202B206D6178576964746829202F20323B0A202020202020202020202020636972636C652E736574417474726962757465282772272C2073697A652E746F';
wwv_flow_imp.g_varchar2_table(264) := '537472696E672829293B0A202020202020202020202020636972636C652E73657441747472696275746528276378272C20706F696E742E782E746F537472696E672829293B0A202020202020202020202020636972636C652E7365744174747269627574';
wwv_flow_imp.g_varchar2_table(265) := '6528276379272C20706F696E742E792E746F537472696E672829293B0A202020202020202020202020636972636C652E736574417474726962757465282766696C6C272C2070656E436F6C6F72293B0A2020202020202020202020207376672E61707065';
wwv_flow_imp.g_varchar2_table(266) := '6E644368696C6428636972636C65293B0A20202020202020207D293B0A202020202020202072657475726E207376672E6F7574657248544D4C3B0A202020207D0A7D0A72657475726E205369676E61747572655061643B0A7D29293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(2103360423406427775)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_file_name=>'js/signature_pad.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2F2041504558205369676E61747572652066756E6374696F6E730A2F2F20417574686F723A2044616E69656C20486F63686C6569746E65720A2F2F2056657273696F6E3A20312E320A0A2F2F20676C6F62616C206E616D6573706163650A7661722061';
wwv_flow_imp.g_varchar2_table(2) := '7065785369676E6174757265203D207B0A202020202F2F20706172736520737472696E6720746F20626F6F6C65616E0A202020207061727365426F6F6C65616E3A2066756E6374696F6E2870537472696E6729207B0A2020202020202020766172207042';
wwv_flow_imp.g_varchar2_table(3) := '6F6F6C65616E3B0A20202020202020206966202870537472696E672E746F4C6F776572436173652829203D3D2027747275652729207B0A20202020202020202020202070426F6F6C65616E203D20747275653B0A20202020202020207D0A202020202020';
wwv_flow_imp.g_varchar2_table(4) := '20206966202870537472696E672E746F4C6F776572436173652829203D3D202766616C73652729207B0A20202020202020202020202070426F6F6C65616E203D2066616C73653B0A20202020202020207D0A202020202020202069662028212870537472';
wwv_flow_imp.g_varchar2_table(5) := '696E672E746F4C6F776572436173652829203D3D202774727565272920262620212870537472696E672E746F4C6F776572436173652829203D3D202766616C7365272929207B0A20202020202020202020202070426F6F6C65616E203D20756E64656669';
wwv_flow_imp.g_varchar2_table(6) := '6E65643B0A20202020202020207D0A202020202020202072657475726E2070426F6F6C65616E3B0A202020207D2C0A202020202F2F206275696C64732061206A732061727261792066726F6D206C6F6E6720737472696E670A20202020636C6F62324172';
wwv_flow_imp.g_varchar2_table(7) := '7261793A2066756E6374696F6E28636C6F622C2073697A652C20617272617929207B0A20202020202020206C6F6F70436F756E74203D204D6174682E666C6F6F7228636C6F622E6C656E677468202F2073697A6529202B20313B0A202020202020202066';
wwv_flow_imp.g_varchar2_table(8) := '6F7220287661722069203D20303B2069203C206C6F6F70436F756E743B20692B2B29207B0A20202020202020202020202061727261792E7075736828636C6F622E736C6963652873697A65202A20692C2073697A65202A202869202B20312929293B0A20';
wwv_flow_imp.g_varchar2_table(9) := '202020202020207D0A202020202020202072657475726E2061727261793B0A202020207D2C0A202020202F2F20636F6E7665727473204461746155524920746F2062617365363420737472696E670A2020202064617461555249326261736536343A2066';
wwv_flow_imp.g_varchar2_table(10) := '756E6374696F6E286461746155524929207B0A202020202020202076617220626173653634203D20646174615552492E73756273747228646174615552492E696E6465784F6628272C2729202B2031293B0A202020202020202072657475726E20626173';
wwv_flow_imp.g_varchar2_table(11) := '6536343B0A202020207D2C0A202020202F2F207361766520746F2044422066756E6374696F6E0A20202020736176653244623A2066756E6374696F6E28704F7074696F6E732C2070526567696F6E49642C2070496D672C2063616C6C6261636B29207B0A';
wwv_flow_imp.g_varchar2_table(12) := '20202020202020202F2F20696D67204461746155524920746F206261736536340A202020202020202076617220626173653634203D20617065785369676E61747572652E64617461555249326261736536342870496D67293B0A20202020202020202F2F';
wwv_flow_imp.g_varchar2_table(13) := '2073706C69742062617365363420636C6F6220737472696E6720746F20663031206172726179206C656E6774682033306B0A2020202020202020766172206630314172726179203D205B5D3B0A20202020202020206630314172726179203D2061706578';
wwv_flow_imp.g_varchar2_table(14) := '5369676E61747572652E636C6F62324172726179286261736536342C2033303030302C206630314172726179293B0A20202020202020202F2F204170657820416A61782043616C6C0A2020202020202020617065782E7365727665722E706C7567696E28';
wwv_flow_imp.g_varchar2_table(15) := '704F7074696F6E732E616A61784964656E7469666965722C207B0A2020202020202020202020206630313A2066303141727261792C0A2020202020202020202020202F2F202331333A20416C6C6F777320666F72206974656D7320746F20626520737562';
wwv_flow_imp.g_varchar2_table(16) := '6D69747465640A202020202020202020202020706167654974656D733A2028747970656F6620704F7074696F6E732E616A61784974656D73546F5375626D697420213D2022756E646566696E65642229203F20704F7074696F6E732E616A61784974656D';
wwv_flow_imp.g_varchar2_table(17) := '73546F5375626D69742E73706C697428272C2729203A206E756C6C0A20202020202020207D2C207B0A20202020202020202020202064617461547970653A202768746D6C272C0A2020202020202020202020202F2F205355434553532066756E6374696F';
wwv_flow_imp.g_varchar2_table(18) := '6E0A202020202020202020202020737563636573733A2066756E6374696F6E286461746129207B0A202020202020202020202020202020202F2F206164642061706578206576656E740A202020202020202020202020202020202428272327202B207052';
wwv_flow_imp.g_varchar2_table(19) := '6567696F6E4964292E747269676765722827617065787369676E61747572652D73617665642D6462272C204A534F4E2E70617273652864617461203F2064617461203A20277B7D2729293B0A202020202020202020202020202020202F2F2063616C6C62';
wwv_flow_imp.g_varchar2_table(20) := '61636B0A2020202020202020202020202020202063616C6C6261636B28293B0A2020202020202020202020207D2C0A2020202020202020202020202F2F204552524F522066756E6374696F6E0A2020202020202020202020206572726F723A2066756E63';
wwv_flow_imp.g_varchar2_table(21) := '74696F6E287868722C20704D65737361676529207B0A202020202020202020202020202020202F2F206164642061706578206576656E740A202020202020202020202020202020202428272327202B2070526567696F6E4964292E747269676765722827';
wwv_flow_imp.g_varchar2_table(22) := '617065787369676E61747572652D6572726F722D646227293B0A20202020202020202020202020202020636F6E736F6C652E6C6F672827736176653244623A20617065782E7365727665722E706C7567696E204552524F523A272C20704D657373616765';
wwv_flow_imp.g_varchar2_table(23) := '293B0A202020202020202020202020202020202F2F2063616C6C6261636B0A2020202020202020202020202020202063616C6C6261636B28293B0A2020202020202020202020207D0A20202020202020207D293B0A202020207D2C0A202020202F2F2066';
wwv_flow_imp.g_varchar2_table(24) := '756E6374696F6E207468617420676574732063616C6C65642066726F6D20706C7567696E0A20202020617065785369676E6174757265466E633A2066756E6374696F6E2870526567696F6E49642C20704F7074696F6E732C20704C6F6767696E6729207B';
wwv_flow_imp.g_varchar2_table(25) := '0A202020202020202076617220764F7074696F6E73203D20704F7074696F6E733B0A2020202020202020766172207643616E76617324203D20646F63756D656E742E676574456C656D656E744279496428764F7074696F6E732E63616E7661734964293B';
wwv_flow_imp.g_varchar2_table(26) := '0A202020202020202076617220764C6F6767696E67203D20617065785369676E61747572652E7061727365426F6F6C65616E28704C6F6767696E67293B0A202020202020202076617220764D696E5769647468203D207061727365496E7428764F707469';
wwv_flow_imp.g_varchar2_table(27) := '6F6E732E6C696E654D696E5769647468293B0A202020202020202076617220764D61785769647468203D207061727365496E7428764F7074696F6E732E6C696E654D61785769647468293B0A20202020202020207661722076436C65617242746E53656C';
wwv_flow_imp.g_varchar2_table(28) := '6563746F72203D20764F7074696F6E732E636C656172427574746F6E3B0A202020202020202076617220765361766542746E53656C6563746F72203D20764F7074696F6E732E73617665427574746F6E3B0A20202020202020207661722076456D707479';
wwv_flow_imp.g_varchar2_table(29) := '416C657274203D20764F7074696F6E732E656D707479416C6572743B0909090909090909090920200A2020202020202020766172207653686F775370696E6E6572203D20617065785369676E61747572652E7061727365426F6F6C65616E28764F707469';
wwv_flow_imp.g_varchar2_table(30) := '6F6E732E73686F775370696E6E6572293B0A2020202020202020766172207643616E7661735769647468203D207643616E766173242E77696474683B0A2020202020202020766172207643616E766173486569676874203D207643616E766173242E6865';
wwv_flow_imp.g_varchar2_table(31) := '696768743B0A20202020202020207661722076436C69656E745769647468203D207061727365496E7428646F63756D656E742E646F63756D656E74456C656D656E742E636C69656E745769647468293B0A202020202020202076617220764369656E7448';
wwv_flow_imp.g_varchar2_table(32) := '6569676874203D207061727365496E7428646F63756D656E742E646F63756D656E74456C656D656E742E636C69656E74486569676874293B0A202020202020202076617220765472696D43616E766173203D20617065785369676E61747572652E706172';
wwv_flow_imp.g_varchar2_table(33) := '7365426F6F6C65616E28764F7074696F6E732E7472696D43616E766173293B0A20202020202020207661722076496D616765466F726D6174203D20764F7074696F6E732E696D616765466F726D61743B0A20202020202020202F2F206A70656720646F65';
wwv_flow_imp.g_varchar2_table(34) := '736E277420737570706F7274207472616E73706172656E74206261636B67726F756E64732E20536F207765206368616E6765206974206261636B20746F207267622069662072676261206973207365742E0A202020202020202076617220764261636B67';
wwv_flow_imp.g_varchar2_table(35) := '726F756E64436F6C6F72203D202876496D616765466F726D6174203D3D2022696D6167652F6A7065672229203F20764F7074696F6E732E6261636B67726F756E64436F6C6F722E7265706C616365282272676261222C2272676222292E7265706C616365';
wwv_flow_imp.g_varchar2_table(36) := '282F2C285C642B285C2E5C642B293F5C2929242F2C2027292729203A20764F7074696F6E732E6261636B67726F756E64436F6C6F723B0A0A20202020202020202F2F204C6F6767696E670A202020202020202069662028764C6F6767696E6729207B0A20';
wwv_flow_imp.g_varchar2_table(37) := '2020202020202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265466E633A20764F7074696F6E732E616A61784964656E7469666965723A272C20764F7074696F6E732E616A61784964656E746966696572293B0A2020202020';
wwv_flow_imp.g_varchar2_table(38) := '20202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265466E633A20764F7074696F6E732E616A61784974656D73546F5375626D69743A272C20764F7074696F6E732E616A61784974656D73546F5375626D6974293B0A202020';
wwv_flow_imp.g_varchar2_table(39) := '202020202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265466E633A20764F7074696F6E732E63616E76617349643A272C20764F7074696F6E732E63616E7661734964293B0A202020202020202020202020636F6E736F6C65';
wwv_flow_imp.g_varchar2_table(40) := '2E6C6F672827617065785369676E6174757265466E633A20764F7074696F6E732E6C696E654D696E57696474683A272C20764F7074696F6E732E6C696E654D696E5769647468293B0A202020202020202020202020636F6E736F6C652E6C6F6728276170';
wwv_flow_imp.g_varchar2_table(41) := '65785369676E6174757265466E633A20764F7074696F6E732E6C696E654D617857696474683A272C20764F7074696F6E732E6C696E654D61785769647468293B0A202020202020202020202020636F6E736F6C652E6C6F672827617065785369676E6174';
wwv_flow_imp.g_varchar2_table(42) := '757265466E633A20764F7074696F6E732E6261636B67726F756E64436F6C6F723A272C20764261636B67726F756E64436F6C6F72293B0A202020202020202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265466E633A20764F';
wwv_flow_imp.g_varchar2_table(43) := '7074696F6E732E70656E436F6C6F723A272C20764F7074696F6E732E70656E436F6C6F72293B0A202020202020202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265466E633A20764F7074696F6E732E73617665427574746F';
wwv_flow_imp.g_varchar2_table(44) := '6E3A272C20764F7074696F6E732E73617665427574746F6E293B0A202020202020202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265466E633A20764F7074696F6E732E636C656172427574746F6E3A272C20764F7074696F';
wwv_flow_imp.g_varchar2_table(45) := '6E732E636C656172427574746F6E293B0A202020202020202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265466E633A20764F7074696F6E732E656D707479416C6572743A272C20764F7074696F6E732E656D707479416C65';
wwv_flow_imp.g_varchar2_table(46) := '7274293B0A202020202020202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265466E633A20764F7074696F6E732E73686F775370696E6E65723A272C20764F7074696F6E732E73686F775370696E6E6572293B0A2020202020';
wwv_flow_imp.g_varchar2_table(47) := '20202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265466E633A2070526567696F6E49643A272C2070526567696F6E4964293B0A202020202020202020202020636F6E736F6C652E6C6F672827617065785369676E61747572';
wwv_flow_imp.g_varchar2_table(48) := '65466E633A207643616E76617357696474683A272C207643616E7661735769647468293B0A202020202020202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265466E633A207643616E7661734865696768743A272C20764361';
wwv_flow_imp.g_varchar2_table(49) := '6E766173486569676874293B0A202020202020202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265466E633A2076436C69656E7457696474683A272C2076436C69656E745769647468293B0A20202020202020202020202063';
wwv_flow_imp.g_varchar2_table(50) := '6F6E736F6C652E6C6F672827617065785369676E6174757265466E633A20764369656E744865696768743A272C207643616E766173486569676874293B0A202020202020202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265';
wwv_flow_imp.g_varchar2_table(51) := '466E633A20765472696D43616E7661733A272C20765472696D43616E766173293B0A202020202020202020202020636F6E736F6C652E6C6F672827617065785369676E6174757265466E633A2076496D616765466F726D61743A272C2076496D61676546';
wwv_flow_imp.g_varchar2_table(52) := '6F726D6174293B0A20202020202020207D0A20202020202020202F2F20726573697A652063616E7661732069662073637265656E20736D616C6C6572207468616E2063616E7661730A2020202020202020696620287643616E7661735769647468203E20';
wwv_flow_imp.g_varchar2_table(53) := '76436C69656E74576964746829207B0A2020202020202020202020207643616E766173242E7769647468203D2076436C69656E745769647468202D2036303B0A20202020202020207D0A2020202020202020696620287643616E76617348656967687420';
wwv_flow_imp.g_varchar2_table(54) := '3E20764369656E7448656967687429207B0A2020202020202020202020207643616E766173242E686569676874203D20764369656E74486569676874202D2036303B0A20202020202020207D0A20202020202020202F2F205349474E4154555245504144';
wwv_flow_imp.g_varchar2_table(55) := '0A20202020202020202F2F20637265617465207369676E61747572655061640A2020202020202020766172207369676E6174757265506164203D206E6577205369676E6174757265506164287643616E766173242C207B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(56) := '6D696E57696474683A20764D696E57696474682C0A2020202020202020202020206D617857696474683A20764D617857696474682C0A2020202020202020202020206261636B67726F756E64436F6C6F723A20764261636B67726F756E64436F6C6F722C';
wwv_flow_imp.g_varchar2_table(57) := '0A20202020202020202020202070656E436F6C6F723A20764F7074696F6E732E70656E436F6C6F720A20202020202020207D293B0A20202020202020202F2F20636C656172207369676E61747572655061640A2020202020202020242876436C65617242';
wwv_flow_imp.g_varchar2_table(58) := '746E53656C6563746F72292E636C69636B2866756E6374696F6E2829207B0A2020202020202020202020207369676E61747572655061642E636C65617228293B0A2020202020202020202020202F2F206164642061706578206576656E740A2020202020';
wwv_flow_imp.g_varchar2_table(59) := '202020202020202428272327202B2070526567696F6E4964292E747269676765722827617065787369676E61747572652D636C656172656427293B0A20202020202020207D293B0A20202020202020202F2F2073617665207369676E6174757265506164';
wwv_flow_imp.g_varchar2_table(60) := '20746F2044420A20202020202020202428765361766542746E53656C6563746F72292E636C69636B2866756E6374696F6E2829207B0A20202020202020202020202076617220764973456D707479203D207369676E61747572655061642E6973456D7074';
wwv_flow_imp.g_varchar2_table(61) := '7928293B0A0909090A2020202020202020202020202F2F206F6E6C79207768656E207369676E6174757265206973206E6F7420656D7074790A20202020202020202020202069662028764973456D707479203D3D3D2066616C736529207B0A2020202020';
wwv_flow_imp.g_varchar2_table(62) := '20202020202020202020202F2F2073686F772077616974207370696E6E65720A20202020202020202020202020202020696620287653686F775370696E6E657229207B0A2020202020202020202020202020202020202020766172206C5370696E6E6572';
wwv_flow_imp.g_varchar2_table(63) := '24203D20617065782E7574696C2E73686F775370696E6E6572282428272327202B2070526567696F6E496429293B0A202020202020202020202020202020207D0A202020202020202020202020202020202F2F207361766520696D6167650A2020202020';
wwv_flow_imp.g_varchar2_table(64) := '20202020202020202020207661722076496D673B0A2020202020202020202020202020202069662028765472696D43616E76617329207B0A20202020202020202020202020202020202020206966202876496D616765466F726D6174203D3D2022696D61';
wwv_flow_imp.g_varchar2_table(65) := '67652F6A7065672229207B0A20202020202020202020202020202020202020202020202076496D67203D207369676E61747572655061642E7472696D576869746573706163652876496D616765466F726D6174293B0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(66) := '2020202020207D20656C7365207B0A20202020202020202020202020202020202020202020202076496D67203D207369676E61747572655061642E7472696D5768697465737061636528293B0A20202020202020202020202020202020202020207D0A20';
wwv_flow_imp.g_varchar2_table(67) := '2020202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020202020206966202876496D616765466F726D6174203D3D2022696D6167652F6A7065672229207B0A2020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(68) := '2020202076496D67203D207369676E61747572655061642E746F4461746155524C2876496D616765466F726D6174293B0A20202020202020202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(69) := '202076496D67203D207369676E61747572655061642E746F4461746155524C28293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A2020202020202020202020202020202020200A202020202020';
wwv_flow_imp.g_varchar2_table(70) := '20202020202020202020617065785369676E61747572652E7361766532446228764F7074696F6E732C2070526567696F6E49642C2076496D672C2066756E6374696F6E2829207B0A20202020202020202020202020202020202020202F2F20636C656172';
wwv_flow_imp.g_varchar2_table(71) := '0A20202020202020202020202020202020202020207369676E61747572655061642E636C65617228293B0A20202020202020202020202020202020202020202F2F2072656D6F76652077616974207370696E6E65720A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(72) := '202020202020696620287653686F775370696E6E657229207B0A2020202020202020202020202020202020202020202020206C5370696E6E6572242E72656D6F766528293B0A20202020202020202020202020202020202020207D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(73) := '20202020202020207D293B0A202020202020202020202020202020202F2F20697320656D7074790A2020202020202020202020207D20656C7365207B0A20202020202020202020202020202020616C6572742876456D707479416C657274293B0A202020';
wwv_flow_imp.g_varchar2_table(74) := '2020202020202020207D0A20202020202020207D293B0A202020207D0A7D3B0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(2103371856145845056)
,p_plugin_id=>wwv_flow_imp.id(2103297446797417892)
,p_file_name=>'js/apexsignature.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
