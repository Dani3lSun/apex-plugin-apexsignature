// APEX Signature functions
// Author: Daniel Hochleitner
// Version: 1.2

// global namespace
var apexSignature = {
    // parse string to boolean
    parseBoolean: function(pString) {
        var pBoolean;
        if (pString.toLowerCase() == 'true') {
            pBoolean = true;
        }
        if (pString.toLowerCase() == 'false') {
            pBoolean = false;
        }
        if (!(pString.toLowerCase() == 'true') && !(pString.toLowerCase() == 'false')) {
            pBoolean = undefined;
        }
        return pBoolean;
    },
    // builds a js array from long string
    clob2Array: function(clob, size, array) {
        loopCount = Math.floor(clob.length / size) + 1;
        for (var i = 0; i < loopCount; i++) {
            array.push(clob.slice(size * i, size * (i + 1)));
        }
        return array;
    },
    // converts DataURI to base64 string
    dataURI2base64: function(dataURI) {
        var base64 = dataURI.substr(dataURI.indexOf(',') + 1);
        return base64;
    },
    // save to DB function
    save2Db: function(pOptions, pRegionId, pImg, callback) {
        // img DataURI to base64
        var base64 = apexSignature.dataURI2base64(pImg);
        // split base64 clob string to f01 array length 30k
        var f01Array = [];
        f01Array = apexSignature.clob2Array(base64, 30000, f01Array);
        // Apex Ajax Call
        apex.server.plugin(pOptions.ajaxIdentifier, {
            f01: f01Array,
            // #13: Allows for items to be submitted
            pageItems: (typeof pOptions.ajaxItemsToSubmit != "undefined") ? pOptions.ajaxItemsToSubmit.split(',') : null
        }, {
            dataType: 'html',
            // SUCESS function
            success: function(data) {
                // add apex event
                $('#' + pRegionId).trigger('apexsignature-saved-db', JSON.parse(data ? data : '{}'));
                // callback
                callback();
            },
            // ERROR function
            error: function(xhr, pMessage) {
                // add apex event
                $('#' + pRegionId).trigger('apexsignature-error-db');
                console.log('save2Db: apex.server.plugin ERROR:', pMessage);
                // callback
                callback();
            }
        });
    },
    // function that gets called from plugin
    apexSignatureFnc: function(pRegionId, pOptions, pLogging) {
        var vOptions = pOptions;
        var vCanvas$ = document.getElementById(vOptions.canvasId);
        var vLogging = apexSignature.parseBoolean(pLogging);
        var vMinWidth = parseInt(vOptions.lineMinWidth);
        var vMaxWidth = parseInt(vOptions.lineMaxWidth);
        var vClearBtnSelector = vOptions.clearButton;
        var vSaveBtnSelector = vOptions.saveButton;
        var vEmptyAlert = vOptions.emptyAlert;										  
        var vShowSpinner = apexSignature.parseBoolean(vOptions.showSpinner);
        var vCanvasWidth = vCanvas$.width;
        var vCanvasHeight = vCanvas$.height;
        var vClientWidth = parseInt(document.documentElement.clientWidth);
        var vCientHeight = parseInt(document.documentElement.clientHeight);
        var vTrimCanvas = apexSignature.parseBoolean(vOptions.trimCanvas);
        var vImageFormat = vOptions.imageFormat;
        // jpeg doesn't support transparent backgrounds. So we change it back to rgb if rgba is set.
        var vBackgroundColor = (vImageFormat == "image/jpeg") ? vOptions.backgroundColor.replace("rgba","rgb").replace(/,(\d+(\.\d+)?\))$/, ')') : vOptions.backgroundColor;

        // Logging
        if (vLogging) {
            console.log('apexSignatureFnc: vOptions.ajaxIdentifier:', vOptions.ajaxIdentifier);
            console.log('apexSignatureFnc: vOptions.ajaxItemsToSubmit:', vOptions.ajaxItemsToSubmit);
            console.log('apexSignatureFnc: vOptions.canvasId:', vOptions.canvasId);
            console.log('apexSignatureFnc: vOptions.lineMinWidth:', vOptions.lineMinWidth);
            console.log('apexSignatureFnc: vOptions.lineMaxWidth:', vOptions.lineMaxWidth);
            console.log('apexSignatureFnc: vOptions.backgroundColor:', vBackgroundColor);
            console.log('apexSignatureFnc: vOptions.penColor:', vOptions.penColor);
            console.log('apexSignatureFnc: vOptions.saveButton:', vOptions.saveButton);
            console.log('apexSignatureFnc: vOptions.clearButton:', vOptions.clearButton);
            console.log('apexSignatureFnc: vOptions.emptyAlert:', vOptions.emptyAlert);
            console.log('apexSignatureFnc: vOptions.showSpinner:', vOptions.showSpinner);
            console.log('apexSignatureFnc: pRegionId:', pRegionId);
            console.log('apexSignatureFnc: vCanvasWidth:', vCanvasWidth);
            console.log('apexSignatureFnc: vCanvasHeight:', vCanvasHeight);
            console.log('apexSignatureFnc: vClientWidth:', vClientWidth);
            console.log('apexSignatureFnc: vCientHeight:', vCanvasHeight);
            console.log('apexSignatureFnc: vTrimCanvas:', vTrimCanvas);
            console.log('apexSignatureFnc: vImageFormat:', vImageFormat);
        }
        // resize canvas if screen smaller than canvas
        if (vCanvasWidth > vClientWidth) {
            vCanvas$.width = vClientWidth - 60;
        }
        if (vCanvasHeight > vCientHeight) {
            vCanvas$.height = vCientHeight - 60;
        }
        // SIGNATUREPAD
        // create signaturePad
        var signaturePad = new SignaturePad(vCanvas$, {
            minWidth: vMinWidth,
            maxWidth: vMaxWidth,
            backgroundColor: vBackgroundColor,
            penColor: vOptions.penColor
        });
        // clear signaturePad
        $(vClearBtnSelector).click(function() {
            signaturePad.clear();
            // add apex event
            $('#' + pRegionId).trigger('apexsignature-cleared');
        });
        // save signaturePad to DB
        $(vSaveBtnSelector).click(function() {
            var vIsEmpty = signaturePad.isEmpty();
			
            // only when signature is not empty
            if (vIsEmpty === false) {
                // show wait spinner
                if (vShowSpinner) {
                    var lSpinner$ = apex.util.showSpinner($('#' + pRegionId));
                }
                // save image
                var vImg;
                if (vTrimCanvas) {
                    if (vImageFormat == "image/jpeg") {
                        vImg = signaturePad.trimWhitespace(vImageFormat);
                    } else {
                        vImg = signaturePad.trimWhitespace();
                    }
                } else {
                    if (vImageFormat == "image/jpeg") {
                        vImg = signaturePad.toDataURL(vImageFormat);
                    } else {
                        vImg = signaturePad.toDataURL();
                    }
                }
                  
                apexSignature.save2Db(vOptions, pRegionId, vImg, function() {
                    // clear
                    signaturePad.clear();
                    // remove wait spinner
                    if (vShowSpinner) {
                        lSpinner$.remove();
                    }
                });
                // is empty
            } else {
                alert(vEmptyAlert);
            }
        });
    }
};
