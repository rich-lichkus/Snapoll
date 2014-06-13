//
//  CKProfileVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 5/5/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKProfileVC.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

@interface CKProfileVC ()

@property (weak, nonatomic) CKUser *selectedContact;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatarMain;
@property (weak, nonatomic) IBOutlet UIView *uivAlpha;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblFullname;
- (IBAction)pressedBack:(id)sender;

@end

@implementation CKProfileVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureUI];
    // Do any additional setup after loading the view.
}

#pragma mark - Configure and setup Functions

-(void)configureUI{
    self.lblFullname.layer.cornerRadius = 2;
    self.lblUsername.layer.cornerRadius = 2;
    self.imgAvatar.layer.masksToBounds = YES;
    self.imgAvatarMain.layer.cornerRadius = self.imgAvatarMain.frame.size.height/2;
    self.imgAvatarMain.layer.masksToBounds = YES;
}

#pragma mark - Actions

- (IBAction)pressedBack:(id)sender {
    [self.delegate didSelectProfileExit];
}

#pragma mark - Load

-(void)loadSelectedContact:(CKUser*)selectedContact{
    self.selectedContact = selectedContact;
    self.lblUsername.text = self.selectedContact.userName;
    self.lblName.text = self.selectedContact.firstName;
    self.lblFullname.text = [[self.selectedContact.firstName stringByAppendingString:@" "] stringByAppendingString:self.selectedContact.lastName];
    self.imgAvatar.image = [self blur:[UIImage imageNamed:@"avatar"]];
    self.imgAvatar.frame = CGRectMake(0, 20, 240, 274);
    self.imgAvatarMain.image = [UIImage imageNamed:@"avatar"];
}

#pragma mark - Image

- (UIImage*) blur:(UIImage*)theImage
{
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
    
    // *************** if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
