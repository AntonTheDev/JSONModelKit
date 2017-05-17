Pod::Spec.new do |s|
  s.name         = "JSONModelKit"
  s.version      = "1.0.0"
  s.summary      = "JSON/Dictionary Driven Model Generator"
  s.homepage     = "https://github.com/AntonTheDev/JSONModelKit"
  s.license      = 'MIT'
  s.author       = { "Anton Doudarev" => "antonthedev@gmail.com" }
  s.source       = { :git => 'https://github.com/AntonTheDev/JSONModelKit', :tag => s.version }

  s.ios.deployment_target  = '8.0'
  s.osx.deployment_target  = '10.9'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = true
  s.source_files = "Source/**/*.*"

end
