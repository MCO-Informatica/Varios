#INCLUDE "PROTHEUS.CH"

STATIC __ProcStat := {}
STATIC aEntry	  := {}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA110   ºAutor  ³Armando M. Tessaroliº Data ³  23/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa reservado para realizar as funcoes do GARA110 nos  º±±
±±º          ³novos modelos de notas fiscais.                             º±±
±±º          ³Importa cliente, pedido e gera RA no financeiro, depois     º±±
±±º          ³fatura servico e mercadoria para entrega futura, integrado  º±±
±±º          ³com o GAR via WS                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GARA210()


Local aSays		:= {}
Local aButtons	:= {}
Local nOpcBat	:= 0
Local nOpcProc	:= 0
Local aArea		:= GetArea()

Local oProcess		
Local cPerg			:= "GARA210"
Private oDlgLog	:= nil
Private oDlgAux	:= nil
Private cTexto	:= ""
Private oMemo	:= nil 


Aadd( aSays, "FATURA PEDIDOS DE VENDA GAR PENDENTES" )
Aadd( aSays, "" )
Aadd( aSays, "Esta rotina tem o objetivo de gerar e transmitir nas notas fiscais dos pedidos " )
Aadd( aSays, "que apresentaram falhas na geração da nota e/ou transmissão da nota para SEFAZ. " )
Aadd( aSays, "Os espelhos serão gerados e recolocados no tunel de comunicação com o GAR." )

AjustaSX1(cPerg)
Pergunte(cPerg, .F. )

Aadd(aButtons, { 5,.T.,{|| Pergunte(cPerg, .T. ) } } )
Aadd(aButtons, { 1,.T.,{|| nOpcBat	:= 2, FechaBatch() }} )
Aadd(aButtons, { 2,.T.,{|| nOpcBat	:= 3, FechaBatch() }} )

FormBatch( "Integração com o GAR", aSays, aButtons )

If nOpcBat = 2

	oProcess := MsNewProcess():New({|lEnd| GAR210Proc(@oProcess,@lEnd)}, "Espelho GAR", "Lendo Registros para impressão",.F.)
	oProcess:Activate()
 
EndIF

RestArea(aArea)

Return(.T.)
 
Static Function GAR210Proc(oProcess,lEnd)

Local aRet			:= {}
Local nRecSF2Sfw	:= 0
Local nRecSF2Hrd	:= 0
Local cNotaSfw		:= ""
Local cNotaHrd		:= ""
Local nI,nJ
Local aRetTraPMSP	:= {}
Local aRetEspPMSP	:= {}
Local aRetTrans		:= {}
Local aRetEspelho	:= {}
Local nTime			:= 0                                            
Local cRandom		:= ""
Local cQuery		:= ""
Local nErroSC9		:= 0
Local nTotPed       := 0
Local cPedGar       := ''
Local nCount		:=0
Local nNumThrd		:= 20
Local dEmisDe   	:= ctod('01/01/2012')
Local dEmisAte   	:= ctod('31/12/2012')

dEmisDe   	:= MV_PAR01
dEmisAte   	:= MV_PAR02

cQuery:=" SELECT COUNT(*) TOTREC " 
cQuery+=" FROM( "

cQuery+=" SELECT CHVBPAG  " 
cQuery+=" FROM( "

cQuery+=" SELECT C5_CHVBPAG  AS CHVBPAG "
cQuery+=" FROM SC6010, SC5010 "
cQuery+=" WHERE C6_FILIAL='"+xFilial("SC6")+"' "
cQuery+=" AND C6_PEDGAR<>'"+Padr(" ",TamSX3("C6_PEDGAR")[1])+"'  "
cQuery+=" AND SC6010.D_E_L_E_T_<>'*' "
cQuery+=" AND C6_XOPER IN ('51','52') "
cQuery+=" AND ( (C6_QTDVEN-C6_QTDEMP-C6_QTDENT)>0 OR  (C6_QTDVEN>C6_QTDENT) ) "
cQuery+=" AND C6_NOTA='"+Padr(" ",TamSX3("C6_NOTA")[1])+"' "
cQuery+=" AND SC5010.C5_FILIAL=SC6010.C6_FILIAL "
cQuery+=" AND SC5010.C5_NUM=SC6010.C6_NUM  "
cQuery+=" AND SC5010.C5_XNPSITE = '"+Padr(" ",TamSX3("C5_XNPSITE")[1])+"'  "
cQuery+=" AND SC5010.D_E_L_E_T_<>'*' "
cQuery+=" AND SC5010.C5_EMISSAO>='"+ dtos(dEmisDe)+"' "
cQuery+=" AND SC5010.C5_EMISSAO<='"+ dtos(dEmisAte)+"' "

cQuery+=" UNION "

cQuery+=" SELECT C5_CHVBPAG AS CHVBPAG "
cQuery+=" FROM SC5010, "
cQuery+=" SC6010 SC6A "
cQuery+=" INNER JOIN SC6010 SC6B ON SC6B.C6_FILIAL=SC6A.C6_FILIAL AND SC6B.C6_NUM=SC6A.C6_NUM "
cQuery+=" WHERE "
cQuery+=" C5_FILIAL='"+xFilial("SC5")+"' "
cQuery+=" AND SC5010.C5_EMISSAO>='"+ dtos(dEmisDe)+"' "
cQuery+=" AND SC5010.C5_EMISSAO<='"+ dtos(dEmisAte)+"' "
cQuery+=" AND SC6A.C6_FILIAL =C5_FILIAL "
cQuery+=" AND SC6A.C6_NUM=C5_NUM "
cQuery+=" AND SC6A.C6_XOPER='51' "
cQuery+=" AND SC6A.C6_NOTA=' ' "
cQuery+=" AND SC6B.C6_NOTA>' ' "
cQuery+=" AND SC6B.C6_XOPER='52' "
cQuery+=" AND SC5010.D_E_L_E_T_<>'*' "
cQuery+=" AND SC6A.D_E_L_E_T_<>'*' "
cQuery+=" AND SC6B.D_E_L_E_T_<>'*' "

cQuery+=" UNION "

cQuery+=" SELECT C5_CHVBPAG AS CHVBPAG "
cQuery+=" FROM SC5010, "
cQuery+=" SC6010 SC6A "
cQuery+=" INNER JOIN SC6010 SC6B ON SC6B.C6_FILIAL=SC6A.C6_FILIAL AND SC6B.C6_NUM=SC6A.C6_NUM "
cQuery+=" WHERE "
cQuery+=" C5_FILIAL='"+xFilial("SC5")+"' "
cQuery+=" AND SC5010.C5_EMISSAO>='"+ dtos(dEmisDe)+"' "
cQuery+=" AND SC5010.C5_EMISSAO<='"+ dtos(dEmisAte)+"' "
cQuery+=" AND SC6A.C6_FILIAL =C5_FILIAL "
cQuery+=" AND SC6A.C6_NUM=C5_NUM "
cQuery+=" AND SC6A.C6_XOPER='52' "
cQuery+=" AND SC6A.C6_NOTA=' ' "
cQuery+=" AND SC6B.C6_NOTA>' ' "
cQuery+=" AND SC6B.C6_XOPER='51' "
cQuery+=" AND SC5010.D_E_L_E_T_<>'*' "
cQuery+=" AND SC6A.D_E_L_E_T_<>'*' "
cQuery+=" AND SC6B.D_E_L_E_T_<>'*' "


cQuery+=" ) GROUP BY CHVBPAG"
cQuery+=" )

PLSQuery( cQuery, "PEDGARTMP" )

nTotPed := PEDGARTMP->TOTREC

PEDGARTMP->( DbCloseArea() )

If !MsgYesNo("ATENÇÃO, serão processados "+AllTrim(Str(nTotPed))+" Pedidos. Deseja continuar???")
	Return(.F.)
Endif

cQuery:=" SELECT CHVBPAG  " 
cQuery+=" FROM( "

cQuery+=" SELECT C5_CHVBPAG AS CHVBPAG " 
cQuery+=" FROM SC6010, SC5010 "
cQuery+=" WHERE C6_FILIAL='"+xFilial("SC6")+"' "
cQuery+=" AND C6_PEDGAR<>' '  "
cQuery+=" AND SC6010.D_E_L_E_T_<>'*' "
cQuery+=" AND C6_XOPER IN ('51','52') "
cQuery+=" AND ( (C6_QTDVEN-C6_QTDEMP-C6_QTDENT)>0 OR  (C6_QTDVEN>C6_QTDENT) ) "
cQuery+=" AND C6_NOTA=' ' "
cQuery+=" AND SC5010.C5_FILIAL=SC6010.C6_FILIAL "
cQuery+=" AND SC5010.C5_NUM=SC6010.C6_NUM  "
cQuery+=" AND SC5010.C5_XNPSITE = '"+Padr(" ",TamSX3("C5_XNPSITE")[1])+"'  "
cQuery+=" AND SC5010.D_E_L_E_T_<>'*' "
cQuery+=" AND SC5010.C5_EMISSAO>='"+ dtos(dEmisDe)+"' "
cQuery+=" AND SC5010.C5_EMISSAO<='"+ dtos(dEmisAte)+"' "


