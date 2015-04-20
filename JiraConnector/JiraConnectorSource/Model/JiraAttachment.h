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

/**
 Attachment file name, with file extension, for example ConsoleLogs.txt
 */
@property (nonatomic, strong) NSString *fileName;

/**
 Attachment mime type, use kAttachmentMimeTypeImagePng or kAttachmentMimeTypePlaneTxt constants, or specify some custom type if you need
 */
@property (nonatomic, strong) NSString *mimeType;

/**
 Attachment data
 */
@property (nonatomic, strong) NSData *attachmentData;

@end
