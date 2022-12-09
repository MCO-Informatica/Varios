#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Cadp001ºAutor  ³Alebas / Sciba         º Data ³  13/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LASELVA COMERCIO DE LIVROS E ARTIGOS DE CONVENINENCIA LTDA º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CADP001()

Private aSays      := {}
Private aButtons   := {}
Private	nOpca      := 0
Private _cCadastro := "Importacao do Cadastro de Fornecedores"

AADD(aSays,"Este programa tem o objetivo importar os dados ")
AADD(aSays,"dos fornecedores do Sistema Proget para o Protheus.")
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( _cCadastro, aSays, aButtons )
	
	If nOpcA == 1
		Processa({|| CadFor() },"Cadastrando Fornecedores....")
	Endif
	
	
	Return
	
	STATIC Function CadFor()
	Local aVetor := {}
	Local cQuery :=" " 
	Local cIns	:= " "
	lMsErroAuto := .F.
	
	
	cQuery    +="SELECT '' AS 'A2_FILIAL', "
	cQuery    +="dbo.TI_StrZero(a.CodTerceiro,6) AS 'A2_COD', "
	cQuery    +="COALESCE((SELECT b.M0_CODFIL FROM PROGET.microsiga.dbo.sigamat b "
	cQuery    +="WITH(NOLOCK) WHERE b.codestabelecimento = a.CodTerceiro ), 'ZZ') AS "
	cQuery    +="'A2_LOJA',"
	cQuery    +="a.RazaoSocial AS 'A2_NOME', "
	cQuery    +="a.Fantasia AS 'A2_NREDUZ', "
	cQuery    +="COALESCE( a.Endereco, '' ) AS 'A2_END', "
	cQuery    +="'' AS 'A2_NR_END', "
	cQuery    +="COALESCE( a.Bairro, '') AS 'A2_BAIRRO', "
	cQuery    +="COALESCE( a.Cidade, '') AS 'A2_MUN', "
	cQuery    +="a.SiglaEstado AS 'A2_EST',"
	cQuery    +="'' AS 'A2_ESTADO',"
	cQuery    +="CONVERT( VARCHAR(8), RTRIM(LTRIM(REPLACE( COALESCE( a.Cep, ''), "
	cQuery    +="'-', '')))) AS 'A2_CEP', "
	cQuery    +="'' AS 'A2_CX_POST', "
	cQuery    +="CASE WHEN LTRIM(RTRIM(a.Cpf)) = '' OR a.Cpf IS NULL THEN 'J' ELSE "
	cQuery    +="'F' END AS 'A2_TIPO', "
	cQuery    +="CASE WHEN "
	cQuery    +="(SELECT b.M0_CGC "
	cQuery    +="FROM PROGET.microsiga.dbo.sigamat b WITH(NOLOCK) "
	cQuery    +="WHERE b.codestabelecimento = a.CodTerceiro ) IS NULL THEN "
	cQuery    +="CASE WHEN LEFT( REPLACE(REPLACE(REPLACE( a.Cgc, '-', ''), "
	cQuery    +="'/', ''), '.', ''), 14 ) IS NULL "
	cQuery    +="THEN LEFT( REPLACE(REPLACE(REPLACE( COALESCE( a.Cpf, "
	cQuery    +="''), '-', ''),'/', ''),'.',''),14) "
	cQuery    +="ELSE LEFT( REPLACE(REPLACE(REPLACE( a.Cgc, '-', ''), "
	cQuery    +="'/', ''), '.', ''), 14 ) END "
	cQuery    +="ELSE "
	cQuery    +="(SELECT b.M0_CGC "
	cQuery    +="FROM PROGET.microsiga.dbo.sigamat b WITH(NOLOCK) "
	cQuery    +="WHERE b.codestabelecimento = a.CodTerceiro ) END  AS 'A2_CGC', "
	cQuery    +="CONVERT( VARCHAR(180), COALESCE( a.Rg, '') ) AS 'A2_PFISICA', "
	cQuery    +="CONVERT( VARCHAR(3), LTRIM(RTRIM( COALESCE( a.DDD, '')))) AS  'A2_DDD', "
	cQuery    +="COALESCE( REPLACE( a.Telefone, '-', '' ), '') AS 'A2_TEL', "
	cQuery    +="COALESCE( REPLACE( a.Telefax, '-', '' ) , '') AS 'A2_FAX', "
	cQuery    +="COALESCE( a.InscricaoEstadual, '') AS 'A2_INSCR', "
	cQuery    +="COALESCE( a.Contato, '') AS 'A2_CONTATO', "
	cQuery    +="'005' AS 'A2_COND', "
	cQuery    +="COALESCE( a.eMail, '') AS 'A2_EMAIL', "
	cQuery    +="COALESCE( a.WebSite, '') AS 'A2_HPAGE', "
	cQuery    +="CASE WHEN a.CodSituacao IN (1,3) THEN 2 ELSE 1 END AS 'A2_MSBLQL', "
	cQuery    +="COALESCE( a.Complemento, '') AS 'A2_COMPL', "
	cQuery    +="COALESCE((SELECT M0_CODFIL from PROGET.microsiga.dbo.sigamat where codestabelecimento = a.CodTerceiro),'') AS 'A2_SIGA', "
	cQuery    +="COALESCE( cast(a.CODIBGE as varchar(15)), '') AS 'A2_IBGE' "
	cQuery    +="FROM PROGET.PROGET.dbo.Terceiro a WITH (NOLOCK) where "
	cQuery    +="a.CodTerceiro not in (select CAST(A2_PROGET AS INT) FROM MICROSIGA.SIGA.dbo.SA2010)

	
	
	memowrite("cadp001.SQL",cQuery)
	
	//EXECUTA QUERY
	TcQuery cQuery NEW ALIAS "QRY1"
	
	// Conta os registros da Query
	TcQuery "SELECT COUNT(*) AS TOTALREG FROM (" + cQuery + ") AS T" NEW ALIAS "QRYCONT"
	QRYCONT->(dbgotop())
	nReg := QRYCONT->TOTALREG
	QRYCONT->(dbclosearea())
	          
	          
	If nReg > 0
	
		while QRY1-> (!EOF())
			lMsErroAuto := .F.
		  	aVetor:={	{"A2_FILIAL", XFILIAL("SA2"),nil},;
		  	{"A2_PROGET", QRY1->A2_COD,nil},;   
		  	{"A2_SIGA", QRY1->A2_SIGA,nil},;
			{"A2_NOME", QRY1->A2_NOME,nil},;
			{"A2_NREDUZ", QRY1->A2_NREDUZ,nil},;
			{"A2_END", QRY1->A2_END,nil},;
			{"A2_NR_END", QRY1->A2_NR_END,nil},;
			{"A2_BAIRRO", QRY1->A2_BAIRRO,nil},;
			{"A2_MUN", QRY1->A2_MUN,nil},;
			{"A2_EST", QRY1->A2_EST,nil},;
			{"A2_ESTADO", QRY1->A2_ESTADO,nil},;
			{"A2_CEP", QRY1->A2_CEP,nil},;
			{"A2_CX_POST", QRY1->A2_CX_POST,nil},;
			{"A2_TIPO", QRY1->A2_TIPO,nil},;
			{"A2_CGC", QRY1->A2_CGC,nil},;
			{"A2_INSCR", QRY1->A2_INSCR,nil},;
			{"A2_PFISICA", QRY1->A2_PFISICA,nil},;
			{"A2_DDD", QRY1->A2_DDD,nil},;
			{"A2_TEL", QRY1->A2_TEL,nil},;
			{"A2_FAX", QRY1->A2_FAX,nil},;
			{"A2_CONTATO", QRY1->A2_CONTATO,nil},;
			{"A2_COND", QRY1->A2_COND,nil},;
			{"A2_EMAIL", QRY1->A2_EMAIL,nil},;
			{"A2_HPAGE", QRY1->A2_HPAGE,nil},; 
			{"A2_MSBLQL", "2",nil},; 
			{"A2_COMPL", QRY1->A2_COMPL,nil}}  
			
			//{"A2_IBGE", QRY1->A2_IBGE,nil},; VALIDAR DEPOIS
			
			MSExecAuto({|x,y| Mata020(x,y)},aVetor,3) //Inclusao
			IF lMsErroAuto
			    //	mostraerro()
				//qry1->A2_COD montar tabela com erro
					
   			cIns	:= " "
			cIns	+= " INSERT INTO DADOSTST.dbo.VALIDASB2 values('" + XFILIAL("SA2") +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_COD) + "', "      
			cIns	+= "'"+  alltrim(QRY1->A2_LOJA) +"', "      
			cIns	+= "'"+  alltrim(QRY1->A2_NOME) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_NREDUZ) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_END) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_NR_END) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_BAIRRO) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_MUN) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_EST) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_ESTADO) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_CEP) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_CX_POST) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_TIPO) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_CGC) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_INSCR) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_PFISICA) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_DDD) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_TEL) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_FAX) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_CONTATO) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_COND) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_EMAIL) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_HPAGE) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_COMPL) +"', "
			cIns	+= "'"+  alltrim(QRY1->A2_IBGE) + "') "        
			
			memowrite("cadp002.SQL",cIns)

			TcSQLExec(cIns)
	
			Endif
			QRY1->(dbskip())
		EndDo 
		
	   /*	aVetor:={	{"A2_FILIAL", "",nil},;
			{"A2_COD", "cu",nil},;
			{"A2_LOJA", "cu",nil},;
			{"A2_NOME", "alebas",nil},;
			{"A2_NREDUZ", "ale",nil},;
			{"A2_END", "Rua Penedao",nil},;
			{"A2_NR_END", "159",nil},;
			{"A2_BAIRRO", "Jd Alvorada",nil},;
			{"A2_MUN", "Sao Paulo",nil},;
			{"A2_EST", "SP",nil},;
			{"A2_ESTADO", "SP",nil},;
			{"A2_CEP", "04547-005",nil},;
			{"A2_CX_POST", "",nil},;
			{"A2_TIPO", "J",nil},;
			{"A2_CGC", "53928891000107",nil},;
			{"A2_PFISICA", "",nil},;
			{"A2_DDD", "11",nil},;
			{"A2_TEL", "55237660",nil},;
			{"A2_FAX", "",nil},;
			{"A2_INSCR", "111.177.014.111",nil},;
			{"A2_CONTATO", "bucetao",nil},;
			{"A2_COND", "005",nil},;
			{"A2_EMAIL", "alepetrucci@gmx.net",nil},;
			{"A2_HPAGE", "www.alebas.com",nil},;
			{"A2_MSBLQL", "2",nil},;
			{"A2_COMPL", "",nil}}
			
			MSExecAuto({|x,y| Mata020(x,y)},aVetor,3) //Inclusao
			IF lMsErroAuto
				mostraerro()
				//qry1->A2_COD montar tabela com erro
			Endif    */
		
	Endif
	
Return()