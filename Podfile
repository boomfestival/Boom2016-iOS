source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.3'
use_frameworks!

target 'Boom' do
  pod 'SnapKit'
  pod 'Masonry'
  pod 'RealmSwift'
  pod 'AFNetworking'
  pod 'SwiftyJSON'
  pod 'SDWebImage'
  pod 'Alamofire'
  pod 'HTMLReader'
  pod 'MWPhotoBrowser'
  pod 'SwiftSpinner'
  pod 'Bond'
  pod 'KDEAudioPlayer'
  pod "RFAboutView-Swift", '~> 1.0.11'
end

post_install do |installer|
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-Boom/Pods-Boom-acknowledgements.plist', 'Boom/Acknowledgements.plist', :remove_destination => true)
end