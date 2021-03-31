# Uncomment the next line to define a global platform for your project
 platform :ios, '10.3'

target 'Sharent' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks

use_frameworks!

pod 'Firebase/Core'
pod 'Firebase/Messaging'

pod 'GoogleSignIn'
pod 'FacebookLogin'
pod 'FacebookCore'
pod 'Fabric'
pod 'Crashlytics'

pod 'Alamofire'
pod 'ActionSheetPicker'
pod 'LGSideMenuController'
pod 'SDWebImage'
pod 'GooglePlaces'
pod 'GooglePlacePicker'
pod 'GoogleMaps'
pod 'Stripe'
pod 'ImageSlideshow'
pod "ImageSlideshow/SDWebImage"
pod 'UITextView+Placeholder'
pod 'CCBottomRefreshControl'

pod 'Firebase/Analytics'
pod 'Firebase/DynamicLinks'
pod 'Firebase/Auth'

pod 'MaterialComponents/Chips'

 # Pods for SendBird-iOS
  pod 'SendBirdSDK', '~> 3.0'
  pod 'AlamofireImage'
  pod 'MGSwipeTableCell'
  pod 'FLAnimatedImage', '~> 1.0'
  pod 'NYTPhotoViewer', '~> 1.1.0'
  pod 'HTMLKit', '~> 2.0'
  pod 'TTTAttributedLabel'
  pod 'RSKImageCropper'

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end


 
end
