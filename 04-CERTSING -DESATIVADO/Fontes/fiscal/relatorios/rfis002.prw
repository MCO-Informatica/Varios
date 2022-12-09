#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#DEFINE PICT_VL  "@E 999,999,999.99"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIS002   ºAutor  ³Rene Lopes          º Data ³  22/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     |@Mapa de Imposto de ISS                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFIS002()


//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ Declaracao de Variaveis                                             ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio de mapa de imposto de ISS "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Mapa de Imposto - ISS"
Local cPict          := ""
Local titulo       := "@Mapa de Imposto - ISS"
Local nLin         := 60

Local Cabec1       := "FORNECEDOR  NOME                                                           CNPJ                 NUMERO   COD.ISS  EMISSAO    ALIQ    BS.ISS     VLISS     DT.VENC     VENC REAL   DT.DIGIT"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFIS002" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFIS002" // Coloque aqui o nome do arquivo usado para impressao em disco 
Private cPerg 	   := "RFIS002A" 
Private cString    := "" 

Private nTotalNF   := 0
Private nTotalISS  := 0     
Private cFilial    := 0

AjustaSX1()
If !Pergunte(cPerg,.T.)
	Return
EndIf

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ Monta a interface padrao com o usuario...                           ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,tamanho,,.T.)  //THE SPACE NULL IS VARIABLE SIZE

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ Processamento. RPTSTATUS monta janela com a regua de processamento. ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |RUNREPORT ºAutor  ³AP6 IDE	         º Data ³  22/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa Principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cWhere := ""

cAliasTrb := "TRC"

 	BeginSql Alias cAliasTrb
  		
  		SELECT   
  		F1.F1_FILIAL FILIAL,
		F1.F1_FORNECE COD_FOR,
		(SELECT A2.A2_NOME FROM %Table:SA2% A2 WHERE A2.A2_COD = F1.F1_FORNECE AND A2.A2_LOJA = F1.F1_LOJA AND A2.D_E_L_E_T_ = ' ') NOME,
		(SELECT A2.A2_CGC FROM %Table:SA2% A2 WHERE A2.A2_COD = F1.F1_FORNECE AND A2.A2_LOJA = F1.F1_LOJA AND A2.D_E_L_E_T_ = ' ') CNPJ,
		E2_NUM NUMERO, 
		D1.D1_ALIQISS ALIQISS,
		D1.D1_BASEISS VALORNF,
		D1.D1_VALISS VLISS,
		E2.E2_EMISSAO EMISSAO,
		F1_DOC, F1_SERIE SERIE		
		FROM %Table:SE2% E2 
		LEFT OUTER JOIN %Table:SF1% F1 
		ON E2_NUM = F1_DOC AND E2.E2_FORNECE = F1.F1_FORNECE AND F1.F1_LOJA = E2.E2_LOJA AND F1.F1_PREFIXO = E2.E2_PREFIXO AND F1.D_E_L_E_T_ = ' ' 
		INNER JOIN %Table:SD1% D1 
		ON D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = E2.E2_FORNECE AND D1.D1_LOJA = E2.E2_LOJA AND D1.D_E_L_E_T_ = ' '
		WHERE
		E2.E2_EMISSAO >= %exp:mv_par01% AND
		E2.E2_EMISSAO <= %exp:mv_par02% AND
		F1.F1_FORNECE >= %exp:mv_par03% AND
		F1.F1_FORNECE <= %exp:mv_par04% AND
		E2.E2_TIPO IN ('NF') AND
		E2.E2_ISS > 0 AND    
		E2.E2_FILIAL = %xFilial:SE2% AND
		F1.F1_FILIAL = %xFilial:SF1% AND
		D1.D1_FILIAL = %xFilial:SD1% AND
		E2.D_E_L_E_T_ = ' ' 
		ORDER BY E2.E2_NUM
   ENDSQL
    
_cDataBase 	:= dDataBase 
_cTime 		:= Time()
_aCabec 	:= {}
_aDados		:= {}

AAdd(_aCabec, {"COD_FOR"},{"NOME"},{"CNPJ"},{"NUMERO"},{"CODRETISS"},{"EMISSAO"},{"ALIQISS"},{"VALORNF"},{"VLISS"})

  
DbSelectArea("TRC") 
TRC->(dbGoTop())

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ SETREGUA -> Indica quantos registros serao processados para a regua ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

SetRegua(RecCount())

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ Posicionamento do primeiro registro e loop principal. Pode-se criar ï¿½
//ï¿½ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ï¿½
//ï¿½ cessa enquanto a filial do registro for a filial corrente. Por exem ï¿½
//ï¿½ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ï¿½
//ï¿½                                                                     ï¿½
//ï¿½ dbSeek(xFilial())                                                   ï¿½
//ï¿½ While !EOF() .And. xFilial() == A1_FILIAL                           ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
IF TRC->(EOF())
	MsgAlert('Não há registros conforme parâmetros informados, por favor verifique.','Mapa de Imposto - ISS')
	Return
