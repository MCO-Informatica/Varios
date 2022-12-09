#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RNO003    º Autor ³ Marcelo IUSPA      º Data ³  08/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastrar SE2 apartir da tabela SZ7                      º±±
±±º          ³       Apos a aprovação via WF                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RNO003()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravar campos da SE2 baseado SZ7                                                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aSavAre  := GetArea()
Local aVetor   := {}
Local aNumTit  := NewNumber()
Local cNovoNumero := ""
//Local nSaveSX8 := GetSX8Len()

//Regra da RNV-003 para criar as Tabelas FIE e CNX

     AaDd(aVetor,{"E2_FILIAL" ,xFilial("SE2")           ,Nil})
     AaDd(aVetor,{"E2_PREFIXO",aNumTit[1,1]    			,Nil})
     AaDd(aVetor,{"E2_NUM"    ,aNumTit[1,2]				,Nil})
     AaDd(aVetor,{"E2_PARCELA",aNumTit[1,3]      		,Nil})
     AaDd(aVetor,{"E2_TIPO"   ,"PA "                    ,Nil})
     AaDd(aVetor,{"E2_FORNECE",SZ7->Z7_FORNECE          ,Nil})
     AaDd(aVetor,{"E2_LOJA   ",SZ7->Z7_LOJA             ,Nil})
     AaDd(aVetor,{"E2_EMISSAO",ddatabase                ,Nil})
     AaDd(aVetor,{"E2_VENCTO" ,SZ7->Z7_VENCTO           ,Nil})
     AaDd(aVetor,{"E2_VALOR"  ,SZ7->Z7_VALOR            ,Nil})  
     AaDd(aVetor,{"E2_HIST"   ,"Adt. a Fornecedor/ "+IF(!EMPTY(SZ7->Z7_NUMPED),"Pedido Compra: "+SZ7->Z7_NUMPED,"Contrato: "+SZ7->Z7_CONTRA+"REV: "+SZ7->Z7_REVISAO)    ,Nil})
     AaDd(aVetor,{"E2_NATUREZ",SZ7->Z7_NATUREZ          ,Nil})
     AaDd(aVetor,{"E2_ORIGEM" ,"SZ7"                    ,NIL})
	 AaDd(aVetor,{"E2_MDCONTR",SZ7->Z7_CONTRA			,Nil})   
 	 AaDd(aVetor,{"E2_MDREVIS",SZ7->Z7_REVISAO			,Nil})  
	 AaDd(aVetor,{"E2_CCD" 	  ,SZ7->Z7_CCUSTO			,Nil})     	  
	 AaDd(aVetor,{"E2_ITEMD"  ,SZ7->Z7_ITEMCTA			,Nil})     	 	 
	 AaDd(aVetor,{"E2_CLVLDB" ,SZ7->Z7_CLVL				,Nil})  
	 AaDd(aVetor,{"E2_EC05DB" ,SZ7->Z7_EC05DB			,Nil})     	 	    	 	 
     AaDd(aVetor,{"AUTBANCO"  ,SZ7->Z7_PABCO            ,NIL})
     AaDd(aVetor,{"AUTAGENCIA",SZ7->Z7_PAAGENC          ,NIL})
     AaDd(aVetor,{"AUTCONTA"  ,SZ7->Z7_PACONTA          ,NIL})

     lMsErroAuto := .F.
     MSExecAuto({|x,y| Fina050(x,y)},aVetor,3) //3-Inclusao //5-Exclusao
     If lMsErroAuto
		  RollBackSX8()
          MostraErro()
     Else
		//ConfirmSx8()
		RecLock("SZ7", .F.) 
			SZ7->Z7_PREFIXO:= SE2->E2_PREFIXO
			SZ7->Z7_NUMTIT := SE2->E2_NUM    
			SZ7->Z7_PARCELA:= SE2->E2_PARCELA
			SZ7->Z7_STATUS := "1"
			SZ7->Z7_WFOBS 	:= cWFObs	// ==> Variavel Private de origem do fonte RNO001.PRW
			SZ7->Z7_DATALIB := Date()
		MsUnlock()
	     IF !EMPTY(SZ7->Z7_NUMPED)
	        RecLock("FIE",.T.)
	        FIE_FILIAL := SZ7->Z7_FILIAL
	        FIE_CART   := "P"
	        FIE_PEDIDO := SZ7->Z7_NUMPED
	        FIE_PREFIX := aNumTit[1,1]//"ADT"
	        FIE_NUM    := aNumTit[1,2]//SE2->E2_NUM
	        FIE_PARCEL := aNumTit[1,3]//"1"
	        FIE_TIPO   := "PA"
	        FIE_CLIENT := ""
	        FIE_FORNEC := SZ7->Z7_FORNECE
	        FIE_LOJA   := SZ7->Z7_LOJA
	        FIE_VALOR  := SZ7->Z7_VALOR
	        FIE_SALDO  := SZ7->Z7_VALOR
	        MSUnLock()
	     ELSEIF !EMPTY(SZ7->Z7_CONTRA) 
	     
			DbSelectArea('CNX')
			CNX->(DbSetOrder(2))
			cNovoNumero	:= CriaVar('CNX_NUMERO')
					
			While DbSeek(xFilial('CNX') + cNovoNumero )
				CNX->(ConfirmSx8())		        
				cNovoNumero	:= CriaVar('CNX_NUMERO')
			EndDo	     

	        CNX->(ConfirmSx8())
	        	     
	        RecLock("CNX",.T.)
	        CNX_FILIAL := SZ7->Z7_FILIAL  	//Filial
	        CNX_NUMSEQ := SZ7->Z7_NUMSEQ  	//N.Sequencial
	        CNX_NUMTIT := aNumTit[1,2]		//SE2->E2_NUM
	        CNX_CONTRA := SZ7->Z7_CONTRA  	//Contrato
	        CNX_NUMMED := SZ7->Z7_MEDICAO 	//Medição
	        CNX_FORNEC := SZ7->Z7_FORNECE 	//Fornecedor
	        CNX_LJFORN := SZ7->Z7_LOJA    	//Loja
	        CNX_CLIENT := ""               	//Cliente
	        CNX_LOJACL := ""               	//Loja
	        CNX_VLADT  := SZ7->Z7_VALOR   	//Valor
	        CNX_DTADT  := SZ7->Z7_VENCTO  	//Data Vencimento
	        CNX_PREFIX := aNumTit[1,1]     	//Prefixo
			//CNX_XVLORI := SZ7->Z7_VALOR  
			CNX_BANCO  := SZ7->Z7_PABCO      // Banco
			CNX_AGENCI := SZ7->Z7_PAAGENC    // Agencia 
			CNX_CONTA  := SZ7->Z7_PACONTA   //Conta
			CNX_SALDO  := SZ7->Z7_VALOR 	//Valor
			CNX_NUMERO := cNovoNumero

	        MSUnLock()                          

	     ENDIF
	Endif
