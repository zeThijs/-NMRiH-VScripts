/*
    Setup a functional numerical display.
    Features:
        Display input number
        Display server time
        Create and display a keypad code
*/


local NDISPLAYELEMENTS = 5

local displayname="sSegDisplay"

local h_keypad0=null

if ( (h_keypad0 = Entities.FindByName(h_keypad0, "keypad0")) == null){
    printl("7Seg-Display script; cannot find entity named: keypad0")
}


local currNum = array(NDISPLAYELEMENTS, 0)

local h_DisplayArr = array(NDISPLAYELEMENTS, null)

local elementsfound = 0
local ent = null;

//inventorize the display elements
while ( (ent = Entities.FindByName(ent, displayname+elementsfound)) != null){

    printl("7Seg-Display script; found " + ent.GetName())
    h_DisplayArr[elementsfound] = ent
    elementsfound++
}
printl("Found " + elementsfound +" sSegDisplay Elements")


local h_timer = null


/*
 *  timer for displaying time. Timer calls UpdateTimeDisplay on fire.
*/
function CreateTimer(){
    h_timer = Entities.CreateByClassname("logic_timer")
    EntFireByHandle(h_timer, "name", "currentime")
    EntFireByHandle(h_timer, "RefireTime", 1)
    EntFireByHandle(h_timer, "StartDisabled", 1)
    EntFireByHandle(h_timer, "AddOutput", "OnTimer displayscript1:RunScriptCode:UpdateTimeDisplay():0:-1")
    printl("Timer Creation Finished")
}
/*
 *  This toggles live time display on the display.
 *  The Source engine does not have a native function for 
 *      fetching real time;  time since server start is displayed instead.
*/
function ToggleDisplayTime(){
    if (h_timer==null){
        CreateTimer()
    }
    EntFireByHandle(h_timer, "Enable")
}
function UpdateTimeDisplay(){
    local zetime = time()
    DisplayNumber(zetime)
}

/*
 * Displays the number passed. Can display up to a 5 digit number.
*/
function DisplayNumber(number){
    local str_time = number.tostring()
    local strlength = str_time.len()

    local numbercount
    if(strlength<NDISPLAYELEMENTS){
        numbercount=strlength
    }
    else {
        numbercount=NDISPLAYELEMENTS
    }
    local i=0
    for (i; i<numbercount ; i++){
        currNum[i] = str_time.slice(strlength-i-1,strlength-i)
        EntFire("sSegDisplay" + i, "skin", "" + currNum[i]);
    }
}


/*
 * Sets a random keypad code
*/
function a_KeypadCode(){
    //printl("starting new keypad code")
    local code = RandomInt(0, 9999)
    //printl("Code:" + code)
    DisplayNumber(code)
    EntFire("keypad0", "InputSetCode", code)
}


//display element number, from right to left. Number of shifts to perform
function ShiftDigit(digitnumber, shifts){ 
    local i=0
    for (i; i<shifts;i++){
        if (currNum[digitnumber] == 9){
            currNum[digitnumber] = 0
        }
        else {
            currNum[digitnumber] += 1
        }
        EntFire("sSegDisplay" + digitnumber, "skin", "" + currNum[digitnumber]);
        //h_DisplayArr[digitnumber].__KeyValueFromInt("skin", lastskin + 1)
    }
}
