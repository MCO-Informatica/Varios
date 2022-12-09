#INCLUDE "EECPEM26.ch"
#INCLUDE "Average.ch"
/*
Programa        : EECPEM26.PRW
Objetivo        : Memorando de Exportacao 
Autor           : Heder M Oliveira
Data/Hora       : 20/11/99 14:47
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

#xTranslate xLin1(<nVar>) => (<nVar> := <nVar>+10)
#xTranslate xLin2(<nVar>) => (<nVar> := <nVar>+08)

/*NCF - 21/08/09 - Define LIN_FIM_DLG
  Esta Define foi criada em substituição da Define DLG_LIN_FIN do Average.ch que está retornando -1
  e devido a isto, desposicionando a tela de Seleção de Itens do Memorando de Exportação.
*/
#define LIN_FIM_DLG (oMainWnd:ReadClientCoords(),oMainWnd:nBottom-If(SetMDIChild(),70,60))  
/*
Funcao      : EECPEM26
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : Cristiano A. Ferreira
              08/12/1999 10:16     
Obs.        :
*/
User Function EECPEM26

Local lRet := .f.
Local cRpt := "MEMEXP.RPT"

Local nCont, nInc
Local aSaveOrd

Private cSEQMEM,dDTIPMEM,cNomeExp,cEndExp,cCgcExp,cInscExp,cCidExp  
Private cEstExp,cNFExp,cSerieExp,dNFExp,cExpNro,cObsExp,cREExp,dREExp   
Private cDEExp,dDEExp,cCEExp,dCEExp,cProd1Exp,cProd2Exp,cProd3Exp
Private cDestExp,cDtExp,cAss1Exp,cAss2Exp,cCodFab,cNomeFab,cEndFab,cEnd2Fab 
Private cCgcFab,cInscFab,cCidFab,cEstFab,cNFFab,cSerieFab,cDtNFFab 
Private aNota := {}, aRE :={}

