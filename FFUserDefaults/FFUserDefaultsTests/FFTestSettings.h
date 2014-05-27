//
//  FFTestSettings.h
//  FFUserDefaults
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFUserDefaults.h"

@interface FFTestClass : NSObject
@end

@interface FFTestSettings : FFUserDefaults

@property (nonatomic, strong) NSString *testString;
@property (nonatomic, strong) NSDate *testDate;
@property (nonatomic, strong) FFTestClass *testObject;
@property (nonatomic, getter = isTestBool) BOOL testBool;
@property (nonatomic) NSTimeInterval testTimeInterval;
@property (nonatomic) NSUInteger testUInteger;
@property (nonatomic, assign, setter = catchTestID:) id testID;

@end
