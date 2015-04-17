Pod::Spec.new do |s|
  s.name     = 'JiraConnector'
  s.version  = '0.123'
  s.license  = 'MIT'
  s.summary  = 'JiraConnector for iOS'
  s.homepage = 'https://github.com/adurbalo/JiraConnector'
  s.authors  = 'Andrey Durbalo'
  s.source   = { :git => 'https://github.com/adurbalo/JiraConnector.git', :tag => s.version, :submodules => true }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'  
  
  s.source_files = "JiraConnector/JiraConnectorSource/**/*.{h,m}"
  s.resource = "JiraConnector/JiraConnectorSource/**/*.{xib}"
 
  s.dependency 'AFNetworking' 
  s.dependency 'Mantle'

end