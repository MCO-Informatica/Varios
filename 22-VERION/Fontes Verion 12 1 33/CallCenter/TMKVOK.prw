#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
/*
+------------+----------+--------+-----------------+-------+------------+
| Programa:  | TMKVOK 	| Autor: | Silverio Bastos | Data: | Março/2010 |
+------------+----------+--------+-----------------+-------+------------+
| Descrição: | Ponto de Entrada para checar controle de limite na apro- |
|            | vação do credito.                          				|
+------------+----------------------------------------------------------+
| Uso:       | Verion Óleo Hidráulica Ltda.                             |
+------------+----------------------------------------------------------+
*/
User Function TMKVOK  
// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+
Local _aArea   := GetArea()
Local _cDupli  := 0
Local _NCompra := GETMV("MV_NCOMP") // Numero de Compras
Local _MCompra := GETMV("MV_MCOMP") // Numero de compras ref controle de pagto, só libera prox faturamento, se o anterior estiver pago
Local _CCompra := GETMV("MV_CCOMP") // Condicao Pagto a Vista
Local _nPosTot := _nTotal := 0

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA,.f.)

_cLimite := SA1->A1_LC
_cVctLmt := SA1->A1_VENCLC
_cPricom := SA1->A1_PRICOM  
_cUltcom := SA1->A1_ULTCOM
_cNrocom := SA1->A1_NROCOM 
_cNropag := SA1->A1_NROPAG
_cTitpro := SA1->A1_ATR //SA1->A1_TITPROT
	
if SA1->A1_X_RISCO <> "A"
   	ndias := (ddatabase - _cUltcom)
	
   IF ndias > 185 .and. (INCLUI .or. ALTERA)
    	ALERT ("Cliente inativo a mais de 6 meses")
   Endif 
	
   If (Empty(_cPricom) .or. SA1->A1_X_RISCO = "F") .and. (INCLUI .or. ALTERA) .and. .not. (ALLTRIM(M->UA_CONDPG)$"050/051/096/097/098/091") //incluído condição de pagamento 091 - Alex Rodrigues - 22/07/2018
      ALERT (" Para Clientes Novos ou Risco = F, Condicao de Pagamento somente A Vista, favor contactar o financeiro ")
   Endif

   If  (_cNroCom < _NCompra .or. SA1->A1_X_RISCO = "F") .and. _cPricom >= CTOD("01/04/2010") .and. (INCLUI .or. ALTERA) .and. .not. (ALLTRIM(M->UA_CONDPG)$"050/051/096/097/098/091") //incluído condição de pagamento 091 - Alex Rodrigues - 22/07/2018
		ALERT (" Cliente nao atingiu " + alltrim(Str(_NCompra)) + " compras ou risco F, favor contactar o financeiro ")
   Endif
	
   If  _cTitpro > 0  .and. INCLUI
	   ALERT (" Cliente possui titulos protestados, favor contactar o financeiro ")
	Endif

    DbSelectArea("SE1")
    DbSetOrder(2)
    DbSeek(xFilial("SE1") + M->UA_CLIENTE + M->UA_LOJA,.f.)
	
    While !Eof() .AND. M->UA_CLIENTE == SE1->E1_CLIENTE .AND. M->UA_LOJA == SE1->E1_LOJA
	    
	      If SE1->E1_SALDO = 0
	         DbSelectArea("SE1")
	         DbSkip()
	         loop               
	      Endif     
	
	      if SE1->E1_TIPO  # "NF"
	         DbSelectArea("SE1")
	         DbSkip()
	         loop
          Endif     
		 
          If  DTOS(SE1->E1_VENCREA)  < DTOS(ddatabase) .AND. (INCLUI .OR. ALTERA) 
	          ALERT (" Cliente possui duplicatas VENCIDAS, favor contactar o financeiro ")
		  Endif

		  If  DTOS(SE1->E1_VENCREA)  >= DTOS(ddatabase) .AND. (INCLUI .OR. ALTERA)
		      _cDupli := _cDupli + (SE1->E1_VALOR - SE1->E1_SALDO)

		      If _cPricom >= CTOD("01/04/2010") .and. _cNropag <= _MCompra .and. .not. (ALLTRIM(M->UA_CONDPG)$"050/051/096/097/098/091") //incluído condição de pagamento 091 - Alex Rodrigues - 22/07/2018
		         ALERT (" Para Clientes Novos compras faturadas somente se as compras anteriores estiverem pagas !!!")
		      Endif   
		  Endif    
		      
	      DbSelectArea("SE1")
	      DbSkip()
    End
Endif	
                                  
If INCLUI .OR. ALTERA 
	_nPosTot  := aScan(aHeader,{|x| Alltrim(x[2]) == "UB_VLRITEM"})

	For nx := 1 to Len(aCols)
		_nTotal += aCols[nx][_nPosTot]
	next             

	If (_cDupli + _nTotal) > _cLimite 
   		ALERT (" Limite de Credito Excedido, favor contactar o financeiro")
	Endif
Endif

// +----------------------------+
// | Restaura Ambiente Original |
// +----------------------------+
RestArea(_aArea)
Return(.t.)
