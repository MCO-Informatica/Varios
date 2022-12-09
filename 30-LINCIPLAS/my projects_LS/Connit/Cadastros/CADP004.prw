#INCLUDE "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADP004บAutor  ณAlebas         		 บ Data ณ  07/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIMPORTAวรO DO CADASTRO DE MATERIAIS                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LASELVA COMERCIO DE LIVROS E ARTIGOS DE CONVENINENCIA LTDA บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADP004()

Private aSays      := {}
Private aButtons   := {}
Private	nOpca      := 0
Private _cCadastro := "Importacao do Cadastro de Materiais"

AADD(aSays,"Este programa tem o objetivo de importar ")
AADD(aSays," o CADASTRO DE MATERIAIS do Sistema Proget para o Protheus.")
AADD(aSays,"maravilhoso sistema Microsiga. ")
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( _cCadastro, aSays, aButtons )
	
	If nOpcA == 1
		Processa({|| CadMAT() },"Cadastrando Materiais....")
	Endif
		
Return
	
Static Function Cadmat()

Local aVetor 		:= {}
Local cQuery 		:=" " 
Local cIns			:= " "
Local nHdl			:= 0					// Handle do arquivo de log de erros
Local cEOL			:= ""					// Variavel para caractere de CR + LF
Local _cLinha		:= ""
Local _cReferArq	:= "LOG" 
Local cDir			:= "\ale\"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
EndIf

If File(cDir+_cReferArq+".txt")
	Ferase(_cReferArq)						// Elimina arquivo, caso exista
Endif

nHdl := fCreate(cDir+_cReferArq+".txt")		// Cria arquivo txt de log de erros
	
If nHdl == -1								// Erro na criacao do arquivo
	MsgAlert("O arquivo de nome " + _cReferArq + " nao pode ser criado!","Atencao!")
Endif

lMsErroAuto := .F.
		
