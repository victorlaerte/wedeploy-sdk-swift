Pod::Spec.new do |s|
	s.name					= "WeDeploy"
	s.version				= "0.4.1"
	s.summary				= "Swift API Client for WeDeploy Project."
	s.homepage				= "http://wedeploy.com/"
	s.license				= {
								"text": "Copyright 2017 Liferay Inc.",
								"type": "Copyright"
							}
	s.author				= {
								"Bruno Farache" => "bruno.farache@liferay.com",
								"Victor Galán" => "victor.galan@liferay.com"
							}
	s.source				= {
								:http => "http://cdn.wedeploy.com/api-swift/#{s.version.to_s}/WeDeploy.zip"
							}
	s.ios.deployment_target = '9.0'
	s.osx.deployment_target = '10.11'
	s.tvos.deployment_target = '9.0'
	s.ios.vendored_frameworks = 'iOS/WeDeploy.framework'
	s.tvos.vendored_frameworks = 'tvOS/WeDeploy.framework'
	s.osx.vendored_frameworks = 'Mac/WeDeploy.framework'
	s.dependency			"PromiseKit", "~> 4.0"
	s.dependency			"Socket.IO-Client-Swift", "~> 8.1"
	s.dependency			"RxSwift", "~> 3.0"
end
