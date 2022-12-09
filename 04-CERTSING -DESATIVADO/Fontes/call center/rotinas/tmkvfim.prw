#include "Protheus.ch"

//+-------------------------------------------------------------------+
//| Rotina | TMKVFIM | Autor | Rafael Beghini | Data | 21.07.2015 
//+-------------------------------------------------------------------+
//| Descr. | PE na chamada da gravacao do TeleAtendimento para alterar
//|        | campos da SC5 (Pedido Vendas)
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function TMKVFIM(cNumTMK, cPedido)
	Local __aArea	:= GetArea()
	Local cEmpOld	:= cEmpAnt
	Local cFilOld	:= cFilAnt
	Local lFatFil 	:= .F.
	Local _aItemPV	:= {}
	Local cCategoHRD:= GetNewPar("MV_GARHRD", "1")
	Local cC6_CF := ''
	
	Private lMsErroAuto := .F.
	
	SC5->(DbSetOrder(1))
	SA1->(DbSetOrder(1))
	
	If SC5->(DbSeek(xFilial("SC5")+cPedido))
		IF SUA->UA_OPER == '1' //Faturamento	
			
			SA1->( dbSeek( xFilial( 'SA1' ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )
			
			n := 1
			
			MsDocument("SC5", SC5->(Recno()), 1)
			
			SC5->( RecLock("SC5",.F.) )
				SC5->C5_XNATURE := GetNewPar("MV_XNATCLI","FT010010")
				SC5->C5_ATDTLV 	:= cNumTMK
				SC5->C5_VEND2 	:= IIF(SUA->UA_XVCOMP=="1",SUA->UA_XVEND2,"")	
				If SUA->(DbSeek(xFilial("SUA")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)) .and. !"***Novo Cliente Criado Automaticamente***" $ SC5->C5_XOBS  
					SC5->C5_XOBS	:= "***Novo Cliente Criado Automaticamente***"+CRLF+SC5->C5_XOBS
				EndIf
				SC5->C5_XORIGPV := "4"
				SC5->C5_INDPRES := "3"
			SC5->(MsUnlock()) 
			
			SC6->(DbSetOrder(1))
			If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
				While !SC6->(EoF()) .AND. SC6->C6_NUM = SC5->C5_NUM
					SC6->(RecLock("SC6",.F.))
					SC6->C6_TES	:= u_GFAT001(SC6->C6_PRODUTO,SC5->C5_CLIENTE,SC5->C5_LOJACLI,.T.)                                                
					SC6->C6_CF	:= u_GFAT002(SC6->C6_PRODUTO,SC5->C5_CLIENTE,SC5->C5_LOJACLI,.T.)
					SC6->(MsUnlock())
					
					cC6_CF := MultT()
					
					If Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_CATEGO") $  cCategoHRD
						AADD( _aItemPV,{	{"LINPOS"    , "C6_ITEM"   , SC6->C6_ITEM },; // Numero do Item no Pedido
			  								{"AUTDELETA" , "N"         , Nil          },; // Se o item deve ser excluído
			  								{"C6_TES"    , SC6->C6_TES , Nil          },; // Operação a ser atualizada para ajustar o item de acordo a FIlial,;
			  								{"C6_CF"     , cC6_CF      , Nil          }})
			  		EndIf	

					SC6->(DbSkip())					
				EndDo	
			EndIf
			
			Processa( { || COPYAC9(cNumTMK,cPedido) } )
			
			lFatFil := STATICCALL( VNDA190, FATFIL, cPedido)
			
			//Tratamento para alteração da filial de faturamento caso conte com produto de hardware
			//e o cliente se enquadre na regra de faturamento por filial
			If Len(_aItemPV) > 0
				If lFatFil
					MSExecAuto({|x,y,z|Mata410(x,y,z)},{{"C5_NUM",SC5->C5_NUM,Nil}},_aItemPV,4)
					STATICCALL( VNDA190, FATFIL, nil ,cFilOld )
				EndIf
			EndIf
		EndIF
	EndIf
	
	RestArea(__aArea)
Return

Static Function MultT()
	Local aDadosCfo := {}
	Local cRet := ''
	Aadd(aDadosCfo,{"OPERNF","S"})
	Aadd(aDadosCfo,{"TPCLIFOR",SC5->C5_TIPOCLI})					
	Aadd(aDadosCfo,{"UFDEST",Iif(SC5->C5_TIPO $ "DB",SA2->A2_EST,SA1->A1_EST)})
	Aadd(aDadosCfo,{"INSCR" ,Iif(SC5->C5_TIPO$"DB",SA2->A2_INSCR,SA1->A1_INSCR)})
	Aadd(aDadosCfo,{"CONTR", SA1->A1_CONTRIB})
	cRet := MaFisCfo(,Iif(!Empty(SC6->C6_CF),SC6->C6_CF,SF4->F4_CF),aDadosCfo)
Return( cRet )

//+-------------------------------------------------------------------+
//| Rotina | COPYAC9 | Autor | Rafael Beghini | Data | 21.07.2015 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para Copia dos Arquivos anexados a Um atendimento
//|        | 
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function COPYAC9(cNumTMK,cPedido)
	Local _cSql	    := ""
	
	_cSql := " SELECT "
	_cSql += " AC9_CODOBJ "
	_cSql += " FROM "
	_cSql += " "+RetSqlName("AC9")+" AC9 INNER JOIN "+RetSqlName("ACB")+" ACB ON "
	_cSql += " AC9_CODOBJ = ACB_CODOBJ "
	_cSql += " WHERE "
	_cSql += " AC9_FILIAL = '"+xFilial("AC9")+"' AND "
	_cSql += " AC9_ENTIDA = 'SUA' AND "
	_cSql += " AC9_CODENT = '"+xFilial("SUA")+AllTrim(cNumTMK)+"' AND "
	_cSql += " AC9.D_E_L_E_T_ = ' ' AND "
	_cSql += " ACB_FILIAL = '"+xFilial("ACB")+"' AND "
	_cSql += " ACB.D_E_L_E_T_ = ' ' "
	
	If select("TMKCB") > 0
	TMKCB->(DbCloseArea())				
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSql),"TMKCB",.F.,.T.)					
	ProcRegua( TMKCB->( RecCount() ) )
	
	AC9->(DbSetOrder(1))
	
	While !TMKCB->((EoF()))
		IncProc("Atualizando Documentos do Pedido")
		If !AC9->(DbSeek(xFilial("AC9")+TMKCB->AC9_CODOBJ+"SC5"+xFilial("SC5")+cPedido))
	    	RecLock("AC9",.T.)
	    	AC9->AC9_FILIAL	:= xFilial("AC9") 
	    	AC9->AC9_FILENT	:= xFilial("SC5")  
	    	AC9->AC9_ENTIDA	:= "SC5"
	    	AC9->AC9_CODENT	:= cPedido
	    	AC9->AC9_CODOBJ	:= TMKCB->AC9_CODOBJ  
	    	AC9->(MsUnlock())
	 	EndIf
	   	TMKCB->(DbSkip())	
	Enddo
Return