Pod::Spec.new do |spec|
  spec.name        = 'ChartboostCoreSDK'
  spec.version     = '0.1.0'
  spec.license     = { :type => 'MIT', :file => 'LICENSE.md' }
  spec.homepage    = 'https://github.com/ChartBoost/chartboost-core-ios-sdk'
  spec.authors     = { 'Chartboost' => 'https://www.chartboost.com/' }
  spec.summary     = 'Chartboost Core iOS SDK.'
  spec.description = 'SDK that provides core functionalities to publishers and other modules.'

  # Source
  spec.module_name  = 'ChartboostCoreSDK'
  spec.source       = { :git => 'https://github.com/ChartBoost/chartboost-core-ios-sdk.git', :tag => spec.version }
  spec.source_files = 'Source/**/*.{swift}'
  spec.static_framework = true

  # Minimum supported versions
  spec.swift_version         = '5.0'
  spec.ios.deployment_target = '11.0'

  # System frameworks used
  spec.ios.frameworks = ['Foundation', 'UIKit']

  # Test spec that defines tests to run when executing `pod lib lint`
  spec.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/**/*.{swift}'
  end
end
