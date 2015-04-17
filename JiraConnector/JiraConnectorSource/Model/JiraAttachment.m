//
//  JiraAttachment.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/17/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JiraAttachment.h"

@implementation JiraAttachment

/*
 if (self.screenshotSwitch.isOn && self.screenshot) {
 MWJiraIssueAttachment *attachment = [MWJiraIssueAttachment new];
 attachment.fileName = [NSString stringWithFormat:@"Screenshot_%@.png", [[NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"] stringFromDate:[NSDate date]]];
 attachment.mimeType = @"image/png";
 attachment.attachmentData = UIImagePNGRepresentation(self.screenshot);
 [issueAttachmentsArray addObject:attachment];
 }
 
 if (self.stacktraceSwitch.isOn && self.callStackSymbols) {
 MWJiraIssueAttachment *attachment = [MWJiraIssueAttachment new];
 attachment.fileName = @"callStackSymbols.log";
 attachment.mimeType = @"plane/txt";
 attachment.attachmentData = [[self.callStackSymbols componentsJoinedByString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
 [issueAttachmentsArray addObject:attachment];
 }
 
 if (self.logsSwitch.isOn) {
 MWJiraIssueAttachment *attachment = [MWJiraIssueAttachment new];
 attachment.fileName = @"consol logs.log";
 attachment.mimeType = @"plane/txt";
 
 NSMutableString *logsString = [[NSMutableString alloc] init];
 NSArray* logs = [[InMemoryLogger sharedInMemoryLogger] logs];
 for (DDLogMessage *lm in logs) {
 [logsString appendFormat:@"%@: %@\n\n", [[NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"] stringFromDate:lm->timestamp], lm->logMsg];
 }
 attachment.attachmentData = [logsString dataUsingEncoding:NSUTF8StringEncoding];
 [issueAttachmentsArray addObject:attachment];
 }

*/

@end
