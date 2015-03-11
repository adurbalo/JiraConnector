//
//  ViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/2/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setAuthorizationHeaderFieldWithUsername:@"admin" password:@"2005899"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://localhost:8080%@", @"/rest/auth/1/session"];
    
//    request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCredential:credential];
//    [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@, operation: %@", responseObject, operation);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure: %@", error);
//    }];
//    
//    [manager.operationQueue addOperation:operation];
    
    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
    manager1.requestSerializer = requestSerializer;
    
    [manager1 GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@, operation: %@", responseObject, operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
