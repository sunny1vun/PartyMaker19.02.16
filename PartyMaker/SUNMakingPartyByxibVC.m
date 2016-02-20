//
//  SUNMakingPartyByxibVC.m
//  PartyMaker
//
//  Created by 2 on 2/8/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import "SUNMakingPartyByxibVC.h"
#import "SUNUniversalView.h"
#import "SUNDataStore.h"
#import "SUNPartyMakerSDK.h"
#import <MBProgressHUD.h>

@interface SUNMakingPartyByxibVC () <UITextViewDelegate , UITextFieldDelegate , UIScrollViewDelegate , SUNUniversalViewDelegate>

//clickable
@property (nonatomic, weak) IBOutlet UIView* shiningDot;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintShiningDot;
@property (nonatomic, weak) IBOutlet UIButton *buttonDateChoosing;
@property (nonatomic) NSString *dateIsChosen;
@property (nonatomic) NSString *fullDateIsChosen;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UISlider *sliderTop;
@property (nonatomic, weak) IBOutlet UISlider *sliderBot;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonSave;
@property (nonatomic) NSString *previousText;

//noneditable
@property (nonatomic, weak) IBOutlet UILabel *labelOfTopSlider;
@property (nonatomic, weak) IBOutlet UILabel *labelOfBottomSlider;

////nonclickable
@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewTopSlider;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewBotSlider;
@property (nonatomic, weak) IBOutlet UIView *dot1;
@property (nonatomic, weak) IBOutlet UIView *dot2;
@property (nonatomic, weak) IBOutlet UIView *dot3;
@property (nonatomic, weak) IBOutlet UIView *dot4;
@property (nonatomic, weak) IBOutlet UIView *dot5;
@property (nonatomic, weak) IBOutlet UIView *dot6;
@property (weak, nonatomic) IBOutlet UIView *dot7;
@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;

@property (nonatomic) UIDatePicker *pickerViewAndTools;
@property BOOL doneWasPressed;
@property BOOL partyWasEdited;
@property BOOL keyboardWasShown;

@end

@implementation SUNMakingPartyByxibVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
    [self.view layoutIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"MyriadPro-Bold" size: 15] }];
    
    self.shiningDot.center = (CGPoint)(self.dot1.center);
    self.shiningDot.layer.cornerRadius = 6.5f;
    
    self.buttonDateChoosing.layer.cornerRadius =
    self.buttonLocation.layer.cornerRadius = 5.f;
    
    [self addAttributDotsAndLines];
    [self addAttributTextField];
    [self addAttributSliders];
    [self addAttributeScrollViewPageControl];
    [self addAttributeTextView];
    self.partyWasEdited = NO;
    
    if( self.partyToChange ){
        
//        NSLog(@"Here is some party to change %@ %li", self.partyToChange.partyName, self.indexOfPartyToChange);
#warning add party id here to self.partyToChange
        [self.navigationItem setTitle:@"EDITING PARTY"];
        
        NSLog(@"partyModel fro dataCore and Networking is reused");
        //preparing startTime and endTime
        NSDate *dateOfParty = [NSDate dateWithTimeIntervalSince1970:self.partyToChange.startTime.doubleValue];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd.MM.yyyy"];
        
        NSString *dateOfPartyInString = [dateFormat stringFromDate:dateOfParty];
        NSLog(@"%@", dateOfPartyInString);
        
        [self.buttonDateChoosing setTitle:dateOfPartyInString forState:UIControlStateNormal];
        //it's for all
        self.dateIsChosen = dateOfPartyInString;
        
        [self.textField setText:self.partyToChange.nameOfParty];
        [dateFormat setDateFormat:@"HH:mm"];
        dateOfParty = [NSDate dateWithTimeIntervalSince1970:self.partyToChange.startTime.doubleValue];
        CGFloat minutes = [self numberOfMinutesInHoursAndMinutes:[dateFormat stringFromDate:dateOfParty]];
        [self.sliderTop setValue:minutes];
        [self.labelOfTopSlider setText:[self textFromValueOfSlider:self.sliderTop]];
        
        dateOfParty = [NSDate dateWithTimeIntervalSince1970:self.partyToChange.endTime.doubleValue];
        minutes = [self numberOfMinutesInHoursAndMinutes:[dateFormat stringFromDate:dateOfParty]];
        [self.sliderBot setValue:minutes];
        [self.labelOfBottomSlider setText:[self textFromValueOfSlider:self.sliderBot]];
        
        [self.pageControl setCurrentPage:self.partyToChange.logo.doubleValue];
        CGPoint contentOffset = (CGPoint){self.scrollView.frame.size.width * self.pageControl.currentPage, 0};
        [self.scrollView setContentOffset:contentOffset];
        
        [self.textView setText:self.partyToChange.comment];
        self.partyWasEdited = YES;
        
    }
    
    //NSLog(@"value from slider %f", [self numberOfMinutesInHoursAndMinutes:@"2:30"]);

}