cQuery+=" UNION "

cQuery+=" SELECT C5_CHVBPAG AS CHVBPAG "
cQuery+=" FROM SC5010, "
cQuery+=" SC6010 SC6A "
cQuery+=" INNER JOIN SC6010 SC6B ON SC6B.C6_FILIAL=SC6A.C6_FILIAL AND SC6B.C6_NUM=SC6A.C6_NUM "
cQuery+=" WHERE "
cQuery+=" C5_FILIAL='"+xFilial("SC5")+"' "
cQuery+=" AND SC5010.C5_EMISSAO>='"+ dtos(dEmisDe)+"' "
cQuery+=" AND SC5010.C5_EMISSAO<='"+ dtos(dEmisAte)+"' "
cQuery+=" AND SC6A.C6_FILIAL =C5_FILIAL "
cQuery+=" AND SC6A.C6_NUM=C5_NUM "
cQuery+=" AND SC6A.C6_XOPER='51' "
cQuery+=" AND SC6A.C6_NOTA=' ' "
cQuery+=" AND SC6B.C6_NOTA>' ' "
cQuery+=" AND SC6B.C6_XOPER='52' "
cQuery+=" AND SC5010.D_E_L_E_T_<>'*' "
cQuery+=" AND SC6A.D_E_L_E_T_<>'*' "
cQuery+=" AND SC6B.D_E_L_E_T_<>'*' "

cQuery+=" UNION "

cQuery+=" SELECT C5_CHVBPAG AS CHVBPAG "
cQuery+=" FROM SC5010, "
cQuery+=" SC6010 SC6A "
cQuery+=" INNER JOIN SC6010 SC6B ON SC6B.C6_FILIAL=SC6A.C6_FILIAL AND SC6B.C6_NUM=SC6A.C6_NUM "
cQuery+=" WHERE "
cQuery+=" C5_FILIAL='"+xFilial("SC5")+"' "
cQuery+=" AND SC5010.C5_EMISSAO>='"+ dtos(dEmisDe)+"' "
cQuery+=" AND SC5010.C5_EMISSAO<='"+ dtos(dEmisAte)+"' "
cQuery+=" AND SC6A.C6_FILIAL =C5_FILIAL "
cQuery+=" AND SC6A.C6_NUM=C5_NUM "
cQuery+=" AND SC6A.C6_XOPER='52' "
cQuery+=" AND SC6A.C6_NOTA=' ' "
cQuery+=" AND SC6B.C6_NOTA>' ' "
cQuery+=" AND SC6B.C6_XOPER='51' "
cQuery+=" AND SC5010.D_E_L_E_T_<>'*' "
cQuery+=" AND SC6A.D_E_L_E_T_<>'*' "
cQuery+=" AND SC6B.D_E_L_E_T_<>'*' "

cQuery+=" ) GROUP BY CHVBPAG"


PLSQuery( cQuery, "PEDGARTMP" )

DbSelectArea("PEDGARTMP")
PEDGARTMP->( DbGoTop() )

oProcess:SetRegua1(1)
oProcess:SetRegua2(nTotPed)
nThread := 0  

While PEDGARTMP->(!Eof())
     
    cPedGar:= PEDGARTMP->CHVBPAG
   	aUsers 	:= Getuserinfoarray()
	nThread := 0
	aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_GERFATPED" ,nThread++,nil )  })
	
	If nThread <= nNumThrd 
		nCount++
		oProcess:IncRegua1("Faturando pedidos")
		oProcess:IncRegua2("Processando pedido "+AllTrim(Str(nCount))+"/"+AllTrim(Str(nTotPed)))
		
		//para job use	
		StartJob("U_GERFATPED",GetEnvServer(),.F.,cEmpAnt,cFilAnt,cPedGar)
		
		//para dbugar use
		//U_GERFATPED(cPedGar)
		
		PEDGARTMP->( DbSkip() )
		
    EndIf
     
Enddo
 
PEDGARTMP->( DbCloseArea() )    

Return

USER Function GerFatPed(cEmp,cFil,cPedGar)

Local aRet			:= {}
Local nRecSF2Sfw	:= 0
Local nRecSF2Hrd	:= 0
Local cNotaSfw		:= ""
Local cNotaHrd		:= ""
Local nI,nJ
Local aRetTraPMSP	:= {}
Local aRetEspPMSP	:= {}
Local aRetTrans		:= {}
Local aRetEspelho	:= {}
Local nTime			:= 0
Local cRandom		:= ""
Local nErroSC9		:= 0

RpcSetType(2)
RpcSetEnv(cEmp,cFil)

// Etapa 02 : Geracao da Nota Prefeitura e/ou nota futura

