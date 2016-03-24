# CloudBoost DraftSDK (Swift)

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
