WORKAREA.registerModule('affirmPaymentTriggers', (function () {
    'use strict';

    var setup = function (index, trigger) {
            var $trigger = $(trigger),
                $form = $trigger.closest('form'),
                $payments = $('[name="' + trigger.name + '"]', $form);

            if (typeof affirm === 'undefined') { return; }

            $form.on('submit.affirm', _.partialRight(handleSubmit, $payments));
        },

        handleSubmit = function (event, $payments) {
            if ($payments.filter(':checked').val() === 'affirm') {
                event.preventDefault();
                affirm.checkout.post();
            }
        },

        init = function ($scope) {
            $('[data-affirm-payment-trigger]', $scope)
            .each(setup);
        };

    return {
        init: init
    };
}()));
