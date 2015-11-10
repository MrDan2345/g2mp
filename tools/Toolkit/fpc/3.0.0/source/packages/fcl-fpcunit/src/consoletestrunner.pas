{ This unit contains the TTestRunner class, a base class for the console test
  runner for fpcunit.

  Copyright (C) 2006 Vincent Snijders

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
}
unit consoletestrunner;

{$mode objfpc}{$H+}

interface

uses
  custapp, Classes, SysUtils, fpcunit, testregistry, testutils,
  fpcunitreport, latextestreport, xmltestreport, plaintestreport,
  dom;

const
  Version = '0.3';

type
  TFormat = (fPlain, fLatex, fXML, fPlainNoTiming);

var
  DefaultFormat : TFormat = fXML;
  DefaultRunAllTests : Boolean = False;

type
  { TTestRunner }

  TTestRunner = class(TCustomApplication)
  private
    FShowProgress: boolean;
    FFileName: string;
    FStyleSheet: string;
    FLongOpts: TStrings;
    FFormatParam: TFormat;
  protected
    property FileName: string read FFileName write FFileName;
    property LongOpts: TStrings read FLongOpts write FLongOpts;
    property ShowProgress: boolean read FShowProgress write FShowProgress;
    property StyleSheet: string read FStyleSheet write FStyleSheet;
    property FormatParam: TFormat read FFormatParam write FFormatParam;
    procedure DoRun; override;
    procedure DoTestRun(ATest: TTest); virtual;
    function GetShortOpts: string; virtual;
    procedure AppendLongOpts; virtual;
    procedure WriteCustomHelp; virtual;
    procedure ParseOptions; virtual;
    procedure ExtendXmlDocument(Doc: TXMLDocument); virtual;
    function GetResultsWriter: TCustomResultsWriter; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses testdecorator;

const
  ShortOpts = 'alhp';
  DefaultLongOpts: array[1..11] of string =
     ('all', 'list', 'progress', 'help', 'skiptiming',
      'suite:', 'format:', 'file:', 'stylesheet:','sparse','no-addresses');

  { TProgressWriter }
type
  TProgressWriter= class(TNoRefCountObject, ITestListener)
  private
    FSuccess: boolean;
    procedure WriteChar(c: char);
  public
    destructor Destroy; override;

    { ITestListener interface requirements }
    procedure AddFailure(ATest: TTest; AFailure: TTestFailure);
    procedure AddError(ATest: TTest; AError: TTestFailure);
    procedure StartTest(ATest: TTest);
    procedure EndTest(ATest: TTest);
    procedure StartTestSuite(ATestSuite: TTestSuite);
    procedure EndTestSuite(ATestSuite: TTestSuite);
  end;

procedure TProgressWriter.WriteChar(c: char);
begin
  write(c);
  // flush output, so that we see the char immediately, even it is written to file
  Flush(output);
end;

destructor TProgressWriter.Destroy;
begin
  // on descruction, just write the missing line ending
  writeln;
  inherited Destroy;
end;

procedure TProgressWriter.AddFailure(ATest: TTest; AFailure: TTestFailure);
begin
  FSuccess := false;
  writechar('F');
end;

procedure TProgressWriter.AddError(ATest: TTest; AError: TTestFailure);
begin
  FSuccess := false;
  writechar('E');
end;

procedure TProgressWriter.StartTest(ATest: TTest);
begin
  FSuccess := true; // assume success, until proven otherwise
end;

procedure TProgressWriter.EndTest(ATest: TTest);
begin
  if FSuccess then
    writechar('.');
end;

procedure TProgressWriter.StartTestSuite(ATestSuite: TTestSuite);
begin
  // do nothing
end;

procedure TProgressWriter.EndTestSuite(ATestSuite: TTestSuite);
begin
  // do nothing
end;

function TTestRunner.GetResultsWriter: TCustomResultsWriter;
begin
  case FormatParam of
    fLatex:         Result := TLatexResultsWriter.Create(nil);
    fPlain:         Result := TPlainResultsWriter.Create(nil);
  else
    begin
      Result := TXmlResultsWriter.Create(nil);
      ExtendXmlDocument(TXMLResultsWriter(Result).Document);
    end;
  end;
  Result.SkipTiming:=HasOption('skiptiming');
  Result.Sparse:=HasOption('sparse');
  Result.SkipAddressInfo:=HasOption('no-addresses');
