# Oracle APEX Region Plugin - APEX Signature

[![APEX Community](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/78c5adbe/badges/apex-community-badge.svg)](https://github.com/Dani3lSun/apex-github-badges) [![APEX Plugin](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/b7e95341/badges/apex-plugin-badge.svg)](https://github.com/Dani3lSun/apex-github-badges)
[![APEX Built with Love](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/7919f913/badges/apex-love-badge.svg)](https://github.com/Dani3lSun/apex-github-badges)

APEX Signature allows you to draw smooth signatures into a HTML5 canvas and enables you to save the resulting image into database.
It is based on JS Framework Signature Pad (https://github.com/szimek/signature_pad).

## Changelog

#### 1.2 - updates + fixes
  - Updated signature_pad to v5.0.2
  - Added Image Format support (JPEG / PNG for now)
  - Upgraded to Apex 23.2.2
  - Fixed the null problem in martindsouza's pull request which fixed issue #13
  - Added the functionality to remove whitespace from the signature. Note that, for now, when using JPEG format only a white background is supported

#### 1.1 - Added optional WaitSpinner when saving image into database

#### 1.0.1 - Fixed character set issues with line minWidth/maxWidth decimal numbers

#### 1.0 - Initial Release


## Install
- Import plugin file "region_type_plugin_de_danielh_apexsignature.sql" from source directory into your application
- (Optional) Deploy the JS files from "server" directory on your webserver and change the "File Prefix" to webservers folder.

## Plugin Settings
The plugin settings are highly customizable and you can change:
- **Width** - Default width of signature area
- **Height** - Default height of signature area
- **Line minWidth** - Minimum width of a line. Defaults to 0.5
- **Line maxWidth** - Maximum width of a line. Defaults to 2.5
- **Background Color** - Background color of signature area. Defaults to "rgba(0,0,0,0)", can be RGB, Hex or color name like white or black
- **Pen color** - Color used to draw the lines. Defaults to "black", can be RGB, Hex or color name like white or black
- **Image Format** - Decide whether to use png or jpeg image format for the signature blob.
- **PLSQL Code** - PLSQL code which saves the resulting image to database tables or collections, default APEX_COLLECTION: "APEX_SIGNATURE"
- **Clear Button JQuery Selector** - JQuery Selector to identify the "Clear Button" to clear signature area (#MY_BUTTON_STATIC_ID or .my_button_class)
- **Save Button JQuery Selector** - JQuery Selector to identify the "Save Button" to save signature into Database (#MY_BUTTON_STATIC_ID or .my_button_class)
- **Save empty Signature Alert text** - Alert text when a User tries to save a empty signature
- **Show Wait Spinner** - Show/Hide wait spinner when saving image into database
- **Logging** - Whether to log events in the console

## Plugin Events
- **Signature cleared** - DA event that fires when the signature area get cleared
- **Signature saved to DB** - DA event that fires when the signature is successfully save to DB
- **Signature saved to DB Error** - DA event that fires when saving to DB had an error

## How to use
- Create a APEX Signature region on target page
- Choose best fitting plugin attributes (help included)

#### Save to DB using PL/SQL (default Code of Plugin)
For saving files to DB you can use a PL/SQL function like this:

```language-sql
DECLARE
  --
  l_collection_name VARCHAR2(100);
  l_clob            CLOB;
  l_blob            BLOB;
  l_filename        VARCHAR2(100);
  l_mime_type       VARCHAR2(100);
  l_token           VARCHAR2(32000);
  --
BEGIN
  -- get defaults
  l_filename  := 'signature_' ||
                 to_char(SYSDATE,
                         'YYYYMMDDHH24MISS') || '.png';
  l_mime_type := 'image/png';
  -- build CLOB from f01 30k Array
  dbms_lob.createtemporary(l_clob,
                           FALSE,
                           dbms_lob.session);

  FOR i IN 1 .. apex_application.g_f01.count LOOP
    l_token := wwv_flow.g_f01(i);

    IF length(l_token) > 0 THEN
      dbms_lob.writeappend(l_clob,
                           length(l_token),
                           l_token);
    END IF;
  END LOOP;
  --
  -- convert base64 CLOB to BLOB (mimetype: image/png)
  l_blob := apex_web_service.clobbase642blob(p_clob => l_clob);
  --
  -- create own collection (here starts custom part (for example a Insert statement))
  -- collection name
  l_collection_name := 'APEX_SIGNATURE';
  -- check if exist
  IF NOT
      apex_collection.collection_exists(p_collection_name => l_collection_name) THEN
    apex_collection.create_collection(l_collection_name);
  END IF;
  -- add collection member (only if BLOB not null)
  IF dbms_lob.getlength(lob_loc => l_blob) IS NOT NULL THEN
    apex_collection.add_member(p_collection_name => l_collection_name,
                               p_c001            => l_filename, -- filename
                               p_c002            => l_mime_type, -- mime_type
                               p_d001            => SYSDATE, -- date created
                               p_blob001         => l_blob); -- BLOB img content
  END IF;
  --
END;
```

#### Get files from default PL/SQL code
If you use the default PL/SQL code provided with this plugin, the files are saved in a APEX collection called "APEX_SIGNATURE". Select it like that:

```language-sql
SELECT c001    AS filename,
       c002    AS mime_type,
       d001    AS date_created,
       blob001 AS img_content
  FROM apex_collections
 WHERE collection_name = 'APEX_SIGNATURE';
 ```


## Demo Application
https://apex.oracle.com/pls/apex/f?p=APEXPLUGIN

## Preview
![](https://github.com/Dani3lSun/apex-plugin-apexsignature/blob/master/preview.gif)
---
