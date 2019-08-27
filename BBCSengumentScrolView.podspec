#
# Be sure to run `pod lib lint BBCSengumentScrolView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BBCSengumentScrolView'
  s.version          = '1.0.0'
  s.license          = 'MIT'
  s.summary          = 'Resolve scrollView nested sliding conflicts.'
  s.description      = %{
    
  }                       
  s.homepage         = 'https://github.com/daibo789/BBCSengumentScrolView/BBCSengumentScrolView/BBCSengumentScrolView'
  s.author           = { 'Arch' => 'daibo789@163.com' }
  s.source           = { :git => 'https://github.com/daibo789/BBCSengumentScrolView.git', :tag => s.version.to_s }
  s.source_files = 'BBCSengumentScrolView/BBCSengumentScrolView/classes/*.{h,m}'
  s.ios.frameworks = 'Foundation', 'UIKit'
  s.ios.deployment_target = '9.0'
  s.dependency 'Masonry', '~> 1.1.0'
  s.requires_arc = true
end