end;

procedure TTestRunner.DoTestRun(ATest: TTest);
var
  ResultsWriter: TCustomResultsWriter;
  ProgressWriter: TProgressWriter;
  TestResult: TTestResult;
begin
  ResultsWriter := GetResultsWriter;
  ResultsWriter.Filename := FileName;
  TestResult := TTestResult.Create;
  try
    if ShowProgress then
    begin
      ProgressWriter := TProgressWriter.Create;
      TestResult.AddListener(ProgressWriter);
    end
    else
      ProgressWriter := nil;
    TestResult.AddListener(ResultsWriter);
    ATest.Run(TestResult);
    ResultsWriter.WriteResult(TestResult);
  finally
    TestResult.Free;
    ResultsWriter.Free;
    ProgressWriter.Free;
  end;
end;

function TTestRunner.GetShortOpts: string;
begin
  Result := ShortOpts;
end;

procedure TTestRunner.AppendLongOpts;
var
  i: Integer;
begin
  for i := low(DefaultLongOpts) to high(DefaultLongOpts) do
    LongOpts.Add(DefaultLongOpts[i]);
end;

procedure TTestRunner.WriteCustomHelp;
begin
  // no custom help options in base class;
end;

procedure TTestRunner.ParseOptions;
begin
  if HasOption('h', 'help') or ((ParamCount = 0) and not DefaultRunAllTests) then
  begin
    writeln(Title);
    writeln(Version);
    writeln;
    writeln('Usage: ');
    writeln('  --format=latex            output as latex source (only list implemented)');
    writeln('  --format=plain            output as plain ASCII source');
    writeln('  --format=xml              output as XML source (default)');
    writeln('  --skiptiming              Do not output timings (useful for diffs of testruns)');
    writeln('  --sparse                  Produce Less output (errors/failures only)');
    writeln('  --no-addresses            Do not display address info');
    writeln('  --stylesheet=<reference>   add stylesheet reference');
    writeln('  --file=<filename>         output results to file');
    writeln;
    writeln('  -l or --list              show a list of registered tests');
    writeln('  -a or --all               run all tests');
    writeln('  -p or --progress          show progress');
    writeln('  --suite=MyTestSuiteName   run single test suite class');
    WriteCustomHelp;
    writeln;
    writeln('The results can be redirected to an xml file,');
    writeln('for example: ', ParamStr(0),' --all > results.xml');
  end;

  //get the format parameter
  FormatParam := DefaultFormat;
  if HasOption('format') then
  begin
    if CompareText(GetOptionValue('format'),'latex')=0 then
      FormatParam := fLatex
    else if CompareText(GetOptionValue('format'),'plain')=0 then
      FormatParam := fPlain
    else if CompareText(GetOptionValue('format'),'plainnotiming')=0 then
      FormatParam := fPlainNoTiming
    else if CompareText(GetOptionValue('format'),'xml')=0 then
      FormatParam := fXML;
  end;

  ShowProgress := HasOption('p', 'progress');

  if HasOption('file') then
    FileName := GetOptionValue('file');
  if HasOption('stylesheet') then
    StyleSheet := GetOptionValue('stylesheet');
end;

procedure TTestRunner.ExtendXmlDocument(Doc: TXMLDocument);
var
  n: TDOMElement;
begin
  if StyleSheet<>'' then begin
    Doc.StylesheetType := 'text/xsl';
    Doc.StylesheetHRef := StyleSheet;
  end;
  n := Doc.CreateElement('Title');
  n.AppendChild(Doc.CreateTextNode(Title));
  Doc.FirstChild.AppendChild(n);
end;

constructor TTestRunner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLongOpts := TStringList.Create;
  AppendLongOpts;
end;

destructor TTestRunner.Destroy;
begin
  FLongOpts.Free;
  inherited Destroy;
end;

Type
  TTestDecoratorClass = Class of TTestDecorator;

  { TDecoratorTestSuite }

  TDecoratorTestSuite = Class(TTestSuite)
  public
    Procedure  FreeDecorators(T : TTest);
    Destructor Destroy; override;
  end;

