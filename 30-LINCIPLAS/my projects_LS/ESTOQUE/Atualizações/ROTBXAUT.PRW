#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*
+==================+======================+================+
|Programa: SF2460I |Autor: Antonio Carlos |Data: 13/03/08  |
+==================+======================+================+
|Descricao: Ponto de Entrada utilizado no final da grava   |
|cao do SF2, onde sao processados Pedido de Compra/Pre-Nota|
|para acerto de Consignacao.                               |
+==========================================================+
|Uso: Laselva                                              |
+==========================================================+
*/

User Function ROTBXAUT()

Local cCadastro    	:= "Gera NF de Entrada"
Local aSays        	:= {}
Local aButtons     	:= {}
Local nOpc        	:= 0
Local oDlg
Private oProcess              
Private lMsErroAuto	:= .F.


AADD(aSays,OemToAnsi("Este programa tem o objetivo de processar automaticamente"))
AADD(aSays,OemToAnsi("a entrada de NF nas Lojas."))

AADD(aButtons, { 1,.T.,{|o| nOpc:= 1,If(MsgYesNo(OemToAnsi("Confirma processamento?"),OemToAnsi("Atenção")),o:oWnd:End(),nOpc:=0) } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons,,200,405 )
	
If nOpc == 1
	LjMsgRun("Aguarde..., Processando registros...",, {|| GeraEnt() })
EndIf
	
Return
	
Static Function GeraEnt()
	
Local aArea		:= GetArea()
Local _nReg		:= 0
Local _nQtde	:= 0
Local nItens	:= "01"
Local _cNumPed	:= Space(6)
Local aCabec	:= {}
Local aLinha	:= {}
Local aItens	:= {}
Local _cTes		:= "063"           

cQuery := " SELECT C6_CLI,C6_LOJA,C6_PRODUTO,C6_QTDVEN,C6_PRCVEN,C6_ITEMORI,C6_NFORI,C6_SERIORI,C6_IDENTB6 "
cQuery += " FROM "+RetSqlName("SC6") + " SC6 (NOLOCK)" 
cQuery += " WHERE "
cQuery += " C6_FILIAL='R4' AND C6_NUM IN ('000154','000155','000156','000157','000158','000159','000160','000161','000162','000163','000164','000165','000166') "
cQuery += " ORDER BY C6_CLI, C6_LOJA, C6_NFORI, C6_SERIORI, C6_PRODUTO "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMP", .F., .T.)	
	
DbSelectArea("TMP")
TMP->( DbGoTop() )
If TMP->( !Eof() )

	While TMP->( !Eof() ) 
		
		aCabec	:= {}   
		aItens  := {}   
		
		cFornece := TMP->C6_CLI
		cLoja    := TMP->C6_LOJA
		cNota    := TMP->C6_NFORI
		cSerie   := TMP->C6_SERIORI	
			
		While TMP->( !Eof() ) .And. TMP->C6_CLI == cFornece .And. TMP->C6_LOJA ==  cLoja .And. TMP->C6_NFORI == cNota .And. TMP->C6_SERIORI == cSerie
		
			If Empty(_cNumPed)
				_cNumPed := TMP->C6_NFORI
						
				DbSelectArea("SA2")
				SA2->(DbSetOrder(1))
				SA2->(DbSeek(xFilial("SA2")+TMP->C6_CLI+TMP->C6_LOJA))
						
				Aadd(aCabec,{"F1_TIPO"    , "N"})
				Aadd(aCabec,{"F1_FORMUL"  , "N"})
				Aadd(aCabec,{"F1_DOC"     , TMP->C6_NFORI})
				Aadd(aCabec,{"F1_SERIE"   , TMP->C6_SERIORI})
				Aadd(aCabec,{"F1_EMISSAO" , dDataBase})
				Aadd(aCabec,{"F1_DTDIGIT" , dDataBase})
				Aadd(aCabec,{"F1_FORNECE" , TMP->C6_CLI})
				Aadd(aCabec,{"F1_LOJA"    , TMP->C6_LOJA})
				Aadd(aCabec,{"F1_ESPECIE" , "NFE"})
				Aadd(aCabec,{"F1_COND"    , SA2->A2_COND})
			EndIf
					
				aLinha	:= {} 
				
				If SD2->D2_GRUPO $ ("0001/0002/0008") 
					_cTes := "002"
				Else 
					_cTes := "001"					
				EndIf	
									
				Aadd(aLinha,{"D1_COD"    , TMP->C6_PRODUTO ,Nil})
				Aadd(aLinha,{"D1_QUANT"  , TMP->C6_QTDVEN,Nil})
				Aadd(aLinha,{"D1_VUNIT"  , TMP->C6_PRCVEN,Nil})
				Aadd(aLinha,{"D1_TOTAL"  , TMP->C6_QTDVEN*TMP->C6_PRCVEN,Nil})
				Aadd(aLinha,{"D1_LOCAL"  , "01",Nil})
				Aadd(aLinha,{"D1_TES"    , _cTes,Nil})
					
				nItens := Soma1(nItens)
				aAdd(aItens,aLinha)
				_nReg++
					
				TMP->( DbSkip() )
					
		EndDo
					
		If _nReg > 0
			MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabec,aItens,3)
			If lMsErroAuto
				MostraErro()
				If ( __lSX8)
					RollBackSX8()
				EndIf
				DisarmTransaction()
			Else
				If ( __lSX8)
					ConfirmSX8()
				EndIf
			EndIf

			_cNumPed := ''
			
			aCabec	:= {}   
			aItens  := {}
			_nReg	:= 0
			
		EndIf
				
	EndDo    

