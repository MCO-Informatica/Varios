#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

User Function CSAG0003(nCase,oModel) //PARA ALTERA플O E FECHAMENTO SERA PASSADO O NUMERO DA OS

Local cOrdem	:= oModel:aAllSubModels[1]:ADATAMODEL[1][2][2]
Local nX     := 0
Local nY     := 0         
Local lOk    := .T.
Local cCod     := ""
Local nCalls := 0      
Local codChama := ""
Local cAssunto := GETNEWPAR('MV_CSAGASS','BK0007',"")
Local cOcor := GETNEWPAR('MV_CSAGOCO','006448',"")
Local cAcao := GETNEWPAR('MV_CSAGACA','000268',"")
Local lRet := .F.
Local aLinha := {}
Local aCabec := {}
Local aItens := {}
Local aParambox := {}
Local aRetorno	:= {}
Local aHeader	:= {}
Local aCols		:= {}
Local cMail		:= oModel:aAllSubModels[1]:ADATAMODEL[1][46][2]
Local cContato 	:= oModel:aAllSubModels[1]:ADATAMODEL[1][7][2]
Local cCliFat	:= oModel:aAllSubModels[1]:ADATAMODEL[1][9][2]
Local cLojFat	:= oModel:aAllSubModels[1]:ADATAMODEL[1][10][2]
Local cCliLoc	:= oModel:aAllSubModels[1]:ADATAMODEL[1][4][2]
Local cLojLoc	:= oModel:aAllSubModels[1]:ADATAMODEL[1][5][2]
Local cDDD		:= oModel:aAllSubModels[1]:ADATAMODEL[1][18][2]
Local cTel		:= oModel:aAllSubModels[1]:ADATAMODEL[1][19][2]

Private lMsErroAuto := .F.
Private codChama

