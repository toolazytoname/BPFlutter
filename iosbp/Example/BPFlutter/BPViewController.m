//
//  BPViewController.m
//  BPFlutter
//
//  Created by toolazytoname on 03/08/2019.
//  Copyright (c) 2019 toolazytoname. All rights reserved.
//

#import "BPViewController.h"
//#import "BPTFlutter.h"
//#import <BPFlutter/BPFlutter-umbrella.h>
//#import "Flutter.h"
#import <BPFlutter/Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"


@interface BPViewController ()

@end

@implementation BPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  //  UIView *flutterview = [[BPTFlutter shared] viewController].view;
   // [self.view addSubview: flutterview];
    FlutterEngine *engine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:nil];
    [engine runWithEntrypoint:nil];
    [GeneratedPluginRegistrant registerWithRegistry:engine];
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] initWithEngine:engine nibName:nil bundle:nil];
    [self.view addSubview:flutterViewController.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
