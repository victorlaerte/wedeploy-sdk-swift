Pod::Spec.new do |s|
	s.name					= "WeDeploy"
	s.version				= "0.3.0"
	s.summary				= "Swift API Client for Launchpad Project."
	s.homepage				= "https://github.com/wedeploy/api.swift"
	s.license				= "MIT"
	s.author				= {
								"Bruno Farache" => "bruno.farache@liferay.com",
								"Victor Galán" => "victor.galan@liferay.com"
							}
	s.platform				= :ios
	s.ios.deployment_target	= '8.0'
	s.source				= {
								:git => "https://github.com/wedeploy/api.swift.git",
								:tag => s.version.to_s
							}
	s.ios.deployment_target = '8.0'
	s.osx.deployment_target = '10.10'
	s.tvos.deployment_target = '9.0'
	s.source_files			= "Source/**/*.swift"
	s.dependency			"PromiseKit", "~> 4.0"
	s.dependency			"Socket.IO-Client-Swift", "~> 8.1"
	s.dependency			"RxSwift", "~> 3.0"
end
