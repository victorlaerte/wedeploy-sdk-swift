Pod::Spec.new do |s|
	s.name					= "WeDeploy"
	s.version				= "0.3.0"
	s.summary				= "Swift API Client for Launchpad Project."
	s.homepage				= "https://github.com/launchpad-project/api.swift"
	s.license				= "MIT"
	s.author				= {
								"Bruno Farache" => "bruno.farache@liferay.com"
							}
	s.platform				= :ios
	s.ios.deployment_target	= '8.0'
	s.source				= {
								:git => "https://github.com/launchpad-project/api.swift.git",
								:tag => s.version.to_s
							}
	s.source_files			= "Source/**/*.swift"
	s.dependency			"later", "= 0.1.0"
	s.dependency			"Socket.IO-Client-Swift", "~> 8.1"
end
