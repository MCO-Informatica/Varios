#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#Include "Avprint.ch"
#Include "Font.ch"
#Include "Protheus.ch"
#Include "rwmake.ch"



USER FUNCTION RFATR03()


    cPerg	:= "ETIQIMP"

    
    If !pergunte(cPerg,.T.)
        Return
    Endif

    ImpGrafico()

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
Static Function ImpGrafico()
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

    CQUERYT := ""

    CQUERYT += "SELECT DISTINCT "
    CQUERYT += "F2_X_EMPFA, "
    CQUERYT += "F2_DOC, "
    CQUERYT += "F2_SERIE, "
    CQUERYT += "F2_CLIENTE, "
    CQUERYT += "F2_LOJA, "
    CQUERYT += "F2_TRANSP, "
    CQUERYT += "F2_EMISSAO, "
    CQUERYT += "F2_ESPECI1, "
    CQUERYT += "A1_NOME, "
    CQUERYT += "A1_END, "
    CQUERYT += "A1_COMPLEM, "
    CQUERYT += "A1_BAIRRO, "
    CQUERYT += "A1_CEP, "
    CQUERYT += "A1_MUN, "
    CQUERYT += "A1_EST, "
    CQUERYT += "A1_CEP, "
    CQUERYT += "D2_LOCAL, "
    CQUERYT += "A4_NOME, "
    CQUERYT += "C5_NUM, "
    CQUERYT += "C5_X_NUMSE "
    CQUERYT += "FROM "
    CQUERYT += "SF2010 SF2 "
    CQUERYT += "INNER JOIN SA1010 SA1 ON "
    CQUERYT += "A1_COD = F2_CLIENTE "
    CQUERYT += "AND A1_LOJA = F2_LOJA "
    CQUERYT += "AND SA1.D_E_L_E_T_ = '' "
    CQUERYT += "INNER JOIN SA4010 SA4 ON "
    CQUERYT += "A4_COD = F2_TRANSP "
    CQUERYT += "AND SA4.D_E_L_E_T_ = '' "
    CQUERYT += "INNER JOIN SD2010 SD2 ON "
    CQUERYT += "D2_DOC = F2_DOC "
    CQUERYT += "AND D2_SERIE = F2_SERIE "
    CQUERYT += "AND D2_CLIENTE = F2_CLIENTE "
    CQUERYT += "AND D2_LOJA = F2_LOJA "
    CQUERYT += "AND D2_LOCAL BETWEEN '"+MV_PAR15+"' AND '"+MV_PAR16+"' "
    CQUERYT += "AND D2_PEDIDO BETWEEN '"+MV_PAR17+"' AND '"+MV_PAR18+"' "
    CQUERYT += "AND SD2.D_E_L_E_T_ = '' "
    CQUERYT += "INNER JOIN SC5010 SC5 ON "
    CQUERYT += "C5_NUM = D2_PEDIDO "
    CQUERYT += "AND SC5.D_E_L_E_T_ = '' "
    CQUERYT += "WHERE SF2.D_E_L_E_T_= '' "
    CQUERYT += "AND F2_SERIE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
    CQUERYT += "AND F2_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
    CQUERYT += "AND F2_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
    CQUERYT += "AND F2_LOJA BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
    CQUERYT += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' "
    CQUERYT += "AND F2_TRANSP BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "
    //CQUERYT += "AND F2_TRANSP NOT IN ('001001','000004','001000') " 
    CQUERYT += "AND F2_X_EMPFA BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"' "

    If MV_PAR20 == 1
        CQUERYT += " AND F2_X_ETIOK = 'OK' "
    Else
        CQUERYT += " AND F2_X_ETIOK = '' "
    EndIf

    IF SELECT("TRBA")<>0
        DBSELECTAREA("TRBA")
        TRBA->(DBCLOSEAREA())
    ENDIF

    TCQUERY CQUERYT NEW ALIAS "TRBA"

    dbGoTop()

    ProcRegua(nRec)