-(void)viewDidAppear:(BOOL)animated{
    //добавил
    [super viewDidAppear:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewWillDisappear:YES];
    
}

#pragma mark - shining dot

-(void)dotTo:(CGPoint)pointTo{
    
    [self.constraintShiningDot setConstant:(pointTo.y - 30)];

    [UIView animateWithDuration:0.2f animations:^(void){
        
        [self.view updateConstraints];
        
    }];
    
}

-(void)addAttributDotsAndLines{
    
    self.dot1.layer.cornerRadius =
    self.dot2.layer.cornerRadius =
    self.dot3.layer.cornerRadius =
    self.dot4.layer.cornerRadius =
    self.dot5.layer.cornerRadius =
    self.dot6.layer.cornerRadius =
    self.dot7.layer.cornerRadius = 5.f;

}

#pragma mark - button ChooseDate

- (IBAction)dateButtonWasClicked:(id)sender {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SUNUniversalView class]) owner:nil options:nil];
    SUNUniversalView *pickerViewAndTools = nibContents[0];
    pickerViewAndTools.delegate = self;
    
    pickerViewAndTools.frame = (CGRect){0 , self.view.frame.size.height , self.view.frame.size.width , self.view.frame.size.height/2 + 66};
    
    [self.view addSubview:pickerViewAndTools];
    self.pickerViewAndTools = (UIDatePicker*)pickerViewAndTools;
    
    [UIView animateWithDuration:0.3f delay:0.05f options:UIViewAnimationOptionCurveLinear animations:^(void){
        
        CGRect frameForDatePicker = self.pickerViewAndTools.frame;
        frameForDatePicker.origin.y = self.view.frame.size.height/2 ; //+66 magic number
        self.pickerViewAndTools.frame = frameForDatePicker;
        
    }   completion:nil];
    
    self.buttonDateChoosing.enabled = NO;
    
    [self dotTo:self.dot1.center];
    
}



-(void)doneWasClicked:(SUNUniversalView *) datePickerView{
    //stores date to normalTitle of CHOOSE DATE button and hides views
    
    self.buttonDateChoosing.enabled = YES;
    
    for(id view in self.pickerViewAndTools.subviews){
        if([view class]== [UIDatePicker class]){
            UIDatePicker *datePicker= (UIDatePicker*)view;
            
//            NSDate *dateOfPicker= datePicker.date;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Europe/Kiev"];
            [dateFormat setTimeZone:tz];
            
            [dateFormat setDateFormat:@"dd.MM.yyyy"];
            NSString *prettyDate = [dateFormat stringFromDate:datePicker.date];
            [self.buttonDateChoosing setTitle:prettyDate forState:UIControlStateNormal];
            NSLog(@"%@",prettyDate);
            
            self.dateIsChosen = prettyDate;
            self.buttonDateChoosing.enabled = YES;
            self.doneWasPressed = 1;
            //use it in editing mode and dont change it
            //party is only in day of "choose day"
            //current day of party is saved with 00:00:00 for startTime and endTime of model of coredata and server
//            [dateFormat setDateFormat:@"yyyy.MM.dd"];
//            self.fullDateIsChosen = [dateFormat stringFromDate:datePicker.date];
//            NSLog(@"%@",self.fullDateIsChosen);
        }
    }
    
    [UIView animateWithDuration:0.3f delay:0.05f options:UIViewAnimationOptionCurveLinear animations:^(void){
        
        CGRect frameForDatePicker = self.pickerViewAndTools.frame;
        frameForDatePicker.origin.y= self.view.frame.size.height;
        self.pickerViewAndTools.frame= frameForDatePicker;
        
    }   completion:^(BOOL finished){
        [datePickerView removeFromSuperview];
        
    }];
    
}

