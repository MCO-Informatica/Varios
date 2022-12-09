#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "Fileio.ch"

//***********************************************************************************//
User Function GHVLPORI()                                                             
///**********************************************************************************//
//Esta função valida se os limites de bonificação para o cliente e representante tem //
//saldo e se o cliente informado no pedido de bonificação está relacionado com o pe- //
//dido original e atualiza os campos C5_X_TBO1 e C5_X_TBO2 para conferência no momen-//
//to da gravação do pedido de venda (MT410TOK) se o mesmo está dentro do limite.     //
//Está associada a validação do campo C5_X_PORIG                                     // 
//***********************************************************************************//
// Fábio Alves Carneiro * 2013-07-12 * Gold Hair                                     //
//***********************************************************************************//

Local lRet  		:= .T.

/*
Local aArea 		:= GetArea()
Private cCondicao   := ''
Private cNtxBx1
Private nTamFil     := 0
Private nFilial       := ''
Private nCliente      := ''
Private nPedori       := ''
Private cCodUser := Alltrim(UsrRetName(__CUSERID))

If (cCodUser != "Joao") .AND. (cCodUser != "Sue Ellen")  .AND. (cCodUser != "Fabio")
DbSelectArea("SC5")
DbSetOrder(1)
If SC5->(Dbseek(xFilial("SC5")+M->C5_X_PORIG))
   nFilial  := SC5->C5_FILIAL
   nCliente := SC5->C5_CLIENTE
   nPedori  := SC5->C5_NUM
   nPerCli  := SC5->C5_X_BON1
   nPerRep  := SC5->C5_X_BON2
   nMaxCli  := SC5->C5_X_TBO1
   nMaxRep  := SC5->C5_X_TBO2
   nCliori  := SC5->C5_CLIENTE
   nLjcori  := SC5->C5_LOJACLI
   nRepOri  := SC5->C5_X_REPRE
   nLjrOri  := SC5->C5_X_LOJA
   nTamFil  := Len(SC5->C5_FILIAL)
Else
   Alert("Pedido original não localizado!")
   lRet := .F.
   Return lRet      
Endif




If M->C5_X_PEDBO == "1"
   CriaArq()
   CarregaTRB()
   If M->C5_CLIENTE == nCliori
      M->C5_X_TPBON := "C"
      If nPerCli > 0
         nJabon       := 0
         M->C5_X_TBO1 := 0
         While !TRBV->(eof())
	        DbSelectArea("SC6")
	        SC6->(DbSetOrder(1)) // Filial + Pedido + Item + Produto
	        If SC6->(DbSeek(TRBV->TR_FILIAL + TRBV->TR_NUM))
	           While !SC6->(EOF())
	              If SC6->C6_NUM == TRBV->TR_NUM    
	                 nJabon := nJabon + C6_VALOR
	              Endif   
   	              SC6->(DbSkip())
		       EndDo
	        Endif
            TRBV->(DbSkip())
	     Enddo
	     If nJabon >= nMaxCli
	        M->C5_X_TBO1 := 0
	        Alert("Valor maximo de bonificação já atingido!")
	        lRet := .F.
	     Else
	        M->C5_X_TBO1 := nMaxCli - nJabon       
	     Endif      
      Else
         Alert("Pedido original sem percentual de bonificação para o cliente!")
         lRet := .F.
      Endif      
   Else
      If M->C5_CLIENTE == nRepOri
         M->C5_X_TPBON := "R"
         If nPerRep > 0
            nJabon       := 0      
            M->C5_X_TBO2 := 0            
            While !TRBV->(eof())
	           DbSelectArea("SC6")
	           SC6->(DbSetOrder(1)) // Filial + Pedido + Item + Produto
               If SC6->(DbSeek(TRBV->TR_FILIAL + TRBV->TR_NUM))
	              While !SC6->(EOF())
	                 If SC6->C6_NUM == TRBV->TR_NUM    
	                    nJabon := nJabon + C6_VALOR
	                 Endif   
   	                 SC6->(DbSkip())
   	              EndDo
	           Endif	
               TRBV->(DbSkip())
	        Enddo
            If nJabon >= nMaxRep
               M->C5_X_TBO2 := 0
               Alert("Valor maximo de bonificação já atingido!")
               lRet := .F.      
            Else
               M->C5_X_TBO2 := nMaxRep - nJabon   
            Endif      
         Else
            Alert("Pedido original sem percentual de bonificação para o representante!")
            lRet := .F.
         Endif
      Else
         Alert("Pedido original não está relacionado ao cliente informado no pedido de bonificação!")
         lRet := .F.
      Endif             
   Endif
   FErase(cNtxBx1)  
Endif
//DbCommitAll()
//DbUnlockAll()    
Endif

RestArea(aArea)
*/

Return lRet

