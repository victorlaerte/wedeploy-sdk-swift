[![Build Status](https://travis-ci.org/launchpad-project/api.swift.svg?branch=master)](https://travis-ci.org/launchpad-project/api.swift)

## Connect to your API

```ruby
pod 'WeDeploy'
```

```swift
import WeDeploy
```

## Login

```swift
WeDeploy.auth("http://<YOUR-SERVICE>.<YOUR-PROJECT>/wedeploy.io)
	.signInWith(username: "yourusername", password: "yourpassword")
	.done { user, error in 
		print(user)
	} 
```

```swift
WeDeploy.auth("http://<YOUR-SERVICE>.<YOUR-PROJECT>/wedeploy.io)
	.signInWith(username: "yourusername", password: "yourpassword")
	.toObservable()
	.subscribe(onNext: { user in
		print(user)
	})
	.addDisposableTo(disposeBag)
```

```swift
WeDeploy.auth("http://<YOUR-SERVICE>.<YOUR-PROJECT>/wedeploy.io)
	.signInWith(username: "yourusername", password: "yourpassword")
	.toCallback { user, error in
		print(user)
	} 
```

## Send Email

```swift
WeDeploy.email("http://<YOUR-SERVICE>.<YOUR-PROJECT>/wedeploy.io)
	.sendEmail(from: "from@from.com", to: "to@to.com", subject: "aSubject", body: "aBody")
	.done { emailId in 
		print(emailId)
	} 
```
