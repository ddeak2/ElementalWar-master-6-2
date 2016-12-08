//
//  ViewController.h
//  ElementalWar
//
//  Created by Fabio Alves on 2/8/16.
//
//  Members: Fabio Alves, Jennifer Trippett, David Deak, Mahadeo Khemraj
//
//  Copyright © 2016 HeritageSevenApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)startNewGame:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *aiDeckCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerDeckCountLabel;


//Player card selection
- (IBAction)cardSelection:(id)sender;
- (IBAction)nextRoundButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *playerCard1;
@property (weak, nonatomic) IBOutlet UIButton *playerCard2;
@property (weak, nonatomic) IBOutlet UIButton *playerCard3;

//testing Labels
@property (weak, nonatomic) IBOutlet UILabel *aiCardTestLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerCardTestLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerDiscardPileLabel;
@property (weak, nonatomic) IBOutlet UILabel *aiDiscardPileLabel;
@property (weak, nonatomic) IBOutlet UILabel *warLabel;

@property (weak, nonatomic) IBOutlet UILabel *inPlayCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *aiCardWarLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerCardWarLabel;


//Power-Up Buttons
- (IBAction)powerUp1SmallPackageButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *powerUp1SmallPackageButtonOutlet;
- (IBAction)powerUp2NegateElementsButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *powerUp2NegateElementsOutlet;
- (IBAction)powerUp3WarMachineButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *powerUp3WarMachineOutlet;
- (IBAction)powerUp4ReconButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *powerUp4ReconOutlet;

//Ai Cards Labels
@property (weak, nonatomic) IBOutlet UILabel *aiCardLabel1;
@property (weak, nonatomic) IBOutlet UILabel *aiCardLabel2;
@property (weak, nonatomic) IBOutlet UILabel *aiCardLabel3;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

//CARD IMAGES
@property (weak, nonatomic) IBOutlet UIImageView *playerDeckImage;
@property (weak, nonatomic) IBOutlet UIImageView *playerCard1Image;
@property (weak, nonatomic) IBOutlet UIImageView *playerCard2Image;
@property (weak, nonatomic) IBOutlet UIImageView *playerCard3Image;
@property (weak, nonatomic) IBOutlet UIImageView *playerDiscardPileImage;
@property (weak, nonatomic) IBOutlet UIImageView *playerCardInPlayImage;
@property (weak, nonatomic) IBOutlet UIImageView *aiDeckImage;
@property (weak, nonatomic) IBOutlet UIImageView *aiDiscardPileImage;
@property (weak, nonatomic) IBOutlet UIImageView *aiCard1Image;
@property (weak, nonatomic) IBOutlet UIImageView *aiCard2Image;
@property (weak, nonatomic) IBOutlet UIImageView *aiCard3Image;
@property (weak, nonatomic) IBOutlet UIImageView *aiCardInPlayImage;

//POWER UP IMAGES
@property (weak, nonatomic) IBOutlet UIImageView *powerUp1Image;
@property (weak, nonatomic) IBOutlet UIImageView *powerUp2Image;
@property (weak, nonatomic) IBOutlet UIImageView *powerUp3Image;
@property (weak, nonatomic) IBOutlet UIImageView *powerUp4Image;

//Winner and element bonus labels
@property (weak, nonatomic) IBOutlet UILabel *aiBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *handWinnerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *overallWinnerLabel;

//Game Reset Button
@property (weak, nonatomic) IBOutlet UIButton *gameReset;

//War Card Image outlets
@property (weak, nonatomic) IBOutlet UIImageView *warBottomCard;
@property (weak, nonatomic) IBOutlet UIImageView *warTopCard;
@property (weak, nonatomic) IBOutlet UIImageView *warAiTopCard;
@property (weak, nonatomic) IBOutlet UIImageView *warAiBottomCard;





@end