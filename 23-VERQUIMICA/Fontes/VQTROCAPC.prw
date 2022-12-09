#include "rwmake.ch"
#include "protheus.ch"

User Function VQTROCAPC()

Local _aArea	 	:=	GetArea()
Private _cProdEXC 	:=	Space(15)
Private _cProdINC 	:=	Space(15)
Private _cPedido  	:=	Space(06)

@ 000,000 TO 300,500 DIALOG oDlg1 TITLE "Troca Produto - Pedido Compra"
//@ 010,010 TO 290,490
@ 020,050 SAY OemToAnsi("Esta rotina tem como objetivo executar a troca de produto no Pedido de Compra")	of oDlg1	SIZE 250,20 Pixel
@ 050,010 SAY OemToAnsi("Pedido Compra:")					of oDlg1	SIZE 100,20 Pixel
@ 050,080 GET _cPedido  Picture "@!"  F3("SC7")	Valid Pedido()			SIZE 100,20
@ 065,010 SAY OemToAnsi("Produto a excluir:")				of oDlg1	SIZE 100,20 Pixel
@ 065,080 GET _cProdEXC Picture "@!"  F3("SB1") Valid ProdExc()		 	SIZE 100,20
@ 080,010 SAY OemToAnsi("Produto a incluir:")				of oDlg1	SIZE 100,20	Pixel
@ 080,080 GET _cProdINC Picture "@!"  F3("SB1")	Valid ProdInc()		 	SIZE 100,20
@ 110,100 BMPBUTTON TYPE 1 ACTION TROCA()  
@ 110,135 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

ACTIVATE DIALOG oDlg1 Center

RestArea(_aArea)

RETURN


Static Function TROCA()              

_cMsg		:= 	""
_cEOF		:=	Chr(13)+Chr(10)
_cGrupOld	:=	Posicione("SB1",1,xFilial("SB1")+_cProdEXC,"B1_GRUPO")
_cGrupNew	:=  Posicione("SB1",1,xFilial("SB1")+_cProdINC,"B1_GRUPO")                                              


//----> VERIFICA SE O GRUPO DO PRODUTO A SER EXCLUIDO E IGUAL AO GRUPO DO PRODUTO A SER INCLUIDO
If _cGrupOld <> _cGrupNew
	MsgBox("O produto a ser incluído tem grupo divergente do grupo do produto a ser excluído. Não é permitido trocar.")
	Close(oDlg1)
	Return
EndIf


//----> VERIFICA SE O PRODUTO A SER EXCLUIDO EXISTE NO PEDIDO DE COMPRA
dbSelectArea("SC7")
dbSetOrder(4)
dbGoTop()
If !dbSeek(xFilial("SC7")+_cProdEXC+_cPedido,.f.)
	MsgBox(" O produto "+Alltrim(_cProdEXC)+" a ser excluído nao consta no pedido de compra "+_cPedido+".")
	Close(oDlg1)
   Return
