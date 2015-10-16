Rails.application.routes.draw do


  resources :masters

  resources :cards do
    get 'well_done'
    get 'try_again'
  end
  post '/cards/add_all_to_cardbox', to: 'cards#add_all_to_cardbox'

  resources :cardboxes do
    get 'turn_cards'
    get 'copy_cardbox_for_me'
  end

  get 'download_csv', to: "badrecords#download_csv"
  resources :badrecords do
    # get 'finish_badrecord', to: 'badrecords#finish_badrecord'
    get 'finish_badrecord'
  end

  resources :cadres

  resources :exercises

  resources :subjects

  resources :teachers

  resources :observations

  resources :homeworks

  resources :complaints

  get 'quit_discussion', to: 'discussions#quit_discussion'
  resources :discussions do
    delete 'end_discussion'
  end

  resources :members
  post '/members/create_members_in_batch', to: 'members#create_members_in_batch'

  resources :classrooms

  resources :justices

  resources :evaluations do
    get 'delete_picture_ya'
  end

  get 'me/summary'
  get 'me/point_card'
  get 'me/justify'
  get 'me/assign_homeworks'
  get 'me/my_homeworks'
  get 'me/as_a_teacher'
  get 'me/as_a_student'

  resources :plans

  resources :teachings

  resources :catalogs do
    get :autocomplete_lesson_title, on: :collection
  end

  resources :textbooks

  resources :practices do
    get 'delete_picture_q'
    get 'delete_picture_a'
  end
  post '/practices/create_practices_in_batch', to: 'practices#create_practices_in_batch'

  resources :tutors do
    get 'delete_picture1'
    get 'delete_picture2'
  end
  resources :lessons do
    get 'delete_picture'
    get 'easy_teaching'
  end

  devise_for :users
  scope "/admin" do
    resources :users
  end

  root 'site#home'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
