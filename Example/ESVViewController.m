//
//  ESVViewController.m
//  EyeScrollView
//
//  Created by Benjamin Loulier on 5/14/13.
//  Copyright (c) 2013 Benjamin Loulier. All rights reserved.
//

#import "ESVViewController.h"
#import "ESVEyeScroller.h"
#import "ESVEyePositionIndicatorView.h"

@interface ESVViewController () <ESVEyeScrollerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic, strong) ESVEyeScroller *eyeScroller;
@property (weak, nonatomic) IBOutlet ESVEyePositionIndicatorView *eyePositionIndicator;

- (IBAction)calibrate:(id)sender;

@end

@implementation ESVViewController

#pragma mark - Initialization/Teardown
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupEyeScroller];
    [self loadWebviewContent];
    self.webview.scrollView.delegate = self;
    //Attach a scrollview (the webview's scrollview in this case) to the EyeScroller
}

- (void)loadWebviewContent {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"iPhoneAppProgrammingGuide" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webview loadRequest:request];
}

- (void)viewDidUnload {
    [self setWebview:nil];
    [self setEyePositionIndicator:nil];
    [super viewDidUnload];
}

#pragma mark - EyeScroller management
- (void)setupEyeScroller {
    self.eyeScroller = [[ESVEyeScroller alloc] init];
    self.eyeScroller.delegate = self;
    self.eyeScroller.maxSpeed = 500.0;
    [self.eyeScroller startRunning];
    [self.eyeScroller attachScrollView:self.webview.scrollView];
}

#pragma mark - ESVEyeScrollerDelegate
- (void)esvEyeScroller:(ESVEyeScroller *)eyeScroller didGetNewRelativeVerticalEyePosition:(float)eyePosition {
    self.eyePositionIndicator.relativeEyePosition = eyePosition;
}

- (void)esvEyeScroller:(ESVEyeScroller *)eyeScroller didCalibrateForNeutralVerticalEyePosition:(float)neutralPosition {
    self.eyePositionIndicator.neutralVerticalEyePosition = neutralPosition;
}

#pragma mark - Actions
- (IBAction)calibrate:(id)sender {
    [self.eyeScroller calibrateNeutralVerticalEyePosition];
}

#pragma mark - UIScrollView delegate

//Detactivate the eye scrolling when the user scrolls manually.
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.eyeScroller detachScrollView];
}

//Reatach the scrollview when it finish decelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.eyeScroller attachScrollView:self.webview.scrollView];
}

@end