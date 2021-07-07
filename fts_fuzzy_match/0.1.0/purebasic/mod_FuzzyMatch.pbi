; "mod_FuzzyMatch.pbi" | v1.0.0 | 2021/07/07 | PureBasic 5.73 | CC0 1.0
;{******************************************************************************
; *                                                                            *
; *                        Module FTS Fuzzy Match 0.1.0                        *
; *                                                                            *
; *               A Sublime Text inspired fuzzy match algorithm                *
; *                                                                            *
; *                             by Tristano Ajmone                             *
; *                                                                            *
; ******************************************************************************
; This is the PureBasic implementation of Forrest Thomas Smith's fts_fuzzy_match
; algorithm v0.1.0, originally published in the lib_fts project (Public Domain):
;     https://github.com/forrestthewoods/lib_fts
;
; Ported to PureBasic by Tristano Ajmone from the JavaScript implementation:
;     "fts_fuzzy_match.js" v0.1.0 (2016/03/28 — 2017/02/19)
;
; Published in the "Fuzzy Search" project, dedicated to implementations of the
; FTS Fuzzy Search algorithm in multiple programming languages:
;     https://github.com/tajmone/fuzzy-search
;
; Tristano Ajmone has dedicated this code to the public domain via the CC0 1.0
; Universal Public Domain Dedication, waiving all of his rights to the work
; worldwide under copyright law, including all related and neighbouring rights,
; to the extent allowed by law:
;     https://creativecommons.org/publicdomain/zero/1.0/
;}------------------------------------------------------------------------------

DeclareModule FTS
  Declare.i FuzzyMatch(pattern.s,         ; Pattern to search for.
                       str.s,             ; Target string.
                       *outScore.Integer) ; Pointer to score variable.
EndDeclareModule

;- Usage Instructions
;{===================
; Syntax:
;     Result = FTS::FuzzyMatch("<search pattern>", "<target string>", @score)
;
; Return value:
;     #True if <search pattern> matched <target string>, #False otherwise.
;     The matching score will be stored in the `score` variable (must be defined
;     before invoking the procedure).
;
; Remarks:
;     See "Usage Example" at the end of this file for a real code example.
;}

