//
//  NSString+CamelCase.m
//
//  Created by Florian Friedrich on 27.05.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "NSString+CamelCase.h"

@implementation NSString (CamelCase)

- (instancetype)camelCaseString
{
    __autoreleasing NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<!([ ]))([A-Z](?![A-Z0-9])|([A-Z]+(?=[A-Z0-9])))"
                                                                           options:NSRegularExpressionDotMatchesLineSeparators
                                                                             error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:self
                                                       options:kNilOptions
                                                         range:NSMakeRange(0, [self length])
                                                  withTemplate:@" $2"];
    
    NSMutableString *camelCaseString = [NSMutableString string];
    NSArray *parts = [result componentsSeparatedByString:@" "];
    [parts enumerateObjectsUsingBlock:^(NSString *part, NSUInteger idx, BOOL *stop) {
        if (!part.length) return;
        NSString *firstLetter = [[part substringToIndex:1] capitalizedString];
        NSString *capitalizedPart = [part stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
        [camelCaseString appendString:capitalizedPart];
    }];
    
    return [camelCaseString copy];
}

@end
