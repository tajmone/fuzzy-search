program Test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, System.Classes,
  uFuzzyMatching;

var
 InStrings, OutStrings: TStringList;
 InFileName, OutFilename, Str, Pattern: string;
 Score, i: integer;

begin
  Pattern := 'LLL';
  InFileName := ExpandFileName(ParamStr(0) + '\..\..\..\..') + '\dataset\ue4_filenames.txt';
  OutFilename := 'test_results.txt';
  InStrings := TStringList.Create;
  OutStrings := TStringList.Create;

  if FileExists(InFileName) then
    try
      InStrings.Loadfromfile(InFileName);

      for i := 0 to InStrings.Count - 1 do begin
        if FuzzyMatch(Pattern, InStrings[i], Score) then
          OutStrings.Add(inttostr(Score) + '|' + InStrings[i]);
        if OutStrings.Count >= 100 then break;
      end;
      OutStrings.SaveToFile(OutFilename);
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;

  InStrings.Free;
  OutStrings.Free;

end.

