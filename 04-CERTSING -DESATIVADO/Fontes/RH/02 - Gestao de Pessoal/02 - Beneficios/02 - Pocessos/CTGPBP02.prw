#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE CRLF chr(13)+chr(10)

User Function CTGPBP02()
/*
+----------------------------------------------------------------------------------------+
| <Descricao>.: Integra valores de VR e VA com o movimento de Folha de Pagamento.        |
| <Autor>.....: Alexandre Alves da Silva - OPVS.                                         |
| <Data>......: 01/07/2016.                                                              |
| <Parametros>: Não Há.                                                                  |
| <Retorno>...: NIL.                                                                     |
| <Processos>.: Gestão de Pessoal - Beneficos                                            |
| <Tipo>......: (Menu, Trigger, Validacao, Ponto de Entrada, Genericas, Especificas): E  |
| <Observacao>:                                                                          |
+----------------------------------------------------------------------------------------+
*/
Local bProcesso := {|oSelf| fProcessa( oSelf )}

Private cCadastro  := "Integração do VR e VA com o Movimento de Folha"
Private cPerg      := "GPINTV"
Private cDescricao := "Esta rotina tem o objetivo de integrar os valores de VR e VA, ao movimento de folha dos colaboradores."

AjustSx1()
Pergunte(cPerg,.F.)


tNewProcess():New( "CTGPBP02" , cCadastro , bProcesso , cDescricao , cPerg,,,,,.T.,.F. ) 	


Return ()


Static Function fProcessa( oSelf )
/*
+----------------------------------------------------------------------------------------+
| <Descricao>.: Funcao de processamento principal da rotina.                             |
| <Autor>.....: Alexandre Alves da Silva - OPVS.                                         |
| <Data>......: 01/07/2016.                                                              |
| <Parametros>: Não Há.                                                                  |
| <Retorno>...: NIL.                                                                     |
| <Processos>.: Gestão de Pessoal - Beneficos                                            |
| <Tipo>......: (Menu, Trigger, Validacao, Ponto de Entrada, Genericas, Especificas): E  |
| <Observacao>:                                                                          |
+----------------------------------------------------------------------------------------+

+---------------------------------------------------------------+
| Parametros da Rotina.                                         |
+---------------------------------------------------------------+
|mv_par01 ->  De  Filial?                                       |
|mv_par02 ->  Ate  Filial?                                      |
|mv_par03 ->  De Matricula?                                     |
|mv_par04 ->  Ate Matricula?                                    |
|mv_par05 ->  De C. de Custo?                                   |
|mv_par06 ->  Ate C. de Custo?                                  |
|mv_par07 ->  Integração? (1=Refeição / 2=Alimentação / 3=Ambos)|
|mv_par08 ->  Situações ?                                       |
|mv_par09 ->  Dt. de Referencia ?                               |
+---------------------------------------------------------------+
*/
Local cAliasBN   := ""
Local cCpoFil    := "_FILIAL"
Local cCpoMat    := "_MAT"
Local cCpoDta    := "_ANOMES"
Local cCpoCCu    := "_CC"
Local cCpoEmp    := "_EMP"
Local cCpoQtd    := "_QUANT"
Local lGrava     := .F.
Local nX         := 0
Local cVarAux    := ""
Local cQuery     := ""

Private cVrbVR     := ""
Private cVrbVA     := ""

//-> Buscando Verbas p/ VR e VA.
fVrbVRVA()

If (mv_par07 = 1 .And. Empty(cVrbVR)) .Or.;
   (mv_par07 = 2 .And. Empty(cVrbVA)) .Or.;
   (mv_par07 = 3 .And. Empty(cVrbVR)  .And. Empty(cVrbVA) ) 
    AVISO("ATENÇÃO!","CADASTRE AS VERBAS PARA INTEGRAÇÃO DO VR E/OU VA NA TABELA U009 DA FOLHA.",{"OK"})
