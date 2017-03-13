ActiveAdmin.register Restaurant do

  menu priority: 3
  actions :index, :show, :update, :destroy
  permit_params :status
  config.batch_actions = true

  scope :all, default: true
  scope('Accepted') { |scope| scope.where(status: 'Accepted') }
  scope('Pending') { |scope| scope.where(status: 'Pending') }
  scope('Rejected') { |scope| scope.where(status: 'Rejected') }

  index do
    selectable_column
    column('Id', sortable: id) {|resto| resto.id }
    column('Name', sortable: :name) {|resto| link_to resto.name, admin_restaurant_path(resto) }
    column('Owner', sortable: 'restaurant.name') { |resto| link_to resto.user.name, admin_user_path(resto.user) }
    column('Status') { |resto| status_tag(resto.status, "#{'green' if resto.status == 'Accepted' }#{'red' if resto.status == 'Rejected'}" ) }
    column('# of Dishes') { |resto| resto.foods.count }
    column('Rating') {|resto| resto.ave_ratings}
    column('Options') do |resto|
      if resto.status == 'Pending'
        span link_to "Accept", admin_restaurant_path(resto.id, restaurant: { status: 'Accepted' } ), method: :put
        span link_to "Reject", admin_restaurant_path(resto.id, restaurant: { status: 'Rejected' } ), method: :put
      else

      end
    end

  end

  controller do
    def update
      @restaurant = Restaurant.find(params[:id])
      if @restaurant.update!(permitted_params[:restaurant])
        Notification.create(message: "Your restaurant #{view_context.link_to @restaurant.name, restaurant_path(@restaurant)} has been #{@restaurant.status}.", user: @restaurant.user)
        UserMailer.send_email(@restaurant.user).deliver_now

        respond_to do |format|
          format.html { redirect_to admin_restaurants_path }
        end
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
