WORKAREA.registerModule('affirmErrors', (function () {
    'use strict';

    var init = function () {
        if (window.affirm && affirm.ui) {
            affirm.ui.ready(function () {
                affirm.ui.error.on('close', function () {
                    $('form').each(function (i, element) {
                        $.rails.enableFormElements($(element));
                    });
                });
            });
        }
    };

    return {
        init: _.once(init)
    };
}()));
