ActiveAdmin.register Notification do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :user_id, :message
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  menu priority: 6
  actions :index, :new, :create, :destroy
  
  index do
    selectable_column
    column :id
    column :message do |noti|
      noti.message.html_safe
    end
    column "For" do |noti|
      link_to noti.user.name, admin_user_path(noti.user)
    end
    column :status
    column :created_at
  end
  
  form do |f|
    inputs 'Send a Message' do
      f.input :user
      f.input :message
    end
    
    actions
    
  end
  
  controller do
    def create
      create! do |format|
        format.html { redirect_to admin_notifications_path } 
      end
    end
  end
  
end
