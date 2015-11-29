
Pod::Spec.new do |s|
  s.name             = "RJCircularCollectionViewLayout"
  s.version          = "0.0.1"
  s.summary          = "A custom collection view layout to lay cells in a circular fashion"

  s.description      = <<-DESC
                       A custom UICollectionViewLayout subclass to lay cells in a circular fashion with support for rubber banding, configurable item size and radius
			DESC

  s.homepage         = "https://github.com/rounak/RJCircularCollectionViewLayout"
  s.screenshots     = "https://raw.githubusercontent.com/rounak/RJCircularCollectionViewLayout/master/demo.gif"
  s.license          = 'MIT'
  s.author           = { "rounak" => "rounak91@gmail.com" }
  s.source           = { :git => "https://github.com/rounak/RJCircularCollectionViewLayout.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/r0unak'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'RJCircularCollectionViewLayout' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
