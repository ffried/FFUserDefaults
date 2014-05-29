//
//  FFNSStringCamelCaseTests.m
//  FFUserDefaults
//
//  Created by Florian Friedrich on 27.05.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FFUserDefaults/NSString+FFCamelCase.h>

@interface FFNSStringCamelCaseTests : XCTestCase

@end

@implementation FFNSStringCamelCaseTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCamelCase
{
    NSString *input = @"ThisIsMyUTF8Library With greatStuffFor9Elements";
    NSString *expectedOutput = @"ThisIsMyUTF8LibraryWithGreatStuffFor9Elements";
    NSString *camelCase = [input camelCaseString];
    XCTAssertEqualObjects(camelCase, expectedOutput, @"CamelCase is: %@\nBut should be: %@", camelCase, expectedOutput);
}

@end