Begin Sequence
   If Select("Header_p") = 0
      AbreEEC()
   EndIf

   cSEQMEM  := SPACE(20) //SEQUENCIA MEMORANDO
   dDTIPMEM := dDATABASE // DATA IMPRESSAO MEMORANDO
   cNomeExp := Space(60) // Nome do Exportador
   cEndExp  := Space(60) // Endereco do Exportador
   cCgcExp  := Space(30) // CGC
   cInscExp := Space(30) // Inscricao Estadual
   cCidExp  := Space(60) // Cidade
   cEstExp  := Space(10) // Estado
   cNFExp   := "" //Space(30) // Nota Fiscal
   cSerieExp:= Space(20) // Serie da Nota
   dNFExp   := AVCTOD("")  // Data da Nota
   cExpNro  := Space(20) // Exportacao Nro
   cObsExp  := INCSPACE(STR0001,60,.F.) //Space(60) // Observacoes //"CONVÊNIO ICMS 113 DE 13/09/96"
   
   cREExp   := Space(20) // Registro de Exportacao
   dREExp   := AVCTOD("")  // Dt.Registro de Exportacao
   cDEExp   := Space(20) // Despacho de Exportacao
   dDEExp   := AVCTOD("")  // Dt.Despacho de Exportacao
   cCEExp   := Space(20) // Conhecimento de Exportacao
   dCEExp   := AVCTOD("")  // Dt do Conhecimento de Exportacao
   cProd1Exp:= Space(60) // Produtos 1
   cProd2Exp:= Space(60) // Produtos 2
   cProd3Exp:= Space(60) // Produtos 3
   cDestExp := Space(20) // Destino
   cDtExp   := Space(60) // Data 
   cAss1Exp := Space(60) // Nome da Pessoa Assinante
   cAss2Exp := Space(60) // Cargo da pessoa assinante

   cCodFab  := Space(10) // Código do Fabricante
   cNomeFab := Space(60) // Nome do Fabricante
   cEndFab  := Space(60) // Endereco
   cEnd2Fab := Space(60) // Complemento do End
   cCgcFab  := Space(30) // CGC
   cInscFab := Space(30) // Inscricao Estadual
   cCidFab  := Space(30) // cidade
   cEstFab  := Space(10) // Estado
   cNFFab   := Space(30) // Nota Fiscal
   cSerieFab:= Space(20) // Serie
   cDtNFFab := Space(10) // Data da NF            
   
   IF ! TelaGets()
      Break
   Endif
   
   // Alterado por Heder M Oliveira - 1/6/2000
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
 
   FOR nCONT:=1 TO 4 //4 VIAS
      //adicionar registro no HEADER_P
      HEADER_P->(DBAPPEND())

      //gravar dados a serem editados
      HEADER_P->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
      
      HEADER_P->AVG_SEQREL := cSeqRel
      HEADER_P->AVG_C01_10 := STR(nCONT,1) //NR. VIA
      HEADER_P->AVG_C01_20 := cSEQMEM    // NR. SEQUENCIA
      HEADER_P->AVG_C02_20 := DTOC(dDTIPMEM) //DATA IMPRESSAO
      HEADER_P->AVG_C01_60 := cNomeExp  // Nome do Exportador
      HEADER_P->AVG_C02_60 := cEndExp   // Endereco do Exportador
      HEADER_P->AVG_C01_30 := cCgcExp   // CGC
      HEADER_P->AVG_C02_30 := cInscExp  // Inscricao Estadual
      HEADER_P->AVG_C03_60 := cCidExp   // Cidade
      HEADER_P->AVG_C02_10 := cEstExp   // Estado
      /* AST - 21/08/08
      HEADER_P->AVG_C03_30 := cNFExp    // Nota Fiscal
      HEADER_P->AVG_C03_20 := cSerieExp // Serie da Nota
      HEADER_P->AVG_C03_10 := Dtoc(dNFExp) // Data da Nota
      */
      if nCONT == 1 // AST - 21/08/08 - Adiciona as notas no detail_p apenas uma vez, para não repetir no relatório
         For nInc := 1 To Len(aNota)         
            DETAIL_P->(DbAppend())
            DETAIL_P->AVG_SEQREL := HEADER_P->AVG_SEQREL
            DETAIL_P->AVG_CHAVE  := "NOTA"
            DETAIL_P->AVG_C01_60 := aNota[nInc][1]    // Nota Fiscal
            DETAIL_P->AVG_C01_10 := aNota[nInc][2] // Serie da Nota
            DETAIL_P->AVG_C02_10 := Dtoc(aNota[nInc][3]) // Data da Nota
         Next         
      endIf
      HEADER_P->AVG_C04_20 := cExpNro   // Exportacao Nro
      HEADER_P->AVG_C04_60 := cObsExp   // Observacoes
      /* AST - 21/08/08
      HEADER_P->AVG_C05_20 := cREExp    // Registro de Exportacao
      HEADER_P->AVG_C04_10 := Dtoc(dREExp) // Dt.Registro de Exportacao
      */
      if nCONT == 1 // AST - 21/08/08 - Adiciona os RE no detail_p apenas uma vez, para não repetir no relatório
         For nInc := 1 To Len(aRE)         
            DETAIL_P->(DbAppend())
            DETAIL_P->AVG_SEQREL := HEADER_P->AVG_SEQREL
            DETAIL_P->AVG_CHAVE  := "RE"
            DETAIL_P->AVG_C01_20 := aRE[nInc][1]    // Registro de Exportacao
            DETAIL_P->AVG_C03_10 := Dtoc(aRE[nInc][2]) // Dt.Registro de Exportacao
         Next
      endIf   
      HEADER_P->AVG_C06_20 := cDEExp    // Despacho de Exportacao
      HEADER_P->AVG_C05_10 := Dtoc(dDEExp) // Dt.Despacho de Exportacao
      HEADER_P->AVG_C07_20 := cCEExp    // Conhecimento de Exportacao
      HEADER_P->AVG_C06_10 := Dtoc(dCEExp) // Dt do Conhecimento de Exportacao
      HEADER_P->AVG_C07_60 := cProd1Exp // Produtos 1
      HEADER_P->AVG_C08_60 := cProd2Exp // Produtos 2
      HEADER_P->AVG_C09_60 := cProd3Exp // Produtos 3
      HEADER_P->AVG_C08_20 := cDestExp  // Destino
      HEADER_P->AVG_C10_60 := cDtExp    // Data 
      HEADER_P->AVG_C11_60 := cAss1Exp  // Nome da Pessoa Assinante
      HEADER_P->AVG_C12_60 := cAss2Exp  // Cargo da pessoa assinante

      HEADER_P->AVG_C13_60 := cNomeFab // Nome do Fabricante
      HEADER_P->AVG_C14_60 := cEndFab  // Endereco
      HEADER_P->AVG_C15_60 := cEnd2Fab // Complemento do End
      HEADER_P->AVG_C04_30 := cCgcFab  // CGC
      HEADER_P->AVG_C05_30 := cInscFab // Inscricao Estadual
      HEADER_P->AVG_C06_30 := cCidFab  // cidade
      HEADER_P->AVG_C07_10 := cEstFab  // Estado
      HEADER_P->AVG_C07_30 := cNFFab   // Nota Fiscal
      HEADER_P->AVG_C09_20 := cSerieFab// Serie
      HEADER_P->AVG_C16_60 := cDtNFFab // Data da NF

      // Gravar historico de doctos
      HEADER_H->(dbAppend())
      AvReplace("HEADER_P","HEADER_H")

   NEXT nCONT

   /*
   AMS - 06/01/2006. Gravação do número do memorando de exportação no EXL.
   */
   If SX2->(dbSetOrder(1), dbSeek("EXL"))

      If Select("EXL") = 0
         dbSelectArea("EXL")
      EndIf

      If Select("EXL") <> 0 .and. EXL->(FieldPos("EXL_NROMEX") <> 0 .and.;
                                        FieldPos("EXL_DTMEX") <> 0)

         aSaveOrd := SaveOrd("EXL", 1)

         If EXL->(EXL_FILIAL+EXL_PREEMB) <> EEC->(EEC_FILIAL+EEC_PREEMB)
            EXL->(dbSeek(xFilial()+EEC->EEC_PREEMB))
         EndIf

         EXL->( RecLock("EXL", .F.),;
                EXL_NROMEX := cSEQMEM,;
                EXL_DTMEX  := Dtoc(dDTIPMEM),;
                MsUnLock() )

         RestOrd(aSaveOrd, .T.)

      EndIf   

   EndIf
   /*Fim do controle p/ gravação do nº do memorando de exportação*/

   IF ! (lRet := AvgCrw32(cRpt,STR0002,cSeqRel)) //"Memorando de Exportacao"
      Break
   Endif
      
   //gravar historico de documentos
   E_HISTDOC(,STR0002,dDATABASE,,,cRPT,cSeqRel,"2",EEC->EEC_PREEMB) //"Memorando de Exportacao"
   
