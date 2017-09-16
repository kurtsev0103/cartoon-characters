//
//  OKServerManager.m
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKServerManager.h"
#import "OKCharacter.h"

@implementation OKServerManager

+ (OKServerManager*)sharedManager {
    static OKServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [OKServerManager new];
    });
    
    return manager;
}

- (void)getCharactersWithCategory:(NSString*)category
                            limit:(NSInteger)limit
                        onSuccess:(void(^)(NSArray* characters))success
                        onFailure:(void(^)(NSError* error))failure {
    
    NSString* baseURL = @"http://muppet.wikia.com/api/v1/Articles/Top?expand=1";
    NSString* sitesPath = [NSString stringWithFormat:@"%@&category=%@&limit=%ld", baseURL, category, (long)limit];
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:sitesPath]];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            
            NSError* parseError = nil;
            NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&parseError];
            if (!dictionary) {
                NSLog(@"Error wile parsing %@", [parseError localizedDescription]);
            } else {
                
                NSArray* dictsArray = [dictionary objectForKey:@"items"];
                NSMutableArray* objectsArray = [NSMutableArray new];
                
                for (NSDictionary* dict in dictsArray) {
                    OKCharacter* character = [[OKCharacter alloc] initWithServerResponse:dict];
                    [objectsArray addObject:character];
                }
                
                if (success) {
                    success(objectsArray);
                }
            }
            
        } else {
            
            NSLog(@"ERROR: %@", [error localizedDescription]);
            if (failure) {
                failure(error);
            }
        }
    }];
    
    [dataTask resume];
    [session finishTasksAndInvalidate];
}

- (void)getDetailsCharacterWithId:(NSInteger)idCharacter
                    abstractLimit:(NSInteger)abstractLimit
                        onSuccess:(void(^)(NSArray* array))success
                        onFailure:(void(^)(NSError* error))failure {
    
    NSString* baseURL = @"http://muppet.wikia.com/api/v1/Articles/Details?";
    NSString* sitesPath = [NSString stringWithFormat:@"%@ids=%ld&abstract=%ld", baseURL, (long)idCharacter, (long)abstractLimit];
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:sitesPath]];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            
            NSError* parseError = nil;
            NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&parseError];
            if (!dictionary) {
                NSLog(@"Error wile parsing %@", [parseError localizedDescription]);
            } else {
                
                NSDictionary* dictsArray = [dictionary objectForKey:@"items"];
                NSString* key = [NSString stringWithFormat:@"%ld", (long)idCharacter];
                NSDictionary* valuesDict = [dictsArray objectForKey:key];
                NSArray* array = [NSArray arrayWithObject:[valuesDict objectForKey:@"abstract"]];
                
                if (success) {
                    success([array copy]);
                }
            }
            
        } else {
            
            NSLog(@"ERROR: %@", [error localizedDescription]);
            if (failure) {
                failure(error);
            }
        }
    }];
    
    [dataTask resume];
    [session finishTasksAndInvalidate];
}

@end
