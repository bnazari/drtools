Dsars::Engine.routes.draw do
  scope ':environment_id/dsars' do
    resource :input, only: :show do
      post :input
    end
    resources :reports, only: [:index, :show] do
      resources :charts, only: :show
      resource :dosr, only: :show, controller: 'dosr'
    end
  end
end
