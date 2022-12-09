#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ETIQIMP ºAutor  ³Luiz Alberto        º Data ³  12/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION RFATR02()
    LOCAL aCampos      := {{"F2_SERIE","Serie","@!"},{"F2_DOC","Num.Documento","@!"},{"F2_CLIENTE","Cliente","@!"},;
        {"F2_LOJA","Loja","@!"},{"F2_EMISSAO","Emissao"}}
    LOCAL nOpc         := 0
    LOCAL aMarked      := {}
    LOCAL aDesc        := {"Este programa imprime etiquetas de","volumes de acordo com","os parametros informados"}
    PRIVATE Exec       := .F.
    PRIVATE cIndexName := ''
    PRIVATE cIndexKey  := ''
    PRIVATE cFilter    := ''
    Tamanho  := "M"
    titulo   := "Impressao de Etiqueta de Volumes"
    cDesc1   := "Este programa destina-se a impressao de Etiquetas de Volumes."
    cDesc2   := ""
    cDesc3   := ""
    cString  := "SF2"
    wnrel    := "ETIQIMP"
    lEnd     := .F.
    aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
    nLastKey := 0
    dbSelectArea("SF2")
    cPerg    := "ETIQIMP"
    AJUSTASX1()
    PERGUNTE(cPerg,.F.)
    wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)
    IF nLastKey == 27
        Set Filter to
        Return
    ENDIF
    SETDEFAULT(aReturn,cString)
    IF nLastKey == 27
        Set Filter to
        Return
    ENDIF
    nOpc := 1
    IF nOpc == 1
        cIndexName := Criatrab(Nil,.F.)
        cIndexKey  := 	"F2_X_EMPFA+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA"
        cFilter    := 	"F2_SERIE >= '" + MV_PAR01 + "' .And. F2_SERIE <= '" + MV_PAR02 + "' .And. " + ;
            "F2_DOC     >= '" + MV_PAR03 + "' .And. F2_DOC     <= '" + MV_PAR04 + "' .And. " + ;
            "F2_CLIENTE >= '" + MV_PAR05 + "' .And. F2_CLIENTE <= '" + MV_PAR06 + "' .And. " + ;
            "F2_LOJA >= '" + MV_PAR07 + "' .And. F2_LOJA <= '" + MV_PAR08 + "' .And. " + ;
            "F2_TRANSP >= '" + MV_PAR11 + "' .And. F2_TRANSP <= '" + MV_PAR12 + "' .And. " + ;
            "F2_EMISSAO >= CTOD('" + DTOC(MV_PAR09) + "') .And. F2_EMISSAO <= CTOD('" + DTOC(MV_PAR10) + "') .And. " + ;
            "F2_X_EMPFA >= '" + MV_PAR13 + "' .And. F2_X_EMPFA <= '" + MV_PAR14 + "' "
//	"F2_FILIAL   = '"+xFilial()+"' "
//	"F2_VOLUME1 > 0 .And. F2_FILIAL   = '"+xFilial()+"' "
        IndRegua("SF2", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
        dbSelectArea("SF2")
        #IFNDEF TOP
            dbSetIndex(cIndexName + OrdBagExt())
        #ENDIF
        dbGoTop()

        @ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Notas"
        @ 001,001 TO 170,350 BROWSE "SF2" MARK "F2_X_ETIOK"
        @ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
        @ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))
        ACTIVATE DIALOG oDlg CENTERED

        dbGoTop()
        WHILE !EOF()
            IF MARKED("F2_X_ETIOK")
                AADD(aMarked,.T.)
            ELSE
                AADD(aMarked,.F.)
            ENDIF
            dbSkip()
        ENDDO
        dbGoTop()
        IF Exec
            PROCESSA({|lEnd|ImpGrafico(aMarked)})
        ENDIF
        RETINDEX("SF2")
        fErase(cIndexName+OrdBagExt())
    ENDIF
RETURN Nil



RETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpGraficoºAutor  ³Microsiga           º Data ³  06/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao da Etiqueta em Modo Grafico.					  º±±
±±º          ³														      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 - Especifico - GPS                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpGrafico(ADADOSETQ)
    Local oPrint
    Local nLinEtq
    Local nColEtq
    Local nX
    LOCAL ADEST := {}
    LOCAL ARQLOGO := ""
    LOCAL CQUERYT := ""
    LOCAL NCONTAREG := 1
    LOCAL CLOGOSD := ""
    LOCAL ACABEC := {}
    LOCAL ADET   := {}
    LOCAL NREC := 0
    LOCAL Col := 100
    LOCAL LI  := 0
    LOCAL _NVOLUME := 0




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a Fonte/Tipo e Tamanho utilizado na Etiqueta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    DEFINE FONT oFntNome  NAME "Trebuchet MS" SIZE 0,9 BOLD  OF oPrint
    DEFINE FONT oFntEnder NAME "Trebuchet MS" SIZE 0,8       OF oPrint

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o objeto e Configura o Formato³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oPrint := TMSPrinter():New("ETIQUETA")
    oPrint:Setup()
    oPrint:SetPortrait()
    oPrint:SetPaperSize(9)			// Seta para papel A4
    oPrint:StartPage()				// Inicia uma nova pagina
    dbGoTop()
    WHILE !EOF()
        nRec := nRec + 1
        dbSkip()
    ENDDO
    dbGoTop()
    ProcRegua(nRec)

//INICIA NOVA PAGINA
    oPrint:StartPage()
    Li := 050
    Col := 100

    _cEmpAnt := SM0->M0_CODIGO
    _cFilAnt := SM0->M0_CODFIL


    WHILE !SF2->(EOF())


        CQUERYT := " SELECT A1_NOME, A1_END, A1_COMPLEM, A1_BAIRRO, A1_CEP, A1_EST, A1_MUN "
        CQUERYT += " FROM "+RETSQLNAME("SA1")+" "
        CQUERYT += " WHERE A1_FILIAL = '"+XFILIAL("SA1")+"' "
        CQUERYT += " AND A1_COD = '"+SF2->F2_CLIENTE+"' "
        CQUERYT += " AND A1_LOJA = '"+SF2->F2_LOJA+"' "
        CQUERYT += " AND D_E_L_E_T_ <> '*' "

	/*
        IF SF2->F2_VOLUME1 == 0
		DBSELECTAREA("SF2")
		SF2->(dbskip())
		Loop
        ENDIF*/

	dbSelectArea("SD2")
	dbSetOrder(3)
        If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.f.)
            If SD2->D2_LOCAL < MV_PAR15 .OR. SD2->D2_LOCAL > MV_PAR16
			dbSelectArea("SF2")
			dbSkip()
			Loop
            EndIf
        EndIf
	
	
        IF SELECT("TRBA")<>0
		DBSELECTAREA("TRBA")
		TRBA->(DBCLOSEAREA())
        ENDIF
	
	TCQUERY CQUERYT NEW ALIAS "TRBA"
	
	DBSELECTAREA("TRBA")
	TRBA->(DBGOTOP())
	
	DBSELECTAREA("SA4")
	SA4->(DBSETORDER(1))
	SA4->(DBSEEK(XFILIAL("SA4")+SF2->F2_TRANSP))
	
	_cEmpAnt := SM0->M0_CODIGO
	_cFilAnt := SM0->M0_CODFIL

	_cEmpAgo := "01"
	_cFilAgo := "01"+SUBS(SF2->F2_SERIE,2,2)
	
	//MONTA CABEÇALHO DE ETIQUETA
	dbSelectArea("SM0")
	dbseek(_cEmpAgo+_cFilAgo,.f.)
		
