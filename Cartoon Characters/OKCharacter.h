//
//  OKCharacter.h
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OKCharacter : NSObject

@property (nonatomic, strong) NSString* nameCharacter;
@property (nonatomic, strong) NSString* textAboutCharacter;
@property (nonatomic, strong) NSString* linkWikiCharacter;
@property (nonatomic, strong) NSString* linkImageCharacter;
@property (nonatomic, assign) NSInteger idCharacter;
@property (nonatomic, strong) UIImage* imageCharacter;
@property (nonatomic, assign) BOOL isFavorite;

- (id)initWithServerResponse:(NSDictionary*)responseObject;

@end
