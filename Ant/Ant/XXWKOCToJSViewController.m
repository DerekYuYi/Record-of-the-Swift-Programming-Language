//
//  XXWKOCToJSViewController.m
//  Ant
//
//  Created by YuYi on 2017/9/20.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import "XXWKOCToJSViewController.h"
#import "XXWeakScriptMessageHandler.h"
#import <WebKit/WebKit.h>

@interface XXWKOCToJSViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler> {
    NSURL *baseUrl;
}

@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) UIButton *changeColorButton;

@end

@implementation XXWKOCToJSViewController

#pragma mark - Life Cycle
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
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:bundlePath];
    if (baseURL) {
        baseUrl = baseURL;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // peapare js source: 调用 js 根据视图大小来缩放页面
    NSString *jsScript = @"var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(meta);";
    
    // 1. Provide user script that should be injected into a webpage
    WKUserScript *wkUserScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jsScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    
    // 2. Set webview configuration
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addUserScript:wkUserScript];
    XXWeakScriptMessageHandler *weakScriptMessageHandler = [[XXWeakScriptMessageHandler alloc] initWithDelegate:self];
    
    /*
     Usage in js: window.webkit.messageHandlers.<name>.postMessage(<messageBody>)
     */
    [configuration.userContentController addScriptMessageHandler:weakScriptMessageHandler name:@"callbackHandler"];
    
    // 3. Create WKWebview
    _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) configuration:configuration];
    _webview.UIDelegate = self;
    _webview.navigationDelegate = self;
    
    [self.view addSubview:_webview];
    
    NSString *htmlPathString = [[NSBundle mainBundle] pathForResource:self.resourcePath ofType:nil];
    NSString *htmlContentStr = [NSString stringWithContentsOfFile:htmlPathString encoding:NSUTF8StringEncoding error:nil];
    if (htmlContentStr) {
        [_webview loadHTMLString:htmlContentStr baseURL:baseUrl];
    }
    
    [self.view addSubview:self.changeColorButton];
    
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    _webview.UIDelegate = nil;
    _webview.navigationDelegate = nil;
    [_webview loadHTMLString:@"" baseURL:nil];
    [_webview stopLoading];
    _webview = nil;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch Event
- (void)buttonTapped:(UIButton *)sender {
    // invoked js method
    [self.webview evaluateJavaScript:@"redHeader(\"red\")" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        // get respose back from js.
        NSLog(@"%@", response);
    }];
}


#pragma mark - WKUIDelegate
/** @abstract Displays a JavaScript alert panel. */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%@", message);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:@"JS 调用 alert" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler) {
            completionHandler();
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/** @abstract Displays a JavaScript comfirm panel. */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}

/** @abstract Displays a Javascript test input panel. */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
}


#pragma mark - WKNavigationDelegate
/** @abstract Decides whether to allow or cancel a navigation. */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    /*
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"xx://"]) {
        // do requirements what you need here.
    }
     */
    if (decisionHandler) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

/** @abstract Decides whether to allow or cancel a navigtion after its response is known. */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
}

/** @abstract Invoked when a main frame navigation starts. */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

/** @abstract Invoked when a server redirect is received for the main frame. */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

/** @abstract Invoked when content starts arriving for the main frame. */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

/** @abstract Invoked when a main frame navigation completes. */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

/** @abstract Invoked when an error occurs during a committed main frame navigation. */
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {

}

#pragma mark - WKScriptMessageHandler
/** @abstract Invoked when a script message is received from a webpage. */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"js invoked %@ method, and passde parameter: %@", message.name, message.body);
}

#pragma mark - Getter Method
- (UIButton *)changeColorButton {
    if (!_changeColorButton) {
        _changeColorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeColorButton setFrame:CGRectMake(100, 100, 180, 64)];
        [_changeColorButton setTitle:@"调用js: 标题变红" forState:UIControlStateNormal];
        _changeColorButton.backgroundColor = [UIColor yellowColor];
        [_changeColorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_changeColorButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeColorButton;
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
