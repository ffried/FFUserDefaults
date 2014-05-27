//
//  FFUserDefaultsTests.m
//  FFUserDefaultsTests
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FFTestSettings.h"

@interface FFUserDefaultsTests : XCTestCase
@property (nonatomic, strong) FFTestSettings *testSettings;
@end

@implementation FFUserDefaultsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.testSettings = [[FFTestSettings alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.testSettings = nil;
    [super tearDown];
}

- (void)testSettingsExist
{
    XCTAssertNotNil(self.testSettings, @"Settings must not be nil.");
}

- (void)testDateProperty
{
    NSDate *date = [NSDate date];
    self.testSettings.testDate = date;
    XCTAssertEqualObjects(self.testSettings.testDate, date, @"testDate was set to %@ but is %@!", date, self.testSettings.testDate);
}

- (void)testStringProperty
{
    NSString *string = @"String";
    self.testSettings.testString = string;
    XCTAssertEqual(self.testSettings.testString, string, @"testString was set to \"%@\" but is %@", string, self.testSettings.testString);
}

- (void)testBoolProperty
{
    BOOL testBool = YES;
    self.testSettings.testBool = testBool;
    XCTAssertEqual(testBool, self.testSettings.testBool, @"testBool was set to %@ but is %@", (testBool) ? @"YES" : @"NO", (self.testSettings.testBool) ? @"YES" : @"NO");
}

@end
