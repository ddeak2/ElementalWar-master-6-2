//
//  ViewController.m
//  ElementalWar
//
//  Created by Fabio Alves on 2/8/16.
//
//  Members: Fabio Alves, Jennifer Trippett, David Deak, Mahadeo Khemraj
//
//  Copyright © 2016 HeritageSevenApps. All rights reserved.
//

#import "ViewController.h"
#import "Deck.h"
#import "Card.h"

@interface ViewController ()


@end

//set up the stacks
NSMutableArray *aiStack;
NSMutableArray *playerStack;
NSMutableArray *playerHand;
NSMutableArray *inPlay;
NSMutableArray *playerDiscardPile;
NSMutableArray *aiDiscardPile;
NSNumber *emptyArray;

//set up the power ups
BOOL pu1SmallPackageInt;
BOOL pu2NegateElementsInt;
BOOL pu4ReconInt;
#define on true
#define off false

#define AICARD 0
#define PLAYERCARD 1
#define ELEMENTBONUS 2

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    playerStack = [[NSMutableArray alloc]init];
    aiStack = [[NSMutableArray alloc]init];
    playerHand = [[NSMutableArray alloc]init];
    inPlay = [[NSMutableArray alloc]init];
    playerDiscardPile = [[NSMutableArray alloc]init];
    aiDiscardPile = [[NSMutableArray alloc]init];
    
    //filling in the Player's Hand Array to compare values
    emptyArray = [[NSNumber alloc]initWithInt:0];
    [playerHand addObject:emptyArray];
    [playerHand addObject:emptyArray];
    [playerHand addObject:emptyArray];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - gameLogic


- (void) fillPlayersHand{//Fill the player's hand with cards.

    for (int i = 0; i < playerHand.count ; i++) {
        [self checkForGameOver];
        if ([playerHand objectAtIndex:i] == emptyArray && playerStack.count > 0) {
            [playerHand replaceObjectAtIndex:i withObject:[playerStack lastObject]];
            [playerStack removeLastObject];
        }
        
    }
}

-(void)checkForGameOver{
    //player side
    if (playerStack.count == 0 && playerDiscardPile > 0) {
        playerStack = [NSMutableArray arrayWithArray:playerDiscardPile];
        [playerDiscardPile removeAllObjects];
//        NSLog(@"end of stack");
//        NSLog(@"player Stack count is %lu", (unsigned long)playerStack.count);
//        NSLog(@"player Discard count is %lu", (unsigned long)playerDiscardPile.count);

    }
    
//    Conditions for the Player to Lose the Game - Note that the PlayerHand Array is never empty so we have to compare all the 3 objects to the "emptyArray" NSNumber set previously
        if (playerStack.count == 0 &&
            playerDiscardPile.count == 0 &&
            [playerHand objectAtIndex:0] == emptyArray &&
            [playerHand objectAtIndex:1] == emptyArray &&
            [playerHand objectAtIndex:2] == emptyArray){
            NSLog(@"💥💥💥💥💥 GAME OVER, YOU LOST  💥💥💥💥💥");
           [_overallWinnerLabel setImage:[UIImage imageNamed:@"0message_lose"]];
            _overallWinnerLabel.hidden = false;
            _gameReset.hidden = false;  //show the Play Again button.
            _gameReset.enabled = true;
            _playerCard1.enabled = false; //disable the player card buttons on game over
            _playerCard2.enabled = false;
            _playerCard3.enabled = false;
            _powerUp2NegateElementsOutlet.enabled = false;  //disable the powerups on game over
            _powerUp1SmallPackageButtonOutlet.enabled = false;
            _powerUp3WarMachineOutlet.enabled = false;
            _powerUp4ReconOutlet.enabled = false;
            _nextButton.enabled = false;  //disable next button on game over.
            
            
        }
    
    //ai Side
    if (aiStack.count == 0 && aiDiscardPile.count >0) {
        aiStack = [NSMutableArray arrayWithArray:aiDiscardPile];
        [aiDiscardPile removeAllObjects];
        NSLog(@"end of ai Stack");
    }else if (aiStack.count == 0 && aiDiscardPile.count == 0){
        NSLog(@"GAME OVER, YOU WIN!");
      
        [_overallWinnerLabel setImage:[UIImage imageNamed:@"0message_win"]];
        _overallWinnerLabel.hidden = false;  //show the winner label
        _gameReset.hidden = false;  //show and enable the game reset button
        _gameReset.enabled = true;
        _playerCard1.enabled = false;  //disable player cards
        _playerCard2.enabled = false;
        _playerCard3.enabled = false;
        _powerUp2NegateElementsOutlet.enabled = false;  //disable powerups
        _powerUp1SmallPackageButtonOutlet.enabled = false;
        _powerUp3WarMachineOutlet.enabled = false;
        _powerUp4ReconOutlet.enabled = false;
        _nextButton.enabled = false;  //disable the next button.
    }
    
    
}


- (IBAction)startNewGame:(id)sender {
    
    //clear the player hand array by replacing each cell.
    
    [playerHand replaceObjectAtIndex:0 withObject:emptyArray];
    [playerHand replaceObjectAtIndex:1 withObject:emptyArray];
    [playerHand replaceObjectAtIndex:2 withObject:emptyArray];
    //set arrays to empty when starting a new game.
    
    [playerStack removeAllObjects];
    [aiStack removeAllObjects];
    [playerDiscardPile removeAllObjects];
    [aiDiscardPile removeAllObjects];
    [inPlay removeAllObjects];
    
    //Set up the Deck and Shuffle
    Deck *deck = [[Deck alloc] init];
    [deck shuffle];
    
    
    //Distribute the cards
    while ([deck cardsRemaining] > 0){
        Card *card = [deck draw];
        [playerStack addObject:card];
        Card *card2 = [deck draw];
        [aiStack addObject:card2];
    }
    
    //Fill Player's Hand
    [self fillPlayersHand];

    [self updateGUI];
    
    _overallWinnerLabel.hidden = true;  //clear the overall winner label
    
    //hide game reset and hand labels when game starts.
    _gameReset.hidden = true;  //hide the game reset button
    _gameReset.enabled = false;
    _playerBonusLabel.hidden = true;  //hide the bonus labels.
    _aiBonusLabel.hidden = true;
    _handWinnerLabel.hidden = true;  //hide the hand winner label
    
    //hide the war cards
    
    _warTopCard.hidden = true;
    _warBottomCard.hidden = true;
    _warAiBottomCard.hidden = true;
    _warAiTopCard.hidden = true;
    
    //other enabled buttons

    _nextButton.enabled = true;
    
    //enable the powerups
    
    _powerUp1SmallPackageButtonOutlet.enabled = true;
    _powerUp2NegateElementsOutlet.enabled = true;
    _powerUp3WarMachineOutlet.enabled = true;
    _powerUp4ReconOutlet.enabled = true;
    
    //reset the powerup images.
    
    [_powerUp1Image setImage: [UIImage imageNamed:@"PU_SP_inactive"]];
    [_powerUp2Image setImage: [UIImage imageNamed:@"PU_NE_inactive"]];
    [_powerUp3Image setImage: [UIImage imageNamed:@"PU_WM_inactive"]];
    
    //reset the cards in play and the player's hand
    
    [_aiCardInPlayImage setImage: [UIImage imageNamed:@"0emptycard"]];
    [_playerCardInPlayImage setImage: [UIImage imageNamed:@"0emptycard"]];
    [_playerCard1Image setImage: [UIImage imageNamed:@"0emptycard"]];
    [_playerCard2Image setImage: [UIImage imageNamed:@"0emptycard"]];
    [_playerCard3Image setImage: [UIImage imageNamed:@"0emptycard"]];
    [_playerDiscardPileImage setImage: [UIImage imageNamed:@"0emptycard"]];
    
    
    
}

- (void)updateGUI{
    self.playerDeckCountLabel.text = [NSString stringWithFormat:@"%ld", playerStack.count];
    self.aiDeckCountLabel.text = [NSString stringWithFormat:@"%ld", aiStack.count];
    self.playerDiscardPileLabel.text = [NSString stringWithFormat:@"%ld", playerDiscardPile.count];
    self.aiDiscardPileLabel.text = [NSString stringWithFormat:@"%ld", aiDiscardPile.count];
    self.inPlayCounterLabel.text = [NSString stringWithFormat:@"%ld", inPlay.count];
    
    //UPDATE CARD IMAGES IN STACK AND DISCARD
    
    //***MY UPDATE*** update card images
    if (playerStack.count == 0){  //update player stack image
        [_playerDeckImage setImage: [UIImage imageNamed:@"0emptycard"]];}
    else{
        [_playerDeckImage setImage: [UIImage imageNamed:@"0back_of_card"]];}
    
    if (playerDiscardPile.count == 0){//update player discard image
        [_playerDiscardPileImage setImage: [UIImage imageNamed:@"0emptycard"]];}
    else{
        [_playerDiscardPileImage setImage: [UIImage imageNamed:@"0back_of_card"]];}
    


    if (aiStack.count == 0){//update AI stack image
        [_aiDeckImage setImage: [UIImage imageNamed:@"0emptycard"]];}
    else{
        [_aiDeckImage setImage: [UIImage imageNamed:@"0back_of_card"]];}

    if (aiDiscardPile.count == 0) {//update AI discard image
        [_aiDiscardPileImage setImage: [UIImage imageNamed:@"0emptycard"]];}
    else{
        [_aiDiscardPileImage setImage: [UIImage imageNamed:@"0back_of_card"]];}
    
     //SET AI CARD 1,2,3 IMAGES
    
    
    //update Ai Card Labels
    [self.aiCardLabel1 setText:@"Card 1"];
    [self.aiCardLabel2 setText:@"Card 2"];
    [self.aiCardLabel3 setText:@"Card 3"];
    
    //update AI card images
    [_aiCard1Image setImage: [UIImage imageNamed:@"0emptycard"]];
    [_aiCard2Image setImage: [UIImage imageNamed:@"0emptycard"]];
    [_aiCard3Image setImage: [UIImage imageNamed:@"0emptycard"]];
    
    //update the inPlay Labels
    if (inPlay.count) {
        Card *card4 = [inPlay objectAtIndex:AICARD];
        Card *card5 = [inPlay objectAtIndex:PLAYERCARD];
        [self.aiCardTestLabel setText:[NSString stringWithFormat:@"%d of %d", card4.value, card4.element]];
        [self.playerCardTestLabel setText:[NSString stringWithFormat:@"%d of %d", card5.value, card5.element]];
        
        
        //UPDATE THE CARDS IN PLAY
        
        //SET AI CARD IMAGE
        [_aiCardInPlayImage setAlpha:0.0f];  //animate the ai card in play.
        [UIView animateWithDuration:2.0f animations:^{
            [_aiCardInPlayImage setAlpha:1.0f];
        }];
        if(card4.element == 0){  //Set the AI card in play image.
            if(card4.value == 1)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"fire_01"]];
            else if(card4.value == 2)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"fire_02"]];
            else if(card4.value == 3)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"fire_03"]];
            else if(card4.value == 4)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"fire_04"]];
            else if(card4.value == 5)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"fire_05"]];
            else if(card4.value == 6)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"fire_06"]];
            else if(card4.value == 7)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"fire_07"]];
            else if(card4.value == 8)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"fire_08"]];
            else if(card4.value == 9)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"fire_09"]];
            else if(card4.value == 10)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"fire_10"]];
            else if(card4.value == 11)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"fire_11"]];
            else if(card4.value == 12)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"fire_12"]];}
        else if(card4.element == 1){
            if(card4.value == 1)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"earth_01"]];
            else if(card4.value == 2)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"earth_02"]];
            else if(card4.value == 3)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"earth_03"]];
            else if(card4.value == 4)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"earth_04"]];
            else if(card4.value == 5)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"earth_05"]];
            else if(card4.value == 6)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"earth_06"]];
            else if(card4.value == 7)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"earth_07"]];
            else if(card4.value == 8)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"earth_08"]];
            else if(card4.value == 9)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"earth_09"]];
            else if(card4.value == 10)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"earth_10"]];
            else if(card4.value == 11)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"earth_11"]];
            else if(card4.value == 12)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"earth_12"]];}
        else if(card4.element == 2){
            if(card4.value == 1)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"water_01"]];
            else if(card4.value == 2)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"water_02"]];
            else if(card4.value == 3)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"water_03"]];
            else if(card4.value == 4)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"water_04"]];
            else if(card4.value == 5)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"water_05"]];
            else if(card4.value == 6)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"water_06"]];
            else if(card4.value == 7)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"water_07"]];
            else if(card4.value == 8)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"water_08"]];
            else if(card4.value == 9)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"water_09"]];
            else if(card4.value == 10)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"water_10"]];
            else if(card4.value == 11)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"water_11"]];
            else if(card4.value == 12)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"water_12"]];}
        else if(card4.element == 3){
            if(card4.value == 1)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"air_01"]];
            else if(card4.value == 2)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"air_02"]];
            else if(card4.value == 3)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"air_03"]];
            else if(card4.value == 4)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"air_04"]];
            else if(card4.value == 5)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"air_05"]];
            else if(card4.value == 6)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"air_06"]];
            else if(card4.value == 7)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"air_07"]];
            else if(card4.value == 8)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"air_08"]];
            else if(card4.value == 9)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"air_09"]];
            else if(card4.value == 10)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"air_10"]];
            else if(card4.value == 11)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"air_11"]];
            else if(card4.value == 12)
                [_aiCardInPlayImage setImage: [UIImage imageNamed:@"air_12"]];}
        
        //SET PLAYER CARD IN PLAY IMAGE
        [_playerCardInPlayImage setAlpha:0.0f];  //animate the player card in play
        [UIView animateWithDuration:2.0f animations:^{
            [_playerCardInPlayImage setAlpha:1.0f];
        }];
        if(card5.element == 0){  //set the player card in play.
            if(card5.value == 1)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"fire_01"]];
            else if(card5.value == 2)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"fire_02"]];
            else if(card5.value == 3)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"fire_03"]];
            else if(card5.value == 4)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"fire_04"]];
            else if(card5.value == 5)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"fire_05"]];
            else if(card5.value == 6)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"fire_06"]];
            else if(card5.value == 7)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"fire_07"]];
            else if(card5.value == 8)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"fire_08"]];
            else if(card5.value == 9)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"fire_09"]];
            else if(card5.value == 10)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"fire_10"]];
            else if(card5.value == 11)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"fire_11"]];
            else if(card5.value == 12)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"fire_12"]];}
        else if(card5.element == 1){
            if(card5.value == 1)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"earth_01"]];
            else if(card5.value == 2)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"earth_02"]];
            else if(card5.value == 3)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"earth_03"]];
            else if(card5.value == 4)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"earth_04"]];
            else if(card5.value == 5)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"earth_05"]];
            else if(card5.value == 6)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"earth_06"]];
            else if(card5.value == 7)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"earth_07"]];
            else if(card5.value == 8)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"earth_08"]];
            else if(card5.value == 9)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"earth_09"]];
            else if(card5.value == 10)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"earth_10"]];
            else if(card5.value == 11)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"earth_11"]];
            else if(card5.value == 12)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"earth_12"]];}
        else if(card5.element == 2){
            if(card5.value == 1)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"water_01"]];
            else if(card5.value == 2)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"water_02"]];
            else if(card5.value == 3)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"water_03"]];
            else if(card5.value == 4)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"water_04"]];
            else if(card5.value == 5)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"water_05"]];
            else if(card5.value == 6)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"water_06"]];
            else if(card5.value == 7)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"water_07"]];
            else if(card5.value == 8)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"water_08"]];
            else if(card5.value == 9)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"water_09"]];
            else if(card5.value == 10)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"water_10"]];
            else if(card5.value == 11)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"water_11"]];
            else if(card5.value == 12)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"water_12"]];}
        else if(card5.element == 3){
            if(card5.value == 1)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"air_01"]];
            else if(card5.value == 2)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"air_02"]];
            else if(card5.value == 3)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"air_03"]];
            else if(card5.value == 4)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"air_04"]];
            else if(card5.value == 5)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"air_05"]];
            else if(card5.value == 6)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"air_06"]];
            else if(card5.value == 7)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"air_07"]];
            else if(card5.value == 8)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"air_08"]];
            else if(card5.value == 9)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"air_09"]];
            else if(card5.value == 10)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"air_10"]];
            else if(card5.value == 11)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"air_11"]];
            else if(card5.value == 12)
                [_playerCardInPlayImage setImage: [UIImage imageNamed:@"air_12"]];}    }
    
    
}

