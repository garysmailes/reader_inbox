Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Inbox (authenticated surface)
  get "/inbox", to: "inbox#show", as: :inbox
  get "/archive", to: "archive#show", as: :archive

  root to: redirect("/inbox")

  # Rails 8 built-in authentication (generated)
  # (These routes should exist after `bin/rails generate authentication`)
  resource :session, only: %i[new create destroy]
  resources :passwords, only: %i[new create edit update]

  # Sign-up (we add this)
  get  "/sign-up", to: "registrations#new",    as: :sign_up
  post "/sign-up", to: "registrations#create"

# Saved Items (URL capture)
resources :saved_items, only: %i[create destroy] do
  member do
    get :open
    get :confirm_delete
    patch :state, to: "saved_items#update_state"
    patch :archive, to: "saved_items#archive"
    patch :unarchive, to: "saved_items#unarchive"
    patch :read, to: "saved_items#mark_read"
  end
end



end
