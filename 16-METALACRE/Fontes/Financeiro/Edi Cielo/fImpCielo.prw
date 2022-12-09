#include "protheus.ch"

#DEFINE CIE_IDPAY	001
#DEFINE CIE_DTVEN	002
#DEFINE CIE_VALOR	003
#DEFINE CIE_VLREA	004
#DEFINE CIE_REJEI	005
#DEFINE CIE_PREFI	006
#DEFINE CIE_TITUL	007
#DEFINE CIE_PARCE	008
#DEFINE CIE_CLIEN	009
#DEFINE CIE_LOJA	010
#DEFINE CIE_NOME	011
#DEFINE CIE_EMISS	012
#DEFINE CIE_VECTO	013
#DEFINE CIE_VLTIT	014
#DEFINE CIE_PEDWB	015
#DEFINE CIE_PEDID	016
#DEFINE CIE_SALDO	017
#DEFINE CIE_DTBAI	018
#DEFINE CIE_RECNO	019

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RelCAbc   บAutor  ณ Luiz     บ Data ณ  07/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rios Curva ABC Clientes บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MetaLacre - Protheus 11                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fImpCielo(aRelacao)
Local oReport
Private cPerg 	:= ''
	
	
If TRepInUse() //verifica se relatorios personalizaveis esta disponivel 
	oReport := ReportDef() 
	oReport:PrintDialog() 
EndIf 
	
Return 
    
 
Static Function ReportDef() 
	Local oReport 
	Local oSection1 	 
 
	oReport := TReport():New('EdiCielo',"Relatorio de Rela็ใo EDI Cielo x Titulos a Receber",'',{|oReport| PrintReport(oReport)},"Esta Rotina irแ imprimir o Relat๓rio Retorno EDI Cielo") 	
	oReport:SetTotalInLine(.T.) // Impressao do total geral das colunas somadas
	oReport:ShowFooter()            
	oReport:SetLandScape()    
	oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao
	
	oSection1 := TRSection():New(oReport,"Relat๓rio Edi Cielo x Financeiro",{}) 
	
	oSection1:SetTotalInLine(.T.) // Impressao do total geral das colunas somadas

	TRCell():New(oSection1,"_CIE_IDPAY"	    ,"   ","Id Trans"		   										,'@!'		, 20)
	TRCell():New(oSection1,"_CIE_DTVEN"	    ,"   ","Dt.Venda"		   										,PesqPict("SE1","E1_EMISSAO")		, TamSX3("E1_EMISSAO")[1])
	TRCell():New(oSection1,"_CIE_VALOR"	    ,"   ","Valor Venda"	   										,PesqPict("SE1","E1_VALOR")		, TamSX3("E1_VALOR")[1])
	TRCell():New(oSection1,"_CIE_VLREA"	    ,"   ","Valor Recebido" 										,PesqPict("SE1","E1_VALOR")		, TamSX3("E1_VALOR")[1])
	TRCell():New(oSection1,"_CIE_REJEI"	    ,"   ","Rej"				   									,'@!'		, 03)
//	TRCell():New(oSection1,"_CIE_PREFI"	    ,"   ","Pref"		   											,'@!'		, 03)
	TRCell():New(oSection1,"_CIE_TITUL"	    ,"   ","Titulo"		   											,'@!'		, 10)
