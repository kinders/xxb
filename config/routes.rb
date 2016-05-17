Rails.application.routes.draw do

  resources :sentences

  resources :word_parsers

  resources :words do
    get "change_meanful"
  end

  resources :words_reports do
    get 'show_word2'
    get 'show_word3'
    get 'show_word4'
    get 'show_word5'
    get 'show_word6'
    get 'show_word7'
    get 'show_de1'
    get 'show_de2'
    get 'show_de3'
    get 'show_basic'
    get 'show_all_words'
  end

  resources :examrooms

  resources :paperitems

  resources :papertests

  resources :papers

  resources :fees

  resources :quiz_items do
    get  "right"
    get  "wrong"
  end

  resources :quizzes

  mathjax 'mathjax'

  resources :withdraws

  resources :cashiers

  resources :receipts
  get 'person_receipts', to: "receipts#person_receipts"
  get 'person_onboards', to: "receipts#person_onboards"
  get 'who_online', to: "receipts#who_online"
  get 'off_onboard', to: "receipts#off_onboard"

  resources :onboards

  resources :classpersonscores

  resources :classgroupscores

  resources :players

  resources :teams do
    post 'join_team'
    post 'exit_team'
  end

  resources :sectionalizations do
    get 'choose_sectionalization'
  end
  get '/reset_sectionalization', to: 'sectionalizations#reset_sectionalization'

  resources :masters

  resources :cards do
    get 'well_done'
    get 'try_again'
    get 'pass_card'
  end
  post '/cards/add_to_cardbox', to: 'cards#add_to_cardbox'
  post '/cards/multiple_operate', to: 'cards#multiple_operate'
  get '/list_right_cards', to: 'cards#list_right_cards'
  post '/search_right_cards', to: 'cards#search_right_cards'

  resources :cardboxes do
    get 'turn_cards'
    post 'copy_cardbox_for_me'
  end
  post '/cardboxes/append_to_cardbox', to: 'cardboxes#append_to_cardbox'
  get '/share_cardboxes', to: 'cardboxes#share_cardboxes'

  get 'download_csv', to: "badrecords#download_csv"
  resources :badrecords do
    # get 'finish_badrecord', to: 'badrecords#finish_badrecord'
    get 'finish_badrecord'
    get 'restore_badrecord'
  end
  post '/badrecords/finish_badrecords_in_batch', to: 'badrecords#finish_badrecords_in_batch'

  resources :cadres

  resources :exercises
  get "/new_many_exercises", to: 'exercises#new_many_exercises'
  post "/add_many_practices", to: 'exercises#add_many_practices'
  post "/import_exercises_from_cardbox", to: "exercises#import_exercises_from_cardbox"
  get "/export_exercises_to_cardbox", to: "exercises#export_exercises_to_cardbox"


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
  get '/quit_classroom', to: 'classrooms#quit_classroom'
  get '/class_badrecords', to: 'classrooms#class_badrecords'
  get '/class_finish_badrecords', to: 'classrooms#class_finish_badrecords'

  resources :justices

  resources :evaluations do
    get 'delete_picture_ya'
  end

  get '/hello' => "me#summary", as: :user_root
  get 'me/summary'
  get 'me/teacher_office'
  get 'me/point_card'
  get 'me/justify'
  get 'me/assign_homeworks'
  get 'me/my_homeworks'
  get 'me/as_a_teacher'
  get 'me/as_a_student'
  get 'me/my_receipts'

  resources :plans

  resources :teachings

  resources :catalogs do
    get :autocomplete_lesson_title, on: :collection
  end
  get '/catalogs_quick_append', to: 'catalogs#quick_append'

  resources :textbooks

  resources :practices do
    get 'delete_picture_q'
    get 'delete_picture_a'
    get 'add_to_paper'
  end
  post '/practices/create_practices_in_batch', to: 'practices#create_practices_in_batch'

  resources :tutors do
    get 'delete_picture1'
    get 'delete_picture2'
  end
  resources :lessons do
    get 'delete_picture'
    get 'easy_teaching'
    get 'words_analysis'
  end
  post '/search_lesson_title', to: 'lessons#search_lesson_title'

  devise_for :users, controllers: { sessions: "users/sessions" }

  scope "/admin" do
    resources :users
  end
  post "set_vip_user", to: "users#set_vip_user"
  post "set_normal_user", to: "users#set_normal_user"
  post "reset_password", to: "users#reset_password"

  mount Ckeditor::Engine => '/ckeditor'

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
