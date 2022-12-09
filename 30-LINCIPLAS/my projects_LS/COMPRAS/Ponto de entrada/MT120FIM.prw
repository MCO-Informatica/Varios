#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

// Programa.: mt120fim
// Alteração: Alexandre Dalpiaz				
// Data.....: 12/09/2013
// Função...: Cria registro de relacionamento para pagamentos adiantados (FIE)
//			  Usa recursos da rotina padrão do protheus
//			  Também cria mais um nível de aprovação de pedidos para o gerente financeiro

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT120FIM()
///////////////////////

Local aArea	:= getArea()
_cNum 		:= SC7->C7_NUM      

DbSelectArea('SC7')
DbSetOrder(1)
For _nI := 1 to len(aCols)
    If !GdDeleted(_nI)
    	If DbSeek(xFilial('SC7') + _cNum + GdFieldGet('C7_ITEM',_nI),.f.)
    		RecLock('SC7',.f.)
    		SC7->C7_TES := GdFieldGet('C7_TES',_nI)
    		MsUnLock()
    	EndIf
    EndIf
Next                            

If Posicione('SE4',1,xFilial('SE4') + SC7->C7_COND,'E4_CTRADT ') == '1' .and. FunName() $ 'MATA120/MATA121' .and. !empty(GetMv('LS_APRVFIN'))
	
	_cQuery := "SELECT SUM(C7_TOTAL) TOTAL, SUM(C7_IPI) IPI, SUM(C7_ICMSRET) ST"
	_cQuery += _cEnter + " FROM " + RetSqlName('SC7') + " (NOLOCK)"
	_cQuery += _cEnter + " 	WHERE C7_FILIAL = '" + SC7->C7_FILIAL + "'"
	_cQuery += _cEnter + " AND C7_NUM = '" + SC7->C7_NUM + "'"
	_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), '_SC7', .F., .T.)
	
	_nTotal := _SC7->TOTAL
	_nIPI   := _SC7->IPI  
	_nST    := _SC7->ST   
	DbCloseArea()
	
	Reclock("SCR",.T.)
	SCR->CR_FILIAL	:= SC7->C7_FILIAL
	SCR->CR_NUM		:= SC7->C7_NUM
	SCR->CR_TIPO	:= iif(SC7->C7_TIPO == 1, 'PC', 'AE')
	SCR->CR_NIVEL	:= "00"
	SCR->CR_USER	:= Posicione("SAK", 1, xFilial("SAK") + GetMv('LS_APRVFIN'), 'AK_USER')
	SCR->CR_APROV	:= GetMv('LS_APRVFIN')
	SCR->CR_STATUS	:= "01"
	SCR->CR_TOTAL	:= _nTotal
	SCR->CR_EMISSAO	:= SC7->C7_EMISSAO           
	SCR->CR_MOEDA   := 1
	SCR->CR_TXMOEDA := 1
	MsUnlock("SCR")
	
	DbSelectArea('FIE')
	RecLock('FIE',!DbSeek(xFilial('FIE') + 'P' + SC7->C7_NUM,.f.))	
	_nAdianta := iif(FIE->FIE_VALOR == 0, (_nTotal + _nIPI + _nST),FIE->FIE_VALOR)
	
	Define MsDialog _oDlg Title "Adiantamento de Pedido de Compra" From 000,000 to 220,300 of oMainWnd Pixel
	@ 005,002 Say 'Total dos Produtos:'      Size 250,010 COLOR CLR_BLACK Pixel of _oDlg
	@ 020,002 Say 'Valor IPI:'               Size 250,010 COLOR CLR_BLACK Pixel of _oDlg
	@ 035,002 Say 'Valor ICMS/ST:'           Size 250,010 COLOR CLR_BLACK Pixel of _oDlg
	@ 060,002 Say 'Valor do adiantamento:'   Size 250,010 COLOR CLR_BLACK Pixel of _oDlg

	@ 005,090 Get _nTotal    pict '@E 999,999.99' size 50,10 Pixel of _oDlg when .f.
	@ 020,090 Get _nIPI      pict '@E 999,999.99' size 50,10 Pixel of _oDlg when .f.
	@ 035,090 Get _nST       pict '@E 999,999.99' size 50,10 Pixel of _oDlg when .f.
	@ 060,090 Get _nAdianta  pict '@E 999,999.99' size 50,10 Pixel of _oDlg valid iif(_nAdianta <= 0,Aviso('Adiantamentos de Pedido de Compra','Informar valor correto do adiantamento',{'OK'},2,'Pedido de Compras nº' + SC7->C7_NUM)>9,.t.)

	@ 080,010 BmpButton Type 1 Action (_oDlg:End())
	Activate MsDialog _oDlg Centered Valid iif(_nAdianta <= 0,Aviso('Adiantamentos de Pedido de Compra','Informar valor correto do adiantamento',{'OK'},2,'Pedido de Compras nº' + SC7->C7_NUM)>9,.t.)

	DbSelectArea('FIE')
	RecLock('FIE',!DbSeek(xFilial('FIE') + 'P' + SC7->C7_NUM,.f.))	
	FIE->FIE_FILIAL := xFilial('FIE')
	FIE->FIE_CART   := 'P'
	//FIE->FIE_NUM    := xFilial('FIE') + 'P' + SC7->C7_NUM
	FIE->FIE_PRVENT := SC7->C7_DATPRF 
	FIE->FIE_PEDIDO := SC7->C7_NUM
	FIE->FIE_TIPO   := 'PA'
	FIE->FIE_FORNEC := SC7->C7_FORNECE
	FIE->FIE_LOJA   := SC7->C7_LOJA
	FIE->FIE_VALOR  := _nAdianta
	FIE->FIE_SALDO  := _nAdianta
	FIE->FIE_SITUA  := SC7->C7_CONAPRO
	MsUnLock()
	DbSelectArea('SC7')

EndIf

restArea(aArea)

Return()