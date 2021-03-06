#
# Be sure to run `pod lib lint Spinner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Spinner"
  s.version          = "0.1.0"
  s.summary          = "Show a Spinner while your app is thinking"

  s.description      = <<-DESC
If you need to show that the app is thinking now, you can use this spinner
                       DESC

  s.homepage         = "https://github.com/devnikor/Spinner"
  s.screenshots     = "https://raw.githubusercontent.com/devnikor/Spinner/master/Screenshots/screenshot.png"
  s.license          = 'MIT'
  s.author           = { "Igor Nikitin" => "devnickr@icloud.com" }
  s.source           = { :git => "https://github.com/devnikor/Spinner.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/devnikor'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Spinner' => ['Pod/Assets/*.png']
  }

  s.frameworks = 'UIKit'
end
