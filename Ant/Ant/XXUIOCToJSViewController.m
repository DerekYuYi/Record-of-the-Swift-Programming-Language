//
//  XXUIOCToJSViewController.m
//  Ant
//
//  Created by geetest on 2017/9/20.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import "XXUIOCToJSViewController.h"
#import "XXJSObject.h"

@interface XXUIOCToJSViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) JSContext *context;

@end

@implementation XXUIOCToJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    // load local html
    if (!self.resourcePath && [self.resourcePath isEqualToString:@""]) { return; }
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:self.resourcePath ofType:nil];
    NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:bundlePath];
    
    [self.webView loadHTMLString:htmlContent baseURL:baseURL];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // stop cache increasing
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    // set navigationTitle
    if ([self.title isEqualToString:@""] || !self.title) {
        NSString *navigationTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if (![navigationTitle isEqualToString:@""]) {
            [self setTitle:navigationTitle];
        }
    }
    
    XXJSObject *jsObject = [[XXJSObject alloc] init];
    
    // get JSContext
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // build bridge
    self.context[@"Module"] = jsObject; // Note: XXJSObject which implements JSExport protocol and supplys methods to JS to call.
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"handle exception.");
    };
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

// Catching every request at here
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // You can catch every request on here, and do things what you want to do.
    return YES;
}


#pragma mark - Touch Events
- (IBAction)changeToRedButtonTapped:(UIButton *)sender {
    if (self.context) {
        NSString *jsString = @"redHeader(\"red\")";
        JSValue *value = [self.context evaluateScript:jsString];
        NSLog(@"%@:%@", NSStringFromSelector(_cmd), value.toString);
    }
}

- (IBAction)changeToGreenButtonTapped:(UIButton *)sender {
    NSString *string = [self.webView stringByEvaluatingJavaScriptFromString:@"redHeader(\"green\")"];
    NSLog(@"%@:%@",NSStringFromSelector(_cmd), string);
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
