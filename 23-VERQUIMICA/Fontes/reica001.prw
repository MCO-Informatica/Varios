#Include 'Protheus.ch'
#INCLUDE "EicFi400.ch"
#INCLUDE "TOPCONN.CH"


USER FUNCTION REICA001()// Chamado do Menu

LOCAL cCamposErro:=''

If AvFlags("EIC_EAI") //AHAC 07/07/2014 - Integrado com Logix
   EasyHelp(STR0157) //"Funcionalidade não disponível para este cenário de negócio."
   RETURN .T.
EndIf

IF GetNewPar("MV_EASYFIN","N") = "N"
   MSGSTOP(STR0089,"MV_EASYFIN = N")//"Sistema nao esta integrado com o Financeiro."
   RETURN .T.
Else 								// CDS 12/01/05
   If Select("__SUBS")==0           // Essa rotina foi inclusa para não dar erro qdo ADS
      ChkFile("SE2",.F.,"__SUBS")
     Else
      DbSelectArea("__SUBS")
   EndIf
ENDIF

PRIVATE lTemWDCampos:=.T.
IF SWD->(FIELDPOS("WD_PREFIXO")) = 0 .OR.;
   SWD->(FIELDPOS("WD_PARCELA")) = 0 .OR.;
   SWD->(FIELDPOS("WD_TIPO"   )) = 0
   lTemWDCampos:=.F.
   MSGSTOP(STR0086) //"Campo WD_PREFIXO ou WD_PARCELA ou WD_TIPO nao existe."
ENDIF

