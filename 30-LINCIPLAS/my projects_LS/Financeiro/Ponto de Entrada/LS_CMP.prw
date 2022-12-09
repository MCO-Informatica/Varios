#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_CMP
// Autor 		Alexandre Dalpiaz
// Data 		31/08/2011
// Descricao  	Consulta títulos envolvidos em compensação de títulos
// 				Chamada nos pontos de entrada F040BOT e F050BOT
// Uso         	Laselva
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_CMP(_cCarteira)
///////////////////////////////
_aAlias     := GetArea()

DbSelectArea('TRBCMP')  
DbGoTop()
_aCmp := {}
Do While !eof() 
	_aLinha := {}
	aAdd(_aLinha, iif(SE1->E1_TIPO = 'RA', TRBCMP->EMISSAO, TRBCMP->PAGAMENTO))
	aAdd(_aLinha, TRBCMP->E5_PREFIXO)
	aAdd(_aLinha, TRBCMP->E5_NUMERO)
	aAdd(_aLinha, TRBCMP->E5_PARCELA)
	aAdd(_aLinha, TRBCMP->E5_TIPO)
	aAdd(_aLinha, TRBCMP->E5_DATA)
	aAdd(_aLinha, TRBCMP->E5_VALOR)
	aAdd(_aLinha, TRBCMP->E5_RECPAG)
	aAdd(_aLinha, TRBCMP->SALDO)
	aAdd(_aLinha, TRBCMP->BANCO)
	aAdd(_aLinha, TRBCMP->AGENCIA)
	aAdd(_aLinha, TRBCMP->CONTA)
	aAdd(_aLinha, .F. )
	aAdd(_aCmp,aClone(_aLinha))
	DbSkip()
EndDo

_nAltura 	:= 150 + 15 * len(_aCmp)
_nLargura 	:= oMainWnd:nClientWidth - 200
_aHeader := {}

DbSelectArea('SX3')
DbSetOrder(2)
DbSeek('E1_EMISSAO') ; AADD(_aHeader,{ 'Recebimento'     , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('E5_PREFIXO') ; AADD(_aHeader,{ TRIM(X3_TITULO)   , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('E5_NUMERO' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('E5_PARCELA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('E5_TIPO'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('E5_DATA'   ) ; AADD(_aHeader,{ 'Compensação'	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('E5_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('E5_RECPAG' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('E1_SALDO'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('E5_BANCO'  ) ; AADD(_aHeader,{ 'Compensação'	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('E5_AGENCIA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('E5_CONTA'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )

_nOPc := 0                                                                                       
If _cCarteira == 'SE1'
	_cTitulo := + SE1->E1_PREFIXO + '-' + SE1->E1_NUM + '/' + SE1->E1_PARCELA + ' ' + SE1->E1_TIPO
Else
	_cTitulo := + SE2->E2_PREFIXO + '-' + SE2->E2_NUM + '/' + SE2->E2_PARCELA + ' ' + SE2->E2_TIPO
EndIf
oDlg1       := MSDialog():New( 20,0,_nAltura,_nLargura,"Consulta compensação do título " + _cTitulo,,,.F.,,,,,,.T.,,,.T. )
oDlg1:bInit := {||EnchoiceBar(oDlg1,{||_nOpc :=1,oDlg1:End() },{||_nOpc := 2,oDlg1:End()},.F.)}
oBrwDiv     := MsNewGetDados():New(020,00,_nAltura/2-10,_nLargura/2,,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',,_aHeader,_aCmp )
oDlg1:Activate(,,,.t.)

RestArea(_aAlias)
Return()

