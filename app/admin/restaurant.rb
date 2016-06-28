ActiveAdmin.register Restaurant do

  menu priority: 3
  actions :index, :show, :update
#  permit_params :status
  
  scope :all, default: true
  scope('Accepted') { |scope| scope.where(status: 'Accepted') } 
  scope('Pending') { |scope| scope.where(status: 'Pending') } 
  scope('Rejected') { |scope| scope.where(status: 'Rejected') } 
  
  index do
    column('Id', sortable: id) {|resto| resto.id }
    column('Name', sortable: :name) {|resto| link_to resto.name, admin_restaurant_path(resto) }
    column('Owner', sortable: 'restaurant.name') { |resto| resto.user.name }
    column('Status') { |resto| status_tag(resto.status, "#{puts 'green' if resto.status == 'Accepted' }#{puts 'red' if resto.status == 'Rejected'}" ) }
    column('Rating') {|resto| resto.ave_ratings}  
    column('Options') do |resto|
      if resto.status == 'Pending'
        span link_to "Accept", admin_restaurant_path(resto.id, restaurant: { status: 'Accepted' } ), method: :put
        span link_to "Reject", admin_restaurant_path(resto.id, restaurant: { status: 'Rejected' } ), method: :put
      end
    end
    
  end
  
  controller do
    def update
      update! do |format|
        format.html { redirect_to admin_restaurants_path }
      end
    end
  end
  
  
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


end