- (IBAction)cardSelection:(id)sender {//Selector of the card
    _nextButton.enabled = true;
    _nextButton.hidden = false;
    [self checkForWar:sender];  //Send the card Button ID to the CheckForWar Class
    [self fillPlayersHand];
    [self updateGUI];
}

- (IBAction)nextRoundButton:(id)sender {
   
    //erase War Indicator Label
    [self.warLabel setText:@""];
    
    //reset table cards
    [inPlay removeAllObjects];
    [self.aiCardTestLabel setText:@"xxx"];
    [self.playerCardTestLabel setText:@"xxx"];
    
    //clear the player and ai card in play images.
    
    [_playerCardInPlayImage setImage: [UIImage imageNamed:@"0emptycard"]];
    [_aiCardInPlayImage setImage: [UIImage imageNamed:@"0emptycard"]];
    
    //clear the labels
    
    _handWinnerLabel.hidden = true;
    _aiBonusLabel.hidden = true;
    _playerBonusLabel.hidden = true;
    
    //hide and disable the next round button
    _nextButton.enabled = false;
    _nextButton.hidden = true;
    
    //hide the war cards
    
    _warTopCard.hidden = true;
    _warBottomCard.hidden = true;
    _warAiTopCard.hidden = true;
    _warAiBottomCard.hidden = true;
    

    
    [self updateGUI];
    
    //Check for GG
     [self checkForGameOver];

    //Update Player Cards
    
    if ([[playerHand objectAtIndex:0] isMemberOfClass:[Card class]]) {  //Check if the Object in the PlayerHand Array is a CARD to update it.
        [self.playerCard1 setEnabled:true];                             //reactivate the Player card buttons
        Card *card1 = [playerHand objectAtIndex:0];
   //     [self.playerCard1 setTitle:[NSString stringWithFormat:@"%d of %d", card1.value, card1.element] forState:UIControlStateNormal];
        
        //SET CARD IMAGE
        if(card1.element == 0){  //set the image of player card 1.
            if(card1.value == 1)
                [_playerCard1Image setImage: [UIImage imageNamed:@"fire_01"]];
            else if(card1.value == 2)
                [_playerCard1Image setImage: [UIImage imageNamed:@"fire_02"]];
            else if(card1.value == 3)
                [_playerCard1Image setImage: [UIImage imageNamed:@"fire_03"]];
            else if(card1.value == 4)
                [_playerCard1Image setImage: [UIImage imageNamed:@"fire_04"]];
            else if(card1.value == 5)
                [_playerCard1Image setImage: [UIImage imageNamed:@"fire_05"]];
            else if(card1.value == 6)
                [_playerCard1Image setImage: [UIImage imageNamed:@"fire_06"]];
            else if(card1.value == 7)
                [_playerCard1Image setImage: [UIImage imageNamed:@"fire_07"]];
            else if(card1.value == 8)
                [_playerCard1Image setImage: [UIImage imageNamed:@"fire_08"]];
            else if(card1.value == 9)
                [_playerCard1Image setImage: [UIImage imageNamed:@"fire_09"]];
            else if(card1.value == 10)
                [_playerCard1Image setImage: [UIImage imageNamed:@"fire_10"]];
            else if(card1.value == 11)
                [_playerCard1Image setImage: [UIImage imageNamed:@"fire_11"]];
            else if(card1.value == 12)
                [_playerCard1Image setImage: [UIImage imageNamed:@"fire_12"]];}
        else if(card1.element == 1){
            if(card1.value == 1)
                [_playerCard1Image setImage: [UIImage imageNamed:@"earth_01"]];
            else if(card1.value == 2)
                [_playerCard1Image setImage: [UIImage imageNamed:@"earth_02"]];
            else if(card1.value == 3)
                [_playerCard1Image setImage: [UIImage imageNamed:@"earth_03"]];
            else if(card1.value == 4)
                [_playerCard1Image setImage: [UIImage imageNamed:@"earth_04"]];
            else if(card1.value == 5)
                [_playerCard1Image setImage: [UIImage imageNamed:@"earth_05"]];
            else if(card1.value == 6)
                [_playerCard1Image setImage: [UIImage imageNamed:@"earth_06"]];
            else if(card1.value == 7)
                [_playerCard1Image setImage: [UIImage imageNamed:@"earth_07"]];
            else if(card1.value == 8)
                [_playerCard1Image setImage: [UIImage imageNamed:@"earth_08"]];
            else if(card1.value == 9)
                [_playerCard1Image setImage: [UIImage imageNamed:@"earth_09"]];
            else if(card1.value == 10)
                [_playerCard1Image setImage: [UIImage imageNamed:@"earth_10"]];
            else if(card1.value == 11)
                [_playerCard1Image setImage: [UIImage imageNamed:@"earth_11"]];
            else if(card1.value == 12)
                [_playerCard1Image setImage: [UIImage imageNamed:@"earth_12"]];}
        else if(card1.element == 2){
            if(card1.value == 1)
                [_playerCard1Image setImage: [UIImage imageNamed:@"water_01"]];
            else if(card1.value == 2)
                [_playerCard1Image setImage: [UIImage imageNamed:@"water_02"]];
            else if(card1.value == 3)
                [_playerCard1Image setImage: [UIImage imageNamed:@"water_03"]];
            else if(card1.value == 4)
                [_playerCard1Image setImage: [UIImage imageNamed:@"water_04"]];
            else if(card1.value == 5)
                [_playerCard1Image setImage: [UIImage imageNamed:@"water_05"]];
            else if(card1.value == 6)
                [_playerCard1Image setImage: [UIImage imageNamed:@"water_06"]];
            else if(card1.value == 7)
                [_playerCard1Image setImage: [UIImage imageNamed:@"water_07"]];
            else if(card1.value == 8)
                [_playerCard1Image setImage: [UIImage imageNamed:@"water_08"]];
            else if(card1.value == 9)
                [_playerCard1Image setImage: [UIImage imageNamed:@"water_09"]];
            else if(card1.value == 10)
                [_playerCard1Image setImage: [UIImage imageNamed:@"water_10"]];
            else if(card1.value == 11)
                [_playerCard1Image setImage: [UIImage imageNamed:@"water_11"]];
            else if(card1.value == 12)
                [_playerCard1Image setImage: [UIImage imageNamed:@"water_12"]];}
        else if(card1.element == 3){
            if(card1.value == 1)
                [_playerCard1Image setImage: [UIImage imageNamed:@"air_01"]];
            else if(card1.value == 2)
                [_playerCard1Image setImage: [UIImage imageNamed:@"air_02"]];
            else if(card1.value == 3)
                [_playerCard1Image setImage: [UIImage imageNamed:@"air_03"]];
            else if(card1.value == 4)
                [_playerCard1Image setImage: [UIImage imageNamed:@"air_04"]];
            else if(card1.value == 5)
                [_playerCard1Image setImage: [UIImage imageNamed:@"air_05"]];
            else if(card1.value == 6)
                [_playerCard1Image setImage: [UIImage imageNamed:@"air_06"]];
            else if(card1.value == 7)
                [_playerCard1Image setImage: [UIImage imageNamed:@"air_07"]];
            else if(card1.value == 8)
                [_playerCard1Image setImage: [UIImage imageNamed:@"air_08"]];
            else if(card1.value == 9)
                [_playerCard1Image setImage: [UIImage imageNamed:@"air_09"]];
            else if(card1.value == 10)
                [_playerCard1Image setImage: [UIImage imageNamed:@"air_10"]];
            else if(card1.value == 11)
                [_playerCard1Image setImage: [UIImage imageNamed:@"air_11"]];
            else if(card1.value == 12)
                [_playerCard1Image setImage: [UIImage imageNamed:@"air_12"]];}
    }
    
    if ([[playerHand objectAtIndex:1] isMemberOfClass:[Card class]]) {
        [self.playerCard2 setEnabled:true];
        Card *card2 = [playerHand objectAtIndex:1];
      //  [self.playerCard2 setTitle:[NSString stringWithFormat:@"%d of %d", card2.value, card2.element] forState:UIControlStateNormal];
        
        //SET CARD IMAGE
        if(card2.element == 0){  //set the image of player card 2.
            if(card2.value == 1)
                [_playerCard2Image setImage: [UIImage imageNamed:@"fire_01"]];
            else if(card2.value == 2)
                [_playerCard2Image setImage: [UIImage imageNamed:@"fire_02"]];
            else if(card2.value == 3)
                [_playerCard2Image setImage: [UIImage imageNamed:@"fire_03"]];
            else if(card2.value == 4)
                [_playerCard2Image setImage: [UIImage imageNamed:@"fire_04"]];
            else if(card2.value == 5)
                [_playerCard2Image setImage: [UIImage imageNamed:@"fire_05"]];
            else if(card2.value == 6)
                [_playerCard2Image setImage: [UIImage imageNamed:@"fire_06"]];
            else if(card2.value == 7)
                [_playerCard2Image setImage: [UIImage imageNamed:@"fire_07"]];
            else if(card2.value == 8)
                [_playerCard2Image setImage: [UIImage imageNamed:@"fire_08"]];
            else if(card2.value == 9)
                [_playerCard2Image setImage: [UIImage imageNamed:@"fire_09"]];
            else if(card2.value == 10)
                [_playerCard2Image setImage: [UIImage imageNamed:@"fire_10"]];
            else if(card2.value == 11)
                [_playerCard2Image setImage: [UIImage imageNamed:@"fire_11"]];
            else if(card2.value == 12)
                [_playerCard2Image setImage: [UIImage imageNamed:@"fire_12"]];}
        else if(card2.element == 1){
            if(card2.value == 1)
                [_playerCard2Image setImage: [UIImage imageNamed:@"earth_01"]];
            else if(card2.value == 2)
                [_playerCard2Image setImage: [UIImage imageNamed:@"earth_02"]];
            else if(card2.value == 3)
                [_playerCard2Image setImage: [UIImage imageNamed:@"earth_03"]];
            else if(card2.value == 4)
                [_playerCard2Image setImage: [UIImage imageNamed:@"earth_04"]];
            else if(card2.value == 5)
                [_playerCard2Image setImage: [UIImage imageNamed:@"earth_05"]];
            else if(card2.value == 6)
                [_playerCard2Image setImage: [UIImage imageNamed:@"earth_06"]];
            else if(card2.value == 7)
                [_playerCard2Image setImage: [UIImage imageNamed:@"earth_07"]];
            else if(card2.value == 8)
                [_playerCard2Image setImage: [UIImage imageNamed:@"earth_08"]];
            else if(card2.value == 9)
                [_playerCard2Image setImage: [UIImage imageNamed:@"earth_09"]];
            else if(card2.value == 10)
                [_playerCard2Image setImage: [UIImage imageNamed:@"earth_10"]];
            else if(card2.value == 11)
                [_playerCard2Image setImage: [UIImage imageNamed:@"earth_11"]];
            else if(card2.value == 12)
                [_playerCard2Image setImage: [UIImage imageNamed:@"earth_12"]];}
        else if(card2.element == 2){
            if(card2.value == 1)
                [_playerCard2Image setImage: [UIImage imageNamed:@"water_01"]];
            else if(card2.value == 2)
                [_playerCard2Image setImage: [UIImage imageNamed:@"water_02"]];
            else if(card2.value == 3)
                [_playerCard2Image setImage: [UIImage imageNamed:@"water_03"]];
            else if(card2.value == 4)
                [_playerCard2Image setImage: [UIImage imageNamed:@"water_04"]];
            else if(card2.value == 5)
                [_playerCard2Image setImage: [UIImage imageNamed:@"water_05"]];
            else if(card2.value == 6)
                [_playerCard2Image setImage: [UIImage imageNamed:@"water_06"]];
            else if(card2.value == 7)
                [_playerCard2Image setImage: [UIImage imageNamed:@"water_07"]];
            else if(card2.value == 8)
                [_playerCard2Image setImage: [UIImage imageNamed:@"water_08"]];
            else if(card2.value == 9)
                [_playerCard2Image setImage: [UIImage imageNamed:@"water_09"]];
            else if(card2.value == 10)
                [_playerCard2Image setImage: [UIImage imageNamed:@"water_10"]];
            else if(card2.value == 11)
                [_playerCard2Image setImage: [UIImage imageNamed:@"water_11"]];
            else if(card2.value == 12)
                [_playerCard2Image setImage: [UIImage imageNamed:@"water_12"]];}
        else if(card2.element == 3){
            if(card2.value == 1)
                [_playerCard2Image setImage: [UIImage imageNamed:@"air_01"]];
            else if(card2.value == 2)
                [_playerCard2Image setImage: [UIImage imageNamed:@"air_02"]];
            else if(card2.value == 3)
                [_playerCard2Image setImage: [UIImage imageNamed:@"air_03"]];
            else if(card2.value == 4)
                [_playerCard2Image setImage: [UIImage imageNamed:@"air_04"]];
            else if(card2.value == 5)
                [_playerCard2Image setImage: [UIImage imageNamed:@"air_05"]];
            else if(card2.value == 6)
                [_playerCard2Image setImage: [UIImage imageNamed:@"air_06"]];
            else if(card2.value == 7)
                [_playerCard2Image setImage: [UIImage imageNamed:@"air_07"]];
            else if(card2.value == 8)
                [_playerCard2Image setImage: [UIImage imageNamed:@"air_08"]];
            else if(card2.value == 9)
                [_playerCard2Image setImage: [UIImage imageNamed:@"air_09"]];
            else if(card2.value == 10)
                [_playerCard2Image setImage: [UIImage imageNamed:@"air_10"]];
            else if(card2.value == 11)
                [_playerCard2Image setImage: [UIImage imageNamed:@"air_11"]];
            else if(card2.value == 12)
                [_playerCard2Image setImage: [UIImage imageNamed:@"air_12"]];}
    }

    if ([[playerHand objectAtIndex:2] isMemberOfClass:[Card class]]) {
        [self.playerCard3 setEnabled:true];
        Card *card3 = [playerHand objectAtIndex:2];
  //      [self.playerCard3 setTitle:[NSString stringWithFormat:@"%d of %d", card3.value, card3.element] forState:UIControlStateNormal];
        
        //SET CARD IMAGE
        if(card3.element == 0){ //set the image of player card 3.
            if(card3.value == 1)
                [_playerCard3Image setImage: [UIImage imageNamed:@"fire_01"]];
            else if(card3.value == 2)
                [_playerCard3Image setImage: [UIImage imageNamed:@"fire_02"]];
            else if(card3.value == 3)
                [_playerCard3Image setImage: [UIImage imageNamed:@"fire_03"]];
            else if(card3.value == 4)
                [_playerCard3Image setImage: [UIImage imageNamed:@"fire_04"]];
            else if(card3.value == 5)
                [_playerCard3Image setImage: [UIImage imageNamed:@"fire_05"]];
            else if(card3.value == 6)
                [_playerCard3Image setImage: [UIImage imageNamed:@"fire_06"]];
            else if(card3.value == 7)
                [_playerCard3Image setImage: [UIImage imageNamed:@"fire_07"]];
            else if(card3.value == 8)
                [_playerCard3Image setImage: [UIImage imageNamed:@"fire_08"]];
            else if(card3.value == 9)
                [_playerCard3Image setImage: [UIImage imageNamed:@"fire_09"]];
            else if(card3.value == 10)
                [_playerCard3Image setImage: [UIImage imageNamed:@"fire_10"]];
            else if(card3.value == 11)
                [_playerCard3Image setImage: [UIImage imageNamed:@"fire_11"]];
            else if(card3.value == 12)
                [_playerCard3Image setImage: [UIImage imageNamed:@"fire_12"]];}
        else if(card3.element == 1){
            if(card3.value == 1)
                [_playerCard3Image setImage: [UIImage imageNamed:@"earth_01"]];
            else if(card3.value == 2)
                [_playerCard3Image setImage: [UIImage imageNamed:@"earth_02"]];
            else if(card3.value == 3)
                [_playerCard3Image setImage: [UIImage imageNamed:@"earth_03"]];
            else if(card3.value == 4)
                [_playerCard3Image setImage: [UIImage imageNamed:@"earth_04"]];
            else if(card3.value == 5)
                [_playerCard3Image setImage: [UIImage imageNamed:@"earth_05"]];
            else if(card3.value == 6)
                [_playerCard3Image setImage: [UIImage imageNamed:@"earth_06"]];
            else if(card3.value == 7)
                [_playerCard3Image setImage: [UIImage imageNamed:@"earth_07"]];
            else if(card3.value == 8)
                [_playerCard3Image setImage: [UIImage imageNamed:@"earth_08"]];
            else if(card3.value == 9)
                [_playerCard3Image setImage: [UIImage imageNamed:@"earth_09"]];
            else if(card3.value == 10)
                [_playerCard3Image setImage: [UIImage imageNamed:@"earth_10"]];
            else if(card3.value == 11)
                [_playerCard3Image setImage: [UIImage imageNamed:@"earth_11"]];
            else if(card3.value == 12)
                [_playerCard3Image setImage: [UIImage imageNamed:@"earth_12"]];}
        else if(card3.element == 2){
            if(card3.value == 1)
                [_playerCard3Image setImage: [UIImage imageNamed:@"water_01"]];
            else if(card3.value == 2)
                [_playerCard3Image setImage: [UIImage imageNamed:@"water_02"]];
            else if(card3.value == 3)
                [_playerCard3Image setImage: [UIImage imageNamed:@"water_03"]];
            else if(card3.value == 4)
                [_playerCard3Image setImage: [UIImage imageNamed:@"water_04"]];
            else if(card3.value == 5)
                [_playerCard3Image setImage: [UIImage imageNamed:@"water_05"]];
            else if(card3.value == 6)
                [_playerCard3Image setImage: [UIImage imageNamed:@"water_06"]];
            else if(card3.value == 7)
                [_playerCard3Image setImage: [UIImage imageNamed:@"water_07"]];
            else if(card3.value == 8)
                [_playerCard3Image setImage: [UIImage imageNamed:@"water_08"]];
            else if(card3.value == 9)
                [_playerCard3Image setImage: [UIImage imageNamed:@"water_09"]];
            else if(card3.value == 10)
                [_playerCard3Image setImage: [UIImage imageNamed:@"water_10"]];
            else if(card3.value == 11)
                [_playerCard3Image setImage: [UIImage imageNamed:@"water_11"]];
            else if(card3.value == 12)
                [_playerCard3Image setImage: [UIImage imageNamed:@"water_12"]];}
        else if(card3.element == 3){
            if(card3.value == 1)
                [_playerCard3Image setImage: [UIImage imageNamed:@"air_01"]];
            else if(card3.value == 2)
                [_playerCard3Image setImage: [UIImage imageNamed:@"air_02"]];
            else if(card3.value == 3)
                [_playerCard3Image setImage: [UIImage imageNamed:@"air_03"]];
            else if(card3.value == 4)
                [_playerCard3Image setImage: [UIImage imageNamed:@"air_04"]];
            else if(card3.value == 5)
                [_playerCard3Image setImage: [UIImage imageNamed:@"air_05"]];
            else if(card3.value == 6)
                [_playerCard3Image setImage: [UIImage imageNamed:@"air_06"]];
            else if(card3.value == 7)
                [_playerCard3Image setImage: [UIImage imageNamed:@"air_07"]];
            else if(card3.value == 8)
                [_playerCard3Image setImage: [UIImage imageNamed:@"air_08"]];
            else if(card3.value == 9)
                [_playerCard3Image setImage: [UIImage imageNamed:@"air_09"]];
            else if(card3.value == 10)
                [_playerCard3Image setImage: [UIImage imageNamed:@"air_10"]];
            else if(card3.value == 11)
                [_playerCard3Image setImage: [UIImage imageNamed:@"air_11"]];
            else if(card3.value == 12)
                [_playerCard3Image setImage: [UIImage imageNamed:@"air_12"]];}
    }
    
}

