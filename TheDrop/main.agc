
// Project: TheDrop 
// Created: 2018-08-27

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "TheDrop" )
SetWindowSize( 414, 736, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 414, 736 ) // doesn't have to match the window
SetOrientationAllowed( 1, 0, 0, 0 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

//Load Images
LoadImage (1, "Sprites/playerCircle.png")
LoadImage (2, "Sprites/spinner.png")
LoadImage (3, "Sprites/StartGame2.png")
LoadImage (4, "Sprites/BorderLeft.png")
LoadImage (5, "Sprites/BorderRight.png")
LoadImage (6, "Sprites/spinner_spin.png")
LoadImage (7, "Sprites/coinGold.png")
LoadImage (8, "Sprites/spinner.png")
LoadImage (9, "Sprites/castleCenter.png")
LoadImage (10, "Sprites/bg_castle.png")
LoadImage (11, "Sprites/gemBlue.png")
LoadImage (12, "Sprites/ExtraLifeCard.png")
LoadImage (13, "Sprites/ExtraCoinsCard.png")
LoadImage (14, "Sprites/SkipButton.png")
//LoadImage (6, "Sprites/PlayerShadow.png")

//Set Text
CreateText(1, "Score: 0")
CreateText(2, "Coins: 0")

//Set Constants
SetClearColor( 252, 252, 252 )

//Set Globals
global points = 0
global plr_coins = 0
global high_score = 0
global widthOfPlay = 17
global lifeUp = 0
global coinsUp = 1

global boxes as integer [ 1 ] 
global slide as integer [ 1 ]
global coins as integer [ 1 ]
global border_left as integer [ 1 ]
global border_right as integer [ 1 ]
global background as integer [ 1 ]
global gems as integer [ 1 ]


//Set Borders
/*CreateSprite(10, 4)
CreateSprite(11, 5)
SetSpritePosition(11, 414-64, 0)

//Set Lower Borders
CreateSprite(12, 4)
SetSpritePosition(12, 0, 740)
CreateSprite(13, 5)
SetSpritePosition(13, 414-64, 740)*/

file_path$ = GetWritePath()

// Create save file
function createFile()
	OpenToWrite(1, "Data/Saves.txt")
	WriteInteger(1, 0)
	CloseFile(1)
EndFunction

// Save to save file
function saveGame()
	OpenToWrite(1,"Data/Saves.txt")
	WriteInteger(1,plr_coins)
	WriteInteger(1,high_score)
	CloseFile(1)
EndFunction

// Load from save file
function loadGame()
	if GetFileExists("Data/Saves.txt")=1
		OpenToRead(1, "Data/Saves.txt")
		plr_coins = ReadInteger(1)
		high_score = ReadInteger(1)
		CloseFile(1)
	else
		createFile()
	endif
EndFunction

// Creates all sprites used in the game
function createHazard(x, y, id)
	hazard = CreateSprite(id)
	//SetSpriteScale(hazard, .25, .25)
	SetSpritePosition(hazard, x, y)
	SetSpriteShape(hazard, 1)
	
	
EndFunction hazard

function createCoin(x, y)
	coin = CreateSprite(7)
	SetSpritePosition(coin, x, y)
	SetSpriteShape(coin, 1)
EndFunction coin

function createBorder(x, y)
	border = CreateSprite(9)
	SetSpritePosition(border, x, y)
	SetSpriteDepth(border, 998)
	SetSpriteShape(border, 0)
EndFunction border

function createBG(x, y)
	border = CreateSprite(10)
	SetSpritePosition(border, x, y)
	SetSpriteDepth(border, 999)
EndFunction border

function createGem(x, y)
	gem = CreateSprite(11)
	SetSpritePosition(gem, x, y)
	SetSpriteDepth(gem, 1)
	SetSpriteShape(gem, 0)
EndFunction gem

// Main function
function runMenu()
	coinsUp = 1
	sprite=0
	CreateSprite(3, 3)
	
	saveGame()
	
	CreateText(3, "High Score: "+str(high_score))
	
	background.insert(createBG(0,0))
	background.insert(createBG(256, 0))
	background.insert(createBG(0,250))
	background.insert(createBG(256, 250))
	background.insert(createBG(0,500))
	background.insert(createBG(256, 500))
	background.insert(createBG(0,750))
	background.insert(createBG(256, 750))
	
	for i = 0 to 12
		border_left.insert(createBorder(-17, 70*i))
		border_right.insert(createBorder(414-52, 70*i))
	next i
	
	
	do
		if GetSpriteExists(3)=1
			print(lifeUp)
			SetTextString(3, "High Score: "+str(high_score))
			SetTextColor(3, 1, 1, 1, 255)
			SetTextSize(3, 40)
			SetTextAlignment(3, 1)
			SetTextPosition(3, 207, 200)
			
			SetSpritePosition(3, 207-96, 250)
			
			SetSpriteDepth(3,100)
					
			if ( GetPointerPressed ( ) = 1 )
				sprite = GetSpriteHit(GetPointerX ( ), GetPointerY ( ))
				
				if sprite = 3
					DeleteSprite(3)
					runUpgrades()
				endif
			endif
			
			Sync()
		endif
		
	loop
	
EndFunction

// Handles upgrade store
function runUpgrades()
	CardLife = CreateSprite(12)
	SetSpritePosition(CardLife, 32, (736/2)-128)
	SetSpriteDepth(CardLife,100)
	
	CardCoin = CreateSprite(13)
	SetSpritePosition(CardCoin, 414-160, (736/2)-128)
	SetSpriteDepth(CardCoin,100)
	
	SkipButton = CreateSprite(14)
	SetSpritePosition(SkipButton, (414/2)-128, (736/2)+192)
	SetSpriteDepth(SkipButton,100)
	
	do
		SetSpritePosition(CardLife, 32, (736/2)-128)
		SetSpriteDepth(CardLife,100)
		
		SetSpritePosition(CardCoin, 414-160, (736/2)-128)
		SetSpriteDepth(CardCoin,100)
	
		if ( GetPointerPressed ( ) = 1 )
			sprite = GetSpriteHit(GetPointerX ( ), GetPointerY ( ))
					
			if sprite = CardLife
				lifeUp = 2
				plr_coins = plr_coins - 25
				DeleteSprite(CardLife)
				DeleteSprite(CardCoin)
				DeleteSprite(SkipButton)
				runLevel()
			endif
			
			if sprite = CardCoin
				coinsUp = 5
				plr_coins = plr_coins - 25
				DeleteSprite(CardLife)
				DeleteSprite(CardCoin)
				DeleteSprite(SkipButton)
				runLevel()
			endif
			
			if sprite = SkipButton
				DeleteSprite(CardLife)
				DeleteSprite(CardCoin)
				DeleteSprite(SkipButton)
				runLevel()
			endif
		endif
		
		Sync()
	loop
EndFunction

// Runs the game itself
function runLevel()
	if lifeUp = 0
		points = 0
	elseif lifeUp > 0
		lifeUp = lifeUp - 1
	endif
		
	waiter = 60
	waitForBorder = 0
	waitForBack = 0
	chanceOfGem = 1
	currentChance = 0
	
	widthPowerTimer = 0
	
	DeleteText(3)
	
	image_id = 2
	animTimer = 0
	
	SetTextSize(1, 40)
	SetTextPosition(1, 103, 0)
	SetTextAlignment(1, 1)
	SetTextColor(1, 1, 1, 1, 255)
	
	SetTextSize(2, 40)
	SetTextPosition(2, 310, 0)
	SetTextAlignment(2, 1)
	SetTextColor(2, 1, 1, 1, 255)
	//SetTextDepth(1,1)
	
	ball_X = 207-32
	ball_Y = 75
	
	shadow_X = 207-32
	
	waitToSpawn = 0
	scoreTimer = 0
	
	CreateSprite (1, 1)
	SetSpriteShape(1, 1)
	SetSpriteDepth(1,1)
	SetSpritePosition(1, ball_X,ball_Y)
	
	//CreateSprite (14, 6)
	//SetSpriteShape(14, 1)
	//SetSpriteDepth(14,2)
	
	do
		inc waitToSpawn
		inc points
		inc scoreTimer
		inc animTimer
		inc waitForBorder
		inc waitForBack
		
		print(lifeUp)
		
		currentChance = Random(1,1000)
		
		if widthOfPlay > 17
			inc widthPowerTimer
			
			if widthPowerTimer = 300
				widthOfPlay = 17
			endif
		endif
		
		if currentChance = chanceOfGem
			gems.insert(createGem(Random(75, 339), 800))
		endif
		
		if points > high_score
			high_score = points
		endif
		
		// Move Borders
		
		if waitForBack = 25
			background.insert(createBG(0,750))
			background.insert(createBG(256, 750))
			waitForBack = 0
		endif
		
		if waitForBorder = 7
			border_left.insert(createBorder(-widthOfPlay, 800)) //Random(0,35)*-1
			border_right.insert(createBorder(414-(70-widthOfPlay), 800)) //414-Random(35,70)
			waitForBorder = 0
		endif
		
		for i = 1 to gems.length
			if GetSpriteExists(gems[i])=1
				gem_X = GetSpriteX(gems[i])
				gem_Y = GetSpriteY(gems[i])
				
				SetSpritePosition(gems[i], gem_X, gem_Y-10)
				
				if GetSpriteCollision (1, gems[i] ) = 1
					widthOfPlay = 70
					widthPowerTimer = 0
					DeleteSprite(gems[i])
				endif
			endif
		next i
		
		for i = 1 to background.length
			if GetSpriteExists(background[i])=1
				wall_X = GetSpriteX(background[i])
				wall_Y = GetSpriteY(background[i])
				
				SetSpritePosition(background[i], wall_X, wall_Y-10)
				
				if GetSpriteY(background[i]) < -256
					DeleteSprite(background[i])
				endif
			endif
		next i
		
		for i = 1 to border_left.length
			if GetSpriteExists(border_left[i])=1
				wall_X = GetSpriteX(border_left[i])
				wall_Y = GetSpriteY(border_left[i])
				
				SetSpritePosition(border_left[i], wall_X, wall_Y-10)
				
				if GetSpriteCollision (1, border_left[i] ) = 1
						DeleteSprite(1)
						DeleteSprite(14)
							
						for ii = 1 to slide.length
							if GetSpriteExists(slide[ii])= 1
								DeleteSprite(slide[ii])
							endif
						next ii
						
						for ii = 1 to boxes.length
							if GetSpriteExists(boxes[ii])= 1
								DeleteSprite(boxes[ii])
							endif
						next ii
						
						for ii = 1 to coins.length
							if GetSpriteExists(coins[ii])=1
								DeleteSprite(coins[ii])
							endif
						next ii
						
						for ii = 1 to border_right.length
							if GetSpriteExists(border_right[ii])
								DeleteSprite(border_right[ii])
							endif
						next ii
						
						for ii = 1 to border_left.length
							if GetSpriteExists(border_left[ii])
								DeleteSprite(border_left[ii])
							endif
						next ii
						
						for ii = 1 to background.length
							if GetSpriteExists(background[ii])
								DeleteSprite(background[ii])
							endif
						next ii
						
						runMenu()
				endif
				
				if GetSpriteY(border_left[i]) < -70
					DeleteSprite(border_left[i])
				endif
			endif
		next i
		
		for i = 1 to border_right.length
			if GetSpriteExists(border_right[i])=1
				wall_X = GetSpriteX(border_right[i])
				wall_Y = GetSpriteY(border_right[i])
				
				SetSpritePosition(border_right[i], wall_X, wall_Y-10)
				
				if GetSpriteY(border_right[i]) < -70
					DeleteSprite(border_right[i])
				endif
			endif
		next i
		
		// Continue
		
		SetTextString(1, "Score: "+str(points))
		SetTextString(2, "Coins: "+str(plr_coins))
		
		if (waitToSpawn >= waiter )
			pos_X = Random(0, 300)
			
			if points <= 1500
				chosen = 1
			elseif points >= 1500
				chosen = Random(1,2)
			endif
			
			if chosen = 1
				boxes.insert (createHazard(pos_X, 800, 2))
			elseif chosen = 2
				slide.insert (createHazard(pos_X, 800, 8))
			endif
			
			hasCoin = Random(0,10)
			
			if (hasCoin = 4)
				coins.insert (createCoin(pos_X+64, 800))
			endif
			
			if (hasCoin = 6)
				coins.insert (createCoin(pos_X-64, 800))
			endif
			
			waitToSpawn = 0
		endif
		
		if (animTimer = 5) 
			image_id = 6
		endif
		
		if (animTimer = 10)
			image_id = 2
			animTimer = 0
		endif
		
		if (scoreTimer = 1000)
			waiter = waiter - 1
			scoreTimer = 0
		endif
		
		/*print(boxes.length)
		print("Still going")*/
		
		inc ball_X, GetDirectionX ( ) * 10
		inc shadow_X, GetDirectionX ( ) * 11
		
		if GetSpriteExists(1)=1
			SetSpritePosition(1,ball_X,ball_Y)
			//SetSpritePosition(14,ball_X+8,ball_Y)
		endif
		
		for i = 0 to coins.length
			if GetSpriteExists(coins[i])=1
				coin_X = GetSpriteX(coins[i])
				coin_Y = GetSpriteY(coins[i])
				SetSpritePosition(coins[i], coin_X, coin_Y-10)
				
				if GetSpriteCollision (1, coins[i] ) = 1
					DeleteSprite(coins[i])
					coins.remove(i)
					inc plr_coins, coinsUp
				endif
				
			endif
		next i
		
		for i = 0 to boxes.length
			if GetSpriteExists(boxes[i]) = 1
				box_X = GetSpriteX(boxes[i])
				box_Y = GetSpriteY(boxes[i])
				
				SetSpritePosition(boxes[i], box_X, box_Y-10)
				
				SetSpriteImage(boxes[i], image_id)
					
				
				if GetSpriteExists(1)=1
					if GetSpriteCollision (1, boxes[i] ) = 1
							DeleteSprite(1)
							DeleteSprite(14)
							
							for ii = 1 to slide.length
								if GetSpriteExists(slide[ii])= 1
									DeleteSprite(slide[ii])
								endif
							next ii
							
							for ii = 1 to boxes.length
								if GetSpriteExists(boxes[ii])= 1
									DeleteSprite(boxes[ii])
								endif
							next ii
							
							for ii = 1 to coins.length
								if GetSpriteExists(coins[ii])=1
									DeleteSprite(coins[ii])
								endif
							next ii
							
							for ii = 1 to border_right.length
								if GetSpriteExists(border_right[ii])
									DeleteSprite(border_right[ii])
								endif
							next ii
							
							for ii = 1 to border_left.length
								if GetSpriteExists(border_left[ii])
									DeleteSprite(border_left[ii])
								endif
							next ii
							
							for ii = 1 to background.length
								if GetSpriteExists(background[ii])
									DeleteSprite(background[ii])
								endif
							next ii
							
							runMenu()
						
					endif
				endif
				
				if (box_Y < -100)
					DeleteSprite(boxes[i])
					boxes.remove(i)
				endif
				
			endif
		next i
		
		for i = 0 to slide.length
			if GetSpriteExists(slide[i]) = 1
				box_X = GetSpriteX(slide[i])
				box_Y = GetSpriteY(slide[i])
				
				SetSpritePosition(slide[i], box_X+(Sin(box_Y)*10), box_Y-10)
				
				SetSpriteImage(slide[i], image_id)
					
				
				if GetSpriteExists(1)=1
					if GetSpriteCollision (1, slide[i] ) = 1
							DeleteSprite(1)
							DeleteSprite(14)
							
							for ii = 1 to slide.length
								if GetSpriteExists(slide[ii])= 1
									DeleteSprite(slide[ii])
								endif
							next ii
							
							for ii = 1 to boxes.length
								if GetSpriteExists(boxes[ii])= 1
									DeleteSprite(boxes[ii])
								endif
							next ii
							
							for ii = 1 to coins.length
								if GetSpriteExists(coins[ii])=1
									DeleteSprite(coins[ii])
								endif
							next ii
							
							for ii = 1 to border_right.length
								if GetSpriteExists(border_right[ii])
									DeleteSprite(border_right[ii])
								endif
							next ii
							
							for ii = 1 to border_left.length
								if GetSpriteExists(border_left[ii])
									DeleteSprite(border_left[ii])
								endif
							next ii
							
							for ii = 1 to background.length
								if GetSpriteExists(background[ii])
									DeleteSprite(background[ii])
								endif
							next ii
							
							runMenu()
					endif
				endif
				
				if (box_Y < -100)
					DeleteSprite(slide[i])
					slide.remove(i)
				endif
				
			endif
		next i
		
		Sync()
	loop
EndFunction

loadGame()
runMenu()