End Sequence

Return .F.

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.
Local y := 0
Local bOk, bCancel

Local oFld,aFld

Begin Sequence
   
   M->EEC_PREEMB := Space(AVSX3("EEC_PREEMB",3))

   DEFINE MSDIALOG oDlg TITLE STR0003 FROM 7,10 TO 12,60 OF oMainWnd //"Memorando de Exportação"
   
      y := 20
      cDescCpo := Avsx3("EEC_PREEMB",AV_TITULO)
      @ y,05 SAY cDescCpo PIXEL
      @ y,45 MSGET M->EEC_PREEMB F3 "EEC" SIZE 50,08;
                    PICTURE AVSX3("EEC_PREEMB",6) ;
                    VALID ExistEmbarq() PIXEL 
      
      bOk     := {||lRet:=.t.,IF(ValidAll(oDlg),oDlg:End(),lRet:=.f.)}
      bCancel := {||oDlg:End()}

   ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,bOk,bCancel))
   
   IF ! lRet
      Break
   Endif 
   
   // AST - 01/08/08 - Caso alguma operação seja cancelada, não apresenta a dialog
   lRet := LoadGets()
   
   IF ! lRet
      Break
   Endif 
   
   DEFINE MSDIALOG oDlg TITLE STR0003 FROM 7,0 TO 28,80 OF oMainWnd //"Memorando de Exportação"
   
      oFld := TFolder():New(15,1,{STR0004, STR0005,STR0006},; //"Exportador"###"Exportador - Continuação"###"Fabricante"
                 {"EXP","CON","FAB"},oDlg,,,,.T.,.F.,314,145)
      
      // Atribui a fonte da dialog, para os folder's ...
      aFld := oFld:aDialogs
      aEval(aFld,{|x| x:SetFont(oDlg:oFont) }) 
      
      /* AST - 21/08/08 - Alguns campos sairam da tela devido o novo Layout do Memorando de Exportação*/
      // Exportador ...
      TSay():New(y:=1,01,{|| STR0007},aFld[1],,,,,,.t.) //"Nome"
      TGet():New(xLin2(y),01,bSetGet(cNomeExp),aFld[1],210,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y),01,{|| STR0008},aFld[1],,,,,,.t.) //"Endereco"
      TGet():New(xLin2(y),01,bSetGet(cEndExp),aFld[1],210,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0009},aFld[1],,,,,,.t.) //"CGC"
      TSay():New(y, 80,{|| STR0010},aFld[1],,,,,,.t.) //"Inscriçao Estadual"
      TSay():New(y,160,{|| STR0011},aFld[1],,,,,,.t.) //"Cidade"
      TSay():New(y,250,{|| STR0012},aFld[1],,,,,,.t.) //"Estado"
      
      TGet():New(xLin2(y),01,bSetGet(cCGCExp),aFld[1],77,08,"@!",,,,,,,.t.,)
      TGet():New(y,80,bSetGet(cInscExp),aFld[1],77,08,"@!",,,,,,,.t.,)
      TGet():New(y,160,bSetGet(cCidExp),aFld[1],87,08,"@!",,,,,,,.t.,)
      TGet():New(y,250,bSetGet(cEstExp),aFld[1],57,08,"@!",,,,,,,.t.,)
      
//      TSay():New(xLin1(y), 01,{|| STR0013},aFld[1],,,,,,.t.) //"Nota Fiscal Nro."
//      TSay():New(y,140,{|| STR0014},aFld[1],,,,,,.t.) //"Série"
//      TSay():New(y,213,{|| STR0015},aFld[1],,,,,,.t.) //"Data"
      
//      TGet():New(xLin2(y),01,bSetGet(cNFExp),aFld[1],137,08,"@!",,,,,,,.t.,)
//      TGet():New(y,140,bSetGet(cSerieExp),aFld[1],70,08,"@!",,,,,,,.t.,)
//      TGet():New(y,213,bSetGet(dNFExp),aFld[1],60,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0016},aFld[1],,,,,,.t.) //"Exportação Nro."
      TSay():New(y, 74,{|| STR0017},aFld[1],,,,,,.t.) //"Observações"
      
      TGet():New(xLin2(y),01,bSetGet(cExpNro),aFld[1],70,08,"@!",,,,,,,.t.,)
      TGet():New(y, 74,bSetGet(cObsExp),aFld[1],210,08,"@!",,,,,,,.t.,)
      
//      TSay():New(xLin1(y), 01,{|| STR0018},aFld[1],,,,,,.t.) //"Registro de Exportação Nro."
//      TSay():New(y, 74,{|| STR0015},aFld[1],,,,,,.t.) //"Data"
      TSay():New(xLin1(y),01,{|| STR0019},aFld[1],,,,,,.t.) //"Despacho Exportacao Nro."
      TSay():New(y,75,{|| STR0015},aFld[1],,,,,,.t.) //"Data"
      TSay():New(y, 122,{|| STR0020},aFld[1],,,,,,.t.) //"Conhecimento de Embarque"
      TSay():New(y, 198,{|| STR0015},aFld[1],,,,,,.t.) //"Data"
      
      