Else


  //-> Formata Situacao para Query.
  For nX := 1 To Len(mv_par08)
      cVarAux += If( Substr(mv_par08, nX, 1) <> "*", "'" + Substr(mv_par08, nX, 1) + "',", "") //-> Situacoes.
  Next
  mv_par08  := Substr(cVarAux, 1, Len(cVarAux) -1)


  //-> Parametriza variavel para o Alias de leitura. / (1=Refeição / 2=Alimentação / 3=Ambos)|
  cAliasBN := If( mv_par07 = 1, "SZC", If(mv_par07 = 2, "SZD", "") )

  For nX := 1 To If(mv_par07 <= 2,1,2)

    //-> Preparando os campos do Alias.
    If mv_par07 <= 2 //-> Se for VR ou VA.
       cCpoFil := Substr(cAliasBN,2,2)+"_FILIAL"
       cCpoMat := Substr(cAliasBN,2,2)+"_MAT"
       cCpoDta := Substr(cAliasBN,2,2)+"_ANOMES"
       cCpoCCu := Substr(cAliasBN,2,2)+"_CC"
       cCpoEmp := Substr(cAliasBN,2,2)+"_EMP"
       cCpoQtd := Substr(cAliasBN,2,2)+"_QUANT"
    ElseIf nX = 1                                       //-> VR (SZC)
       cAliasBN:= "SZC"
       cCpoFil := "ZC_FILIAL"
       cCpoMat := "ZC_MAT"
       cCpoDta := "ZC_ANOMES"
       cCpoCCu := "ZC_CC"
       cCpoEmp := "ZC_EMP"
       cCpoQtd := "ZC_QUANT"
    ElseIf nX = 2                                       //-> VA (SZD)
       cAliasBN:= "SZD"
       cCpoFil := "ZD_FILIAL"
       cCpoMat := "ZD_MAT"
       cCpoDta := "ZD_ANOMES"
       cCpoCCu := "ZD_CC"
       cCpoEmp := "ZD_EMP"  
       cCpoQtd := "ZD_QUANT"         
    EndIf

    If (cAliasBN = "SZC" .And. !Empty(cVrbVR)) .Or. (cAliasBN = "SZD" .And. !Empty(cVrbVA))
    
       //-> Executando Query.
       cQuery := "SELECT "+cCpoFil+" AS FIL, "+CRLF
       cQuery += "       "+cCpoMat+" AS MAT, "+CRLF
       cQuery += "       "+cCpoDta+" AS DTA, "+CRLF
       cQuery += "       "+cCpoCCu+" AS CCU, "+CRLF
       cQuery += "       "+cCpoEmp+" AS VLR, "+CRLF
       cQuery += "       RA_NOME     AS NOM  "+CRLF
       cQuery += "FROM "+RetSqlName(cAliasBN)+" BEN "+CRLF
       cQuery += "INNER JOIN "+RetSqlName("SRA")+" SRA ON RA_FILIAL = "+cCpoFil+" AND RA_MAT = "+cCpoMat+" "+CRLF
       cQuery += "WHERE "+cCpoFil+" BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "+CRLF
       cQuery += "      "+cCpoMat+" BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "+CRLF
       cQuery += "      "+cCpoCCu+" BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "+CRLF
       cQuery += "      "+cCpoQtd+" > 0                                       AND "+CRLF       
       cQuery += "      BEN.D_E_L_E_T_ <> '*' AND SRA.D_E_L_E_T_ <> '*'       AND "+CRLF
       cQuery += "      RA_SITFOLH IN("+mv_par08+")  AND "+cCpoDta+" = "+AnoMes(mv_par09)+" "+CRLF
       cQuery += "ORDER BY "+cCpoFil+", "+cCpoMat+" "+CRLF
    
       cQuery := ChangeQuery(cQuery)       		
    
       If Select("BENEF") <> 0
          BENEF->(DBCloseArea())
       EndIf

       TCQUERY cQuery NEW ALIAS ('BENEF')

       BENEF->(dbGotop())                

       If BENEF->(Eof())
          If cAliasBN = "SZC" //VR
             AVISO("ATENÇAO!","NÃO FORAM ENCONTRADOS REGISTROS PARA O PROCESSAMENTO DA INTEGRAÇÃO DO VALE REFEIÇÃO. VERIFIQUE OS PARAMETROS.",{"OK"})
          Else
             AVISO("ATENÇAO!","NÃO FORAM ENCONTRADOS REGISTROS PARA O PROCESSAMENTO DA INTEGRAÇÃO DO VALE ALIMENTAÇÃO. VERIFIQUE OS PARAMETROS.",{"OK"})
          EndIf
       Else
          fProcInt(If(cAliasBN="SZC","VR","VA"),oSelf)
       EndIf
    EndIf
  Next nX

  BENEF->(DBCloseArea())