IF lTemWDCampos
   IF(LEN(SWD->WD_PREFIXO) # LEN(SE2->E2_PREFIXO),cCamposErro+="WD_PREFIXO,E2_PREFIXO e ",)
   IF(LEN(SWD->WD_PARCELA) # LEN(SE2->E2_PARCELA),cCamposErro+="WD_PARCELA,E2_PARCELA e ",)
   IF(LEN(SWD->WD_TIPO)    # LEN(SE2->E2_TIPO)   ,cCamposErro+="WD_TIPO,E2_TIPO e ",)
ENDIF
IF(LEN(SWD->WD_CTRFIN1) # LEN(SE2->E2_NUM) ,cCamposErro+="WD_CTRFIN1,E2_NUM e ",)
IF(LEN(SWD->WD_FORN) # LEN(SE2->E2_FORNECE),cCamposErro+="WD_FORN,E2_FORNECE e ",)

IF !EMPTY(cCamposErro)
   cCamposErro:=LEFT(cCamposErro,LEN(cCamposErro)-3)
    MSGSTOP(STR0095 + Chr(13) + Chr(10) + ; //Campos necessarios para Integração com o Financeiro estão com tamanhos diferentes.
            STR0045 + cCamposErro + Chr(13) + Chr(10) + ;  //"Campo(s) "###" com tamanho diferente."
            STR0094) //"Favor contatar o Depto de Suporte."

   lTemWDCampos:=.F.
ENDIF

PRIVATE cFile:="", cCadastro := STR0087 //"Despachantes"
PRIVATE aRotina := MenuDef()
Private cControle := "" //RRV - 22/02/2013

mBrowse(,,,,"SA2",,,,,,,,,,,,,,filtroForn())

IF SELECT("TRB") # 0
   TRB->(E_ERASEARQ(cFile))
ENDIF

Return .T.

/**
 * EJA - 08/01/2019 - Filtro para exibir apenas fornecedores com pelo menos uma despesa do tipo 901
 */
Static Function filtroForn()

    
    Local cFilter := "R_E_C_N_O_ in ("
    Local cQuery  := ""


    cQuery += " SELECT DISTINCT A2.R_E_C_N_O_ "
    cQuery += " FROM "+ RetSqlName("SA2") +" A2 "
    cQuery += " INNER JOIN " + RetSqlName("SWD") + " SWD ON (A2_COD  = WD_FORN "
    cQuery += "                       AND A2_LOJA = WD_LOJA) "
    cQuery += " WHERE A2_FILIAL		= '" + xFilial("SA2") + "' "
    cQuery += "   AND WD_FILIAL		= '" + xFilial("SWD") + "' "
    cQuery += "   AND WD_BASEADI	= '1' "
    cQuery += "   AND SWD.D_E_L_E_T_= ' ' "
    cQuery += "   AND A2.D_E_L_E_T_	= ' ' "

    cQuery := ChangeQuery(cQuery)
    cFilter += cQuery + ")"

Return cFilter


Static Function MenuDef()
Local aRotAdic := {}
Local aRotina :=  { { STR0047, "AxPesqui"       , 0 , 1},; //"Pesquisar"
                    { STR0048, "U_EIC_DESP", 0 , 4},; //"Gera PA"
                    { STR0049, "U_EIC_DESP", 0 , 4},; //"Cancela PA"
                    { STR0116, "AxVisual"       , 0 , 2}}  //STR0116 "Visualizar"

// P.E. utilizado para adicionar itens no Menu da mBrowse
If EasyEntryPoint("IPA400MNU")
	aRotAdic := ExecBlock("IPA400MNU",.f.,.f.)
	If ValType(aRotAdic) == "A"
		AEval(aRotAdic,{|x| AAdd(aRotina,x)})
	EndIf
EndIf

Return aRotina


*------------------------------------------------------------------*
USER FUNCTION EIC_DESP(cAlias,nReg,nOpc)
*------------------------------------------------------------------*
LOCAL C,aSemSX3,oDlgPA,nOpcao:=0,nTipo:=2
PRIVATE cMarca := GetMark(), lInverte := .F.
PRIVATE lGeraPA   := (nOpc == 2)
PRIVATE lCancelPA := (nOpc == 3)
PRIVATE aBotoes:={}

lDespAtual := (nTipo == 2)

IF SELECT("TRB") = 0
   aHeader:={}
   aCampos:={}
   FOR C := 1 TO SWD->(FCOUNT())
       AADD(aCampos,SWD->(FIELD(C)))
   NEXT
   aSemSX3:={}
   AADD(aSemSX3,{"WKFLAG"    ,"C",02,0})
   AADD(aSemSX3,{"WKRECNO"   ,"N",10,0})
   //TRP - 30/01/07 - Campos do WalkThru
   AADD(aSemSX3,{"TRB_ALI_WT","C",03,0})
   AADD(aSemSX3,{"TRB_REC_WT","N",10,0})

   aSemSx3:= addWkCpoUser(aSemSx3,"SWD")

   cFile:=E_CRIATRAB(,aSemSX3)
   aCampos := Nil //THTS - 07/02/2018 - Apos a chamada do E_CriaTrab, limpa o aCampos para que nao seja utilizado de forma errada em outra chamada do E_CriaTrab
   IF !USED()
      Help(" ",1,"E_NAOHAREA")
      RETURN .F.
   ENDIF
   IndRegua("TRB",cFile+TEOrdBagExt(),"WD_FORN+WD_LOJA+WD_DOCTO")
   //TRP-18/09/08- Criação de índice a ser utilizado na busca de PAs para efetuar o Cancelamento de uma PA.
   cFile2:=E_Create(,.F.)
   IndRegua("TRB",cFile2+TEOrdBagExt(),"WD_HAWB")

   Set Index to (cFile+TEOrdBagExt()),(cFile2+TEOrdBagExt())
ENDIF

IF TRB->(FIELDPOS("WD_PREFIXO")) = 0 .OR.;
   TRB->(FIELDPOS("WD_PARCELA")) = 0 .OR.;
   TRB->(FIELDPOS("WD_TIPO"   )) = 0 .AND. lTemWDCampos
   lTemWDCampos:=.F.
   MSGSTOP(STR0088) //"Campo WD_PREFIXO ou WD_PARCELA ou WD_TIPO nao estao como 'USADO' no dicionario."
ENDIF

Processa({||  EIC_LER_SWD() }, STR0054) //"Lendo Despesas..."
SA2->(DBGOTO(nReg))

TRB->(DBGOTOP())
IF TRB->(BOF()) .AND. TRB->(EOF())
   MSGSTOP(STR0055) //"Nao foram encontradas despesas de adiantamento."
   RETURN .F.
ENDIF

TB_Campos:=ArrayBrowse("SWD","TRB",{"WD_BASEADI"})

IF lCancelPA
   FI400AADD(TB_Campos, {"WD_LOJA"   ,,AVSX3("WD_LOJA"   ,5)} )//11
   FI400AADD(TB_Campos, {"WD_FORN"   ,,AVSX3("WD_FORN"   ,5)} )//10
   FI400AADD(TB_Campos, {"WD_TIPO"   ,,AVSX3("WD_TIPO"   ,5)} )//9
   FI400AADD(TB_Campos, {"WD_PARCELA",,AVSX3("WD_PARCELA",5)} )//8
ENDIF
FI400AADD(TB_Campos, {"WD_CTRFIN1",,AVSX3("WD_CTRFIN1",5)} )//7
IF lCancelPA
   FI400AADD(TB_Campos, {"WD_PREFIXO",,AVSX3("WD_PREFIXO",5)} )//6
ENDIF
IF cPaisLoc == "ARG"
   FI400AADD(TB_Campos, {"WD_DOCTO"  ,,AVSX3("WD_DOCTO",5)} )//4
ENDIF
IF lGeraPA
   FI400AADD(TB_Campos, {"WD_LOJA"   ,,AVSX3("WD_LOJA" ,5)} )//3
   FI400AADD(TB_Campos, {"WD_FORN"   ,,AVSX3("WD_FORN" ,5)} )//2
ENDIF
FI400AADD(TB_Campos, {"WD_HAWB" ,,AVSX3("WD_HAWB" ,5)} ) // BHF - 04/08/08
FI400AADD(TB_Campos, {"WKFLAG"    ,,""} )//1

nOpcao:=0

IF lGeraPA
   AADD(aBotoes,{'EDIT'    ,{|| MSAguarde( {|| FI400IncPA(oMark)    } )},STR0048}) //"Gera PA"
   AADD(aBotoes,{"RESPONSA",{|| Processa ( {|| FI400Marca(oMark,.T.)} )},STR0052}) //STR0052 "Todos"
ELSE
   AADD(aBotoes,{'EXCLUIR',{|| MSAguarde( {|| FI400ExcPA(oMark) } )},STR0049}) //"Cancela PA"
   AADD(aBotoes,{'PESQUISA',{|| MSAguarde( {|| FI400PesqPA() } )},STR0047})
ENDIF
IF(EasyEntryPoint("EICFI400"),Execblock("EICFI400",.F.,.F.,"FI400GERAPA"),) //CCH - 13/04/09 - Ponto de Entrada para adição de novos botões em aBotoes
PRIVATE nValorS:=0
PRIVATE lLerWD_VALOR_M:=TRB->(FIELDPOS("WD_VALOR_M")) # 0 .AND. cPaisLoc == "ARG"
PRIVATE lLerWD_MOEDA  :=TRB->(FIELDPOS("WD_MOEDA"  )) # 0 .AND. cPaisLoc == "ARG"
PRIVATE cNumEICTit :=""
PRIVATE cPrefEICTit:=""
PRIVATE cParcEICTit:=""
PRIVATE cTipoEICTit:=""
PRIVATE cFornEICTit:=""
PRIVATE cLojaEICTit:=""

SA2->(DBGOTO(nReg))
oMainWnd:ReadClientCoords()
DEFINE MSDIALOG oDlgPA TITLE STR0056+IF(lDespAtual,STR0057+SA2->A2_COD+"-"+ALLTRIM(SA2->A2_NOME),'') ; //"Despesa de Adiantamento"###" - Despachante: "
      FROM oMainWnd:nTop+125,oMainWnd:nLeft+5 TO oMainWnd:nBottom-60,oMainWnd:nRight-10;
      OF oMainWnd PIXEL

   TRB->(DBGOTOP())

   //by GFP - 13/10/2010 - 14:40
   TB_Campos := AddCpoUser(TB_Campos,"SWD","2")

   oMark:=MsSelect():New("TRB","WKFLAG",,TB_Campos,lInverte,cMarca,{18,1,(oDlgPA:nClientHeight-4)/2,(oDlgPA:nClientWidth-4)/2})
   oMark:baval:={||  FI400Marca(oMark,.F.) }
   oMark:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlgPA ON INIT EnchoiceBar(oDlgPA,If(lGeraPA,{|| MSAGUARDE( {|| FI400INCPA(OMARK) , ODLGPA:END()   } )},{|| MSAguarde( {|| FI400ExcPA(oMark), oDlgPA:End() } )}),;
                                             {||nOpcao:=0,oDlgPA:End()},,aBotoes)

SA2->(DBGOTO(nReg))

Return .T.


*-------------------------------------------------------------------*
STATIC FUNCTION FI400AADD(TB_Campos,aCampo)
*-------------------------------------------------------------------*
ASIZE(TB_Campos,LEN(TB_Campos)+1)
AINS(TB_Campos,1)
TB_Campos[1]:=aCampo
Return .t.
*-------------------------------------------------------------------*
STATIC FUNCTION FI400ExcPA(oMark)
*-------------------------------------------------------------------*
LOCAL aRotOld:=ACLONE(aRotina),lMarcados:=.F.,aOrd:=SaveOrd({"SE2","SE5"})
LOCAL nRecno:=TRB->(RECNO()),lGravou:=.F., aHawbs:={}, I, nInd, nWk
LOCAL lGeraPO  := IF(GetNewPar("MV_EASYFPO","S")="S",.T.,.F.)
LOCAL lGerPrDI := IF(GetNewPar("MV_EASYFDI","S")="S",.T.,.F.)
Local lBxConc     := EasyGParam("MV_BXCONC",.T.,.F.) == "1"  //GFP - 27/08/2014
Local cChaveSWD := "" //MCF - 15/07/2016
Local aTit := {}
Private lMSErroAuto := .f.
cControle  := "ExcluiPA" //RRV - 22/02/2013

IF !lTemWDCampos
   MSGSTOP(STR0058) //"Campo WD_PREFIXO ou WD_PARCELA ou WD_TIPO nao esta correto."
   RETURN .F.
ENDIF

MsProcTxt(STR0059) //"Iniciando Cancelamento..."

TRB->(DBGOTOP())
DO WHILE !TRB->(EOF())
   IF !EMPTY(TRB->WKFLAG)
      lMarcados:=.T.
      EXIT
   ENDIF
   TRB->(DBSKIP())
ENDDO

IF !lMarcados
   TRB->(DBGOTOP())
//   MSGSTOP(STR0060) //"Nao existe registros marcados."
   oMark:oBrowse:ReFresh()
   RETURN .F.
ENDIF

SWD->(DBGOTO(TRB->WKRECNO))  //tabela se2 conta swd
cChaveSWD :=SWD->WD_PREFIXO+SWD->WD_CTRFIN1+SWD->WD_PARCELA+SWD->WD_TIPO+SWD->WD_FORN+SWD->WD_LOJA //MCF - 18/07/2016
//MFR 10/09/2021 ossme-6178 subsitituído o fina050 pelo execauto         
      AADD(aTit,{"E2_PREFIXO",SWD->WD_PREFIXO,NIL})
      AADD(aTit,{"E2_NUM"    ,SWD->WD_CTRFIN1,NIL})      
      AADD(aTit,{"E2_PARCELA",SWD->WD_PARCELA,NIL})    
      AADD(aTit,{"E2_TIPO"   ,SWD->WD_TIPO,NIL})    
      AADD(aTit,{"E2_FORNECE",SWD->WD_FORN,NIL})    
      AADD(aTit,{"E2_LOJA"   ,SWD->WD_LOJA,NIL})    
cCodFor :=TRB->WD_FORN
cLojaFor:=TRB->WD_LOJA

DBSELECTAREA("SE2")

SE2->(DBSETORDER(1))//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
IF SE2->(DBSEEK(xFilial()+cChaveSWD)) //MCF - 18/07/2016
   //GFP - 27/08/2014 - Tratamento para não permitir alteração no câmbio quando o parâmetro MV_BXCONC = 2 e a parcela já foi conciliada no financeiro.
   SE5->(DbSetOrder(2))
   If SE5->(dbSeek(xFilial("SE5")+"PA"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+Dtos(SE2->E2_EMISSAO)+SE2->E2_FORNECE+SE2->E2_LOJA))
      If !lBxConc .And. !Empty(SE5->E5_RECONC)
         MsgInfo(STR0150,STR0128) //STR0150 "Pagamento Antecipado não pode ser alterado pois foi conciliado/reconciliado no financeiro - Verifique o parâmetro MV_BXCONC" //STR0128  "Aviso"
         Return .F.
      Endif
   EndIf
    //MFR 10/09/2021 ossme-6178 subsitituído o fina050 pelo execauto   
//   bExecuta:={||nPosRot:=ASCAN(aRotina, {|R| UPPER(R[2])=UPPER("FA050Delet")}) ,;
//                lGravou:=FA050Delet("SE2",SE2->(RECNO()),IF(nPosRot=0,5,nPosRot)), If(ValType(lGravou) <> "L", lGravou := .F., ) }
                 
//   SE2->(Fina050(,,,bExecuta))
   
   MSExecAuto({|a,b,c| FINA050(a,b,c)}, aTit, nil,5)
   lGravou :=  !lMsErroAuto
   if !lGravou
      mostraErro() 
   EndIf
ELSE
   lGravou:=MSGNOYES(STR0061+; //"Lancamento no Finaceiro nao encontrado,"
                    STR0062,STR0063+cChaveSWD) //" Deseja Liberar Despesa p/ nova geracao."###"Chave: "
ENDIF

IF lGravou

   MsProcTxt(STR0064) //"Atualizando Despesa..."
   TRB->(DBSETORDER(1))
   TRB->(DBSEEK(cCodFor+cLojaFor))

   DO WHILE !TRB->(EOF()) .AND.;
      TRB->(WD_FORN+WD_LOJA) == cCodFor+cLojaFor
      MsProcTxt(STR0064) //"Atualizando Despesa..."
      IF !EMPTY(TRB->WKFLAG)
         if ascan(aHawbs,TRB->WD_HAWB)==0  // Jonato Ocorrência 0110/03
            AADD(aHawbs,TRB->WD_HAWB)
         endif
         SWD->(DBGOTO(TRB->WKRECNO))
         IF cChaveSWD == SWD->WD_PREFIXO+SWD->WD_CTRFIN1+SWD->WD_PARCELA+SWD->WD_TIPO+SWD->WD_FORN+SWD->WD_LOJA //MCF - 18/07/2016
            TRB->WKFLAG    :=""
            TRB->WD_CTRFIN1:=""
            SWD->(DBGOTO(TRB->WKRECNO))
            SWD->(RECLOCK("SWD",.F.))
            SWD->WD_CTRFIN1:=""
            SWD->WD_DTENVF :=CTOD('')
            IF lTemWDCampos
               TRB->WD_PREFIXO:=""
               TRB->WD_PARCELA:=""
               TRB->WD_TIPO   :=""
               SWD->WD_PREFIXO:=""
               SWD->WD_PARCELA:=""
               SWD->WD_TIPO   :=""
               SWD->WD_GERFIN :="2"  //ASK 16/10/2007 - Volta o campo como "2" Gera Fin. = Não , conforme o padrão
            ENDIF
            SWD->(MSUNLOCK())
         ENDIF
      ENDIF
      TRB->(DBSKIP())

   ENDDO

   IF EasyEntryPoint("FI400ExisteCampos") .AND. ExecBlock("FI400ExisteCampos",.F.,.F.,.F.) // Jonato OS 1188/03 Ocorrência 0110/03
      axFl2DelWork:={}
      for nInd :=1 to len(aHawbs)
          SW6->(DBSETORDER(1))
          IF SW6->(DBSEEK(xfilial("SW6")+aHawbs[nind]))
             aPos:={}
             FI400SW7(SW6->W6_HAWB)
	          IF lGeraPO
	              FOR I := 1 TO LEN(aPos)
	                  SW2->(DBSETORDER(1))
	                  SW2->(DBSEEK(XFILIAL("SW2")+aPos[I]))
	                  Processa({|| DeleImpDesp(SW2->W2_PO_SIGA,"PR","PO") })
	                  Processa({|| AVPOS_PO(aPos[I],"DI") })  // S.A.M. 26/03/2001
	              NEXT
             Endif
	             DeleImpDesp(SW6->W6_NUMDUP,"PRE","DI",.T.)  //ASR - 28/09/2005 - CANCELANDO PA DO DESPACHANTE
             Processa({|| AVPOS_DI(SW6->W6_HAWB, lGerPrDI) })
          ENDIF
      next
      // ***** DELETAR ARQUIVO DA FUNCAO AV POS_DI() - AWR - 27/05/2004
      If Select("WorkTP") # 0
         IF TYPE("axFl2DelWork") = "A" .AND. LEN(axFl2DelWork) > 0
            WorkTP->(E_EraseArq(axFl2DelWork[1]))
            FOR nWk:=2 TO LEN(axFl2DelWork)
                FERASE(axFl2DelWork[nWk]+TEOrdBagExt())
            NEXT
         ENDIF
      ENDIF
      // *****
   ENDIF

ENDIF

// GFP - 06/10/2012
IF(EasyEntryPoint("EICFI400"),Execblock("EICFI400",.F.,.F.,'EXC_PA'),)

aRotina:=ACLONE(aRotOld)

TRB->(DBGOTO(nRecno))

oMark:oBrowse:ReFresh()
RestOrd(aOrd,.T.)  //GFP - 27/08/2014

RETURN .T.
*-------------------------------------------------------------------*
STATIC FUNCTION FI400IncPA(oMark)
// Inseri as funcoes que tratam a geração de PA
*-------------------------------------------------------------------*
LOCAL aRotOld:=ACLONE(aRotina),lMarcados:=.F.
LOCAL nRecno:=TRB->(RECNO()),I,nind,nWk
LOCAL lOkSE2:=.f., lContabilizou, aHawbs:={} // Jonato Ocorrência 0110/03
LOCAL lGeraPO := IF(GetNewPar("MV_EASYFPO","S")="S",.T.,.F.)
LOCAL lGerPrDI := IF(GetNewPar("MV_EASYFDI","S")="S",.T.,.F.)
Local aOrdTRB :=SaveOrd({"TRB"})
PRIVATE cIniNatur:=SPACE(LEN(SE2->E2_NATUREZ)),cIniSerie:=""
cControle  := "GeraPA" //RRV - 22/02/2013
Inclui := .T. //RNLP - 10/01/2020 DTRADE-3698

IF !lTemWDCampos
   MSGSTOP(STR0058) //"Campo WD_PREFIXO ou WD_PARCELA ou WD_TIPO nao esta correto."
   RETURN .F.
ENDIF

MsProcTxt(STR0065) //"Iniciando Valores..."

cHistorico := "" //RNLP 27/11/20 - OSSME-5370 - Inicializa a variável
TRB->(DBGOTOP())
DO WHILE !TRB->(EOF())
    IF EMPTY(TRB->WKFLAG)
       TRB->(DBSKIP())
       LOOP
    ENDIF

    aOrdTRB :=SaveOrd({"TRB"})
    lMarcados:=.T.

    SWD->(DBGOTO(TRB->WKRECNO))

    IF EasyGParam("MV_EASYFIN",,"N") == "S" .AND. EMPTY(TRB->WD_FORN) //MCF - 16/09/2015
    MSGSTOP(STR0158) // "O campo Fornecedor não foi preenchido no cadastro do Despachante."
    RETURN .F.
    ENDIF

    cCodFor  :=TRB->WD_FORN
    cLojaFor :=TRB->WD_LOJA  
    cIniDocto:= NumTit("SWD","WD_CTRFIN1")    
    IF TRB->(FieldPos("WD_NATUREZ")) # 0
    cIniNatur:=TRB->WD_NATUREZ
    EndIf
    If TRB->(FieldPos("WD_SE_DOC")) > 0
    cIniSerie:=TRB->WD_SE_DOC
    EndIf

    nMoedSubs:= 1
    IF cPaisLoc == "ARG"
    IF lLerWD_MOEDA .AND. !EMPTY(TRB->WD_MOEDA)
        nMoedSubs:= SimbToMoeda(TRB->WD_MOEDA)
        nMoedSubs:= IF(nMoedSubs=0,1,nMoedSubs)
    ENDIF
    ENDIF

    nValorS:=0

   TRB->(DBSEEK(cCodFor+cLojaFor))
   cHistorico := "Proc.: "
   DO WHILE !TRB->(EOF()) .AND.;
      TRB->(WD_FORN+WD_LOJA) == cCodFor+cLojaFor

      IF !EMPTY(TRB->WKFLAG)
         IF lLerWD_VALOR_M .AND. !EMPTY(TRB->WD_VALOR_M)
            nValorS+=TRB->WD_VALOR_M
         Else
            nValorS+=TRB->WD_VALOR_R
         Endif
         cHistorico += ALLTRIM(TRB->WD_HAWB) + " | "  //RNLP 27/11/20 - OSSME-5370
      ENDIF
      TRB->(DBSKIP())
   ENDDO
   cHistorico := Avkey(cHistorico,"E2_HIST")

    //ISS - 06/01/11 - Ponto de entrada para alterar os valores iniciais da tela para inclusão de títulos no contas a pagar
    IF EasyEntryPoint("EICFI400")
    Execblock("EICFI400",.F.,.F.,"FI400INCPA_ALTCPO")
    EndIf

    cValidaOK:=" .AND. FI400IniValPA('V') "

    bIniciaVal:={|| FI400IniValPA('I') }
    lGravou:=.F.

    MsProcTxt(STR0066) //"Iniciando Inclusao..."

    DBSELECTAREA("SE2")
    bExecuta:={||nPosRot:=ASCAN(aRotina, {|R| UPPER(R[2])=UPPER("FA050Inclu")}) ,;
                lGravou:=FA050Inclu("SE2",SE2->(RECNO()),IF(nPosRot=0,3,nPosRot) ), If(ValType(lGravou) <> "N", lGravou := .F., lGravou := (lGravou == 1)) }
    
    Fina050(,,,bExecuta)
  
    IF lGravou
    MsProcTxt(STR0067) //"Gravando Titulo..."
    TRB->(DBSEEK(cCodFor+cLojaFor))
    cChave:=""
    lContabilizou:=.f.
    DO WHILE !TRB->(EOF()) .AND.;
        TRB->(WD_FORN+WD_LOJA) == cCodFor+cLojaFor

        MsProcTxt(STR0067) //"Gravando Titulo..."
        IF !EMPTY(TRB->WKFLAG)
            if ascan(aHawbs,TRB->WD_HAWB)==0  // Jonato Ocorrência 0110/03
                AADD(aHawbs,TRB->WD_HAWB)
            endif
            TRB->WKFLAG    :=""
            TRB->WD_CTRFIN1:=cNumEICTit
            SWD->(DBGOTO(TRB->WKRECNO))
            SWD->(RECLOCK("SWD",.F.))
            SWD->WD_CTRFIN1:=cNumEICTit
            IF lTemWDCampos
                SWD->WD_PREFIXO:=cPrefEICTit
                SWD->WD_PARCELA:=cParcEICTit
                SWD->WD_TIPO   :=cTipoEICTit
            ENDIF
            SWD->WD_FORN   :=cFornEICTit
            SWD->WD_LOJA   :=cLojaEICTit
            SWD->WD_DTENVF :=dDataBase
            SWD->WD_GERFIN :="1"
            SWD->(MSUNLOCK())
            cChave:=SWD->WD_PREFIXO+SWD->WD_CTRFIN1+SWD->WD_PARCELA+SWD->WD_TIPO+SWD->WD_FORN+SWD->WD_LOJA
            IF !lOkSE2
                SE2->(DBSETORDER(1))//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
                IF SE2->(DBSEEK(xFilial()+cChave))
                SE2->(RECLOCK("SE2",.F.))
                SE2->E2_ORIGEM:="SIGAEIC"
                SE2->(MSUNLOCK())
                lContabilizou:= IF(EMPTY(SE2->E2_LA),.f.,.t.)
                lOkSE2:=.t.
                ENDIF
            ENDIF
            IF lContabilizou
                SWD->(RECLOCK("SWD",.F.))
                SWD->WD_DTLANC:=dDataBase
                SWD->(MSUNLOCK())
            ENDIF
            // Jonato Ocorrência 0110/03 --> fim
        ENDIF
        TRB->(DBSKIP())

    ENDDO

    IF EasyEntryPoint("FI400ExisteCampos") .AND. ExecBlock("FI400ExisteCampos",.F.,.F.,.F.) // Jonato OS 1188/03 Ocorrência 0110/03
        axFl2DelWork:={}
        for nInd :=1 to len(aHawbs)
            SW6->(DBSETORDER(1))
            IF SW6->(DBSEEK(xfilial("SW6")+aHawbs[nind]))
                aPos:={}
                FI400SW7(SW6->W6_HAWB)
                IF lGeraPO
                    FOR I := 1 TO LEN(aPos)
                        nOrderSW2:=SW2->(INDEXORD())
                        SW2->(DBSETORDER(1))
                        SW2->(DBSEEK(XFILIAL("SW2")+aPos[I]))
                        Processa({|| DeleImpDesp(SW2->W2_PO_SIGA,"PR","PO") })
                        Processa({|| AVPOS_PO(aPos[I],"DI") })  // S.A.M. 26/03/2001
                        SW2->(DBSETORDER(nOrderSW2))
                    NEXT
                Endif
                DeleImpDesp(SW6->W6_NUMDUP,"PRE","DI",.T.)
                Processa({|| AVPOS_DI(SW6->W6_HAWB, lGerPrDI) })	//ASR - 28/09/2005 - GERANDO O PA DO DESPACHANTE
            ENDIF
        next
        // ***** DELETAR ARQUIVO DA FUNCAO AV POS_DI() - AWR - 27/05/2004
        If Select("WorkTP") # 0
            IF LEN(axFl2DelWork) > 0
                WorkTP->(E_EraseArq(axFl2DelWork[1]))
                FOR nWk:=2 TO LEN(axFl2DelWork)
                    FERASE(axFl2DelWork[nWk]+TEOrdBagExt())
                NEXT
            ENDIF
        ENDIF
        //*******************

    ENDIF
    // Jonato ocorrência 0110/03 --> fim
    ENDIF

    IF !empty(aOrdTRB)
       RestOrd(aOrdTRB,.T.)
    EndIF 

    TRB->(DBSKIP())
ENDDO

IF !lMarcados
    TRB->(DBGOTOP())
    //   MSGSTOP(STR0060) //"Nao existe registros marcados."
    oMark:oBrowse:ReFresh()
    RETURN .F.
ENDIF

aRotina:=ACLONE(aRotOld)

TRB->(DBGOTO(nRecno))

oMark:oBrowse:ReFresh()

Return .T.
*-------------------------------------------------------------------*
STATIC FUNCTION FI400IniValPA(cExe)
*-------------------------------------------------------------------*
LOCAL c_DuplDoc
Private cTipoAdnt := ""

IF(EasyEntryPoint("EICFI400"),Execblock("EICFI400",.F.,.F.,"ANTES_VAL_TIPO_PA"),)

IF cExe = 'V'

   IF !(ALLTRIM(M->E2_TIPO) $ AvKey("PA","WD_TIPO")+IF(!Empty(cTipoAdnt) .And. FI400ValTpO(cTipoAdnt),"/"+AvKey(cTipoAdnt,"WD_TIPO"),""))
      MSGSTOP(STR0068+"PA"+IF(!Empty(cTipoAdnt),"/"+cTipoAdnt,""),STR0069) //"Tipo deve ser igual a "###"Verificao Importacao"
      Return .F.
   ENDIF

   IF cCodFor # M->E2_FORNECE .OR. cLojaFor # M->E2_LOJA
      MSGSTOP(STR0070+cCodFor+"-"+cLojaFor,STR0069) //"Fornecedor nao pode ser diferente de: "###"Verificao Importacao"
      Return .F.
   ENDIF

   IF M->E2_VALOR != nValorS .Or. M->E2_VLCRUZ != nValorS .Or. M->E2_SALDO != nValorS .Or. M->E2_MOEDA != nMoedSubs
      MSGSTOP(STR0169, STR0069)
      Return .F.
   EndIf
   
   If M->E2_PREFIXO <> 'EIC'
       MSGSTOP(STR0171, STR0069) //"Não é permitido alterar o prefixo do Título"
      Return .F.
   EndIf

   cPrefEICTit:=M->E2_PREFIXO
   cParcEICTit:=M->E2_PARCELA
   cTipoEICTit:=M->E2_TIPO
   cNumEICTit :=M->E2_NUM
   cFornEICTit:=M->E2_FORNECE
   cLojaEICTit:=M->E2_LOJA

ELSEIF cExe = 'I'

   If !Empty(cIniNatur)
      M->E2_NATUREZ:=cIniNatur
   EndIf

   M->E2_FORNECE := AvKey(cCodFor,"E2_FORNECE")
   M->E2_LOJA 	:=  AvKey(cLojaFor,"E2_LOJA")
   If SA2->(DbSeek(xFilial("SA2")+AvKey(cCodFor,"E2_FORNECE")+AvKey(cLojaFor,"E2_LOJA")))
      M->E2_NATUREZ := SA2->A2_NATUREZ
   EndIf

   c_DuplDoc := GetNewPar("MV_DUPLDOC"," ")
   IF SUBSTR(c_DuplDoc,1,1) == "S" .AND. !EMPTY(cIniDocto)
      M->E2_NUM:=cIniDocto
   ENDIF

   M->E2_PREFIXO := "EIC"
   M->E2_TIPO    := AvKey("  ","E2_TIPO")
   M->E2_HIST    := cHistorico   // BHF - 04/08/08
   If cPaisLoc == "ARG"
      M->E2_PREFIXO := &(EasyGParam("MV_2DUPREF"))
      If !Empty(cIniSerie)
         M->E2_PREFIXO:=cIniSerie
      EndIf
   EndIf

   // GCC - 09/08/2013 - Passar a data base do sistema como default na geração de pagamento antecipado
   M->E2_VENCTO   := dDataBase
   M->E2_VENCREA  := DataValida(M->E2_VENCTO,.T.)
      
   If type("nValDig") == "N" .And. INCLUI //RNLP - 10/01/2020 DTRADE-3698   
      nValDig := M->E2_VALOR
   Endif   

EndIf

IF(EasyEntryPoint("EICFI400"),Execblock("EICFI400",.F.,.F.,"FI400INIVALPA"),) // LDR
Return .T.

*-------------------------------------------------------------------*
STATIC FUNCTION FI400Marca(oMark,lTodos)   // Jonato Ocorrência 0110/03
*------------------------------------------------------------------*
LOCAL cMarcaNew:=IF(EMPTY(TRB->WKFLAG),cMarca,"")
LOCAL cForn :=TRB->WD_FORN
LOCAL cLoja :=TRB->WD_LOJA
LOCAL cDocto:=TRB->WD_DOCTO
LOCAL cMoeda:="   "
LOCAL nRecno:=TRB->(RECNO())
LOCAL cChave:=""

IF !lTodos
   IF !EMPTY(TRB->WD_CTRFIN1) .AND. lGeraPA
      MSGSTOP(STR0071+MVPagAnt,STR0069) //"Despesa ja possui "###"Verificao Importacao"
      Return .F.
   ENDIF

   IF EMPTY(TRB->WD_CTRFIN1) .AND. lCancelPA
      MSGSTOP(STR0072+MVPagAnt,STR0069) //"Despesa nao possui "###"Verificao Importacao"
      Return .F.
   ENDIF
ENDIF

IF lDespAtual .AND. cPaisLoc # "ARG" .AND. !lTodos .AND. !lCancelPA
   TRB->WKFLAG:=cMarcaNew
   oMark:oBrowse:ReFresh()
   Return .T.
ENDIF

IF lTemWDCampos
   SWD->(DBGOTO(TRB->WKRECNO))
   cChave:=SWD->WD_PREFIXO+SWD->WD_CTRFIN1+SWD->WD_PARCELA+SWD->WD_TIPO+SWD->WD_FORN+SWD->WD_LOJA
ENDIF

If cPaisLoc == "ARG"
   If lLerWD_MOEDA .AND. !EMPTY(TRB->WD_MOEDA)
      cMoeda:=TRB->WD_MOEDA
   Endif
Endif

TRB->(DBGOTOP())

DO WHILE !TRB->(EOF())

   TRB->WKFLAG:=""

   IF lTodos
      IF !EMPTY(TRB->WD_CTRFIN1) .AND. lGeraPA
         TRB->(DBSKIP())
         LOOP
      ENDIF
      IF EMPTY(TRB->WD_CTRFIN1) .AND. lCancelPA
         TRB->(DBSKIP())
         LOOP
      ENDIF
      TRB->WKFLAG:=cMarcaNew
      TRB->(DBSKIP())
      LOOP
   ENDIF

   IF (lTemWDCampos .AND. lCancelPA)//Cancelamento

      SWD->(DBGOTO(TRB->WKRECNO))
      IF cChave == SWD->WD_PREFIXO+SWD->WD_CTRFIN1+SWD->WD_PARCELA+SWD->WD_TIPO+SWD->WD_FORN+SWD->WD_LOJA
         TRB->WKFLAG:=cMarcaNew
      ENDIF

   ELSE

      IF TRB->(WD_FORN+WD_LOJA)        == cForn+cLoja    .AND.;
         (cPaisLoc # "ARG" .OR. cDocto == TRB->WD_DOCTO) .AND.;
         (!lLerWD_MOEDA    .OR. cMoeda == TRB->WD_MOEDA)
         TRB->WKFLAG:=cMarcaNew
      ENDIF

   ENDIF

   TRB->(DBSKIP())

ENDDO

TRB->(DBGOTO(nRecno))

oMark:oBrowse:ReFresh()

Return .T.


// GFP - 14/10/2015 - Alterado a função EIC_LER_SWD() para busca de adiantamentos via Query, melhorando performance.
*------------------------------------------------------------------*
STATIC FUNCTION EIC_LER_SWD()
*------------------------------------------------------------------*
LOCAL cQuery := ""
Local lMultiFil  := VerSenha(115) .and. FWModeAccess("SWD") == "E"
Local aFilSel,cFilSel := ""
Private cTipoAd := ""
If Type("cTipoAdnt") == "U"
   cTipoAdnt:= ""
EndIf

IF(EasyEntryPoint("EICFI400"),Execblock("EICFI400",.F.,.F.,"ANTES_LER_SWD_PA"),)

ProcRegua(10)

DBSELECTAREA("TRB")
AvZap()

If Select("WKSWDPA") > 0
   WKSWDPA->(dbClosearea())
EndIf

If lMultiFil
   aFilSel:=AvgSelectFil(.T.,"SWD")
   If Len(aFilSel) > 1 .Or. aFilSel[1] <> "WND_CLOSE" // Clicou em Cancelar na tela de seleção de filiais
      aEval( aFilSel , {|x| cFilSel += " '"+x+"' "+If( aScan(aFilSel,x) < Len(aFilSel) ,",","") } , 1 , Len(aFilSel) )
   Else
      cFilSel := " '"+xFilial("SWD")+"' "
   EndIf
Else
   cFilSel := " '"+xFilial("SWD")+"' "
EndIf

cQuery += " SELECT SWD.*,SWD.R_E_C_N_O_ AS NUNREC FROM " + RetSqlName("SWD") + " SWD "
cQuery += " INNER JOIN " + RetSqlName("SW6") + " SW6 ON SW6.W6_FILIAL = '" + xFilial("SW6") + "' AND SW6.W6_HAWB = SWD.WD_HAWB "
cQuery += " WHERE SWD.WD_BASEADI = '1'"/* AND SW6.W6_TIPOFEC <> 'DIN' "*/ // LRS - 22/01/2015 - Permite a geração de PA para despesas gerado no desembaraço Nacional

cQuery += " AND SWD.WD_FILIAL IN ("+cFilSel+")"

IF SWD->(FieldPos("WD_DA_ORI")) > 0 //LRS - 04/01/2017 - Para não trazer as despesas copiadas do processo original para nacionalização
   cQuery += " AND SWD.WD_DA_ORI <> '1'"
ENDIF 

If lGeraPA
   cQuery += " AND SWD.WD_CTRFIN1 = '' "
Else
   cQuery += " AND SWD.WD_CTRFIN1 <> '' "
EndIf

If lCancelPA
   cQuery += " AND (SWD.WD_TIPO LIKE '%PA%' "
   If !Empty(cTipoAd) .And. FI400ValTpO(cTipoAd)
      cQuery += " OR SWD.WD_TIPO LIKE '" + AvKey(cTipoAdnt,"WD_TIPO") + "' )"
   Else
      cQuery += ") "
   EndIf
EndIf
//LRS - 01/12/2015 - Correção do cQuery para Bancos DB2
If lDespAtual
   cQuery += " AND SWD.WD_FORN = '" + SA2->A2_COD + "'"
   cQuery += " AND SWD.WD_LOJA = '" + SA2->A2_LOJA + "'"
EndIf

If TcSrvType() <> "AS/400" //.AND. TcSrvType() <> "iSeries"
    cQuery += " AND SWD.D_E_L_E_T_ <> '*' AND SW6.D_E_L_E_T_ <> '*'"
Else
    cQuery += "SWD.@DELETED@ <> '*' AND SW6.@DELETED@ <> '*'"
EndIf

cQuery:= ChangeQuery(cQuery)
TcQuery cQuery ALIAS "WKSWDPA" NEW
TCSetField( "WKSWDPA", "WD_INTEGRA", AVSX3("WD_INTEGRA",2), AVSX3("WD_INTEGRA",3), AVSX3("WD_INTEGRA",4))
TCSetField( "WKSWDPA", "WD_NUMERA" , AVSX3("WD_NUMERA",2), AVSX3("WD_NUMERA",3), AVSX3("WD_NUMERA",4))

WKSWDPA->(DbGoTop())
Do While WKSWDPA->(!Eof())
   TRB->(DBAPPEND())
   AVREPLACE("WKSWDPA","TRB")
   TRB->WKRECNO    := WKSWDPA->NUNREC //LRS - 16/08/2018
   TRB->TRB_ALI_WT := "SWD"
   TRB->TRB_REC_WT := WKSWDPA->NUNREC //LRS - 16/08/2018
   WKSWDPA->(DbSkip())
EndDo

If Select("WKSWDPA") > 0
   WKSWDPA->(dbClosearea())
EndIf

Return .T.


Static Function NumTit(cAlias,cCampo)

Local cNum := ""

IF FindFunction("AvgNumSeq") .AND. EasyGParam("MV_EICNUMT",,"1") == "1"
   cNum:=AvgNumSeq(cAlias,cCampo)
ELSE
   If EasyGParam("MV_EICNUMT",,"1") == "2"
      cNum:=GetSXENum("SE2","E2_NUM")
   Else
      cNum:=GetSXENum(cAlias,cCampo)
   EndIf

   ConfirmSX8()
ENDIF

Return cNum