conout("------- [GARA210] INICIO DO FATURAMENTO DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
// Reposiciona o pedido de vendas antes de realizar a liberacao para garantir que o pedido estah correto
//SC5->( DbSetOrder(5) )		// C5_FILIAL + C5_CHVBPAG

SC5->(DbOrderNickName("NUMPEDGAR"))//Alterado por LMS em 03-01-2013 para virada
SC5->( !MsSeek( xFilial("SC5")+cPedGar ) )

aRet := {}
aRet := GAR110Lib()
If !aRet[1]
	U_AddProcStat("F",aRet)
	//U_GTPutOUT('GARA210'+cPedGar,"L",cPedGar,{"u_gara210",{"L",aRet},"Falha ao liberar o pedido",SC5->C5_NUM,""})
	U_GTPutOUT('GARA210'+cPedGar,"L",cPedGar,{{"u_gara210",aRet}})
	DelClassIntf()
	Return
Endif

U_GTPutOUT('GARA210'+cPedGar,"L",cPedGar,{{"u_gara210",aRet}})

// Reposiciona o pedido de vendas antes de realizar o faturamento para garantir que o pedido estah correto
//SC5->( DbSetOrder(5) )		// C5_FILIAL + C5_CHVBPAG

SC5->(DbOrderNickName("NUMPEDGAR"))//Alterado por LMS em 03-01-2013 para virada
SC5->( MsSeek( xFilial("SC5")+cPedGar ) )

aRet := {}

aRet := GAR110Fat(@nRecSF2Sfw, @nRecSF2Hrd)
If !aRet[1]
//	conout("Retorno Falso Geracao Nota")
	U_AddProcStat("F",aRet)
	//U_GTPutOUT('GARA210'+cPedGar,"D",cPedGar,{"u_GARA120",{"D",aRet},"Falha ao gerar documento de saída",SC5->C5_NUM,''})
	U_GTPutOUT('GARA210'+cPedGar,"D",cPedGar,{{"u_gara210",aRet}})
	DelClassIntf()
	Return
Endif
	//U_GTPutOUT('GARA210'+cPedGar,"D",cPedGar,{"u_GARA120",{"D",aRet},"Documento gerado com sucesso",SC5->C5_NUM,SF2->F2_DOC})
	U_GTPutOUT('GARA210'+cPedGar,"L",cPedGar,{{"u_gara210",aRet}})

// Reposiciona o pedido de vendas para garantir que estamos falando do mesmo pedido
//SC5->( DbSetOrder(5) )		// C5_FILIAL + C5_CHVBPAG

SC5->(DbOrderNickName("NUMPEDGAR"))//Alterado por LMS em 03-01-2013 para virada
SC5->( MsSeek( xFilial("SC5")+cPedGar ) )

// Verifica se o pedido foi TOTALMENTE faturado, pois estah ficando pedido liberado e sem ser faturado
// isso acontece e nao estah sendo gerado nenhum LOG de erro, o pedido se perde no tempo e no espaco...
cQuery	:=	" SELECT  COUNT(*) QTDSC9 " +;
			" FROM    " + RetSQLName("SC9") +;
			" WHERE   C9_FILIAL = '" + xFilial("SC9") + "' AND " +;
			"         C9_PEDIDO = '" + SC5->C5_NUM + "' AND " +;
			"         C9_NFISCAL = ' ' AND " +;
			"         C9_SERIENF = ' ' AND " +;
			"         D_E_L_E_T_ = ' ' "
PLSQuery( cQuery, "SC9TMP" )
nErroSC9 := SC9TMP->QTDSC9
SC9TMP->( DbCloseArea() )

// Se por um acaso o pedido naum foi totalmente faturado, eu estorno ele todo e devolvo uma mensagem de erro
If nErroSC9 > 0
	
	U_ResetStat()
	
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000159" )
	Aadd( aRet, cPedGar )
	Aadd( aRet, "Casos de pedido que ficou sem faturar e perdeu o rastreamento." )
	
	U_AddProcStat("P",aRet)
	U_AddProcStat("F",aRet)
	
	//U_GTPutOUT('GARA210'+cPedGar,"D",cPedGar,{"u_GARA120",{"D",aRet},"Falha ao gerar documento de saída",SC5->C5_NUM,''})
	U_GTPutOUT('GARA210'+cPedGar,"D",cPedGar,{{"u_gara210",aRet}})
 
	DelClassIntf()
	Return 
Endif

If nRecSF2Sfw > 0

	// Se chegou uma nota de serviço executa a transmissao para a PMSP
	
	SF2->( DbGoto(nRecSF2Sfw) )
	
	// A Totvs nao disponibilizou a transmição da RPS para a prefeitura via WEBSERVICES.
	// Esta funcao sempre vai retornar TRUE ateh que a funcao da tranmissão seja criada
//	conout("------- [GARA210] INICIO DA TRANSMISSAO SFW DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	aRetTraPMSP := U_TransPMSP(SF2->F2_DOC,SF2->F2_SERIE,cPedGar)
//	conout("------- [GARA210] FIM DA TRANSMISSAO SFW DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")

/*
	If !aRetTraPMSP[1]
		// Se nao transmitiu, envio para o JOB de retransmissao
		conout("------- [GARA210] INICIO DA RETRANSMISSAO SFW DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
		U_RetranPMSP(aRetTraPMSP,SF2->F2_DOC,SF2->F2_SERIE,cPedGar)                   
		conout("------- [GARA210] FIM DA RETRANSMISSAO SFW DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	Endif
*/
	// Gera o arquivo espelho da nota de servico 
 //	conout("------- [GARA210] INICIO DO ESPELHO SFW DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	aRetEspPMSP := U_GARR020(aRetTraPMSP,.T.)
 //	conout("------- [GARA210] FIM DO ESPELHO SFW DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	
	If aRetEspPMSP[1]
		// Se o espelho foi gerado, recupera URI do espelho
		cNotaSfw := aRetEspPMSP[4]
	Endif

Endif

If nRecSF2Hrd > 0
	
	// Se chegou nota de hardware, transmite e gera espelho tb

	SF2->( DbGoto(nRecSF2Hrd) )
	
	// Transmite a nota eletronica para o SEFAZ e aguarda a resposta da efetivacao
   //	conout("------- [GARA210] INICIO DA TRANSMISSAO HRD DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	aRetTrans := U_Transmitenfe(SF2->F2_DOC,SF2->F2_SERIE,cPedGar)              
//	conout("------- [GARA210] FIM DA TRANSMISSAO HRD DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
	 
	/*	
	// 000132 - Codigo referente a dados com erro, naum adiante tentar retransmitir.
	// os demais codigos sao referentes a falhas na comunicacao.
	If !aRetTrans[1]
		
		U_GTPutOUT('GARA210'+cPedGar,"T",cPedGar,{"u_GARA120",{"T",aRetTrans},"Falha ao gerar documento de saída",SC5->C5_NUM,SF2->F2_ARET})

		
		// Se nao transmitiu, envio para o JOB de retransmissao
		conout("------- [GARA210] INICIO DA RETRANSMISSAO HRD DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
		U_RetranNFE(aRetTrans,SF2->F2_DOC,SF2->F2_SERIE,cPedGar)
		conout("------- [GARA210] FIM DA RETRANSMISSAO HRD DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
		
	Endif
	*/
	// TESTE - REMOVER DEPOIS... 
	// Espera um minuto
	// WaitTime(60)
	// TESTE - REMOVER DEPOIS... 
	
	nTime := Seconds()
//	Mystatus("ESPELHO -- Iniciando ...")
	
	While .T.
	//	conout("------- [GARA210] INICIO DO ESPELHO HRD DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")		
		// Gera o arquivo espelho da nota fiscal 
		SF2->( DbGoto(nRecSF2Hrd) )
		
		SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
		SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )
		
		SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
		SC5->( MsSeek( xFilial("SC5")+SC6->C6_NUM ) )
		

		If aRetTrans[2] == "000169"
			lDeneg := .T.			
			U_NFDENG02()
				
			aRetEspelho := U_NFDENG03(aRetTrans,@cRandom)
							
		else				 
		   	lDeneg := .F.
			aRetEspelho := U_GARR010(aRetTrans,@cRandom)                                                           
					
		EndIf
	  //	conout("------- [GARA210] FIM DO ESPELHO HRD DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")
		
		If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
			
			If aRetTrans[1] .AND. (!SF2->F2_FIMP $ "D")
				SF2->( DbGoto(nRecSF2Hrd) )
				SF2->( RecLock("SF2",.F.) )
				If lDeneg
					SF2->F2_FIMP := "D"
				Else	
					SF2->F2_FIMP := "S"
				EndIf
				SF2->( MsUnLock() )
			EndIf
			
			// Enviou / Gerou certinho ? Pode sair 
		//	Mystatus("ESPELHO -- saindo 001 - gerou o espelho : "+str(Seconds()-nTime))
			Exit
		Else

		
			//	Mystatus("ESPELHO -- Tentou gerar o espelho e falhou : "+str(Seconds()-nTime))
		Endif
		
		If Len(aRetEspelho) > 1 .AND. aRetEspelho[2] == "000134"
			// Ocorrencia 000134, pode sair 
			// ( Impressao fora de job , uso com remote por exemplo ) 
		//	Mystatus("ESPELHO -- saindo 002 - Impressao fora de job , uso com remote por exemplo : "+str(Seconds()-nTime))
			Exit
		Endif
		
		If !aRetTrans[1]
			// Se nao transmitiu nao adiante insistir na impressao do PDF, entao pode sair
		//	Mystatus("ESPELHO -- saindo 003 - nao transmitiu para o SEFAZ : "+str(Seconds()-nTime))
			Exit
		Endif
		
		// Verifica quanto tempo esta tentando enviar ... 
		// Se passou da 00:00, recalcula tempo 
		
		
		nWait := Seconds()-nTime
		If nWait < 0 
			nWait += 86400
		Endif

		If nWait > GetNewPar("MV_TIMESP", 45 )

	   		//U_GTPutOUT('GARA210'+cPedGar,"E",cPedGar,{"u_GARA120",{"E",aRetEspelho},"Falhou ao gerar o espelho",SC5->C5_NUM,''})
	   		U_GTPutOUT('GARA210'+cPedGar,"E",cPedGar,{{"u_gara210",aRetEspelho}})
	
			// Passou de 2 minutos tentando ? Desiste ! 
			conout("------- [GARA210] SAIU DA TENTATIVA DE ENVIANDO O ESPELHO HRD DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")		
		//	Mystatus("ESPELHO -- saindo 004 - time out : "+str(Seconds()-nTime))
			EXIT
		Endif

		// Espera um pouco ( 5 segundos ) para tentar novamente
		
	//	conout("-------[GARA210] AGUARDANDO 5 SEGUNDOS DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")		
		Sleep(2000)
	//	conout("-------[GARA210] PASSOU OS 5 SEGUNDOS DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")		
	//	Mystatus("ESPELHO -- dormindo 5 segundos... zzzzz...  : "+str(Seconds()-nTime))
		
	EndDo
//	Mystatus("ESPELHO -- fora do loop  : "+str(Seconds()-nTime))
	
	If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
		// Se gerou espelho, recupera URI do espelho 
		
		//U_GTPutOUT('GARA210'+cPedGar,"E",cPedGar,{"u_GARA120",{"E",aRetEspelho},"Gerou o Espelho ",SC5->C5_NUM,aRetEspelho[4]})
		U_GTPutOUT('GARA210'+cPedGar,"E",cPedGar,{{"u_gara210",aRetEspelho}})
		
	
		cNotaHrd := aRetEspelho[4]
	Endif	
	
Endif

// Agora monta o retorno baseado nos status de processamento 
aRet := {}

// Esta tudo certo, retorna OK + as URIs ...
Aadd( aRet, .T. )
Aadd( aRet, "000096" ) // NFS gerada com sucesso...
Aadd( aRet, cPedGar )

// Monta string com as informacoes detalhadas de nota de prefeitura 
cRetInfo := ''

If nRecSF2Sfw > 0
	cRetInfo += IIF(aRetTraPMSP[1],"T","F")+","
	cRetInfo += aRetTraPMSP[2]+","
	cRetInfo += cNotaSfw+","
Else
	cRetInfo += ',,,'
Endif

// agora acrescenta dados da sefaz
If nRecSF2Hrd > 0
	cRetInfo += IIF(aRetTrans[1].AND.aRetEspelho[1],"T","F")+","
	cRetInfo += IIF(!aRetTrans[1],aRetTrans[2],aRetEspelho[2])+","
	cRetInfo += cNotaHrd+","
Else
	//cRetInfo += ',,,'
	cRetInfo += ',,,'
Endif

// Acrescenta a linguica de retorno no 4. elemento
Aadd( aRet, cRetInfo )

