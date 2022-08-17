#
# Be sure to run `pod lib lint YKRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YKRouter'
  s.version          = '0.0.1'
  s.summary          = 'A short description of YKRouter.'
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
    DESC

  s.homepage         = 'https://github.com/wanyakun/YKRouter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wanyakun' => 'yakun.wan@gmail.com' }
  s.source           = { :git => 'git@github.com:wanyakun/YKRouter.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.requires_arc          = true
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}

  s.source_files = 'YKRouter/Classes/**/*'

  # s.resource_bundles = {
  #   'YKRouter' => ['YKRouter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
