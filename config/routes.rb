Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#opening"

  get "host", to: "pages#host"
  get "host/confirmations", to: "pages#host_confirmations", as: :host_confirmations
  get "host/floor", to: "pages#host_floor", as: :host_floor
  get "manager", to: "pages#manager"

  namespace :host do
    patch "confirmations/:id", to: "confirmations#update", as: :confirmation
    post "sections/approve_all", to: "sections#approve_all", as: :approve_sections
    post "parties/:id/confirm_seat", to: "seating#confirm", as: :confirm_seat
    post "pacing/:id/confirm", to: "pacing#confirm", as: :confirm_pacing
    post "pacing/:id/decline", to: "pacing#decline", as: :decline_pacing
    post "cuts/:id/approve", to: "cuts#approve", as: :approve_cut
  end
end