-(void)checkForWar:(id)pressedButton{

    UIButton *button = (UIButton*)pressedButton;

    //add top card from aiStack to inPlay and remove
    if([aiStack lastObject] != nil){
        [inPlay insertObject:[aiStack lastObject] atIndex:AICARD];}
    [aiStack removeLastObject];
    
    //add selected card from playerHand to inPlay and remove
    if([playerHand objectAtIndex:button.tag] != nil){
    [inPlay insertObject:[playerHand objectAtIndex:button.tag] atIndex:PLAYERCARD];
        [playerHand replaceObjectAtIndex:button.tag withObject:emptyArray];}
    
    
  //  [button setTitle:@"EMPTY" forState:UIControlStateNormal];
    
      //DISAPPEAR CARD FROM HAND AFTER PLAYED
    
    if(button == _playerCard1){
               [_playerCard1Image setImage: [UIImage imageNamed:@"0emptycard"]];
    }
    else if(button == _playerCard2){
    [_playerCard2Image setImage: [UIImage imageNamed:@"0emptycard"]];    }
    else if(button == _playerCard3)
    {
        [_playerCard3Image setImage: [UIImage imageNamed:@"0emptycard"]];
    }
    
    
    //disable all the cards
    [self.playerCard1 setEnabled:false];
    [self.playerCard2 setEnabled:false];
    [self.playerCard3 setEnabled:false];
    
    //check for War Conditions & add cards to Stacks
    Card *cardAi = [inPlay objectAtIndex:AICARD];
    Card *cardPlayer = [inPlay objectAtIndex:PLAYERCARD];
    
    [self checkWinner:cardAi :cardPlayer];
    
}


