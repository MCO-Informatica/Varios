#include "rwmake.ch"    
#include "protheus.ch"

User Function VER_EST()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³ VER_EST  ³ Autor ³ Rodrigo Franco        ³ Data ³ Mai/05   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
local nColCodPr := aScan(aHeader,{ |x| UPPER(ALLTRIM(x[2])) == "C6_PRODUTO"})
local nColLocal := aScan(aHeader,{ |x| UPPER(ALLTRIM(x[2])) == "C6_LOCAL"})
local nColQtVen := aScan(aHeader,{ |x| UPPER(ALLTRIM(x[2])) == "C6_QTDVEN"})
local nColTes   := aScan(aHeader,{ |x| UPPER(ALLTRIM(x[2])) == "C6_TES"})    
lOCAL _nSdoPed  := 0                                                                                                                                                   
lOCAL _lRet 	:= .T.
local _nSldAcols:= 0
Local _lVsdPed 	:= SuperGetMv("FU_VSDPED", .F., .f. ) 
local iw
LOCAL  wusado:= len(aheader)         

//verifico no acols se o produto está repetido 
for iw:= 1 to len(acols)
   if iw == n
      loop
   endif

  if  ACOLS[iw][WUSADO+1] == .F.  //não deletado

	   if acols[n,nColCodPr] == acols[iw,nColCodPr] 
    	  _nSldAcols+= acols[iw,nColQtVen]
	   endif

  endif

Next iw     

DbSelectArea("SF4")
DbSetOrder(1)
IF DbSeek(xFilial("SF4")+aCols[n,nColTes])
	IF SF4->F4_ESTOQUE == "S" 
	
		// Se solcitado para verificar saldo em pedidos
		if _lVsdPed
		
			_nSdoPed := u__VerPedAb( M->C5_NUM, aCols[n,nColCodPr] )  
			_nSdoPed += _nSldAcols   //somo pedidos em aberto e linhas digitadas nesse pedido ,exceto a linha que está sendo digitada
		
		Endif
		
		DbSelectArea("SB2")
		If (DbSeek("01"+aCols[n,nColCodPr]+aCols[n,nColLocal]))
			If ( SB2->B2_QATU - _nSdoPed )  < aCols[n,nColQtVen]     // para incluir mais um grupo este é o ponto
				Msgbox("A quantidade e' maior que o saldo em estoque" + chr(13) + chr(13) + "Consulte Saldo na tecla F4"+ chr(13) + chr(13) + "Ou consulte Saldo de outro Almoxarifado", "Aviso")
				_lRet := .F.
			Endif
		ENDIF
	ENDIF
Else
	msgbox("Coloque a TES, antes da Quantidade", "Aviso")
	_lRet := .F.
ENDIF

Return(_lRet) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³ _VerPedAb  ³ Autor ³ Ivan de Oliveira     ³ Data ³ Ago/13      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verificar saldo de pedidos                                     ³±±  
±±³parâmetros: Nro Pedido ( se informado busca todos excluindo este )         ³±± 
±±³parâmetros: Produto   ( Obrigatório - item a ser analisado )         	  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function _VerPedAb( _cPedido, _cProduto )    

Local _nQtIt := 0    

Default _cPedido  := " "  
Default _cProduto := " " 

_cAlias := GetNextAlias() 
 BEGINSQL ALIAS _cAlias  
%noParser%
                  	
	SELECT  
   	   		SUM ( C6_QTDVEN - C6_QTDENT ) QTDE 
	FROM 
	   		%table:SC6% SC6
	INNER JOIN %table:SF4% SF4 
	ON 		F4_CODIGO = C6_TES AND F4_ESTOQUE = 'S' AND SF4.%notDel%  
	
	WHERE  
			C6_FILIAL	=  %xFilial:SC6%   
			AND C6_NUM 	<> %exp:_cPedido%		
 			AND C6_PRODUTO BETWEEN %exp:_cProduto% AND %exp:_cProduto%
 			AND C6_BLQ NOT IN ( 'R' ,'S')
 			AND (C6_QTDVEN-C6_QTDENT )>0
 			AND SC6.%notDel%    
   
ENDSQL
    
//  Última querie executada ->>> GetLastQuery()[2]
 
(_cAlias)->( DbGotop() ) 
_nQtIt 	 := (_cAlias)->(QTDE)   
(_cAlias)->(DbCloseArea())	
      	
Return _nQtIt
   