EndIf               
	
MsgStop("Rotina executada com sucesso!!!")
	
DbSelectArea("TMP")
DbCloseArea()
	
RestArea(aArea)
	
Return 

/*
User Function ROTBXAUT()

Local cCadastro    	:= "Gera NF de Entrada"
Local aSays        	:= {}
Local aButtons     	:= {}
Local nOpc        	:= 0
Local oDlg
Private oProcess              
Private lMsErroAuto	:= .F.


AADD(aSays,OemToAnsi("Este programa tem o objetivo de processar automaticamente"))
AADD(aSays,OemToAnsi("a entrada de NF nas Lojas."))

AADD(aButtons, { 1,.T.,{|o| nOpc:= 1,If(MsgYesNo(OemToAnsi("Confirma processamento?"),OemToAnsi("Atenção")),o:oWnd:End(),nOpc:=0) } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons,,200,405 )
	
If nOpc == 1
	LjMsgRun("Aguarde..., Processando registros...",, {|| GeraEnt() })
EndIf
	
Return
	
Static Function GeraEnt()
	
Local aArea		:= GetArea()
Local _nReg		:= 0
Local _nQtde	:= 0
Local nItens	:= "01"
Local _cNumPed	:= Space(6)
Local aCabec	:= {}
Local aLinha	:= {}
Local aItens	:= {}
Local _cTes
	
cQuery := " SELECT F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA "
cQuery += " FROM "+RetSqlName("SF2") + " SF2 (NOLOCK)" 
cQuery += " WHERE "
cQuery += " F2_FILIAL = 'R4' AND "
cQuery += " F2_EMISSAO = '20090211' AND "
cQuery += " F2_CLIENTE = '000004' AND "
cQuery += " F2_LOJA = 'A2' AND "
cQuery += " SF2.D_E_L_E_T_ = '' "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .F., .T.)
	
DbSelectArea("QRY")
QRY->( DbGoTop() )
If QRY->( !Eof() )

	While QRY->( !Eof() ) 
		
		DbSelectArea("SD2")
		SD2->( DbSetOrder(3) )     
		
		aCabec	:= {}   
		aItens  := {}
			
		If SD2->( DbSeek('R4' + QRY->F2_DOC + QRY->F2_SERIE + QRY->F2_CLIENTE + QRY->F2_LOJA) )
			
			While SD2->( !Eof() ) .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+;
				SD2->D2_LOJA == QRY->F2_FILIAL+QRY->F2_DOC+QRY->F2_SERIE+QRY->F2_CLIENTE+QRY->F2_LOJA
					
				If Empty(_cNumPed)
					_cNumPed := SD2->D2_DOC
						
					DbSelectArea("SA2")
					SA2->(DbSetOrder(1))
					SA2->(DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA))
						
					Aadd(aCabec,{"F1_TIPO"    , "N"})
					Aadd(aCabec,{"F1_FORMUL"  , "N"})
					Aadd(aCabec,{"F1_DOC"     , SD2->D2_DOC})
					Aadd(aCabec,{"F1_SERIE"   , SD2->D2_SERIE})
					Aadd(aCabec,{"F1_EMISSAO" , dDataBase})
					Aadd(aCabec,{"F1_DTDIGIT" , dDataBase})
					Aadd(aCabec,{"F1_FORNECE" , "000005"})
					Aadd(aCabec,{"F1_LOJA"    , "R4"})
					Aadd(aCabec,{"F1_ESPECIE" , "NFE"})
					Aadd(aCabec,{"F1_COND"    , SA2->A2_COND})
				EndIf
					
				aLinha	:= {} 
				
				If SD2->D2_GRUPO $ ("0001/0002/0008") 
					_cTes := "002"
				Else 
					_cTes := "001"					
				EndIf	
									
				Aadd(aLinha,{"D1_COD"    , SD2->D2_COD ,Nil})
				Aadd(aLinha,{"D1_QUANT"  , SD2->D2_QUANT,Nil})
				Aadd(aLinha,{"D1_VUNIT"  , SD2->D2_PRCVEN,Nil})
				Aadd(aLinha,{"D1_TOTAL"  , SD2->D2_QUANT*SD2->D2_PRCVEN,Nil})
				Aadd(aLinha,{"D1_LOCAL"  , SD2->D2_LOCAL,Nil})
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
				If ( __lSX8)
					RollBackSX8()
				EndIf
				DisarmTransaction()
			Else
				If ( __lSX8)
					ConfirmSX8()
				EndIf
			EndIf

			_cNumPed := ''
			
			aCabec	:= {}   
			aItens  := {}
			_nReg	:= 0
			
		EndIf
			
		QRY->(dbskip())
			
	EndDo    

EndIf               
	
MsgStop("Rotina executada com sucesso!!!")
	
DbSelectArea("QRY")
DbCloseArea()
	
RestArea(aArea)
	
Return       
*/