//	TRCell():New(oSection1,"_CIE_PARCE"	    ,"   ","Par"		   											,'@!'		, 02)
	TRCell():New(oSection1,"_CIE_CLIEN"	    ,"   ","Cliente"		   										,'@!'		, 06)
	TRCell():New(oSection1,"_CIE_LOJA"	    ,"   ","Loja"		   											,'@!'		, 02)
	TRCell():New(oSection1,"_CIE_NOME"	    ,"   ","Nome Cliente"		   									,PesqPict("SA1","A1_NREDUZ")		, TamSX3("A1_NREDUZ")[1])
	TRCell():New(oSection1,"_CIE_EMISS"	    ,"   ","Emissao"		   										,PesqPict("SE1","E1_EMISSAO")		, TamSX3("E1_EMISSAO")[1])
	TRCell():New(oSection1,"_CIE_VECTO"	    ,"   ","Vencimento"		   										,PesqPict("SE1","E1_EMISSAO")		, TamSX3("E1_EMISSAO")[1])
	TRCell():New(oSection1,"_CIE_VLTIT"	    ,"   ","Vlr.Titulo"		   										,PesqPict("SE1","E1_VALOR")		, TamSX3("E1_VALOR")[1])
	TRCell():New(oSection1,"_CIE_PEDWB"	    ,"   ","Ped.Web"		   										,'@!'		, 10)
	TRCell():New(oSection1,"_CIE_PEDID"	    ,"   ","Ped.Int"		   										,'@!'		, 06)
	TRCell():New(oSection1,"_CIE_SALDO"	    ,"   ","Saldo"		   											,PesqPict("SE1","E1_VALOR")		, TamSX3("E1_VALOR")[1])
	TRCell():New(oSection1,"_CIE_DTBAI"	    ,"   ","Dt.Baixa"		   										,PesqPict("SE1","E1_EMISSAO")		, TamSX3("E1_EMISSAO")[1])
	TRCell():New(oSection1,"_CIE_RECNO"	    ,"   ","Rec"			   										,'9999999'		, 7)


   	oSection1:Cell("_CIE_IDPAY"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_DTVEN"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_VALOR"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_VLREA"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_REJEI"):lHeaderSize := .F.
//   	oSection1:Cell("_CIE_PREFI"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_TITUL"):lHeaderSize := .F.
//   	oSection1:Cell("_CIE_PARCE"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_CLIEN"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_LOJA" ):lHeaderSize := .F.
   	oSection1:Cell("_CIE_NOME" ):lHeaderSize := .F.
   	oSection1:Cell("_CIE_EMISS"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_VECTO"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_VLTIT"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_PEDWB"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_PEDID"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_SALDO"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_DTBAI"):lHeaderSize := .F.
   	oSection1:Cell("_CIE_RECNO"):lHeaderSize := .F.

   	oSection1:Cell("_CIE_IDPAY"):nSize := 25	
   	oSection1:Cell("_CIE_DTVEN"):nSize := 10
   	oSection1:Cell("_CIE_VALOR"):nSize := TamSX3("E1_VALOR")[1]
   	oSection1:Cell("_CIE_VLREA"):nSize := TamSX3("E1_VALOR")[1]
   	oSection1:Cell("_CIE_REJEI"):nSize := 3
//   	oSection1:Cell("_CIE_PREFI"):nSize := TamSX3("E1_PREFIXO")[1]
   	oSection1:Cell("_CIE_TITUL"):nSize := TamSX3("E1_NUM")[1]
//   	oSection1:Cell("_CIE_PARCE"):nSize := TamSX3("E1_PARCELA")[1]
   	oSection1:Cell("_CIE_CLIEN"):nSize := TamSX3("E1_CLIENTE")[1]
   	oSection1:Cell("_CIE_LOJA" ):nSize := TamSX3("E1_LOJA")[1]
   	oSection1:Cell("_CIE_NOME" ):nSize := 15
   	oSection1:Cell("_CIE_EMISS"):nSize := 10
   	oSection1:Cell("_CIE_VECTO"):nSize := 10
   	oSection1:Cell("_CIE_VLTIT"):nSize := TamSX3("E1_VALOR")[1]
   	oSection1:Cell("_CIE_PEDWB"):nSize := 10	
   	oSection1:Cell("_CIE_PEDID"):nSize := 10	
   	oSection1:Cell("_CIE_SALDO"):nSize := TamSX3("E1_VALOR")[1]
   	oSection1:Cell("_CIE_DTBAI"):nSize := 10
   	oSection1:Cell("_CIE_RECNO"):nSize := 10

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Criacao da Segunda Secao: Funcionario  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 

Return oReport 

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
 