-(void)checkWinner:(Card*)cardAi : (Card*)cardPlayer{
    

    int cardAiTotal = cardAi.value;
    int cardPlayerTotal = cardPlayer.value;
    
    //check if Power Up 2 Negate the Elements is active or not to check the Bonuses
    NSLog(@"*-*-*-*-*-*-*-*-*-*-*");

    if (!pu2NegateElementsInt) {
        
        //check Elemental Bonuses
        switch ([cardAi element]) {
            case elementFire:{
                NSLog(@"0. FIRE");
                if (cardPlayer.element == elementEarth){
                    cardAiTotal += ELEMENTBONUS;
                    [_aiBonusLabel setAlpha:0.0f];  //set the animation for the bonus label.
                    [UIView animateWithDuration:2.0f animations:^{
                        [_aiBonusLabel setAlpha:1.0f];
                    }];
                    _aiBonusLabel.text = @"CPU Element Bonus!";  //change elemental bonus label text.
                    _aiBonusLabel.hidden = false;  //make elemental bonus label visible.
                }
                if (cardPlayer.element == elementWater) {
                    
                    cardAiTotal -= ELEMENTBONUS;
                    [_playerBonusLabel setAlpha:0.0f];  //set animation for bonus label.
                    [UIView animateWithDuration:2.0f animations:^{
                        [_playerBonusLabel setAlpha:1.0f];
                    }];
                    _playerBonusLabel.text = @"Player 1 Element Bonus!";  //change elemental bonus text.
                    _playerBonusLabel.hidden = false;} //make element bonus label visible.
            }
                break;
            case elementEarth:{
                NSLog(@"1. EARTH");
                if (cardPlayer.element == elementWind)
                {cardAiTotal += ELEMENTBONUS;
                    [_aiBonusLabel setAlpha:0.0f];  //set animation for bonus label.
                    [UIView animateWithDuration:2.0f animations:^{
                        [_aiBonusLabel setAlpha:1.0f];
                    }];
                    _aiBonusLabel.text = @"CPU Element Bonus!";  //set bonus label text
                    _aiBonusLabel.hidden = false;                  } //show bonus label
                if (cardPlayer.element == elementFire){
                    cardAiTotal -= ELEMENTBONUS;
                    [_playerBonusLabel setAlpha:0.0f];  //animate bonus label
                    [UIView animateWithDuration:2.0f animations:^{
                        [_playerBonusLabel setAlpha:1.0f];
                    }];
                    _playerBonusLabel.text = @"Player 1 Element Bonus!";  //set text of bonus label
                    _playerBonusLabel.hidden = false;                }  //show bonus label
            }
                break;
            case elementWater:{
                NSLog(@"2. WATER");
                if (cardPlayer.element == elementFire){ cardAiTotal += ELEMENTBONUS;
                    [_aiBonusLabel setAlpha:0.0f];  //animate bonus label
                    [UIView animateWithDuration:2.0f animations:^{
                        [_aiBonusLabel setAlpha:1.0f];
                    }];
                    _aiBonusLabel.text = @"CPU Element Bonus";  //set text of bonus label
                    _aiBonusLabel.hidden = false;                }  //show bonus label
                if (cardPlayer.element == elementWind) {cardAiTotal -= ELEMENTBONUS;
                    [_playerBonusLabel setAlpha:0.0f]; //animate bonus label
                    [UIView animateWithDuration:2.0f animations:^{
                        [_playerBonusLabel setAlpha:1.0f];
                    }];
                    _playerBonusLabel.text = @"Player 1 Element Bonus";  //set text of bonus label
                    _playerBonusLabel.hidden = false;                } //show bonus label
            }
                break;
            case elementWind:{
                NSLog(@"3. WIND");
                if (cardPlayer.element == elementWater){ cardAiTotal += ELEMENTBONUS;
                    [_aiBonusLabel setAlpha:0.0f];  //animate bonus label
                    [UIView animateWithDuration:2.0f animations:^{
                        [_aiBonusLabel setAlpha:1.0f];
                    }];
                    _aiBonusLabel.text = @"CPU Element Bonus";  //set bonus label text
                    _aiBonusLabel.hidden = false;                } //show bonus label
                if (cardPlayer.element == elementEarth){ cardAiTotal -= ELEMENTBONUS;
                    [_playerBonusLabel setAlpha:0.0f];  //animate bonus label
                    [UIView animateWithDuration:2.0f animations:^{
                        [_playerBonusLabel setAlpha:1.0f];
                    }];
                    
                    _playerBonusLabel.text = @"Player 1 Element Bonus"; //set bonus label text
                    _playerBonusLabel.hidden = false;                } //show bonus label
            }
                break;
                break;    //maybe an extra break? Please check.
            default:
                NSLog(@"Something really wrong happened");
                break;
        }
    } //end of if for the pu2ElementsInt
    else{ //disable negate elements after it is used.
        NSLog(@"Negate Elements ON");
        pu2NegateElementsInt = off;
        _powerUp2NegateElementsOutlet.enabled = false;
        [self.powerUp2Image setImage: [UIImage imageNamed:@"PU_NE_used"]]; //change to used image for negateelements
    }
    
    
    

    
    //Small Package PowerUp Inverts the values so the smaller will win
    if (pu1SmallPackageInt) {
        NSLog(@"Small Package value change activated");
        int temp;
        temp = cardPlayerTotal;
        cardPlayerTotal = cardAiTotal;
        cardAiTotal = temp;
        pu1SmallPackageInt = off;
        _powerUp1SmallPackageButtonOutlet.enabled = false;
        [self.powerUp1Image setImage: [UIImage imageNamed:@"PU_SP_used"]];
    }
    
//    ******TROUBLESHOOTING MODE******
//    Making all AI WIN all the time
//    ******TROUBLESHOOTING MODE******
//    cardAiTotal += 100;
//    ******TROUBLESHOOTING MODE******
//    Making all AI WIN all the time
//    ******TROUBLESHOOTING MODE******
    
    
 
    
    
    //WAR RESULTS AFTER BONUSES:
    NSLog(@"card AI total: %d", cardAiTotal);
    NSLog(@"card Player total: %d", cardPlayerTotal);

    
    //Who won and what to do with the inPlay Cards:
    if (cardAiTotal > cardPlayerTotal){ //ai Wins
        NSLog(@"-> AI Wins");
        [_handWinnerLabel setAlpha:0.0f];
        [UIView animateWithDuration:2.0f animations:^{
            [_handWinnerLabel setAlpha:1.0f];
        }];
        _handWinnerLabel.text = @"CPU wins!";  //set text for hand winner label
        _handWinnerLabel.hidden = false;  //show hand winner label
        [_aiDiscardPileImage setImage:_aiCardInPlayImage.image];
        [_playerCardInPlayImage setImage: [UIImage imageNamed:@"0emptycard"]];  //reset in play card images
        [_aiCardInPlayImage setImage: [UIImage imageNamed:@"0emptycard"]];
        [aiDiscardPile addObjectsFromArray:inPlay];
    }else if (cardAiTotal < cardPlayerTotal){//Player Wins
        NSLog(@"-> PLAYER Wins");
        [_handWinnerLabel setAlpha:0.0f];
        [UIView animateWithDuration:2.0f animations:^{
            [_handWinnerLabel setAlpha:1.0f];
        }];
        _handWinnerLabel.text = @"Player 1 wins!";  //set text for hand winner label
        _handWinnerLabel.hidden = false;  //show hand winner label
        [_playerDiscardPileImage setImage:_playerCardInPlayImage.image];
        [_playerCardInPlayImage setImage: [UIImage imageNamed:@"0emptycard"]];
        [_aiCardInPlayImage setImage: [UIImage imageNamed:@"0emptycard"]];
        [playerDiscardPile addObjectsFromArray:inPlay];   }else
            
        {//WAR
            [self war];        }

    
    
    
    
}

