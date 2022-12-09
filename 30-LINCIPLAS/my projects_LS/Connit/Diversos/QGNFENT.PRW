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

User Function QGNFENT()

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
	
	/*
	cQuery := " SELECT * "
	cQuery += " FROM "	+RetSqlName("SF2")+" SF2 (NOLOCK)"
	cQuery += " WHERE "
	cQuery += " F2_FILIAL = '01' AND "
	cQuery += " F2_DOC = '014109' AND F2_SERIE = '1' AND "
	cQuery += " SF2.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY F2_FILIAL, F2_EMISSAO, F2_DOC, F2_SERIE "
	

	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .F., .T.)
	*/
	
	
	cQuery := " SELECT * FROM NFENTRADA WHERE F2_LOJA = '" + XFILIAL("SF2") +"'"

	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .F., .T.)
	
	
	
	DbSelectArea("QRY")
	QRY->(DbGoTop())
	If QRY->(!Eof())

	
		While QRY->(!Eof()) 
		
			DbSelectArea("SD2")
			SD2->(DbSetOrder(3))     
			aCabec	:= {}   
			aItens  := {}
			
			If SD2->(DbSeek('01' + QRY->F2_DOC + QRY->F2_SERIE + QRY->F2_CLIENTE + QRY->F2_LOJA))
				While SD2->(!Eof()) .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+;
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
						Aadd(aCabec,{"F1_FORNECE" , "000001"})
						Aadd(aCabec,{"F1_LOJA"    , "01"})
						Aadd(aCabec,{"F1_ESPECIE" , "NFE"})
						Aadd(aCabec,{"F1_COND"    , SA2->A2_COND})
					EndIf
					
					aLinha	:= {}
					
					Aadd(aLinha,{"D1_COD"    , SD2->D2_COD ,Nil})
					Aadd(aLinha,{"D1_QUANT"  , SD2->D2_QUANT,Nil})
					Aadd(aLinha,{"D1_VUNIT"  , SD2->D2_PRCVEN,Nil})
					Aadd(aLinha,{"D1_TOTAL"  , SD2->D2_QUANT*SD2->D2_PRCVEN,Nil})
					Aadd(aLinha,{"D1_LOCAL"  , SD2->D2_LOCAL,Nil})
					//Aadd(aLinha,{"D1_TES"    ,GetMv("MV_TESCCO"),Nil})
					
					nItens := Soma1(nItens)
					aAdd(aItens,aLinha)
					_nReg++
					
					SD2->(DbSkip())
					
				EndDo
				
			EndIf
			
			If _nReg > 0
				MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)
				If lMsErroAuto
					MostraErro()
					If ( __lSX8)
						RollBackSX8()
					EndIf
					DisarmTransaction()
				Else
					If ( __lSX8)
						ConfirmSX8()
						//Aviso("Acerto de Consignacao","Pedido de Compra: "+_cNumPed,{"Ok"})
					EndIf
				EndIf

				_cNumPed := ''
				aItens	 := {}
			EndIf
			
			QRY->(dbskip())
			
		EndDo    

	EndIf               
	
	
	
	MsgStop("Rotina executada com sucesso!!!")
	
	DbSelectArea("QRY")
	DbCloseArea()
	
	RestArea(aArea)
	
	Return
