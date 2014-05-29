//
//  FFTestSettings.h
//  FFUserDefaults
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import <FFUserDefaults/FFUserDefaults.h>

@interface FFTestClass : NSObject <NSCoding>
@end

@interface FFTestSettings : FFUserDefaults

@property (nonatomic, strong) NSString *testString;
@property (nonatomic, strong) NSDate *testDate;
@property (nonatomic, strong) FFTestClass *testObject;
@property (nonatomic, assign, setter = catchTestID:) id testID;

@property (nonatomic, getter = isTestBool) BOOL testBool;
@property (nonatomic) NSTimeInterval testTimeInterval;

@property (nonatomic) NSUInteger testUInteger;
@property (nonatomic) NSInteger testInteger;

# pragma mark - Just test properties
@property (nonatomic) unsigned long long testUnsignedLongLong;
@property (nonatomic) long long testLongLong;
@property (nonatomic) unsigned long testUnsignedLong;
@property (nonatomic) long testLong;
@property (nonatomic) unsigned int testUInt;
@property (nonatomic) int testInt;

@property (nonatomic) short testShort;
@property (nonatomic) unsigned short testUShort;
@property (nonatomic) char testChar;

@property (nonatomic) u_int8_t testInt8;
@property (nonatomic) u_int16_t testInt16;
@property (nonatomic) u_int32_t testInt32;
@property (nonatomic) u_int64_t testInt64;

@end
