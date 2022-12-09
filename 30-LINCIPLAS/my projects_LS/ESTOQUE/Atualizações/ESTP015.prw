#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH" 

/*
+=============================================================+
|Programa: ESTP014 |Autor: Antonio Carlos |Data: 07/10/09     |
+=============================================================+
|Descrição: Rotina responsavel pela inclusão da NF de Entrada |
|ref. Devolução Simbolica de Coligadas.                       |
+=============================================================+
|Uso: Laselva                                                 |
+=============================================================+
*/

User Function ESTP014()
      
Local nOpca 	:= 0
Local aSays 	:= {}
Local aButtons  := {}
Private cCadastro	:= "Devolucao NF Simbolica - Laselva x Coligadas"

If SM0->M0_CODFIL <> "01"
	MsgStop("Essa rotina tem que ser executada na Laselva - Matriz !")
	Return(.F.)
EndIf

AADD(aSays,OemToAnsi( "Essa rotina tem por objetivo efetuar o processamento das Notas" ) ) 
AADD(aSays,OemToAnsi( "Fiscais de Devolucao Simbolica das Coligadas para a Laselva. " ) )
AADD(aSays,OemToAnsi( " " ) )

AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca <> 1
	Return NIL
EndIf

If MsgYesNo("Deseja executar esta rotina?")
	Processa( {|lEnd| GeraNFD()(@lEnd)}, "Aguarde...","Processando registros...", .T. )
EndIf	

Return Nil

Static Function GeraNFD(lEnd)

Local aArea		:= GetArea()

Local _cNumNF	:= Space(9)
Local _nReg		:= 0
Local _nCont	:= 0
Local nTotRec	:= 0
Local aCabec	:= {}
Local aLinha	:= {}	
Local aItens	:= {}     
Local nItens	:= "0001"       

Private lMsErroAuto := .F.

If Select("QRYAC") > 0
	DbSelectArea("QRYAC")
	DbCloseArea()
EndIf	

cQryAc := " SELECT * FROM SIGA.dbo.NFS_COLIGADA WHERE STATUS <> 'P' ORDER BY FILIAL "
TcQuery cQryAc NEW ALIAS "QRYAC"

Count To nTotRec
ProcRegua(nTotRec)

DbSelectArea("QRYAC")
QRYAC->( DbGoTop() )
If QRYAC->( !Eof() )

	While QRYAC->( !Eof() )
	
		IncProc("Processando...")

		Do Case
			Case Substr(QRYAC->FILIAL,1,1) == "G"
			_cCli := "000002"
			Case Substr(QRYAC->FILIAL,1,1) == "C"
			_cCli := "000003"
			Case Substr(QRYAC->FILIAL,1,1) == "A"
			_cCli := "000004"
			Case Substr(QRYAC->FILIAL,1,1) == "B"
			_cCli := "000004"		
			Case Substr(QRYAC->FILIAL,1,1) == "R"
			_cCli := "000005"
			Case Substr(QRYAC->FILIAL,1,1) == "T"
			_cCli := "000006"
		EndCase
		
		DbSelectArea("SD2")
		SD2->( DbSetOrder(3) )
		If SD2->( DbSeek(QRYAC->FILIAL+QRYAC->NF+QRYAC->SERIE+"000001"+"01") )
	
			While SD2->( !Eof() ) .And. SD2->D2_FILIAL == QRYAC->FILIAL .And. SD2->D2_DOC == QRYAC->NF .And. SD2->D2_SERIE == QRYAC->SERIE .And. SD2->D2_CLIENTE == "000001" .And. SD2->D2_LOJA == "01"
		
				If Empty(_cNumNF)
				
					_cNumNF := SD2->D2_DOC
						
					Aadd(aCabec,{"F1_TIPO"    , "N"})
					Aadd(aCabec,{"F1_FORMUL"  , "N"})
					Aadd(aCabec,{"F1_DOC"     , SD2->D2_DOC})
					Aadd(aCabec,{"F1_SERIE"   , SD2->D2_SERIE})
					Aadd(aCabec,{"F1_EMISSAO" , SD2->D2_EMISSAO})
					Aadd(aCabec,{"F1_DTDIGIT" , dDataBase})
					Aadd(aCabec,{"F1_FORNECE" , _cCli})
					Aadd(aCabec,{"F1_LOJA"    , QRYAC->FILIAL})
					Aadd(aCabec,{"F1_ESPECIE" , "NF"})
					Aadd(aCabec,{"F1_COND"    , "074"})
					
				EndIf
					
				aLinha	:= {} 
			
				//Efetuar tratamento para a Tes de Devolucao
				DbSelectArea("SB1")
				SB1->( DbSetOrder(1) ) 
				SB1->( DbSeek(xFilial("SB1")+SD2->D2_COD ) )
		    	
				_cTes := "070"
										
				Aadd(aLinha,{"D1_COD"    , SD2->D2_COD ,Nil})
				Aadd(aLinha,{"D1_QUANT"  , SD2->D2_QUANT,Nil})
				Aadd(aLinha,{"D1_VUNIT"  , SD2->D2_PRCVEN,Nil})
				Aadd(aLinha,{"D1_TOTAL"  , SD2->D2_QUANT*SD2->D2_PRCVEN,Nil})
				Aadd(aLinha,{"D1_LOCAL"  , "01",Nil})
				Aadd(aLinha,{"D1_TES"    , _cTes,Nil})
					
				nItens := Soma1(nItens)
				aAdd(aItens,aLinha)
				_nReg++
				
				SD2->( DbSkip() )
					
			EndDo
				
		EndIf	
	
		If _nReg > 0
	
			MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabec,aItens,3)
	
			If lMsErroAuto
				MostraErro()
				_nReg	:= 0 
				aCabec	:= {} 	
				aItens	:= {}
				_cNumNF := Space(9)
			Else	
				cQry := " UPDATE SIGA.dbo.NFS_COLIGADA SET STATUS = 'P' "
				TcSQLExec(cQry)
				_nReg := 0
				aCabec	:= {} 	
				aItens	:= {}
				_cNumNF := Space(9)
				_nCont++
			EndIf	
		
		EndIf
		
		QRYAC->( DbSkip() )
		
	EndDo	
	
	If _nCont > 0
		MsgInfo("Processamento realizado com sucesso!")
	Else
		MsgStop("Nao foi possivel realizar o processamento, favor verificar!")		
	EndIf	
	
Else	

	MsgStop("Nao existem registros para o processamento!")
	
EndIf	

RestArea(aArea)

Return