Procedure  TDecoratorTestSuite.FreeDecorators(T : TTest);

Var
  I : Integer;
begin
  If (T is TTestSuite) then
    for I:=0 to TTestSuite(t).Tests.Count-1 do
      FreeDecorators(TTest(TTestSuite(t).Tests[i]));
  if (T is TTestDecorator) and (TTestDecorator(T).Test is TDecoratorTestSuite) then
    T.free;
end;

{ TDecoratorTestSuite }

destructor TDecoratorTestSuite.Destroy;
begin
  FreeDecorators(Self);
  Tests.Clear;
  inherited Destroy;
end;

procedure TTestRunner.DoRun;


  procedure CheckTestRegistry (test:TTest; ATestName:string; res : TTestSuite);
  var s, c : string;
      I, p : integer;
      ds : TTestSuite;
      D : TTestDecorator;

  begin
    if (test is TTestSuite) or (test is TTestDecorator) then
      begin
      p := pos ('.', ATestName);
      if p > 0 then
        begin
        s := copy (ATestName, 1, p-1);
        c := copy (ATestName, p+1, maxint);
        end
      else
        begin
        s := '';
        c := ATestName;
        end;
      if comparetext(c, test.TestName) = 0 then
        res.AddTest(test)
      else if (CompareText( s, Test.TestName) = 0) or (s = '') then
        begin
        if (test is ttestsuite) then
          begin
          for I := 0 to TTestSuite(test).Tests.Count - 1 do
             CheckTestRegistry (TTest((test as TTestSuite).Tests[I]), c, res)
          end
        else if (test is TTestDecorator) then
          begin
          DS:=TDecoratorTestSuite.Create;
          CheckTestRegistry(TTest((test as TTestDecorator).Test), c, ds);
          if (ds.CountTestCases>0) then
            begin
            D:=TTestDecoratorClass(Test.ClassType).Create(DS);
            Res.AddTest(D);
            end
          else
            DS.free;
          end;
        end;
      end
    else // if test is TTestCase then
      begin
      if comparetext(test.TestName, ATestName) = 0 then
        res.AddTest(test);
      end;
  end;

var
  I,P : integer;
  S : string;
  TS : TDecoratorTestSuite;
  
begin
  S := CheckOptions(GetShortOpts, LongOpts);
  if (S <> '') then
    Writeln(S);

  ParseOptions;

  //get a list of all registed tests
  if HasOption('l', 'list') then
    case FormatParam of
      fLatex:         Write(GetSuiteAsLatex(GetTestRegistry));
      fPlain:         Write(GetSuiteAsPlain(GetTestRegistry));
      fPlainNoTiming: Write(GetSuiteAsPlain(GetTestRegistry));
    else
      Write(GetSuiteAsLatex(GetTestRegistry));;
    end;

  //run the tests
  if HasOption('suite') then
  begin
    S := '';
    S := GetOptionValue('suite');
    if S = '' then
      for I := 0 to GetTestRegistry.Tests.Count - 1 do
        writeln(GetTestRegistry[i].TestName)
    else
      begin
        TS:=TDecoratorTestSuite.Create('SuiteList');
        try
        while Not(S = '') Do
          begin
            P:=Pos(',',S);
            if P = 0 Then
              begin
                for I := 0 to GetTestRegistry.Tests.count-1 do
                  CheckTestRegistry (GetTestregistry[I], S, TS);
                S := '';
              end
            else
              begin
                for I := 0 to GetTestRegistry.Tests.count-1 do
                  CheckTestRegistry (GetTestregistry[I],Copy(S, 1,P - 1), TS);
                Delete(S, 1, P);
              end;
          end;
          if (TS.CountTestCases>1) then
            DoTestRun(TS)
          else if TS.CountTestCases=1 then
            DoTestRun(TS[0])
          else
            Writeln('No tests selected.');  
        finally
          TS.Free;
        end;
      end;
  end
  else if HasOption('a', 'all') or (DefaultRunAllTests and Not HasOption('l','list')) then
    DoTestRun(GetTestRegistry) ;
  Terminate;
end;

end.