DO CASE

	CASE nCase == 3 //INCLUS홒 DE PROTOCOLO DE ATENDIMENTO
			
		codChama := GETNUMADE() 
				
		aAdd(aCabec,{"ADE_CODIGO" 	,codChama	        		 							,Nil})
		aAdd(aCabec,{"ADE_DATA"   	,dDataBase			       	 							,Nil})
		aAdd(aCabec,{"ADE_HORA"   	,Time()			           								,Nil})
		aAdd(aCabec,{"ADE_CODCON" 	,cContato				  		 						,NIL})
		aAdd(aCabec,{"ADE_DESCIN" 	,"Codigo + Loja"										,Nil})
		aAdd(aCabec,{"ADE_TIPO" 	,"000002"												,Nil})
		aAdd(aCabec,{"ADE_ENTIDA" 	,"SA1"					 								,NIL})
		aAdd(aCabec,{"ADE_CHAVE"  	,IIF(Empty(cCliFat),cCliLoc+cLojLoc,cCliFat+cLojFat)	,NIL})
		aAdd(aCabec,{"ADE_OPERAC"   ,"1"													,NIL})
		aAdd(aCabec,{"ADE_STATUS"	,"2"													,NIL})
		aAdd(aCabec,{"ADE_INCIDE" 	,'Incluido automaticamente'                				,Nil})
		aAdd(aCabec,{"ADE_GRUPO"	,"9G"													,NIL})
		aAdd(aCabec,{"ADE_CODSB1" 	,"KT010010"		       									,Nil})
		aAdd(aCabec,{"ADE_ASSUNT" 	,cAssunto												,Nil})
		aAdd(aCabec,{"ADE_EMAIL2"	,cMail										        	,NIL})
		aAdd(aCabec,{"ADE_DDDRET"	,cDDD													,NIL})
		aAdd(aCabec,{"ADE_TELRET"	,cTel													,NIL}) 
		aAdd(aCabec,{"ADE_OPERAD"	,"000001"												,NIL})
		aAdd(aCabec,{"ADE_DATUSO"	,dDataBase										       	,NIL})
		aAdd(aCabec,{"ADE_SEVCOD"	,"3"													,NIL})
		aAdd(aCabec,{"ADE_OS" 	    ,cOrdem													,Nil})		        
				
		aAdd(aLinha,{"ADF_ITEM"        	,"001"			       	 	,Nil})
		aAdd(aLinha,{"ADF_CODSU9"    	,cOcor			      		,Nil})
		aAdd(aLinha,{"ADF_CODSUQ"    	,cAcao			  			,Nil})
		aAdd(aLinha,{"ADF_CODSU7"    	,"000001"		      		,Nil})
		aAdd(aLinha,{"ADF_CODSU0"    	,"9G"			      		,Nil})
		aAdd(aLinha,{"ADF_OBS"        	,'Incluido automaticamente' ,Nil})
		aAdd(aLinha,{"ADF_DATA"       	,dDataBase		       		,Nil})
		aAdd(aLinha,{"ADF_HORA"       	,Time()		            	,Nil})
		aAdd(aLinha,{"ADF_OS"       	,cOrdem		            	,Nil})           
		aAdd(aItens,aLinha)
		
		If Len(aCabec) > 0
			
			If Len(aLinha) > 0
			
				TMKA503A(aCabec,aItens,3, @codChama)
		
				If !lMsErroAuto
        	
   					ConOut("Chamado incluido com sucesso! Codigo=" + codChama)
       				
   					lRet := .T.   
            
				Else
        	
					ConOut("Erro na inclusao do chamado!")
        			
    				Mostraerro()
        			
    				lRet := .F.                   
            
				EndIf
				
			Else
			
				lRet := .F.
				
			Endif
			
		Else
		
			lRet := .F.
			
		Endif
		
	CASE nCase == 4	//ALTERA플O PROTOCOLO DE ATENDIMENTO PARA REALIZAR O FECHAMENTO
	
		cOcor := '006448'
		cAcao := '000267'
	
		dbSelectArea("ADE")
		dbSetOrder(28)
		dbSeek(xFilial("ADE")+cOrdem)
		
		If ADE->(Found())
		
			codChama := ADE->ADE_CODIGO
			
			BEGIN TRANSACTION                         
	
				RecLock("ADE",.F.)	
				ADE->ADE_STATUS := "3"				
				MsUnlock()
	
			END TRANSACTION
			
			dbSelectArea("ADF")
			dbSetOrder(1)
			dbSeek(xFilial("ADF")+codChama)
			
			ADF->(DbGoBottom())
			
			cItem := ADF->ADF_ITEM++			
			
			BEGIN TRANSACTION                         
	
				RecLock("ADF",.T.)
				ADF->ADF_CODIGO		:= codChama
				ADF->ADF_ITEM 		:= cItem
				ADF->ADF_CODSU9 	:= cOcor
				ADF->ADF_CODSUQ		:= cAcao
				ADF->ADF_CODSU7		:= "000001"
				ADF->ADF_CODSU0		:= "9G"
				ADF->ADF_OBS		:= "FECHAMENTO AUTOMATICO POR FINALIZA플O DE OS ATRELADA"
				ADF->ADF_DATA		:= dDataBase
				ADF->ADF_HORA		:= Time()	
				ADF->ADF_HORAF		:= Time()
				ADF->ADF_OS			:= cOrdem	
				MsUnlock()
	
			END TRANSACTION
			
			ConOut("Chamado finalizado com sucesso! Codigo=" + codChama)		

			lRet := .T.
			
		End If
    
    CASE nCase == 5	//ALTERA플O PROTOCOLO DE ATENDIMENTO PARA CONFIRMA플O DE AGENDAMENTO
	
		cOcor := '006448'
		cAcao := '000405'
	
		dbSelectArea("ADE")
		dbSetOrder(28)
		dbSeek(xFilial("ADE")+cOrdem)
		
		If ADE->(Found())
		
			codChama := ADE->ADE_CODIGO
			
			dbSelectArea("ADF")
			dbSetOrder(1)
			dbSeek(xFilial("ADF")+codChama)
			
			ADF->(DbGoBottom())
			
			cItem := ADF->ADF_ITEM++			
			
			BEGIN TRANSACTION                         
	
				RecLock("ADF",.T.)
				ADF->ADF_CODIGO		:= codChama
				ADF->ADF_ITEM 		:= cItem
				ADF->ADF_CODSU9 	:= cOcor
				ADF->ADF_CODSUQ		:= cAcao
				ADF->ADF_CODSU7		:= "000001"
				ADF->ADF_CODSU0		:= "9G"
				ADF->ADF_OBS		:= "AGENDAMENTO CONFIRMADO"
				ADF->ADF_DATA		:= dDataBase
				ADF->ADF_HORA		:= Time()	
				ADF->ADF_HORAF		:= Time()
				ADF->ADF_OS			:= cOrdem	
				MsUnlock()
	
			END TRANSACTION
			
			ConOut("Chamado alterado com sucesso! Codigo=" + codChama)		

			lRet := .T.
			
		End If
		
ENDCASE 
   	
aRet := {}
   	
aAdd(aRet,{lRet, codChama})

Return (aRet)