// Retorno de processamento de nota futura 
U_AddProcStat("F",aRet)

//U_GTPutOUT('GARA210'+cPedGar,"Q",cPedGar,{"u_GARA120",{"Q",aRet},"Processo Finalizado com sucesso",SC5->C5_NUM,cRetInfo})
U_GTPutOUT('GARA210'+cPedGar,"Q",cPedGar,{{"u_gara210",aRetEspelho}})

conout("-------[GARA210] FIM DO PROCESSO DO PEDIDO GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")		
	
DelClassIntf()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA210   ºAutor  ³Armando M. tessaroliº Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GAR110Lib()

Local aAutoSC5		:= {}
Local aAutoSC6		:= {}
Local aItemSC6		:= {}
Local aStructSC5	:= SC5->( DbStruct() )
Local aStructSC6	:= SC6->( DbStruct() )
Local nI			:= 0
Local cCampo		:= ""
Local cAutoErr		:= ""
Local aAutoErr		:= {}
Local lLibAll			:= .T.
Local nPC5_LIBEROK	:= 0
Local cFilOld 		:= cFilAnt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O Pedido de Vendas jah vem validado e posicionado, agora verifico se estah liberado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC5->C5_LIBEROK <> "S"
	
	For nI := 1 To Len(aStructSC5)
		cCampo := aStructSC5[nI][1]
		If !Empty(&("SC5->"+cCampo))
			Aadd( aAutoSC5, { cCampo, &("SC5->"+cCampo), NIL } )
		Endif
	Next nI
	
	SC6->( DbSetOrder(1) )
	SC6->( MsSeek( xFilial("SC6")+SC5->C5_NUM ) )
	While	SC6->( !Eof() ) .AND.;
			SC6->C6_FILIAL == xFilial("SC6") .AND.;
			SC6->C6_NUM == SC5->C5_NUM
			
		If Empty(SC6->C6_NOTA) .and. SC6->C6_QTDEMP > 0
			MaAvalSC6("SC6",4,"SC5")
   		EndIf
		
		For nI := 1 To Len(aStructSC6)
			cCampo := Alltrim(aStructSC6[nI][1])
			Do Case
				Case cCampo == "C6_QTDLIB" .OR. cCampo == "C6_QTDEMP"
					If SC6->C6_XOPER == "53" .OR. !Empty(SC6->C6_NOTA) .OR. SC6->(C6_QTDVEN-C6_QTDEMP-C6_QTDENT)<=0
						Aadd( aItemSC6, { cCampo, 0, NIL } )
						lLibAll := .F.
					Else
						Aadd( aItemSC6, { cCampo, SC6->C6_QTDVEN, NIL } )
					Endif
					
				Case cCampo $ "C6_CF"
				
				Otherwise
					If !Empty(&("SC6->"+cCampo))
						Aadd( aItemSC6, { cCampo, &("SC6->"+cCampo), NIL } )
					Endif
				
			Endcase
		Next nI
		
		Aadd( aAutoSC6, aItemSC6 )
		aItemSC6 := {}
		
		SC6->( DbSkip() )
	End
	
	// Se liberou todos os itens do pedido, marco como liberado total
	nPC5_LIBEROK := Ascan( aAutoSC5, { |x| AllTrim(x[1])=="C5_LIBEROK"} )
	If lLibAll
		If nPC5_LIBEROK > 0
			aAutoSC5[nPC5_LIBEROK][2] := "S"
		Else
			Aadd( aAutoSC5, {"C5_LIBEROK", "S", Nil} )
		Endif
	Endif
	
	Private lMsErroAuto		:= .F.	// variavel interna da rotina automatica MSExecAuto()
	Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()
	
	//Renato Ruy - 13/08/2018
	//Tratamento sera incluido em todas rotinas para compatibilizacao de CFOP.
	STATICCALL( VNDA190, FATFIL, SC5->C5_NUM )
	
	MSExecAuto({|x,y,z| MATA410(x,y,z)}, aAutoSC5, aAutoSC6, 4)
	
	If cFilOld <> cFilAnt
		STATICCALL( VNDA190, FATFIL, nil ,cFilOld )
	Endif
	
	If lMsErroAuto
		cAutoErr := "SC5, SC6 --> Erro de inclusão de pedido de vendas na rotina padrão do sistema Protheus MSExecAuto({|x,y,z| MATA410(x,y,z)}, aAutoSC5, aAutoSC6, 4)" + CRLF + CRLF
		aAutoErr := GetAutoGRLog()
		For nI := 1 To Len(aAutoErr)
			cAutoErr += aAutoErr[nI] + CRLF
		Next nI
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000045" )
		Aadd( aRet, cPedGar )
		Aadd( aRet, cAutoErr )
		Return(aRet)
	Endif
	
	SC9->( DbSetOrder(1) )		// C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	If SC9->( DBSeek( xFilial("SC9")+SC5->C5_NUM ) )
//		Mystatus("CHECK - Liberacao do SC9 OK ")
	Else
//		Mystatus("CHECK - Liberacao do SC9 NAO GEROU !!!!")
	Endif
	
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utiliza arquivo de liberados para desbloquear CREDITO e ESTOQUE       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SC9->( DbSetOrder(1) )		// C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
If SC9->( DBSeek( xFilial("SC9")+SC5->C5_NUM ) )
	While	SC9->( !Eof() ) .AND.;
			SC9->C9_FILIAL == xFilial("SC9") .AND.;
			SC9->C9_PEDIDO == SC5->C5_NUM

		
		If (!Empty(SC9->C9_BLEST) .AND. !ALLTRIM(SC9->C9_BLEST)$'ZZ|10') .AND. (!Empty(SC9->C9_BLCRED).AND. !ALLTRIM(SC9->C9_BLCRED)$'ZZ|10')
			SC9->( RecLock("SC9"), .F. )
			SC9->C9_BLEST	:= ""
			SC9->C9_BLCRED	:= ""
			SC9->( MsUnLock() )
		Endif
	
		SC9->( DbSkip() )
	End
Else

//	Mystatus("*** ERRO NA CHAVE SC9 ?? ["+xFilial("SC9")+SC5->C5_NUM+"]")

	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000098" )
	Aadd( aRet, SC5->C5_CHVBPAG )
	Aadd( aRet, "" )
	Return(aRet)
Endif

aRet := {}
Aadd( aRet, .T. )
Aadd( aRet, "000099" )
Aadd( aRet, SC5->C5_CHVBPAG )
Aadd( aRet, "" )

