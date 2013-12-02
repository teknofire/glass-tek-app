Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :google_oauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"],
    {
      name: "google",
      scope: "userinfo.email, userinfo.profile, glass.timeline, glass.location",
      image_aspect_ratio: "square",
      image_size: 50,
      prompt: 'consent'
    }
end