EndIF

While !TRC->(EOF()) 

    nFilial := xFilial("SD1")
	cCodFor := TRC->COD_FOR
	cNumNF 	:= TRC->NUMERO
	cSerieNF := TRC->SERIE
	dDtEmi  := TRC->EMISSAO 
    dNumero := NUMERO
	nVlIss  := VLISS
	cAlias  := "TRD"
	cAlias2 := "TRE"

	BeginSql Alias cAlias
	SELECT  
	B1.B1_CODISS CODRETISS,
	SubStr(F1.F1_EMISSAO,7,2)||'/'||SubStr(F1.F1_EMISSAO,5,2)||'/'||SubStr(F1.F1_EMISSAO,1,4) AS EMISSAO,
	SubStr(F1.F1_DTDIGIT,7,2)||'/'||SubStr(F1.F1_DTDIGIT,5,2)||'/'||SubStr(F1.F1_DTDIGIT,1,4) AS DTDIGIT
	FROM %Table:SD1% D1 
	INNER JOIN %Table:SB1% B1 
	ON D1.D1_FILIAL = B1.B1_FILIAL AND D1.D1_COD = B1.B1_COD AND B1.D_E_L_E_T_ = ' '  
    INNER JOIN %Table:SF1% F1 
    ON D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = F1.F1_FORNECE AND D1.D1_LOJA = F1.F1_LOJA AND F1.D_E_L_E_T_ = ' '
    WHERE   
    D1.D1_FILIAL = %EXP:nFilial% AND
    D1.D1_FORNECE = %EXP:cCodFor%  AND
    D1.D1_DOC = %EXP:cNumNF% AND
	D1.D1_SERIE = %EXP:cSerieNF% AND
   	B1.B1_CODISS  <> ' ' AND
    D1.D_E_L_E_T_ = ' '
	ENDSQL  
	
	
	BeginSql Alias cAlias2
	SELECT SubStr(E2.E2_VENCTO,7,2)||'/'||SubStr(E2.E2_VENCTO,5,2)||'/'||SubStr(E2.E2_VENCTO,1,4) AS VENCIMENTO,
	SubStr(E2.E2_VENCREA,7,2)||'/'||SubStr(E2.E2_VENCREA,5,2)||'/'||SubStr(E2.E2_VENCREA,1,4) AS VENC_ORIG,
	E2.E2_VENCTO AS E2_VENCTO
	FROM 
	%Table:SE2% E2
	WHERE 
	//--E2.E2_FILIAL = %EXP:nFilial% AND
	E2.E2_EMISSAO = %EXP:dDtEmi% AND
	//--E2_VALOR = %EXP:nVlIss% AND
	E2.E2_TIPO = 'ISS' AND
	E2.E2_NUM = %EXP:dNumero% AND
	E2.D_E_L_E_T_ = ' '
	ENDSQL 
	
	IF .NOT. ( TRE->E2_VENCTO >= dToS(mv_par05) .And. TRE->E2_VENCTO <= dToS(mv_par06)  )
		TRD->(dbCloseArea())
		TRE->(dbCloseArea()) 
	   TRC->(dbSkip())    
		Loop
	Else
		aAdd(_aDados, 	{   TRC->COD_FOR,;
	        				TRC->NOME,;
	        				Transform(TRC->CNPJ, '@R 99.999.999/9999-99'),;
	        				TRC->NUMERO,;
	        				TRD->CODRETISS,;
	        				(TRD->EMISSAO),;
	        				TRC->ALIQISS,;
	        				TRC->VALORNF,;
	        				TRC->VLISS,;
	        				TRD->DTDIGIT,;
	        				TRE->VENCIMENTO,;
	        				TRE->VENC_ORIG})    
	   TRD->(dbCloseArea())
	   TRE->(dbCloseArea()) 
	   TRC->(dbSkip())
	EndIF 

EndDo
TRC->(dbCloseArea()) 

IF Empty(_aDados)
	MsgAlert('Atenção.' + CRLF + 'Após análise, não há registros conforme parâmetros informados, por favor verifique.','Mapa de Imposto - ISS')
	Return
EndIF
_aDados := aSort(_aDados,,,{|x,y| x[2] < y[2]}) 

nDados := Len(_aDados)
nCount := 1
lnextpage := .T.

Private aCols