//      TGet():New(xLin2(y),01,bSetGet(cREExp),aFld[1],70,08,"@!",,,,,,,.t.,)
//      TGet():New(y, 74,bSetGet(dREExp),aFld[1],40,08,"@!",,,,,,,.t.,)
      TGet():New(xLin2(y),01,bSetGet(cDEExp),aFld[1],70,08,"@!",,,,,,,.t.,)
      TGet():New(y,75,bSetGet(dDEExp),aFld[1],40,08,"@!",,,,,,,.t.,)      
      TGet():New(y, 122,bSetGet(cCEExp),aFld[1],70,08,"@!",,,,,,,.t.,)
      TGet():New(y, 198,bSetGet(dCEExp),aFld[1],40,08,"@!",,,,,,,.t.,)
      
      // Exportador - Continuacao ...
	  y:=1
      
      TSay():New(y,01,{|| STR0021},aFld[2],,,,,,.t.) //"Destino"
      TGet():New(xLin2(y),01,bSetGet(cDestExp),aFld[2],70,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0022},aFld[2],,,,,,.t.) //"Descriminação dos Produtos"
      
      TGet():New(xLin2(y),01,bSetGet(cProd1Exp),aFld[2],210,08,"@!",,,,,,,.t.,)
      TGet():New(xLin1(y),01,bSetGet(cProd2Exp),aFld[2],210,08,"@!",,,,,,,.t.,)
      TGet():New(xLin1(y),01,bSetGet(cProd3Exp),aFld[2],210,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0023},aFld[2],,,,,,.t.) //"Data da Impressão"
      TGet():New(xLin2(y),01,bSetGet(cDtExp),aFld[2],210,08,"@!",,,,,,,.t.,)
      
	  TSay():New(xLin1(y), 01,{|| STR0024},aFld[2],,,,,,.t.) //"Assinatura"
      TGet():New(xLin2(y),01,bSetGet(cAss1Exp),aFld[2],210,08,"@!",,,,,,,.t.,,,,,,,,,"E33")
      TGet():New(xLin1(y),01,bSetGet(cAss2Exp),aFld[2],210,08,"@!",,,,,,,.t.)
      
	  TSay():New(xLin1(y), 01,{|| STR0025},aFld[2],,,,,,.t.) //"Seqüência do Memorando "
	  TSay():New(y,80,{|| STR0026},aFld[2],,,,,,.t.) //"Data do Memorando"
	  TGet():New(xLin2(y),01,bSetGet(cSEQMEM),aFld[2],70,08,"@!",,,,,,,.t.)
      TGet():New(y,80,bSetGet(dDTIPMEM),aFld[2],70,08,"@!",,,,,,,.t.)
       
      // Fabricante ...
      y := 1
      TSay():New(1,01,{||"Cód."},aFld[3],,,,,,.t.) //"Código"
      TSay():New(y,60,{|| STR0007},aFld[3],,,,,,.t.) //"Nome"
      //TGet():New(XLin2(y),01,bSetGet(cCodFab),aFld[3],55,08,"@!",,,,,,,.t.,)
      @ xLin2(y),01 MSGET cCodFab F3 "SA2" Valid valFab() SIZE 55,08 of oFld:aDialogs[3] Pixel

      TGet():New(y,60,bSetGet(cNomeFab),aFld[3],210,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y),01,{|| STR0008},aFld[3],,,,,,.t.) //"Endereco"
      TGet():New(xLin2(y),01,bSetGet(cEndFab),aFld[3],210,08,"@!",,,,,,,.t.,)
      TGet():New(xLin1(y),01,bSetGet(cEnd2Fab),aFld[3],210,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0009},aFld[3],,,,,,.t.) //"CGC"
      TSay():New(y, 80,{|| STR0010},aFld[3],,,,,,.t.) //"Inscriçao Estadual"
      TSay():New(y,160,{|| STR0011},aFld[3],,,,,,.t.) //"Cidade"
      TSay():New(y,250,{|| STR0012},aFld[3],,,,,,.t.) //"Estado"
      
      TGet():New(xLin2(y),01,bSetGet(cCGCFab),aFld[3],77,08,"@!",,,,,,,.t.,)
      TGet():New(y,80,bSetGet(cInscFab),aFld[3],77,08,"@!",,,,,,,.t.,)
      TGet():New(y,160,bSetGet(cCidFab),aFld[3],87,08,"@!",,,,,,,.t.,)
      TGet():New(y,250,bSetGet(cEstFab),aFld[3],57,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0013},aFld[3],,,,,,.t.) //"Nota Fiscal Nro."
      TSay():New(y,140,{|| STR0014},aFld[3],,,,,,.t.) //"Série"
      TSay():New(y,213,{|| STR0015},aFld[3],,,,,,.t.) //"Data"
      
      TGet():New(xLin2(y),01,bSetGet(cNFFab),aFld[3],137,08,"@!",,,,,,,.t.,)
      TGet():New(y,140,bSetGet(cSerieFab),aFld[3],70,08,"@!",,,,,,,.t.,)
      TGet():New(y,213,bSetGet(cDtNFFab),aFld[3],60,08,"@!",,,,,,,.t.,)

      bOk     := {||lRet:=.t.,oDlg:End()}
      bCancel := {||oDlg:End()}
      
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