Static Function PrintReport(oReport)
Local cQuery	    := ""
Local oSection1 := oReport:Section(1)

TRFunction():New(oSection1:Cell("_CIE_VALOR")	,NIL,"SUM"		,/*oBreak*/,"Total Venda",'@E 999,999,999.99'		,{|| oSection1:Cell("_CIE_VALOR"):GetValue(.T.) },.T.,.F.)
TRFunction():New(oSection1:Cell("_CIE_VLREA")	,NIL,"SUM"		,/*oBreak*/,"Total Recebido",'@E 999,999,999.99'		,{|| oSection1:Cell("_CIE_VLREA"):GetValue(.T.) },.T.,.F.)
TRFunction():New(oSection1:Cell("_CIE_VLTIT")	,NIL,"SUM"		,/*oBreak*/,"Total Titulos",'@E 999,999,999.99'		,{|| oSection1:Cell("_CIE_VLTIT"):GetValue(.T.) },.T.,.F.)
TRFunction():New(oSection1:Cell("_CIE_SALDO")	,NIL,"SUM"		,/*oBreak*/,"Total em Aberto",'@E 999,999,999.99'		,{|| oSection1:Cell("_CIE_SALDO"):GetValue(.T.) },.T.,.F.)

ProcRegua(Len(aRelacao))
For nVenda := 1 To Len(aRelacao)
	If oReport:Cancel() 
		Exit 
	EndIf            
	
	IncProc()
			   
	oSection1:Init()


   	oSection1:Cell("_CIE_IDPAY"):SetValue(aRelacao[nVenda,CIE_IDPAY])	
   	oSection1:Cell("_CIE_DTVEN"):SetValue(aRelacao[nVenda,CIE_DTVEN])	
   	oSection1:Cell("_CIE_VALOR"):SetValue(aRelacao[nVenda,CIE_VALOR])	
   	oSection1:Cell("_CIE_VLREA"):SetValue(aRelacao[nVenda,CIE_VLREA])	
   	oSection1:Cell("_CIE_REJEI"):SetValue(aRelacao[nVenda,CIE_REJEI])	
//   	oSection1:Cell("_CIE_PREFI"):SetValue(aRelacao[nVenda,CIE_PREFI])	
   	oSection1:Cell("_CIE_TITUL"):SetValue(aRelacao[nVenda,CIE_TITUL])	
//   	oSection1:Cell("_CIE_PARCE"):SetValue(aRelacao[nVenda,CIE_PARCE])	
   	oSection1:Cell("_CIE_CLIEN"):SetValue(aRelacao[nVenda,CIE_CLIEN])	
   	oSection1:Cell("_CIE_LOJA" ):SetValue(aRelacao[nVenda,CIE_LOJA])	
   	oSection1:Cell("_CIE_NOME" ):SetValue(aRelacao[nVenda,CIE_NOME])	
   	oSection1:Cell("_CIE_EMISS"):SetValue(aRelacao[nVenda,CIE_EMISS])	
   	oSection1:Cell("_CIE_VECTO"):SetValue(aRelacao[nVenda,CIE_VECTO])	
   	oSection1:Cell("_CIE_VLTIT"):SetValue(aRelacao[nVenda,CIE_VLTIT])	
   	oSection1:Cell("_CIE_PEDWB"):SetValue(aRelacao[nVenda,CIE_PEDWB])	
   	oSection1:Cell("_CIE_PEDID"):SetValue(aRelacao[nVenda,CIE_PEDID])	
   	oSection1:Cell("_CIE_SALDO"):SetValue(aRelacao[nVenda,CIE_SALDO])	
   	oSection1:Cell("_CIE_DTBAI"):SetValue(aRelacao[nVenda,CIE_DTBAI])	
   	oSection1:Cell("_CIE_RECNO"):SetValue(aRelacao[nVenda,CIE_RECNO])	

	//Imprime registros na secao 1 
	oSection1:PrintLine()		       
			
Next
oSection1:Finish()			
Return    

