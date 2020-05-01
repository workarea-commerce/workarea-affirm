WORKAREA.analytics.registerAdapter('affirm', function () {
    var productListImpressions = [],

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

    return {
      'productList': function (payload) {
          productListImpressions = productListImpressions.concat(payload.impressions);
      },

      'categoryView': function (payload) {
          affirm.ui.ready(function () {
              affirm.analytics.trackProductListViewed(
                  { 'listId': payload.id, 'name': payload.name },
                  _.map(productListImpressions, buildProduct)
              );
          });
      },

      'searchResultsView': function (payload) {
          affirm.ui.ready(function () {
              affirm.analytics.trackProductsSearched(payload.terms);
              affirm.analytics.trackProductListViewed(
                  { 'listId': payload.terms },
                  _.map(productListImpressions, buildProduct)
              );
          });
      },

      'productClick': function (payload) {
          affirm.ui.ready(function () {
              affirm.analytics.trackProductClicked(buildProduct(payload));
          });
      },

      'productView': function (payload) {
          affirm.ui.ready(function () {
              affirm.analytics.trackProductViewed(buildProduct(payload));
          });
      },

      'addToCart': function (payload) {
          affirm.ui.ready(function () {
              affirm.analytics.trackProductAdded(buildItem(payload));
          });
      },

      'removeFromCart': function (payload) {
          affirm.ui.ready(function () {
              affirm.analytics.trackProductRemoved(buildItem(payload));
          });
      },

      'cartView': function (payload) {
          affirm.ui.ready(function () {
              affirm.analytics.trackCartViewed(_.map(payload.items, buildItem));
          });
      },

      'checkoutAddressesView': function (payload) {
          affirm.ui.ready(function () {
              var order = buildOrder(payload);

              affirm.analytics.trackCheckoutStarted(
                order,
                _.map(payload.items, buildItem)
              );

              affirm.analytics.trackCheckoutStepViewed(1, order);
          });
      },

      'checkoutShippingView': function (payload) {
          affirm.ui.ready(function () {
              var order = buildOrder(payload);
              affirm.analytics.trackCheckoutStepCompleted(1, order);
              affirm.analytics.trackCheckoutStepViewed(2, order);
          });
      },

      'checkoutPaymentView': function (payload) {
          affirm.ui.ready(function () {
              var order = buildOrder(payload);
              affirm.analytics.trackCheckoutStepCompleted(2, order);
              affirm.analytics.trackCheckoutStepViewed(3, order);
          });
      },

      'checkoutOrderPlaced': function (payload) {
          affirm.ui.ready(function () {
              var order = buildOrder(payload);
              affirm.analytics.trackCheckoutStepCompleted(3, order);
              affirm.analytics.trackOrderConfirmed(
                  order,
                  _.map(payload.items, buildItem)
              );
          });
      }
    };
});
