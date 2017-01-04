Pod::Spec.new do |s|
  s.name = 'RainyRefreshControl'
  s.version = '0.2.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'Simple refresh control for iOS based on POP, SpriteKit and Core Graphics'
  s.homepage = 'https://github.com/Onix-Systems/RainyRefreshControl'
  s.social_media_url = 'https://twitter.com/onix_systems'
  s.authors = { 'Onix-Systems' => 'ios@onix-systems.com' }
  s.source = { :git => 'https://github.com/Onix-Systems/RainyRefreshControl.git', :tag => s.version }
  s.resource_bundles = {
  'RainyRefreshControl' => ['Sources/Assets/*.png', 'Sources/Assets/*.sks']
  }
  s.module_name  = 'RainyRefreshControl'
  s.source_files = 'Sources/*.swift'
  s.frameworks   = 'SpriteKit'
  s.ios.deployment_target = '9.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
  s.dependency 'pop', '1.0.9'

end