//	AADD(ADET,{"NOTA:"+ALLTRIM(SF2->F2_DOC)+"-"+ALLTRIM(SF2->F2_SERIE),;
//	SF2->F2_VOLUME1,;
//	"ESPECIE:"+SF2->F2_ESPECI1 ,;
//	"TRANSPORTADORA:"+ALLTRIM(SA4->A4_NOME)})

	AADD(ADET,{"NOTA:"+ALLTRIM(SF2->F2_DOC)+"-"+ALLTRIM(SF2->F2_SERIE),;
	MV_PAR17,;
	"ESPECIE: CAIXA(S)",;
	"TRANSPORTADORA:"+ALLTRIM(SA4->A4_NOME)})
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Modelo: PIMACO ...                 ³
	//³Papel  A4 com total de 8  Etiquetas³
	//³4 Etiquetas por coluna             ³
	//³2 Colunas por folha                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia uma Nova Pagina³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
        IF LI > 3000
		oPrint:ENDPAGE()
		oPrint:StartPage()
		Li := 050  
		Col:= 100
        ENDIF
	//
	
	//IF SF2->F2_VOLUME1 <> 0
		_NVOLUME := MV_PAR17
	//ELSE
	//	_NVOLUME := 1
	//ENDIF

        For _I :=1 To MV_PAR17
	
		//----> PRIMEIRA ETIQUETA
		LI := LI + 100
		// DADOS DO DESTINATARIO
		oPrint:Say(Li+000,col,"DESTINATARIO: ",oFntNome)
		oPrint:Say(Li+045,Col,AllTrim(TRBA->A1_NOME),oFntNome)
		oPrint:Say(Li+090,Col,AllTrim(TRBA->A1_END)+" "+AllTrim(TRBA->A1_COMPLEM),oFntEnder)
		oPrint:Say(Li+135,Col,AllTrim(TRBA->A1_BAIRRO)+" - "+AllTrim(TRBA->A1_MUN)+" - "+AllTrim(TRBA->A1_EST),oFntEnder)
		oPrint:Say(Li+170,Col,"CEP "+AllTrim(Substr(TRBA->A1_CEP,1,5)+"-"+Substr(TRBA->A1_CEP,6,3)),oFntEnder)			
		oPrint:Line(Li+210,COL,Li+210,COL+700)

		
            If !Subs(SF2->F2_SERIE,1,1)$"F"
			// DADOS DO REMETENTE
			oPrint:Say(Li+235,Col,"REMETENTE: ",oFntNome)  //NOME DA REMETENTE
			//oPrint:Say(Li+270,Col,AllTrim(SM0->M0_NOMECOM),oFntNome) 
			oPrint:Say(Li+305,Col,AllTrim(SM0->M0_ENDCOB),oFntEnder)  //ENDEREÇO
			oPrint:Say(Li+340,Col,AllTrim(SM0->M0_BAIRCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+"-"+AllTrim(SM0->M0_ESTCOB),oFntEnder)  //ENDEREÇO
			oPrint:Say(Li+375,Col,"CEP "+AllTrim(SUBS(SM0->M0_CEPCOB,1,5)+"-"+SUBS(SM0->M0_CEPCOB,6,3)),oFntEnder)  //ENDEREÇO
			oPrint:Line(Li+415,COL,Li+415,COL+700)
            Else
			// DADOS DO REMETENTE
			oPrint:Say(Li+235,Col,"REMETENTE: ",oFntNome)  //NOME DA REMETENTE
			oPrint:Say(Li+270,Col,AllTrim(SM0->M0_NOMECOM),oFntNome) 
			oPrint:Say(Li+305,Col,AllTrim(SM0->M0_ENDCOB),oFntEnder)  //ENDEREÇO
			oPrint:Say(Li+340,Col,AllTrim(SM0->M0_BAIRCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+"-"+AllTrim(SM0->M0_ESTCOB),oFntEnder)  //ENDEREÇO
			oPrint:Say(Li+375,Col,"CEP "+AllTrim(SUBS(SM0->M0_CEPCOB,1,5)+"-"+SUBS(SM0->M0_CEPCOB,6,3)),oFntEnder)  //ENDEREÇO
			oPrint:Line(Li+415,COL,Li+415,COL+700)
            EndIf
		
		// DADOS DO VOLUME
 		oPrint:Say(Li+440,Col,"NOTA:"+ALLTRIM(SF2->F2_DOC)+"-"+ALLTRIM(SF2->F2_SERIE),oFntNome)
		oPrint:Say(Li+475,Col,"VOLUME:"+TRANSFORM(_I,"@R 999")+"/"+TRANSFORM(_NVOLUME,"@R 999"),oFntEnder)
		oPrint:Say(Li+510,Col,"ESPECIE:"+SF2->F2_ESPECI1,oFntEnder)
		oPrint:Say(Li+545,Col,"TRANSPORTADORA:"+ALLTRIM(SA4->A4_NOME),oFntEnder)
		// VOLUME            
		//----> PRIMEIRA ETIQUETA
 			
		Col += 1300
		
		
		//----> SEGUNDA ETIQUETA
		// DADOS DO DESTINATARIO
		oPrint:Say(Li+235,col,"DESTINATARIO: ",oFntNome)
		oPrint:Say(Li+270,Col,AllTrim(TRBA->A1_NOME),oFntNome)
		oPrint:Say(Li+305,Col,AllTrim(TRBA->A1_END)+" "+AllTrim(TRBA->A1_COMPLEM),oFntEnder)
		oPrint:Say(Li+340,Col,AllTrim(TRBA->A1_BAIRRO)+" - "+AllTrim(TRBA->A1_MUN)+" - "+AllTrim(TRBA->A1_EST),oFntEnder)
		oPrint:Say(Li+375,Col,"CEP "+AllTrim(Substr(TRBA->A1_CEP,1,5)+"-"+Substr(TRBA->A1_CEP,6,3)),oFntEnder)			
		//oPrint:Line(Li+210,COL,Li+210,COL+700)
		
		// DADOS DO REMETENTE
		//oPrint:Say(Li+235,Col,"REMETENTE: ",oFntNome)  //NOME DA REMETENTE
		//oPrint:Say(Li+270,Col,AllTrim(SM0->M0_NOMECOM),oFntNome) 
		//oPrint:Say(Li+305,Col,AllTrim(SM0->M0_ENDCOB),oFntEnder)  //ENDEREÇO
		//oPrint:Say(Li+340,Col,AllTrim(SM0->M0_BAIRCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+"-"+AllTrim(SM0->M0_ESTCOB),oFntEnder)  //ENDEREÇO
		//oPrint:Say(Li+375,Col,AllTrim(SUBS(SM0->M0_CEPCOB,1,5)+"-"+SUBS(SM0->M0_CEPCOB,6,3)),oFntEnder)  //ENDEREÇO
		//oPrint:Line(Li+415,COL,Li+415,COL+700)
		
		// DADOS DO VOLUME
 		//oPrint:Say(Li+440,Col,"NOTA:"+ALLTRIM(SF2->F2_DOC)+"-"+ALLTRIM(SF2->F2_SERIE),oFntNome)
		//oPrint:Say(Li+475,Col,"VOLUME:"+TRANSFORM(_I,"@R 999")+"/"+TRANSFORM(_NVOLUME,"@R 999"),oFntNome)
		//oPrint:Say(Li+510,Col,"ESPECIE:"+SF2->F2_ESPECI1,oFntNome)
		//oPrint:Say(Li+545,Col,"TRANSPORTADORA:"+ALLTRIM(SA4->A4_NOME),oFntNome)
		// VOLUME            
		//----> SEGUNDA ETIQUETA


		Li 	+= 700 
		Col := 100
			
        Next
	// 

	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Sai do Looping quando esta no ultimo registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//If _I > Len(aDadosEtq)
	//	_I++
	//	Exit
	//EndIf
  SF2->(dbskip())
    END

dbSelectArea("SM0")
dbseek(_cEmpAnt+_cFilAnt,.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finaliza a Pagina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPrint:EndPage()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Visualiza o Relatorio na Tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Preview()
//oPrint:Print()     
MS_FLUSH()
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1   ³ Autor ³ Anderson Ciriaco   ³ Data ³ 22/08/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajustar as perguntas no SX1.					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AjustaSX1		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RGPR01, Localizacoes...                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1()
LOCAL aRegs 	:= {}
LOCAL cPerg 	:= PADR("ETIQIMP",10)
LOCAL aAreaOld 	:= GetArea()
Local nX        := 0

AADD(aRegs,{"Da Serie          ?","Da Serie          ?","Da Serie          ?","mv_ch1","C", 3,0,0,"G",""  ,"mv_par01",""		     ,""		   ,""			  ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,"",""})
AADD(aRegs,{"Até a Serie       ?","Até a Serie       ?","Até a Serie       ?","mv_ch2","C", 3,0,0,"G",""  ,"mv_par02",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,"",""})
AADD(aRegs,{"Da Nota           ?","Da Nota           ?","Da Nota           ?","mv_ch3","C", 9,0,0,"G",""  ,"mv_par03",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""  	   ,""	   ,""	  ,"",""})
AADD(aRegs,{"Até a Nota        ?","Até a Nota        ?","Até a Nota        ?","mv_ch4","C", 9,0,0,"G",""  ,"mv_par04",""		     ,""		   ,""            ,"" ,"",""				  ,""			    ,""			   ,"","",""	   ,""	   ,""	  ,"",""})
AADD(aRegs,{"Do Cliente        ?","Do Cliente        ?","Do Cliente        ?","mv_ch5","C", 6,0,0,"G",""  ,"mv_par05",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,"SA1",""})
AADD(aRegs,{"Até o Cliente     ?","Até o Cliente     ?","Até o Cliente     ?","mv_ch6","C", 6,0,0,"G",""  ,"mv_par06",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,"SA1",""})
AADD(aRegs,{"Da Loja           ?","Da Loja           ?","Da Loja           ?","mv_ch7","C", 2,0,0,"G",""  ,"mv_par07",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,""   ,""})
AADD(aRegs,{"Até a loja        ?","Até a loja        ?","Até a loja        ?","mv_ch8","C", 2,0,0,"G",""  ,"mv_par08",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,""   ,""})
AADD(aRegs,{"De Data           ?","Data De           ?","From Date         ?","mv_ch9","D", 8,0,0,"G",""  ,"mv_par09",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,""   ,""})
AADD(aRegs,{"A Data            ?","Data Ate          ?","To Date           ?","mv_cha","D", 8,0,0,"G",""  ,"mv_par10",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,""   ,""})
AADD(aRegs,{"Da Transportadora ?","Da Transportadora ?","Da Transportadora ?","mv_chb","C", 6,0,0,"G",""  ,"mv_par11",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,"SA4",""})
AADD(aRegs,{"Até a Transportadora ?","Até a Transportadora ?","Até a Transportadora ?","mv_chc","C", 6,0,0,"G",""  ,"mv_par12",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,"SA4",""})
AADD(aRegs,{"Da Empresa ?","Da Empresa ?","Da Empresa ?"                     ,"mv_chb","C", 4,0,0,"G",""  ,"mv_par13",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,"SM0",""})
AADD(aRegs,{"Até a Empresa ?","Até a Empresa ?","Até a Empresa ?"            ,"mv_chc","C", 4,0,0,"G",""  ,"mv_par14",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,"SM0",""})

dbSelectArea("SX1")
dbSetOrder(1)
    For nX:=1 to Len(aRegs)
        If !(dbSeek(cPerg+StrZero(nx,2)))
		RecLock("SX1",.T.)
		Replace X1_GRUPO    with cPerg
		Replace X1_ORDEM   	with StrZero(nx,2)
		Replace x1_pergunte	with aRegs[nx][01]
		Replace x1_perspa   with aRegs[nx][02]
		Replace x1_pereng   with aRegs[nx][03]
		Replace x1_variavl	with aRegs[nx][04]
		Replace x1_tipo		with aRegs[nx][05]
		Replace x1_tamanho	with aRegs[nx][06]
		Replace x1_decimal	with aRegs[nx][07]
		Replace x1_presel   with aRegs[nx][08]
		Replace x1_gsc      with aRegs[nx][09]
		Replace x1_valid    with aRegs[nx][10]
		Replace x1_var01    with aRegs[nx][11]
		Replace x1_def01    with aRegs[nx][12]
		Replace x1_defspa1	with aRegs[nx][13]
		Replace x1_defeng1	with aRegs[nx][14]
		Replace x1_cnt01    with aRegs[nx][15]
		Replace x1_var02    with aRegs[nx][16]
		Replace x1_def02    with aRegs[nx][17]
		Replace x1_defspa2	with aRegs[nx][18]
		Replace x1_defeng2	with aRegs[nx][19]
		Replace x1_cnt02    with aRegs[nx][20]
		Replace x1_var03    with aRegs[nx][21]
		Replace x1_def03    with aRegs[nx][22]
		Replace x1_defspa3	with aRegs[nx][23]
		Replace x1_defeng3	with aRegs[nx][24]
		Replace x1_f3     	with aRegs[nx][25]
		Replace x1_grpsxg 	with aRegs[nx][26]
		MsUnlock()
        Endif
    Next

RestArea( aAreaOld )
Return
