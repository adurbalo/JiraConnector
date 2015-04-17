//
//  JiraAttachment.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/17/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kAttachmentMimeTypeImagePng = @"image/png";
static NSString * const kAttachmentMimeTypePlaneTxt = @"plane/txt";

@interface JiraAttachment : NSObject

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSData *attachmentData;

@end