cQuery    ="SELECT " 
cQuery    +="'' AS 'B1_FILIAL', "
cQuery    +="CONVERT( VARCHAR(15), a.CodMaterial ) AS 'B1_COD', "
cQuery    +="COALESCE( a.Descricao, '') AS 'B1_DESC', "
cQuery    +="CASE WHEN CodTipo NOT IN ('03', '07') THEN COALESCE( a.Referencia, '123') ELSE '123' END AS 'B1_COMPDES', "
cQuery    +="'PA' AS 'B1_TIPO', "
cQuery    +="COALESCE( a.CodUnidade, 'UN') AS 'B1_UM', "
cQuery    +="'01' AS 'B1_LOCPAD', "
cQuery    +="dbo.get_bm(2,a.CodTipo)  AS 'B1_GRUPO', "
cQuery    +="COALESCE(Codassunto,'0100' ) AS 'B1_CODASS', "
cQuery    +="COALESCE( Codassunto, '0101' ) AS 'B1_CODSA', "
cQuery    +="'2' AS 'B1_MSBLQL', "
cQuery    +="CASE WHEN CodTipo IN ('02', '03', '04', '06', '07', '08' ) THEN '133' ELSE '002' END AS 'B1_TE', "
cQuery    +="CASE WHEN CodTipo IN ('02', '03', '04', '06', '07', '08' ) THEN '501' ELSE '502' END AS 'B1_TS', "
cQuery    +="1 AS 'B1_CONV', "
cQuery    +="'M' AS 'B1_TIPCONV', "
cQuery    +="CASE WHEN b.Preco <= 0 OR b.Preco IS NULL THEN 0 ELSE b.Preco END AS 'B1_PRV1', "
cQuery    +="CAST(COALESCE( ( SELECT TOP 1 CAST(YEAR(DTULTCOMPRA) AS VARCHAR(4)) + RIGHT('0'+CAST(MONTH(DTULTCOMPRA) AS VARCHAR(2)),2)+ RIGHT('0'+CAST(DAY(DTULTCOMPRA) AS VARCHAR(2)),2) "
cQuery    +="FROM PROGET.PROGET.dbo.normaestoque g WITH (NOLOCK) "
cQuery    +="WHERE g.CodMaterial = a.CodMaterial AND g.DTULTCOMPRA IS NOT NULL "
cQuery    +="ORDER BY g.DTULTCOMPRA DESC), '20070101' ) AS CHAR(8)) AS 'B1_UCOM', "
cQuery    +="COALESCE( ( SELECT TOP 1 g.PRULTCOMPRA "
cQuery    +="FROM PROGET.PROGET.dbo.normaestoque g WITH (NOLOCK) "
cQuery    +="WHERE g.CodMaterial = a.CodMaterial AND g.DTULTCOMPRA IS NOT NULL "
cQuery    +="ORDER BY g.DTULTCOMPRA DESC), 0 ) AS 'B1_UPRC', "
cQuery    +="dbo.get_bm(1,a.CodTipo) AS 'B1_CONTA', "
cQuery    +="(SELECT TOP 1 A2_COD  FROM DADOSTST.dbo.SA2010 WHERE RIGHT(A2_PROGET,5)=cast(c.CodTerceiro as varchar(15))) AS 'B1_PROC', "
cQuery    +="(SELECT TOP 1 A2_LOJA  FROM DADOSTST.dbo.SA2010 WHERE RIGHT(A2_PROGET,5)=cast(c.CodTerceiro as varchar(15))) AS 'B1_LOJPROC', "
cQuery    +="COALESCE(CAST(YEAR(DataAlteracao) AS VARCHAR(4)) + RIGHT('0'+CAST(MONTH(DataAlteracao) AS VARCHAR(2)),2)+ RIGHT('0'+CAST(DAY(DataAlteracao) AS VARCHAR(2)),2),'20010101') AS 'B1_UREV', "
cQuery    +="'N' AS 'B1_RASTRO', "
cQuery    +="'N' AS 'B1_MONO', "
cQuery    +="0 AS 'B1_PERINV', " 
cQuery	  +="COALESCE(e.Aliquota,0) as B1_ALIQICM, "
cQuery    +="CONVERT( VARCHAR(18), LTRIM(RTRIM( COALESCE( a.CodigoBarra, '123') ))) AS 'B1_CODBAR', "
cQuery    +="CASE WHEN dbo.get_bm(2,a.CodTipo)  IN ('0003', '0007') THEN CASE WHEN a.Referencia IS NOT NULL THEN CONVERT( VARCHAR(13), LTRIM(RTRIM(a.Referencia)) ) ELSE '123' END ELSE '123' END AS 'B1_ISBN', "
cQuery    +="CASE WHEN dbo.get_bm(2,a.CodTipo)  = '0015' THEN '1' ELSE '2' END AS 'B1_USAFEFO', "
cQuery    +="COALESCE((SELECT TOP 1 i.Z3_COD FROM DADOSTST.dbo.SZ3010 i WITH (NOLOCK) WHERE LTRIM(RTRIM(c.Autor)) = LTRIM(RTRIM(i.Z3_DESC)) COLLATE SQL_Latin1_General_CP1_CI_AS), '019242') AS 'B1_CODAUT', "
cQuery    +="RIGHT('000000'+CAST(Editora AS VARCHAR(15)),6) AS 'B1_CODEDIT', "
cQuery    +="dbo.get_bm(3,a.CodTipo)  AS 'B1_XCONTA', "
cQuery    +="CAST(YEAR(DataCadastramento) AS VARCHAR(4)) + RIGHT('0'+CAST(MONTH(DataCadastramento) AS VARCHAR(2)),2)+ RIGHT('0'+CAST(DAY(DataCadastramento) AS VARCHAR(2)),2) AS 'B1_DTCAD', "
cQuery    +="'' AS 'D_E_L_E_T_', "
cQuery    +="ROW_NUMBER() OVER(ORDER BY a.CodMaterial) AS 'R_E_C_N_O_', "
cQuery    +="0 AS 'R_E_C_D_E_L_', "
cQuery    +="COALESCE(5, 0) AS 'B1_PERIODI', "
cQuery    +="COALESCE(CAST(YEAR(DataEncalhe) AS VARCHAR(4)) + RIGHT('0'+CAST(MONTH(DataEncalhe) AS VARCHAR(2)),2)+ RIGHT('0'+CAST(DAY(DataEncalhe) AS VARCHAR(2)),2) ,'20000101') AS 'B1_ENCALHE' "
cQuery    +="from PROGET.PROGET.dbo.material a with(nolock) "
cQuery    +="inner join PROGET.PROGET.dbo.Precomaterial b with(nolock) on a.CodMaterial=b.CodMaterial  "
cQuery    +="inner join PROGET.PROGET.dbo.dadocomplementarmaterial c with(nolock) on a.CodMaterial=c.CodMaterial "
cQuery    +="left join  PROGET.PROGET.dbo.Aliquota e on c.SituacaoIcms=e.TipoAliquota and e.SiglaEstado='SP'and e.CodEstabelecimento=1"
cQuery    +="where a.Descricao NOT LIKE '%*INUTILIZA%' AND a.Descricao NOT LIKE '%*NAO U%'  " 
cQuery    +="AND a.Descricao NOT LIKE '%**INUTILIZA%' AND a.Descricao NOT LIKE '%** INUTILIZA%'  "
cQuery    +="AND a.Descricao <> '*COMENDO*' AND a.Descricao NOT LIKE '%*INVALIDO%' AND a.Descricao NOT LIKE '%* NAO U%'  "
cQuery    +="AND a.CodMaterial IS NOT NULL AND a.CodMaterial <> '' "
cQuery    +="and ltrim(rtrim(a.CodMaterial)) not in (select ltrim(rtrim(B1_COD))  COLLATE SQL_Latin1_General_CP1_CI_AS FROM MICROSIGA.DADOSTST.dbo.SB1010 with(nolock)) "
cQuery    +="and isnumeric(a.CodMaterial)=1 and b.CodTabela=1 and b.CodMoeda=1  AND a.CodTipo in ('03','07','50','09')  "

