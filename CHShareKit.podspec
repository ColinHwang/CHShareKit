#
# Be sure to run `pod lib lint CHShareKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CHShareKit'
  s.version          = '0.1.0'
  s.summary          = '分享组件'
  s.homepage         = 'https://github.com/ColinHwang/CHShareKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ColinHwang' => 'chwang7158@gmail.com' }
  s.source           = { :git => 'https://github.com/ColinHwang/CHShareKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.public_header_files = 'CHShareKit/Classes/CHShareKit.h'
  s.source_files = 'CHShareKit/Classes/CHShareKit.h'
  s.requires_arc = true
  s.frameworks = 'Foundation', 'UIKit'
  
  # Core
  s.subspec 'Core' do |core|
      core.source_files = 'CHShareKit/Classes/Core/**/*.{h,m}'
      core.dependency 'AFNetworking'
      core.dependency 'CHCategories'
      core.dependency 'SDWebImage'
      core.dependency 'YYModel'
  end
  
  # QQBridge
  s.subspec 'QQBridge' do |qqbridge|
      qqbridge.source_files = 'CHShareKit/Classes/QQBridge/**/*.{h,m}'
      qqbridge.dependency 'CHShareKit/Core'
      qqbridge.dependency 'CHQQSDK'
  end
  
  # WeiboBridge
  s.subspec 'WeiboBridge' do |weibobridge|
      weibobridge.source_files = 'CHShareKit/Classes/WeiboBridge/**/*.{h,m}'
      weibobridge.dependency 'CHShareKit/Core'
      weibobridge.dependency 'Weibo_SDK'
  end
  
  # WXBridge
  s.subspec 'WXBridge' do |wxbridge|
      wxbridge.source_files = 'CHShareKit/Classes/WXBridge/**/*.{h,m}'
      wxbridge.dependency 'CHShareKit/Core'
      wxbridge.dependency 'WechatOpenSDK'
  end
end
