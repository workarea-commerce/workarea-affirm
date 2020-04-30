WORKAREA.registerModule('affirmRefresh', (function () {
    'use strict';

    var init = function ($scope) {
        if (!_.isNil(affirm.ui.refresh)) {
            affirm.ui.refresh();
        }
    };

    return {
        init: init
    };
}()));
