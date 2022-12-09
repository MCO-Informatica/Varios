#include "topconn.ch"
#include "protheus.ch"
//#include "inkey.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#DEFINE DIRXML  "XMLNFE\"
#DEFINE DIRALER "NEW\"
#DEFINE DIRLIDO "OLD\"
#DEFINE DIRERRO "ERR\" 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCOMR03   บAutor  ณFelipi Marques      บ Data ณ  03/29/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChamada de Job ou Rotinas                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  U_MCOMR01("99","",.T.,.T.)                            
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function MCOMR03( cXEmp, cXFil, lJob, lWS )

Local aFiles := {}
Local nX	 := 0
Local aProc  := {}
Local aErros := {}
Local cTpAmb		
Local cUfAutor	
Local cCNPJ		
Local cQuery		:= ""       
Local cAlias		:= GetNextAlias()
Local nSemaForo

Private cStartLido	:= Trim(DIRXML)+DIRLIDO
Private c2StartPath	:= Trim(cStartLido)+AllTrim(Str(Year(Date())))+"\"     //MES
Private c3StartPath	:= Trim(c2StartPath)+AllTrim(Str(Month(Date())))+"\"   //DIA	

//-- Prepara estrutura de diretorios
If !ExistDir(DIRXML)
	MakeDir(DIRXML)
	MakeDir(DIRXML +DIRALER)
	MakeDir(DIRXML +DIRLIDO)
	MakeDir(DIRXML +DIRERRO)
EndIf

If lJob

	//-- Loga empresa e filial
	RpcSetType(3)
	RpcSetEnv(cXEmp,cXFil,,,"COM")
	  
	If ( nSemaforo := MsFCreate(GetNewPar("ES_SEMACHV","JOB"+cEmpAnt+".lck") ) ) < 0	
		Conout("Interface em Uso. Processamento do JOB MCOMR02 - Empresa: " + cEmpAnt + " - " + Time() + " cancelado...")
	Else 
	 	//-- Processa importacao dos arquivos baixados
		aFiles := Directory("\" +DIRXML +DIRALER +"*.xml")
		For nX := 1 To Len(aFiles)
			U_COMxXMLImp(aFiles[nX,1],lJob,@aProc,@aErros)
		Next nX
    EndIf
    RpcClearEnv()
	Fclose(nSemaForo)
	Ferase("JOB"+cEmpAnt+".lck")

Else
	Conout("Inicio do manifesto e download das Nfe junto a SEFAZ.")
	Conout("Gerar arquivo de semaforo ... " + Time() )
	        
	If ( nSemaforo := MsFCreate(GetNewPar("ES_SEMACHV","JOB"+cEmpAnt+".lck") ) ) < 0	
		MsgAlert(OemToAnsi("A Rotina de Download do XML das NFe's esta sendo utilizada por")+ENTER+;
		OemToAnsi("outro usuario. Por questoes de integridade de dados, nao")+ENTER+;
		OemToAnsi(" permitida a utilizao desta rotina por mais de um usu rio")+ENTER+;
		OemToAnsi("simultaneamente. Tente novamente mais tarde."),"Aten็ใo")
	Else  
	    //-- Processa importacao dos arquivos baixados
		aFiles := Directory("\" +DIRXML +DIRALER +"*.xml")
		For nX := 1 To Len(aFiles)
			U_COMxXMLImp(aFiles[nX,1],lJob,@aProc,@aErros)
		Next nX
		
		Fclose(nSemaForo)
		Ferase("MCOMR01"+cEmpAnt+".lck")
	EndIf	
EndIf
	
Return