//
//  APIConstants.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/2/16.
//  Copyright © 2016 Andrey Durbalo. All rights reserved.
//

#ifndef APIConstants_h
#define APIConstants_h

NSString * const kJCAuthPath = @"/rest/auth/1/session";

NSString * const kJCGetProjectPath = @"/rest/api/2/project";
NSString * const kJCGetIssueTypePath = @"/rest/api/2/issuetype";
NSString * const kJCGetPriorityPath = @"/rest/api/2/priority";
NSString * const kJCGetAssignablePath =@"/rest/api/2/user/assignable/search";
NSString * const kJCGetIssueByKeyPath = @"/rest/api/2/issue/%@";
NSString * const kJCPostIssuePath = @"/rest/api/2/issue";
NSString * const kJCGetVersionsForProjectPath = @"/rest/api/2/project/%@/versions?expand";
NSString * const kJCGetComponentsPath = @"/rest/api/2/project/%@/components";
NSString * const kJCPostAttachmentsIssueByKeyPath = @"/rest/api/2/issue/%@/attachments";

#endif /* APIConstants_h */
