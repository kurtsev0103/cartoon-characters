//
//  OKCharacter.m
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKCharacter.h"

@implementation OKCharacter

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject
{
    self = [super init];
    if (self) {
        
        self.idCharacter = [[responseObject objectForKey:@"id"] integerValue];
        self.nameCharacter = [responseObject objectForKey:@"title"];
        self.textAboutCharacter = [responseObject objectForKey:@"abstract"];
        self.linkWikiCharacter = [responseObject objectForKey:@"url"];
        self.linkImageCharacter = [responseObject objectForKey:@"thumbnail"];
        
    }
    return self;
}

@end