-(void) war{
    
    _handWinnerLabel.text = @"War!!!";
    _handWinnerLabel.hidden = false;
    _aiBonusLabel.hidden = true;  //hide the bonus labels
    _playerBonusLabel.hidden = true;
    
    [self checkForGameOver];
    //fill player stack if not enough cards for 2-card war
    if (playerStack.count < 2 && playerDiscardPile > 0) {
        for(int i=0; i<playerDiscardPile.count; i++){
            [playerStack addObject:[playerDiscardPile lastObject]];
            [playerDiscardPile removeLastObject];}
    }
    //do the same for the AI stack
    if (aiStack.count < 2 && aiDiscardPile.count >0) {
        for(int i=0; i<aiDiscardPile.count; i++){
            [aiStack addObject:[aiDiscardPile lastObject]];
            [aiDiscardPile removeLastObject];
        }
            NSLog(@"end of ai Stack");
        }        //indicate the war happened
    if(aiStack.count >= 2 && playerStack.count >= 2)
    {
    [self.warLabel setText:@"WAR!!!"];
    
    //get 2 cards from ai Stack
    for (int i=0; i<2; i++) {
        [inPlay addObject:[aiStack lastObject]];
        [aiStack removeLastObject];
    }
    Card *cardAi = [inPlay lastObject];  //set the card that is going to be compared.
    [_warAiTopCard setAlpha:0.0f];  //set the animation for the war card.
    [UIView animateWithDuration:2.0f animations:^{
        [_warAiTopCard setAlpha:1.0f];
    }];
    if(cardAi.element == 0){  //set the image for the AI's war card.
        if(cardAi.value == 1)
            [_warAiTopCard setImage: [UIImage imageNamed:@"fire_01"]];
        else if(cardAi.value == 2)
            [_warAiTopCard setImage: [UIImage imageNamed:@"fire_02"]];
        else if(cardAi.value == 3)
            [_warAiTopCard setImage: [UIImage imageNamed:@"fire_03"]];
        else if(cardAi.value == 4)
            [_warAiTopCard setImage: [UIImage imageNamed:@"fire_04"]];
        else if(cardAi.value == 5)
            [_warAiTopCard setImage: [UIImage imageNamed:@"fire_05"]];
        else if(cardAi.value == 6)
            [_warAiTopCard setImage: [UIImage imageNamed:@"fire_06"]];
        else if(cardAi.value == 7)
            [_warAiTopCard setImage: [UIImage imageNamed:@"fire_07"]];
        else if(cardAi.value == 8)
            [_warAiTopCard setImage: [UIImage imageNamed:@"fire_08"]];
        else if(cardAi.value == 9)
            [_warAiTopCard setImage: [UIImage imageNamed:@"fire_09"]];
        else if(cardAi.value == 10)
            [_warAiTopCard setImage: [UIImage imageNamed:@"fire_10"]];
        else if(cardAi.value == 11)
            [_warAiTopCard setImage: [UIImage imageNamed:@"fire_11"]];
        else if(cardAi.value == 12)
            [_warAiTopCard setImage: [UIImage imageNamed:@"fire_12"]];}
    else if(cardAi.element == 1){
        if(cardAi.value == 1)
            [_warAiTopCard setImage: [UIImage imageNamed:@"earth_01"]];
        else if(cardAi.value == 2)
            [_warAiTopCard setImage: [UIImage imageNamed:@"earth_02"]];
        else if(cardAi.value == 3)
            [_warAiTopCard setImage: [UIImage imageNamed:@"earth_03"]];
        else if(cardAi.value == 4)
            [_warAiTopCard setImage: [UIImage imageNamed:@"earth_04"]];
        else if(cardAi.value == 5)
            [_warAiTopCard setImage: [UIImage imageNamed:@"earth_05"]];
        else if(cardAi.value == 6)
            [_warAiTopCard setImage: [UIImage imageNamed:@"earth_06"]];
        else if(cardAi.value == 7)
            [_warAiTopCard setImage: [UIImage imageNamed:@"earth_07"]];
        else if(cardAi.value == 8)
            [_warAiTopCard setImage: [UIImage imageNamed:@"earth_08"]];
        else if(cardAi.value == 9)
            [_warAiTopCard setImage: [UIImage imageNamed:@"earth_09"]];
        else if(cardAi.value == 10)
            [_warAiTopCard setImage: [UIImage imageNamed:@"earth_10"]];
        else if(cardAi.value == 11)
            [_warAiTopCard setImage: [UIImage imageNamed:@"earth_11"]];
        else if(cardAi.value == 12)
            [_warAiTopCard setImage: [UIImage imageNamed:@"earth_12"]];}
    else if(cardAi.element == 2){
        if(cardAi.value == 1)
            [_warAiTopCard setImage: [UIImage imageNamed:@"water_01"]];
        else if(cardAi.value == 2)
            [_warAiTopCard setImage: [UIImage imageNamed:@"water_02"]];
        else if(cardAi.value == 3)
            [_warAiTopCard setImage: [UIImage imageNamed:@"water_03"]];
        else if(cardAi.value == 4)
            [_warAiTopCard setImage: [UIImage imageNamed:@"water_04"]];
        else if(cardAi.value == 5)
            [_warAiTopCard setImage: [UIImage imageNamed:@"water_05"]];
        else if(cardAi.value == 6)
            [_warAiTopCard setImage: [UIImage imageNamed:@"water_06"]];
        else if(cardAi.value == 7)
            [_warAiTopCard setImage: [UIImage imageNamed:@"water_07"]];
        else if(cardAi.value == 8)
            [_warAiTopCard setImage: [UIImage imageNamed:@"water_08"]];
        else if(cardAi.value == 9)
            [_warAiTopCard setImage: [UIImage imageNamed:@"water_09"]];
        else if(cardAi.value == 10)
            [_warAiTopCard setImage: [UIImage imageNamed:@"water_10"]];
        else if(cardAi.value == 11)
            [_warAiTopCard setImage: [UIImage imageNamed:@"water_11"]];
        else if(cardAi.value == 12)
            [_warAiTopCard setImage: [UIImage imageNamed:@"water_12"]];}
    else if(cardAi.element == 3){
        if(cardAi.value == 1)
            [_warAiTopCard setImage: [UIImage imageNamed:@"air_01"]];
        else if(cardAi.value == 2)
            [_warAiTopCard setImage: [UIImage imageNamed:@"air_02"]];
        else if(cardAi.value == 3)
            [_warAiTopCard setImage: [UIImage imageNamed:@"air_03"]];
        else if(cardAi.value == 4)
            [_warAiTopCard setImage: [UIImage imageNamed:@"air_04"]];
        else if(cardAi.value == 5)
            [_warAiTopCard setImage: [UIImage imageNamed:@"air_05"]];
        else if(cardAi.value == 6)
            [_warAiTopCard setImage: [UIImage imageNamed:@"air_06"]];
        else if(cardAi.value == 7)
            [_warAiTopCard setImage: [UIImage imageNamed:@"air_07"]];
        else if(cardAi.value == 8)
            [_warAiTopCard setImage: [UIImage imageNamed:@"air_08"]];
        else if(cardAi.value == 9)
            [_warAiTopCard setImage: [UIImage imageNamed:@"air_09"]];
        else if(cardAi.value == 10)
            [_warAiTopCard setImage: [UIImage imageNamed:@"air_10"]];
        else if(cardAi.value == 11)
            [_warAiTopCard setImage: [UIImage imageNamed:@"air_11"]];
        else if(cardAi.value == 12)
            [_warAiTopCard setImage: [UIImage imageNamed:@"air_12"]];}
    //get 2 cards from Player Stack
    for (int i=0; i<2; i++) {
    //[self checkForGameOver];
    [inPlay addObject:[playerStack lastObject]];
    [playerStack removeLastObject];
    }
    Card *cardPlayer = [inPlay lastObject];
    
    [_warTopCard setAlpha:0.0f];  //set animation for player war card.
    [UIView animateWithDuration:2.0f animations:^{
        [_warTopCard setAlpha:1.0f];
    }];
    if(cardPlayer.element == 0){  //set image for player war card.
        if(cardPlayer.value == 1)
            [_warTopCard setImage: [UIImage imageNamed:@"fire_01"]];
        else if(cardPlayer.value == 2)
            [_warTopCard setImage: [UIImage imageNamed:@"fire_02"]];
        else if(cardPlayer.value == 3)
            [_warTopCard setImage: [UIImage imageNamed:@"fire_03"]];
        else if(cardPlayer.value == 4)
            [_warTopCard setImage: [UIImage imageNamed:@"fire_04"]];
        else if(cardPlayer.value == 5)
            [_warTopCard setImage: [UIImage imageNamed:@"fire_05"]];
        else if(cardPlayer.value == 6)
            [_warTopCard setImage: [UIImage imageNamed:@"fire_06"]];
        else if(cardPlayer.value == 7)
            [_warTopCard setImage: [UIImage imageNamed:@"fire_07"]];
        else if(cardPlayer.value == 8)
            [_warTopCard setImage: [UIImage imageNamed:@"fire_08"]];
        else if(cardPlayer.value == 9)
            [_warTopCard setImage: [UIImage imageNamed:@"fire_09"]];
        else if(cardPlayer.value == 10)
            [_warTopCard setImage: [UIImage imageNamed:@"fire_10"]];
        else if(cardPlayer.value == 11)
            [_warTopCard setImage: [UIImage imageNamed:@"fire_11"]];
        else if(cardPlayer.value == 12)
            [_warTopCard setImage: [UIImage imageNamed:@"fire_12"]];}
    else if(cardPlayer.element == 1){
        if(cardPlayer.value == 1)
            [_warTopCard setImage: [UIImage imageNamed:@"earth_01"]];
        else if(cardPlayer.value == 2)
            [_warTopCard setImage: [UIImage imageNamed:@"earth_02"]];
        else if(cardPlayer.value == 3)
            [_warTopCard setImage: [UIImage imageNamed:@"earth_03"]];
        else if(cardPlayer.value == 4)
            [_warTopCard setImage: [UIImage imageNamed:@"earth_04"]];
        else if(cardPlayer.value == 5)
            [_warTopCard setImage: [UIImage imageNamed:@"earth_05"]];
        else if(cardPlayer.value == 6)
            [_warTopCard setImage: [UIImage imageNamed:@"earth_06"]];
        else if(cardPlayer.value == 7)
            [_warTopCard setImage: [UIImage imageNamed:@"earth_07"]];
        else if(cardPlayer.value == 8)
            [_warTopCard setImage: [UIImage imageNamed:@"earth_08"]];
        else if(cardPlayer.value == 9)
            [_warTopCard setImage: [UIImage imageNamed:@"earth_09"]];
        else if(cardPlayer.value == 10)
            [_warTopCard setImage: [UIImage imageNamed:@"earth_10"]];
        else if(cardPlayer.value == 11)
            [_warTopCard setImage: [UIImage imageNamed:@"earth_11"]];
        else if(cardPlayer.value == 12)
            [_warTopCard setImage: [UIImage imageNamed:@"earth_12"]];}
    else if(cardPlayer.element == 2){
        if(cardPlayer.value == 1)
            [_warTopCard setImage: [UIImage imageNamed:@"water_01"]];
        else if(cardPlayer.value == 2)
            [_warTopCard setImage: [UIImage imageNamed:@"water_02"]];
        else if(cardPlayer.value == 3)
            [_warTopCard setImage: [UIImage imageNamed:@"water_03"]];
        else if(cardPlayer.value == 4)
            [_warTopCard setImage: [UIImage imageNamed:@"water_04"]];
        else if(cardPlayer.value == 5)
            [_warTopCard setImage: [UIImage imageNamed:@"water_05"]];
        else if(cardPlayer.value == 6)
            [_warTopCard setImage: [UIImage imageNamed:@"water_06"]];
        else if(cardPlayer.value == 7)
            [_warTopCard setImage: [UIImage imageNamed:@"water_07"]];
        else if(cardPlayer.value == 8)
            [_warTopCard setImage: [UIImage imageNamed:@"water_08"]];
        else if(cardPlayer.value == 9)
            [_warTopCard setImage: [UIImage imageNamed:@"water_09"]];
        else if(cardPlayer.value == 10)
            [_warTopCard setImage: [UIImage imageNamed:@"water_10"]];
        else if(cardPlayer.value == 11)
            [_warTopCard setImage: [UIImage imageNamed:@"water_11"]];
        else if(cardPlayer.value == 12)
            [_warTopCard setImage: [UIImage imageNamed:@"water_12"]];}
    else if(cardPlayer.element == 3){
        if(cardPlayer.value == 1)
            [_warTopCard setImage: [UIImage imageNamed:@"air_01"]];
        else if(cardPlayer.value == 2)
            [_warTopCard setImage: [UIImage imageNamed:@"air_02"]];
        else if(cardPlayer.value == 3)
            [_warTopCard setImage: [UIImage imageNamed:@"air_03"]];
        else if(cardPlayer.value == 4)
            [_warTopCard setImage: [UIImage imageNamed:@"air_04"]];
        else if(cardPlayer.value == 5)
            [_warTopCard setImage: [UIImage imageNamed:@"air_05"]];
        else if(cardPlayer.value == 6)
            [_warTopCard setImage: [UIImage imageNamed:@"air_06"]];
        else if(cardPlayer.value == 7)
            [_warTopCard setImage: [UIImage imageNamed:@"air_07"]];
        else if(cardPlayer.value == 8)
            [_warTopCard setImage: [UIImage imageNamed:@"air_08"]];
        else if(cardPlayer.value == 9)
            [_warTopCard setImage: [UIImage imageNamed:@"air_09"]];
        else if(cardPlayer.value == 10)
            [_warTopCard setImage: [UIImage imageNamed:@"air_10"]];
        else if(cardPlayer.value == 11)
            [_warTopCard setImage: [UIImage imageNamed:@"air_11"]];
        else if(cardPlayer.value == 12)
            [_warTopCard setImage: [UIImage imageNamed:@"air_12"]];}
    
    _warTopCard.hidden = false; //show the war cards.
    _warBottomCard.hidden = false;
    _warAiTopCard.hidden = false;
        _warAiBottomCard.hidden = false;
    
    //print labels
     [self.aiCardWarLabel setText:[NSString stringWithFormat:@"%d of %d", cardAi.value, cardAi.element]];
     [self.playerCardWarLabel setText:[NSString stringWithFormat:@"%d of %d", cardPlayer.value, cardPlayer.element]];

    //check for winner or War
    [self checkWinner:cardAi :cardPlayer];
    }
    else if(aiStack.count >= 2 && ((playerStack.count == 0 && (([[playerHand objectAtIndex:0] isMemberOfClass:[Card class]] && [[playerHand objectAtIndex:1] isMemberOfClass:[Card class]]) || ([[playerHand objectAtIndex:0] isMemberOfClass:[Card class]] && [[playerHand objectAtIndex:2] isMemberOfClass:[Card class]]) || ([[playerHand objectAtIndex:1] isMemberOfClass:[Card class]] && [[playerHand objectAtIndex:2] isMemberOfClass:[Card class]]))))){    //if ai stack is greater than or equal to two and player stack is zero, but there are at least two cards in the player hand.
        [self.warLabel setText:@"WAR!!!"];
        
        //get 2 cards from ai Stack
        for (int i=0; i<2; i++) {
            [self checkForGameOver];
            [inPlay addObject:[aiStack lastObject]];
            [aiStack removeLastObject];
        }
        Card *cardAi = [inPlay lastObject];
        [_warAiTopCard setAlpha:0.0f];  //animate the AI war card.
        [UIView animateWithDuration:2.0f animations:^{
            [_warAiTopCard setAlpha:1.0f];
        }];
        if(cardAi.element == 0){  //set image for AI War top card.
            if(cardAi.value == 1)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_01"]];
            else if(cardAi.value == 2)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_02"]];
            else if(cardAi.value == 3)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_03"]];
            else if(cardAi.value == 4)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_04"]];
            else if(cardAi.value == 5)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_05"]];
            else if(cardAi.value == 6)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_06"]];
            else if(cardAi.value == 7)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_07"]];
            else if(cardAi.value == 8)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_08"]];
            else if(cardAi.value == 9)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_09"]];
            else if(cardAi.value == 10)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_10"]];
            else if(cardAi.value == 11)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_11"]];
            else if(cardAi.value == 12)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_12"]];}
        else if(cardAi.element == 1){
            if(cardAi.value == 1)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_01"]];
            else if(cardAi.value == 2)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_02"]];
            else if(cardAi.value == 3)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_03"]];
            else if(cardAi.value == 4)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_04"]];
            else if(cardAi.value == 5)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_05"]];
            else if(cardAi.value == 6)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_06"]];
            else if(cardAi.value == 7)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_07"]];
            else if(cardAi.value == 8)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_08"]];
            else if(cardAi.value == 9)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_09"]];
            else if(cardAi.value == 10)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_10"]];
            else if(cardAi.value == 11)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_11"]];
            else if(cardAi.value == 12)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_12"]];}
        else if(cardAi.element == 2){
            if(cardAi.value == 1)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_01"]];
            else if(cardAi.value == 2)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_02"]];
            else if(cardAi.value == 3)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_03"]];
            else if(cardAi.value == 4)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_04"]];
            else if(cardAi.value == 5)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_05"]];
            else if(cardAi.value == 6)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_06"]];
            else if(cardAi.value == 7)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_07"]];
            else if(cardAi.value == 8)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_08"]];
            else if(cardAi.value == 9)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_09"]];
            else if(cardAi.value == 10)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_10"]];
            else if(cardAi.value == 11)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_11"]];
            else if(cardAi.value == 12)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_12"]];}
        else if(cardAi.element == 3){
            if(cardAi.value == 1)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_01"]];
            else if(cardAi.value == 2)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_02"]];
            else if(cardAi.value == 3)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_03"]];
            else if(cardAi.value == 4)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_04"]];
            else if(cardAi.value == 5)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_05"]];
            else if(cardAi.value == 6)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_06"]];
            else if(cardAi.value == 7)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_07"]];
            else if(cardAi.value == 8)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_08"]];
            else if(cardAi.value == 9)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_09"]];
            else if(cardAi.value == 10)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_10"]];
            else if(cardAi.value == 11)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_11"]];
            else if(cardAi.value == 12)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_12"]];}
        
       // [self checkForGameOver];
        [inPlay addObject:[playerStack lastObject]];  //add a card from player stack.
        [playerStack removeLastObject];
        if(([[playerHand objectAtIndex:2] isMemberOfClass:[Card class]]) && ([[playerHand objectAtIndex:1] isMemberOfClass:[Card class]]))  //check which positions the player hand has another card.
        {
            
            [inPlay addObject:[playerHand objectAtIndex:2]];  //add another card from the player hand to in play.
            [playerHand removeObjectAtIndex:2];
            [inPlay addObject:[playerHand objectAtIndex:1]];
            [playerHand removeObjectAtIndex:1];
        }
        else if(([[playerHand objectAtIndex:2] isMemberOfClass:[Card class]]) && ([[playerHand objectAtIndex:0] isMemberOfClass:[Card class]]))
        {
            
            [inPlay addObject:[playerHand objectAtIndex:2]];
            [playerHand removeObjectAtIndex:2];
            [inPlay addObject:[playerHand objectAtIndex:0]];
            [playerHand removeObjectAtIndex:0];
        }
        else if(([[playerHand objectAtIndex:1] isMemberOfClass:[Card class]]) && ([[playerHand objectAtIndex:0] isMemberOfClass:[Card class]]))
        {
            
            [inPlay addObject:[playerHand objectAtIndex:1]];
            [playerHand removeObjectAtIndex:1];
            [inPlay addObject:[playerHand objectAtIndex:0]];
            [playerHand removeObjectAtIndex:0];
        }
        
        Card *cardPlayer = [inPlay lastObject];
        
        [_warTopCard setAlpha:0.0f];  //animate the player war card.
        [UIView animateWithDuration:2.0f animations:^{
            [_warTopCard setAlpha:1.0f];
        }];
        if(cardPlayer.element == 0){  //set image of the player war card.
            if(cardPlayer.value == 1)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_01"]];
            else if(cardPlayer.value == 2)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_02"]];
            else if(cardPlayer.value == 3)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_03"]];
            else if(cardPlayer.value == 4)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_04"]];
            else if(cardPlayer.value == 5)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_05"]];
            else if(cardPlayer.value == 6)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_06"]];
            else if(cardPlayer.value == 7)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_07"]];
            else if(cardPlayer.value == 8)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_08"]];
            else if(cardPlayer.value == 9)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_09"]];
            else if(cardPlayer.value == 10)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_10"]];
            else if(cardPlayer.value == 11)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_11"]];
            else if(cardPlayer.value == 12)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_12"]];}
        else if(cardPlayer.element == 1){
            if(cardPlayer.value == 1)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_01"]];
            else if(cardPlayer.value == 2)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_02"]];
            else if(cardPlayer.value == 3)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_03"]];
            else if(cardPlayer.value == 4)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_04"]];
            else if(cardPlayer.value == 5)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_05"]];
            else if(cardPlayer.value == 6)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_06"]];
            else if(cardPlayer.value == 7)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_07"]];
            else if(cardPlayer.value == 8)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_08"]];
            else if(cardPlayer.value == 9)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_09"]];
            else if(cardPlayer.value == 10)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_10"]];
            else if(cardPlayer.value == 11)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_11"]];
            else if(cardPlayer.value == 12)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_12"]];}
        else if(cardPlayer.element == 2){
            if(cardPlayer.value == 1)
                [_warTopCard setImage: [UIImage imageNamed:@"water_01"]];
            else if(cardPlayer.value == 2)
                [_warTopCard setImage: [UIImage imageNamed:@"water_02"]];
            else if(cardPlayer.value == 3)
                [_warTopCard setImage: [UIImage imageNamed:@"water_03"]];
            else if(cardPlayer.value == 4)
                [_warTopCard setImage: [UIImage imageNamed:@"water_04"]];
            else if(cardPlayer.value == 5)
                [_warTopCard setImage: [UIImage imageNamed:@"water_05"]];
            else if(cardPlayer.value == 6)
                [_warTopCard setImage: [UIImage imageNamed:@"water_06"]];
            else if(cardPlayer.value == 7)
                [_warTopCard setImage: [UIImage imageNamed:@"water_07"]];
            else if(cardPlayer.value == 8)
                [_warTopCard setImage: [UIImage imageNamed:@"water_08"]];
            else if(cardPlayer.value == 9)
                [_warTopCard setImage: [UIImage imageNamed:@"water_09"]];
            else if(cardPlayer.value == 10)
                [_warTopCard setImage: [UIImage imageNamed:@"water_10"]];
            else if(cardPlayer.value == 11)
                [_warTopCard setImage: [UIImage imageNamed:@"water_11"]];
            else if(cardPlayer.value == 12)
                [_warTopCard setImage: [UIImage imageNamed:@"water_12"]];}
        else if(cardPlayer.element == 3){
            if(cardPlayer.value == 1)
                [_warTopCard setImage: [UIImage imageNamed:@"air_01"]];
            else if(cardPlayer.value == 2)
                [_warTopCard setImage: [UIImage imageNamed:@"air_02"]];
            else if(cardPlayer.value == 3)
                [_warTopCard setImage: [UIImage imageNamed:@"air_03"]];
            else if(cardPlayer.value == 4)
                [_warTopCard setImage: [UIImage imageNamed:@"air_04"]];
            else if(cardPlayer.value == 5)
                [_warTopCard setImage: [UIImage imageNamed:@"air_05"]];
            else if(cardPlayer.value == 6)
                [_warTopCard setImage: [UIImage imageNamed:@"air_06"]];
            else if(cardPlayer.value == 7)
                [_warTopCard setImage: [UIImage imageNamed:@"air_07"]];
            else if(cardPlayer.value == 8)
                [_warTopCard setImage: [UIImage imageNamed:@"air_08"]];
            else if(cardPlayer.value == 9)
                [_warTopCard setImage: [UIImage imageNamed:@"air_09"]];
            else if(cardPlayer.value == 10)
                [_warTopCard setImage: [UIImage imageNamed:@"air_10"]];
            else if(cardPlayer.value == 11)
                [_warTopCard setImage: [UIImage imageNamed:@"air_11"]];
            else if(cardPlayer.value == 12)
                [_warTopCard setImage: [UIImage imageNamed:@"air_12"]];}
        
        _warTopCard.hidden = false;  //show the 4 war cards (2 for human and 2 for CPU, one face up and one face down.
        _warBottomCard.hidden = false;
        _warAiTopCard.hidden = false;
        _warAiBottomCard.hidden = false;
        
        //print labels
        [self.aiCardWarLabel setText:[NSString stringWithFormat:@"%d of %d", cardAi.value, cardAi.element]];
        [self.playerCardWarLabel setText:[NSString stringWithFormat:@"%d of %d", cardPlayer.value, cardPlayer.element]];
        
        //check for winner or War
        [self checkWinner:cardAi :cardPlayer];
    }
    else if(aiStack.count == 1 && (playerStack.count >=1 || ((playerStack.count == 0) && ([[playerHand objectAtIndex:1] isMemberOfClass:[Card class]])) || ((playerStack.count == 0) && ([[playerHand objectAtIndex:0] isMemberOfClass:[Card class]])) || ((playerStack.count == 0) && ([[playerHand objectAtIndex:2] isMemberOfClass:[Card class]])))){  //ai is down to its last card and player has at least 1 card
        [self.warLabel setText:@"WAR!!!"];
        
        //get 1 card from ai Stack
        
            [self checkForGameOver];
            [inPlay addObject:[aiStack lastObject]];
            [aiStack removeLastObject];
        
        Card *cardAi = [inPlay lastObject];
        [_warAiTopCard setAlpha:0.0f];  //animate the AI war card
        [UIView animateWithDuration:2.0f animations:^{
            [_warAiTopCard setAlpha:1.0f];
        }];
        if(cardAi.element == 0){  //set image of the AI war card.
            if(cardAi.value == 1)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_01"]];
            else if(cardAi.value == 2)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_02"]];
            else if(cardAi.value == 3)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_03"]];
            else if(cardAi.value == 4)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_04"]];
            else if(cardAi.value == 5)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_05"]];
            else if(cardAi.value == 6)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_06"]];
            else if(cardAi.value == 7)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_07"]];
            else if(cardAi.value == 8)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_08"]];
            else if(cardAi.value == 9)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_09"]];
            else if(cardAi.value == 10)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_10"]];
            else if(cardAi.value == 11)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_11"]];
            else if(cardAi.value == 12)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_12"]];}
        else if(cardAi.element == 1){
            if(cardAi.value == 1)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_01"]];
            else if(cardAi.value == 2)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_02"]];
            else if(cardAi.value == 3)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_03"]];
            else if(cardAi.value == 4)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_04"]];
            else if(cardAi.value == 5)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_05"]];
            else if(cardAi.value == 6)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_06"]];
            else if(cardAi.value == 7)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_07"]];
            else if(cardAi.value == 8)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_08"]];
            else if(cardAi.value == 9)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_09"]];
            else if(cardAi.value == 10)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_10"]];
            else if(cardAi.value == 11)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_11"]];
            else if(cardAi.value == 12)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_12"]];}
        else if(cardAi.element == 2){
            if(cardAi.value == 1)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_01"]];
            else if(cardAi.value == 2)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_02"]];
            else if(cardAi.value == 3)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_03"]];
            else if(cardAi.value == 4)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_04"]];
            else if(cardAi.value == 5)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_05"]];
            else if(cardAi.value == 6)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_06"]];
            else if(cardAi.value == 7)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_07"]];
            else if(cardAi.value == 8)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_08"]];
            else if(cardAi.value == 9)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_09"]];
            else if(cardAi.value == 10)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_10"]];
            else if(cardAi.value == 11)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_11"]];
            else if(cardAi.value == 12)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_12"]];}
        else if(cardAi.element == 3){
            if(cardAi.value == 1)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_01"]];
            else if(cardAi.value == 2)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_02"]];
            else if(cardAi.value == 3)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_03"]];
            else if(cardAi.value == 4)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_04"]];
            else if(cardAi.value == 5)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_05"]];
            else if(cardAi.value == 6)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_06"]];
            else if(cardAi.value == 7)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_07"]];
            else if(cardAi.value == 8)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_08"]];
            else if(cardAi.value == 9)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_09"]];
            else if(cardAi.value == 10)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_10"]];
            else if(cardAi.value == 11)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_11"]];
            else if(cardAi.value == 12)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_12"]];}
        
       // [self checkForGameOver];
        if(playerStack.count ==1){
        [inPlay addObject:[playerStack lastObject]];  //if there's a card on the player stack, add it to in play.
            [playerStack removeLastObject];}
        else if(([[playerHand objectAtIndex:2] isMemberOfClass:[Card class]]))  //if there isn't a card on player stack, add one from player's hand.
        {
            
            [inPlay addObject:[playerHand objectAtIndex:2]];
            [playerHand removeObjectAtIndex:2];
        }
        else if(([[playerHand objectAtIndex:0] isMemberOfClass:[Card class]]))
        {
            [inPlay addObject:[playerHand objectAtIndex:0]];
            [playerHand removeObjectAtIndex:0];
        }
        else if(([[playerHand objectAtIndex:1] isMemberOfClass:[Card class]]))
        {
            
            [inPlay addObject:[playerHand objectAtIndex:1]];
            [playerHand removeObjectAtIndex:1];
        }
        
        Card *cardPlayer = [inPlay lastObject];
        
        [_warTopCard setAlpha:0.0f];  //set animation for player war card
        [UIView animateWithDuration:2.0f animations:^{
            [_warTopCard setAlpha:1.0f];
        }];
        if(cardPlayer.element == 0){  //set image for player war card.
            if(cardPlayer.value == 1)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_01"]];
            else if(cardPlayer.value == 2)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_02"]];
            else if(cardPlayer.value == 3)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_03"]];
            else if(cardPlayer.value == 4)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_04"]];
            else if(cardPlayer.value == 5)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_05"]];
            else if(cardPlayer.value == 6)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_06"]];
            else if(cardPlayer.value == 7)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_07"]];
            else if(cardPlayer.value == 8)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_08"]];
            else if(cardPlayer.value == 9)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_09"]];
            else if(cardPlayer.value == 10)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_10"]];
            else if(cardPlayer.value == 11)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_11"]];
            else if(cardPlayer.value == 12)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_12"]];}
        else if(cardPlayer.element == 1){
            if(cardPlayer.value == 1)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_01"]];
            else if(cardPlayer.value == 2)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_02"]];
            else if(cardPlayer.value == 3)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_03"]];
            else if(cardPlayer.value == 4)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_04"]];
            else if(cardPlayer.value == 5)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_05"]];
            else if(cardPlayer.value == 6)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_06"]];
            else if(cardPlayer.value == 7)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_07"]];
            else if(cardPlayer.value == 8)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_08"]];
            else if(cardPlayer.value == 9)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_09"]];
            else if(cardPlayer.value == 10)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_10"]];
            else if(cardPlayer.value == 11)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_11"]];
            else if(cardPlayer.value == 12)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_12"]];}
        else if(cardPlayer.element == 2){
            if(cardPlayer.value == 1)
                [_warTopCard setImage: [UIImage imageNamed:@"water_01"]];
            else if(cardPlayer.value == 2)
                [_warTopCard setImage: [UIImage imageNamed:@"water_02"]];
            else if(cardPlayer.value == 3)
                [_warTopCard setImage: [UIImage imageNamed:@"water_03"]];
            else if(cardPlayer.value == 4)
                [_warTopCard setImage: [UIImage imageNamed:@"water_04"]];
            else if(cardPlayer.value == 5)
                [_warTopCard setImage: [UIImage imageNamed:@"water_05"]];
            else if(cardPlayer.value == 6)
                [_warTopCard setImage: [UIImage imageNamed:@"water_06"]];
            else if(cardPlayer.value == 7)
                [_warTopCard setImage: [UIImage imageNamed:@"water_07"]];
            else if(cardPlayer.value == 8)
                [_warTopCard setImage: [UIImage imageNamed:@"water_08"]];
            else if(cardPlayer.value == 9)
                [_warTopCard setImage: [UIImage imageNamed:@"water_09"]];
            else if(cardPlayer.value == 10)
                [_warTopCard setImage: [UIImage imageNamed:@"water_10"]];
            else if(cardPlayer.value == 11)
                [_warTopCard setImage: [UIImage imageNamed:@"water_11"]];
            else if(cardPlayer.value == 12)
                [_warTopCard setImage: [UIImage imageNamed:@"water_12"]];}
        else if(cardPlayer.element == 3){
            if(cardPlayer.value == 1)
                [_warTopCard setImage: [UIImage imageNamed:@"air_01"]];
            else if(cardPlayer.value == 2)
                [_warTopCard setImage: [UIImage imageNamed:@"air_02"]];
            else if(cardPlayer.value == 3)
                [_warTopCard setImage: [UIImage imageNamed:@"air_03"]];
            else if(cardPlayer.value == 4)
                [_warTopCard setImage: [UIImage imageNamed:@"air_04"]];
            else if(cardPlayer.value == 5)
                [_warTopCard setImage: [UIImage imageNamed:@"air_05"]];
            else if(cardPlayer.value == 6)
                [_warTopCard setImage: [UIImage imageNamed:@"air_06"]];
            else if(cardPlayer.value == 7)
                [_warTopCard setImage: [UIImage imageNamed:@"air_07"]];
            else if(cardPlayer.value == 8)
                [_warTopCard setImage: [UIImage imageNamed:@"air_08"]];
            else if(cardPlayer.value == 9)
                [_warTopCard setImage: [UIImage imageNamed:@"air_09"]];
            else if(cardPlayer.value == 10)
                [_warTopCard setImage: [UIImage imageNamed:@"air_10"]];
            else if(cardPlayer.value == 11)
                [_warTopCard setImage: [UIImage imageNamed:@"air_11"]];
            else if(cardPlayer.value == 12)
                [_warTopCard setImage: [UIImage imageNamed:@"air_12"]];}
        
        _warTopCard.hidden = false;  //show the 1 war card for each player on the screen.
        _warAiTopCard.hidden = false;
        
        //print labels
        [self.aiCardWarLabel setText:[NSString stringWithFormat:@"%d of %d", cardAi.value, cardAi.element]];
        [self.playerCardWarLabel setText:[NSString stringWithFormat:@"%d of %d", cardPlayer.value, cardPlayer.element]];
        
        //check for winner or War
        [self checkWinner:cardAi :cardPlayer];
    }
    else if(aiStack.count >= 1 && (((playerStack.count == 0) && ([[playerHand objectAtIndex:1] isMemberOfClass:[Card class]])) || ((playerStack.count == 0) && ([[playerHand objectAtIndex:0] isMemberOfClass:[Card class]])) || ((playerStack.count == 0) && ([[playerHand objectAtIndex:2] isMemberOfClass:[Card class]])))){//player is down to its last card.
        [self.warLabel setText:@"WAR!!!"];
        
        //get 1 card from ai Stack
        
        // [self checkForGameOver];  Not sure about this.
        [inPlay addObject:[aiStack lastObject]];
        [aiStack removeLastObject];
        
        Card *cardAi = [inPlay lastObject];
        [_warAiTopCard setAlpha:0.0f];  //animate the AI war card.
        [UIView animateWithDuration:2.0f animations:^{
            [_warAiTopCard setAlpha:1.0f];
        }];
        if(cardAi.element == 0){  //set image of AI war card.
            if(cardAi.value == 1)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_01"]];
            else if(cardAi.value == 2)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_02"]];
            else if(cardAi.value == 3)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_03"]];
            else if(cardAi.value == 4)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_04"]];
            else if(cardAi.value == 5)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_05"]];
            else if(cardAi.value == 6)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_06"]];
            else if(cardAi.value == 7)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_07"]];
            else if(cardAi.value == 8)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_08"]];
            else if(cardAi.value == 9)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_09"]];
            else if(cardAi.value == 10)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_10"]];
            else if(cardAi.value == 11)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_11"]];
            else if(cardAi.value == 12)
                [_warAiTopCard setImage: [UIImage imageNamed:@"fire_12"]];}
        else if(cardAi.element == 1){
            if(cardAi.value == 1)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_01"]];
            else if(cardAi.value == 2)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_02"]];
            else if(cardAi.value == 3)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_03"]];
            else if(cardAi.value == 4)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_04"]];
            else if(cardAi.value == 5)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_05"]];
            else if(cardAi.value == 6)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_06"]];
            else if(cardAi.value == 7)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_07"]];
            else if(cardAi.value == 8)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_08"]];
            else if(cardAi.value == 9)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_09"]];
            else if(cardAi.value == 10)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_10"]];
            else if(cardAi.value == 11)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_11"]];
            else if(cardAi.value == 12)
                [_warAiTopCard setImage: [UIImage imageNamed:@"earth_12"]];}
        else if(cardAi.element == 2){
            if(cardAi.value == 1)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_01"]];
            else if(cardAi.value == 2)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_02"]];
            else if(cardAi.value == 3)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_03"]];
            else if(cardAi.value == 4)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_04"]];
            else if(cardAi.value == 5)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_05"]];
            else if(cardAi.value == 6)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_06"]];
            else if(cardAi.value == 7)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_07"]];
            else if(cardAi.value == 8)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_08"]];
            else if(cardAi.value == 9)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_09"]];
            else if(cardAi.value == 10)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_10"]];
            else if(cardAi.value == 11)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_11"]];
            else if(cardAi.value == 12)
                [_warAiTopCard setImage: [UIImage imageNamed:@"water_12"]];}
        else if(cardAi.element == 3){
            if(cardAi.value == 1)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_01"]];
            else if(cardAi.value == 2)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_02"]];
            else if(cardAi.value == 3)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_03"]];
            else if(cardAi.value == 4)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_04"]];
            else if(cardAi.value == 5)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_05"]];
            else if(cardAi.value == 6)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_06"]];
            else if(cardAi.value == 7)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_07"]];
            else if(cardAi.value == 8)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_08"]];
            else if(cardAi.value == 9)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_09"]];
            else if(cardAi.value == 10)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_10"]];
            else if(cardAi.value == 11)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_11"]];
            else if(cardAi.value == 12)
                [_warAiTopCard setImage: [UIImage imageNamed:@"air_12"]];}
        
        // [self checkForGameOver];
        if(playerStack.count ==1){
            [inPlay addObject:[playerStack lastObject]]; //add player card to stack if there's one there.
            [playerStack removeLastObject];}
        else if(([[playerHand objectAtIndex:2] isMemberOfClass:[Card class]]))  //if there isn't a player card at the stack, check each hand position and add a card from the hand.
        {
            
            [inPlay addObject:[playerHand objectAtIndex:2]];
            [playerHand removeObjectAtIndex:2];
        }
        else if(([[playerHand objectAtIndex:0] isMemberOfClass:[Card class]]))
        {
            [inPlay addObject:[playerHand objectAtIndex:0]];
            [playerHand removeObjectAtIndex:0];
        }
        else if(([[playerHand objectAtIndex:1] isMemberOfClass:[Card class]]))
        {
            
            [inPlay addObject:[playerHand objectAtIndex:1]];
            [playerHand removeObjectAtIndex:1];
        }
        
        Card *cardPlayer = [inPlay lastObject];
        
        [_warTopCard setAlpha:0.0f];  //animate the player war card.
        [UIView animateWithDuration:2.0f animations:^{
            [_warTopCard setAlpha:1.0f];
        }];
        if(cardPlayer.element == 0){ //set player war card image.
            if(cardPlayer.value == 1)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_01"]];
            else if(cardPlayer.value == 2)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_02"]];
            else if(cardPlayer.value == 3)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_03"]];
            else if(cardPlayer.value == 4)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_04"]];
            else if(cardPlayer.value == 5)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_05"]];
            else if(cardPlayer.value == 6)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_06"]];
            else if(cardPlayer.value == 7)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_07"]];
            else if(cardPlayer.value == 8)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_08"]];
            else if(cardPlayer.value == 9)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_09"]];
            else if(cardPlayer.value == 10)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_10"]];
            else if(cardPlayer.value == 11)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_11"]];
            else if(cardPlayer.value == 12)
                [_warTopCard setImage: [UIImage imageNamed:@"fire_12"]];}
        else if(cardPlayer.element == 1){
            if(cardPlayer.value == 1)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_01"]];
            else if(cardPlayer.value == 2)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_02"]];
            else if(cardPlayer.value == 3)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_03"]];
            else if(cardPlayer.value == 4)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_04"]];
            else if(cardPlayer.value == 5)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_05"]];
            else if(cardPlayer.value == 6)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_06"]];
            else if(cardPlayer.value == 7)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_07"]];
            else if(cardPlayer.value == 8)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_08"]];
            else if(cardPlayer.value == 9)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_09"]];
            else if(cardPlayer.value == 10)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_10"]];
            else if(cardPlayer.value == 11)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_11"]];
            else if(cardPlayer.value == 12)
                [_warTopCard setImage: [UIImage imageNamed:@"earth_12"]];}
        else if(cardPlayer.element == 2){
            if(cardPlayer.value == 1)
                [_warTopCard setImage: [UIImage imageNamed:@"water_01"]];
            else if(cardPlayer.value == 2)
                [_warTopCard setImage: [UIImage imageNamed:@"water_02"]];
            else if(cardPlayer.value == 3)
                [_warTopCard setImage: [UIImage imageNamed:@"water_03"]];
            else if(cardPlayer.value == 4)
                [_warTopCard setImage: [UIImage imageNamed:@"water_04"]];
            else if(cardPlayer.value == 5)
                [_warTopCard setImage: [UIImage imageNamed:@"water_05"]];
            else if(cardPlayer.value == 6)
                [_warTopCard setImage: [UIImage imageNamed:@"water_06"]];
            else if(cardPlayer.value == 7)
                [_warTopCard setImage: [UIImage imageNamed:@"water_07"]];
            else if(cardPlayer.value == 8)
                [_warTopCard setImage: [UIImage imageNamed:@"water_08"]];
            else if(cardPlayer.value == 9)
                [_warTopCard setImage: [UIImage imageNamed:@"water_09"]];
            else if(cardPlayer.value == 10)
                [_warTopCard setImage: [UIImage imageNamed:@"water_10"]];
            else if(cardPlayer.value == 11)
                [_warTopCard setImage: [UIImage imageNamed:@"water_11"]];
            else if(cardPlayer.value == 12)
                [_warTopCard setImage: [UIImage imageNamed:@"water_12"]];}
        else if(cardPlayer.element == 3){
            if(cardPlayer.value == 1)
                [_warTopCard setImage: [UIImage imageNamed:@"air_01"]];
            else if(cardPlayer.value == 2)
                [_warTopCard setImage: [UIImage imageNamed:@"air_02"]];
            else if(cardPlayer.value == 3)
                [_warTopCard setImage: [UIImage imageNamed:@"air_03"]];
            else if(cardPlayer.value == 4)
                [_warTopCard setImage: [UIImage imageNamed:@"air_04"]];
            else if(cardPlayer.value == 5)
                [_warTopCard setImage: [UIImage imageNamed:@"air_05"]];
            else if(cardPlayer.value == 6)
                [_warTopCard setImage: [UIImage imageNamed:@"air_06"]];
            else if(cardPlayer.value == 7)
                [_warTopCard setImage: [UIImage imageNamed:@"air_07"]];
            else if(cardPlayer.value == 8)
                [_warTopCard setImage: [UIImage imageNamed:@"air_08"]];
            else if(cardPlayer.value == 9)
                [_warTopCard setImage: [UIImage imageNamed:@"air_09"]];
            else if(cardPlayer.value == 10)
                [_warTopCard setImage: [UIImage imageNamed:@"air_10"]];
            else if(cardPlayer.value == 11)
                [_warTopCard setImage: [UIImage imageNamed:@"air_11"]];
            else if(cardPlayer.value == 12)
                [_warTopCard setImage: [UIImage imageNamed:@"air_12"]];}
        
        _warTopCard.hidden = false;  //show war cards on the screen.
        _warAiTopCard.hidden = false;
        
        //print labels
        [self.aiCardWarLabel setText:[NSString stringWithFormat:@"%d of %d", cardAi.value, cardAi.element]];
        [self.playerCardWarLabel setText:[NSString stringWithFormat:@"%d of %d", cardPlayer.value, cardPlayer.element]];
        
        //check for winner or War
        [self checkWinner:cardAi :cardPlayer];
    }
    [self checkForGameOver];
    }
    
    


- (IBAction)powerUp1SmallPackageButton:(id)sender {
    
    //Change War Label
    [self.warLabel setText:@"SmallPackage Activated"];
    
    //CHANGE IMAGE
    [self.powerUp1Image setImage: [UIImage imageNamed:@"PU_SP_active"]];
    
    pu1SmallPackageInt = on;
    [self.powerUp1SmallPackageButtonOutlet setEnabled:false];
    
}
- (IBAction)powerUp2NegateElementsButton:(id)sender {
    //Change War Label
    [self.warLabel setText:@"Negate Elements Activated"];
    
    //CHANGE POWERUP 2 IMAGE
    [self.powerUp2Image setImage: [UIImage imageNamed:@"PU_NE_active"]];
    
    pu2NegateElementsInt = on;
    [self.powerUp2NegateElementsOutlet setEnabled:false];
}



- (IBAction)powerUp3WarMachineButton:(id)sender {
    if(aiStack.count >= 2 && playerStack.count >= 2){
    //Change War Label
    [self.warLabel setText:@"WarMachine Activated"];
    
    [self.powerUp3Image setImage: [UIImage imageNamed:@"PU_WM_active"]];
    
    //get 2 cards from both Stacks
        for (int i=0; i<2; i++) {
        [inPlay addObject:[aiStack lastObject]];
        [aiStack removeLastObject];
        [inPlay addObject:[playerStack lastObject]];
        [playerStack removeLastObject];
        }
    [self.powerUp3WarMachineOutlet setEnabled:false];
    
        [self.powerUp3Image setImage: [UIImage imageNamed:@"PU_WM_used"]];}
    else
        [self.warLabel setText:@"Not enough cards to start war."];
        }



- (IBAction)powerUp4ReconButton:(id)sender {
    
    if (aiStack.count < 3) { //mainly to refill the player stack
        [self checkForGameOver];
    }
    
    NSMutableArray *hand = [[NSMutableArray alloc] init];    //array with number of cards left on the AiStack
    for (NSUInteger y = 0; (int)aiStack.count > y && y < 3; y++) {
        [hand addObject:@(y + 1)];    //add number of cards to the array
    }
    
    int inicitalHandCount = (int)hand.count;

    for (int i = 0; i < inicitalHandCount; i++){
       
        NSInteger index = arc4random() % (NSUInteger)(hand.count);  //random number from hand array
        int object = [(NSNumber *)[hand objectAtIndex:index]intValue]; //assign that number to object
        [hand removeObjectAtIndex:index]; //remove number from hand array
        
        
        
        
        int x = (int)aiStack.count - i -1;  //getting the top cards from the stacks
        Card *card1 = [aiStack objectAtIndex:x];
        switch (object) {  //since object was random it will randomly pick a label to update the AiCard
            case 1:
                [self.aiCardLabel1 setText:[NSString stringWithFormat:@"%d of %d", card1.value, card1.element]];
                if(card1.element == 0){  //set the AI card image if recon is called.
                    if(card1.value == 1)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"fire_01"]];
                    else if(card1.value == 2)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"fire_02"]];
                    else if(card1.value == 3)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"fire_03"]];
                    else if(card1.value == 4)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"fire_04"]];
                    else if(card1.value == 5)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"fire_05"]];
                    else if(card1.value == 6)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"fire_06"]];
                    else if(card1.value == 7)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"fire_07"]];
                    else if(card1.value == 8)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"fire_08"]];
                    else if(card1.value == 9)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"fire_09"]];
                    else if(card1.value == 10)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"fire_10"]];
                    else if(card1.value == 11)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"fire_11"]];
                    else if(card1.value == 12)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"fire_12"]];}
                else if(card1.element == 1){
                    if(card1.value == 1)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"earth_01"]];
                    else if(card1.value == 2)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"earth_02"]];
                    else if(card1.value == 3)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"earth_03"]];
                    else if(card1.value == 4)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"earth_04"]];
                    else if(card1.value == 5)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"earth_05"]];
                    else if(card1.value == 6)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"earth_06"]];
                    else if(card1.value == 7)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"earth_07"]];
                    else if(card1.value == 8)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"earth_08"]];
                    else if(card1.value == 9)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"earth_09"]];
                    else if(card1.value == 10)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"earth_10"]];
                    else if(card1.value == 11)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"earth_11"]];
                    else if(card1.value == 12)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"earth_12"]];}
                else if(card1.element == 2){
                    if(card1.value == 1)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"water_01"]];
                    else if(card1.value == 2)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"water_02"]];
                    else if(card1.value == 3)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"water_03"]];
                    else if(card1.value == 4)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"water_04"]];
                    else if(card1.value == 5)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"water_05"]];
                    else if(card1.value == 6)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"water_06"]];
                    else if(card1.value == 7)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"water_07"]];
                    else if(card1.value == 8)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"water_08"]];
                    else if(card1.value == 9)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"water_09"]];
                    else if(card1.value == 10)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"water_10"]];
                    else if(card1.value == 11)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"water_11"]];
                    else if(card1.value == 12)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"water_12"]];}
                else if(card1.element == 3){
                    if(card1.value == 1)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"air_01"]];
                    else if(card1.value == 2)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"air_02"]];
                    else if(card1.value == 3)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"air_03"]];
                    else if(card1.value == 4)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"air_04"]];
                    else if(card1.value == 5)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"air_05"]];
                    else if(card1.value == 6)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"air_06"]];
                    else if(card1.value == 7)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"air_07"]];
                    else if(card1.value == 8)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"air_08"]];
                    else if(card1.value == 9)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"air_09"]];
                    else if(card1.value == 10)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"air_10"]];
                    else if(card1.value == 11)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"air_11"]];
                    else if(card1.value == 12)
                        [_aiCard1Image setImage: [UIImage imageNamed:@"air_12"]];}
                break;
            case 2:
                [self.aiCardLabel2 setText:[NSString stringWithFormat:@"%d of %d", card1.value, card1.element]];
                if(card1.element == 0){  //set AI card2 image if recon is selected.
                    if(card1.value == 1)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"fire_01"]];
                    else if(card1.value == 2)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"fire_02"]];
                    else if(card1.value == 3)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"fire_03"]];
                    else if(card1.value == 4)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"fire_04"]];
                    else if(card1.value == 5)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"fire_05"]];
                    else if(card1.value == 6)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"fire_06"]];
                    else if(card1.value == 7)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"fire_07"]];
                    else if(card1.value == 8)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"fire_08"]];
                    else if(card1.value == 9)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"fire_09"]];
                    else if(card1.value == 10)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"fire_10"]];
                    else if(card1.value == 11)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"fire_11"]];
                    else if(card1.value == 12)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"fire_12"]];}
                else if(card1.element == 1){
                    if(card1.value == 1)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"earth_01"]];
                    else if(card1.value == 2)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"earth_02"]];
                    else if(card1.value == 3)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"earth_03"]];
                    else if(card1.value == 4)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"earth_04"]];
                    else if(card1.value == 5)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"earth_05"]];
                    else if(card1.value == 6)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"earth_06"]];
                    else if(card1.value == 7)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"earth_07"]];
                    else if(card1.value == 8)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"earth_08"]];
                    else if(card1.value == 9)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"earth_09"]];
                    else if(card1.value == 10)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"earth_10"]];
                    else if(card1.value == 11)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"earth_11"]];
                    else if(card1.value == 12)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"earth_12"]];}
                else if(card1.element == 2){
                    if(card1.value == 1)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"water_01"]];
                    else if(card1.value == 2)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"water_02"]];
                    else if(card1.value == 3)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"water_03"]];
                    else if(card1.value == 4)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"water_04"]];
                    else if(card1.value == 5)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"water_05"]];
                    else if(card1.value == 6)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"water_06"]];
                    else if(card1.value == 7)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"water_07"]];
                    else if(card1.value == 8)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"water_08"]];
                    else if(card1.value == 9)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"water_09"]];
                    else if(card1.value == 10)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"water_10"]];
                    else if(card1.value == 11)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"water_11"]];
                    else if(card1.value == 12)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"water_12"]];}
                else if(card1.element == 3){
                    if(card1.value == 1)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"air_01"]];
                    else if(card1.value == 2)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"air_02"]];
                    else if(card1.value == 3)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"air_03"]];
                    else if(card1.value == 4)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"air_04"]];
                    else if(card1.value == 5)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"air_05"]];
                    else if(card1.value == 6)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"air_06"]];
                    else if(card1.value == 7)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"air_07"]];
                    else if(card1.value == 8)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"air_08"]];
                    else if(card1.value == 9)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"air_09"]];
                    else if(card1.value == 10)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"air_10"]];
                    else if(card1.value == 11)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"air_11"]];
                    else if(card1.value == 12)
                        [_aiCard2Image setImage: [UIImage imageNamed:@"air_12"]];}
                break;
            case 3:
                [self.aiCardLabel3 setText:[NSString stringWithFormat:@"%d of %d", card1.value, card1.element]];
                if(card1.element == 0){ //set card3 image if recon is selected.
                    if(card1.value == 1)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"fire_01"]];
                    else if(card1.value == 2)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"fire_02"]];
                    else if(card1.value == 3)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"fire_03"]];
                    else if(card1.value == 4)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"fire_04"]];
                    else if(card1.value == 5)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"fire_05"]];
                    else if(card1.value == 6)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"fire_06"]];
                    else if(card1.value == 7)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"fire_07"]];
                    else if(card1.value == 8)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"fire_08"]];
                    else if(card1.value == 9)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"fire_09"]];
                    else if(card1.value == 10)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"fire_10"]];
                    else if(card1.value == 11)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"fire_11"]];
                    else if(card1.value == 12)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"fire_12"]];}
                else if(card1.element == 1){
                    if(card1.value == 1)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"earth_01"]];
                    else if(card1.value == 2)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"earth_02"]];
                    else if(card1.value == 3)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"earth_03"]];
                    else if(card1.value == 4)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"earth_04"]];
                    else if(card1.value == 5)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"earth_05"]];
                    else if(card1.value == 6)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"earth_06"]];
                    else if(card1.value == 7)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"earth_07"]];
                    else if(card1.value == 8)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"earth_08"]];
                    else if(card1.value == 9)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"earth_09"]];
                    else if(card1.value == 10)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"earth_10"]];
                    else if(card1.value == 11)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"earth_11"]];
                    else if(card1.value == 12)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"earth_12"]];}
                else if(card1.element == 2){
                    if(card1.value == 1)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"water_01"]];
                    else if(card1.value == 2)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"water_02"]];
                    else if(card1.value == 3)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"water_03"]];
                    else if(card1.value == 4)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"water_04"]];
                    else if(card1.value == 5)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"water_05"]];
                    else if(card1.value == 6)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"water_06"]];
                    else if(card1.value == 7)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"water_07"]];
                    else if(card1.value == 8)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"water_08"]];
                    else if(card1.value == 9)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"water_09"]];
                    else if(card1.value == 10)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"water_10"]];
                    else if(card1.value == 11)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"water_11"]];
                    else if(card1.value == 12)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"water_12"]];}
                else if(card1.element == 3){
                    if(card1.value == 1)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"air_01"]];
                    else if(card1.value == 2)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"air_02"]];
                    else if(card1.value == 3)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"air_03"]];
                    else if(card1.value == 4)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"air_04"]];
                    else if(card1.value == 5)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"air_05"]];
                    else if(card1.value == 6)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"air_06"]];
                    else if(card1.value == 7)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"air_07"]];
                    else if(card1.value == 8)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"air_08"]];
                    else if(card1.value == 9)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"air_09"]];
                    else if(card1.value == 10)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"air_10"]];
                    else if(card1.value == 11)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"air_11"]];
                    else if(card1.value == 12)
                        [_aiCard3Image setImage: [UIImage imageNamed:@"air_12"]];}
                break;
            default:
                break;
        }
    }
    
    _powerUp4ReconOutlet.enabled = false; //use only once
    
        //SET POWER UP 4 IMAGE TO USED
    
    [_powerUp4Image setImage: [UIImage imageNamed:@"PU_R_inactive"]];

}
@end