Module FTS
  Procedure.i Max(a.i, b.i)
    If a>b
      ProcedureReturn a
    EndIf
    ProcedureReturn b
  EndProcedure

  ;- Score Constants
  #adjacency_bonus            =   5 ; Bonus for adjacent matches.
  #separator_bonus            =  10 ; Bonus if match occurs after a separator.
  #camel_bonus                =  10 ; Bonus if match is uppercase and prev is lower.
  #leading_letter_penalty     =  -3 ; Penalty for every letter preceding 1st match.
  #max_leading_letter_penalty =  -9 ; Maximum penalty for leading letters.
  #unmatched_letter_penalty   =  -1 ; Penalty for every letter that doesn't matter.

  Procedure FuzzyMatch(pattern.s, str.s, *outScore.Integer)

    ;- Loop variables
    *outScore\I = 0
    patternIdx = 0
    patternLength = Len(pattern)
    strIdx = 0
    strLength = Len(str)
    prevMatched = #False
    prevLower = #False
    prevSeparator = #True ; true so if first letter match gets separator bonus

    ; Use "best" matched letter if multiple string letters match the pattern
    bestLetter.s = #Null$
    bestLower.s  = #Null$
    bestLetterIdx = #Null
    bestLetterScore = 0

    While strIdx <> strLength ;- Loop over strings
      patternChar.s = Mid(pattern, patternIdx +1, 1)
      strChar.s     = Mid(str, strIdx +1, 1)

      patternLower.s = LCase(patternChar)
      strLower.s = LCase(strChar)
      strUpper.s = UCase(strChar)

      ; If curr pattern char matches: 'nextMatch = #True'
      nextMatch = Bool(patternChar And patternLower = strLower)
      ; If curr bestLetter char matches: 'rematch = #True'
      rematch   = Bool(bestLetter And bestLower = strLower)

      ; If curr char & bestLetter match: then we might have a new bestLetter
      advanced = Bool(nextMatch And bestLetter)
      ; If curr char & bestLetter are same: then we might have a new bestLetter
      patternRepeat = Bool(bestLetter And patternChar And bestLower = patternLower)
      If (advanced Or patternRepeat)
        *outScore\I + bestLetterScore
        bestLetter = #Null$
        bestLower = #Null$
        bestLetterIdx = #Null
        bestLetterScore = 0
      EndIf

      If (nextMatch Or rematch)
        newScore = 0

        ;- Leading Letter Penalty
        ; =======================
        ; Apply penalty for each letter before the first pattern match.
        ; NOTE: Since penalties are negative values, Max() is smallest penalty.
        If patternIdx = 0
          penalty = Max(strIdx * #leading_letter_penalty, #max_leading_letter_penalty)
          *outScore\I + penalty
        EndIf

        ;- Adjacency Bonus
        ; ================
        ; Apply bonus for consecutive bonuses.
        If prevMatched
          newScore + #adjacency_bonus
        EndIf

        ;- Separator Bonus
        ; ================
        ; Apply bonus for matches after a separator.
        If prevSeparator
          newScore + #separator_bonus
        EndIf

        ;- Camel Bonus
        ; ============
        ; Apply bonus across camel case boundaries.
        ; Includes "clever" isLetter check.
        If prevLower And strChar = strUpper And strLower <> strUpper
          newScore + #camel_bonus
        EndIf

        ;- Update patternIdx
        ; ==================
        ; Update pattern index if the next pattern letter was matched.
        If nextMatch
          patternIdx +1
        EndIf

        ;- Update bestLetter
        ; ==================
        ; Update best letter in str which may be for a "next" letter or a "rematch".
        If newScore >= bestLetterScore
          ; Apply penalty for now skipped letter
          If (bestLetter <> #Null$)
            *outScore\I + #unmatched_letter_penalty
          EndIf

          bestLetter = strChar
          bestLower = LCase(bestLetter)
          bestLetterIdx = strIdx
          bestLetterScore = newScore
        EndIf
        ; -----------------
        prevMatched = #True
      Else
        *outScore\I + #unmatched_letter_penalty
        prevMatched = #False
      EndIf

      ; Includes "clever" isLetter check.
      prevLower = Bool(strChar = strLower And strLower <> strUpper)
      prevSeparator = Bool(strChar = "_" Or strChar = " ")

      strIdx +1
    Wend

    ;- Apply score for last match
    ; ===========================
    If bestLetter
      *outScore\I + bestLetterScore
    EndIf

    matched = Bool(patternIdx = patternLength)
    ProcedureReturn matched
  EndProcedure

EndModule

;- /// Usage Example ///

; To see the following example code in action, compile
; or run this module from the PureBasic IDE, on its own.

CompilerIf #PB_Compiler_IsMainFile

  Define.i score ; FTS::FuzzyMatch() will set its value to the match score.

  ; Matching Example
  ; ================
  If FTS::FuzzyMatch("pb", "PureBasic", @score)
    MessageRequester("MATCHED",
                     ~"Pattern \"pb\" matched \"PureBasic\" with score "+
                     Str(score)+".", #PB_MessageRequester_Info)
  Else
    MessageRequester("NO MATCH",
                     ~"Pattern \"pb\" didn't match \"PureBasic\".",
                     #PB_MessageRequester_Error)
  EndIf

  ; Non-Matching Example
  ; ====================
  If FTS::FuzzyMatch("sb", "PureBasic", @score)
    MessageRequester("MATCHED",
                     ~"Pattern \"sb\" matched \"PureBasic\" with score "+
                     Str(score)+".", #PB_MessageRequester_Info)
  Else
    MessageRequester("NO MATCH",
                     ~"Pattern \"sb\" didn't match \"PureBasic\".",
                     #PB_MessageRequester_Error)
  EndIf

CompilerEndIf
