Workarea.append_partials(
  'storefront.document_head',
  'workarea/storefront/affirm/affirm_javascript_sdk'
)

Workarea::Plugin.append_partials(
  'storefront.cart_show',
  'workarea/storefront/carts/affirm_cart_promo_messaging'
)

Workarea::Plugin.append_partials(
  'storefront.product_pricing_details',
  'workarea/storefront/products/affirm_product_promo_messaging'
)

Workarea::Plugin.append_partials(
  'storefront.payment_method',
  'workarea/storefront/checkouts/affirm_payment'
)

Workarea::Plugin.append_stylesheets(
  'storefront.components',
  ['workarea/storefront/affirm/components/affirm_as_low_as', 'workarea/storefront/affirm/components/payment_icon']
)

Workarea::Plugin.append_javascripts(
  'storefront.modules',
  'workarea/storefront/affirm/modules/affirm_payment_triggers',
  'workarea/storefront/affirm/modules/affirm_refresh',
  'workarea/storefront/affirm/modules/affirm_analytics',
)
