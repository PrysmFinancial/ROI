Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#opening"

  get "host", to: "pages#host"
  get "host/floor", to: "pages#host_floor", as: :host_floor
  get "manager", to: "pages#manager"
end
