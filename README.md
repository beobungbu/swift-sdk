# CloudBoost Swift SDK

[![CI Status](http://img.shields.io/travis/CloudBoost/swift-sdk.svg?style=flat)](https://travis-ci.org/CloudBoost/swift-sdk)
[![Version](https://img.shields.io/cocoapods/v/CloudBoost.svg?style=flat)](http://cocoapods.org/pods/CloudBoost)
[![License](https://img.shields.io/cocoapods/l/CloudBoost.svg?style=flat)](http://cocoapods.org/pods/CloudBoost)
[![Platform](https://img.shields.io/cocoapods/p/CloudBoost.svg?style=flat)](http://cocoapods.org/pods/CloudBoost)
[![Contact](https://img.shields.io/badge/contact-%40randhir051-blue.svg)](http://twitter.com/randhir051)


## Installation

CloudBoost is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CloudBoost"
```

install by:
```ruby
pod install
```

close currently open project and open the project in .xcworkspace

add CloudBoost to your project
<img width="1512" alt="screen shot 2016-05-11 at 2 04 26 pm" src="https://cloud.githubusercontent.com/assets/10333542/15174904/78a1385a-1781-11e6-91b5-b5440ddd29a5.png">


# Usage:

import CloudBoost in your swift file
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
let obj = CloudObject(tableName: "Student")

// Set attributes
obj.set("name", value: "Randhir")
obj.set("marks", value: 99)

// Save the table, with a callback. response is in the form of CloudBoostResponse
obj.save({ response in
    response.log()
})
```


## Author

Randhir Singh, randhirsingh051@gmail.com

## License

CloudBoost is available under the MIT license. See the LICENSE file for more info.
