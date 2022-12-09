#INCLUDE "rwmake.ch"
#DEFINE PICT_VL  "@E 999,999,999.99"


/*/
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅRFIS002     пїЅ Autor пїЅ Rene Lopes       пїЅ Data пїЅ  11/08/11   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDescricao пїЅ Mapa de Imposto de IRRF                                    пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ Certisign Especifico - FISCAL                              пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
/*/

User Function RFIS003()


//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ Declaracao de Variaveis                                             пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio de mapa de imposto de ISS "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Mapa de Imposto - IRRF"
Local cPict          := ""
Local titulo       := "@Mapa de Imposto - IRRF"
Local nLin         := 80

Local Cabec1       := "FORNECEDOR  NOME                                                           CNPJ                 NUMERO   CODRET   EMISSAO      ALIQ.     BS.IRRF     VL.IRRF   DT.VENC     VENC.REAL   DT.DIGIT    VL.IRRF DUPLICATA"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
//Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RFIS003" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFIS003" // Coloque aqui o nome do arquivo usado para impressao em disco 
Private cPerg 	:= "RFIS003" 
Private cString := ""
Private cCodFor
Private nValor := 0
Private cNumNF := 0 

Private nTotalNF := 0
Private nTotalISS:= 0 

AjustaSX1()
If !Pergunte(cPerg,.T.)
	Return
EndIf

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ Monta a interface padrao com o usuario...                           пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ Processamento. RPTSTATUS monta janela com a regua de processamento. пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅFunпїЅпїЅo    пїЅRUNREPORT пїЅ Autor пїЅ AP6 IDE            пїЅ Data пїЅ  22/06/11   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDescriпїЅпїЅo пїЅ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ monta a janela com a regua de processamento.               пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ Programa principal                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local _cDataBase := dDataBase 
Local _cTime 	    := Time()
Local _aCabec 	:= {}
Local _aDados  	:= {}
Local nIRRFE2    := 0
Local cPicture  := X3Picture("E2_NUMERO")

cAliasTrb := "TRC"

 	BeginSql Alias cAliasTrb
  		SELECT 
		F1.F1_FORNECE COD_FOR,
		F1.F1_LOJA LOJ_FOR,
		(SELECT A2.A2_NOME FROM SA2010 A2 WHERE A2.A2_COD = F1.F1_FORNECE AND A2.A2_LOJA = F1.F1_LOJA AND A2.D_E_L_E_T_ = ' ') NOME,
		(SELECT A2.A2_CGC FROM SA2010 A2 WHERE A2.A2_COD = F1.F1_FORNECE AND A2.A2_LOJA = F1.F1_LOJA  AND A2.D_E_L_E_T_ = ' ') CNPJ,
		E2.E2_FILIAL FILIAL,
		E2.E2_PREFIXO PREFIXO,
		E2.E2_NUM NUMERO,
		E2.E2_PARCELA PARCELA,
		E2.E2_TIPO TIPO,
		D1.D1_TOTAL VALORTIT,
		D1.D1_ALIQIRR ALIQIRRF,
		D1.D1_BASEIRR BASEIRR,
		D1.D1_VALIRR VLIRR,
		F1.F1_EMISSAO AS EMISSAO,
		SubStr(F1.F1_DTDIGIT,7,2)||'/'||SubStr(F1.F1_DTDIGIT,5,2)||'/'||SubStr(F1.F1_DTDIGIT,1,4) AS DTDIGIT 
		FROM
		%Table:SE2% E2 LEFT OUTER JOIN SF1010 F1 ON E2_NUM = F1_DOC AND 
		E2.E2_FORNECE = F1.F1_FORNECE AND E2.E2_LOJA = F1.F1_LOJA INNER JOIN 
		%Table:SD1% D1 ON D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = E2.E2_FORNECE AND D1.D1_LOJA = E2.E2_LOJA AND D1.D1_SERIE = E2.E2_PREFIXO
		WHERE
		F1.F1_DTDIGIT >= %exp:mv_par01% AND
		F1.F1_DTDIGIT <= %exp:mv_par02% AND 
		F1.F1_FORNECE >= %exp:mv_par03% AND
		F1.F1_FORNECE <= %exp:mv_par04% AND	
		E2.E2_TIPO IN ('NF') AND
		E2.E2_IRRF <> 0 AND
		E2.D_E_L_E_T_ = ' ' AND
		F1.D_E_L_E_T_ = ' ' AND
		D1.D_E_L_E_T_ = ' ' 
		ORDER BY NUMERO
  	ENDSQL
   
