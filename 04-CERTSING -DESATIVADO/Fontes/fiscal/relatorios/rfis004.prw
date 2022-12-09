#INCLUDE "rwmake.ch"
#Include 'Protheus.ch'
#DEFINE PICT_VL  "@E 999,999,999.99"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFIS004   บAutor  ณRen๊ Lopes          บ Data ณ  17/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de INSS                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function RFIS004()

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variaveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio de mapa de imposto de INSS "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Mapa de Imposto - INSS"
Local cPict          := ""
Local titulo       := "@Mapa de Imposto - INSS"
Local nLin         := 80

Local Cabec1       := "FORNECEDOR  NOME                                                           CNPJ                 NUMERO   EMISSAO     ALIQ    BS.INSS    VLINSS      DT.VENC     VENC REAL   DT.DIGIT    FILIAL"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
//Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RFIS004" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
//Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFIS004" // Coloque aqui o nome do arquivo usado para impressao em disco 
Private cPerg 	:= "RFIS004" 
Private cString := "" 

Private nTotalNF  := 0
Private nTotalINS := 0 

AjustaSX1()
If !Pergunte(cPerg,.T.)
	Return
EndIf     


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤL,็L,็ฟ
//ณMonta a interface padrao com o usuario...  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤL,็L,็ู
*/

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessamento. RPTSTATUS monta janela com a regua de processamento.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRUNREPORT     บAutor  ณAP6 IDE         บ Data ณ  04/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//Local nOrdem  
Local nVLRNF  := 0
Local nVLRINS := 0 
Local cPicture  := X3Picture("E2_NUMERO")
//Local aTotais := {0,0}
// aTotais[1] := Valor Nota
// aTotais[2] := Valor ISS

//dbSelectArea(cString)
//dbSetOrder(1)

cAliasTrb := "TRC"

 	BeginSql Alias cAliasTrb
  		
  		SELECT 
		F1.F1_FORNECE COD_FOR,
		(SELECT A2.A2_NOME FROM %Table:SA2% A2 WHERE A2.A2_COD = F1.F1_FORNECE AND A2.A2_LOJA = F1.F1_LOJA AND A2.D_E_L_E_T_ = ' ') NOME,
		(SELECT A2.A2_CGC FROM %Table:SA2% A2 WHERE A2.A2_COD = F1.F1_FORNECE AND A2.A2_LOJA = F1.F1_LOJA AND A2.D_E_L_E_T_ = ' ') CNPJ,
		E2_NUM NUMERO, 
		D1.D1_ALIQINS ALIQINS,
		D1.D1_BASEINS VALORNF,
		D1.D1_VALINS VLINS,
		E2.E2_EMISSAO EMISSAO,
		F1.F1_FILIAL FILIAL		
		FROM
		%Table:SE2% E2 LEFT OUTER JOIN %Table:SF1% F1 ON E2_NUM = F1_DOC AND 
		E2.E2_FORNECE = F1.F1_FORNECE INNER JOIN 
		%Table:SD1% D1 ON D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = E2.E2_FORNECE
		WHERE
		F1.F1_EMISSAO >= %exp:mv_par01% AND
		F1.F1_EMISSAO <= %exp:mv_par02% AND
		E2.E2_TIPO IN ('NF') AND
		E2.E2_INSS <> 0 AND    
		E2.D_E_L_E_T_ = ' ' AND
		F1.D_E_L_E_T_ = ' ' AND
		D1.D_E_L_E_T_ = ' ' 
		ORDER BY F1.F1_FORNECE, E2.E2_NUM ASC
   ENDSQL
   

_aCabec 	:= {}
_aDados	:= {}

  
DbSelectArea("TRC") 
TRC->(dbGoTop())


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSETREGUA -> Indica quantos registros serao processados para a reguaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

SetRegua(RecCount())   


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosicionamento do primeiro registro e loop principal. Pode-se criar  ณ
//ณa logica da seguinte maneira: Posiciona-se na filial corrente e pro  ณ
//ณcessa enquanto a filial do registro for a filial corrente. Por exem  ณ
//ณplo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:     ณ
//ณ                                                                     ณ
//ณdbSeek(xFilial())                                                    ณ
//ณWhile !EOF() .And. xFilial() == A1_FILIAL                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/