EndIf
	

Return


Static Function fProcInt(cTipBn, oSelf)
/*
+----------------------------------------------------------------------------------------+
| <Descricao>.: Realiza a Integração dos Beneficios no Movimento de  Folha.              |
| <Autor>.....: Alexandre Alves da Silva - OPVS.                                         |
| <Data>......: 04/07/2016.                                                              |
| <Parametros>: Não Há.                                                                  |
| <Retorno>...: NIL.                                                                     |
| <Processos>.: Gestão de Pessoal - Beneficos                                            |
| <Tipo>......: (Menu, Trigger, Validacao, Ponto de Entrada, Genericas, Especificas): E  |
| <Observacao>:                                                                          |
+----------------------------------------------------------------------------------------+
*/
Local lGrvSRC := .T.

BENEF->(dbGotop())

oSelf:SetRegua1( BENEF->(RecCount()) )

While BENEF->( !Eof() ) 

      oSelf:IncRegua1( BENEF->(FIL + " - " + MAT + " - " + NOM) )
      If oSelf:lEnd 
         Break
      EndIf

      If SRC->( DBSeek( BENEF->(FIL + MAT + If(cTipBn = "VR",cVrbVR,cVrbVA) )  ) ) .And.;//RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ
         SRC->(RC_FILIAL+RC_MAT+RC_PD) = BENEF->(FIL + MAT + If(cTipBn = "VR",cVrbVR,cVrbVA) )
         lGrvSRC := .F.               
      Else
         lGrvSRC := .T.               
      EndIf
         
      SRC->( RecLock("SRC", lGrvSRC ) )
      
      SRC->RC_FILIAL := BENEF->FIL
      SRC->RC_MAT    := BENEF->MAT
      SRC->RC_DATA   := CToD("  /  /    ") 
      SRC->RC_PD     :=  If(cTipBn = "VR",cVrbVR,cVrbVA)
      SRC->RC_CC     := BENEF->CCU
      SRC->RC_SEMANA := ""
      SRC->RC_TIPO1  := "V"
      SRC->RC_HORAS  := 0.00
      SRC->RC_VALOR  := BENEF->VLR
      SRC->RC_PARCELA:= 0
      SRC->RC_TIPO2  := "G"
      SRC->RC_SEQ    := ""

      SRC->( MsUnlock() )                                                                                         
    
      BENEF->( DBSkip() )    

EndDo


Return


Static Function fVrbVRVA()
/*
+----------------------------------------------------------------------------------------+
| <Descricao>.: Busca codigos para verbas na tabela U009 da Folha.                       |
| <Autor>.....: Alexandre Alves da Silva - OPVS.                                         |
| <Data>......: 04/07/2016.                                                              |
| <Parametros>: Não Há.                                                                  |
| <Retorno>...: NIL.                                                                     |
| <Processos>.: Gestão de Pessoal - Beneficos                                            |
| <Tipo>......: (Menu, Trigger, Validacao, Ponto de Entrada, Genericas, Especificas): E  |
| <Observacao>:                                                                          |
+----------------------------------------------------------------------------------------+
*/
If RCC->(DbSeek(xFilial("RCC")+"U009"))     
   While !Eof() .And. RCC->RCC_CODIGO == "U009"
         If Substr(RCC->RCC_CONTEU,1,1) = "1"
            cVrbVR := Substr(RCC->RCC_CONTEU,2,3)
         Else
            cVrbVA := Substr(RCC->RCC_CONTEU,2,3)
         EndIf
         RCC->(dbSkip())
   EndDo