RestArea(aSavAre)
Return Iif(lMsErroAuto,.F.,.T.)

Static Function NewNumber()
Local aAreaAtu	:= GetArea()
Local cPrefixo	:= "ADT"	//"GCT"
Local cNumPref	:= StrZero(1,TamSx3('E2_NUM')[1])
Local cParcela	:= StrZero(1,TamSx3('E2_PARCELA')[1]) 
Local aRetorno	:= {}
Local cAliasQry	:= GetNextAlias()

DbSelectArea("SE2")
SE2->(DbsetOrder(1))
 
If SE2->( DbSeek(xFilial("SE2") + cPrefixo + cNumPref + cParcela ) )

	cQuery := "SELECT MAX(E2_NUM) E2_NUM "
	cQuery += "FROM "+RetSqlName("SE2")
	cQuery += " WHERE E2_FILIAL  = '"+xFilial("SE2")+"'"
	cQuery += "   AND E2_PREFIXO = '"+cPrefixo+"' "
	cQuery += "   AND D_E_L_E_T_  = ' ' " 
	cQuery := ChangeQuery( cQuery )
	
	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. )
	DbSelectArea(cAliasQry)
	(cAliasQry)->(DbGoTop())
	
	If (cAliasQry)->(!Eof())
	    cNumPref := (cAliasQry)->E2_NUM
	EndIf
	
	(cAliasQry)->(DbCloseArea())           
	
	cNumPref:= Soma1(cNumPref)

EndIf	                                       

AADD(aRetorno,{cPrefixo,cNumPref,cParcela})

RestArea( aAreaAtu )
Return(aRetorno)       


User Function TSTRNO003( cCodigo )

Private cWFObs :="Acionado por teste [TSTRNO003]"

DbSelectArea("SZ7")
DbSetOrder(1)
If DbSeek( xFilial("SZ7") + cCodigo )
	U_RNO003()
	Reclock("SZ7",.F.)
		SZ7->Z7_WFOBS 	:= cWFObs
		SZ7->Z7_DATALIB := Date()
		SZ7->Z7_STATUS  := "1"
	MsUnlock()
	ApMsgInfo('Gerado titulo avaliar.')
Else
	ApMsgInfo('Não Localizado sequencia: ' + cCodigo)
EndIf
Return()                   
