/*-------------------------------------
 * APEX Signature
 * Version: 1.2 (09.07.2024)
 * Author:  Daniel Hochleitner
 *-------------------------------------
*/
FUNCTION render_apexsignature(p_region              IN apex_plugin.t_region,
                              p_plugin              IN apex_plugin.t_plugin,
                              p_is_printer_friendly IN BOOLEAN)
  RETURN apex_plugin.t_region_render_result IS
  -- plugin attributes
  l_width              NUMBER := p_region.attribute_01;
  l_height             NUMBER := p_region.attribute_02;
  l_line_minwidth      VARCHAR2(50) := p_region.attribute_03;
  l_line_maxwidth      VARCHAR2(50) := p_region.attribute_04;
  l_background_color   VARCHAR2(100) := p_region.attribute_05;
  l_pen_color          VARCHAR2(100) := p_region.attribute_06;
  l_logging            VARCHAR2(50) := p_region.attribute_08;
  l_clear_btn_selector VARCHAR2(100) := p_region.attribute_09;
  l_save_btn_selector  VARCHAR2(100) := p_region.attribute_10;
  l_alert_text         VARCHAR2(200) := p_region.attribute_11;
  l_show_spinner       VARCHAR2(50) := p_region.attribute_12;
  l_image_format       VARCHAR2(50) := p_region.attribute_13;
  l_trim_canvas        VARCHAR2(50) := p_region.attribute_14;

  -- other variables
  l_region_id              VARCHAR2(200);
  l_canvas_id              VARCHAR2(200);
  l_background_color_esc   VARCHAR2(100);
  l_pen_color_esc          VARCHAR2(100);
  l_clear_btn_selector_esc VARCHAR2(100);
  l_save_btn_selector_esc  VARCHAR2(100);
  l_alert_text_esc         VARCHAR2(200);
  -- js/css file vars
  l_signaturepad_js  VARCHAR2(50);
  l_apexsignature_js VARCHAR2(50);
  --
BEGIN
  -- Debug
  IF apex_application.g_debug THEN
    apex_plugin_util.debug_region(p_plugin => p_plugin,
                                  p_region => p_region);
    -- set js/css filenames
    l_apexsignature_js := 'apexsignature';
    l_signaturepad_js  := 'signature_pad';
  ELSE
    l_apexsignature_js := 'apexsignature.min';
    l_signaturepad_js  := 'signature_pad.min';
  END IF;
  -- set variables and defaults
  l_region_id    := apex_escape.html_attribute(p_region.static_id ||
                                               '_signature');
  l_canvas_id    := l_region_id || '_canvas';
  l_logging      := nvl(l_logging,
                        'false');
  l_show_spinner := nvl(l_show_spinner,
                        'false');
  l_trim_canvas := nvl(l_trim_canvas,
                        'true');
  l_image_format := nvl(l_image_format,
                        'false');

  -- escape input
  l_background_color_esc   := sys.htf.escape_sc(l_background_color);
  l_pen_color_esc          := sys.htf.escape_sc(l_pen_color);
  l_clear_btn_selector_esc := sys.htf.escape_sc(l_clear_btn_selector);
  l_save_btn_selector_esc  := sys.htf.escape_sc(l_save_btn_selector);
  l_alert_text_esc         := sys.htf.escape_sc(l_alert_text);
  																  
  --
  -- add div and canvas for signature pad
  sys.htp.p('<div id="' || l_region_id || '"><canvas id="' || l_canvas_id ||
            '" width="' || l_width || '" height="' || l_height ||
            '" style="border: solid; border-radius: 4px; box-shadow: 0 0 5px rgba(0, 0, 0, 0.02) inset;"></canvas></div>');
  --
  -- add signaturepad and apexsignature js files                          
  apex_javascript.add_library(p_name           => l_signaturepad_js,
                              p_directory      => p_plugin.file_prefix ||
                                                  'js/',
                              p_version        => NULL,
                              p_skip_extension => FALSE);
  --
  apex_javascript.add_library(p_name           => l_apexsignature_js,
                              p_directory      => p_plugin.file_prefix ||
                                                  'js/',
                              p_version        => NULL,
                              p_skip_extension => FALSE);
 
  -- onload code
  apex_javascript.add_onload_code(p_code => 'apexSignature.apexSignatureFnc(' ||
                                            apex_javascript.add_value(p_region.static_id) || '{' ||
                                            apex_javascript.add_attribute('ajaxIdentifier',
                                                                          apex_plugin.get_ajax_identifier) ||
                                            apex_javascript.add_attribute('ajaxItemsToSubmit',
                                                                          p_region.ajax_items_to_submit) ||                              
                                            apex_javascript.add_attribute('canvasId',
                                                                          l_canvas_id) ||
                                            apex_javascript.add_attribute('lineMinWidth',
                                                                          l_line_minwidth) ||
                                            apex_javascript.add_attribute('lineMaxWidth',
                                                                          l_line_maxwidth) ||
                                            apex_javascript.add_attribute('backgroundColor',
                                                                          l_background_color_esc) ||
                                            apex_javascript.add_attribute('penColor',
                                                                          l_pen_color_esc) ||
                                            apex_javascript.add_attribute('clearButton',
                                                                          l_clear_btn_selector_esc) ||
                                            apex_javascript.add_attribute('saveButton',
                                                                          l_save_btn_selector_esc) ||
                                            apex_javascript.add_attribute('emptyAlert',
                                                                          l_alert_text_esc) ||	
                                            apex_javascript.add_attribute('trimCanvas',
                                                                          l_trim_canvas,
                                                                          FALSE) ||						  
                                            apex_javascript.add_attribute('showSpinner',
                                                                          l_show_spinner,
                                                                          FALSE) ||
                                            apex_javascript.add_attribute('imageFormat',
                                                                          l_image_format,
                                                                          FALSE,
                                                                          FALSE) || '},' ||
                                            apex_javascript.add_value(l_logging,
                                                                      FALSE) || ');');
  --
  RETURN NULL;
  --
END render_apexsignature;
--
--
-- AJAX function
--
--
FUNCTION ajax_apexsignature(p_region IN apex_plugin.t_region,
                            p_plugin IN apex_plugin.t_plugin)
  RETURN apex_plugin.t_region_ajax_result IS
  --
  -- plugin attributes
  l_result     apex_plugin.t_region_ajax_result;
  l_plsql_code p_region.attribute_07%TYPE := p_region.attribute_07;

  --
BEGIN

  -- replace imageFormat in plsql code
  if p_region.attribute_13 = 'image/jpeg' then
    l_plsql_code := replace(replace(l_plsql_code, '.png','.jpeg'),'image/png','image/jpeg');
  end if;

  -- execute PL/SQL
  apex_plugin_util.execute_plsql_code(p_plsql_code => l_plsql_code);
  --
  --
  RETURN NULL;
  --
END ajax_apexsignature;