While nCount <= nDados


   //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
   //ï¿½ Verifica o cancelamento pelo usuario...                             ï¿½
   //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
   //ï¿½ Impressao do cabecalho do relatorio. . .                            ï¿½
   //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½   
     If nLin > 55 // Salto de Pï¿½gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
  	 Endif
	
	 // Coloque aqui a logica da impressao do seu programa...
   	// Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
 		
 		
       //nLin := nLin + 1 // Avanca a linha de impressa
	    
        aCols := 1 
      	@nLin,02  PSAY _aDados[nCount][aCols]	
   		aCols++
   		@nLin,12  PSAY _aDados[nCount][aCols]	
		aCols++
		@nLin,75 PSAY _aDados[nCount][aCols] 		//PICTURE "@R 99.999.999/9999-99"
		aCols++
		@nLin,96 PSAY _aDados[nCount][aCols]  		//PICTURE "999999"
		aCols++ 
		@nLin,105 PSAY _aDados[nCount][aCols] 	
		aCols++
		@nLin,114 PSAY _aDados[nCount][aCols]		
		aCols++
		@nLin,126 PSAY _aDados[nCount][aCols]  		  		
		aCols++
		@nLin,128 PSAY _aDados[nCount][aCols]       PICTURE PICT_VL
		aCols++
		@nLin,140 PSAY _aDados[nCount][aCols]		PICTURE PICT_VL
		aCols+=2 
		@nLin,157 PSAY _aDados[nCount][aCols]   
		aCols++
		@nLin,169 PSAY _aDados[nCount][aCols]
		aCols-=2
		@nLin,181 PSAY _aDados[nCount][aCols]
						
		
		nTotalNF  += _aDados[nCount][8]
		nTotalISS += _aDados[nCount][9]
		nLin++
		nCount++ 
		                  
Enddo  

  If nLin > 60 // Salto de Pï¿½gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
  	 Endif   
	  	@nLin,00 PSAY Replicate ("__",220)
        nLin += 2
        @nLin,150 PSAY "Valor Total NF : "
        @nLin,164 PSAY nTotalNF PICTURE PICT_VL  
		@nLin,182 PSAY "Valor Total ISS: " 
        @nLin,195 PSAY nTotalISS PICTURE PICT_VL
        nLin += 2 
        @nLin,160 PSAY Replicate ("--",13)      

_aDados := aSort(_aDados,,,{|x,y| x[5] < y[5]})  
nCount	  := 1 
nTotalISS := 0  

nLin++  
@nLin,70 SAY "Aguarde finalizado o relatorio"
     
Private nCodRet:= _aDados[nCount][5] 
  
  While nCount <= Len(_aDados) 
  
    If nLin > 60 // Salto de Pï¿½gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
  	 Endif
    
  If lnextpage == .t.
   //  	nLin := 10
   	lnextpage := .F.
    	
    	@nLin,160 PSAY "|CD.RETENCAO|"
        @nLin,174 PSAY "VL. TOTAL  |"
	nLin++
 Endif
   
    If _aDados[nCount][5] <> nCodRet  
        @nLin,160 PSAY "|"
        @nLin,163 PSAY nCodRet + "|"
        @nLin,171 PSAY nTotalISS PICTURE PICT_VL
        @nLin,185 PSAY " |"
        nCodRet:= _aDados[nCount][5] 
        nTotalISS := 0  
        nTotalISS := 0
        nLin ++        
        
   //    If nLin >= 70                                                                                                       
     //  	nLin := 10
	  //	Endif
    
    EndIf 
   		nTotalISS += _aDados[nCount][9]
    	nCount ++                           
   Enddo 
  		@nLin,160 PSAY "|"
        @nLin,163 PSAY nCodRet + "|"
        @nLin,171 PSAY nTotalISS PICTURE PICT_VL
        @nLin,185 PSAY " |" 
        nLin ++
  		@nLin,160 PSAY Replicate ("--",13)      

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ Abertura do Arquivo em EXCEL. 		                                ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
	
If mv_par07 == 1
	DlgToExcel({ {"ARRAY","Mapa de Impostos - @ISS", _aCabec, _aDados} }) 
EndIf

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ Finaliza a execucao do relatorio...                                 ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

SET DEVICE TO SCREEN

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ Se impressao em disco, chama o gerenciador de impressao...          ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return 

Static Function AjustaSX1()
	Local aArea := GetArea()
	
	PutSx1(cPerg,"01","Emissao De    ","Data De       ","Data De       ","mv_ch1","D",08,00,01,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
	PutSx1(cPerg,"02","Emissao Ate   ","Data Ate      ","Data Ate      ","mv_ch2","D",08,00,01,"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
	PutSx1(cPerg,"03","Fornecedor de ","Fornecedor de ","Fornecedor de ","mv_ch3","C",06,00,01,"G","","SA2","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
	PutSx1(cPerg,"04","Fornecedor ate","Fornecedor ate","Fornecedor ate","mv_ch4","C",06,00,01,"G","","SA2","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
	PutSx1(cPerg,"05","Vencimento De ","Data De       ","Data De       ","mv_ch5","D",08,00,01,"G","","   ","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial (pagamento) a ser considerada"})
	PutSx1(cPerg,"06","Vencimento Ate","Data Ate      ","Data Ate      ","mv_ch6","D",08,00,01,"G","","   ","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final (pagamento) a ser considerada"})
	PutSx1(cPerg,"07","Excel         ","Excel         ","Excel         ","mv_ch7","N",01,00,01,"C","",""   ,"","","mv_par07","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo Excel"})
	
	RestArea(aArea)
Return