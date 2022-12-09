#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M320FIM ºAutor  ³Ricardo Souza     º Data ³  08/04/2018     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Regrava o custo standard dos produtos especiais de acordo   º±±
±±º          ³com a data mais atual do custo standard do produto padrao   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - Especifico Ancora.                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M320FIM()

local _aArea	:=	GetArea()

If MsgYesNo("Deseja Reorganizar o Custo Standard?")
	
_cSQL := "UPDATE SB1010 SET B1_UTILIZ = '' WHERE B1_UTILIZ = 'PROD ESTRUT'" 
TcSqlExec(_cSQL)            

	dbSelectArea("SB1")
	dbSetOrder(15)
	dbGoBottom()
	
	While !Bof()
		
		//----> GUARDA AS INFORMACOES ATUAIS DE CUSTO STANDARD DO PRODUTO
		_nRecAtu	:= 	Recno()
		_nCustd		:= 	SB1->B1_CUSTD
		_dCustdOrig	:=	SB1->B1_DATREF
		_cProdOrig	:=	SB1->B1_COD
		
		/*
		If Alltrim(SB1->B1_UTILIZ)$"PROD ESTRUT"
			ALERT("Limpando Prod Orig "+Alltrim(_cProdOrig)+" - Utiliz "+Alltrim(SB1->B1_UTILIZ))
			RecLock("SB1",.f.)
			SB1->B1_UTILIZ	:=	""
			MsUnLock()
		EndIf
		*/

		If !Empty(SB1->B1_X_ALTER)
		
			_cProdDest	:=	Subs(SB1->B1_X_ALTER,1,15)
		
		ElseIf Len(Alltrim(SB1->B1_COD))>9
		
			//----> VERIFICA SE EXISTE PRODUTO ESPECIAL
			If Subs(SB1->B1_COD,1,1)$"Z"
				_cProdDest	:=	Subs(SB1->B1_COD,2,15)
		
			//----> CASO CONTRARIO PEGA PRODUTO PADRAO
			Else
				_cProdDest	:=	"Z"+Subs(SB1->B1_COD,1,15)
			EndIf
		Else
			//----> VERIFICA SE EXISTE PRODUTO ESPECIAL
			If Subs(SB1->B1_COD,1,1)$"Z"
				_cProdDest	:=	Subs(SB1->B1_COD,2,15)
		
			//----> CASO CONTRARIO PEGA PRODUTO PADRAO
			Else
				_cProdDest	:=	"Z"+Subs(SB1->B1_COD,1,15)
			EndIf
		Endif
		
		If _cProdOrig <> _cProdDest

			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+_cProdDest,.f.)

				_dCustdDest	:=	SB1->B1_DATREF
				_nCustdDest	:=	SB1->B1_CUSTD

				If _dCustdOrig == _dCustdDest
					
					dbSelectArea("SG1")
					dbSetOrder(1)
					If dbSeek(xFilial("SG1")+_cProdDest,.f.)
						If _nCustd <> _nCustdDest			
						
							ALERT("Prod Orig "+Alltrim(_cProdOrig)+" - Prod Dest "+Alltrim(_cProdDest)+" - Custo Diferente")

							RecLock("SB1",.f.)
							SB1->B1_UTILIZ	:=	"PROD ESTRUT"
							MsUnLock()
				
							dbSelectArea("SB1")
							dbSetOrder(1)
							If dbSeek(xFilial("SB1")+_cProdOrig,.f.)
								RecLock("SB1",.f.)
								SB1->B1_UTILIZ	:=	"PROD ESTRUT"
								MsUnLock()
							EndIf

							dbSelectArea("SB1")
							dbSetOrder(1)
							dbSeek(xFilial("SB1")+_cProdDest,.f.)
						Else
							RecLock("SB1",.f.)
							SB1->B1_CUSTD	:=	_nCustd
							SB1->B1_DATREF	:=	_dCustdOrig
							MsUnLock()
						EndIf
					Else
						dbSelectArea("SG1")
						dbSetOrder(1)
						If dbSeek(xFilial("SG1")+_cProdOrig,.f.)
							If _nCustd <> _nCustdDest			
							
								ALERT("Prod Orig "+Alltrim(_cProdOrig)+" - Prod Dest "+Alltrim(_cProdDest)+" - Custo Diferente")

								RecLock("SB1",.f.)
								SB1->B1_UTILIZ	:=	"PROD ESTRUT"
								MsUnLock()
					
								dbSelectArea("SB1")
								dbSetOrder(1)
								If dbSeek(xFilial("SB1")+_cProdOrig,.f.)
									RecLock("SB1",.f.)
									SB1->B1_UTILIZ	:=	"PROD ESTRUT"
									MsUnLock()
								EndIf

								dbSelectArea("SB1")
								dbSetOrder(1)
								dbSeek(xFilial("SB1")+_cProdDest,.f.)
							Else
								RecLock("SB1",.f.)
								SB1->B1_CUSTD	:=	_nCustd
								SB1->B1_DATREF	:=	_dCustdOrig
								MsUnLock()
							EndIf
						Else
							RecLock("SB1",.f.)
							SB1->B1_CUSTD	:=	_nCustd
							SB1->B1_DATREF	:=	_dCustdOrig
							MsUnLock()
						EndIf
					EndIf	
				ElseIf _dCustdOrig > _dCustdDest
					RecLock("SB1",.f.)
					SB1->B1_CUSTD	:=	_nCustd
					SB1->B1_DATREF	:=	_dCustdOrig
					MsUnLock()
				EndIf
			Else
				RecLock("SB1",.f.)
				SB1->B1_CUSTD	:=	_nCustd
				SB1->B1_DATREF	:=	_dCustdOrig
				MsUnLock()
			EndIf
		EndIf
		
		dbSelectArea("SB1")
		dbGoTo(_nRecAtu)

		ALERT("ANTES DO DBKSIP "+SB1->B1_COD)

		dbSkip(-1)
	EndDo
EndIf
RestArea(_aArea)

Return
