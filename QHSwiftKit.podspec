Pod::Spec.new do |s|
  s.name             = 'QHSwiftKit'
  s.version          = '0.1.0'
  s.summary          = '常用的Swift组件'
  s.description      = '常用的Swift组件'
  s.homepage         = 'https://github.com/pengquanhuawork/SwiftKit.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Robert' => 'im.pengqh@gmail.com' }
  s.source = { :git => 'https://github.com/pengquanhuawork/SwiftKit.git', :branch => 'main' }
  s.swift_version    = '5.0'
  # Add any dependencies or frameworks your library may need
  
  s.dependency 'Alamofire', '~> 5.0'
  s.source_files = 'SwiftKit/**/*.swift'
  s.ios.deployment_target = '15.0'
  
end

