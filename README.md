# Arumdaun Church Mobile App
Arumdaun Church(swift 4.0, ios 9+)

- iTuens: https://itunes.apple.com/US/app/id1324081450?mt=8 
# Requirements #

- iPhone app with Swift 4.0
- Development environment: Xcode 9.2, iOS9 and later
- 3rd Party Libraries (Podfile)

# Main Features #

- Display Youtube on the WebView using javascript
- Integrate Lotte Lib(https://airbnb.design/lottie/)
- Parse/loading Webpage Source
- MVC, MVVM architect design
- 3rd party libraries
  - Kanna : xml prase
  - lottie-ios : loading 'After Effects' animation data
  - OneSignal : Free push-notification

```` code
use_frameworks!
inhibit_all_warnings!

target 'Arumdaun' do
  pod 'Kanna', '~> 2.1.0'
  pod 'Alamofire', '~> 4.4'
  pod 'AlamofireImage', '~> 3.1'
  pod 'CCBottomRefreshControl'
  pod 'lottie-ios'
  pod "SwiftyXMLParser", :git => 'https://github.com/yahoojapan/SwiftyXMLParser.git'
  pod "Woopra"
  pod 'HockeySDK'
  pod 'OneSignal', '>= 2.5.2', '< 3.0'
end

target 'ArumdaunNotificationExtension' do
  pod 'OneSignal', '>= 2.5.2', '< 3.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
````

# ScreenShot

![ScreenShot](https://raw.github.com/4dot/Arumdaun/master/docs/iTunes_ScreenShot.jpeg)

## License

**APC** is under MIT license. See the [LICENSE](LICENSE) file for more info.
