#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

User Function TKGRPED()

//Alert("Este orçamento não será gravado.")
//MsgStop("Cliente com pendencias. Favor contatar o setor financeiro.")
Local _lRet := .T.
Local _aArea := GetArea()
Local _cDupli := 0
Local _NCompra := GETMV("MV_NCOMP") // Numero de Compras
Local _MCompra := GETMV("MV_MCOMP") // Numero de compras ref controle de pagto, só libera prox faturamento, se o anterior estiver pago
Local _CCompra := GETMV("MV_CCOMP") // Condicao Pagto a Vista
Local _nPosTot := _nTotal := 0

  If SM0->M0_CODIGO == "02"
     return(_lRet)
  endif

DbSelectArea("SUB")
DbSetOrder(1)
_cMsg := ''

_nPosEmissao :=ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_EMISSAO"})
_nPosItem    :=ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_ITEM"})
_nPosXvrc    :=ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_XVRCOMP"})

//DbSeek(xFilial("SUB") + M->UA_NUM,.f.)
FOR nn:= 1 to LEN(acols) //WHILE SUB->UB_NUM = M->UA_NUM .and. !INCLUI
   If acols[nn,_nPosEmissao] <> DDATABASE .and. ! acols[nn,len(aheader)+1] .and. acols[nn,_nPosXvrc] = 0//SUB->UB_EMISSAO <> DDATABASE
        //Alert("Não será gravado. O item " + SUB->UB_ITEM +" - " + SUB->UB_PRODUTO +" esta Desatualizado com o dolar de " + dtoc(SUB->UB_EMISSAO) + " FAVOR ATUALIZAR PARA O DOLAR ATUAL " )
		_cMsg := _cMsg + acols[nn,_nPosItem] + " - "
   		_lRet := .F.
   Endif                 
   //dbskip()
NEXT	

IF !_lRet
  
//	Alert("Não será gravado. Item(s) - " + _cMSG +" esta com o dolar desatualizado.  FAVOR ATUALIZAR PARA O DOLAR ATUAL " )
	cTXT := "Item(s) - " + _cMSG +" esta com o dolar desatualizado.  deseja atualizar automaticamente todos itens?"
	IF AVISO("Título", cTxt, { "Sim", "Não" }, 1) = 1
      for i := 1 to len(aCols)
		If ExistTrigger('UB_VRDESC') .and.  acols[i,_nPosXvrc] = 0
			N := i
			RunTrigger(2,i,nil,,'UB_VRDESC ') 
		
		ENDIF	
	  next    
   	  GetDRefresh()
	  SYSREFRESH()
      Alert("Item atualizado para o dolar atual, Favor verificar os valores." )
   ELSE
      Alert("Não será gravado. Item(s) - " + _cMSG +" esta com o dolar desatualizado.  FAVOR ATUALIZAR PARA O DOLAR ATUAL " )
    Endif
    
Endif   	

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA,.f.)

	_cLimite := SA1->A1_LC
	_cVctLmt := SA1->A1_VENCLC
	_cPricom := SA1->A1_PRICOM  
	_cUltcom := SA1->A1_ULTCOM
	_cNrocom := SA1->A1_NROCOM 
    _cNropag := SA1->A1_NROPAG
	_cTitpro := SA1->A1_TITPROT
	
if SA1->A1_X_RISCO <> "A"

   ndias := (ddatabase - _cUltcom)
	
   If (empty(_cPricom) .or. SA1->A1_X_RISCO = "F") .and. (INCLUI .or. ALTERA) .and. .not. (ALLTRIM(M->UA_CONDPG)$"050/051/096/097/098")
      
      ALERT (" Para Clientes Novos ou Risco = F Condicao de Pagamento somente A Vista, favor contactar o financeiro ")
      _lRet := .F.

   Endif

   If  _cNroCom < _NCompra .and. _cPricom >= CTOD("01/04/2010") .and. (INCLUI .or. ALTERA) .and. .not. (ALLTRIM(M->UA_CONDPG)$"050/051/096/097/098")
		
		ALERT (" Cliente nao atingiu " + alltrim(Str(_NCompra)) + " compras, favor contactar o financeiro ")
      _lRet := .F.		
		
   Endif
	
   If  _cTitpro > 0  .and. INCLUI
		
	   ALERT (" Cliente possui titulos protestados, favor contactar o financeiro ")
      _lRet := .F.	   
	
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
		 
          If  DTOS(SE1->E1_VENCREA+3)  < DTOS(ddatabase) .AND. (INCLUI .OR. ALTERA) 
		
	          ALERT (" Cliente possui duplicatas VENCIDAS, favor contactar o financeiro ")
		      _lRet := .F.	          
		
		  Endif

		  If  DTOS(SE1->E1_VENCREA)  >= DTOS(ddatabase) .AND. (INCLUI .OR. ALTERA)

		      _cDupli := _cDupli + (SE1->E1_VALOR - SE1->E1_SALDO)

		      If _cPricom >= CTOD("01/04/2010") .and. _cNropag <= _MCompra .and. .not. (ALLTRIM(M->UA_CONDPG)$"050/051/096/097/098")

		         ALERT (" Para Clientes Novos compras faturadas somente se as compras anteriores estiverem pagas !!!")
			      _lRet := .F.		         
		         
		      Endif   
 		      
		  Endif    
		      
	      DbSelectArea("SE1")
	      DbSkip()
	
    Enddo

Endif	
                                  
/*                                  
If INCLUI .OR. ALTERA 

	_nPosTot  := aScan(aHeader,{|x| Alltrim(x[2]) == "UB_VLRITEM"})

	For nx := 1 to Len(aCols)

		_nTotal += aCols[nx][_nPosTot]

	next             

	If (_cDupli + _nTotal) > _cLimite 
    	
   		ALERT (" Limite de Credito Excedido, favor contactar o financeiro")
      _lRet := .F.   		
         
	Endif

Endif
*/

// +----------------------------+
// | Restaura Ambiente Original |
// +----------------------------+

RestArea(_aArea)

Return(_lRet)               
                  

