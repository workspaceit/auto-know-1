//
//  AdvertImagesViewController.m
//  Cabguard Advert
//
//  Created by Workspace Infotech on 7/25/17.
//  Copyright © 2017 Workspace Infotech. All rights reserved.
//

#import "AdvertImagesViewController.h"
#import "ImageResponse.h"
#import "PostAdvertTwoViewController.h"
#import "AFNetworking/AFNetworking.h"
@interface AdvertImagesViewController ()
@property(strong,nonatomic) NSMutableArray *images;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) PHImageRequestOptions *requestOptions;
@property (nonatomic) NSMutableArray *imageTokens;
@property (nonatomic) NSString *bimToken;
@property (nonatomic) BOOL isbanner;

@end

@implementation AdvertImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesCol.delegate = self;
    self.imagesCol.dataSource = self;

    self.images = [[NSMutableArray alloc]init];
    self.imageTokens = [[NSMutableArray alloc]init];
    self.bannerImages.image = [UIImage imageNamed:@"main-screen"];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    self.bannerImages.userInteractionEnabled = YES;
    [self.bannerImages addGestureRecognizer:tapGestureRecognizer];
    
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    // this one is key
    self.requestOptions.synchronous = true;
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Next"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(nextAction:)];
    self.navigationItem.rightBarButtonItem = flipButton;
    _isbanner = false;
    self.loader.hidden = YES;
}
-(IBAction) nextAction:(id)sender{
    if(_isbanner && [_images count]>0){
        [self postImage : _bannerImages.image];
    }else{
       [ToastView showToastInParentView:self.view withText:@"Banner image & at least one other image required" withDuaration:2.0];
    }
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addmore:(id)sender {
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 6;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}
- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:NULL];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    double imageSize   = imageData.length/(1024.0*1024.0);
  
    NSLog(@"size of image in MB: %f ", imageSize);
    if(imageSize>1.5){
         [ToastView showToastInParentView:self.view withText:@"File size exceeds limit 1.5MB" withDuaration:2.0];
    }else{
        _isbanner = true;
      self.bannerImages.image = image;
    }
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - QBImagePickerController
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    PHImageManager *manager = [PHImageManager defaultManager];
    for (PHAsset *asset in assets) {
        [manager requestImageForAsset:asset
                           targetSize:PHImageManagerMaximumSize
                          contentMode:PHImageContentModeDefault
                              options:self.requestOptions
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                           UIImage *ima = image;
                            NSData *imageData = UIImageJPEGRepresentation(ima, 1.0);
                            double imageSize   = imageData.length/(1024.0*1024.0);
                            if(imageSize>1.5){
                                [ToastView showToastInParentView:self.view withText:@"File size exceeds limit 1.5MB" withDuaration:2.0];
                            }else{
                                [self.images addObject:ima];
                            }
                           
                        }];
    }
    [self.imagesCol reloadData];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - CollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:      (NSInteger)section
{
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(collectionView.frame)/2.25,CGRectGetWidth(collectionView.frame)/2.25)];
    dot.image= self.images[indexPath.row];
    [cell.contentView addSubview:dot];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Called");
    return CGSizeMake(CGRectGetWidth(collectionView.frame)/2.25, CGRectGetWidth(collectionView.frame)/2.25);
}
#pragma mark - AFNetworking
-(void) postImage:(UIImage *)image{
    self.loader.hidden = NO;
    [self.loader startAnimating];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://advert.cabguardpro.com/api/file/service/img/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
         NSData *imageData = UIImageJPEGRepresentation(self.bannerImages.image, 1.0);
        [formData appendPartWithFileData:imageData name:@"advtImg" fileName:@"file.jpg" mimeType:@"image/jpeg"] ;// you file to upload
        
    } error:nil];
  
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          //Update the progress view
                         // [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      self.loader.hidden = YES;
                      [self.loader startAnimating];
                      [uploadTask suspend];
                      if (error) {
                             NSLog(@"%@",error);
                             [ToastView showToastInParentView:self.view withText:@"Server Unreachable" withDuaration:2.0];
                      } else {
                          NSLog(@"%@", responseObject);
                          ImageResponse *response =  [[ImageResponse alloc] initWithDictionary:responseObject error:&error];
                          if(response.responseStat.status !=false){
                              
                              self.bimToken = response.responseData;
                              [self postOtherImage:0];
                          }

                      }
                  }];
    
    [uploadTask resume];
}
-(void) postOtherImage:(int) index{
    self.loader.hidden = NO;
    [self.loader startAnimating];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://advert.cabguardpro.com/api/file/service/img/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(self.images[index], 1.0);
        [formData appendPartWithFileData:imageData name:@"advtImg" fileName:@"file.jpg" mimeType:@"image/jpeg"] ;// you file to upload
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          //Update the progress view
                          // [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      self.loader.hidden = YES;
                      [self.loader startAnimating];
                       [uploadTask suspend];
                      if (error) {
                          NSLog(@"%@",error);
                          [ToastView showToastInParentView:self.view withText:@"Server Unreachable" withDuaration:2.0];
                      } else {
                          NSLog(@"%@", responseObject);
                          ImageResponse *response =  [[ImageResponse alloc] initWithDictionary:responseObject error:&error];
                          if(response.responseStat.status !=false){
                              [self.imageTokens addObject: response.responseData];
                              if(index == [_images count]-1){
                                  NSLog(@"%@",self.imageTokens);
                                  [self performSegueWithIdentifier:@"next" sender:NULL];
                              }
                              else{
                                  [self postOtherImage:index+1];
                              }
                          }
                          
                      }
                  }];
    
    [uploadTask resume];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"next"])
    {
        PostAdvertTwoViewController *data= segue.destinationViewController;
        data.image = self.bannerImages.image;
        data.otherImg = self.imageTokens;
        data.bannerImage = self.bimToken;
        data.discount = self.discount;
        data.price = self.price;
        data.descriptn = self.description;
        data.website = self.website;
        data.companyName = self.companyName;
        data.phoneNumber = self.phoneNumber;
        data.currency = self.currency;
        data.discountCurrency = self.discountCurrency;
        data.companyType = self.companyType;
    }
}


@end