EndIf

Return

Static Function AjustSx1()
/*
+----------------------------------------------------------------------------------------+
| <Descricao>.: Cria Grupo de Perguntas da Rotina.                                       |
| <Autor>.....: Alexandre Alves da Silva - OPVS.                                         |
| <Data>......: 06/04/2015.                                                              |
| <Parametros>: Não Há.                                                                  |
| <Retorno>...: NIL.                                                                     |
| <Processos>.: Gestão de Pessoal - Beneficos                                            |
| <Tipo>......: (Menu, Trigger, Validacao, Ponto de Entrada, Genericas, Especificas): E  |
| <Observacao>:                                                                          |
+----------------------------------------------------------------------------------------+
*/
aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

//PutSx1(cGrupo  ,cOrdem ,cPergunt      ,cPerSpa       ,cPerEng       ,cVar     ,cTipo ,nTamanho ,nDecimal ,nPresel ,cGSC ,cValid ,cF3   ,cGrpSxg ,cPyme ,cVar01     ,cDef01 ,cDefSpa1 ,cDefEng1 ,cCnt01 ,cDef02 ,cDefSpa2 ,cDefEng2 ,cDef03 ,cDefSpa3 ,cDefEng3 ,cDef04 ,cDefSpa4 ,cDefEng4 ,cDef05 ,cDefSpa5 ,cDefEng5           ,aHelpPor                ,aHelpEng           ,aHelpSpa           ,cHelp )                                               
  PutSX1(cPerg,  "01"   ,"De  Filial?" ,"De  Filial?" ,"De  Filial?" ,"mv_ch1" ,"C"   ,02       ,0        ,0       ,"G"  ,""     ,"XM0" ,""      ,""    ,"mv_par01" ,""     ,""       ,""       ,""     ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,"")

