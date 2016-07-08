Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '518668981672509', '962611746529111ef996cdb0a9f1f896', scope: 'email, public_profile', info_fields: 'name, email', display: 'popup', secure_image_url: true;
end