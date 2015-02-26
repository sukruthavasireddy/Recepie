//
//  ListViewController.m
//  RECEIPE
//


#import "ListViewController.h"
#import "AsyncImageView.h"
#define ASYNC_IMAGE_TAG 9999
#define LABEL_TAG 8888
#define LABEL_TAG1 7777
@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *DataLstView;
    NSOperationQueue *_connectionQueue;
}
@end

@implementation ListViewController
@synthesize dataArray = _dataArray,EnteredRecipe = _EnteredRecipe;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DataLstView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    DataLstView.delegate = self;
    DataLstView.dataSource = self;
    [self.view addSubview:DataLstView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 70.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *constant = @" ";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:constant];
    AsyncImageView *asyncImageView = nil;
    UILabel *datatext = nil;
    UILabel *detailtext = nil;

    
    
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:constant ];
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.width = 60;
        frame.size.height = 70;
        asyncImageView = [[AsyncImageView alloc] initWithFrame:frame];
        asyncImageView.backgroundColor = [UIColor whiteColor];
        asyncImageView.tag = ASYNC_IMAGE_TAG;
        [cell.contentView addSubview:asyncImageView];
        
        datatext = [[UILabel alloc] initWithFrame:CGRectMake(65, 0,self.view.frame.size.width-65 , 45)];
        datatext.tag = LABEL_TAG;
        datatext.backgroundColor=[UIColor clearColor];
        datatext.numberOfLines = 0;
        datatext.lineBreakMode = NSLineBreakByWordWrapping;
        datatext.font = [UIFont boldSystemFontOfSize:18.0f];
        [cell.contentView addSubview:datatext];
        
        
        detailtext = [[UILabel alloc] initWithFrame:CGRectMake(65, 50,self.view.frame.size.width-65 , 20)];
        detailtext.tag = LABEL_TAG1;
        detailtext.numberOfLines = 0;
        detailtext.lineBreakMode = NSLineBreakByWordWrapping;
        detailtext.backgroundColor=[UIColor clearColor];
        detailtext.font=[UIFont systemFontOfSize:15.0f];
        [cell.contentView addSubview:detailtext];
        
    }
    else {
        asyncImageView = (AsyncImageView *) [cell.contentView viewWithTag:ASYNC_IMAGE_TAG];
        datatext = (UILabel *) [cell.contentView viewWithTag:LABEL_TAG];
        detailtext = (UILabel *) [cell.contentView viewWithTag:LABEL_TAG1];
    }
    NSDictionary *detailData = [_dataArray objectAtIndex:indexPath.row];
    datatext.text=[[detailData objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    detailtext.text=[detailData objectForKey:@"ingredients"];
    
    [asyncImageView loadImageFromURL:[NSURL URLWithString:[detailData objectForKey:@"thumbnail"]]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
