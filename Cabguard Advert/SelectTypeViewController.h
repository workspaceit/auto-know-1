//
//  SelectTypeViewController.h
//  Cabguard Advert
//
//  Created by Workspace Infotech on 12/9/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessCategoryResponse.h"

@interface SelectTypeViewController : UIViewController
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}

@property (strong, nonatomic) BusinessCategoryResponse *data;
@property (strong, nonatomic) IBOutlet UITableView *tableData;

@end