End Sequence

Return lRet

/*
Funcao      : LoadGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function LoadGets

Local aOrd := SaveOrd({"SA2","EE9","SYR","EEM","EES"}) // AST - 01/08/08 - acrescentada a tabela "EES"
Local cAux, nInc

// AST - 01/08/08 - maiores detalhes, chamado 076088  
// AST - 21/08/08 - inclusão de novos campos na work, para trabalhar corretamente com NF e RE, maiores informações chamado 076088
Local cFileWork, oMark                                             
Local oDlg
Local aCpoBrowse := {}
Local aWork := { {"WKMARCA"  , "C"                        , 2                             , 0},;
                 {"WK_SEQEMB", AVSX3("EE9_SEQEMB",AV_TIPO), AVSX3("EE9_SEQEMB",AV_TAMANHO), 0},;
                 {"WK_COD_I" , AVSX3("EE9_COD_I" ,AV_TIPO), AVSX3("EE9_COD_I" ,AV_TAMANHO), 0},;
                 {"WK_VM_DES", "C"                        , AVSX3("EE9_VM_DES",AV_TAMANHO), 0},;
                 {"WK_RE    ", AVSX3("EE9_RE"    ,AV_TIPO), AVSX3("EE9_RE"    ,AV_TAMANHO), 0},;
                 {"WK_DTRE  ", AVSX3("EE9_DTRE"  ,AV_TIPO), AVSX3("EE9_DTRE"  ,AV_TAMANHO), 0},;                 
                 {"WK_NF    ", "C"                        , 30                            , 0},; 
                 {"WK_NFEES ", "C"                        , 50                            , 0} }

Local lSair := .F., nIndice, lRet := .T.   
Local cNF   := " "
Local lTEMEES  := .F. //Flag da tabela EES para verificar se existe registro referente ao embarque
Local lSelItem := .F. //Flag usada para verificar se nenhum item foi selecionado            

Local bOk := {|| oDlg:End() }, bCancel := {|| oDlg:End(), lSair:=.T.}
Local aButtons := { {"LBTIK",{|| Processa({|| MarkAll("WK_MEM",oMark)}) } ,"Marca/Desmarca Todos"} }
Local aPos := {}  //NCF - 21/08/09 - Array com as posições do objeto oDlg
Private aCampos := {}, aHeader := {} //usados no E_criaTrab
Private lInverte := .F., cMarca := GetMark()
Private aNF := {}

Begin Sequence

   SA2->(dbSetOrder(1))
   EE9->(dbSetOrder(3))
   SYR->(dbSetOrder(1))
   EEM->(dbSetOrder(2))

   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))

   //AST - 01/08/08 - Verifica se existe registro na Tabela EES referente ao embarque
   lTEMEES := EES->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   
   IF !EMPTY(EEC->EEC_EXPORT)
      SA2->(dbSeek(xFilial()+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
   ELSE
      SA2->(dbSeek(xFilial()+EEC->EEC_FORN+EEC->EEC_FOLOJA))
   ENDIF

   cNomeExp := Padr(Transf(SA2->A2_NOME,AVSX3("A2_NOME",6)),60)
   cEndExp  := Padr(Transf(SA2->A2_END,AVSX3("A2_END",6)),60)
   cCgcExp  := Padr(Transf(SA2->A2_CGC,AVSX3("A2_CGC",6)),30)
   cInscExp := Padr(Transf(SA2->A2_INSCR,AVSX3("A2_INSCR",6)),30)
   cCidExp  := Padr(Transf(SA2->A2_MUN,AVSX3("A2_MUN",6)),60)
   cEstExp  := Padr(Transf(SA2->A2_EST,AVSX3("A2_EST",6)),10)

   cNFExp   := "" // Nota Fiscal
   cSerieExp:= Space(20) // Serie da Nota
   dNFExp   := AVCTOD("")  // Data da Nota

   // AST - 01/08/08 
   If !lTEMEES
   
      EEM->(dbSeek(xFilial()+EEC->EEC_PREEMB+EEM_NF))
      EEM->(dbEval({|| cNFExp:=cNFExp+IF(!EMPTY(cNFExp),";","")+ALLTRIM(EEM->EEM_NRNF),;
                       cSerieExp := EEM->EEM_SERIE,;
                       dNFExp := EEM->EEM_DTNF },{|| EEM->EEM_TIPONF=="1"},;
                   {|| EEM_FILIAL==xFilial("EEM") .And. EEM_PREEMB == EEC->EEC_PREEMB .And. EEM_TIPOCA==EEM_NF}))

      cNFExp := Padr(cNFExp,30)                                                                                  
      cSerieExp:=Padr(cSerieExp,20)                                                                              
      
      // AST - 21/08/08 - Adiciona a nota no vetor, necessário para o novo layout do memorando de exportação
      aAdd(aNota,{cNFExp,cSerieExp,dNFExp})
   EndIf   

   cExpNro  := Transf(EEC->EEC_PREEMB,AVSX3("EEC_PREEMB",6))

   cREExp   := Padr(Transf(EE9->EE9_RE,AVSX3("EE9_RE",6)),20) // Registro de Exportacao
   dREExp   := EE9->EE9_DTRE       // Dt.Registro de Exportacao 

   cDEExp   := Padr(Transf(EE9->EE9_NRSD,AVSX3("EE9_NRSD",6)),20)//Space(20) // Despacho de Exportacao
   dDEExp   := EE9->EE9_DTAVRB //AVCTOD("")  // Dt.Despacho de Exportacao

   cCEExp   := Padr(Transf(EEC->EEC_NRCONH,AVSX3("EEC_NRCONH",6)),20) // Conhecimento de Exportacao
   dCEExp   := EEC->EEC_DTCONH  // Dt do Conhecimento de Exportacao
            
   SYR->(dbSeek(xFilial()+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA))
   cDestExp := Padr(POSICIONE("SYA",1,XFILIAL("SYA")+SYR->YR_PAIS_DE,"YA_DESCR"),20) // Destino

   cDtExp   := Padr(AllTrim(cCidExp)+", "+AllTrim(Str(Day(dDataBase)))+STR0028+Upper(MesExtenso(Month(dDataBase)))+STR0028+Str(Year(dDataBase),4),60) //"SAO PAULO, "###" DE "###" DE "
   cAss1Exp := Padr(EECCONTATO(CD_SA2,SA2->A2_COD,SA2->A2_LOJA,"1",1),60) // Nome da Pessoa Assinante
   cAss2Exp := Padr(EECCONTATO(CD_SA2,SA2->A2_COD,SA2->A2_LOJA,"1",2),60) // Cargo da pessoa assinante

   SA2->(dbSeek(xFilial()+EE9->EE9_FABR+EE9->EE9_FALOJA))

   // Dados do Fabricante ...
   cNomeFab := Padr(SA2->A2_NOME,60)
   cEndFab  := Padr(SA2->A2_END,60)
   cEnd2Fab := Padr(ALLTRIM(SA2->A2_BAIRRO)+"-"+ALLTRIM(SA2->A2_MUN)+"/"+ALLTRIM(SA2->A2_EST) ;
                             +"-"+ALLTRIM(BUSCAPAIS(SA2->A2_PAIS)) ;
                             +IF(!EMPTY(SA2->A2_CX_POST),STR0029+SA2->A2_CX_POST,""); //"-Cx.Post. "
                             +IF(!EMPTY(SA2->A2_CEP),STR0030+SA2->A2_CEP,""),60) //"-C.E.P. "
   Space(60) // Complemento do End
   cCgcFab  := Padr(Transf(SA2->A2_CGC,AVSX3("A2_CGC",6)),30)
   cInscFab := Padr(Transf(SA2->A2_INSCR,AVSX3("A2_INSCR",6)),30)
   cCidFab  := Padr(Transf(SA2->A2_MUN,AVSX3("A2_MUN",6)),60)  
   cEstFab  := Padr(Transf(SA2->A2_EST,AVSX3("A2_EST",6)),10)  

   cNFFab   := Space(30) // Nota Fiscal
   cSerieFab:= Space(20) // Serie
   cDtNFFab := Space(10) // Data da NF

   cAux := AllTrim(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),2))+" - "                           
   
   //AST - 01/08/08
   cFileWork := E_CriaTrab(,aWork,"WK_MEM")

   While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB 
                                              
      //AST - 01/08/08    
      /*cAux := cAux+AllTrim(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),1))+" / "
      EE9->(dbSkip())*/
      
      //AST - 01/08/08 - Adiciona na work os itens referente ao embarque
      WK_MEM->(dbAppend())
      WK_MEM->WKMARCA  := cMarca
      WK_MEM->WK_SEQEMB := EE9->EE9_SEQEMB 
      WK_MEM->WK_COD_I  := EE9->EE9_COD_I
      WK_MEM->WK_VM_DES := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),1)
      WK_MEM->WK_RE     := EE9->EE9_RE
      WK_MEM->WK_DTRE     := EE9->EE9_DTRE      
      //Seleciona todas as notas fiscais do item na tabela EES 
      If lTEMEES
         EES->(dbGoTop())
         cNF := ""
         cNFEES := ""
         Do While EES->(!EOF())
            If AllTrim(EES->EES_PREEMB) == AllTrim(EE9->EE9_PREEMB) .And.; 
                  alltrim(EES->EES_SEQUEN) == alltrim(EE9->EE9_SEQUEN)
            
               cNF += alltrim(EES->EES_NRNF) + " / "
               // AST - 21/08/08 - adiciona os recno das notas, para posteriormente recuperar os dados das notas selecionadas
               cNFEES += alltrim( str(EES->(RECNO() )) )+","
            
            ENDIF
            EES->(dbSkip())
         EndDo
         WK_MEM->WK_NF := SubStr(cNF,1,Len(cNF)-2)     
         WK_MEM->WK_NFEES:= SubStr(cNFEES,1,Len(cNFEES)-1)     
      EndIf
      
      EE9->(dbSkip())
   Enddo                                               

   // AST - 21/08/08 - adicionados os campos EE9_RE e EE9_DTRE no browse 
   aAdd(aCpoBrowse, {"WKMARCA",,""})
   aAdd(aCpoBrowse, {{|| WK_MEM->WK_SEQEMB },, AvSx3("EE9_SEQEMB", AV_TITULO)})
   aAdd(aCpoBrowse, {{|| WK_MEM->WK_COD_I  },, AvSx3("EE9_COD_I" , AV_TITULO)})
   aAdd(aCpoBrowse, {{|| WK_MEM->WK_VM_DES },, AvSx3("EE9_VM_DES", AV_TITULO)})
   aAdd(aCpoBrowse, {{|| WK_MEM->WK_RE     },, AvSx3("EE9_RE"    , AV_TITULO)})
   aAdd(aCpoBrowse, {{|| WK_MEM->WK_DTRE   },, AvSx3("EE9_DTRE"  , AV_TITULO)})   
   if lTEMEES
      aAdd(aCpoBrowse, {{|| WK_MEM->WK_NF }, ,"NOTAS FISCAIS"})
   ENDIF
   
   WK_MEM->(dbGoTop())
   
   DEFINE MSDIALOG oDlg TITLE "Seleção de Itens" FROM 0,0 TO LIN_FIM_DLG-(LIN_FIM_DLG/4),DLG_COL_FIM-(DLG_COL_FIM/4);
               						                      OF oMainWnd PIXEL
      aPos := {15,1,(oDlg:nClientHeight-6)/2,(oDlg:nClientWidth-4)/2}       //NCF - 21/08/09
      If(SetMdiChild(),aPos[3] -= 12,)
         						                      
      oMark := MsSelect():New("WK_MEM","WKMARCA",,aCpoBrowse,@lInverte,@cMarca,aPos/*PosDlg(oDlg)*/)   

   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, bOk, bCancel,,aButtons) CENTERED
  
   If lSair
      lRet := .F.
      break
   EndIf
  
   WK_MEM->(dbGoTop())
   
   Do While WK_MEM->(!EOF())
      IF WK_MEM->WKMARCA == cMarca
         cAux += alltrim(WK_MEM->WK_VM_DES) + " / "
         aAdd(aRE,{WK_MEM->WK_RE,WK_MEM->WK_DTRE})
         lSelItem := .T.
         If lTEMEES
            Split(WK_MEM->WK_NFEES,aNF,",")
         EndIf 
      EndIF   
      
      WK_MEM->(dbSkip())
   EndDo                                                  
   
   If !lSelItem
      Alert("Nenhum item selecionado.","Atenção")
      lRet := .F.
      break
   EndIf 
   
   // Não permite apresentar a mesma nota fiscal no relatório
   If lTEMEES       
      aSort(aNF)      
      for nIndice := 1 to len(aNF)
         // AST - 21/08/08 - obtem os dados das notas dos itens selecionados
         EES->(dbGoTo(val(aNF[nIndice])))
         aAdd(aNota,{alltrim(EES->EES_NRNF),alltrim(EES->EES_SERIE),EES->EES_DTNF})
      next
        ordenaNotas(aNota)     