DbSelectArea("TRC") 
TRC->(dbGoTop())

SE2->( dbSetOrder(1) )

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ SETREGUA -> Indica quantos registros serao processados para a regua пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

SetRegua(RecCount())

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ Posicionamento do primeiro registro e loop principal. Pode-se criar пїЅ
//пїЅ a logica da seguinte maneira: Posiciona-se na filial corrente e pro пїЅ
//пїЅ cessa enquanto a filial do registro for a filial corrente. Por exem пїЅ
//пїЅ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    пїЅ
//пїЅ                                                                     пїЅ
//пїЅ dbSeek(xFilial())                                                   пїЅ
//пїЅ While !EOF() .And. xFilial() == A1_FILIAL                           пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
IF .NOT. TRC->( EOF() )
	While !TRC->(EOF())
	  
	//lRet 	:= .F.
	dDtEmi  := TRC->EMISSAO
	cSubE2  := TRC->COD_FOR  
	cNumNF  := TRC->NUMERO
		
	    cAlias  := "TRD" 
	    
		BeginSql Alias cAlias
		    	SELECT
				SE2.E2_CODRET CODRET,
				SE2.E2_VENCTO, 
				SubStr(SE2.E2_EMISSAO,7,2)||'/'||SubStr(SE2.E2_EMISSAO,5,2)||'/'||SubStr(SE2.E2_EMISSAO,1,4) EMISSAO,
				SubStr(SE2.E2_VENCTO,7,2)||'/'||SubStr(SE2.E2_VENCTO,5,2)||'/'||SubStr(SE2.E2_VENCTO,1,4) VENCIMENTO,
				SubStr(SE2.E2_VENCREA,7,2)||'/'||SubStr(SE2.E2_VENCREA,5,2)||'/'||SubStr(SE2.E2_VENCREA,1,4) VENCREAL,
				SE2.E2_SALDO, SE2.E2_VALOR
				FROM
				%Table:SE2% SE2
				WHERE
				SE2.E2_NUM = %EXP:cNumNF% AND
				SE2.E2_NATUREZ IN ('SF410001') AND
				SE2.E2_EMISSAO = %EXP:dDtEmi%  AND 
			   	SUBSTR(SE2.E2_TITPAI,18,6) = %Exp:cSubE2% AND
				SE2.D_E_L_E_T_ = ' '
		ENDSQL 
		
		//RBeghini [30.01.2018] Retirado a condiзгo de somente tнtulos nгo pagos. Solicitaзгo de NGiardino
		IF .NOT. ( (TRD->CODRET == mv_par05) .And. ( TRD->E2_VENCTO >= dToS(mv_par06) .And. TRD->E2_VENCTO <= dToS(mv_par07) ) ) //.And. TRD->E2_SALDO > 0 )
			TRD->( dbCloseArea() ) 
			TRC->( dbSkip() ) 
			Loop
		Else
			IF SE2->( dbSeek( TRC->FILIAL + TRC->PREFIXO + TRC->NUMERO + TRC->PARCELA + TRC->TIPO + TRC->COD_FOR + TRC->LOJ_FOR ) )
				nIRRFE2  := SE2->E2_IRRF
			Else
				nIRRFE2  := 0
			EndIF
			
			aAdd(_aDados, {   TRC->COD_FOR,;
		        				TRC->NOME,;
		        			    IIf(Len(rTrim(TRC->CNPJ)) == 14, Transform(TRC->CNPJ, '@R 99.999.999/9999-99'), Transform(TRC->CNPJ, '@R 999.999.999-99')),;
		        				TRC->NUMERO,;
		        				TRD->CODRET,;
		        				TRD->EMISSAO,;
		        				TRC->ALIQIRRF,;
		        				TRC->BASEIRR,;
		        				TRC->VLIRR,;
		        				TRC->DTDIGIT,;
		        				TRD->VENCIMENTO,;
		        				TRD->VENCREAL,;
		        				Transform(nIRRFE2, '@E 99,999,999.99')})    
		   TRD->(dbCloseArea())                                                        
		   TRC->(dbSkip())    
		EndIF
		nIRRFE2  := 0
	EndDo
	TRC->(dbCloseArea())
