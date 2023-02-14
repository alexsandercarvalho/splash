unit UnitSplashX;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TextFade, Registry, DB, DBTables, StdCtrls, jpeg;

type
    TSplashX = class(TForm)
    Shutdown: TTimer;
    TextFader1: TTextFader;
    Eval: TListBox;
    NewEval: TEdit;
    Image1: TImage;
    HDNUM: TLabel;
    HDNCRP: TLabel;
    txtkeyreg: TLabel;
    prazo: TLabel;
    procedure ShutdownTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
   procedure MakeSplash;                 /// declaramos o MakeSplash ...
    { Public declarations }
  end;

var
  SplashX: TSplashX;
  Bitmap:tBitmap;
  tnet:variant;
  xTrial:variant;
  ArqTrial:TextFile;
  SystemDir:Array[0..MAX_PATH]of char;
textTrial:string;
pos:integer;
Xshift :integer;

Result:STRING;
HDNCRPs : string;


implementation

uses UnitFinancer, UnitDataModule1, UnitRegistro;



{$R *.dfm}

type
TLangInfoBuffer = array [1..4] of SmallInt;


procedure TSplashX.MakeSplash;        /// procedimento  MakeSplash ...
Var
Serial:DWord;
DirLen,Flags: DWord;
DLabel : Array[0..11] of Char;

begin
Try GetVolumeInformation(PChar('C:\'),dLabel,12,@Serial,DirLen,Flags,nil,0);
Result := IntToHex(Serial,8);
Except Result :='';
end;
  HDNUM.Caption:=Result;
                               /// refaz o form para ser apresentado ...
  BorderStyle := bsNone;                /// na abertura do sistema ...
  FormStyle := fsStayOnTop;
  Show;
  Update;
end;


procedure TSplashX.ShutdownTimer(Sender: TObject);
begin
tnet:=tnet - 1;
AlphaBlendValue:=tnet;
if tnet=0 then
begin
Close;
Release;
end;
end;

procedure TSplashX.FormActivate(Sender: TObject);
begin
tnet:=255;
end;

procedure TSplashX.FormShow(Sender: TObject);
var
Registro : TRegistry;
  S: String;

    pos : integer;
    shift :integer;
begin

HDNCRPs := HDNUM.caption;
      shift := StrToInt('#####'); /// chave do trial
      for pos := 1 to length(HDNCRPs) do
      HDNCRPs[pos] := chr(ord(HDNCRPs[pos]) + shift);
      HDNCRP.caption := HDNCRPs;

//LerRegistro;

/// ---> 1º- Obtenho o System32 <--- \\\
GetSystemDirectory(@SystemDir,MAX_PATH);
AssignFile( ArqTrial, SystemDir+'\smss.sys'  );
xTrial:='0';
/// ---> 2º- Procuro Pelo Arquivo <--- \\\
             if fileexists((SystemDir)+'\smss.sys')
               then
                  begin

// Descriptografo  

        Eval.Items.LoadFromFile((SystemDir)+'\smss.sys');
        textTrial:=Eval.Items[0];
        Xshift:=75;
        for pos := 1 to length(textTrial) do
        textTrial[pos]:=chr(ord(textTrial[pos]) - Xshift);

              end
                else
                  begin

// Se não o encontra o arquivo o Cria  
                  ReWrite( ArqTrial, SystemDir+'\smss.sys'  );
                  Append(ArqTrial);
                  CloseFile( ArqTrial );
                end;
/// ---> 3º-Obtenho o Valor e efetuo Calculo <--- \\\
        xTrial:=textTrial;
//  Me previne com o Arquivo Vazio
        if xTrial='' then xTrial:='0';
//  Calculo o novo valor
        xTrial:=xTrial+1;
            prazo.Caption:=textTrial;

// Criptografo                        
 
        textTrial:=xTrial;
        Xshift:=75;
        for pos := 1 to length(textTrial) do
        textTrial[pos]:=chr(ord(textTrial[pos]) + Xshift);
/// --> Retorno com o Valor para API !!!
        NewEval.Text:=textTrial;
 
// Reescrevo o Valor Criptografado e Recalculado no arquivo 
        ReWrite( ArqTrial, SystemDir+'\smss.sys'  );
        WriteLn( ArqTrial, textTrial ); // Escreve no arquivo
        CloseFile( ArqTrial );
/// ---> 4º-Testo o Valor Recalculado <--- \\\
{*******************************************************************************
*                                                                              *
*                         ---> Bloqueio da API <---                            *
*                                                                              *
*******************************************************************************}

if (xTrial=100)or(xTrial>100) then begin

Registro := TRegistry.Create;
with Registro do
  begin
RootKey := HKEY_CLASSES_ROOT;

if  OpenKey ('SOFTWARE\{8B873B229BBE-F49CF340B3-B2A0E332FD}', False) then  
if ValueExists ('') then

 s:= ReadString ('');


Registro.CloseKey;
Registro.Free;


if s <> HDNCRPs then
begin

showmessage('Prazo de experiência desta versão se esgotou !!!'+#13+#10+'Entre em contato com o Suporte'+#13+#10+'(31) 3731-7439');
Application.Terminate; 
/// este telefone não é meu telefone atual

end
else
begin

        xTrial:='0';
        textTrial:=xTrial;
        Xshift:=75;
        for pos := 1 to length(textTrial) do
        textTrial[pos]:=chr(ord(textTrial[pos]) + Xshift);
/// --> Retorno com o Valor para API !!!
        NewEval.Text:=textTrial;
         ReWrite( ArqTrial, SystemDir+'\smss.sys'  );
        WriteLn( ArqTrial, textTrial ); // Escreve no arquivo
        CloseFile( ArqTrial );
end;
end;
end;
end;

procedure TSplashX.FormClose(Sender: TObject; var Action: TCloseAction);
begin
DataModule1.ACCESS.OPEN;
DataModule1.ACCESS.edit;
DataModule1.ACCESSACESSO.AsString:=xTrial;

DataModule1.ACCESS.ApplyUpdates;
DataModule1.ACCESS.CommitUpdates;
DataModule1.ACCESS.close;
end;

end.