//      cNFExp := SubStr(cNFExp,1,Len(cNFExp)-1)
   EndIf
   
   ordenaRE(aRE)   
      
   cAux := Substr(cAux,1,Len(cAux)-2)

   cProd1Exp:= Padr(MemoLine(cAux,60,1),60) // Produto 1
   cProd2Exp:= Padr(MemoLine(cAux,60,2),60) // Produto 2
   cProd3Exp:= Padr(MemoLine(cAux,60,3),60) // Produto 3

End Sequence

//AST - 01/08/08
WK_MEM->(DbCloseArea())
E_EraseArq(cFileWork)
RestOrd(aOrd)

Return lRet
      
/*
Funcao      : Split
Parametros  : Texto a ser divido, array onde as partes serão armazenadas, caracter usado para divisão do texto
Retorno     : 
Objetivos   : Dividir um texto em várias partes de acordo com o caracter que simboliza a divisão
Autor       : Anderson Soares Toledo
Data/Hora   : 01/08/2008 - 11h00
Revisao     : 
Obs.        :
*/
Static Function Split(cTexto, aArray, cSplit)
Local nIni := 1
Local nFim := len(alltrim(cTexto))
Local nSplit

Do While nIni <= nFim
   nSplit := at(cSplit,SubStr(cTexto,nIni,nFim))
   
   If nSplit > 0
      aAdd(aArray,alltrim(subStr(cTexto,nIni,nSplit - 1)))
      nIni := nSplit + 1
   Elseif len(SubStr(cTexto,nIni,nFim)) > 0
      aAdd(aArray,alltrim(subStr(cTexto,nIni,nFim)) )
      exit
   Else
      exit
   EndIf    
