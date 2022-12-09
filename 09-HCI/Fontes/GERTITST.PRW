/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERTITST  ºAutor  ³Jose Mauricio       º Data ³  16/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geração do titulo a pagar de Substituição Tributaria       º±±
±±º          ³ nas operações fora do estado                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION GERTITST
LOCAL aArea := GETAREA()
LOCAL _aVetTit := {}

IF  GetMv("MV_ESTADO")=="SP" .AND. SF2->F2_ICMSRET > 0  .AND. SF2->F2_EST <> "SP"

	SA2->(DBSETORDER(1))
	IF SA2->(DBSEEK(XFILIAL("SA2")+GetMV("MV_RECEST"),.T.))

		AADD(_aVetTit,{"E2_PREFIXO", cFilAnt+"0"     , NIL} )			
		AADD(_aVetTit,{"E2_NUM",     SF2->F2_DOC     , NIL} )					
		AADD(_aVetTit,{"E2_PARCELA", "A"             , NIL} )							
		AADD(_aVetTit,{"E2_TIPO",    "ICM"           , NIL} )							
		AADD(_aVetTit,{"E2_FORNECE", SA2->A2_COD     , NIL} )							
		AADD(_aVetTit,{"E2_LOJA",    SA2->A2_LOJA    , NIL} )									
		AADD(_aVetTit,{"E2_EMISSAO", SF2->F2_EMISSAO , NIL} )									
		AADD(_aVetTit,{"E2_NATUREZ", GETMV("MV_ICMS"), NIL} )											
		AADD(_aVetTit,{"E2_VALOR",   SF2->F2_ICMSRET , NIL} )											
		AADD(_aVetTit,{"E2_MOEDA",   1               , NIL} )											
		AADD(_aVetTit,{"E2_VENCTO",  SF2->F2_EMISSAO , NIL} )													
		AADD(_aVetTit,{"E2_EMIS1",   dDataBase       , NIL} )	

   		lMsErroAuto := .F.
		MSExecAuto({|x,y| Fina050(x,y)},_aVetTit,3) //Inclusao	 C.Pagar
		If lMsErroAuto
			MSGALERT("GERTITST - NÃO FOI POSSIVEL GERAR O TITULO DE CONTAS A PAGAR DA SUBSTITUIÇÃO TRIBUTARIA")
		ENDIF
    ENDIF                    
ENDIF
RESTAREA(aArea)
RETURN