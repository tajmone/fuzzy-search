program FuzzyScore;

{$APPTYPE Console}

uses
  SysUtils,
  uFuzzyMatching;

var
  Pattern, Line: String;
  Score: Integer;
  Matches: TMatches;
  MatchStr: String;
  p: Integer;
begin
  Pattern := ParamStr(1);

  if Pattern = '' then
  begin
    WriteLn('Enter search string');
    ReadLn(Pattern);
  end;

  while not EOF do
  begin

    ReadLn(Line);
    if FuzzyMatch(Pattern, Line, Score, Matches) then
    begin
      WriteLn(Line);
      MatchStr := StringOfChar(' ', Length(Line));
      for p := 0 to Length(Pattern) - 1 do
        MatchStr[Matches[p] + 1] := Line[Matches[p] + 1];
      WriteLn(TrimRight(MatchStr), '  score: ', Score);
    end else
      WriteLn('No match for ', Line);

  end;
end.