Return(aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA210   ºAutor  ³Armando M. tessaroliº Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GAR110Fat(nRecSF2Sfw, nRecSF2Hrd)

Local lEnd			:= .F.
Local cQuery		:= ""
Local cQuerySfw		:= ""
Local cQueryHrd		:= ""
Local cCategoSFW	:= "('" + StrTran(GetNewPar("MV_GARSFT", "2"),",","','") + "')"
Local cCategoHRD	:= "('" + StrTran(GetNewPar("MV_GARHRD", "1"),",","','") + "')"
Local cNota			:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faturamento de Software - NOTA FISCAL DE SERVICO - PREFEITURA DE SAO PAULO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuerySfw:=	" SELECT  COUNT(*) B1_QTDPRO " +;
			" FROM    " + RetSQLName("SC6") + " SC6, " + RetSQLName("SC9") + " SC9, " + RetSQLName("SB1") + " SB1 " +;
			" WHERE   SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND " +;
			"         SC6.C6_PEDGAR = '" + SC5->C5_CHVBPAG + "' AND " +;
			"         SC6.D_E_L_E_T_ = ' ' AND " +;
			"         SC6.C6_XOPER = '51' AND " +;
			"         SC9.C9_FILIAL = '" + xFilial("SC9") + "' AND " +;
			"         SC9.C9_PEDIDO = SC6.C6_NUM AND " +;
			"         SC9.C9_ITEM = SC6.C6_ITEM AND " +;
			"         SC9.D_E_L_E_T_ = ' ' AND " +;
			"         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND " +;
			"         SB1.B1_COD = SC6.C6_PRODUTO AND " +;
			"         SB1.D_E_L_E_T_ = ' ' AND " +;
			"         SB1.B1_CATEGO IN " + cCategoSFW   
		PLSQuery( cQuerySfw, "SB1TMP" )
If SB1TMP->B1_QTDPRO > 0
	
	conout(" ------ [GARA210] INICIO GERACAO NF SFW PEDIDO GAR "+SC5->C5_CHVBPAG+" INICIO EM "+DtoC(date())+"  as  "+Time())
	cNota := Ma460Proc("SC9",GetNewPar("MV_GARSSFW","RP2"),.F.,.F.,.F.,.F.,.F.,3,3,"","ZZZZZZ",.F.,0,"","ZZZZZZ",.F.,.F.,"",@lEnd,"2")
	conout(" ------ [GARA210] FIM GERACAO NF SFW PEDIDO GAR "+SC5->C5_CHVBPAG+" FIM EM "+DtoC(date())+"  as  "+Time())
	
	//'SPR', 'SP2'
	SE1->( DbSetOrder(1) )
	SE1->( MsSeek( xFilial("SE1")+&(GetMV("MV_1DUPREF"))+SF2->F2_DOC ) )
	While	SE1->( !Eof() ) .AND.;
			SE1->E1_FILIAL == xFilial("SE1") .AND.;
			SE1->E1_PREFIXO == &(GetMV("MV_1DUPREF")) .AND.;
			SE1->E1_NUM == SF2->F2_DOC
		SE1->( RecLock("SE1",.F.) )
		SE1->E1_PEDGAR	:= SC5->C5_CHVBPAG
		SE1->E1_CNPJ	:= SC5->C5_CNPJ
		SE1->E1_TIPMOV	:= SC5->C5_TIPMOV
		SE1->( MsUnLock() )
		SE1->( DbSkip() )
	End
	
	// Salva o recno do arquivo para imprimir mais tarde.
	nRecSF2Sfw := SF2->( RecNo() )
	
Endif
SB1TMP->( DbCloseArea() )



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faturamento de Hardware - NOTA FISCAL DE PRODUTO - SEFAZ                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQueryHrd:=	" SELECT  COUNT(*) B1_QTDPRO " +;
			" FROM    " + RetSQLName("SC6") + " SC6, " + RetSQLName("SC9") + " SC9, " + RetSQLName("SB1") + " SB1 " +;
			" WHERE   SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND " +;
			"         SC6.C6_PEDGAR = '" + SC5->C5_CHVBPAG + "' AND " +;
			"         SC6.D_E_L_E_T_ = ' ' AND " +;
			"         SC6.C6_XOPER = '52' AND " +;
			"         SC9.C9_FILIAL = '" + xFilial("SC9") + "' AND " +;
			"         SC9.C9_PEDIDO = SC6.C6_NUM AND " +;
			"         SC9.C9_ITEM = SC6.C6_ITEM AND " +;
			"         SC9.D_E_L_E_T_ = ' ' AND " +;
			"         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND " +;
			"         SB1.B1_COD = SC6.C6_PRODUTO AND " +;
			"         SB1.D_E_L_E_T_ = ' ' "+ " AND " +;
			"         SB1.B1_CATEGO IN " + cCategoHRD 
PLSQuery( cQueryHrd, "SB1TMP" )
If SB1TMP->B1_QTDPRO > 0
	
	conout(" ------ [GARA210] INICIO GERACAO NF FUTURA HRD PEDIDO GAR "+SC5->C5_CHVBPAG+" INICIO EM "+DtoC(date())+"  as  "+Time())
	cNota := Ma460Proc("SC9",GetNewPar("MV_GARSHRD","2  "),.F.,.F.,.F.,.F.,.F.,3,3,"","ZZZZZZ",.F.,0,"","ZZZZZZ",.F.,.F.,"",@lEnd,"1")
	conout(" ------ [GARA210] FIM GERACAO NF FUTURA HRD PEDIDO GAR "+SC5->C5_CHVBPAG+" FIM EM "+DtoC(date())+"  as  "+Time())
	
	//'SPR', 'SP2'
	SE1->( DbSetOrder(1) )
	SE1->( MsSeek( xFilial("SE1")+&(GetMV("MV_1DUPREF"))+SF2->F2_DOC ) )
	While	SE1->( !Eof() ) .AND.;
			SE1->E1_FILIAL == xFilial("SE1") .AND.;
			SE1->E1_PREFIXO == &(GetMV("MV_1DUPREF")) .AND.;
			SE1->E1_NUM == SF2->F2_DOC
		SE1->( RecLock("SE1",.F.) )
		SE1->E1_PEDGAR	:= SC5->C5_CHVBPAG
		SE1->E1_CNPJ	:= SC5->C5_CNPJ
		SE1->E1_TIPMOV	:= SC5->C5_TIPMOV
		SE1->( MsUnLock() )
		SE1->( DbSkip() )
	End
	
	// Salva o recno do arquivo para imprimi mais tarde.
	nRecSF2Hrd := SF2->( RecNo() )
Endif
SB1TMP->( DbCloseArea() )

If nRecSF2Sfw == 0 .AND. nRecSF2Hrd == 0
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "000136" )
	Aadd( aRet, SC5->C5_CHVBPAG )
	Aadd( aRet, "Query de serviço-> " + cQuerySfw + CRLF + "Query de Produto-> " +cQueryHrd )
	Return(aRet)
Endif

aRet := {}
Aadd( aRet, .T. )
Aadd( aRet, "000101" )
Aadd( aRet, SC5->C5_CHVBPAG )
Aadd( aRet, "" )

