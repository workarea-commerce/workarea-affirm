WORKAREA.analytics.registerAdapter('affirm', function () {
    var productListImpressions = [],
        enabled = !_.isEmpty($('meta[name="affirm-analytics"]')),

        whenAffirmReady = function (fn) {
              if (window.affirm && affirm.ui) {
                  return function (payload) {
                      affirm.ui.ready(function () { fn(payload); });
                  };
              } else {
                  return $.noop;
              }
        },

        buildProduct = function (payload) {
            return {
                'category': payload.category,
                'name': payload.name,
                'price': payload.price,
                'productID': payload.id,
                'variant': payload.sku
            }
        };

        buildOrder = function (payload) {
            return {
                'storeName': payload.site_name,
                'coupon': payload.promo_codes.join(','),
                'revenue': payload.total_price,
                'shipping': payload.shipping_total,
                'shippingMethod': payload.shipping_service,
                'tax': payload.tax_total,
                'orderID': payload.id,
                'total': payload.total_price
            };
        },

        buildItem = function (payload) {
            return {
                'category': payload.category,
                'name': payload.name,
                'price': payload.price,
                'productID': payload.product_id,
                'quantity': payload.quantity,
                'variant': payload.sku
            };
        };

    if (!enabled) {
      return {}
    }

    return {
      'productList': function (payload) {
          productListImpressions = productListImpressions.concat(payload.impressions);
      },

      'categoryView': whenAffirmReady(function (payload) {
          affirm.analytics.trackProductListViewed(
              { 'listId': payload.id, 'name': payload.name },
              _.map(productListImpressions, buildProduct)
          );
      }),

      'searchResultsView': whenAffirmReady(function (payload) {
          affirm.analytics.trackProductsSearched(payload.terms);
          affirm.analytics.trackProductListViewed(
              { 'listId': payload.terms },
              _.map(productListImpressions, buildProduct)
          );
      }),

      'productClick': whenAffirmReady(function (payload) {
          affirm.analytics.trackProductClicked(buildProduct(payload));
      }),

      'productView': whenAffirmReady(function (payload) {
          affirm.analytics.trackProductViewed(buildProduct(payload));
      }),

      'addToCart': whenAffirmReady(function (payload) {
          affirm.analytics.trackProductAdded(buildItem(payload));
      }),

      'removeFromCart': whenAffirmReady(function (payload) {
          affirm.analytics.trackProductRemoved(buildItem(payload));
      }),

      'cartView': whenAffirmReady(function (payload) {
          affirm.analytics.trackCartViewed(_.map(payload.items, buildItem));
      }),

      'checkoutAddressesView': whenAffirmReady(function (payload) {
          var order = buildOrder(payload);

          affirm.analytics.trackCheckoutStarted(
            order,
            _.map(payload.items, buildItem)
          );

          affirm.analytics.trackCheckoutStepViewed(1, order);
      }),

      'checkoutShippingView': whenAffirmReady(function (payload) {
          var order = buildOrder(payload);
          affirm.analytics.trackCheckoutStepCompleted(1, order);
          affirm.analytics.trackCheckoutStepViewed(2, order);
      }),

      'checkoutPaymentView': whenAffirmReady(function (payload) {
          var order = buildOrder(payload);
          affirm.analytics.trackCheckoutStepCompleted(2, order);
          affirm.analytics.trackCheckoutStepViewed(3, order);
      }),

      'checkoutOrderPlaced': whenAffirmReady(function (payload) {
          var order = buildOrder(payload);
          affirm.analytics.trackCheckoutStepCompleted(3, order);
          affirm.analytics.trackOrderConfirmed(
              order,
              _.map(payload.items, buildItem)
          );
      })
    };
});
