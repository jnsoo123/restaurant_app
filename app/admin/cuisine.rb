ActiveAdmin.register Cuisine do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  menu priority: 5
  
  permit_params :name, :description, :avatar
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  show do
    attributes_table do
      row :name
      row :avatar do
        image_tag cuisine.avatar.url, style: 'width: 300px;'
      end
    end
    active_admin_comments
  end
  
  
end