Return(aRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ma460Proc ³ Autor ³Eduardo Riera          ³ Data ³28.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gauge de Processamento da Geracao da Nota Fiscal            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias da MarkBrowse                                  ³±±
±±³          ³ExpC2: Serie da Nota Fiscal a ser considerada               ³±±
±±³          ³ExpL3: Mostra Lanc.Ctb.                                     ³±±
±±³          ³ExpL4: Aglut.Lancamentos                                    ³±±
±±³          ³ExpL5: Lct.Ctb.On-Line                                      ³±±
±±³          ³ExpL6: Lct.Ctb.Custo On-Line                                ³±±
±±³          ³ExpL7: Reajusta na mesma nota                               ³±±
±±³          ³ExpN8: Calc.Acr.Fin                                         ³±±
±±³          ³ExpN9: Arred.Prc.Unit                                       ³±±
±±³          ³ExpCA: Agregador de Liberacao Inicial                       ³±±
±±³          ³ExpCB: Agregador de Liberacao Final                         ³±±
±±³          ³ExpLC: Aglutina Pedido Iguais                               ³±±
±±³          ³ExpND: Valor Minimo para faturamento                        ³±±
±±³          ³ExpNE: Transportadora Inicial                               ³±±
±±³          ³ExpNF: Transportadora Final                                 ³±±
±±³          ³ExpNG: Atualiza Amarracao Cliente x Produto                 ³±±
±±³          ³ExpNH: Cupom Fiscal                                         ³±±
±±³          ³ExpNI: Condicao a Ser Avaliada                              ³±±
±±³          ³ExpLJ: Flag de cancelamento do usuario                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma460Proc(cTabela,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,cAgregI,cAgregF,lJunta,nFatMin,cTranspI,cTranspF,lAtuSA7,lECF,cCondicao,lEnd,cCatego)

Local aArea    		:= GetArea()
Local aAreaSC9 		:= SC9->(GetArea())
Local aFiltro  		:= {}
Local nItemNf  		:= a460NumIt(cSerie)
Local nIndSC9  		:= 0
Local nIndBrw  		:= 0
Local nPosKey  		:= 0
Local nCntFor  		:= 0
Local nTotal   		:= 0
Local nNrVend  		:= Fa440CntVen()
Local nPrcVen  		:= 0
Local nRecDAK  		:= 0
Local cArqSC9  		:= ""
Local cArqBrw  		:= ""
Local cFilSC9  		:= ""
Local cQrySC9  		:= ""
Local cFilBrw  		:= ""
Local cQryBrw  		:= ""
Local cKeySC9  		:= "C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO"
Local cAuxKey  		:= ""
Local cMarca   		:= ThisMark()
Local cCursor1 		:= cTabela
Local cCursor2 		:= "SC9"
Local cCursor3 		:= "SC9"
Local cVendedor		:= ""
Local cFldQry  		:= ""
Local cNota	   		:= ""
Local cTipo9   		:= ""
Local cPedido  		:= ""
Local cSavFil  		:= cFilAnt
Local lInverte 		:= ThisInv()
Local lLibGrupo		:= SuperGetMv("MV_LIBGRUPO")=="S"
Local lQuery   		:= .F.
Local lQuebra  		:= .F.
Local lConfirma		:= .T.
Local lExecuta 		:= .T.
Local lTxMoeda 		:= .F.
Local lAcima   		:= .F.
Local lFilDAK   	:= OsVlEntCom()<>1 .And. cTabela == "DAK"
Local lM461VTot		:= ExistBlock("M461VTOT")
Local lGeraVTot		:= .T.
Local aPvlNfs  		:= {}
Local aQuebra  		:= {}
Local aQuebra2 		:= {}
Local aQuebra3 		:= {}
Local aNfCodISS		:= {}
Local bWhile1  		:= {|| !Eof() }
Local bWhile2  		:= {|| !Eof() }
Local bWhile3  		:= {|| !Eof() }
Local lCond9		:= GetNewPar("MV_DATAINF",.F.)
Local cCategoSFW	:= "('" + StrTran(GetNewPar("MV_GARSFT", "2"),",","','") + "')"
Local cCategoHRD	:= "('" + StrTran(GetNewPar("MV_GARHRD", "1"),",","','") + "')"

#IFDEF TOP
	Local cDbMs    := ""
#ENDIF	

lCond9   := IIf(ValType(lCond9)<>"L",.F.,lCond9)

If ( lExecuta )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica a data de execucao                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If GetNewPar("MV_NFCHGDT",.F.)
		If MsDate()==Date()+1
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Realiza a Selecao do SC9 e da Tabela da Markbrowse se esta existir      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP     
	
		cDbMs := UPPER(TcGetDb())
	
		If ( TcSrvType()<>"AS/400" .And. cDbMs<>"POSTGRES" )
			cAuxKey := cQrySC9
			cQrySC9 := ""
			cCursor1:= "MA460PROC"
			cCursor2:= cCursor1
			cCursor3:= cCursor2
			lQuery := .T.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Montagem dos campos do SC9                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC9")
			For nCntFor := 1 To FCount()
				cQrySC9 += ","+FieldName(nCntFor)
			Next nCntFor
			Do Case
				Case "ORACLE"==Upper(TcGetDb())
					cQrySC9 := "SELECT DISTINCT /*+FIRST_ROWS*/ "+SubStr(cQrySC9,2)
				Case "CACHE"==Upper(TcGetDb())
					cQrySC9 := "SELECT "+SubStr(cQrySC9,2)
				OtherWise
					cQrySC9 := "SELECT DISTINCT "+SubStr(cQrySC9,2)
			EndCase
			cQrySC9 += ",SC9.R_E_C_N_O_ C9RECNO "
			cQrySC9 += ",SC5.R_E_C_N_O_ C5RECNO "
			cQrySC9 += ",SC6.R_E_C_N_O_ C6RECNO, SC6.C6_QTDENT, SC6.C6_QTDVEN "
			cQrySC9 += ",SE4.R_E_C_N_O_ E4RECNO "
			cQrySC9 += ",SB1.R_E_C_N_O_ B1RECNO "
			cQrySC9 += ",SB2.R_E_C_N_O_ B2RECNO "
			cQrySC9 += ",SF4.R_E_C_N_O_ F4RECNO "
			cQrySC9 += ",SF4.F4_ISS F4ISS "
			cQrySC9 += ",SC5.C5_MOEDA "
			cQrySC9 += ",SC5.C5_DATA1 "			
			cQrySC9 += cFldQry
			If ( lJunta )
				cVendedor := "1"
				For nCntfor := 1 To nNrVend
					cQrySC9 += ",SC5.C5_VEND"+cVendedor
					If SC5->(FieldPos("C5_CODRL"+cVendedor)) > 0
						cQrySC9 += ",SC5.C5_CODRL"+cVendedor
					EndIf					
					cVendedor := Soma1(cVendedor,1)
				Next nCntFor
				cQrySC9 += ",SC5.C5_TIPO,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_LOJAENT,SC5.C5_REAJUST,SC5.C5_CONDPAG,SC5.C5_INCISS,SC5.C5_TRANSP,"
				If SC5->(FieldPos("C5_CLIENT"))>0
					cQrySC9 += "SC5.C5_CLIENT,"
				EndIf
				If SC5->(FieldPos("C5_FORNISS"))>0
					cQrySC9 += "SC5.C5_FORNISS,"
				EndIf				
				If SC5->(FieldPos("C5_RECISS"))>0
					cQrySC9 += "SC5.C5_RECISS,"
				EndIf
				cQrySC9 += "SE4.E4_TIPO,SB2.B2_LOCAL "
			Else
				cQrySC9 += ",SB2.B2_LOCAL "
			EndIf
			cQrySC9 += "FROM "+RetSqlName("SC9")+" SC9 ,"
			If ( cTabela <> "SC9" )
				cQrySC9 += RetSqlName(cTabela)+" "+cTabela+","
				If ( lFilDAK )
					cQrySC9 += RetSqlName("DAI")+" DAI,"
				Endif	
			EndIf
			cQrySC9 += RetSqlName("SC5")+" SC5 ,"
			cQrySC9 += RetSqlName("SC6")+" SC6 ,"
			cQrySC9 += RetSqlName("SE4")+" SE4 ,"
			cQrySC9 += RetSqlName("SB1")+" SB1 ,"
			cQrySC9 += RetSqlName("SB2")+" SB2 ,"
			cQrySC9 += RetSqlName("SF4")+" SF4  "
			cQrySC9 += "WHERE "
			cQrySC9 += " SC9.C9_BLCRED='"+Space(Len(SC9->C9_BLCRED))+"'"
			cQrySC9 += " AND SC9.C9_BLEST='"+Space(Len(SC9->C9_BLEST))+"'"
			cQrySC9 += " AND SC9.C9_BLWMS IN('  ','05','06','07') "
			cQrySC9 += " AND SC9.C9_PEDIDO ='"+SC5->C5_NUM+"'"
			cQrySC9 += " AND SC9.C9_AGREG>='"+cAgregI+"'"
			cQrySC9 += " AND SC9.C9_AGREG<='"+cAgregF+"'"
			cQrySC9 += " AND SC9.D_E_L_E_T_=' ' "
			cQrySC9 += " AND SC5.C5_FILIAL='"+xFilial("SC5")+"'"
			cQrySC9 += " AND SC5.C5_NUM=SC9.C9_PEDIDO"
			cQrySC9 += " AND SC5.C5_TRANSP>='"+cTranspI+"'"
			cQrySC9 += " AND SC5.C5_TRANSP<='"+cTranspF+"'"
			cQrySC9 += " AND SC5.D_E_L_E_T_=' '"
			cQrySC9 += " AND SC6.C6_FILIAL='"+xFilial("SC6")+"'"
			cQrySC9 += " AND SC6.C6_NUM=SC9.C9_PEDIDO"
			cQrySC9 += " AND SC6.C6_ITEM=SC9.C9_ITEM"
			cQrySC9 += " AND SC6.C6_PRODUTO=SC9.C9_PRODUTO"
			cQrySC9 += " AND SC6.D_E_L_E_T_=' '"
			cQrySC9 += " AND SE4.E4_FILIAL="+IIf(lFilDAK,OsFilQry("SE4","DAI.DAI_FILPV"),"'"+xFilial("SE4")+"'")
			cQrySC9 += " AND SE4.E4_CODIGO=SC5.C5_CONDPAG "
			cQrySC9 += " AND SE4.D_E_L_E_T_=' '"
			cQrySC9 += " AND SB1.B1_FILIAL="+IIf(lFilDAK,OsFilQry("SB1","DAI.DAI_FILPV"),"'"+xFilial("SB1")+"'")
			cQrySC9 += " AND SB1.B1_COD=SC9.C9_PRODUTO"
			If cCatego == "2"
				cQrySC9 += " AND SB1.B1_CATEGO IN " + cCategoSFW
				cQrySC9 += " AND SC6.C6_XOPER = '51'"
			Else
				cQrySC9 += " AND SB1.B1_CATEGO IN " + cCategoHRD
				cQrySC9 += " AND SC6.C6_XOPER = '52'"
			Endif
			cQrySC9 += " AND SB1.D_E_L_E_T_=' '"
			cQrySC9 += " AND SB2.B2_FILIAL="+IIf(lFilDAK,OsFilQry("SB2","DAI.DAI_FILPV"),"'"+xFilial("SB2")+"'")
			cQrySC9 += " AND SB2.B2_COD=SC9.C9_PRODUTO"
			cQrySC9 += " AND SB2.B2_LOCAL=SC9.C9_LOCAL"
			cQrySC9 += " AND SB2.D_E_L_E_T_=' '"
			cQrySC9 += " AND SF4.F4_FILIAL="+IIf(lFilDAK,OsFilQry("SF4","DAI.DAI_FILPV"),"'"+xFilial("SF4")+"'")
			cQrySC9 += " AND SF4.F4_CODIGO=SC6.C6_TES"
			cQrySC9 += " AND SF4.D_E_L_E_T_=' '"

			cQrySC9 := ChangeQuery(cQrySC9)
			//MEMOWRIT("\MATA461A.SQL",cQrySC9)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC9),cCursor3,.F.,.T.)
			aEval(SC9->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cCursor3,x[1],x[2],x[3],x[4]),Nil)})
		Else
	#ENDIF
	
		If ( cTabela <> "SC9" )
			cArqBrw := CriaTrab(,.F.)
			IndRegua(cTabela,cArqBrw,(cTabela)->(IndexKey()),,cFilBrw)
			nIndBrw := RetIndex(cTabela)
			#IFNDEF TOP
				dbSetOrder(1)
				Eval(bFiltraBrw)
				nIndBrw += Len(aFiltro[5])
				dbSetIndex(cArqBrw+OrdBagExt())
			#ENDIF
			dbSetOrder(nIndBrw+1)
			dbGotop()
		EndIf
		cArqSC9 := CriaTrab(,.F.)
		IndRegua("SC9",cArqSC9,cKeySC9,,cFilSC9)
		nIndSC9 := RetIndex("SC9")
		#IFNDEF TOP        
			If cTabela == "SC9"
				dbSetOrder(1)
				Eval(bFiltraBrw)
				nIndSC9 += Len(aFiltro[5])
			Endif	
			dbSetIndex(cArqSC9+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndSC9+1)
		dbGotop()
		#IFDEF TOP
		EndIf
		#ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica as condicoes de quebra de nota fiscal                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lFilDAK
		aadd(aQuebra2,{"DAI->DAI_FILPV",})
	EndIf
	If ( lJunta )
		aadd(aQuebra,{"SC9->C9_AGREG",})
		aadd(aQuebra,{"SC9->C9_CARGA",})
		aadd(aQuebra,{"SC9->C9_SEQCAR",})
		aadd(aQuebra,{"SC5->C5_TIPO",})
		aadd(aQuebra,{"SC5->C5_CLIENTE",})
		aadd(aQuebra,{"SC5->C5_LOJACLI",})
		If SC5->(FieldPos("C5_CLIENT"))>0
			aadd(aQuebra,{"SC5->C5_CLIENT",})
		EndIf
		aadd(aQuebra,{"SC5->C5_LOJAENT",})
		aadd(aQuebra,{"SC5->C5_REAJUST",})
		aadd(aQuebra,{"SC5->C5_CONDPAG",})
		aadd(aQuebra,{"SC5->C5_INCISS",})
		aadd(aQuebra,{"SC5->C5_TRANSP",})
		If SC5->(FieldPos("C5_FORNISS"))<>0
			aadd(aQuebra,{"SC5->C5_FORNISS",})
		EndIf
		cVendedor := "1"
		For nCntfor := 1 To nNrVend
			aadd(aQuebra,{"SC5->C5_VEND"+cVendedor,})
			If SC5->(FieldPos("C5_CODRL"+cVendedor))>0
				aadd(aQuebra,{"SC5->C5_CODRL"+cVendedor,})
			EndIf
			cVendedor := Soma1(cVendedor,1)
		Next nCntFor
		If SC5->(FieldPos("C5_RECISS"))>0
			aadd(aQuebra,{"SC5->C5_RECISS",})
		EndIf
	Else
		aadd(aQuebra,{"SC9->C9_CARGA",})
		aadd(aQuebra,{"SC9->C9_SEQCAR",})
		aadd(aQuebra,{"SC9->C9_AGREG",})
		aadd(aQuebra,{"SC9->C9_PEDIDO",})
	EndIf                           
	If SC9->(FieldPos("C9_CODISS")) > 0 .And. GetNewPar("MV_NFEQUEB",.F.)
		aadd(aQuebra3,{"SC9->C9_CODISS",})
	Endif
	If SC9->(FieldPos("C9_RETOPER")) > 0 .And. SB1->(FieldPos("B1_RETOPER")) > 0
		aadd(aQuebra,{"SC9->C9_RETOPER",})
	Endif
	If ( lQuery )
		aEval(aQuebra,{|x| x[1]:= SubStr(x[1],6)})
		aEval(aQuebra2,{|x| x[1]:= SubStr(x[1],6)})
		aEval(aQuebra3,{|x| x[1]:= SubStr(x[1],6)})
	EndIf	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa o Arquivo do Browse                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cCursor1)
	While Eval(bWhile1)
		Do Case
		Case cCursor2 == "DAI" .And. cTabela == "DAK"
			DAK->(dbSkip())
			nRecDAK := DAK->(Recno())
			DAK->(dbSkip(-1))
		
			dbSelectArea(cCursor2)
			dbSetOrder(1)
			MsSeek(xFilial("DAI")+(cCursor1)->DAK_COD+(cCursor1)->DAK_SEQCAR)
		Case cCursor2 == "SC9" .And. cTabela == "DAK"
		
			DAK->(dbSkip())
			nRecDAK := DAK->(Recno())
			DAK->(dbSkip(-1))
		
			If !lQuery
				dbSelectArea(cCursor3)
				dbSetOrder(nIndSC9+1)
				MsSeek(xFilial("SC9")+(cCursor1)->DAK_COD+(cCursor1)->DAK_SEQCAR)
			EndIf				
		EndCase
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processa a tabela vinculada ao browse                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		dbSelectArea(cCursor2)
		While Eval(bWhile2)
			If cTabela == "DAK"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica a Filial nal qual deve ser gerada a Nota Fiscal de Saida       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFilDAK
					If cFilAnt <> (cCursor2)->DAI_FILPV
						cFilAnt := (cCursor2)->DAI_FILPV
						MaNFSEnd()
						MaNFSInit()
					EndIf
				EndIf
				If !lQuery
					dbSelectArea(cCursor3)
					dbSetOrder(nIndSC9+1)
					MsSeek(xFilial("SC9")+(cCursor1)->DAK_COD+(cCursor1)->DAK_SEQCAR)
					If cCursor2 <> cCursor3
						(cCursor2)->(dbSkip())
					EndIf
				EndIf				
			EndIf
			dbSelectArea(cCursor3)
			While Eval(bWhile3)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona Registros                                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( !lQuery )
					dbSelectArea("SB1")
					dbSetOrder(1)
					MsSeek(xFilial("SB1")+SC9->C9_PRODUTO)

					dbSelectArea("SC5")
					dbSetOrder(1)
					MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)

					dbSelectArea("SC6")
					dbSetOrder(1)
					MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

					dbSelectArea("SB2")
					dbSetOrder(1)
					MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC9->C9_LOCAL)

					dbSelectArea("SF4")
					dbSetOrder(1)
					MsSeek(xFilial("SF4")+SC6->C6_TES)

					dbSelectArea("SE4")
					dbSetOrder(1)
					MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)
				EndIf	
				dbSelectArea(cCursor3)	
				lConfirma := .T.
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza os itens de Quebra                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aEval(aQuebra,{|x| x[2] := &(x[1])})
				aEval(aQuebra2,{|x| x[2] := &(x[1])})
				aEval(aQuebra3,{|x| x[2] := &(x[1])})				
				If !Empty(aQuebra3)
					If lQuery
						If !Empty((cCursor3)->C9_CODISS)
							aAdd(aNfCodISS,(cCursor3)->C9_CODISS)
						EndIf
					Else
						If !Empty(SC9->C9_CODISS)
							aAdd(aNfCodISS,SC9->C9_CODISS)
						EndIf
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Inicializa as variaveis de quebra do SC9                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
				If lQuery
					cPedido := (cCursor3)->C9_PEDIDO
					If lJunta
						cTipo9  := (cCursor3)->E4_TIPO
					EndIf
				Else
					cPedido := SC9->C9_PEDIDO
					If lJunta
						cTipo9  := SE4->E4_TIPO
					EndIf
				EndIf					
				
				// Verifica se bloqueia faturamento quando o 1o vencto < emissao da NF
				// na cond.pgto tipo 9. MV_DATAINF(T = Bloqueia , F = Fatura)
				// Bloqueia faturamento se a moeda nao estiver cadastrada				
				If lQuery
					If ( lCond9 .And. (cCursor3)->C5_DATA1 < (dtos(Date())) .And. !Empty((cCursor3)->C5_DATA1) );
						.Or. ( xMoeda( 1, (cCursor3)->C5_MOEDA, 1, Date() ) = 0)
						lConfirma:= .F.						
					EndIf            
				Else
					If ( lCond9 .And. SC5->C5_DATA1 < Date() .And. !Empty(SC5->C5_DATA1) );
						.Or. ( xMoeda( 1, SC5->C5_MOEDA, 1, Date() ) = 0)
						lConfirma:= .F.
					EndIf
				EndIf				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Efetua a selecao dos registros                                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( !lQuery )
					If !( SC9->C9_AGREG >= cAgregI .And. SC9->C9_AGREG <= cAgregF .And.;
							SC5->C5_TRANSP >= cTranspI .And. SC5->C5_TRANSP <= cTranspF .And.;
							IIf(cTabela=="SC9",IsMark("C9_OK",cMarca,lInverte),.T.) .And.;
							SC9->C9_BLCRED==Space(Len(SC9->C9_BLCRED)) .And.;
							SC9->C9_BLWMS$"05/06/07/  " .And.;
							SC9->C9_BLEST==Space(Len(SC9->C9_BLEST)) )
						lConfirma:= .F.
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Avalia a Expressao cCondicao                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( !Empty(cCondicao) )
					If ( !(&cCondicao) )
						lConfirma := .F.
					EndIf
				EndIf
				If ( lConfirma )
					nPrcVen := C9_PRCVEN
					If ( !lQuery )
						dbSelectArea("SC5")
					EndIf
					If ( C5_MOEDA <> 1 )
						nPrcVen := a410Arred(xMoeda(nPrcVen,C5_MOEDA,1,Date(),8),"D2_PRCVEN")
					EndIf
					If ( !lQuery )
						dbSelectArea("SC9")
					EndIf
					If nPrcVen <> 0
						aadd(aPvlNfs,{ C9_PEDIDO,;
							C9_ITEM,;
							C9_SEQUEN,;
							C9_QTDLIB,;
							nPrcVen,;
							C9_PRODUTO,;
							If(lQuery,F4ISS=="S",SF4->F4_ISS=="S"),;
							If(lQuery,C9RECNO,SC9->(RecNo())),;
							If(lQuery,C5RECNO,SC5->(RecNo())),;
							If(lQuery,C6RECNO,SC6->(RecNo())),;
							If(lQuery,E4RECNO,SE4->(RecNo())),;
							If(lQuery,B1RECNO,SB1->(RecNo())),;
							If(lQuery,B2RECNO,SB2->(RecNo())),;
							If(lQuery,F4RECNO,SF4->(RecNo())),;
							If(lQuery,B2_LOCAL,SB2->B2_LOCAL),;
							If(cTabela<>"DAK",0,If(lQuery,DAKRECNO,DAK->(RecNo()))),;
							C9_QTDLIB2})
					Else
						lTxMoeda := .T.
					EndIf
				EndIf
				dbSelectArea(cCursor3)
				dbSkip()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona Registros                                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( !lQuery )
					dbSelectArea("SB1")
					dbSetOrder(1)
					MsSeek(xFilial("SB1")+SC9->C9_PRODUTO)

					dbSelectArea("SC5")
					dbSetOrder(1)
					MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)

					dbSelectArea("SC6")
					dbSetOrder(1)
					MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

					dbSelectArea("SB2")
					dbSetOrder(1)
					MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC9->C9_LOCAL)

					dbSelectArea("SF4")
					dbSetOrder(1)
					MsSeek(xFilial("SF4")+SC6->C6_TES)

					dbSelectArea("SE4")
					dbSetOrder(1)
					MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica a quebra                                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lQuebra := .F.
				If ( aScan(aQuebra,{|x| If(x[2] <> Nil,&(x[1])<>x[2],.F.) }) <> 0 )				
					lQuebra := .T.
				ElseIf ( aScan(aQuebra2,{|x| If(x[2] <> Nil,&(x[1])<>x[2],.F.) }) <> 0 )
					lQuebra := .T.
				ElseIf ( aScan(aQuebra3,{|x| If(x[2] <> Nil,&(x[1])<>x[2].And.!Empty(&(x[1])).And.!Empty(x[2]),.F.) }) <> 0 ) .Or.;
				       ( If(!Empty(aNfCodISS).And.!Empty(If(lQuery,(cCursor3)->C9_CODISS,SC9->C9_CODISS)),aScan(aNfCodISS,If(lQuery,(cCursor3)->C9_CODISS,SC9->C9_CODISS)) == 0,.F.) )
					//Quando nao for NF Conjugada faz a quebra pelo codigo do ISS
					aNfCodIss:= {}
					lQuebra  := .T.
				EndIf

				If ( lJunta )
					If ( !lQuery )
						dbSelectArea("SE4")
					EndIf
					If ( E4_TIPO=="9" .Or. cTipo9=="9" )
						If cPedido <> (cCursor3)->C9_PEDIDO
							lQuebra := .T.
						EndIf
					EndIf
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Efetua a Geracao da Nfs                                                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(cCursor3)
				If ( lQuebra .Or. ( !Eval(bWhile3) .And. !Eval(bWhile2) ) )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica a quebra por numero de itens de nota fiscal                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aEval(aPvlNfs,{|x| nTotal += a410Arred(If(x[4]<>0,x[4],1)*x[5],"D2_TOTAL")})
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Ponto de entrada para verificar o valor total da nota                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lM461VTot
						lGeraVTot := ExecBlock("M461VTOT",.F.,.F.,{nTotal,aPvlNfs[Len(aPvlNfs),11]})
						If ValType(lGeraVTot) <> "L"
							lGeraVTot := .T.
						Endif	
					Endif	
		
					If ( nTotal > nFatMin .And. !Empty(aPvlNfs) .And. lGeraVTot )
						dbSelectArea("SC9")
						cNota := MaPvlNfs(aPvlNfs,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,lAtuSA7,lECF)						
					EndIf
					nTotal  := 0
					aPvlNfs := {}
					aNfCodISS:= {}					
				EndIf
				dbSelectArea(cCursor3)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Controle de cancelamento do usuario                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lEnd
					Exit
				EndIf
			EndDo
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Controle de cancelamento do usuario                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If lFilDAK
				cFilAnt := cSavFil
			Endif	
			
			If lEnd
				Exit
			EndIf			
		EndDo
		If ( cCursor1 <> cCursor2 )
			If (cCursor2 == "DAI" .Or. cCursor2 == "SC9") .And. cTabela == "DAK"
				dbSelectArea("DAK")
				DAK->(MSGoTo(nRecDAK))
			Else
				dbSelectArea(cCursor1)
				dbSkip()
			Endif	
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Controle de cancelamento do usuario                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lEnd
			Exit
		EndIf
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a entrada da rotina                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( lQuery )
		dbSelectArea(cCursor3)
		dbCloseArea()
		dbSelectArea("SC9")
	Else
		RetIndex("SC9")
		dbClearFilter()
		FErase(cArqSC9+OrdBagExt())
		If cTabela <> "SC9"
			RetIndex(cCursor1)
			dbClearFilter()
			FErase(cArqBrw+OrdBagExt())
		EndIf
		Eval(bFiltraBrw)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a entrada da rotina                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := cSavFil
