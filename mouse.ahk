#suspendexempt
#p::
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
$d::HandleMouseMove("d")
$Space:: HandleMouseMove("Space")
$!Space Up:: HandleMouseMove("!Space")
$^!Space Up:: HandleMouseMove("^!Space")
    
HandleMouseMove(key)
{
    shortDistance := 10
    middleDistance := 60
    longDistance := 400

    if (mode == 1) {
        switch key
        {
        case 'h': MouseMove -shortDistance, 0, 0, "R"
        case 'l': MouseMove shortDistance, 0, 0, "R"
        case 'j': MouseMove 0, shortDistance, 0, "R"
        case 'k': MouseMove 0, -shortDistance, 0, "R"
        case '+h': MouseMove -middleDistance, 0, 0, "R"
        case '+l': MouseMove middleDistance, 0, 0, "R"
        case '+j': MouseMove 0, middleDistance, 0, "R"
        case '!k': MouseMove 0, -longDistance, 0, "R"
        case '!h': MouseMove -longDistance, 0, 0, "R"
        case '!l': MouseMove longDistance, 0, 0, "R"
        case '!j': MouseMove 0, longDistance, 0, "R"
        case '+k': MouseMove 0, -middleDistance, 0, "R"
        case 'd': MouseClick "L",,,,,"D", "R"
        case 'Space': Send "{Click Left}"
        case '!Space': Send "{Click Right}"
        case '^!Space': Send "{Click Middle}"
        }
    
    } else {  
        SendOrigin(key)
    }
}

HandleWheel(key)
{
    if (mode == 1) {
        switch key
        {
        case '^j': Send "{WheelDown}"
        case '^k': Send "{WheelUp}"
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