#suspendexempt
!p::
{
    Suspend -1  
    
    content := A_IsSuspended ? "Script suspended" : "Script on wroking"  
    ShowTip(content, "Suspend state change")
}
#SuspendExempt False

global mode := 1

ShowTip(content, title) {
    TrayTip content, title
    SetTimer HideTrayTip, -1000

    HideTrayTip() {
        TrayTip 
    }
}


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
    shortDistance := 10
    middleDistance := 60
    longDistance := 400


    if (mode == 1) {
        CoordMode "Mouse"
        switch key
        {
        case 'h': MouseMove -shortDistance, 0, 0, "R"
        case 'l': MouseMove shortDistance, 0, 0, "R"
        case 'j': MouseMove 0, shortDistance, 0, "R"
        case 'k': MouseMove 0, -shortDistance, 0, "R"
        case '+h': MouseMove -middleDistance, 0, 0, "R"
        case '+l': MouseMove middleDistance, 0, 0, "R"
        case '+j': MouseMove 0, middleDistance, 0, "R"
        case '+k': MouseMove 0, -middleDistance, 0, "R"
        case '!h': MouseMove -longDistance, 0, 0, "R"
        case '!l': MouseMove longDistance, 0, 0, "R"
        case '!j': MouseMove 0, longDistance, 0, "R"
        case '!k': MouseMove 0, -longDistance, 0, "R"
        case 'z': 
        {
            static zCount := 0
            if zCount > 1 
            {
                zCount := 0
                return
            }
            zCount := 1

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
                    return
                }
                else if (GetKeyState("b", "P"))
                {

                    MouseMove A_ScreenWidth, A_ScreenHeight
                    return
                }
                else if (GetKeyState("]", "P"))
                {

                    MouseMove A_ScreenWidth, 0
                    return
                }
                else if (GetKeyState("[", "P"))
                {

                    MouseMove 0, A_ScreenHeight
                    return
                }

                if (GetKeyState("j", "P"))
                {

                    MouseMove A_ScreenWidth / 2, A_ScreenHeight
                    return
                }
                else if (GetKeyState("k", "P"))
                {

                    MouseMove A_ScreenWidth / 2, 0
                    return
                }
                else if (GetKeyState("h", "P"))
                {

                    MouseMove 0, A_ScreenHeight / 2
                    return
                }
                else if (GetKeyState("l", "P"))
                {

                    MouseMove A_ScreenWidth, A_ScreenHeight / 2
                    return
                }
                else if ( A_TimeIdleKeyboard != '' and A_TimeIdleKeyboard > 500)
                {
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

SendOrigin(key)
{
    FoundPos := RegExMatch(key, "[\+\^\!]+", &Match)
    offset := 0 
    matchStr := "" 
    if (Match != "") {
        matchStr := Match[0] 
        offset := Match.Len
    }

    pureKey := SubStr(key,offset + 1)
    if (StrLen(pureKey) == 1 && Match == "") {
        Send "" matchStr "{Blind}{" pureKey "}"
    } else {
    Send "" matchStr "{" pureKey "}"
    }
}