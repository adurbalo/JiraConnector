##JiraConnector for iOS

### Demo 
<img src="http://gifyu.com/images/out3.gif" border="0">

### Installation with [CocoaPods](http://cocoapods.org)
```ruby
platform :ios, '7.0'
pod 'JiraConnector', '~> 1.0'
```

### Usage

* Add JiraConnector to your AppDelegate
```objective-c
#import "JiraConnector.h"
```

* Configurate JiraConnector with server URL and project key (optionaly)

```objective-c
[[JiraConnector sharedManager] configurateWithBaseURL:@"http://localhost:8080" 
                              andPredefinedProjectKey:@"KEY"];
```


* Shake device to show dialog
```objective-c
[[JiraConnector sharedManager] setEnableDetectMotion:YES];
[[JiraConnector sharedManager] setMotionSensitivity:5]; //Default value: 10
```


* Manually show/hide
```objective-c
[[JiraConnector sharedManager] showWithCompletionBlock:^{
	//your code
}];
    
[[JiraConnector sharedManager] hideWithCompletionBlock:^{
	//your code
}];
```


* Enable Screen Capturer
```objective-c
[[JiraConnector sharedManager] setEnableScreenCapturer:YES];
```

* Add your custom attachments
```objective-c
[[JiraConnector sharedManager] setCustomAttachmentsBlock:^ NSArray* (){
        
        JiraAttachment *jiraAttachment = [JiraAttachment new];
        jiraAttachment.fileName = @"callStackSymbols.txt";
        jiraAttachment.mimeType = kAttachmentMimeTypePlaneTxt;
        jiraAttachment.attachmentData = [[[NSThread callStackSymbols] componentsJoinedByString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
        
        return @[jiraAttachment];
    }];
```

### License
JiraConnector is available under the MIT license. See the LICENSE file for more info.

