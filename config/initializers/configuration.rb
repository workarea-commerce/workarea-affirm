Workarea::Configuration.define_fields do
  fieldset 'Affirm', namespaced: true do
    field 'Public Key',
      type: :string,
      description: 'Public API key. Found in the Affirm API Keys admin section.',
      allow_blank: true,
      encrypted: false

    field 'Private Key',
      type: :string,
      description: 'Private API key used for server side calls. Found in the Affirm API Keys admin section.',
      allow_blank: true,
      encrypted: true

    field 'Use Production Environment',
      type: :boolean,
      description: 'Uses the production API and Javascript SDK URLS.',
      default: false

    field 'Merchant Name',
      type: :string,
      description: 'Name of merchant that display in Affirm checkout.',
      allow_blank: true,
      encrypted: false

    field 'Minimum Order Value',
      type: :float,
      description: 'Minimum order total required for Affirm. Affirm will not show as a payment option if this threshold is not met. Leave this field blank for no minimum.',
      allow_blank: true,
      encrypted: false
  end
end
