#INCLUDE "rwmake.ch"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AFAT003  º Autor ³ Giane - ADV Brasil º Data ³  28/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cria tela para mostrar o Log do pedido de vendas, da tabelaº±±
±±º          ³ SZ4, quando usuario estiver no pedido de vendas.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI  - faturamento/pedido de vendas          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AFAT003(cNum)   
	Local _aArea:= GetArea() 
	Local _aAux := {}
	Local aHeader2 := {} 
	Local oDlg
	Local aPicture := {}                   
	Local _cIndex, _cKey
	Local _cFiltro := ""

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "AFAT003" , __cUserID )

	Private aCols := {}    
	Private oLstBox  

	dbSelectArea("SZ4")
	dbSetOrder(3)

	_cFiltro := "Z4_FILIAL = '"+xFilial("SZ4")+"' .AND.  Z4_PEDIDO = '"+ cNum + "' "

	_cIndex:= CriaTrab("SZ4",.F.)
	_cKey := IndexKey()                                 	

	IndRegua("SZ4",_cIndex,_cKey,,_cFiltro,"Selecionando Registros...")  
	DbSelectArea("SZ4")
	dbSetOrder(3)
	DbGotop() 

	Do While !eof() 
		If !( "Rotina Automatica" $ SZ4->Z4_MOTIVO )                                     
			_aAux := {}  
			aadd(_aAux, SZ4->Z4_PEDIDO)
			aadd(_aAux, SZ4->Z4_ITEPED)
			aadd(_aAux, SZ4->Z4_DATA)
			aadd(_aAux, SZ4->Z4_HORA) 
			aadd(_aAux, SZ4->Z4_USUARIO) 
			aadd(_aAux, UsrRetName(SZ4->Z4_USUARIO) )
			aadd(_aAux, SZ4->Z4_EVENTO) 
			if !empty(SZ4->Z4_CODALTE)
				aadd(_aAux, '[...       ]') 
			else
				aadd(_aAux, space(13))
			endif
			aadd(_aAux, SZ4->Z4_MOTIVO)    

			aadd(aCols,_aAux)     
		Endif    
		DbSkip()
	Enddo

	//o if abaixo eh para nao dar erro de execucao no ListBox, se o Select nao retornar nenhum registro                 
	if len(aCols) == 0
		aadd(aCols,{space(06),space(02),"","","","","","",""})
	endif                   


	DEFINE MSDIALOG oDlg FROM  15,6 TO 550,900 TITLE ('Historico do Pedido de Vendas ' + M->C5_NUM ) PIXEL  

	aHeader2 := {"Pedido" ,"Item","Data" ,"Hora" ,"Usuario "   ,"Nome Usuario","Evento  ","Alteracoes","Motivo"} 
	aPicture := {"999999" , "99" ," 99/99/9999"  ,"@E 99:99:99","@!"      , "@!",       ,"@S30" ,"@S30" }   

	EnchoiceBar(oDlg,{||oDlg:End(),Nil},{||oDlg:End()},,,,,.F.,.F.,.F.,)

	//Parametros RDListBox(lin,col,compr,alt, ,  , tamanho das colunas no grid, picture, edita, funcao qdo clica 2 vezes na linha)                       

	oLstBox := RDListBox(2.3,0.5, 440,250, aCols, aHeader2,{8,15,10,10,40,40,20,28,28},aPicture,.F. , {||fVerMemo()} )

	ACTIVATE MSDIALOG oDlg CENTERED

	_cIndex += OrdBagExt()
	fErase(_cIndex)   

	RestArea(_aArea)
Return     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fVerMemo º Autor ³ Giane - ADV Brasil º Data ³  30/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Mostra o campo memo com as alteracoes ocorridas no pedido  º±±
±±º          ³ quando usuario clicar 2 vezes na linha do listbox.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI  - faturamento/pedido de vendas          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fVerMemo() 
	Local oDlg2
	Local cMemo := ""
	Local cPedido, dData, cHora,cItem

	cPedido := ACOLS[ oLstBox:nAt, 1 ] 
	cItem   := ACOLS[ oLstBox:nAt, 2 ] 
	dData   := ACOLS[ oLstBox:nAt, 3 ]    
	cHora   := ACOLS[ oLstBox:nAt, 4 ] 

	DEFINE MSDIALOG oDlg2 FROM  0,0 TO 400,600 TITLE ('Alteracoes Pedido ' + cPedido + ' - Item ' + cItem) PIXEL  

	nTamLinha := 79
	lWordWrap := .t.     

	DbSelectArea("SZ4")
	DbSetorder(3)

	If dbseek(xFilial("SZ4")+cPedido+dtos(dData)+cHora+cItem) 
		cCod := SZ4->Z4_CODALTE
		cMemo := MSMM( cCod, 80 )
	Endif

	@ 30,10 SAY cMemo SIZE 300,400 OF oDlg2 PIXEL 	  

	EnchoiceBar(oDlg2,{||oDlg2:End(),Nil},{||oDlg2:End()},,)

	ACTIVATE MSDIALOG oDlg2 CENTERED      

Return