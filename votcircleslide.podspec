#
# Be sure to run `pod lib lint votcircleslide.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'votcircleslide'
  s.version          = '0.1.1'
  s.summary          = '环形滑块.'

  s.description      = <<-DESC
这是一个用于原地转向的环形滑块，可设置旋转角度，和已加载角度。左右可旋转0-180度
                       DESC

  s.homepage         = 'https://github.com/KebiZoe/votcircleslide'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 's.zengxiangxian' => 's.zengxiangxian@byd.com' }
  s.source           = { :git => 'https://github.com/KebiZoe/votcircleslide.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'votcircleslide/Classes/**/*'
  
  s.resource_bundles = {
    'votcircleslide' => ['votcircleslide/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