Aadd( aHelpPor, "Filial inicial para filtrar os registros" ) 
Aadd( aHelpPor, " a serem impressos no relatorio." ) 
PutSX1Help("P."+cPerg+"01.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

//PutSx1(cGrupo  ,cOrdem ,cPergunt      ,cPerSpa        ,cPerEng        ,cVar     ,cTipo ,nTamanho ,nDecimal ,nPresel ,cGSC ,cValid ,cF3   ,cGrpSxg ,cPyme ,cVar01     ,cDef01 ,cDefSpa1 ,cDefEng1 ,cCnt01 ,cDef02 ,cDefSpa2 ,cDefEng2 ,cDef03 ,cDefSpa3 ,cDefEng3 ,cDef04 ,cDefSpa4 ,cDefEng4 ,cDef05 ,cDefSpa5 ,cDefEng5           ,aHelpPor                ,aHelpEng           ,aHelpSpa           ,cHelp )                                               
  PutSX1(cPerg,  "02"   ,"Ate  Filial?" ,"Ate  Filial?" ,"Ate  Filial?" ,"mv_ch2" ,"C"   ,02       ,0        ,0       ,"G"  ,""     ,"XM0" ,""      ,""    ,"mv_par02" ,""     ,""       ,""       ,""     ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,"")

Aadd( aHelpPor, "Filial final para filtrar os registros" ) 
Aadd( aHelpPor, " a serem impressos no relatorio." ) 
PutSX1Help("P."+cPerg+"02.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

//PutSx1(cGrupo  ,cOrdem ,cPergunt       ,cPerSpa         ,cPerEng         ,cVar     ,cTipo ,nTamanho ,nDecimal ,nPresel ,cGSC ,cValid ,cF3   ,cGrpSxg ,cPyme ,cVar01     ,cDef01 ,cDefSpa1 ,cDefEng1 ,cCnt01 ,cDef02 ,cDefSpa2 ,cDefEng2 ,cDef03 ,cDefSpa3 ,cDefEng3 ,cDef04 ,cDefSpa4 ,cDefEng4 ,cDef05 ,cDefSpa5 ,cDefEng5           ,aHelpPor                ,aHelpEng           ,aHelpSpa           ,cHelp )                                               
  PutSX1(cPerg,  "03"   ,"De Matricula?" ,"De Matricula?" ,"De Matricula?" ,"mv_ch3" ,"C"   ,06       ,0        ,0       ,"G"  ,""     ,"SRA" ,""      ,""    ,"mv_par03" ,""     ,""       ,""       ,""     ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,"")

Aadd( aHelpPor, "Matricula inicial para filtrar os registros" ) 
Aadd( aHelpPor, " a serem impressos no relatorio." ) 
PutSX1Help("P."+cPerg+"03.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

//PutSx1(cGrupo  ,cOrdem ,cPergunt        ,cPerSpa          ,cPerEng          ,cVar     ,cTipo ,nTamanho ,nDecimal ,nPresel ,cGSC ,cValid ,cF3   ,cGrpSxg ,cPyme ,cVar01     ,cDef01 ,cDefSpa1 ,cDefEng1 ,cCnt01 ,cDef02 ,cDefSpa2 ,cDefEng2 ,cDef03 ,cDefSpa3 ,cDefEng3 ,cDef04 ,cDefSpa4 ,cDefEng4 ,cDef05 ,cDefSpa5 ,cDefEng5           ,aHelpPor                ,aHelpEng           ,aHelpSpa           ,cHelp )                                               
  PutSX1(cPerg,  "04"   ,"Ate Matricula?" ,"Ate Matricula?" ,"Ate Matricula?" ,"mv_ch4" ,"C"   ,06       ,0        ,0       ,"G"  ,""     ,"SRA" ,""      ,""    ,"mv_par04" ,""     ,""       ,""       ,""     ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,"")

Aadd( aHelpPor, "Matricula final para filtrar os registros" ) 
Aadd( aHelpPor, " a serem impressos no relatorio." ) 
PutSX1Help("P."+cPerg+"04.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

//PutSx1(cGrupo  ,cOrdem ,cPergunt          ,cPerSpa           ,cPerEng           ,cVar     ,cTipo ,nTamanho ,nDecimal ,nPresel ,cGSC ,cValid ,cF3   ,cGrpSxg ,cPyme ,cVar01     ,cDef01 ,cDefSpa1 ,cDefEng1 ,cCnt01 ,cDef02 ,cDefSpa2 ,cDefEng2 ,cDef03 ,cDefSpa3 ,cDefEng3 ,cDef04 ,cDefSpa4 ,cDefEng4 ,cDef05 ,cDefSpa5 ,cDefEng5           ,aHelpPor                ,aHelpEng           ,aHelpSpa           ,cHelp )                                               
  PutSX1(cPerg,  "05"    ,"De C. de Custo?" ,"De C. de Custo?" ,"De C. de Custo?" ,"mv_ch5" ,"C"   ,09       ,0        ,0       ,"G"  ,""     ,"CTT" ,""      ,""    ,"mv_par05" ,""     ,""       ,""       ,""     ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,"")

Aadd( aHelpPor, "C. de Custo inicial para filtrar os registros" ) 
Aadd( aHelpPor, " a serem impressos no relatorio." ) 
PutSX1Help("P."+cPerg+"05.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

//PutSx1(cGrupo  ,cOrdem ,cPergunt           ,cPerSpa            ,cPerEng            ,cVar     ,cTipo ,nTamanho ,nDecimal ,nPresel ,cGSC ,cValid ,cF3   ,cGrpSxg ,cPyme ,cVar01     ,cDef01 ,cDefSpa1 ,cDefEng1 ,cCnt01 ,cDef02 ,cDefSpa2 ,cDefEng2 ,cDef03 ,cDefSpa3 ,cDefEng3 ,cDef04 ,cDefSpa4 ,cDefEng4 ,cDef05 ,cDefSpa5 ,cDefEng5           ,aHelpPor                ,aHelpEng           ,aHelpSpa           ,cHelp )                                               
  PutSX1(cPerg,  "06"    ,"Ate C. de Custo?" ,"Ate C. de Custo?" ,"Ate C. de Custo?" ,"mv_ch6" ,"C"   ,09       ,0        ,0       ,"G"  ,""     ,"CTT" ,""      ,""    ,"mv_par06" ,""     ,""       ,""       ,""     ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,"")

Aadd( aHelpPor, "C. de Custo final para filtrar os registros" ) 
Aadd( aHelpPor, " a serem impressos no relatorio." ) 
PutSX1Help("P."+cPerg+"06.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

//PutSx1(cGrupo  ,cOrdem ,cPergunt      ,cPerSpa       ,cPerEng       ,cVar     ,cTipo ,nTamanho ,nDecimal ,nPresel ,cGSC ,cValid ,cF3   ,cGrpSxg ,cPyme ,cVar01     ,cDef01     ,cDefSpa1 ,cDefEng1 ,cCnt01 ,cDef02        ,cDefSpa2 ,cDefEng2 ,cDef03  ,cDefSpa3 ,cDefEng3 ,cDef04 ,cDefSpa4 ,cDefEng4 ,cDef05 ,cDefSpa5 ,cDefEng5           ,aHelpPor                ,aHelpEng           ,aHelpSpa           ,cHelp )                                               
  PutSX1(cPerg,  "07"    ,"Integração?" ,"Integração?" ,"Integração?" ,"mv_ch7" ,"N"   ,01       ,0        ,0       ,"C"  ,""     ,""    ,""      ,""    ,"mv_par07" ,"Refeição" ,""       ,""       ,""     ,"Alimentação" ,""       ,""       ,"Ambos" ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,"")

Aadd( aHelpPor, "Selecione o tipo de beneficio a integrar." ) 
PutSX1Help("P."+cPerg+"07.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

//PutSx1(cGrupo  ,cOrdem ,cPergunt      ,cPerSpa       ,cPerEng       ,cVar     ,cTipo ,nTamanho ,nDecimal ,nPresel ,cGSC ,cValid      ,cF3   ,cGrpSxg ,cPyme ,cVar01     ,cDef01 ,cDefSpa1 ,cDefEng1 ,cCnt01 ,cDef02 ,cDefSpa2 ,cDefEng2 ,cDef03 ,cDefSpa3 ,cDefEng3 ,cDef04 ,cDefSpa4 ,cDefEng4 ,cDef05 ,cDefSpa5 ,cDefEng5           ,aHelpPor                ,aHelpEng           ,aHelpSpa           ,cHelp )                                               
 PutSX1(cPerg   ,"08"    ,"Situações ?" ,"Situações ?" ,"Situações ?" ,"mv_ch8" ,"C"   ,05       ,0        ,0       ,"G"  ,"fSituacao" ,""    ,""      ,""    ,"mv_par08" ,""     ,""       ,""       ,""     ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,"")

Aadd( aHelpPor, "Situacoes a filtrar.")
PutSX1Help("P."+cPerg+"08.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

//PutSx1(cGrupo  ,cOrdem ,cPergunt               ,cPerSpa              ,cPerEng               ,cVar     ,cTipo ,nTamanho ,nDecimal ,nPresel ,cGSC ,cValid ,cF3 ,cGrpSxg ,cPyme ,cVar01     ,cDef01 ,cDefSpa1 ,cDefEng1 ,cCnt01 ,cDef02 ,cDefSpa2 ,cDefEng2 ,cDef03 ,cDefSpa3 ,cDefEng3 ,cDef04 ,cDefSpa4 ,cDefEng4 ,cDef05 ,cDefSpa5 ,cDefEng5           ,aHelpPor                ,aHelpEng           ,aHelpSpa           ,cHelp )                                               
 PutSX1(cPerg   ,"09"    ,"Dt. de Referencia ?" ,"Dt. de Referencia ?" ,"Dt. de Referencia ?" ,"mv_ch9" ,"D"   ,08       ,0        ,0       ,"G"  ,""     ,""  ,""      ,""    ,"mv_par09" ,""     ,""       ,""       ,""     ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,"")

Aadd( aHelpPor, "Data de Referencia.")
Aadd( aHelpPor, "Informe o ultimo dia, do mes para o qual realizou a compra.")
PutSX1Help("P."+cPerg+"09.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//


Return