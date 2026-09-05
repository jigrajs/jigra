require "json"
package = JSON.parse(File.read(File.join(__dir__, "package.json")))
Pod::Spec.new do |s|
  s.name = 'Jigra'
  s.version = package['version']
  s.summary = 'Jigra for iOS'
  s.social_media_url = 'https://github.com/jigrajs'
  s.license = 'MIT'
  s.homepage = 'https://jigrajs.web.app/'
  s.ios.deployment_target  = '11.0'
  s.authors = { 'Family Team' => 'git@famicorp.com' }
  s.source = { :git => 'https://github.com/jigrajs/jigra.git', :tag => s.version.to_s }
  s.source_files = 'Jigra/Jigra/*.{swift,h,m}', 'Jigra/Jigra/Plugins/*.{swift,h,m}', 'Jigra/Jigra/Plugins/**/*.{swift,h,m}'
  s.dependency 'JigraCordova'
  s.swift_version = '5.0'
end
