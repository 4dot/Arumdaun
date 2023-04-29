use_frameworks!
inhibit_all_warnings!

target 'Arumdaun' do
  pod 'Kanna', '~> 4.0.0'
  pod 'Alamofire', '~> 4.4'
  pod 'AlamofireImage', '~> 3.1'
  pod 'CCBottomRefreshControl'
  pod 'lottie-ios'
  pod "SwiftyXMLParser", :git => 'https://github.com/yahoojapan/SwiftyXMLParser.git'
  pod "Woopra"
  pod 'YoutubeKit'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
