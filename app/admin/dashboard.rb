ActiveAdmin.register_page "Dashboard" do

  menu priority: 1
  content title: proc{ I18n.t("active_admin.dashboard") } do

    
#     Here is an example of a simple dashboard with columns and panels.
    
     columns do
       column do
         panel "New Users" do
           table_for User.order('id desc').limit(10) do
             column('id') { |user| "##{user.id}" }
             column('name') { |user| user.name }
             column('username') { |user| user.username }
             column('email') { |user| user.email }
             column('registered on') { |user| user.created_at.strftime("%B %d, %Y") }
           end
         end
       end

       column do
         panel "New Pending Restaurants" do
           table_for Restaurant.order('id desc').where(status: 'Pending').limit(10) do
             column('id') { |resto| "##{resto.id}" }
             column('name') { |resto| link_to resto.name, admin_restaurant_path(resto) }
             column('owner') { |resto| resto.user.email }
             column('status') { |resto| status_tag(resto.status, "#{puts 'green' if resto.status == 'Accepted' }#{puts 'red' if resto.status == 'Rejected'}" ) }
             column('registered on') { |resto| resto.created_at.strftime("%B %d, %Y") }
           end
         end
       end
     end
  end # content
end
