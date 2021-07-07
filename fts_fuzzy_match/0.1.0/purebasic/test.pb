; "test.pb" | v1.0.0 | 2021/07/07 | PureBasic 5.73 | CC0 1.0
;{******************************************************************************
; *                                                                            *
; *                        Test Module FTS Fuzzy Match                         *
; *                                                                            *
; *                             by Tristano Ajmone                             *
; *                                                                            *
; ******************************************************************************
; Test the PureBasic port of fts_fuzzy_match against the original algorithm by
; diff comparing their results.
; Works with all algorithms implementations (v0.1.0 or v0.2.0).
;}------------------------------------------------------------------------------

; To execute test, either Run me from the PureBasic IDE or compile me.
; Windows users must compile as Console application.

#DataSetFile$ = "../../../dataset/ue4_filenames.txt"
#ResultsFile$ = "test_results.txt"
#Pattern$ = "LLL"
#MaxMatches = 100

XIncludeFile "mod_FuzzyMatch.pbi"

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  CompilerIf #PB_Compiler_ExecutableFormat <> #PB_Compiler_Console
    CompilerError "Must compile as Console application!"
  CompilerEndIf
CompilerEndIf

OpenConsole("PB Fuzzy Match Test")
PrintN("/// Start ///")

Define.i score ; passed to FTS::FuzzyMatch() via pointer
matches = 0

Enumeration
  #dataF
  #testF
EndEnumeration

If Not CreateFile(#testF, #ResultsFile$, #PB_File_SharedRead)
  ConsoleError("Unable to create "+ #ResultsFile$)
  End 1
EndIf

If ReadFile(#dataF, #DataSetFile$, #PB_UTF8)
  While Not Eof(#dataF) And matches < 100
    line.s = ReadString(#dataF)
    If FTS::FuzzyMatch(#Pattern$, line, @score)
      result$ = Str(score) + "|" + line
      PrintN(result$)
      Debug(result$)
      WriteString(#testF, result$ + #LF$)
      matches +1
    EndIf
  Wend
  CloseFile(#dataF)
  CloseFile(#testF)
Else
  ConsoleError("Unable to open "+ #DataSetFile$)
  End 1
EndIf

PrintN("/// Finish ///")
CloseConsole()