-(void)cancelWasClicked:(SUNUniversalView *) datePickerView{
    
    [UIView animateWithDuration:0.3f delay:0.05f options:UIViewAnimationOptionCurveLinear animations:^(void){
        
        CGRect frameForDatePicker = self.pickerViewAndTools.frame;
        frameForDatePicker.origin.y= self.view.frame.size.height;
        datePickerView.frame= frameForDatePicker;
        
    }   completion:^(BOOL finished){
        [datePickerView removeFromSuperview];

    }];
    
    self.buttonDateChoosing.enabled = YES;
    self.doneWasPressed= 0;
    
    

}

#pragma mark- textField

-(void)addAttributTextField{
    
    self.textField.layer.cornerRadius= 5.f;
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Your Party Name" attributes:@{ NSForegroundColorAttributeName : [[UIColor alloc] initWithRed:76/255.f green:82/255.f blue:92/255.f alpha:1.f] }];
    self.textField.attributedPlaceholder = str;
    self.textField.delegate = self;
    
}

-(IBAction)textFieldDidBeginEditing:(id)sender{
    
    [self dotTo:self.dot2.center];

}

-(BOOL)textFieldShouldReturn:(id)sender{
    
    [(UITextField*)sender resignFirstResponder];

    return YES;
}

#pragma mark- sliders

-(void)addAttributSliders{
    
    self.imageViewBotSlider.image = [UIImage imageWithCGImage:[[UIImage imageNamed:@"TimePopup"] CGImage] scale:1.f orientation:UIImageOrientationUpMirrored];
    
    self.labelOfTopSlider.text = [self textFromValueOfSlider:self.sliderTop];
    
    self.labelOfBottomSlider.text = [self textFromValueOfSlider:self.sliderBot];
    
}

-(IBAction)valueChangedTopSlider:(id)sender{
    //value of slider it's minutes form 0-1439
    [self dotTo:self.dot3.center];
    
    if( self.sliderTop.value > (self.sliderBot.value - 30) ){
        
        self.sliderBot.value = self.sliderTop.value + 30;
        
    }
    
    self.labelOfTopSlider.text = [self textFromValueOfSlider:self.sliderTop];
    
    self.labelOfBottomSlider.text = [self textFromValueOfSlider:self.sliderBot];

    
}

-(NSString *)textFromValueOfSlider:(UISlider*)slider{
    CGFloat value = slider.value;
    CGFloat hours = (int)value/60;
    CGFloat minutes = (value - hours * 60);
    
    return [[NSMutableString alloc] initWithFormat:@"%2d:%02d", (int)hours, (int)minutes];
}

-(CGFloat)numberOfMinutesInHoursAndMinutes:(NSString *) time{
    
    NSArray *items = [time componentsSeparatedByString:@":"];
    NSInteger hours = [[items  objectAtIndex:0] integerValue]*60;
    NSInteger minutes = [[items objectAtIndex:1] integerValue];
    minutes += hours;
    
    return (CGFloat)minutes;
}

