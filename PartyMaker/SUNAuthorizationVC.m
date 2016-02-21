//
//  SUNAuthorizationVC.m
//  PartyMaker
//
//  Created by 2 on 2/16/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import "SUNAuthorizationVC.h"
#import "SUNPartyMakerSDK.h"
#import "SUNDataStore.h"

@interface SUNAuthorizationVC () <UITextFieldDelegate>


@end

@implementation SUNAuthorizationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Login" attributes:@{ NSForegroundColorAttributeName : [[UIColor alloc] initWithRed:76/255.f green:82/255.f blue:92/255.f alpha:1.f] }];
    self.loginTextField.attributedPlaceholder = str;
    
    str = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [[UIColor alloc] initWithRed:76/255.f green:82/255.f blue:92/255.f alpha:1.f] }];
    self.passwordTextField.attributedPlaceholder = str;
    
    self.loginTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - loginTextField

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
- (IBAction)onRegistartionTouched:(id)sender {
    
    if( ![self.loginTextField.text isEqualToString:@""]){
        if( ![self.passwordTextField.text isEqualToString:@""] ){
            
            
            //этот должен (метод СДК) быть вызван в классе модели юзер
            //тут я должен вызвать метод (модели) SUNUser и в качестве аргумента передать в этот метод его инстанс
            __block __weak SUNAuthorizationVC* weakSelf = self;
            //              checking of right symbols of login and password is not need (they are checked in my SDK)
            [[SUNPartyMakerSDK sharedInstance] registerWithUserEmail:[NSString stringWithFormat:@"%@@mail.com", self.loginTextField.text] andPassword:self.passwordTextField.text andName:self.loginTextField.text callback:^(NSDictionary *response, NSError *error) {
                
                BOOL authorized = [weakSelf canAuthorise:response];
                if ( authorized ) {
                    [weakSelf willPassAuthorisation];
                }
                
            }];
        }
    }
    
//    NSLog(@"%@@", self.loginTextField.text);
    
}


- (IBAction)onSignInTouched:(id)sender {
//    tableView can be reached faster than dataBase will answer, so dont make like below
    //registered user exists by login @"sunnyvun" and pass @"sunn1vun"
    if( ![self.loginTextField.text isEqualToString:@""]){
        if( ![self.passwordTextField.text isEqualToString:@""] ){
            
            __block __weak SUNAuthorizationVC* weakSelf = self;
//              checking of right symbols of login and password is not need (they are checked in my SDK)
            //крутилочку тут поставить
            [[SUNPartyMakerSDK sharedInstance] loginWithUserName:self.loginTextField.text andPassword:self.passwordTextField.text callback:^(NSDictionary *response, NSError *error) {
                //handler of block is initiated like that
                BOOL authorized = [weakSelf canAuthorise:response];
                if ( authorized ) {

                    [weakSelf willPassAuthorisation];
//                    тут убрать крутилочку
                }
                
            }];
        }
    }
}

#pragma mark - Authorisation methods

- (void) willPassAuthorisation{
    
//    as was said that graphics should be always painted in mainTread, mainQueue, calling tabBar initiated like that
    dispatch_async(dispatch_get_main_queue(),^{
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController* tabBar = [ storyboard instantiateViewControllerWithIdentifier:@"SUNTabBar"];
        [self presentViewController:tabBar animated:YES completion:^{
            
        }];
        NSLog(@"Table view wasn't first");
    });
    
}

- (BOOL) canAuthorise: (NSDictionary*) response{
    
    NSLog(@"%@",response);
    NSDictionary* localResponse = [response objectForKey:@"response"];
    
    if ([localResponse objectForKey:@"msg"]) {
        NSLog(@"%@",localResponse[@"msg"]);
    }
    if (localResponse[@"name"]) {
        
        NSString *newId = localResponse[@"id"];
        [[NSUserDefaults standardUserDefaults] setObject: @([newId intValue]) forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setObject:localResponse[@"email"] forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setObject:localResponse[@"name"] forKey:@"userEmail"];

        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"was loged");
        
        return YES;
    }
    else if ([[response objectForKey:@"statusCode"]  isEqual: @400]) {
        //here i need insert view that will provide user to know he entered wrong login or password
        //as for registration, as for signIn
        NSLog(@"statusCode %@", response[@"statusCode"]);
        return NO;
    }
    
    return NO;
}


#pragma mark - keyboard

-(void)keyboardWillHide:(NSNotification*)notification{
    
//    self.keyboardWasShown = NO;
    
    float duration = [[[notification userInfo]  objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    __block __weak SUNAuthorizationVC *weakSelf= self;
    [UIView animateWithDuration:duration animations:^(void){
        
        CGRect viewFrame = weakSelf.view.frame;
        viewFrame.origin.y= 0+ 64;
        weakSelf.view.frame= viewFrame;
        
    }];
    
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
