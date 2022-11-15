#
# Be sure to run `pod lib lint YKRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YKRouter'
  s.version          = '0.0.3'
  s.summary          = 'swift路由组件.'
  s.description      = <<-DESC
  swift路由组件支持push,present和url方式跳转
    DESC

  s.homepage         = 'https://github.com/wanyakun/YKRouter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wanyakun' => 'yakun.wan@gmail.com' }
  s.source           = { :git => 'git@github.com:wanyakun/YKRouter.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.requires_arc          = true
  s.static_framework = true

  s.vendored_frameworks = 'fmk/YKRouter.framework'

  s.preserve_paths = 'fmk/YKRouter.framework'

  # s.resource_bundles = {
  #   'YKRouter' => ['YKRouter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
