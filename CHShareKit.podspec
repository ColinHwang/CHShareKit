#
# Be sure to run `pod lib lint CHShareKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CHShareKit'
  s.version          = '0.0.1'
  s.summary          = '分享组件'
  s.homepage         = 'https://github.com/ColinHwang/CHShareKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ColinHwang' => 'chwang7158@gmail.com' }
  s.source           = { :git => 'https://github.com/ColinHwang/CHShareKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'CHShareKit/Classes/**/*'
  s.requires_arc = true
  s.dependency 'AFNetworking'
  s.dependency 'CHCategories'
  s.dependency 'SDWebImage'
  s.dependency 'YYModel'
end