Else
	MsgInfo('Nгo hб dados para imprimir, verifique os parвmetros informados','Mapa de Imposto - IRRF')
	Return
EndIF 

IF Empty( _aDados )
	MsgInfo('Nгo hб dados para imprimir, verifique os parвmetros informados','Mapa de Imposto - IRRF')
	Return
EndIF
_aDados := aSort(_aDados,,,{|x,y| x[2] < y[2]}) 

nDados := Len(_aDados)
nCount := 1
Private aCols

While nCount <= nDados


   //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
   //пїЅ Verifica o cancelamento pelo usuario...                             пїЅ
   //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
   //пїЅ Impressao do cabecalho do relatorio. . .                            пїЅ
   //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ   
     If nLin > 55 // Salto de PпїЅgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
  	 Endif
	
	 // Coloque aqui a logica da impressao do seu programa...
   	// Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD    
  IF nCount < nDados                 
   	cProxForn :=_aDados[nCount + 1][1]        
   	cProxNot  :=_aDados[nCount + 1][4]
 		If _aDados[nCount][1] == cProxForn .AND. _aDados[nCount][4] == cProxNot
 			cValidar:= cValtoChar (_aDados[nCount + 1][5])
 			If  cValidar <> " "
 		      _aDados[nCount][5]  := _aDados[nCount + 1][5] 
 		      _aDados[nCount][6]  := _aDados[nCount + 1][6]
 		      _aDados[nCount][11] := _aDados[nCount + 1][11]
 		      _aDados[nCount][12] := _aDados[nCount + 1][12]
 		      Else
 		      _aDados[nCount + 1][5]  := _aDados[nCount][5] 
 		      _aDados[nCount + 1][6]  := _aDados[nCount][6]
 		      _aDados[nCount + 1][11] := _aDados[nCount][11]
 		      _aDados[nCount + 1][12] := _aDados[nCount][12]
 		      EndIf
 		EndIf
 	EndIf
 		
       //nLin := nLin + 1 // Avanca a linha de impressa 
	    
        aCols := 1 
      	@nLin,02  PSAY _aDados[nCount][aCols] //1 - Cod Fornecedor	
   		aCols++
   		@nLin,12  PSAY _aDados[nCount][aCols] //2 - Desc. Fornecedor	
		aCols++
		@nLin,75 PSAY _aDados[nCount][aCols]  //3- CNPJ		//PICTURE "@R 99.999.999/9999-99"
		aCols++
		@nLin,96 PSAY _aDados[nCount][aCols]  PICTURE cPicture //4- NUMERO NOTA
		aCols++ 
		@nLin,105 PSAY _aDados[nCount][aCols] //5 - CODRET 	
		aCols++
		@nLin,114 PSAY _aDados[nCount][aCols] //6 - EMISSAO		
		aCols++
		@nLin,127 PSAY _aDados[nCount][aCols] //7 - ALIQ  		  		
		aCols++
		@nLin,131 PSAY _aDados[nCount][aCols] PICTURE PICT_VL //8 - BS.IRRF
		aCols++
		@nLin,143 PSAY _aDados[nCount][aCols] PICTURE PICT_VL //9 - VL. IRRF
		aCols+=2 
		@nLin,160 PSAY _aDados[nCount][aCols]       //11 - VENC.REAL
		aCols++
		@nLin,172 PSAY _aDados[nCount][aCols]      //12 - DT.DIGIT
		aCols-=2
		@nLin,184 PSAY _aDados[nCount][aCols]      //10 - DT.VENC
		aCols+=3
		@nLin,191 PSAY _aDados[nCount][aCols]      //13 - VALOR IRRF DUPLICATA
						
		
		nTotalNF  += _aDados[nCount][8]
		nTotalISS += _aDados[nCount][9]
		nLin++
		nCount++ 
		                  
