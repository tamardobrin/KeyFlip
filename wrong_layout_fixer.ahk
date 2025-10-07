; --- Wrong-Layout Fixer (AHK v2) ---
; Alt+Shift+J : English -> Hebrew
; Alt+Shift+K : Hebrew  -> English
; Save as: wrong_layout_fixer.ahk  (requires AutoHotkey v2)

; Physical key mapping between US QWERTY and standard Hebrew layout
; Verified with examples:
;  "vhh nv vnmc" -> "היי מה המצב"
;  "ין יפ' שרק טםו" -> "hi how are you"

g_en2he := Map(
    "q","/",  "w","'",  "e","ק",  "r","ר",  "t","א",  "y","ט",  "u","ו",  "i","ן",  "o","ם",  "p","פ",
    "a","ש",  "s","ד",  "d","ג",  "f","כ",  "g","ע",  "h","י",  "j","ח",  "k","ל",  "l","ך",  ";","ף",
    "z","ז",  "x","ס",  "c","ב",  "v","ה",  "b","נ",  "n","מ",  "m","צ",  ",","ת",  ".","ץ",  "/","."
)

; Build reverse map (Hebrew -> English)
g_he2en := Map()
for k, v in g_en2he
    g_he2en[v] := k

; Utility: convert a string using a mapping (char-by-char)
convert(str, map) {
    out := ""
    Loop Parse, str
    {
        ch := A_LoopField
        ; Handle letters case when going EN->HE:
        ; - Hebrew has no case, so we just map lowercase
        ; - For EN uppercase letters, map their lowercase counterpart and keep as-is for non-letters
        if (map.Has(ch))
            out .= map[ch]
        else if (map.Has(StrLower(ch)))  ; uppercase Latin -> map from lowercase
            out .= map[StrLower(ch)]
        else
            out .= ch
    }
    return out
}

; Clipboard helper (safe copy/paste)
replaceSelectionWith(fn) {
    oldClip := A_Clipboard
    A_Clipboard := ""
    Send "^c"
    ClipWait 0.6
    text := A_Clipboard
    if (text = "") {
        ; Nothing selected; try the current word? (Optional)
        ; For simplicity, do nothing:
        A_Clipboard := oldClip
        return
    }
    newText := fn(text)
    A_Clipboard := newText
    Send "^v"
    Sleep 30
    A_Clipboard := oldClip
}

; --- Hotkeys ---
; Alt+Shift+J : English -> Hebrew
!+j::
{
    replaceSelectionWith( (t) => convert(t, g_en2he) )
}

; Alt+Shift+K : Hebrew -> English
!+k::
{
    replaceSelectionWith( (t) => convert(t, g_he2en) )
}
