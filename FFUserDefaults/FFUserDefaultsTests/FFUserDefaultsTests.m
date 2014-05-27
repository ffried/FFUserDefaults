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

- (void)testSetters
{
    self.testSettings.testBool = YES;
    XCTAssertTrue(self.testSettings.testBool, @"testBool was set to yes but is no!");
    self.testSettings.testString = @"Hello!";
    XCTAssertEqual(self.testSettings.testString, @"Hello!", @"testString was set to \"Hello!\" but is %@", self.testSettings.testString);
}

@end
