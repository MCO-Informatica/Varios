#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
  
/*
+------------+----------+--------+-----------------+-------+------------+
| Programa:  |LIMCLI01	| Autor: | Silverio Bastos | Data: | Abril/2010 |
+------------+----------+--------+-----------------+-------+------------+
| Descrição: | Funcao para calcular o Limite de Credito utilizando como |
|            | base as vendas recebidas apartir da 3a.Venda. 			|
+------------+----------------------------------------------------------+
| Uso:       | Verion Óleo Hidráulica Ltda.                             |
+------------+----------------------------------------------------------+
*/

User Function LIMCLI01
// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _aArea := GetArea()
Local _cDupli := _cLimite := 0
Local _NCompra := GETMV("MV_NCOMP") // Numero de Compras
Local _MCompra := GETMV("MV_MCOMP") // Meses de Compras
Local _CCompra := GETMV("MV_CCOMP") // Condicao Pagto a Vista

DbSelectArea("SA1")
DbSetOrder(1)
DbGotop()

While !Eof() 

	_cVctLmt := SA1->A1_VENCLC
	_cPricom := SA1->A1_PRICOM  
	_cUltcom := SA1->A1_ULTCOM
	_cNrocom := SA1->A1_NROCOM 
	_cNropag := SA1->A1_NROPAG 
	_cTitpro := SA1->A1_TITPROT
	
    DbSelectArea("SE1")
    DbSetOrder(2)
    DbSeek(xFilial("SE1") + SA1->A1_COD + SA1->A1_LOJA,.f.)

    While !Eof() .AND. SA1->A1_COD == SE1->E1_CLIENTE .AND. SA1->A1_LOJA == SE1->E1_LOJA
	    
	      If EMPTY(SE1->E1_BAIXA)
	         DbSelectArea("SE1")
	         DbSkip()
	         loop               
	      Else
	         _cDupli := _cDupli + (SE1->E1_VALOR - SE1->E1_SALDO)
	      Endif     
 
 	      DbSelectArea("SE1")
	      DbSkip()
	
    Enddo    
                       
    If _cNrocom >= _NCompra

       _cLimite := _cDupli / _cNropag

       DbSelectArea("SA1")
       While !RecLock("SA1",.f.)
       Enddo
       SA1->A1_LC := _cLimite
       SA1->A1_VENCLC := CTOD("31/12/2010")
       MsUnLock()

    Endif

    DbSelectArea("SA1")
    DbSkip()
    
    _cDupli := 0 

Enddo

Alert(" Termino do Processo !!! ")

// +----------------------------+
// | Restaura Ambiente Original |
// +----------------------------+

RestArea(_aArea)

Return(.t.)
