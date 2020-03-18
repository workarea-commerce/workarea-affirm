Workarea::Storefront::Engine.routes.draw do
  get 'affirm/complete' => 'affirm#complete', as: :complete_affirm
end
