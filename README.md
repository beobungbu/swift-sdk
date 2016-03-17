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
    
// Create a new table
app.newTable("Cars", attributes: ["name":"String","yearManifactured":"Int"])
    
// Save the table, with a callback
app.saveTable("Cars", callback: { (status: Int, message: String) -> Void in
        //Decide what to do after saving.
        print(message)
})
```
