Pod::Spec.new do |s|
  s.name					= "Logger"
  
  s.version					= '1.0.0'
  
  s.summary					= "Library for configure console logs with format of Shinyieva's projects."
  
  s.license					= "MIT License"
  
  s.homepage				= ""
  
  s.author					= { "shinyieva" => "shinyieva@gmail.com" }
  
  s.source					= { :git => 'git@github.com:shinyieva/Logger.git',  :branch => 'develop'}

  s.source_files			= 'Logger/Logger/**/*.{h,m}'
  
  s.resource                = 'LogColors.plist'
  
  s.requires_arc			= true
  
  s.framework				= 'Foundation'
  
  s.dependency				'CocoaLumberjack', '~> 1.6.2'
  
end
