Pod::Spec.new do |s|
	s.name					= "WeDeploy"
	s.version				= "1.2.0"
	s.summary				= "Swift API Client for WeDeploy Project."
	s.homepage				= "http://wedeploy.com/"
	s.license				= {
								:type => "BSD", 
								:file => "LICENSE.md"
							}
	s.author				= {
								"Bruno Farache" => "bruno.farache@liferay.com",
								"Victor Galán" => "victor.galan@liferay.com"
							}
							
	s.source 				= {
								:git => 'https://github.com/wedeploy/wedeploy-sdk-swift.git',
								:tag => s.version.to_s
							}
	s.source_files			= 'Source/**/*.swift'
	s.ios.deployment_target = '9.0'
	s.osx.deployment_target = '10.11'
	s.tvos.deployment_target = '9.0'
	s.dependency			"PromiseKit", "~> 4.1"
	s.dependency			"Socket.IO-Client-Swift", "~> 12.1"
	s.dependency			"RxSwift", "~> 4.1"
end
