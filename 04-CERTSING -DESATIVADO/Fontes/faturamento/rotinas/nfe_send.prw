#INCLUDE "PROTHEUS.CH"      
#INCLUDE "TopConn.ch" 
#INCLUDE "TbiConn.ch" 

USER FUNCTION NFE_SEND()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFE_SEND    ºAutor  ³Microsiga         º Data ³  04/29/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/               

Local cAlias := "TMP"
Local aRetTrans := { }
Local cAlias1:= "TMP1"
Local cNota  := " " 
Local cDBOra := "ORACLE/SPED"
Local cSrvOra:= "192.168.16.131"
Local nHndOra       
Local cDBOra1 := "ORACLE/DBCERT"         
Local cSrvOra1:= "192.168.16.131"
Local nHndOra1     
Local cSerie := " " 
Local cPedido:= " "  
Local cDocId := " "
Local cCodOP := " "  
Local cPed   := " " 
Local cPedLog  := " "   
Local cPed_SC5 := " " 
Local lMun := .T.		

Local nTotThread := 0

//Abre empresa para Faturamento retirar comentário para processamento em JOB	
//RpcSetType(3)
//RpcSetEnv('01','02')

If .T.
	RETURN
ENDIF

BEGINSQL ALIAS cAlias
	
		SELECT F3_NFISCAL,F3_SERIE FROM PROTHEUS.SF3010
		WHERE
		F3_EMISSAO >= '20130423'  AND
		F3_SERIE 	 = '2' 		  AND    
		F3_ESPECIE   = 'SPED '    AND
		F3_CODRSEF	 = ' '        AND
		D_E_L_E_T_ 	 = ' ' 
		
	ENDSQL 

TMP->(DbGoTop())
	
While TMP->(!EOF())             

	cNota   := TMP->F3_NFISCAL   
	cSerie  := TMP->F3_SERIE  
	
	SC6->(DbCloseArea())  
	
	DbSelectArea("SC6")
	DbSetOrder(4)
	DbSeek(xFilial("SC6")+cNota+cSerie)
	
	If Found()
	  	cPedido := SC6->C6_PEDGAR
	  	cCodOP  := SC6->C6_XOPER
	  	cPed	:= SC6->C6_NUM
	Endif
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	DbSeek(xFilial("SC5")+cPed)
	
	If Found()
		nRec     := SC5->(RECNO())    
		cPed_SC5 := SC5->C5_NUM
		cClient  := SC5->C5_CLIENTE 
		cLoja	 := SC5->C5_LOJACLI
	Endif   
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+cClient+cLoja)
	
	If Found()
	
		cMun 	:= UPPER(A1_MUN)
		cCodMun := SA1->A1_COD_MUN
	    
			DbSelectArea("CC2")
			DbSetOrder(2)
			DbSeek(xFilial("CC2")+cMun)
		    	
		    	If Found()
		    		If cCodMun <> cCodMun
			    		cCodMun := CC2->CC2_CODMUN
			    		lMun := .F.  
		    		Else 
			    		lMun := .T.
		    		Endif
		    	Endif 
	 
		If lMun == .F.
		RecLock("SA1",.F.)
		A1_COD_MUN := cCodMun
		MsUnlock("SA1")
		Endif		
	 
	 Endif
	
	cDocId  := '2  '+Alltrim(cNota) 

				cUpd := "UPDATE SPED.SPED054	"+Chr(13)+Chr(10)
				cUpd += "SET 					"+Chr(13)+Chr(10)    
				cUpd += "D_E_L_E_T_ = '*'		"+Chr(13)+Chr(10)
				cUpd += "WHERE					"+Chr(13)+Chr(10)
				cUpd += "ID_ENT = '000002' AND  "+Chr(13)+Chr(10) 
				cUpd += "CTSAT_SEFR <> '100' AND"+Chr(13)+Chr(10)
				cUpd += "NFE_ID = '"+cDocId+"' AND"+Chr(13)+Chr(10)
				cUpd += "D_E_L_E_T_ = ' '       "+Chr(13)+Chr(10)

	TCSQLEXEC(cUpd)   
	dbcommitAll()   
	
 				cUpd := " "      
				cUpd := "UPDATE SPED.SPED050	"+Chr(13)+Chr(10)
				cUpd += "SET 					"+Chr(13)+Chr(10)    
				cUpd += "D_E_L_E_T_ = '*'		"+Chr(13)+Chr(10)
				cUpd += "WHERE					"+Chr(13)+Chr(10)
				cUpd += "ID_ENT = '000002' AND  "+Chr(13)+Chr(10) 
				cUpd += "NFE_ID = '"+cDocId+"' AND"+Chr(13)+Chr(10)
				cUpd += "D_E_L_E_T_ = ' '       "+Chr(13)+Chr(10)
	
	TCSQLEXEC(cUpd) 
	dbcommitAll()          
	

    nThread := 0
	aUsers 	:= Getuserinfoarray()
	aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA191P".OR.ALLTRIM(UPPER(x[5])) == "U_CERFATALL" .OR.ALLTRIM(UPPER(x[5])) == "PRC",nThread++,nil )  })
	
	If nThread <= 30

		nTotThread += nThread
                              
		If SC5->(MsSeek(xFilial("SC5")+cPed_SC5))
	    	conout( "[CERFATALL] " + "[" + DtoC( Date() ) + " " + Time() + "] - StartJob Pedido: " + cPed_SC5 )
		   //StartJob("U_VNDA191P",GetEnvServer(),.F.,"01","02",SC5->(Recno()),.T.)  //Faturamento
			U_VNDA191P("01","02",SC5->(Recno()),.T.)  //Para debugar utilizar este
		EndIf
		 
		
	Else
		
		While nThread>30
	              
			nThread := 0
			aUsers 	:= Getuserinfoarray()
			aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_VNDA191P".OR.ALLTRIM(UPPER(x[5])) == "U_CERFATALL" .OR.ALLTRIM(UPPER(x[5])) == "PRC",nThread++,nil )  })
					
		EndDo

                 
	EndIf

    If nTotThread > 100                           
    	conout( "[CERFATPED] " + "[" + DtoC( Date() ) + " " + Time() + "] - Processou 10 threads - Libera memoria" )
	    DelClassIntf()
	    nTotThread := 0
	EndIf
	
	SC5->(DbCloseArea())
	SC6->(DbCloseArea())
	SA1->(DbCloseArea())
	CC2->(DbCloseArea())			
	
	TMP->(DbSkip())	
Enddo

Return()