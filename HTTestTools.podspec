#
#  Be sure to run `pod spec lint HTTestTools.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "HTTestTools"
  s.version      = "0.0.1"
  s.summary      = "A short description of HTTestTools."

  s.description  = "龙飞的测试私有库"

  s.homepage     = "https://github.com/longfeiwang91"

  s.license      = "MIT"

  s.author             = { "longfei" => "longfeiwang91@qq.com" }
  s.platform     = :ios,9.0
  
  s.source       = { :git => "https://github.com/longfeiwang91/HTTestTools.git", :tag => "#{s.version}" }


  s.source_files  = "HTTestTools", "HTTestTools/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"


end