Else
	If MsgBox("Tem certeza da troca do produto "+Alltrim(_cProdEXC)+" por "+Alltrim(_cProdINC)+" ?","Atenção","YESNO")
   		While Eof() == .f. .And. SC7->C7_PRODUTO == _cProdExc .and. SC7->C7_NUM == _cPedido
   		    
   		    //----> VERIFICA SE O PEDIDO ENCONTRA-SE BLOQUEADO
   		    If SC7->C7_CONAPRO$"B"
   		    	MsgBox("O pedido "+SC7->C7_NUM+ "encontra-se bloqueado. Por este motivo não poderá ser alterado.")
				Close(oDlg1)
				Return
   		    EndIf
   			
   		    //----> VERIFICA SE O PEDIDO ENCONTRA-SE ATENDIDO
   			If SC7->C7_QUJE >= SC7->C7_QUANT
   		    	MsgBox("O pedido "+SC7->C7_NUM+ "já foi totalmente atendido. Por este motivo não poderá ser alterado.")
				Close(oDlg1)
				Return
   		    EndIf
   			
   		    //----> VERIFICA SE O PEDIDO ENCONTRA-SE COM RESIDUO ELIMINADO
   			If !Empty(SC7->C7_RESIDUO)
   		    	MsgBox("O pedido "+SC7->C7_NUM+ "foi eliminado resíduo. Por este motivo não poderá ser alterado.")
				Close(oDlg1)
				Return
   		    EndIf

   			RecLock("SC7",.f.)
   			SC7->C7_PRODUTO		:=	_cProdINC		//----> TROCA PRODUTO NO PEDIDO DE COMPRA
   		    MsUnLock()
		    
			_cMsg+= "PC "+SC7->C7_NUM+" atualizado - produto antigo "+Alltrim(_cProdEXC)+" - produto novo "+Alltrim(_cProdINC)+_cEOF+_cEOF
			
			//----> VERIFICA SE EXISTE SOLICITACAO DE COMPRA VINCULADA
			If !Empty(SC7->C7_NUMSC+SC7->C7_ITEMSC)
				dbSelectArea("SC1")
				dbSetOrder(2)
				If dbSeek(xFilial("SC1")+_cProdEXC+SC7->C7_NUMSC+SC7->C7_ITEMSC,.f.)
					While Eof() == .f. .And. SC1->(C1_PRODUTO+C1_NUM+C1_ITEM) == _cProdEXC+SC7->C7_NUMSC+SC7->C7_ITEMSC

			   			RecLock("SC1",.f.)
   						SC1->C1_PRODUTO		:=	_cProdINC		//----> TROCA PRODUTO NA SOLICITACAO DE COMPRA
			   		    MsUnLock()
				 
			 			_cMsg+= "SC "+SC1->C1_NUM+" atualizada - produto antigo "+Alltrim(_cProdEXC)+" - produto novo "+Alltrim(_cProdINC)+_cEOF+_cEOF
        
				        dbSelectArea("SC1")
				        dbSkip()
					EndDo			
			    EndIf
			EndIf
			
			//----> VERIFICA SE EXISTE COTACAO DE COMPRA VINCULADA
			If !Empty(SC7->C7_NUMCOT)
				dbSelectArea("SC8")
				dbSetOrder(3)
				If dbSeek(xFilial("SC8")+SC7->C7_NUMCOT+_cProdEXC,.f.)
					While Eof() == .f. .And. SC8->(C8_NUM+C8_PRODUTO) == SC7->C7_NUMCOT+_cProdEXC

			   			RecLock("SC8",.f.)
   						SC8->C8_PRODUTO		:=	_cProdINC		//----> TROCA PRODUTO NA COTACAO DE COMPRA
			   		    MsUnLock()

			 			_cMsg+= "CT "+SC8->C8_NUM+" atualizada - produto antigo "+Alltrim(_cProdEXC)+" - produto novo "+Alltrim(_cProdINC)+_cEOF+_cEOF
				         
				        dbSelectArea("SC8")
				        dbSkip()
					EndDo			
			    EndIf
			EndIf

			dbSelectArea("SC7")
			dbSkip()   		
   		EndDo
    EndIf
EndIf

//----> EXIBE MENSAGEM
If Len(_cMsg) > 1
	MsgBox(_cMsg)     
EndIf

Close(oDlg1)
Return


Static Function ProdExc()

//----> VERIFICA SE O PRODUTO A SER EXCLUIDO FOI INFORMADO
If Empty(_cProdEXC)
   MsgBox("Não foi informado o código do produto a ser excluído.")
EndIf
        

//----> VERIFICA SE O PRODUTO A SER EXCLUIDO EXISTE NO CADASTRO DE PRODUTOS
dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
If !dbSeek(xFilial("SB1")+_cProdEXC,.f.)
   MsgBox("O produto "+Alltrim(_cProdEXC)+" a ser incluído, não existe no Cadastro de Produtos.")
EndIf

Return()



                             
Static Function ProdInc()

//----> VERIFICA SE O PRODUTO A SER INCLUIDO FOI INFORMADO
If Empty(_cProdINC)
   MsgBox("Não foi informado o código do produto a ser incluído.")
EndIf


//----> VERIFICA SE O PRODUTO A SER INCLUIDO EXISTE NO CADASTRO DE PRODUTOS
dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
If !dbSeek(xFilial("SB1")+_cProdINC,.f.)
   MsgBox("O produto "+Alltrim(_cProdINC)+" a ser incluído, não existe no Cadastro de Produtos.")
EndIf

Return()



Static Function Pedido()

//----> VERIFICA SE O PEDIDO DE COMPRA EXISTE
dbSelectArea("SC7")
dbSetOrder(1)
dbGoTop()
If !dbSeek(xFilial("SC7")+_cPedido,.f.)
   MsgBox("O pedido de compra "+_cPedido+" não existe.")
EndIf

Return()