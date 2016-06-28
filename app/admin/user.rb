ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  menu priority: 2
  actions :index, :show, :edit, :update, :destroy

  index do
    column('ID', sortable: :id) { |user| user.id }  
    column('Name', sortable: :name) { |user| link_to user.name, admin_user_path(user) }
    column('Email', sortable: :email) { |user| user.email }
    column('# of    Restaurants') { |user| user.restaurants.count } 
    column('Registered On', :created_at)
    actions
  end
  

end