While !TRC->(EOF())
  
	cCodFor := COD_FOR
	cNumNF 	:= NUMERO
	dDtEmi  := EMISSAO 
    dNumero := NUMERO
	nVlIns  := VLINS
	cAlias  := "TRD"
	cAlias2 := "TRE"

	BeginSql Alias cAlias
	SELECT  
	//--B1.B1_CODISS CODRETISS,
	SubStr(F1.F1_EMISSAO,7,2)||'/'||SubStr(F1.F1_EMISSAO,5,2)||'/'||SubStr(F1.F1_EMISSAO,1,4) AS EMISSAO,
	SubStr(F1.F1_DTDIGIT,7,2)||'/'||SubStr(F1.F1_DTDIGIT,5,2)||'/'||SubStr(F1.F1_DTDIGIT,1,4) AS DTDIGIT
	FROM
    %Table:SD1% D1 INNER JOIN %Table:SB1% B1 ON D1.D1_COD = B1.B1_COD
    INNER JOIN %Table:SF1% F1 ON D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = F1.F1_FORNECE
    WHERE
    D1.D1_FORNECE = %EXP:cCodFor%  AND
    D1.D1_DOC = %EXP:cNumNF% AND
    //B1.B1_FILIAL = %xFilial:SB1% AND
	//F1.F1_FILIAL = %xFilial:SF1% AND
	//B1.B1_CODISS  <> ' ' AND
    D1.D_E_L_E_T_ <> '*' AND
	B1.D_E_L_E_T_ <> '*' 
	ENDSQL
	
	BeginSql Alias cAlias2
	SELECT SubStr(E2.E2_VENCTO,7,2)||'/'||SubStr(E2.E2_VENCTO,5,2)||'/'||SubStr(E2.E2_VENCTO,1,4) AS VENCIMENTO,
	SubStr(E2.E2_VENCREA,7,2)||'/'||SubStr(E2.E2_VENCREA,5,2)||'/'||SubStr(E2.E2_VENCREA,1,4) AS VENC_ORIG
	FROM 
	%Table:SE2% E2
	WHERE
	E2.E2_EMISSAO = %EXP:dDtEmi% AND
	//--E2_VALOR = %EXP:nVlIss% AND
	E2.E2_TIPO = 'INS' AND	
	E2.E2_NUM = %EXP:dNumero% AND
	E2.D_E_L_E_T_ <> '*'
	ENDSQL 
	
	aAdd(_aDados, 	{   TRC->COD_FOR,;
        				TRC->NOME,;
        				Transform(TRC->CNPJ, '@R 99.999.999/9999-99'),;
        				TRC->NUMERO,;
        			 	(TRD->EMISSAO),;
        				TRC->ALIQINS,;      
        				TRC->VALORNF,;
        				TRC->VLINS,;
        				TRE->VENCIMENTO,;
        				TRE->VENC_ORIG,;
        				TRD->DTDIGIT,;
        				TRC->FILIAL}) 
    
    nVLRNF  += TRC->VALORNF
    nVLRINS += TRC->VLINS
       
   TRD->(dbCloseArea())
   TRE->(dbCloseArea()) 
   TRC->(dbSkip())    
	
	
	IF cCodFor <> TRC->COD_FOR
		aAdd(_aDados, { 'Total','','','','','',nVLRNF,nVLRINS,'','','',''}) 
		aAdd(_aDados, { '','','','','','','','','','','',''}) 
		nVLRNF  := 0
    		nVLRINS := 0   
	EndIF
	
	
EndDo
TRC->(dbCloseArea()) 

//_aDados := aSort(_aDados,,,{|x,y| x[2] < y[2]}) 

nDados := Len(_aDados)
nCount := 1
Private aCols

While nCount <= nDados
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario... ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณImpressao do cabecalho do relatorio. .ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
     cCodFor := _aDados[nCount,1]
         
	@nLin,002 PSAY _aDados[nCount,1]
	@nLin,012 PSAY _aDados[nCount,2]
	@nLin,075 PSAY _aDados[nCount,3]
	@nLin,096 PSAY _aDados[nCount,4] PICTURE cPicture
	@nLin,105 PSAY _aDados[nCount,5]
	@nLin,117 PSAY _aDados[nCount,6]
	@nLin,120 PSAY _aDados[nCount,7] PICTURE PICT_VL
	@nLin,132 PSAY _aDados[nCount,8] PICTURE PICT_VL
	@nLin,149 PSAY _aDados[nCount,9]
	@nLin,161 PSAY _aDados[nCount,10]
	@nLin,173 PSAY _aDados[nCount,11]
	@nLin,185 PSAY _aDados[nCount,12]
	
	nTotalNF  += _aDados[nCount][7]
	nTotalINS += _aDados[nCount][8]
	nLin++ 
	nCount++
	
	IF cCodFor <> _aDados[nCount,1]
		@nLin,002 PSAY 'Total Fornecedor'
		@nLin,120 PSAY _aDados[nCount,7] PICTURE PICT_VL
		@nLin,132 PSAY _aDados[nCount,8] PICTURE PICT_VL
		nLin   := nLin + 2
		nCount := nCount + 2
	EndIF
Enddo     

@nLin,002 PSAY Replicate ("-",215)
nLin += 1
@nLin,002 PSAY "Valor Total NF: "
@nLin,016 PSAY nTotalNF PICTURE PICT_VL  
@nLin,036 PSAY "Valor Total INSS: " 
@nLin,050 PSAY nTotalINS PICTURE PICT_VL
nLin += 1
@nLin,002 PSAY Replicate ("-",215)

aAdd(_aDados, { '','','','','','','','','','','',''})
aAdd(_aDados, { 'Total Geral','','','','','',nTotalNF,nTotalINS,'','','',''}) 
 	
If mv_par03 == 1
	DlgToExcel( { { "ARRAY", "Mapa de Impostos - @INSS",;
		          {'FORNECEDOR','NOME','CNPJ','NUMERO','EMISSAO','ALIQ','BS.INSS','VLINSS','DT.VENC','VENC REAL','DT.DIGIT','FILIAL'}, _aDados } } )
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFinaliza a execucao do relatorio...   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe impressao em disco, chama o gerenciador de impressao...   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusteSX1 บAutor  ณRene Lopes          บ Data ณ  17/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1()

Local aArea := GetArea()

PutSx1(cPerg,"01","Emissao De          ","Emissao De         ","Emissao De         ","mv_ch1","D",08,00,01,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
PutSx1(cPerg,"02","Emissao Ate         ","Emissao Ate        ","Emissao Ate        ","mv_ch2","D",08,00,01,"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
PutSx1(cPerg,"03","Excel			 ","Excel              ","Excel             ","mv_chA","N",01,00,01,"C","",""   ,"","","mv_par03","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo Exce"})

RestArea(aArea)