#include "util.ahk"
#suspendexempt
!p::
{
    Suspend -1  
    
    content := A_IsSuspended ? "Script suspended" : "Script on wroking"  
    ShowTip(content, "Suspend state change")
}
#SuspendExempt False

global mode := 1

global zCount := 0

^!m::
{
    global mode
    mode := Mod(mode + 1,2)
    ShowTip("now Mode: " mode "", "Mode change")
}
$^j::HandleWheel("^j")
$^k::HandleWheel("^k")
$n::HandleWheel("n")
$p::HandleWheel("p")

$h::HandleMouseMove("h")
$l::HandleMouseMove("l")
$j::HandleMouseMove("j")
$k::HandleMouseMove("k")
$+h::HandleMouseMove("+h")
$+l::HandleMouseMove("+l")
$+j::HandleMouseMove("+j")
$+k::HandleMouseMove("+k")
$!h::HandleMouseMove("!h")
$!l::HandleMouseMove("!l")
$!j::HandleMouseMove("!j")
$!k::HandleMouseMove("!k")
$d Up::HandleMouseMove("d")
$Space:: HandleMouseMove("Space")
$!Space:: HandleMouseMove("!Space")
m & Space:: 
{
    HandleMouseMove("m{Space}")

}

$z Up:: 
{
    HandleMouseMove("z")

}

HandleMouseMove(key)
{
    ; negative
    neg := 0
    ; positive
    posi := 1
    ; vertical
    vrt := 0
    ; horizontal
    hor := 1


    if (mode == 1) {
        CoordMode "Mouse"
        switch key
        {

        ; middle 
        case 'h': SmoothMouseMove(neg,hor,key,1)
        case 'l': SmoothMouseMove(posi,hor,key,1)
        case 'j': SmoothMouseMove(posi,vrt,key,1)
        case 'k': SmoothMouseMove(neg,vrt,key,1)
        ; quick 
        case '+h': SmoothMouseMove(neg,hor,'h',0)
        case '+l': SmoothMouseMove(posi,hor,'l',0)
        case '+j': SmoothMouseMove(posi,vrt,'j',0)
        case '+k': SmoothMouseMove(neg,vrt,'k',0)
        ; slow 
        case '!h': SmoothMouseMove(neg,hor,'h',2)
        case '!l': SmoothMouseMove(posi,hor,'l',2)
        case '!j': SmoothMouseMove(posi,vrt,'j',2)
        case '!k': SmoothMouseMove(neg,vrt,'k',2)
        case 'z': 
        {
            ; prevent cursor out of screen when move bottom and right by use z commend.
            static moveOffset := 20

            global zCount
            if zCount > 1 
            {
                zCount := 0
                return
            }
            zCount := 1

            MouseGetPos &xpos, &ypos 

            loop 
            {
                if (GetKeyState("z", "P") and A_TimeIdleKeyboard < 500)
                {
                    MouseMove A_ScreenWidth / 2, A_ScreenHeight / 2
                    zCount += 1
                    return
                }
                if (GetKeyState("t", "P"))
                {

                    MouseMove 0, 0
                    zCount := 0
                    return
                }
                else if (GetKeyState("b", "P"))
                {

                    MouseMove A_ScreenWidth - moveOffset, A_ScreenHeight - moveOffset
                    zCount := 0
                    return
                }
                else if (GetKeyState("]", "P"))
                {

                    MouseMove A_ScreenWidth - moveOffset, 0
                    zCount := 0
                    return
                }
                else if (GetKeyState("[", "P"))
                {

                    MouseMove 0, A_ScreenHeight - moveOffset
                    zCount := 0
                    return
                }

                if (GetKeyState("j", "P"))
                {

                    MouseMove xpos, A_ScreenHeight - moveOffset
                    zCount := 0
                    return
                }
                else if (GetKeyState("k", "P"))
                {

                    MouseMove xpos, 0
                    zCount := 0
                    return
                }
                else if (GetKeyState("h", "P"))
                {

                    MouseMove 0, ypos
                    zCount := 0
                    return
                }
                else if (GetKeyState("l", "P"))
                {

                    MouseMove A_ScreenWidth - moveOffset, ypos
                    zCount := 0
                    return
                }
                else if ( A_TimeIdleKeyboard != '' and A_TimeIdleKeyboard > 500)
                {
                    zCount := 0
                    return
                }
                sleep 10
            }
        }
        case 'd': 
        {
            state := GetKeyState("LButton")
            if(state == 0){
                MouseClick "L",,,,,"D", "R"
            }else {
                MouseClick "L",,,,,"U", "R"
            }
        }
        case 'Space': 
        {
            Send "{Click Left}"
        }
        case '!Space':
        {
            Send "{Blind}{Alt up}"
            Send "{Click Right}"
        }
        case 'm{Space}':
        {
            Send "{Click Middle}"
        }
        }
    
    } else {  

        ; XXX optimize it
        if(key == "m{Space}"){
            Send key
        }
        SendOrigin(key)
    }
}
SmoothMouseMove(isPosi,isHor,key,speed)
{
    if(zCount > 0){
        return
    }
    step := isPosi ? 1 : -1

    ; control mouse move speed
    ; why not use Sleep?
    ; "Due to the granularity of the OS's time-keeping system, 
    ; Delay is typically rounded up to the nearest multiple of 10 or 15.6 milliseconds."
    ; @see: https://www.autohotkey.com/docs/v2/lib/Sleep.htm
    ;
    ; so even I write "Sleep(1)" in loop,it will sleep at least 10 ms,its too slow.
    ; and the method mentioned in the offical document to sleep for less then 10ms 
    ; will affect the entire operating system and all applications, which is I dont want to see.
    ; therefore, I use a counter to skip iteration to control mouse move speed.
    quick := 0
    middle := 1000
    slow := 4000

    givenValue := quick
    switch speed
    {
        case 0: givenValue := quick
        case 1: givenValue := middle
        case 2: givenValue := slow
    }
    delay := givenValue

    while GetKeyState(key, "P")
    {
        if(delay <= 0){
            if (isHor){
                MouseMove step, 0, 0, "R"
            }else {
                MouseMove 0, step, 0, "R"
            }
        delay := givenValue
        }
        delay := delay - 1
    }

}
HandleWheel(key)
{
    if (mode == 1) {
        switch key
        {
        case '^j': Send "{Blind^}{WheelDown}"
        case '^k': Send "{Blind^}{WheelUp}"
        case 'p': MouseClick "WL"
        case 'n': MouseClick "WR"
        }
    
    } else {  
        SendOrigin(key)
    }
}