EndDo
      
return


                                  
Static Function MarkAll(cAlias,oMsSelect) 
Local cFlag, nRecNo:=0

Begin Sequence
   If Empty(cAlias)
      Break
   EndIf

   cFlag  := IF(!Empty((cAlias)->WKMARCA),Space(2),cMarca)
   nRecNo := (cAlias)->(RecNo())

   (cAlias)->(dbGotop())
   nOrdem := 1
   (cAlias)->(dbEval({|| (cAlias)->WKMARCA := cFlag}))
   (cAlias)->(dbGoTo(nRecNo))
   
   oMsSelect:oBrowse:Refresh()

End Sequence

Return NIL                        
                                                     
/*
Funcao      : OrdenaNotas
Parametros  : Vetor de 3 dimensões contendo nº da nota, série e data de emissão 
Retorno     : 
Objetivos   : Retirar as notas repetidas e agrupar as notas por série e data de emissão
Autor       : Anderson Soares Toledo
Data/Hora   : 21/08/2008
Revisao     : 
Obs.        :
*/
Static Function OrdenaNotas(aNota)
   local aVet := {{"","",""}} //cria um vetor com 3 posições
   local nCont, nCont2 := 1                                                     
   local cSerie, dData          
      
   //Para facilitar a leitura do código, foram criadas variáveis para informar o que representa o campo no array
   //NF = Fota Fiscal, Serie = Serie da NF e DtNF = Data de emissão da NF 
   Local nNF := 1, nSERIE := 2, nDtNF := 3 
   
   /* o array possui 3 posições: 1-nº NF, 2- Série, 3-data
      o aSort, ordena o array por Série, seguido de data de emissão e por última a nota */   
   aSort(aNota,,,{|x,y| x[nSERIE]+dtos(x[nDtNF])+x[nNF] < y[nSERIE]+dtos(y[nDtNF])+y[nNF]})  
     
   for nCont := 1 to len(aNota)
      
      cSerie := aNota[nCont][nSerie]
      dData := aNota[nCont][nDtNF]
      //percorre o vetor verificando todas as notas com a mesma Série e Data                  
      if !aNota[nCont][nNF] $ aVet[nCont2][nNF]   
         aVet[nCont2][nNF] := aVet[nCont2][nNF] + " ; " + aNota[nCont][nNF]
         aVet[nCont2][nSERIE] := aNota[nCont][nSERIE]
         aVet[nCont2][nDtNF] := aNota[nCont][nDtNF]         
      endif

      if nCont <= len(aNota)-1
         if aNota[nCont+1][nSerie] != cSerie .Or. aNota[nCont+1][nDtNF] != dData
            //retira os caracter ';' e os espaços em brancos da String contendo todas as notas fiscais
            //com a mesma Série e Data
            aVet[nCont2][nNF] := substr(aVet[nCont2][nNF],4,len(aVet[nCont2][nNF]))
            aAdd(aVet,{"","",""})//adiciona uma nova linha no array
            nCont2++
         endIf   
      else
         aVet[nCont2][nNF] := substr(aVet[nCont2][nNF],4,len(aVet[nCont2][nNF]))
      endif
   next
                                                    
   aSize(aVet,len(aVet))//retira a última linha do vetor, pelo fato de ela estar em branco                                           
   aSize(aNota,0) // Zera o vetor aNota para não correr o risco de pegar lixo da memória
   aNota := aVet  // Atribui o vetor criado para o vetor aNota
    