memowrite("cadp004mata010.SQL",cQuery)
	
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
			_cLinha := "Essa merda foi a ultima " + QRY1->B1_COD 
			_cLinha	+= cEOL
			fWrite(nHdl,_cLinha,Len(_cLinha))

			
			aVetor:={	{"B1_FILIAL", XFILIAL("SB1"),nil},;
		  	{"B1_COD", QRY1->B1_COD,nil},;
			{"B1_DESC", QRY1->B1_DESC,nil},;
			{"B1_COMPDES", QRY1->B1_COMPDES,nil},;
			{"B1_TIPO", QRY1->B1_TIPO,nil},;
			{"B1_UM", QRY1->B1_UM,nil},;
			{"B1_LOCPAD", QRY1->B1_LOCPAD,nil},;
			{"B1_GRUPO", QRY1->B1_GRUPO,nil},;
			{"B1_CODASS", QRY1->B1_CODASS,nil},;
			{"B1_CODSA", QRY1->B1_CODSA,nil},;
			{"B1_MSBLQL", QRY1->B1_MSBLQL,nil},;
			{"B1_TE", QRY1->B1_TE,nil},;
			{"B1_TS", QRY1->B1_TS,nil},;
			{"B1_CONV", QRY1->B1_CONV,nil},;
			{"B1_TIPCONV", QRY1->B1_TIPCONV,nil},;
			{"B1_PRV1", QRY1->B1_PRV1,nil},;
			{"B1_PRV2", QRY1->B1_PRV1,nil},; 
			{"B1_ORIGEM", "0",nil},;
			{"B1_UCOM", STOD(QRY1->B1_UCOM),nil},;
			{"B1_UPRC", QRY1->B1_UPRC,nil},;
			{"B1_CONTA", QRY1->B1_CONTA,nil},;
			{"B1_PROC", QRY1->B1_PROC,nil},;
			{"B1_LOJPROC", QRY1->B1_LOJPROC,nil},;
			{"B1_UREV", STOD(QRY1->B1_UREV),nil},;
			{"B1_RASTRO", QRY1->B1_RASTRO,nil},;
			{"B1_MONO", QRY1->B1_MONO,nil},; 
			{"B1_PERINV", QRY1->B1_PERINV,nil},;
			{"B1_CODBAR", QRY1->B1_CODBAR,nil},; 
			{"B1_ISBN", QRY1->B1_ISBN,nil},; 
			{"B1_USAFEFO", QRY1->B1_USAFEFO,nil},; 
			{"B1_CODAUT", QRY1->B1_CODAUT,nil},; 
			{"B1_CODEDIT", QRY1->B1_CODEDIT,nil},;
			{"B1_PICM", QRY1->B1_ALIQICM,nil},;  
			{"B1_XCONTA", QRY1->B1_XCONTA,nil},; 
			{"B1_ENCALHE", STOD(QRY1->B1_ENCALHE),nil},;
			{"B1_EDICAO", right(alltrim(QRY1->B1_COD),4),nil},;
			{"B1_PERIODI", QRY1->B1_PERIODI,nil}}
			 
		
			
  			MSExecAuto({|x,y| Mata010(x,y)},aVetor,3) //Inclusao
			IF lMsErroAuto
	
		   		mostraerro()
				
	   			cIns	:= " "
				cIns	+= " INSERT INTO DADOSTST.dbo.VALIDASB1 values('" + XFILIAL("SB1") +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_COD) + "', "   
				cIns	+= "'"+  alltrim(QRY1->B1_DESC) + "', "      
				cIns	+= "'"+  alltrim(QRY1->B1_COMPDES) +"', "      
				cIns	+= "'"+  alltrim(QRY1->B1_TIPO) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_UM) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_LOCPAD) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_GRUPO) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_CODASS) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_CODSA) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_MSBLQL) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_TE) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_TS) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_CONV) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_TIPCONV) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_PRV1) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_UCOM) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_UPRC) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_CONTA) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_PROC) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_UREV) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_RASTRO) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_MONO) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_PERINV) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_CODBAR) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_ISBN) +"', " 
				cIns	+= "'"+  alltrim(QRY1->B1_USAFEFO) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_CODAUT) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_CODEDIT) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_XCONTA) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_DTCAD) +"', "
				cIns	+= "'"+  alltrim(0) +"', "
				cIns	+= "'"+  alltrim(0) +"', "
				cIns	+= "'"+  alltrim(0) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_PERIODI) +"', "
				cIns	+= "'"+  alltrim(QRY1->B1_ENCALHE) + "') "        
			
				memowrite("cadp004INS.SQL",cIns)

				TcSQLExec(cIns)
		
			Endif
			QRY1->(dbskip())
	EndDo 
		
	Alert("Importacao concluida, Verifique a tabela de erros !!!")	
Endif

Return()               	