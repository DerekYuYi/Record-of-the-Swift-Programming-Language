//
//  XXUIOCToJSViewController.m
//  Ant
//
//  Created by YuYi on 2017/9/20.
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

- (void)dealloc {
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    _webView = nil;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
    // You can catch every request on here, and do things what you want to do. Then, return NO to stop load.
    return YES;
}


#pragma mark - Touch Events
/* 
 first way: Use JSContext, not WebView, but need to supply the js context. We can obtain js context from two aspects:
   On the one hand, We can us local js files, for example "self.context evaluateScript:jsfilecontent"
   On the other hand, wo can use webview load html string from local html files that excute script labels inside, but this way need webview. for example "self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];"
*/
- (IBAction)changeToRedButtonTapped:(UIButton *)sender {
    if (self.context) {
        // Obtain js method and excute it.
        NSString *jsString = @"redHeader(\"red\")";
        JSValue *value = [self.context evaluateScript:jsString];
        NSLog(@"%@%@", NSStringFromSelector(_cmd), value.toString);
    }
}

/*
 Second way: Use webview, not JSContext. Excute js method by stringByEvaluatingJavaScriptFromString: method, js methods are called by html files.
 */
- (IBAction)changeToGreenButtonTapped:(UIButton *)sender {
    NSString *string = [self.webView stringByEvaluatingJavaScriptFromString:@"redHeader(\"green\")"];
    NSLog(@"%@%@",NSStringFromSelector(_cmd), string);
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
