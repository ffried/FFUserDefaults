//
//  FFTestSettings.m
//  FFUserDefaults
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFTestSettings.h"

@implementation FFTestClass
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self init];
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}
@end

@implementation FFTestSettings

@dynamic testString;
@dynamic testDate;
@dynamic testObject;
@dynamic testID;

@dynamic testBool;
@dynamic testTimeInterval;

@dynamic testUInteger;
@dynamic testInteger;

@dynamic testUnsignedLongLong;
@dynamic testLongLong;
@dynamic testUnsignedLong;
@dynamic testLong;
@dynamic testUInt;
@dynamic testInt;

@dynamic testShort;
@dynamic testUShort;
@dynamic testChar;

@dynamic testInt8;
@dynamic testInt16;
@dynamic testInt32;
@dynamic testInt64;

@end
