Pod::Spec.new do |s|
  s.name					= "Logger"
  
  s.version					= '1.0.0'
  
  s.summary					= "Library for configure console logs with format of Shinyieva's projects."
  
  s.license					= "MIT License"
  
  s.homepage				= ""
  
  s.author					= { "shinyieva" => "shinyieva@gmail.com" }
  
  s.source					= { :git => 'git@pdihub.hi.inet:mca/mca-mobile-ios-utils.git',  :branch => 'task/ENJOYGIVEMEFIVE-15675'}
  
  s.platform				= :ios
  
  s.ios.deployment_target	= '6.0'
  
  s.source_files			= 'MCALog/**/*.{h,m}'
  
  s.xcconfig				=  { 'LIBRARY_SEARCH_PATHS' => '"$(SRCROOT)/Pods/MCALog"'}
  s.xcconfig                = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(CONFIGURATION)=1'}
  
  s.requires_arc			= true
  
  s.framework				= 'Foundation'
  
  s.dependency				'CocoaLumberjack', '~> 1.6.2'
  
end
