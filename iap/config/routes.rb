Iap::Engine.routes.draw do
  scope ':environment_id', as: :environment do

    resources :plans, path: 'iap' do
      collection do
        resources :recipients, except: :show do
          collection do
            get :addresses
          end
        end
      end

      resource :distribution, only: [:new, :create]
      resource :approval, only: [:new, :create, :destroy]
      resources :planning_worksheets
      resources :work_assignments do
        post :duplicate, on: :member
        collection do
          get :print
          get :upload
          post :perform_upload
        end
      end

      resource :work_location_verification, controller: :work_location_verification

      resources :attachments, controller: :plan_attachments do
        collection do
          get 'new/upload', action: 'new_upload', as: :new_upload
          scope 'new/drive', controller: 'drive_list' do
            get :switch_user
            get '(:folder_id)', action: 'index', as: :list_drive
            get ':folder_id/assemble', to: 'drive_assemble#new', as: :new_drive
            post ':folder_id/assemble', to: 'drive_assemble#create', as: :create_drive
          end
          get 'new/:source', action: 'new_render', as: :new_render
        end
      end

      collection do
        resource :template, controller: :template do
          get 'new/(:folder_id)', action: 'new', as: :list_drive
          post 'switch_user'
        end
      end

    end
  end

  get "auth/#{Iap::Engine::IAP_OMNIAUTH_NAME}/callback", to: "drive_list#callback"
end
