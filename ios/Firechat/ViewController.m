//
//  ViewController.m
//  Firechat
//
//  Copyright (c) 2012 Firebase.
//
//  No part of this project may be copied, modified, propagated, or distributed
//  except according to terms in the accompanying LICENSE file.
//

#import "ViewController.h"
#import "WelcomeViewController.h"

#define kFirechatNS @"https://ping-im.firebaseIO.com/kevin/chat"

@implementation ViewController

@synthesize nameField;
@synthesize textField;
@synthesize tableView;
@synthesize navBar;




int bubbleFragment_width, bubbleFragment_height;
int bubble_x, bubble_y;

int bubbleFragment_width, bubbleFragment_height;
int bubble_x, bubble_y;

#pragma mark - Setup

// Initialization.
- (void)viewDidLoad
{
    [super viewDidLoad];
    	
    // Initialize array that will store chat messages.
    self.chat = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:kFirechatNS];
    
    // Pick a random number between 1-1000 for our username.
    self.name = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    [nameField setTitle:self.name forState:UIControlStateNormal];
    
    [self exceed];
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        [self.chat addObject:snapshot.value];
        // Reload the table view so the new message will show up.
        [self.tableView reloadData];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //[self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Text field handling

// This method is called when the user enters text in the text field.
// We add the chat message to our Firebase.
- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];

    // This will also add the message to our local array self.chat because
    // the FEventTypeChildAdded event will be immediately fired.
    
    bool sendmessage = true;
    
    NSString* message = aTextField.text;
    if([message length] > 1)
    {
        if([message hasPrefix:@"/"])
        {
            sendmessage = false;
            
            if([message hasPrefix:@"/name "])
            {
                if([message length] >= 7)
                {
                    self.name = [message substringFromIndex:6];
                    [nameField setTitle:self.name forState:UIControlStateNormal];
                    
                    [self.tableView reloadData];
                }
            }
        }
    }
    
    if(sendmessage)
    {
        NSDate *date = [NSDate date];
        int ti = [date timeIntervalSince1970];
        //int time = round(ti);
        
        NSLog(@"%d",ti);

        
        [[self.firebase childByAutoId] setValue:@{@"name" : self.name, @"text": aTextField.text, @"time": [NSString stringWithFormat:@"%d",ti]}];
        
        //sdpasjdpas
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                        initWithURL:[NSURL
                                                     URLWithString:@"http://stormy-ocean-4893.herokuapp.com/n osms"]];
        
        [request setHTTPMethod:@"POST"];
        //[request setValue:self.name forKeyPath:@"userName"];
        NSString* params = [NSString stringWithFormat:@"userName=%@&messageBody=%@",self.name,aTextField.text];
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * postOutput =[[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];

        
    }
    
    [aTextField setText:@""];
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // We only have one section in our table view.
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    // This is the number of chat messages.
    return [self.chat count];
}

//- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)index
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    
//    NSDictionary* chatMessage = [self.chat objectAtIndex:index.row];
//    
//    cell.textLabel.text = chatMessage[@"text"];
//    cell.detailTextLabel.text = chatMessage[@"name"];
//    
//    return cell;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UIImageView *balloonView;
    UIImageView* bar;
    UILabel *label;
    UILabel *name;
    UILabel *time;

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1.0];
        //rgb(236, 240, 241)
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
        balloonView.tag = 1;
        
        bar = [[UIImageView alloc] initWithFrame:CGRectZero];
        bar.tag = 4;
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 2;
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.font = [UIFont systemFontOfSize:14.0];
        
        name = [[UILabel alloc] initWithFrame:CGRectZero];
        name.backgroundColor = [UIColor clearColor];
        name.tag = 3;
        name.numberOfLines = 0;
        name.lineBreakMode = UILineBreakModeWordWrap;
        name.font = [UIFont systemFontOfSize:12.0];
        
        time = [[UILabel alloc] initWithFrame:CGRectZero];
        time.backgroundColor = [UIColor clearColor];
        time.tag = 5;
        time.numberOfLines = 0;
        time.lineBreakMode = UILineBreakModeWordWrap;
        time.font = [UIFont systemFontOfSize:8.0];
        
        UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
        message.tag = 0;
        [message addSubview:balloonView];
        [message addSubview:label];
        [message addSubview:name];
        [message addSubview:bar];
        [message addSubview:time];
        [cell.contentView addSubview:message];
        
        
    }
    else
    {
        balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
        label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
        time = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:5];
        name = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:3];
        bar = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:4];

    }
    
    NSDictionary *text = [self.chat objectAtIndex:indexPath.row];
    CGSize size = [text[@"text"] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    CGSize sizeLong = [text[@"text"] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(265.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    
    CGSize size2 = [text[@"name"] sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    
    UIImage *balloon;
    UIImage *barimage;
    UIImage *balloon2;


    
    
    
    NSString *unix = text[@"time"];
    //NSDate* today = [NSDate date];
    
    NSLog(unix);
    
    
    int unixint = [unix intValue];
    
    
  //  NSLog(@"%d",today);

    
  //  NSTimeInterval ti = [today timeIntervalSince1970];
    
    NSString *unixtime = [[NSDate dateWithTimeIntervalSince1970:unixint] description];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:unixint];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *string = [dateFormatter stringFromDate:date];
    
    NSString *stringtoday = [dateFormatter stringFromDate:[NSDate date]];
    
    if([string isEqualToString:stringtoday])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        string = [formatter stringFromDate:date];
        
        if([[string substringToIndex:1] isEqualToString:@"0"])
        {
            string = [string substringFromIndex:1];
        }
        
    }

    CGSize size3 = [string sizeWithFont:[UIFont systemFontOfSize:7.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    float messagewidth = size.width + 23;
    if(size2.width + 20 > messagewidth)
    {
        messagewidth = size2.width + 23;
    }
    if(size3.width + 28 > messagewidth)
    {
        messagewidth = size3.width + 28;
    }
    
    float messagewidthtext = messagewidth;
    
    if(messagewidth > 239)
    {
        messagewidthtext = sizeLong.width + 23;
    }
    
    
    if([text[@"name"] isEqualToString:self.name])
    {
        
        balloonView.frame = CGRectMake(320.0f - (messagewidth + 5), 2.0f - 1, messagewidth + 5, size.height + 28.0f);
        balloon = [[UIImage imageNamed:@"green.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:20];
        label.frame = CGRectMake(307.0f - (messagewidth - 17.0f), 8.0f, size.width + 5.0f, size.height);
        //name.frame = CGRectMake(307.0f - (size.width + 5.0f), -8.0f, 200, 20);
    }
    else
    {
        balloonView.frame = CGRectMake(5.0, -1 , messagewidthtext, size.height + 40);
        balloon = [[UIImage imageNamed:@"grey_2.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        
       
        
        label.frame = CGRectMake(20, 18, messagewidth + 5, size.height);
        name.frame = CGRectMake(20, 0, 200, 20);
        time.frame = CGRectMake(messagewidthtext - size3.width - 9, size.height + 16, 200, 20);
        
        bar.frame = CGRectMake(18.0, 17 , messagewidthtext - 21, 1);
        barimage = [[UIImage imageNamed:@"bar.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        
    }
    
    bar.image = barimage;
    balloonView.image = balloon;
    label.text = text[@"text"];
    name.text = text[@"name"];
    time.text = string;
    UIColor* graycolor = [UIColor colorWithRed:189.0/255.0 green:195/255.0 blue:199/255.0 alpha:1.0];
    [time setTextColor:graycolor];
    UIColor* color = [UIColor colorWithRed:(39/255.0) green:(174/255.0) blue:(96/255.0) alpha:1.0];
    [name setTextColor:color];
    
    if([text[@"name"] isEqualToString:self.name])
    {
        name.text = @"";
        [time setTextColor:[UIColor whiteColor]];
        [label setTextColor:[UIColor whiteColor]];
        
        int posx = 320 - size.width - 18;
        if(posx > 320 - (size3.width + 25))
        {
            posx = 320 - (size3.width + 25);
        }
        
        time.frame = CGRectMake(posx, size.height + 6, 200, 20);


    }
    else
    {
        [label setTextColor:[UIColor blackColor]];
    }

    
    return cell;
}








//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Calculate
//    CGSize textSize = { 260.0, 20000.0 }; // width and height of text area
//    
//    NSMutableDictionary *dict = [self.chat objectAtIndex:indexPath.section];
//    NSString *aMsg = [dict objectForKey:@"msgBody"];
//    
//    CGSize size = [aMsg sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
//    size.height += 5;
//    
//    CGFloat height = size.height<36?36:size.height;
//    
//    return height;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *body = [self.chat objectAtIndex:indexPath.row];
    CGSize size = [body[@"text"] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0, 480.0) lineBreakMode:UILineBreakModeWordWrap];
    
    if([body[@"name"] isEqualToString:self.name])
    {
            return size.height + 30;
    }
    
    return size.height + 40;
}



#pragma mark - Keyboard handling

// Subscribe to keyboard show/hide notifications.
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
        addObserver:self selector:@selector(keyboardWillShow:)
        name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter]
        addObserver:self selector:@selector(keyboardWillHide:)
        name:UIKeyboardWillHideNotification object:nil];
}

// Unsubscribe from keyboard show/hide notifications.
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
        removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
        removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Setup keyboard handlers to slide the view containing the table view and
// text field upwards when the keyboard shows, and downwards when it hides.
- (void)keyboardWillShow:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:NO];
}

- (void)moveView:(NSDictionary*)userInfo up:(BOOL)up
{
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardEndFrame];
    
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    
    // Get the correct keyboard size to we slide the right amount.
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    int y = keyboardFrame.size.height * (up ? -1 : 1);
    self.view.frame = CGRectOffset(self.view.frame, 0, y);
    
    [UIView commitAnimations];
}

// This method will be called when the user touches on the tableView, at
// which point we will hide the keyboard (if open). This method is called
// because UITouchTableView.m calls nextResponder in its touch handler.
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    
    
    
    
}


-(void) exceed
{
    WelcomeViewController *loginview=[[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
    [self.navigationController pushViewController:loginview animated:NO];
}

@end
