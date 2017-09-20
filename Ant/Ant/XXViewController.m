//
//  XXViewController.m
//  Ant
//
//  Created by yuyi on 2017/9/19.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import "XXViewController.h"
#import "XXUIOCToJSViewController.h"
#import "XXWKOCToJSViewController.h"

@interface XXViewController ()

@end

@implementation XXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init]; // handle redundant black.
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.section == 0) {
        XXUIOCToJSViewController *uiwebOcToJsVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([XXUIOCToJSViewController class])];
        if (indexPath.row == 0) {
            uiwebOcToJsVC.resourcePath = @"index.html"; // oc call js method
        } else {
            uiwebOcToJsVC.resourcePath = @"jsindex.html"; // js call oc method
        }
        [self.navigationController pushViewController:uiwebOcToJsVC animated:YES];
    } else if (indexPath.section == 1) {
        XXWKOCToJSViewController *wkwebOcToJsVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([XXWKOCToJSViewController class])];
        if (indexPath.row == 0) {
            wkwebOcToJsVC.resourcePath = @"wkindex.html"; // oc call js method
        } else {
            wkwebOcToJsVC.resourcePath = @"wkjsindex.html"; // js call oc method
        }
        [self.navigationController pushViewController:wkwebOcToJsVC animated:YES];
    } else {
        return;
    }
}
@end
