ActiveAdmin.register Rating do

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

  menu priority: 4
  actions :index, :show
  
  index do
    column('ID', sortable: :id) { |rate| rate.id }
    column('Rate') { |rate| rate.rate }
    column('Name', sortable: :name) { |rate| link_to rate.user.name, admin_user_path(rate.user.id) }
    column('Restaurant') { |rate| rate.restaurant.name }
    column('Comment') { |rate| rate.comment }
    column('On') { |rate| rate.created_at.strftime('%B %d, %Y') }
  end

end