return                       

/*
Funcao      : OrdenaRE
Parametros  : Vetor de 2 dimensões contendo nº do RE e data
Retorno     : 
Objetivos   : Retirar os Registros repetidos
Autor       : Anderson Soares Toledo
Data/Hora   : 21/08/2008
Revisao     : 
Obs.        :
*/
Static Function OrdenaRE(aRE)
   local aVet := {}
   local nCont
   local nRE
             
   local n:=1
   
   for nCont := 1 to len(aRE)
      nRE := aRE[nCont][1]
      if aScan(aVet,{|x| x[1] == nRE}) == 0 .And. !EMPTY(nRE)
           aAdd(aVet, aRE[nCont])   
      endif
   next

   aSize(aRE,0)
   aRE := aVet
return                                                  
                                                                                 
/*
Funcao      : valFab
Parametros  : 
Retorno     : 
Objetivos   : Preencher os campos na guia Fabricante, de acordo com a empresa selecionada e com os registros da 
              tabela SA2              
Autor       : Anderson Soares Toledo
Data/Hora   : 21/08/2008
Revisao     : 
Obs.        :
*/
Static Function valFab()
  Local aOrdem := SaveOrd({"SA2","SYA"})
  
  SA2->(dbSetOrder(1))  
  SYA->(dbSetOrder(1))
  if  SA2->(dbSeek(xFilial("SA2")+alltrim(cCodFab))) 
     cNomeFab := alltrim(SA2->A2_Nome)  //Nome do Fabricante
     cEndFab  := alltrim(SA2->A2_END) +" - "+alltrim(SA2->A2_NR_END)+" - "+alltrim(SA2->A2_BAIRRO)//  Space(60) // Endereco
     cEnd2Fab := alltrim(SA2->A2_MUN) + " - " + alltrim(SA2->A2_EST) + " - " + POSICIONE("SYA",1,XFILIAL("SYA")+SA2->A2_PAIS,"YA_DESCR")
     cCgcFab  := Transf(SA2->A2_CGC,AVSX3("A2_CGC",AV_PICTURE))   // CGC
     cInscFab := alltrim(SA2->A2_INSCR) // Inscricao Estadual
     cCidFab  := alltrim(SA2->A2_MUN)   // cidade
     cEstFab  := alltrim(SA2->A2_EST)   // Estado  
  else
     Alert("Empresa não encontrada.")  
  endif 
  RestOrd(aOrdem)
return


*-------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM26.PRW                                            *
*-------------------------------------------------------------------------*
