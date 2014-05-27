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
@property (nonatomic) NSString *kvoString;
@end

@implementation FFUserDefaultsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.testSettings = [[FFTestSettings alloc] initWithDefaults:@{@"testDate": [NSDate date]}];
    [self.testSettings addObserver:self forKeyPath:@"testString" options:kNilOptions context:nil];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self.testSettings removeObserver:self forKeyPath:@"testString"];
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

- (void)testKVO
{
    NSString *currentString = self.testSettings.testString;
    NSString *newString = @"TestingKVO";
//    [self.testSettings addObserver:self forKeyPath:@"testString" options:kNilOptions context:nil];
    self.testSettings.testString = newString;
//    [self.testSettings removeObserver:self forKeyPath:@"testString"];
    XCTAssertNotNil(self.kvoString, @"kvoString must not be nil");
    XCTAssertNotEqualObjects(currentString, self.kvoString, @"The kvoString and the previous string must not be equal!");
    XCTAssertEqualObjects(self.kvoString, newString, @"The kvoString should be %@, but is %@", newString, self.kvoString);
    
    self.testSettings.testString = currentString;
}

//- (void)testBoolProperty
//{
//    BOOL testBool = YES;
//    self.testSettings.testBool = testBool;
//    XCTAssertEqual(testBool, self.testSettings.testBool, @"testBool was set to %@ but is %@", (testBool) ? @"YES" : @"NO", (self.testSettings.testBool) ? @"YES" : @"NO");
//}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.testSettings) {
        if ([keyPath isEqualToString:@"testString"]) {
            self.kvoString = self.testSettings.testString;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