/****************************************************************************************/
Static Function CriaArq()
/****************************************************************************************/

	Local aCampos := {}
	Local cArqBxs 
	
	/////////////////////////
	//Tabela Temporaria (TRB)
	/////////////////////////

	aadd(aCampos,{"TR_FILIAL"           ,"C",nTamFil,0})
	aadd(aCampos,{"TR_NUM"              ,"C",06,0})
	aadd(aCampos,{"TR_TIPO"             ,"C",01,0})
	aadd(aCampos,{"TR_CLIENTE"          ,"C",06,0})	
	aadd(aCampos,{"TR_LOJA"             ,"C",02,0})
	aadd(aCampos,{"TR_EMISSAO"          ,"D",08,0})
	aadd(aCampos,{"TR_X_BON1"           ,"N",06,2})
	aadd(aCampos,{"TR_X_BON2"           ,"N",06,2})
	aadd(aCampos,{"TR_X_REPRE"          ,"C",06,2})
	aadd(aCampos,{"TR_X_PEDBO"         ,"C",01,0})
	aadd(aCampos,{"TR_X_PORIG"          ,"C",06,0})
	aadd(aCampos,{"TR_X_TBO1"           ,"N",12,2})
	aadd(aCampos,{"TR_X_TBO2"           ,"N",12,2})
				
	cArqBxs  := CriaTrab(aCampos)
	cNtxBx1  := CriaTrab(nil,.f.)
		
	If select("TRBV") > 0
		TRBV->(DbCloseArea())
	endif
		
	DbUseArea(.T.,,cArqBxs,"TRBV",.F.)
	
 	INDEX ON TR_FILIAL+TR_NUM TO &cNtxBx1	
	SET INDEX TO &cNtxBx1	
Return

/**************************************************************************************/
// Rotina para Carga do Arquivo Temporario
Static Function CarregaTRB()                                                            
/**************************************************************************************/
	Local cSql
	Local cCondicao := '' 
	Local lInverte
	Local lRejeita
	
	// Limpa os Registros do Arquivo Temporario
	dbselectarea("TRBV")
	dbgotop()
	While !TRBV->(Eof()) 
	  RecLock("TRBV",.F.)
	    dbdelete()
	  MsUnlock()
	  TRBV->(dbskip()) 
	Enddo
	If M->C5_CLIENTE == nRepOri
	   nCliente := nRepOri
	Endif   
	// Carrega Pedidos de Bonificação	
	cQuery := "SELECT C5_FILIAL, C5_NUM, C5_TIPO, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO, C5_X_BON1, C5_X_BON2, C5_X_REPRE, C5_X_PEDBO, C5_X_PORIG, C5_X_TBO1, C5_X_TBO2"
	cQuery += " FROM " + RetSqlName("SC5") + " SC5 "
	cQuery += " WHERE C5_FILIAL  = "+"'"+nFilial+"'"
	cQuery += "   AND C5_CLIENTE = "+"'"+nCliente+"'"
	cQuery += "   AND C5_X_PORIG = "+"'"+nPedori+"'"    
	cQuery += "   AND C5_X_PEDBO = '1' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "


	
	If Select("_QRY") > 0
		_QRY->(DbCloseArea())
	Endif
	
	TcQuery ChangeQuery(cQuery) New Alias "_QRY"
	
	While ! _QRY->(EOF())				
         
         /////////////////////////////////////////
	     // Salvar registros na tabela temporaria          
         /////////////////////////////////////////	     
		 DbSelectArea("TRBV")
		 RecLock("TRBV",.T.)
			TR_FILIAL	:= _QRY->C5_FILIAL
			TR_NUM		:= _QRY->C5_NUM
			TR_TIPO     := _QRY->C5_TIPO
			TR_CLIENTE	:= _QRY->C5_CLIENTE
			TR_LOJA		:= _QRY->C5_LOJACLI
			TR_EMISSAO  := STOD(_QRY->C5_EMISSAO)
			TR_X_BON1	:= _QRY->C5_X_BON1 
			TR_X_BON2	:= _QRY->C5_X_BON2
			TR_X_REPRE	:= _QRY->C5_X_REPRE
			TR_X_PEDBO	:= _QRY->C5_X_PEDBON
			TR_X_PORIG  := _QRY->C5_X_PORIG
			TR_X_TBO1   := _QRY->C5_X_TBO1
			TR_X_TBO2   := _QRY->C5_X_TBO2
			MsUnLock()         		 
		 							
	     DbSelectArea("_QRY")
	     _QRY->(DbSkip())

	Enddo
		
	_QRY->(dbclosearea())
	
	Dbselectarea("TRBV")
	TRBV->(DbGoTop())            
	
	INDEX ON TR_NUM TO &cNtxBx1
	SET INDEX TO &cNtxBx1	


Return