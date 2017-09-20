//
//  XXWKOCToJSViewController.m
//  Ant
//
//  Created by YuYi on 2017/9/20.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import "XXWKOCToJSViewController.h"
#import <WebKit/WebKit.h>

@interface XXWKOCToJSViewController ()<WKUIDelegate, WKNavigationDelegate> {
    NSString *htmlContentString;
    NSURL *baseUrl;
}

@property (nonatomic, strong) WKWebView *webview;

@end

@implementation XXWKOCToJSViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSString *htmlPathString = [[NSBundle mainBundle] pathForResource:self.resourcePath ofType:nil];
    NSString *htmlContentStr = [NSString stringWithContentsOfFile:htmlPathString encoding:NSUTF8StringEncoding error:nil];
    if (htmlContentStr) {
        htmlContentString = htmlContentStr;
    }
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:bundlePath];
    if (baseURL) {
        baseUrl = baseURL;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 调用 js 根据视图大小来缩放页面
    NSString *jsScript = @"var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    var head = document.getElementsByTagName('head')[0]; \
    head.appendChild(meta);";
    
    // 1. Provide user script that should be injected into a webpage
    WKUserScript *wkUserScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jsScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    
    // 2. Set webview configuration
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addUserScript:wkUserScript];
    
    // 3. Create WKWebview
    _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) configuration:configuration];
    _webview.UIDelegate = self;
    _webview.navigationDelegate = self;
    
    [self.view addSubview:_webview];
    
    [_webview loadHTMLString:htmlContentString baseURL:baseUrl];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
