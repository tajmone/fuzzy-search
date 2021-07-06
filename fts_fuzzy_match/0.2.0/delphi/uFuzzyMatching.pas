unit uFuzzyMatching;

// Fuzzy matching algorithm.
// LICENSE: CC0, Creative Commons Zero, (public domain)

// Returns if all characters of a given pattern are found in a string, and calculates a matching score
// Applies case insensitive matching, although case can influcence the score

// Based on the C++ version by Forrest Smith
// Original source: https://github.com/forrestthewoods/lib_fts/blob/master/code/fts_fuzzy_match.h
// Blog: https://www.forrestthewoods.com/blog/reverse_engineering_sublime_texts_fuzzy_match/

interface

uses
  System.SysUtils, System.Character;

type
  TMatch = Byte;
  TMatches = array[0..255] of TMatch;
  PMatch = ^TMatch;
  PMatches = ^TMatches;

function FuzzyMatch(const Pattern: String; const Str: String; out Score: Integer): Boolean; overload;
function FuzzyMatch(const Pattern: String; const Str: String; out Score: Integer; var Matches: TMatches): Boolean; overload;

implementation

function FuzzyMatchRecursive(
  Pattern: PChar; Str: PChar; out OutScore: Integer;
  const StrBegin: PChar; const SrcMatches: PMatches; const Matches: PMatches; const MaxMatches: Integer; NextMatch: Integer;
  RecursionCount: Integer; const RecursionLimit: Integer; MatchId: integer): Boolean;

const
  sequential_bonus: Integer = 15;            // bonus for adjacent matches
  separator_bonus: Integer = 30;             // bonus if match occurs after a separator
  camel_bonus: Integer = 30;                 // bonus if match is uppercase and prev is lower
  first_letter_bonus: Integer = 15;          // bonus if the first letter is matched
  first_letter_count: Integer = 1;           // How many letters count as 'first'. Try setting to 2 to skip the first, single letter prefix

  leading_letter_penalty: Integer = -5;      // penalty applied for every letter in str before the first match
  max_leading_letter_penalty: Integer = -15; // maximum penalty for leading letters
  unmatched_letter_penalty: Integer = -1;    // penalty for every letter that doesn't match
var
  RecursiveMatch: Boolean;
  BestRecursiveMatches: TMatches;
  BestRecursiveScore: Integer;
  FirstMatch: Boolean;
  RecursiveMatches: TMatches;
  RecursiveScore: Integer;
  Matched: Boolean;
  Penalty: Integer;
  Unmatched: Integer;
  i: Integer;
  currIdx: Byte;
  prevIdx: Integer;
  Neighbor: Char;
  Curr: Char;

begin
  OutScore := 100;
  RecursiveMatches:= Default(TMatches);

  Inc(RecursionCount);
  if RecursionCount >= RecursionLimit then
    Exit(False);

  if (Pattern^ = #0) or (Str^ = #0) then
    Exit(False);

  RecursiveMatch := False;
  BestRecursiveScore := 0;

  FirstMatch := True;

  while (Pattern^ <> #0) and (Str^ <> #0) do
  begin
    if Pattern^ = Str^ then
    begin
      if NextMatch >= MaxMatches then
        Exit(False);

      if FirstMatch and (SrcMatches <> nil) then
      begin
        Move(SrcMatches^, Matches^, NextMatch);
        FirstMatch := False;
      end;

      if FuzzyMatchRecursive(Pattern, Str+1, RecursiveScore, StrBegin, Matches, @RecursiveMatches[0], MaxMatches, NextMatch, RecursionCount, RecursionLimit, MatchId+1) then
      begin
        if (not RecursiveMatch) or (RecursiveScore > BestRecursiveScore) then
        begin
          Move(RecursiveMatches[0], BestRecursiveMatches[0], MaxMatches);
          BestRecursiveScore := RecursiveScore;
        end;
        RecursiveMatch := True;
      end;

      Matches[NextMatch] := MatchId;
      Inc(NextMatch);
      Inc(Pattern);
    end;
    Inc(Str);
    Inc(MatchId);
  end;

  Matched := Pattern^ = #0;

  if Matched then
  begin

    Penalty := leading_letter_penalty * matches[0];
    if Penalty < max_leading_letter_penalty then
      Penalty := max_leading_letter_penalty;

    Inc(OutScore, Penalty);

    Unmatched := Length(StrBegin) - NextMatch;
    Inc(OutScore, unmatched_letter_penalty * unmatched);

    for i := 0 to NextMatch - 1 do
    begin
      currIdx := Matches[i];
      if i > 0 then
      begin
        prevIdx := Matches[i-1];

        if currIdx = prevIdx+1 then
        begin
          Inc(OutScore, sequential_bonus);
        end;
      end;

      if currIdx > 0 then
      begin
        Neighbor := StrBegin[currIdx - 1];
        Curr := StrBegin[Curridx];
        if NeighBor.IsLetter and Curr.IsLetter and
           (NeighBor <> Neighbor.ToUpper)      and
           (Curr      = Curr.ToUpper)
        then
          Inc(OutScore, camel_bonus);

        if Neighbor in ['.','_',' ','\'] then
          Inc(OutScore, separator_bonus);
      end;

      if currIdx < first_letter_count then
      begin
        Inc(OutScore, first_letter_bonus);
      end;
    end;
  end;

  if RecursiveMatch and ((not Matched) or (BestRecursiveScore > OutScore)) then
  begin
    Move(BestRecursiveMatches[0], Matches[0], MaxMatches);
    OutScore := BestRecursiveScore;
    Exit(True);
  end
  else if Matched then
  begin
    Exit(True);
  end;

  Exit(False);
end;

function FuzzyMatch(const Pattern: String; const Str: String; out Score: Integer): Boolean;
var
  Matches: TMatches;
begin
  Result := FuzzyMatch(Pattern, Str, Score, Matches);
end;

function FuzzyMatch(const Pattern: String; const Str: String; out Score: Integer; var Matches: TMatches): Boolean;
var
  RecursionCount, RecursionLimit: Integer;
  PatternUC, StrUC: string;
begin
  RecursionCount := 0;
  RecursionLimit := 10;
  PatternUC := UpperCase(Pattern);
  StrUC     := UpperCase(Str);

  Result := FuzzyMatchRecursive(PChar(PatternUC), PChar(StrUC), Score, PChar(Str), nil, @Matches[0], Length(Matches), 0, recursionCount, recursionLimit, 0);
end;

end.