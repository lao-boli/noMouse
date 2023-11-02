#Requires AutoHotkey v2.0

ShowTip(content, title) {
    TrayTip content, title
    SetTimer HideTrayTip, -1000

    HideTrayTip() {
        TrayTip 
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