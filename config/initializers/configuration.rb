Workarea::Configuration.define_fields do
  fieldset 'Affirm', namespaced: true do
    field 'Enabled',
      id: :enabled,
      type: :boolean,
      description: 'Whether to enable Affirm functionality throughout the site',
      default: true

    field 'Public Key',
      id: :public_key,
      type: :string,
      description: 'Public API key. Found in the Affirm API Keys admin section.',
      allow_blank: true,
      encrypted: false

    field 'Private Key',
      id: :private_key,
      type: :string,
      description: 'Private API key used for server side calls. Found in the Affirm API Keys admin section.',
      allow_blank: true,
      encrypted: true

    field 'Use Production Environment',
      id: :use_production_environment,
      type: :boolean,
      description: 'Uses the production API and Javascript SDK URLS.',
      default: false

    field 'Merchant Name',
      id: :merchant_name,
      type: :string,
      description: 'Name of merchant that display in Affirm checkout.',
      allow_blank: true,
      encrypted: false

    field 'Minimum Order Value',
      id: :minimum_order_value,
      type: :float,
      description: 'Minimum order total required for Affirm. Affirm will not show as a payment option if this threshold is not met. Leave this field blank for no minimum.',
      allow_blank: true,
      encrypted: false

    field 'Modal Checkout',
      id: :modal_checkout,
      type: :boolean,
      description: 'Enable the modal dialog in checkout rather than redirecting offsite.',
      default: false

    field 'Show PDP Messaging',
      id: :show_pdp_messaging,
      type: :boolean,
      description: 'Enable Affirm messaging on the product page',
      default: true

    field 'Show Cart Messaging',
      id: :show_cart_messaging,
      type: :boolean,
      description: 'Enable Affirm messaging on the cart',
      default: true

    field 'PDP Logo Color',
      id: :pdp_logo_color,
      type: :string,
      description: 'The color of the logo that Affirm places in the product page messaging',
      values: %w[white black],
      allow_blank: true

    field 'PDP Logo Type',
      id: :pdp_logo_type,
      type: :string,
      description: 'The type of logo that Affirm places in the product page messaging',
      values: %w[text symbol],
      allow_blank: true

    field 'Cart Logo Color',
      id: :cart_logo_color,
      type: :string,
      description: 'The color of the logo that Affirm places in the cart messaging',
      values: %w[white black],
      allow_blank: true

    field 'Cart Logo Type',
      id: :cart_logo_type,
      type: :string,
      description: 'The type of logo that Affirm places in the cart messaging',
      values: %w[text symbol],
      allow_blank: true

    field 'Analytics Tracking Enabled',
      id: :analytics_tracking_enabled,
      type: :boolean,
      description: 'Whether to enable page analytics tracking',
      default: true
  end
end
