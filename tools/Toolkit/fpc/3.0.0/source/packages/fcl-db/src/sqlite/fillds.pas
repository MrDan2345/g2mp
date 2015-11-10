program fillds;

{$Mode ObjFpc}
{$H+}
{$define DEBUGHEAP}

//To test the sqlite3 version replace sqliteds by sqlite3ds
//  and TSqliteDataset by TSqlite3Dataset

uses 
{$ifdef DEBUGHEAP}
  Heaptrc,
{$endif}
{$ifdef Linux}
  cmem,
{$endif}
  sqliteds,
  sysutils,db,IniFiles;

const
  SQLITEDS_TESTS_INI_FILE = 'sqlitedstests.ini';
  DEFAULT_TABLENAME = 'tabletest';
  DEFAULT_FILENAME = 'test.db';
  MEMOTEST_FILENAME = 'createds.pas';

var 
  dsTest:TSqliteDataset;
  ini: TIniFile;

begin 
  {$ifdef DEBUGHEAP}
  SetHeapTraceOutput(ExtractFileName(ParamStr(0))+'.heap.log');
  {$endif}
  dsTest:=TSqliteDataset.Create(nil);
  with dsTest do
  begin
     //Load Database properties from a inifile
    ini:=TIniFile.Create(SQLITEDS_TESTS_INI_FILE);
    FileName:=ini.ReadString('testinfo','filename',DEFAULT_FILENAME);
    TableName:=ini.ReadString('testinfo','tablename',DEFAULT_TABLENAME);
    ini.Destroy;
    //Calling Open with an empty SQL, is the same of setting SQL to 'SELECT * from [TableName]';
    Open;
    //Add some dummy values
    Append;
    FieldByName('Integer').AsInteger:=100;
    FieldByName('String').AsString:='Luiz';
    FieldByName('Boolean').AsBoolean:= False;
    FieldByName('Float').AsFloat:=2;
    FieldByName('Word').AsInteger:=2763;
    FieldByName('DateTime').AsDateTime:=Now;
    FieldByName('Time').AsDateTime:=Time;
    FieldByName('Date').AsDateTime:=Date;
    FieldByName('Memo').AsString:='Here is a long text (Not so long in fact :-))';
    FieldByName('Currency').AsFloat:=1.23;
    FieldByName('LargeInt').AsLargeInt:=2163871263187263;
    Post;
    Append;
    FieldByName('Integer').AsInteger:=101;
    FieldByName('String').AsString:='Am�rico';
    FieldByName('Boolean').AsBoolean:= False;
    FieldByName('Float').AsFloat:=1.1;
    FieldByName('DateTime').AsDateTime:=Now;
    FieldByName('Time').AsDateTime:=Time;
    FieldByName('Date').AsDateTime:=Date;
    FieldByName('LargeInt').AsLargeInt:=-9223372036854775808;
    //a real long text :-).
    if FileExists(MEMOTEST_FILENAME) then
      TMemoField(FieldByName('Memo')).LoadFromFile(MEMOTEST_FILENAME);
    Post;
    Append;
    FieldByName('Integer').AsInteger:=102;
    FieldByName('String').AsString:='Ana';
    FieldByName('Boolean').AsBoolean:= False;
    FieldByName('Float').AsFloat:=5.0E-324;
    FieldByName('DateTime').AsDateTime:=Now;
    FieldByName('Time').AsDateTime:=Time;
    FieldByName('Date').AsDateTime:=Date;
    FieldByName('LargeInt').AsLargeInt:=9223372036854775807;
    Post;
    Append;
    FieldByName('Integer').AsInteger:=103;
    FieldByName('String').AsString:='Luiza';
    FieldByName('Boolean').AsBoolean:= True;
    FieldByName('Float').AsFloat:=1.7E308;
    FieldByName('DateTime').AsDateTime:=Now;
    FieldByName('Time').AsDateTime:=Time;
    FieldByName('Date').AsDateTime:=Date;
    FieldByName('Currency').AsFloat:=20.08;
    Post;
    //Save the added data to database
    ApplyUpdates;
    writeln('ReturnString after ApplyUpdates: ',ReturnString);
    //Is not necessary to call Close. Destroy will call it.
    //Close;
    Destroy;
  end;
end.