-(IBAction)valueChangedBotSliders:(id)sender{
    
    [self dotTo:self.dot4.center];
    

    if( self.sliderTop.value >= self.sliderBot.value-30 ){
        
        self.sliderTop.value = self.sliderBot.value - 30;
        
    }
    
    self.labelOfTopSlider.text = [self textFromValueOfSlider:self.sliderTop];
    
    self.labelOfBottomSlider.text = [self textFromValueOfSlider:self.sliderBot];

}

#pragma mark - ScrollView;

-(void)addAttributeScrollViewPageControl{
    
    /*for(CGFloat i = 0; i < self.pageControl.numberOfPages; i++){
        
        CGFloat x= i*self.scrollView.frame.size.width;
        UIImageView* imageView= [[UIImageView alloc] initWithFrame:(CGRect){x + 64, 22, 64, 62}];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%d", (int)i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imageView];
        
    }
    
    self.scrollView.contentSize = (CGSize){self.scrollView.frame.size.width * 6, self.scrollView.frame.size.height};*/
    
    [self.pageControl addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
    self.scrollView.layer.cornerRadius = 2.f;
    self.scrollView.delegate = self;
    
}

-(void)onPageChanged:(UIControlEvents*)event{
    
    [self dotTo:self.dot5.center];
    
    CGPoint contentOffset = (CGPoint){self.scrollView.frame.size.width * self.pageControl.currentPage, 0};
    [self.scrollView setContentOffset:contentOffset];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self dotTo:(CGPoint){self.shiningDot.center.x , self.dot5.center.y }];
    
    NSInteger currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self.pageControl setCurrentPage:currentPage];
    
}

- (IBAction)onPageScrollTouch:(id)sender {
    
    [self dotTo: self.dot5.center];
    
}

#pragma mark - TextView

