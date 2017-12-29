//
//  ScanQRCodeViewController.m
//  c4msis-ios
//
//  Created by Skifary on 21/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "ScanQRCodeViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "Utility.h"
#import "ShadowsocksConfiguration.h"
#import "ScanView.h"
#import "ConfigurationManager.h"

@interface ScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong,nonatomic)AVCaptureDevice* device;

@property (strong,nonatomic)AVCaptureDeviceInput* input;

@property (strong,nonatomic)AVCaptureMetadataOutput* output;

@property (strong,nonatomic)AVCaptureSession* session;

@property (strong,nonatomic)AVCaptureVideoPreviewLayer* previewLayer;

@end

@implementation ScanQRCodeViewController

- (void)loadView {
    
    ScanView* view = [[ScanView alloc] initWithFrame:kScreenFrame];
    
    view.transparencyLength = self.scaleOfInterest*kScreenWidth;
    
    self.view = view;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scaleOfInterest = 0.75;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setScanView];
    [self setAlbumButton];
}

- (void)setAlbumButton {
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Album" style:UIBarButtonItemStylePlain target:self action:@selector(albumButtonAction:)];
    
}

- (void)albumButtonAction:(id)sender {
   
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)setScanView {
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    // 镜像了
    // 这个有点奇怪 对应的是 y x h w 的系数，和正常的不一样
    self.output.rectOfInterest = [self scanRect];
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];

    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = kScreenFrame;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.session startRunning];
}

- (CGRect)scanRect {
    CGFloat screenWidth = kScreenWidth;
    CGFloat screenHeight = kScreenHeight;
    
    CGFloat length = screenWidth * self.scaleOfInterest;
    
    CGFloat heightScale = length / screenHeight;
    
    CGFloat xScale = (screenWidth-length)*0.5/screenWidth;
    CGFloat yScale= (screenHeight-length)*0.5/screenHeight;
    
    // 这个有点奇怪 对应的是 y x h w 的系数，和正常的不一样
    return CGRectMake(yScale, xScale, heightScale,  self.scaleOfInterest);
}

- (BOOL)checkQRCodeValue:(NSString *)value {
    if ([value hasPrefix:@"ss://"]) {
        ShadowsocksConfiguration* configuration = [[ShadowsocksConfiguration alloc] initWithQRCodeValue:value];
        [[ConfigurationManager manager] addConfiguration:configuration];
        return YES;
    }
    return NO;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject* metadataObject = metadataObjects.firstObject;
        NSString* value = metadataObject.stringValue;
        
        if ([self checkQRCodeValue:value]) {
            [self.session stopRunning];
            ScanView* view = (ScanView*)self.view;
            [view removeScanAnimation];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    NSArray* features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count > 0) {
        for (int i = 0; i < features.count; i++) {
            CIQRCodeFeature* feature = features[i];
            NSString* ret = feature.messageString;
            if ([self checkQRCodeValue:ret]) {
                [picker dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [UIAlertController showMessage:@"二维码不正确，请选择正确的二维码！" withTitle:@"二维码错误" andPresenter:picker];
            }
        }
    } else {
        [UIAlertController showMessage:@"请选择正确的二维码！" withTitle:@"二维码错误" andPresenter:picker];
    }
}



@end
