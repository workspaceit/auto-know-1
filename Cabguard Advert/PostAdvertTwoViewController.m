//
//  PostAdvertTwoViewController.m
//  Cabguard Advert
//
//  Created by Workspace Infotech on 12/7/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "PostAdvertTwoViewController.h"
#import "PostAdvertThreeViewController.h"
#import "ToastView.h"
#import "JSONHTTPClient.h"
#import "AdvertDetailsViewController.h"
#import "SelectionViewController.h"
@interface PostAdvertTwoViewController ()

@end

@implementation PostAdvertTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.cityView.layer.cornerRadius = 10.0;
    [self.cityView.layer setMasksToBounds:YES];
    
    self.cityView.frame = CGRectInset(self.cityView.frame, -0.5f, -0.5f);
    self.cityView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cityView.layer.borderWidth = 0.5f;
    
    self.postcodeView.layer.cornerRadius = 10.0;
    [self.postcodeView.layer setMasksToBounds:YES];
    
    self.postcodeView.frame = CGRectInset(self.postcodeView.frame, -0.5f, -0.5f);
    self.postcodeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.postcodeView.layer.borderWidth = 0.5f;
    
    self.addressView.layer.cornerRadius = 10.0;
    [self.addressView.layer setMasksToBounds:YES];
    
    self.addressView.frame = CGRectInset(self.addressView.frame, -0.5f, -0.5f);
    self.addressView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addressView.layer.borderWidth = 0.5f;
    
    self.customIdView.layer.cornerRadius = 10.0;
    [self.customIdView.layer setMasksToBounds:YES];
    
    self.customIdView.frame = CGRectInset(self.cityView.frame, -0.5f, -0.5f);
    self.customIdView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.customIdView.layer.borderWidth = 0.5f;
    
    self.refView.layer.cornerRadius = 10.0;
    [self.refView.layer setMasksToBounds:YES];
    
    self.refView.frame = CGRectInset(self.cityView.frame, -0.5f, -0.5f);
    self.refView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.refView.layer.borderWidth = 0.5f;
    
    self.infoView.layer.cornerRadius = 10.0;
    [self.infoView.layer setMasksToBounds:YES];
    
    self.infoView.frame = CGRectInset(self.cityView.frame, -0.5f, -0.5f);
    self.infoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.infoView.layer.borderWidth = 0.5f;
    
    self.miscView.layer.cornerRadius = 10.0;
    [self.miscView.layer setMasksToBounds:YES];
    
    self.miscView.frame = CGRectInset(self.cityView.frame, -0.5f, -0.5f);
    self.miscView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.miscView.layer.borderWidth = 0.5f;
    
    self.nextBtn.layer.cornerRadius = 5.0;
    [self.nextBtn.layer setMasksToBounds:YES];
    
    self.backBtn.layer.cornerRadius = 5.0;
    [self.backBtn.layer setMasksToBounds:YES];
    
    self.countryView.frame = CGRectInset(self.cityView.frame, -0.5f, -0.5f);
    self.countryView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.countryView.layer.borderWidth = 0.5f;
    UITapGestureRecognizer * tabgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getcountry:)];
    [self.countryView addGestureRecognizer:tabgesture];
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:self.singleTap];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShowOrHide:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShowOrHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
}

-(void) getcountry :(UITapGestureRecognizer *)sender{
    [self performSegueWithIdentifier:@"country" sender:sender];
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)close:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}


-(void)keyboardDidShowOrHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    self.view.frame = newFrame;
    
    
    
    [UIView commitAnimations];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    self.cityText.text = (self.city) ? self.city : @"";
    self.postcodeText.text = (self.postcode) ? self.postcode : @"";
    self.addressText.text = (self.address) ? self.address : @"";
    self.customId.text = (self.custom) ? self.custom : @"";
    self.refText.text = (self.ref) ? self.ref : @"";
    self.miscText.text = (self.misc) ? self.misc : @"";
    self.infoText.text = (self.info) ? self.info : @"";
  
    self.title = (self.edit)?@"Edit Advert":@"Post Advert";
    [self.nextBtn setTitle:(self.edit)?@"Update":@"next" forState:UIControlStateNormal];
     self.backBtn.hidden = self.edit;
    
    if(_country){
        self.countryLbl.text = _country.nickName;
        self.countryLbl.textColor = [UIColor blackColor];
    }

}