//INICIA NOVA PAGINA
    oPrint:StartPage()
    Li := 050
    Col := 100

    _cEmpAnt := SM0->M0_CODIGO
    _cFilAnt := SM0->M0_CODFIL


    WHILE !TRBA->(EOF())

        //----> ARMAZEM 01A1 NÃO IMPRIME ETIQUETAS ANTIGAS QUANDO FOR CORREIO (SEDEX/PAC)
        If TRBA->D2_LOCAL$"01A1" .and. TRBA->F2_TRANSP$"001001,000004,001000"
            dbSelectArea("TRBA")
            TRBA->(dbskip())
            Loop
        EndIf
        
        
        DBSELECTAREA("SA4")
        SA4->(DBSETORDER(1))
        SA4->(DBSEEK(XFILIAL("SA4")+TRBA->F2_TRANSP))

        _cEmpAnt := SM0->M0_CODIGO
        _cFilAnt := SM0->M0_CODFIL

        _cEmpAgo := "01"
        _cFilAgo := "01"+SUBS(TRBA->F2_SERIE,2,2)

        //MONTA CABEÇALHO DE ETIQUETA
        dbSelectArea("SM0")
        dbseek(_cEmpAgo+_cFilAgo,.f.)

        AADD(ADET,{"NOTA:"+ALLTRIM(TRBA->F2_DOC)+"-"+ALLTRIM(TRBA->F2_SERIE),;
            MV_PAR19,;
            "ESPECIE: CAIXA(S)",;
            "TRANSPORTADORA:"+ALLTRIM(TRBA->A4_NOME)})


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
        _NVOLUME := MV_PAR19
        //ELSE
        //	_NVOLUME := 1
        //ENDIF

        For _I :=1 To MV_PAR19

            //----> PRIMEIRA ETIQUETA
            LI := LI + 050
            // DADOS DO DESTINATARIO
            oPrint:Say(Li+000,col,"DESTINATARIO: ",oFntNome)
            oPrint:Say(Li+045,Col,AllTrim(TRBA->A1_NOME),oFntNome)
            oPrint:Say(Li+090,Col,AllTrim(TRBA->A1_END)+" "+AllTrim(TRBA->A1_COMPLEM),oFntEnder)
            oPrint:Say(Li+135,Col,AllTrim(TRBA->A1_BAIRRO)+" - "+AllTrim(TRBA->A1_MUN)+" - "+AllTrim(TRBA->A1_EST),oFntEnder)
            oPrint:Say(Li+170,Col,"CEP "+AllTrim(Substr(TRBA->A1_CEP,1,5)+"-"+Substr(TRBA->A1_CEP,6,3)),oFntEnder)
            oPrint:Line(Li+210,COL,Li+210,COL+700)


            If Subs(TRBA->F2_SERIE,1,1)$"F"
                // DADOS DO VOLUME
                oPrint:Say(Li+235,Col,"NOTA:"+ALLTRIM(TRBA->F2_DOC)+"-"+ALLTRIM(TRBA->F2_SERIE),oFntNome)
                oPrint:Say(Li+270,Col,"VOLUME:"+TRANSFORM(_I,"@R 999")+"/"+TRANSFORM(_NVOLUME,"@R 999"),oFntEnder)
                oPrint:Say(Li+305,Col,"ESPECIE:"+TRBA->F2_ESPECI1,oFntEnder)
                oPrint:Say(Li+340,Col,"TRANSPORTADORA:"+ALLTRIM(TRBA->A4_NOME),oFntEnder)
                oPrint:Line(Li+375,COL,Li+375,COL+700)
                // VOLUME
                // DADOS DO REMETENTE
                //oPrint:Say(Li+410,Col,"REMETENTE: ",oFntNome)  //NOME DA REMETENTE
                //oPrint:Say(Li+445,Col,AllTrim(SM0->M0_NOMECOM),oFntNome)
                //oPrint:Say(Li+480,Col,AllTrim(SM0->M0_ENDCOB),oFntEnder)  //ENDEREÇO
                //oPrint:Say(Li+515,Col,AllTrim(SM0->M0_BAIRCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+"-"+AllTrim(SM0->M0_ESTCOB),oFntEnder)  //ENDEREÇO
                //oPrint:Say(Li+540,Col,"CEP "+AllTrim(SUBS(SM0->M0_CEPCOB,1,5)+"-"+SUBS(SM0->M0_CEPCOB,6,3)),oFntEnder)  //ENDEREÇO
            Else
                // DADOS DO VOLUME
                oPrint:Say(Li+235,Col,"NOTA:"+ALLTRIM(TRBA->F2_DOC)+"-"+ALLTRIM(TRBA->F2_SERIE),oFntNome)
                oPrint:Say(Li+270,Col,"VOLUME:"+TRANSFORM(_I,"@R 999")+"/"+TRANSFORM(_NVOLUME,"@R 999"),oFntEnder)
                oPrint:Say(Li+305,Col,"ESPECIE:"+TRBA->F2_ESPECI1,oFntEnder)
                oPrint:Say(Li+340,Col,"TRANSPORTADORA:"+ALLTRIM(TRBA->A4_NOME),oFntEnder)
                oPrint:Line(Li+375,COL,Li+375,COL+700)
                // VOLUME
                // DADOS DO REMETENTE
                oPrint:Say(Li+410,Col,"REMETENTE: ",oFntNome)  //NOME DA REMETENTE
                oPrint:Say(Li+445,Col,AllTrim(SM0->M0_NOMECOM),oFntNome)
                oPrint:Say(Li+480,Col,AllTrim(SM0->M0_ENDCOB),oFntEnder)  //ENDEREÇO
                oPrint:Say(Li+515,Col,AllTrim(SM0->M0_BAIRCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+"-"+AllTrim(SM0->M0_ESTCOB),oFntEnder)  //ENDEREÇO
                oPrint:Say(Li+540,Col,"CEP "+AllTrim(SUBS(SM0->M0_CEPCOB,1,5)+"-"+SUBS(SM0->M0_CEPCOB,6,3)),oFntEnder)  //ENDEREÇO
            EndIf

            //----> PRIMEIRA ETIQUETA

            Col += 1300

            //----> SEGUNDA ETIQUETA
            //LI := LI + 100
            // DADOS DO DESTINATARIO
            oPrint:Say(Li+000,col,"DESTINATARIO: ",oFntNome)
            oPrint:Say(Li+045,Col,AllTrim(TRBA->A1_NOME),oFntNome)
            oPrint:Say(Li+090,Col,AllTrim(TRBA->A1_END)+" "+AllTrim(TRBA->A1_COMPLEM),oFntEnder)
            oPrint:Say(Li+135,Col,AllTrim(TRBA->A1_BAIRRO)+" - "+AllTrim(TRBA->A1_MUN)+" - "+AllTrim(TRBA->A1_EST),oFntEnder)
            oPrint:Say(Li+170,Col,"CEP "+AllTrim(Substr(TRBA->A1_CEP,1,5)+"-"+Substr(TRBA->A1_CEP,6,3)),oFntEnder)
            oPrint:Line(Li+210,COL,Li+210,COL+700)

            //----> SEGUNDA ETIQUETA
            If Subs(TRBA->F2_SERIE,1,1)$"F"
                // DADOS DO VOLUME
                oPrint:Say(Li+235,Col,"NOTA:"+ALLTRIM(TRBA->F2_DOC)+"-"+ALLTRIM(TRBA->F2_SERIE),oFntNome)
                oPrint:Say(Li+270,Col,"VOLUME:"+TRANSFORM(_I,"@R 999")+"/"+TRANSFORM(_NVOLUME,"@R 999"),oFntEnder)
                oPrint:Say(Li+305,Col,"ESPECIE:"+TRBA->F2_ESPECI1,oFntEnder)
                oPrint:Say(Li+340,Col,"TRANSPORTADORA:"+ALLTRIM(TRBA->A4_NOME),oFntEnder)
                oPrint:Line(Li+375,COL,Li+375,COL+700)
                // VOLUME
                // DADOS DO REMETENTE
                //oPrint:Say(Li+410,Col,"REMETENTE: ",oFntNome)  //NOME DA REMETENTE
                //oPrint:Say(Li+445,Col,AllTrim(SM0->M0_NOMECOM),oFntNome)
                //oPrint:Say(Li+480,Col,AllTrim(SM0->M0_ENDCOB),oFntEnder)  //ENDEREÇO
                //oPrint:Say(Li+515,Col,AllTrim(SM0->M0_BAIRCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+"-"+AllTrim(SM0->M0_ESTCOB),oFntEnder)  //ENDEREÇO
                //oPrint:Say(Li+540,Col,"CEP "+AllTrim(SUBS(SM0->M0_CEPCOB,1,5)+"-"+SUBS(SM0->M0_CEPCOB,6,3)),oFntEnder)  //ENDEREÇO
            Else
                // DADOS DO VOLUME
                oPrint:Say(Li+235,Col,"NOTA:"+ALLTRIM(TRBA->F2_DOC)+"-"+ALLTRIM(TRBA->F2_SERIE),oFntNome)
                oPrint:Say(Li+270,Col,"VOLUME:"+TRANSFORM(_I,"@R 999")+"/"+TRANSFORM(_NVOLUME,"@R 999"),oFntEnder)
                oPrint:Say(Li+305,Col,"ESPECIE:"+TRBA->F2_ESPECI1,oFntEnder)
                oPrint:Say(Li+340,Col,"TRANSPORTADORA:"+ALLTRIM(TRBA->A4_NOME),oFntEnder)
                oPrint:Line(Li+375,COL,Li+375,COL+700)
                // VOLUME
                // DADOS DO REMETENTE
                oPrint:Say(Li+410,Col,"REMETENTE: ",oFntNome)  //NOME DA REMETENTE
                oPrint:Say(Li+445,Col,AllTrim(SM0->M0_NOMECOM),oFntNome)
                oPrint:Say(Li+480,Col,AllTrim(SM0->M0_ENDCOB),oFntEnder)  //ENDEREÇO
                oPrint:Say(Li+515,Col,AllTrim(SM0->M0_BAIRCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+"-"+AllTrim(SM0->M0_ESTCOB),oFntEnder)  //ENDEREÇO
                oPrint:Say(Li+540,Col,"CEP "+AllTrim(SUBS(SM0->M0_CEPCOB,1,5)+"-"+SUBS(SM0->M0_CEPCOB,6,3)),oFntEnder)  //ENDEREÇO
            EndIf
            //----> SEGUNDA ETIQUETA

            Li 	+= 600
            Col := 100

        Next

        dbSelectArea("SF2")
        dbSetOrder(1)
        If dbSeek(xFilial("SF2")+TRBA->F2_DOC+TRBA->F2_SERIE+TRBA->F2_CLIENTE+TRBA->F2_LOJA,.F.)
            RecLock("SF2",.f.)
            SF2->F2_X_ETIOK = 'OK'
            MsUnLock()
        EndIf

        dbSelectArea("TRBA")
        TRBA->(dbskip())
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
