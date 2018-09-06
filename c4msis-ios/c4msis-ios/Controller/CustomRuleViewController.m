//
//  CustomRuleViewController.m
//  c4msis-ios
//
//  Created by Skifary on 2018/9/6.
//  Copyright © 2018 skifary. All rights reserved.
//

#import "CustomRuleViewController.h"

#import "Log.h"

@interface CustomRuleViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CustomRuleViewController

+ (NSString *)customRules {
    
    return [self read];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSaveButton];
    self.textView.text = [[self class] read];
}

- (void)setSaveButton {

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
}

- (void)save {
    [[self class] write:self.textView.text];
    [self.navigationController popViewControllerAnimated:YES];
}

+ (NSString *)read {
    NSString *urlString = [self customRuleFilePath];
    NSError *error;
    NSString *text = [NSString stringWithContentsOfFile:urlString encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        Log(@"%@", error);
    }
    return text;
}

+ (void)write:(NSString *)text {
    
    NSString *urlString = [self customRuleFilePath];
    NSError *error;
    [text writeToFile:urlString atomically:NO encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        Log(@"%@", error);
    }
}

+ (NSString *)customRuleFilePath {
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filepath = [documentPath stringByAppendingPathComponent:@"custom.rule"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"custom" ofType:@"rule"];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:filepath error:&error];
        if (error) {
            Log(@"%@", error);
        }
    }
    return filepath;
}

@end
