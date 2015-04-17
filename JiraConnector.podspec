Pod::Spec.new do |s|
  s.name     = 'JiraConnector'
  s.version  = '0.122'
  s.license  = 'MIT'
  s.summary  = 'JiraConnector for iOS'
  s.homepage = 'https://github.com/adurbalo/JiraConnector'
  s.authors  = 'Andrey Durbalo'
  s.source   = { :git => 'https://github.com/adurbalo/JiraConnector.git', :tag => s.version, :submodules => true }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'  
  
  s.dependency 'AFNetworking' 
  s.dependency 'Mantle'
 
 s.subspec 'Managers' do |managers|
      managers.source_files = 'JiraConnector/JiraConnectorSource/Managers/*.{h, m}'
  end
 
  s.subspec 'Controls' do |controls|
      controls.source_files = 'JiraConnector/JiraConnectorSource/Controls/*.{h, m}'
  end
  
  s.subspec 'Model' do |model|
      model.source_files = 'JiraConnector/JiraConnectorSource/Model/*.{h, m}'
  end
  
  s.subspec 'ViewControllers' do |viewControllers|
      viewControllers.source_files = 'JiraConnector/JiraConnectorSource/ViewControllers/*.{h, m, xib}'
  end

end
