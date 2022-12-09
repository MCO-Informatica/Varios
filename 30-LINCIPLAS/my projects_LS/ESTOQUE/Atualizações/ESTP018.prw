#INCLUDE "PROTHEUS.CH"

/*
+==========================================================+
|Programa: ESTP018 |Autor: Antonio Carlos |Data: 23/07/10  |
+==========================================================+
|Descricao: Este programa tem o objetivo realizar a inclu- |
|sao automatica do NF de Entrada conf. NF Saida.           |
+==========================================================+
|Uso: Laselva                                              |
+==========================================================+
*/

User Function ESTP018()

Local cCadastro	:= "Processa Documento de Entrada"
Local _lTela	:= .T.     

Private _cNumRom	:= Space(9)
		
While _lTela

	DEFINE MSDIALOG oDlg FROM 000,000 TO 220,400 TITLE cCadastro PIXEL

	@ 05,05 TO 80,200 PIXEL			

	@ 010,010 SAY "Esta rotina tem o objetivo de finalizar os romaneios pendentes devido  " PIXEL OF oDlg 
	@ 020,010 SAY "periodo de implantacao gerando os arquivos de Pre-Nota.                " PIXEL OF oDlg                              

	@ 050,050 SAY "Nota Fiscal : " PIXEL OF oDlg
	@ 050,100 MSGET oNumRom VAR _cNumRom SIZE 15,10 PIXEL OF oDlg

	@ 90,055 	BUTTON "Processa"		SIZE 040,015 OF oDlg PIXEL ACTION(LjMsgRun("Aguarde..., Finalizando Romaneio / Processando Nota Fiscal...",, {|| AtuDados() }) ) 
	@ 90,110 	BUTTON "Fechar"  		SIZE 040,015 OF oDlg PIXEL ACTION(_lTela := .F., oDlg:End()) 
  		
	ACTIVATE MSDIALOG oDlg CENTERED
	
EndDo	

Return

Static Function AtuDados()
      
Local _nReg			:= 0
Local nItens		:= "0001"
Local _cNumNF		:= Space(9)
Private aCabec     	:=  {}
Private aItens		:=  {}
Private aLinha      := 	{}
Private lMsErroAuto := .F.

DbSelectArea("SD2")
SD2->( DbSetOrder(3) )          
If SD2->( DbSeek("01"+_cNumRom+"1"+Space(2)+"000003"+"CL") )   

	While SD2->( !Eof() ) .And. SD2->D2_FILIAL == "01" .And. SD2->D2_DOC == _cNumRom .And. SD2->D2_SERIE == "1"+Space(2) 
		
		If Empty(_cNumNF)
			
			_cNumNF := SD2->D2_DOC
						
			Aadd(aCabec,{"F1_TIPO"    , "N"})
			Aadd(aCabec,{"F1_FORMUL"  , "N"})
			Aadd(aCabec,{"F1_DOC"     , SD2->D2_DOC})
			Aadd(aCabec,{"F1_SERIE"   , SD2->D2_SERIE})
			Aadd(aCabec,{"F1_EMISSAO" , dDataBase})
			Aadd(aCabec,{"F1_DTDIGIT" , dDataBase})
			Aadd(aCabec,{"F1_FORNECE" , "000001"})
			Aadd(aCabec,{"F1_LOJA"    , "01"})
			Aadd(aCabec,{"F1_ESPECIE" , "NF"})
			Aadd(aCabec,{"F1_COND"    , "025"})
						
		EndIf
					
		aLinha	:= {} 
				
		//Efetuar tratamento para a Tes de Devolucao
		DbSelectArea("SB1")
		SB1->( DbSetOrder(1) ) 
		SB1->( DbSeek(xFilial("SB1")+SD2->D2_COD ) )
		
		If SB1->B1_GRUPO $ GetMv("MV_GRPLIVR")
			_cTes := "001" 
		ElseIf SB1->B1_GRUPO $ GetMv("MV_GRPREVI")
			_cTes := "005" 
		ElseIf SB1->B1_GRUPO == "0001"	
			_cTes := "077" 		
		ElseIf SB1->B1_GRUPO == "0002"	
			_cTes := "077" 		
		ElseIf SB1->B1_GRUPO == "0010"	
			_cTes := "101" 				
		ElseIf SB1->B1_GRUPO == "0008"	
			_cTes := "077"	
		EndIf          
									
		Aadd(aLinha,{"D1_ITEM"    , strzero(len(aItens)+1,4) ,Nil})
//		Aadd(aLinha,{"D1_ITEM"    , SD2->D2_ITEM ,Nil})
		Aadd(aLinha,{"D1_COD"    , SD2->D2_COD ,Nil})
		Aadd(aLinha,{"D1_QUANT"  , SD2->D2_QUANT,Nil})
		Aadd(aLinha,{"D1_VUNIT"  , SD2->D2_PRCVEN,Nil})
		Aadd(aLinha,{"D1_TOTAL"  , SD2->D2_QUANT*SD2->D2_PRCVEN,Nil})
		Aadd(aLinha,{"D1_LOCAL"  , "01",Nil})
		Aadd(aLinha,{"D1_TES"    , _cTes,Nil})
					
		nItens := Soma1(nItens,4)
		aAdd(aItens,aLinha)
		_nReg++
				
		SD2->( DbSkip() )
					
	EndDo

Else

	MsgStop("NF Invalida!")
	Return(.F.)

EndIf

If _nReg > 0
	
	MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabec,aItens,3)
	
	If lMsErroAuto
		MostraErro()
	Else
		MsgInfo("Processamento efetuado com sucesso!")
	EndIf 

EndIf

Return