RestArea(aAreaSC9)
RestArea(aArea)
Return(cNota)




/*
Encapsulamento para retornos de processo
Um processo do ERP pode ter mais de um retorno
cada retorno "aRet" é empilhado, com um tipo de operacao realizada
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA210   ºAutor  ³Armando M. tessaroliº Data ³  11/30/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function WaitTime(nSecs)
Local nX

For nX := 1 to nSecs
//	Mystatus("Aguardando ... "+str(nX,2))
	Sleep(1000)
Next

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA210   ºAutor  ³Microsiga           º Data ³  03/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MakeMens(cProGar,nQtdVen,nPrcVen,cCartao,cPedBpag)

Local cMensagem := ""
Local cDescri	:= ""
Local nValor	:= nQtdVen * nPrcVen
Local cTipoProd := ""

PA8->( DbSetOrder(1) )
PA8->( MsSeek( xFilial("PA8")+cProGar ) )

SB1->( DbSetOrder(1) )
SB1->( MsSeek( xFilial("SB1")+PA8->PA8_CODMP8 ) )

cTipoProd	:= SB1->B1_TIPO
cDescri		:= SB1->B1_DESC

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Trata o Nome da Operadora de Cartao de Credito                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cCartao 	:= IIF( cCartao=='AME', "Amex",			cCartao)
cCartao 	:= IIF( cCartao=='RED', "Mastercard",	cCartao)
cCartao 	:= IIF( cCartao=='VIS', "Visa",			cCartao)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Processo de Montagem de Mensagem, para SC5 com base no Produto      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If cTipoProd <> "MR"
	cMensagem:= AllTrim(cDescri) + ";"
	cMensagem+= Space(1) + "Qtde:"
	cMensagem+= Space(1) + AllTrim(Transform(nQtdVen, "@E 999,999,999.99")) + ";"
	cMensagem+= Space(1) + "Preço Unitário:"
	cMensagem+= Space(1) + AllTrim(Transform(nPrcVen, "@E 999,999,999.99")) + ";"
	cMensagem+= Space(1) + "Valor Total:"
	cMensagem+= Space(1) + AllTrim(Transform(nValor,  "@E 9,999,999,999.99")) + ";"
	cMensagem+= Space(1) + "NF Liquidada - Pedido Bpag: " + cPedBpag
Else
	cMensagem:= "NF Liquidada - Pedido Bpag: " + cPedBpag 			// + " Pgto Cartao: " + cCartao
Endif

If !Empty(cCartao)
	cMensagem+= "Pgto Cartao: " + cCartao
Endif

Return(cMensagem)


/*
Funcao de notificacao de status de processamento
Monsta msg no log de console
Atualiza informacoes da thread do Protheus Monitor
*/

STATIC Function Mystatus(cMsg)
Local cStatus := "["+dtos(date())+" "+time()+"] "
Local cEcho := cStatus + "[Thread "+alltrim(str(ThreadId(),10))+"] "

PtInternal(1,cStatus+cMsg)
//conout(cEcho+cMsg)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARA210   ºAutor  ³Microsiga           º Data ³  03/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)

Local aRegs	:=	{}

Aadd(aRegs,{cPerg,"01","Emissao de?"	,	"","","MV_CH1","D",8,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Emissao Ate?"	,	"","","MV_CH2","D",8,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

If Len(aRegs) > 0
	PlsVldPerg( aRegs )
Endif

Return(.T.)
