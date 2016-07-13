ActiveAdmin.register Location do

  menu priority: 7
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
  
  permit_params :address
  
  actions :index, :new, :create, :destroy
  
  scope :all, default: true
  scope('Locations') { |scope| scope.where(restaurant: nil) }
  scope('Addresses') { |scope| scope.where.not(restaurant: nil) }
  
  index do
    selectable_column
    column :id
    column :address
    column('Restaurant') do |location| 
      if location.restaurant.present? 
        link_to location.restaurant.name, admin_restaurant_path(location.restaurant)
      end
    end
    column :created_at
  end
  
  form do |f|
    inputs 'Create a Location' do
      f.input :address
    end
    
    actions
  end

end