- (IBAction)next:(id)sender {
    if ([self.cityText.text isEqual:@""])
    {
        [ToastView showToastInParentView:self.view withText:@"Enter city" withDuaration:2.0];
    }
    else if ([self.countryLbl.text isEqual:@"Country"])
    {
        [ToastView showToastInParentView:self.view withText:@"Enter country" withDuaration:2.0];
    }
    else if ([self.postcodeText.text isEqual:@""])
    {
        [ToastView showToastInParentView:self.view withText:@"Enter postcode" withDuaration:2.0];
    }
    else if ([self.addressText.text isEqual:@""])
    {
        [ToastView showToastInParentView:self.view withText:@"Enter bussiness address" withDuaration:2.0];
    }
    else
    {
        if (self.edit)
        {
            [self.loading startAnimating];
            
            NSDictionary *inventory = @{
                                        @"id": self.id,
                                        @"picture_update": @"0",
                                        @"discount" : self.discount,
                                        @"price" : self.price,
                                        @"offer" : self.descriptn,
                                        @"picture" : @"",
                                        @"address" : self.addressText.text,
                                        @"location" : self.cityText.text,
                                        @"postcode" : self.postcodeText.text,
                                        @"custom_id" :self.customId.text,
                                        @"ref"   : self.refText.text,
                                        @"nb":self.infoText.text,
                                        @"misc":self.miscText.text,
                                        @"opening_start_day" : self.openingDayFisrt,
                                        @"opening_end_day" : self.openingDayLast,
                                        @"opening_time" : self.openTime,
                                        @"closing_time" : self.closeTime,
                                        @"closing_start_day" : self.closingDayFirstStr,
                                        @"closing_end_day" : self.closingDayLastStr,
                                        @"limitation" : self.limitationStr,
                                        @"website" : self.website,
                                        @"company_name" : self.companyName,
                                        @"phone_number" : self.phoneNumber,
                                        @"discount_currency" : [NSString stringWithFormat:@"%d",self.discountCurrency.id],
                                        @"currency_id" : [NSString stringWithFormat:@"%d",self.currency.id],
                                        @"company_type_id" : [NSString stringWithFormat:@"%d",self.companyType.id],
                                        @"always_open": [NSNumber numberWithBool:self.always_open]
                                        };
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@api/advertpost/update",baseurl] params:inventory
                                           completion:^(NSDictionary *json, JSONModelError *err) {
                                               
                                               NSError* error = nil;
                                               self.response = [[Response alloc] initWithDictionary:json error:&error];
                                               
                                               NSLog(@"%@",error);
                                               
                                               if(error)
                                               {
                                                   [ToastView showToastInParentView:self.view withText:@"Server Unreachable" withDuaration:2.0];
                                               }
                                               else
                                               {
                                                   NSLog(@"%@",self.response);
                                                   
                                                   if(self.response.responseStat.status){
                                                       
                                                       NSLog(@"%@",self.response);
                                                       
                                                       Advert *data = [[Advert alloc]init];
                                                       data.id = [self.id intValue];
                                                       data.discountCurrency = self.discountCurrency;
                                                       data.currency= self.currency;
                                                       data.companyType = self.companyType;
                                                       data.companyName = self.companyName;
                                                       data.phoneNumber = self.phoneNumber;
                                                       data.website = self.website;
                                                       data.discount = [self.discount floatValue];
                                                       data.price = [self.price floatValue];
                                                       data.offer = self.descriptn;
                                                       data.limitation = self.limitationStr;
                                                       data.customId = self.customId.text;
                                                       data.ref = self.refText.text;
                                                       data.nb = self.infoText.text;
                                                       data.misc = self.miscText.text;
                                                       
                                                       
                                                       AdvertAddress *address=[[AdvertAddress alloc]init];
                                                       address.location = self.cityText.text;
                                                       address.postCode = self.postcodeText.text;
                                                       address.address = self.addressText.text;
                                                       data.advertAddress = address;
                                                       
                                                       AdvertOpening *opening=[[AdvertOpening alloc]init];
                                                       opening.openingStartDay = [self.openingDayFisrt intValue];
                                                       opening.openingEndDay = [self.openingDayLast intValue];
                                                       opening.closingStartDay = [self.closingDayFirstStr intValue];
                                                       opening.closingEndDay = [self.closingDayLastStr intValue];
                                                       opening.openingTime = [self.openTime floatValue];
                                                       opening.closingTime = [self.closeTime floatValue];
                                                       data.advertOpening = opening;
                                                       NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
                                                       AdvertDetailsViewController *data1 = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
                                                       data1.data = data;
                                                       data1.editedImg = self.image;
                                                       data1.edited = true;
                                                       [self.navigationController popToViewController:data1 animated:YES];
                                                       
                                                   }
                                                   else
                                                   {
                                                       [ToastView showToastInParentView:self.view withText:self.response.responseStat.msg withDuaration:2.0];
                                                   }
                                               }
                                               
                                               [self.loading stopAnimating];
                                               
                                           }];
            
        }
        else
        {
            [self performSegueWithIdentifier:@"next" sender:self];
        }

    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"next"])
    {
        PostAdvertThreeViewController *data= segue.destinationViewController;
        data.image = self.image;
        data.otherImg = self.otherImg;
        data.bannerImage = self.bannerImage;
        data.discount = self.discount;
        data.price = self.price;
        data.descriptn = self.descriptn;
        data.city = self.cityText.text;
        data.postcode = self.postcodeText.text;
        data.address = self.addressText.text;
        data.website = self.website;
        data.companyName = self.companyName;
        data.phoneNumber = self.phoneNumber;
        data.currency = self.currency;
        data.discountCurrency = self.discountCurrency;
        data.companyType = self.companyType;
        data.customId = self.customId.text;
        data.ref = self.refText.text;
        data.info = self.infoText.text;
        data.misc = self.miscText.text;
        data.country = self.country;
        data.companyTypeOther = self.companyTypeOther;
    }
    if ([segue.identifier isEqualToString:@"country"])
    {
        SelectionViewController *data= segue.destinationViewController;
        data.type = 4;
        
    }
}

@end
