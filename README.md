# CloudBoost Swift SDK

[![CI Status](http://img.shields.io/travis/RandhirSingh/CloudBoost.svg?style=flat)](https://travis-ci.org/Randhir Singh/CloudBoost)
[![Version](https://img.shields.io/cocoapods/v/CloudBoost.svg?style=flat)](http://cocoapods.org/pods/CloudBoost)
[![License](https://img.shields.io/cocoapods/l/CloudBoost.svg?style=flat)](http://cocoapods.org/pods/CloudBoost)
[![Platform](https://img.shields.io/cocoapods/p/CloudBoost.svg?style=flat)](http://cocoapods.org/pods/CloudBoost)


## Installation

CloudBoost is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CloudBoost"
```


# Usage:

Build the framework and add it to your app
```Swift
import CloudBoost
```
    
Using CloudBoost in code

```Swift
// Creating a new CloudApp with your appID and appKey
let app = CloudApp(appID: "Your-app-ID", appKey: "Your-app-key")

// Enable Logging, defaults to false
app.setIsLogging(true)

// Create a new table
let obj = CloudObject(name: "Student")

// Set attributes
obj.setString("name", value: "Randhir")
obj.setInt("marks", value: 99)

// Save the table, with a callback
obj.save({
    (response: CloudBoostResponse) in
    response.log()
})
```


## Author

Randhir Singh, rick.rox10@gmail.com

## License

CloudBoost is available under the MIT license. See the LICENSE file for more info.
