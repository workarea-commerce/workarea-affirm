WORKAREA.registerModule('affirmRefresh', (function () {
    'use strict';

    var init = function ($scope) {
        if (window.affirm && affirm.ui && affirm.ui.refresh) {
            affirm.ui.refresh();
        }
    };

    return {
        init: init
    };
}()));
