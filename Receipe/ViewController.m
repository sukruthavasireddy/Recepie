//
//  ViewController.m
//  Receipe
//

#import "ViewController.h"
#import "ListViewController.h"

#define  SPACE_PADDING 20
@interface ViewController ()
{
    UILabel *EnterIngredients;
    UILabel *ExIngredients;
    NSOperationQueue *_connectionQueue;
    
    UITextField *IngredientsDetails;
    
    UIButton *RECIPE;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // w-135
    
    
    EnterIngredients = [[UILabel alloc] init];
    EnterIngredients.frame = CGRectMake(0, 150, self.view.frame.size.width, 30);
    EnterIngredients.font = [UIFont boldSystemFontOfSize:20.0f];
    EnterIngredients.textAlignment = NSTextAlignmentCenter;
    EnterIngredients.backgroundColor = [UIColor clearColor];
    EnterIngredients.text = @"Enter Ingredients";
    [self.view addSubview:EnterIngredients];
    
    
    ExIngredients = [[UILabel alloc] init];
    ExIngredients.frame = CGRectMake(0,EnterIngredients.frame.origin.y+EnterIngredients.frame.size.height+SPACE_PADDING , self.view.frame.size.width, 30);
    ExIngredients.font = [UIFont boldSystemFontOfSize:20.0f];
    ExIngredients.textAlignment = NSTextAlignmentCenter;
    ExIngredients.backgroundColor = [UIColor clearColor];
    ExIngredients.text = @"Ex :(Butter)";
    [self.view addSubview:ExIngredients];
    
    
    IngredientsDetails =[[UITextField alloc]init];
    IngredientsDetails.frame = CGRectMake(100,ExIngredients.frame.origin.y+ExIngredients.frame.size.height+SPACE_PADDING , self.view.frame.size.width-200, 40);
    IngredientsDetails.borderStyle = UITextBorderStyleBezel;
    IngredientsDetails.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:IngredientsDetails];
    
    
    RECIPE = [UIButton buttonWithType:UIButtonTypeCustom];
    RECIPE.frame = CGRectMake(100,IngredientsDetails.frame.origin.y+IngredientsDetails.frame.size.height+SPACE_PADDING , self.view.frame.size.width-200, 40);
    [RECIPE setTitle:@"RECIPE" forState:UIControlStateNormal];
    [RECIPE setBackgroundColor:[UIColor lightGrayColor]];
    [RECIPE addTarget:self action:@selector(recipeButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RECIPE];
    
    
}


-(void)fetchReceipeName:(NSString*)itemName
{
    
    NSString *Urltring = [NSString stringWithFormat:@"http://www.recipepuppy.com/api/?i=%@&p=3",itemName];
    
    
    
    NSURLRequest *fetchRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:Urltring]];
    if(_connectionQueue == nil)
    {
        _connectionQueue = [[NSOperationQueue alloc] init];
        [_connectionQueue setMaxConcurrentOperationCount:2];
       // [_connectionQueue setName:@"CuTVDataDownloaderQ"];
    }
    [NSURLConnection sendAsynchronousRequest:fetchRequest queue:_connectionQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
         NSInteger responseStatusCode = [httpResponse statusCode];
         //Just to make sure, it works or not
         
         if(responseStatusCode == 200)
         {
             [self recepieDataDownloadCompletedWithData:data];
         }
     }];
}
- (void)recepieDataDownloadCompletedWithData:(NSData *)data
{
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
     NSArray *downloadedData = [responseDict objectForKey:@"results"];
    if (downloadedData.count>0) {
        [self sendToNextView:downloadedData];
    } else {
        [self showErrorView];
    }
}
-(void)showErrorView
{
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(showErrorView) withObject:nil waitUntilDone:NO];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"Invalid Receipe/No Recepie found for %@",IngredientsDetails.text ];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warring" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
-(void)recipeButtonSelected
{
    [self fetchReceipeName:IngredientsDetails.text];
}
-(void)sendToNextView:(NSArray *)sender
{
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(sendToNextView:) withObject:sender waitUntilDone:NO];
        return;
    }
    
    
    
    ListViewController *listView = [[ListViewController alloc] init];
    listView.dataArray = sender;
    [self.navigationController pushViewController:listView animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
