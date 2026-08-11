Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#opening"

  get "host", to: "pages#host"
  get "host/confirmations", to: "pages#host_confirmations", as: :host_confirmations
  get "host/floor", to: "pages#host_floor", as: :host_floor
  get "host/decisions", to: "pages#host_decisions", as: :host_decisions
  get "manager", to: "pages#manager"

  namespace :host do
    patch "confirmations/:id", to: "confirmations#update", as: :confirmation
    post "sections/approve_all", to: "sections#approve_all", as: :approve_sections
    patch "sections/:id/adjust", to: "sections#adjust", as: :adjust_section
    post "parties/:id/confirm_seat", to: "seating#confirm", as: :confirm_seat
    post "parties/:id/offer_alternate", to: "alternates#create", as: :offer_alternate
    post "pacing/:id/confirm", to: "pacing#confirm", as: :confirm_pacing
    post "pacing/:id/decline", to: "pacing#decline", as: :decline_pacing
    post "pacing/clear_hold", to: "pacing#clear_hold", as: :clear_pacing_hold
    post "cuts/:id/approve", to: "cuts#approve", as: :approve_cut
    post "tables/:id/mock_pickup", to: "pickups#create", as: :mock_pickup
    post "rush", to: "rush#update", as: :rush
  end
end