Enddo     
	  	@nLin,00 PSAY Replicate ("__",220)
        nLin += 2
        @nLin,150 PSAY "Valor Total NF : "
        @nLin,164 PSAY nTotalNF PICTURE PICT_VL  
		@nLin,182 PSAY "Valor Total IRRF: " 
        @nLin,195 PSAY nTotalISS PICTURE PICT_VL
        nLin += 2 
        @nLin,185 PSAY Replicate ("--",13)      

_aDados := aSort(_aDados,,,{|x,y| x[5] < y[5]})  
nCount	  := 1 
nTotalISS := 0 
nLin++
   		@nLin,185 PSAY "|CD.RETENCAO|"
        @nLin,200 PSAY "VL. TOTAL |"
nLin++
     
Private nCodRet:= _aDados[nCount][5] 
  
  While nCount <= Len(_aDados)
  
    If _aDados[nCount][5] <> nCodRet
        @nLin,185 PSAY "|"
        @nLin,188 PSAY nCodRet + "     |"
        @nLin,196 PSAY nTotalISS PICTURE PICT_VL
        @nLin,210 PSAY " |"
        nCodRet:= _aDados[nCount][5] 
        nTotalISS := 0  
        nTotalISS := 0
        nLin ++
    EndIf 
   	nTotalISS += _aDados[nCount][9]
    nCount ++                           
   Enddo 
  		@nLin,185 PSAY "|"
        @nLin,188 PSAY nCodRet + "     |"
        @nLin,196 PSAY nTotalISS PICTURE PICT_VL
        @nLin,210 PSAY " |" 
        nLin ++
  		@nLin,185 PSAY Replicate ("--",13)      
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ Abertura do Arquivo em EXCEL. 		                                пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	
If mv_par08 == 1
	DlgToExcel( { { "ARRAY", "Mapa de Impostos - @IRRF",; 
			     {'Fornecedor', 'Nome', 'CNPJ', 'Numero', 'CodRET', 'Emissгo', 'Aliq.', 'Bs.IRRF', 'Vl.IRRF', 'Dt.Digit', 'Dt.Venc', 'Venc.Real', 'Vl.IRRF Duplicata'},; 
			     _aDados } } )
EndIf

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ Finaliza a execucao do relatorio...                                 пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

SET DEVICE TO SCREEN

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ Se impressao em disco, chama o gerenciador de impressao...          пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return 

Static Function AjustaSX1()

Local aArea := GetArea()

PutSx1(cPerg,"01","Dt. Digitaзгo de      ","","","mv_ch1","D",08,00,01,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
PutSx1(cPerg,"02","Dt. Digitaзгo ate     ","","","mv_ch2","D",08,00,01,"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
PutSx1(cPerg,"03","Fornecedor de         ","","","mv_ch3","C",06,00,01,"G","","SA2","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Cуdigo inicial do Fornecedor"})
PutSx1(cPerg,"04","Fornecedor ate        ","","","mv_ch4","C",06,00,01,"G","","SA2","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Cуdigo final do Fornecedor"})
PutSx1(cPerg,"05","Codigo Recolhimento   ","","","mv_ch5","C",04,00,01,"G","","37" ,"","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Cуdigo de Recolhimento"})
PutSx1(cPerg,"06","Dt. pagamento de      ","","","mv_ch6","D",08,00,01,"G","","   ","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial do pagamento"})
PutSx1(cPerg,"07","Dt. pagamento ate     ","","","mv_ch7","D",08,00,01,"G","","   ","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data final do pagamento"})
//PutSx1(cPerg,"08","Dt. contabilizaзгo de ","","","mv_ch8","D",08,00,01,"G","","   ","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial da contabilizaзгo"})
//PutSx1(cPerg,"09","Dt. contabilizaзгo ate","","","mv_ch9","D",08,00,01,"G","","   ","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data final da contabilizaзгo"})
PutSx1(cPerg,"08","Gerar Excel           ","","","mv_ch8","N",01,00,01,"C","","   ","","","mv_par08","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Gerar arquivo Excel?"})

RestArea(aArea)