-(void)addAttributeTextView{
    
    UIToolbar *toolsForTV= [[UIToolbar alloc] initWithFrame:(CGRect){0.f, self.view.frame.size.height, self.view.frame.size.width, 36}];
    
    [toolsForTV setBarTintColor:[[UIColor alloc] initWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1.f]];
    UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle: @"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onTextViewCanceled)];
    [cancelButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *doneButton= [[UIBarButtonItem alloc] initWithTitle: @"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onTextViewDone)];
    [doneButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *flexaibleSpace= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolsForTV sizeToFit];
    
    [toolsForTV setItems:@[cancelButton, flexaibleSpace, doneButton]];

    self.textView.layer.cornerRadius = 2.f;
    self.textView.inputAccessoryView = toolsForTV;
    self.textView.delegate = self;
    
}

-(void)onTextViewCanceled{
    
    self.textView.text = self.previousText;
    [self.textView resignFirstResponder];
    
}

-(void)onTextViewDone{
    
    [self.textView resignFirstResponder];
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView*) textView{
    
    [self dotTo:(CGPoint){self.dot1.center.x , self.textView.center.y}];
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView*)textView{
    self.previousText = self.textView.text;
    
    return YES;
}

#pragma mark - location

- (IBAction)onLocationWasClicked:(id)sender {
    
    [self dotTo:(CGPoint){self.dot1.center.x , self.buttonLocation.center.y}];
    
}


#pragma mark - keyboard

-(void)keyboardWillShow:(NSNotification*)notification{
    
    if(self.textView.isFirstResponder && (!self.keyboardWasShown)){
        
        self.keyboardWasShown = YES;
        
        CGRect keyboardRect= [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        float duration= [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] + 300;
        
        __block __weak SUNMakingPartyByxibVC *weakSelf= self;
        [UIView animateWithDuration:duration animations:^(void){
            
            CGRect viewFrame = weakSelf.view.frame;
            viewFrame.origin.y -= keyboardRect.size.height - 64;
            weakSelf.view.frame= viewFrame;
            
        }];
        
    }else {
        return;
    }
    
}

-(void)keyboardWillHide:(NSNotification*)notification{
    
    self.keyboardWasShown = NO;
    
    float duration = [[[notification userInfo]  objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    __block __weak SUNMakingPartyByxibVC *weakSelf= self;
    [UIView animateWithDuration:duration animations:^(void){
        
        CGRect viewFrame = weakSelf.view.frame;
        viewFrame.origin.y= 0+ 64;
        weakSelf.view.frame= viewFrame;
        
    }];
    
}

#pragma mark - save button

- (IBAction)onSaveClicked:(id)sender {
    NSMutableArray *parties = [[NSMutableArray alloc] init];
    
    if ( self.partyWasEdited ) {
        self.doneWasPressed = YES;
    }
    
    if (self.doneWasPressed != YES){
        
        __block UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Erorr!"
                                            message:@"You should choose date for your party"
                                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if([self.textField.text isEqualToString:@""]){
        
        __block UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Erorr!"
                                            message:@"You should enter party name"
                                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if([self.previousText isEqualToString:@""]){
        
        __block UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Erorr!"
                                            message:@"You should enter description of your party"
                                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        //old party model for plist
//        SUNDataStore *party = [[SUNDataStore alloc]  initWithName:self.textField.text  date:self.dateIsChosen                                                sliderTop: self.sliderTop    sliderBot: self.sliderBot  description: self.textView.text    pageControl:self.pageControl];
        
        
        //new party Model for coreData and Network
        NSNumber *numberJustForUsage = [[NSNumber alloc] initWithInt:64];
    
        
        //preparing startTime and endTime in creating mode
        
        //it need to be filled in changingMode
//        [formatedString appendString:self.dateIsChosen];
    
//        CGFloat value = self.sliderTop.value;
//        CGFloat hours = (int)value/60;
//        CGFloat minutes = (value - hours * 60);
//        
//        [formatedString appendFormat:@"  %02d:%02d:00", (int)hours, (int)minutes];
//        self.dateIsChosen = formatedString;
        //получает тут ноль
        
        NSString *timeInHoursAndMinutes = [self textFromValueOfSlider:self.sliderTop];
        
        NSMutableString *formatedString = [[NSMutableString alloc] initWithFormat:@"%@ %@",self.dateIsChosen, timeInHoursAndMinutes];
        [formatedString appendString:@":00"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd.MM.yyyy HH:mm:ss"];

        NSDate *dateOfParty = [dateFormat dateFromString:formatedString];

        //из таймстемпа в число получаю ноль, тогда таймстемп в строку а потом в число
        NSString *transitFromTimeStampToStartTimeInNumber = [[NSString alloc] initWithFormat:@"%f", [dateOfParty timeIntervalSince1970]];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *startTime = [f numberFromString:transitFromTimeStampToStartTimeInNumber];
        NSLog(@"%@", startTime);
        NSLog(@"%@",formatedString);
        //need to prepare endTime from sliderBot value and dateIsChosen
        
        
        
        timeInHoursAndMinutes = [self textFromValueOfSlider:self.sliderBot];

        NSMutableString *formatedString_ = [[NSMutableString alloc] initWithFormat:@"%@ %@",self.dateIsChosen, timeInHoursAndMinutes];
        [formatedString_ appendString:@":00"];
        NSDateFormatter *dateFormat_ = [[NSDateFormatter alloc] init];
        [dateFormat_ setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
        
        NSDate *dateOfParty_ = [dateFormat_ dateFromString:formatedString_];
        
        //из таймстемпа в число получаю ноль, тогда таймстемп в строку а потом в число
        NSString *transitFromTimeStampToStartTimeInNumber_ = [[NSString alloc] initWithFormat:@"%f", [dateOfParty_ timeIntervalSince1970]];
        
        formatedString = [[NSMutableString alloc] initWithFormat:@"%@ %@",self.dateIsChosen, timeInHoursAndMinutes];
        [formatedString appendString:@":00"];
        dateOfParty = [dateFormat dateFromString:formatedString];
        NSLog(@"%@",formatedString);
        
        NSNumberFormatter *f_ = [[NSNumberFormatter alloc] init];
        f_.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *endTime = [f_ numberFromString:transitFromTimeStampToStartTimeInNumber_];
        NSLog(@"was saved in plist serverModel, not from plistModel");
        
        
        NSNumber * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];

        //in editing mode i need to fill party by self.partyToChange
        SUNSaver *party = [[SUNSaver sharedInstance] initWithCreatorId: userId startTime:startTime endTime:endTime logo:[[NSNumber alloc] initWithInteger:self.pageControl.currentPage] partyId:numberJustForUsage latitude:numberJustForUsage longitude:numberJustForUsage description:self.textView.text partyName:self.textField.text];
        
        
        NSNumber *uniqId = nil;
        
        if ( self.partyWasEdited ) {
            //parties = [SUNDataStore readFromPlist];
            //working code but with plist
            //no its withot plist
//            party = self.partyToChange;
           // NSData *dataParty = [NSKeyedArchiver archivedDataWithRootObject:party];
            //here i need to check if party in array at indexOfPartyToChange is equal to edtiting party (if it's not equal than ok, save it )
            //not nessesery
            //[parties removeObjectAtIndex:self.indexOfPartyToChange];
            //[parties insertObject:dataParty atIndex:self.indexOfPartyToChange];
           // NSLog(@"data of party was added to parties");
            uniqId = self.partyToChange.partyId;
           
        
        }else{
            parties = [SUNDataStore readFromPlist];
            
            NSData *dataParty = [NSKeyedArchiver archivedDataWithRootObject:party];
            
            [parties addObject:dataParty];
        }
        
        //[SUNDataStore saveToPlist:parties];
        
        __block __weak SUNMakingPartyByxibVC* weakSelf = self;
        ////            checking of right symbols of login and password is not need (they are checked in my SDK)
        //

        //callback - block that is defined here with response and error
        //but it runs in another class-controller (Controls/Networking/SUNPartyMakerSDK) in runtime (когда оно заапущено короче с симулятора, в данном случае)
        //in that block class-cotroller transit parameters (*response, *error) which appears phisicly here only when i'm triggering them in class-controller
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[SUNPartyMakerSDK sharedInstance] addPartyWithId:uniqId.stringValue
                                                     name:party.nameOfParty
                                                startTime:party.startTime.stringValue
                                                  endTime:party.endTime.stringValue
                                                   logoId:party.logo.stringValue
                                                  comment:party.comment
                                                creatorId:userId.stringValue
                                                 latitude:party.startTime.stringValue
                                                longitude:party.startTime.stringValue
                                                 callback:^(NSDictionary *response, NSError *error){

         dispatch_async(dispatch_get_main_queue(),^{
             BOOL authorized = [weakSelf savedOnServer:response];
             if ( authorized ) {
                 [SUNDataStore saveToPlist:parties];
                 NSLog(@"good response from server");
             }else{
                 NSLog(@"bad response from server");
             }
             [self.navigationController popToRootViewControllerAnimated:YES];
             [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
         });
        }];
        

    }
    
}

- (BOOL) savedOnServer: (NSDictionary*) response{
    NSLog(@"server response \n%@",response);
    NSDictionary* localResponse = [response objectForKey:@"response"];
    
    if ([localResponse objectForKey:@"msg"]) {
        NSLog(@"%@",localResponse[@"msg"]);
    }
    
    if ( [[response objectForKey:@"statusCode"]  isEqual: @200]) {
        NSLog(@"was saved");
        return YES;
    }
    else if ([[response objectForKey:@"statusCode"]  isEqual: @400]) {
        //here i need insert view that will provide user to know he entered wrong login or password
        //as for registration, as for signIn
        NSLog(@"statusCode %@", response[@"statusCode"]);
        return NO;
    }else{
//        NSLog(@"statusCode %@", response[@"statusCode"]);
        return NO;

    }
    
    return YES;
}


#pragma mark - cancel button

- (IBAction)onCancelClicked:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];

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
