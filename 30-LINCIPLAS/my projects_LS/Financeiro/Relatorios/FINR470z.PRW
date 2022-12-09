//#Include "FINR470.CH"
#include "PROTHEUS.CH"                                                                                                                              
#DEFINE REC_NAO_CONCILIADO 1                                 
#DEFINE REC_CONCILIADO		2
#DEFINE PAG_NAO_CONCILIADO 3
#DEFINE PAG_CONCILIADO		4

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR470z  ³ Autor ³ Adrianne Furtado      ³ Data ³ 10/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Extrato Banc rio.		 					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR470(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FINR470z()

If FindFunction("TRepInUse") .And. TRepInUse() 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()                         
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	oReport:PrintDialog()
Else
    Return FinR470R3() // Executa versão anterior do fonte
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Adrianne Furtado      ³ Data ³10/08/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport 
Local oBanco
Local oMovBanc           

Pergunte("FIN470",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//"EXTRATO BANCARIO"
//"Este programa ir  emitir o relat¢rio de movimenta‡”es" "banc rias em ordem de data. Poder  ser utilizado para""conferencia de extrato."
oReport := TReport():New("FINR470","FIN470","FIN470", {|oReport| ReportPrint(oReport)},"FINR470"+" "+"FIN470"+" "+"FIN470") 

oBanco := TRSection():New(oReport,"Dados Bancarios",{"SA6"},/*[Ordem]*/ )//"Dados Bancarios"
TRCell():New(oBanco,"A6_COD" 		,"SA6","BANCO",,23,.F.)//"BANCO"             
TRCell():New(oBanco,"A6_AGENCIA"	,"SA6","   AGENCIA ") //"   AGENCIA "
TRCell():New(oBanco,"A6_NUMCON"	,"SA6","   CONTA ")//"   CONTA "
TRCell():New(oBanco,"SALDOINI"	,		,"SALDO INICIAL",,20,,)//"SALDO INICIAL"

oMovBanc := TRSection():New(oBanco,"Movimentos Bancarios",{"SE5"})//"Movimentos Bancarios"
TRCell():New(oMovBanc,"E5_DTDISPO" ,"SE5","DATA"	,/*Picture*/,/*Tamanho*/,/*lPixel*/,) //"DATA"
TRCell():New(oMovBanc,"E5_HISTOR"	,"SE5","OPERACAO"	,,32,.F.,{|| SubStr(E5_HISTOR,1,30)})//"OPERACAO"
TRCell():New(oMovBanc,"E5_NUMCHEQ"	,"SE5","DOCUMENTO"	,,19,.F.,{|| If(Len(Alltrim(E5_DOCUMEN))+Len(Alltrim(E5_NUMCHEQ))<=19,;  //"DOCUMENTO"
																		Alltrim(E5_DOCUMEN) +if(!empty(Alltrim(E5_DOCUMEN)),"-"," ") + Alltrim(E5_NUMCHEQ ),;
																		If(Empty(E5_NUMCHEQ),E5_DOCUMEN,E5_NUMCHEQ))})
TRCell():New(oMovBanc,"PREFIXO/TITULO"	,"SE5","PREFIXO/TITULO"	,,,,{|| E5_PREFIXO+If(Empty(E5_PREFIXO)," ","-")+E5_NUMERO+; //"PREFIXO/TITULO"
																	   	If(Empty(E5_PARCELA)," ","-")+E5_PARCELA})  							 
TRCell():New(oMovBanc,"E5_VALOR-ENTRAD","SE5","ENTRADAS"	,,17,.F.,/*{|| If(E5_RECPAG == "R", Round(xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par06,SE5->E5_DATA,nMoeda+1,,nTxMoedBc),nMoeda), 0)}*/)//"ENTRADAS"
TRCell():New(oMovBanc,"E5_VALOR-SAIDA" ,"SE5","SAIDAS"	,,17,.F.,/*{|| If(E5_RECPAG == "P", Round(xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par06,SE5->E5_DATA,nMoeda+1,,nTxMoedBc),nMoeda), 0)}*/)//"SAIDAS"
TRCell():New(oMovBanc,"SALDO ATUAL"		,"SE5","SALDO ATUAL"	,,18,.F.,{|| nSaldoAtu})//"SALDO ATUAL"

oTotal := TRSection():New(oMovBanc,"Totais",{"SE5"},/*[Ordem]*/ )//"Totais"

TRCell():New(oTotal,"DESCRICAO",,"DESCRICAO" ,,30,,)//"DESCRICAO"
TRCell():New(oTotal,"NAOCONC"  ,,"NAO CONCILIADOS" ,,20,,)//"NAO CONCILIADOS" 
TRCell():New(oTotal,"CONC"		 ,,"CONCILIADOS" ,,20,,)//"CONCILIADOS"
TRCell():New(oTotal,"TOTAL" 	 ,,"TOTAL" ,,20,,)//"TOTAL"

oTotal:SetLeftMargin(38)

Return(oReport)       

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Adrianne Furtado      ³ Data ³27.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local oBanco	:= oReport:Section(1)
Local oMovBanc	:= oReport:Section(1):Section(1)    
Local oTotal	:= oReport:Section(1):Section(1):Section(1)
Local cAlias
Local lAllFil	:= .F.
Local cChave	:= ""
Local cAliasSA6	:= "SA6"
Local cAliasSE5	:= "SE5"
Local cSql1:= cSql2	:= ""
Local nMoeda	:= GetMv("MV_CENT"+(IIF(mv_par06 > 1 , STR(mv_par06,1),"")))            
LOCAL lSpbInUse	:= SpbInUse()        
Local nSaldoAtu	:= 0    
Local nMoedaBco	:= 1
Local cTabela14	:= ""   
Local nCol		:= 0      
Local aRecon 	:= {}     
Local nTotEnt	:= 0 
Local nTotSaida	:= 0    
Local nLimCred	:= 0     
Local nRecebNCon:= 0
Local nRecebConc:= 0   
Local cPictVlr	:=	tm(SE5->E5_VALOR,15,nMoeda)
Local nX
Local aTotais := {}
Local nTxMoedBc

#IFNDEF TOP
	Local cCondicao := ""
	Local cFiltSE5 := oReport:Section(1):GetAdvplExp("SE5")
#ENDIF                       

Pergunte( "FIN470", .F. )
AAdd( aRecon, {0,0,0,0} )   

dbSelectArea("SA6")
dbSetOrder(1)
IF !(dbSeek(xFilial("SA6")+mv_par01+mv_par02+mv_par03))
	Help(" ",1,"BCONOEXIST")
	Return
EndIF
If cPaisLoc	#	"BRA"
	nMoedaBco	:=	Max(A6_MOEDA,1)
Endif

// Carrega a tabela 14
SX5->(DbSetOrder(1))
SX5->(MsSeek(xFilial("SX5")+"14"))
While SX5->(!Eof()) .And. SX5->X5_TABELA == "14"
	cTabela14 += (Alltrim(SX5->X5_CHAVE) + "/")
	SX5->(DbSkip())
End	
cTabela14 += If(cPaisLoc=="BRA","","/$ ")         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Saldo de Partida 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE8")
dbSetOrder(1)			
dbSeek(mv_par11+mv_par01+mv_par02+mv_par03+Dtos(mv_par04),.T.)   // filial + banco + agencia + conta
dbSkip(-1)

IF E8_FILIAL != mv_par11 .Or. E8_BANCO!=mv_par01 .or. E8_AGENCIA!=mv_par02 .or. E8_CONTA!=mv_par03 .or. BOF() .or. EOF()
	nSaldoAtu:=0
	nSaldoIni:=0
Else
	If mv_par07 == 1  //Todos
		nSaldoAtu:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
		nSaldoIni:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
	ElseIf mv_par07 == 2 //Conciliados
		nSaldoAtu:=Round(xMoeda(E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
		nSaldoIni:=Round(xMoeda(E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
	ElseIf mv_par07 == 3	//Nao Conciliados
		nSaldoAtu:=Round(xMoeda(E8_SALATUA-E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
		nSaldoIni:=Round(xMoeda(E8_SALATUA-E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
	Endif	
Endif

If Empty(xFilial( "SA6")) .and. !Empty(xFilial("SE5"))
	cChave	:= "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
	lAllFil:= .T.
Else
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP

	cAlias := GetNextAlias()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBanco:BeginQuery()	     
	
	If	lAllFil
		cOrder  := "%E5_DTDISPO,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ%"
	Else
		cSql1	:=	"E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
		cOrder  := "%E5_FILIAL,E5_DTDISPO,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ%"
	EndIf           
	If lSpbInuse	                                                
		cSql1	+=	" E5_DTDISPO >=  '"     + DTOS(mv_par04) + "' AND"
		cSql1	+=	" ((E5_DTDISPO <= '"+ DTOS(mv_par05) + "') OR "
		cSql1	+=	"  (E5_DTDISPO >= '"+ DTOS(mv_par05) + "' AND "
		cSql1	+=	"  (E5_DATA    >= '"+ DTOS(mv_par04) + "' AND " 
		cSql1	+=	"   E5_DATA    <= '"+ DTOS(mv_par05) + "'))) AND"			
	Else			                                  
		cSql1	+=	" E5_DTDISPO >= '" + DTOS(mv_par04) + "' AND"
		cSql1	+=	" E5_DTDISPO <= '" + DTOS(mv_par05) + "' AND"
	EndIf                           
	If mv_par07 == 2
		cSql1	+=	" E5_RECONC <> ' ' AND "
	ElseIf mv_par07 == 3
		cSql1	+=	" E5_RECONC = ' ' AND " 
	EndIf

	cSql1 := "%"+cSql1+"%"
	
	BeginSql Alias cAlias  
	Select	E5_DTDISPO,	E5_HISTOR,	E5_NUMCHEQ,	E5_DOCUMEN, E5_PREFIXO, E5_NUMERO, E5_PARCELA,
			E5_RECPAG, 	E5_VALOR, 	E5_MOEDA, 	E5_CLIFOR, 	E5_LOJA, 	E5_RECONC,
			A6_FILIAL, 	A6_COD, 	A6_NREDUZ, 	A6_AGENCIA, A6_NUMCON, A6_LIMCRED, E5_DATA
	FROM 	%table:SE5% SE5
			LEFT JOIN %table:SA6% SA6 ON
			(E5_BANCO 	= A6_COD AND
			E5_AGENCIA	= A6_AGENCIA AND
			E5_CONTA 	= A6_NUMCON) 
	WHERE 	%Exp:cSql1%     
			A6_FILIAL 	= %xFilial:SA6% AND
			E5_BANCO 	= %Exp:mv_par01% AND
			E5_AGENCIA 	= %Exp:mv_par02% AND
			E5_CONTA 	= %Exp:mv_par03% AND		
			E5_TIPODOC NOT IN ('DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','BA') AND
			NOT(E5_MOEDA IN('C1/C2/C3/C4/C5/CH') AND E5_NUMCHEQ = '               ' AND (E5_TIPODOC NOT IN('TR#TE'))) AND			
			NOT(E5_TIPODOC IN('TR/TE') AND ((E5_NUMCHEQ BETWEEN '*              ' AND '*ZZZZZZZZZZZZZZ') OR (E5_DOCUMEN BETWEEN '*                ' AND '*ZZZZZZZZZZZZZZZZ' ))) AND
			NOT(E5_TIPODOC IN('TR/TE') AND E5_NUMERO = '      ' AND E5_MOEDA NOT IN(%Exp:cTabela14%)) AND
			E5_SITUACA <> 'C' AND
			E5_VALOR   <> 0 AND
			NOT(E5_NUMCHEQ BETWEEN '*              ' AND '*ZZZZZZZZZZZZZZ') AND//NOT LIKE '%*' AND
			(E5_VENCTO <= %Exp:DTOS(mv_par05)% OR E5_VENCTO <= E5_DATA) AND 
			SE5.%notDel% AND
			SA6.%notDel%
	ORDER BY %exp:cOrder%			
	EndSql               
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBanco:EndQuery(/*Array com os parametros do tipo Range*/)

	oMovBanc:SetParentQuery()

	cAliasSA6	:= cAlias
	cAliasSE5 	:= cAlias
#ELSE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao Advpl                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbSelectArea("SE5")
	DbSetOrder(1)

	MakeAdvplExpr(oReport:uParam)
                   
	If	lAllFil
		cOrder  := "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
	Else
		cOrder  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
		cCondicao := 'E5_FILIAL == "' + xFilial("SE5")+'" .And.'
	EndIf           
	If lSpbInuse	                                                
		cCondicao	+=	" ((DTOS(E5_DTDISPO) <= '"+ DTOS(mv_par05) + "') .OR. "
		cCondicao	+=	"  (DTOS(E5_DTDISPO) >= '"+ DTOS(mv_par05) + "' .And. "
		cCondicao	+=	"  (DTOS(E5_DATA)    >= '"+ DTOS(mv_par04) + "' .And. " 
		cCondicao	+=	"   DTOS(E5_DATA)    <= '"+ DTOS(mv_par05) + "'))) .And. "			
	EndIf 
	cCondicao += 'DTOS(E5_DTDISPO) >= "' + DTOS(mv_par04) + '" .And. '
	cCondicao += 'DTOS(E5_DTDISPO) <= "' + DTOS(mv_par05) + '" .And. '
	cCondicao += 'E5_BANCO   == "' + mv_par01 + '" .And. '
	cCondicao += 'E5_AGENCIA == "' + mv_par02 + '" .And. '
	cCondicao += 'E5_CONTA   == "' + mv_par03 + '" .And. '
	cCondicao += 'E5_SITUACA <> "C" .And. '   //Cancelado
	cCondicao += 'E5_VALOR   <> 0 .And. '  
	cCondicao += '!(E5_TIPODOC $ "DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL/BA") .And. '  
	cCondicao += '!(E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .And. E5_NUMCHEQ = "               " .And. !(E5_TIPODOC $ "TR#TE")) .And.'
	cCondicao += '(DTOS(E5_VENCTO) <= "' + DTOS(mv_par05) + '".Or. E5_VENCTO <= E5_DATA)'
	
	//Adiciona filtro do usuário
	If !Empty(cFiltSE5)
		cCondicao += ' .And. ' + cFiltSE5
   EndIf
                    
	oMovBanc:SetFilter( cCondicao, cOrder )

	oMovBanc:SetRelation( {|| xFilial((cAliasSE5))+(cAliasSA6)->(A6_COD+A6_AGENCIA+A6_NUMCON)},cAliasSA6,1,.T.)
	oMovBanc:SetParentFilter( {|cParam| (cAliasSE5)->(E5_BANCO+E5_AGENCIA+E5_CONTA) == cParam}, { || (cAliasSA6)->(A6_COD+A6_AGENCIA+A6_NUMCON) } )
                               
#ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMovBanc:SetMeter((cAliasSE5)->(LastRec()))
oReport:SetTitle(OemToAnsi("EXTRATO BANCARIO ENTRE ")+DTOC(mv_par04) + " e " +Dtoc(mv_par05))//"EXTRATO BANCARIO ENTRE "
oMovBanc:Cell("E5_VALOR-ENTRAD"	):SetPicture("@Z"+cPictVlr)
oMovBanc:Cell("E5_VALOR-SAIDA"	):SetPicture("@Z"+cPictVlr)
oMovBanc:Cell("SALDO ATUAL"		):SetPicture(tm((cAliasSE5)->E5_VALOR,16,nMoeda))
oMovBanc:Cell("SALDO ATUAL"		):SetBlock({|| nSaldoAtu += Round(xMoeda((cAliasSE5)->E5_VALOR,nMoedaBco,mv_par06,(cAliasSE5)->E5_DATA,nMoeda+1,,nTxMoedBc),nMoeda)*(If((cAliasSE5)->E5_RECPAG == 'R',1,-1)) })
oMovBanc:Cell("E5_VALOR-ENTRAD"	):SetHeaderAlign("RIGH")
oMovBanc:Cell("E5_VALOR-SAIDA"	):SetHeaderAlign("RIGH")
oMovBanc:Cell("SALDO ATUAL"		):SetHeaderAlign("RIGH")
oMovBanc:Cell("E5_VALOR-ENTRAD"  ):SetBlock({|| If((cAliasSE5)->E5_RECPAG == "R", Round(xMoeda((cAliasSE5)->E5_VALOR,nMoedaBco,mv_par06,(cAliasSE5)->E5_DATA,nMoeda+1,,nTxMoedBc),nMoeda), 0)})
oMovBanc:Cell("E5_VALOR-SAIDA"   ):SetBlock({|| If((cAliasSE5)->E5_RECPAG == "P", Round(xMoeda((cAliasSE5)->E5_VALOR,nMoedaBco,mv_par06,(cAliasSE5)->E5_DATA,nMoeda+1,,nTxMoedBc),nMoeda), 0)})
oBanco:SetLineStyle()

nLimCred := (cAliasSA6)->(A6_LIMCRED)

oBanco:Init()         

oBanco:Cell("A6_COD"):SetBlock( {|| (cAliasSA6)->A6_COD +" - "+AllTrim((cAliasSA6)->A6_NREDUZ)} )
oBanco:Cell("SALDOINI"):SetBlock( { || Transform(nSaldoIni,tm(nSaldoIni,16,nMoeda)) } )

oBanco:Cell("SALDOINI"):SetHeaderAlign("RIGH")
oBanco:Cell("SALDOINI"):SetAlign("RIGH")

While !oReport:Cancel() .And. (cAliasSE5)->(!Eof())  
     
	If oReport:Cancel()
		Exit
	EndIf	

	If oBanco:Cancel()
		Exit
	EndIf
	
	lFirst := .T.

	oBanco:PrintLine()
	oMovBanc:Init()               
	While !oReport:Cancel() .And. !(cAliasSE5)->(Eof())
		If oReport:Cancel()
			Exit
		EndIf               
		#IFNDEF TOP            
		If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
			If !(E5_MOEDA $ cTabela14)
				dbSkip()
				Loop
			Endif
		Endif
		If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" .or. Substr(E5_DOCUMEN,1,1) == "*" )
			dbSkip()
			Loop
		Endif
		If !Fr470Skip(mv_par01,mv_par02,mv_par03)
			(cAliasSE5)->(dbSkip())
			Loop
		EndIf	
		#ENDIF
 
		If SE5->(FieldPos('E5_TXMOEDA')) > 0 .And.  SE5->E5_TXMOEDA > 0
			nTxMoedBc := SE5->E5_TXMOEDA	
		ElseIf cPaisLoc=="BRA"  .Or. cPaisLoc<>"BRA" .And. (Empty(E5_MOEDA) .Or. (!Empty(E5_MOEDA).And.Val(E5_MOEDA)==1) )
			nTxMoedBc :=SE5->E5_VALOR/SE5->E5_VLMOED2
		Else
			nTxMoedBc :=E5_VLMOED2/E5_VALOR
		Endif
		oMovBanc:PrintLine()  
		oMovBanc:IncMeter()		          

		If Empty( E5_RECONC ) .AND. E5_RECPAG == "R"
			aRecon[1][REC_NAO_CONCILIADO] += Round(xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par06,SE5->E5_DATA,nMoeda+1,,nTxMoedBc),nMoeda)
		ElseIf E5_RECPAG == "R"
			aRecon[1][REC_CONCILIADO] += Round(xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par06,SE5->E5_DATA,nMoeda+1,,nTxMoedBc),nMoeda)
		ElseIf Empty( E5_RECONC ) .AND. E5_RECPAG == "P"
			aRecon[1][PAG_NAO_CONCILIADO] += Round(xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par06,SE5->E5_DATA,nMoeda+1,,nTxMoedBc),nMoeda)
		ElseIf E5_RECPAG == "P"
			aRecon[1][PAG_CONCILIADO] += Round(xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par06,SE5->E5_DATA,nMoeda+1,,nTxMoedBc),nMoeda)
		EndIf

		(cAliasSE5)->(dbSkip())
	EndDo       
	oMovBanc:Finish()        
	oReport:SkipLine()
EndDo
oBanco:Finish()    

AADD( aTotais ,{"SALDO INICIAL...........: ",,,nSaldoIni})//"SALDO INICIAL...........: "
AADD( aTotais ,{"ENTRADAS NO PERIODO.....: ",aRecon[1][REC_NAO_CONCILIADO],aRecon[1][REC_CONCILIADO],aRecon[1][REC_NAO_CONCILIADO] +  aRecon[1][REC_CONCILIADO]})//"ENTRADAS NO PERIODO.....: "
AADD( aTotais ,{"SAIDAS NO PERIODO ......: ",aRecon[1][PAG_NAO_CONCILIADO],aRecon[1][PAG_CONCILIADO],aRecon[1][PAG_NAO_CONCILIADO] +  aRecon[1][PAG_CONCILIADO] })//"SAIDAS NO PERIODO ......: "
AADD( aTotais ,{"LIMITE DE CREDITO.......: ",,,nLimCred})//"LIMITE DE CREDITO.......: "
AADD( aTotais ,{"SALDO ATUAL ............: ",,,nSaldoAtu})//"SALDO ATUAL ............: "

oTotal:Init()

oTotal:Cell("DESCRICAO"):HideHeader()
oTotal:Cell("NAOCONC"):SetHeaderAlign("RIGH")
oTotal:Cell("NAOCONC"):SetAlign("RIGH")
oTotal:Cell("CONC"):SetHeaderAlign("RIGH")
oTotal:Cell("CONC"):SetAlign("RIGH")
oTotal:Cell("TOTAL"):SetHeaderAlign("RIGH")
oTotal:Cell("TOTAL"):SetAlign("RIGH")

For nX := 1 to 5
	oTotal:Cell("DESCRICAO"):SetBlock( { || aTotais[nX][1] } )
	oTotal:Cell("NAOCONC")	:SetBlock( { || If(nX == 2 .Or. nX == 3,Transform(aTotais[nX][2],tm(aTotais[nX][2],16,nMoeda)),"")} )
	oTotal:Cell("CONC") 		:SetBlock( { || If(nX == 2 .Or. nX == 3,Transform(aTotais[nX][3],tm(aTotais[nX][3],16,nMoeda)),"")} )
	oTotal:Cell("TOTAL")		:SetBlock( { || Transform(aTotais[nX][4],tm(aTotais[nX][4],16,nMoeda))} )
	If nX == 2 .Or. nX == 5
		oReport:SkipLine()
	EndIf
	oTotal:PrintLine()
Next

oTotal:Finish()

Return NIL          




//------------------------------------------------------- R3 ------------------------------------------------------------------------




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINR470	³ Autor ³ Wagner Xavier 		³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extrato Banc rio. 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR470(void)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function FinR470R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1 := "Este programa ir  emitir o relat¢rio de movimentacoes"  //"Este programa ir  emitir o relat¢rio de movimenta‡”es"
LOCAL cDesc2 := "banc rias em ordem de data. Poder  ser utilizado para"  //"banc rias em ordem de data. Poder  ser utilizado para"
LOCAL cDesc3 := "conferencia de extrato."  //"conferencia de extrato."
LOCAL cString:="SE5"
LOCAL Tamanho:="M"

PRIVATE titulo:=OemToAnsi("Extrato Bancario")  //"Extrato Bancario"
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="FINR470"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg	 :="FIN470"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN470",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								 ³
//³ mv_par01				// Banco 										 ³
//³ mv_par02				// Agencia										 ³
//³ mv_par03				// Conta 										 ³
//³ mv_par04				// a partir de 								 ³
//³ mv_par05				// ate											 ³
//³ mv_par06				// Qual Moeda									 ³
//³ mv_par07				// Demonstra Todos/Conciliados/Nao Conc.³
//³ mv_par08				// Linhas por Pagina  ?			    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT 							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FINR470"            //Nome Default do relatorio em Disco
WnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho,"")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao REPORTINI substituir as variaveis.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa470Imp(@lEnd,wnRel,cString)},titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA470IMP ³ Autor ³ Wagner Xavier 		³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extrato Banc rio. 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA470Imp(lEnd,wnRel,cString)
LOCAL CbCont,CbTxt
LOCAL tamanho:="M"
LOCAL cBanco,cNomeBanco,cAgencia,cConta
LOCAL nSaldoAtu:=0,nTipo,nSaldoIni:=0
LOCAL cDOC
LOCAL cFil	  :=""
LOCAL cChave
LOCAL cIndex
LOCAL aRecon := {}
Local nTxMoeda := 1
Local nValor := 0
Local aStru 	:= SE5->(dbStruct())
#IFDEF TOP
	Local ni
#ENDIF	
Local nMoeda	:= GetMv("MV_CENT"+(IIF(mv_par06 > 1 , STR(mv_par06,1),"")))
Local nMoedaBco:=	1
LOCAL nSalIniStr := 0
LOCAL nSalIniCip := 0
LOCAL nSalIniComp := 0
LOCAL nSalStr := 0
LOCAL nSalCip := 0    
LOCAL nSalComp := 0
LOCAL lSpbInUse := SpbInUse()
Local cFilterUser
Local cTabela14 := ""
Local nLin	:= 55
Local lCxLoja := GetNewPar("MV_CXLJFIN",.F.)
Local cChaveSQL

AAdd( aRecon, {0,0,0,0} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCondWhile, lAllFil :=.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1

dbSelectArea("SA6")
dbSetOrder(1)
IF !(dbSeek(xFilial("SA6")+mv_par01+mv_par02+mv_par03))
	Help(" ",1,"BCONOEXIST")
	Return
EndIF
nLin		:=  mv_par08
cBanco		:= A6_COD
cNomeBanco	:= A6_NREDUZ
cAgencia	:= A6_AGENCIA
cConta		:= A6_NUMCON
nLimCred	:= A6_LIMCRED
If cPaisLoc	#	"BRA"
	nMoedaBco	:=	Max(A6_MOEDA,1)
Endif
// Carrega a tabela 14
SX5->(DbSetOrder(1))
SX5->(MsSeek(xFilial("SX5")+"14"))
While SX5->(!Eof()) .And. SX5->X5_TABELA == "14"
	cTabela14 += (Alltrim(SX5->X5_CHAVE) + "/")
	SX5->(DbSkip())
End	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi("EXTRATO BANCARIO ENTRE ")+DTOC(mv_par04) + " e " +Dtoc(mv_par05)  //"EXTRATO BANCARIO ENTRE "
cabec1 := OemToAnsi("BANCO ")+ cBanco +" - " + ALLTRIM(cNomeBanco) + OemToAnsi("   AGENCIA ")+ cAgencia + OemToAnsi("   CONTA ")+ cConta  //"BANCO "###"   AGENCIA "###"   CONTA "
cabec2 := OemToAnsi("DATA     OPERACAO                          DOCUMENTO         PREFIXO/TITULO          ENTRADAS           SAIDAS         SALDO ATUAL")  //"DATA     OPERACAO                          DOCUMENTO         PREFIXO/TITULO          ENTRADAS           SAIDAS         SALDO ATUAL"
nTipo  :=IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Saldo de Partida 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE8")
dbSetOrder(1)
dbSeek( mv_par11+cBanco+cAgencia+cConta+Dtos(mv_par04),.T.)
dbSkip(-1)

IF E8_FILIAL != mv_par11 .Or. E8_BANCO!=cBanco .or. E8_AGENCIA!=cAgencia .or. E8_CONTA!=cConta .or. BOF() .or. EOF()
	nSaldoAtu:=0
	nSaldoIni:=0
Else
	If mv_par07 == 1  //Todos
		nSaldoAtu:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
		nSaldoIni:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
	ElseIf mv_par07 == 2 //Conciliados
		nSaldoAtu:=Round(xMoeda(E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
		nSaldoIni:=Round(xMoeda(E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
	ElseIf mv_par07 == 3	//Nao Conciliados
		nSaldoAtu:=Round(xMoeda(E8_SALATUA-E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
		nSaldoIni:=Round(xMoeda(E8_SALATUA-E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
	Endif	
Endif
If lSpbInUse
	nSalIniStr := 0
	nSalIniCip := 0
	nSalIniComp := 0
Endif		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra o arquivo por tipo e vencimento						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(xFilial( "SA6")) .and. !Empty(xFilial("SE5"))
	cChave	:= "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
	lAllFil:= .T.
Else
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
EndIf

#IFNDEF TOP	
	dbSelectArea("SE5")
	dbSetOrder(1)
	cIndex	:= CriaTrab(nil,.f.)
	dbSelectArea("SE5")
	IndRegua("SE5",cIndex,cChave,,Nil,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
	nIndex	:= RetIndex("SE5")
	dbSetIndex(cIndex+OrdBagExt())
	dbSetOrder(nIndex+1)
	cFil:= Iif(lAllFil,"",xFilial("SE5"))
	dbSeek(cFil+DtoS(mv_par04),.T.)
#ELSE
	If TcSrvType() == "AS/400"
		dbSelectArea("SE5")
		dbSetOrder(1)
		cIndex	:= CriaTrab(nil,.f.)
		dbSelectArea("SE5")
		IndRegua("SE5",cIndex,cChave,,Nil,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
		nIndex	:= RetIndex("SE5")
		dbSetOrder(nIndex+1)
		cFil:= Iif(lAllFil,"",xFilial("SE5"))
		dbSeek(cFil+DtoS(mv_par04),.T.)
	EndIf	
#ENDIF

SetRegua(RecCount())

#IFNDEF TOP
	If  lAllFil
		cCondWhile := "!Eof() .And. E5_DTDISPO <= mv_par05"
	Else
		cCondWhile := "!Eof() .And. E5_FILIAL == xFilial('SE5') .And. E5_DTDISPO <= mv_par05"
	EndIf
#ELSE
	If TcSrvType() != "AS/400"
		DbSelectArea("SE5")
		DbSetOrder(1)
		cCondWhile := " !Eof() "
		If	lAllFil
			cChaveSQL  := "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+R_E_C_N_O_"
		Else
			cChaveSQL  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+R_E_C_N_O_"
		EndIf
		cOrder := SqlOrder(cChaveSQL)
		cQuery := "SELECT * "
		cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
		If !lAllFil
			cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
		EndIf	
		cQuery += " D_E_L_E_T_ <> '*' "
		cQuery += " AND E5_DTDISPO >=  '"     + DTOS(mv_par04) + "'"
		If lSpbInuse
			cQuery += " AND ((E5_DTDISPO <=  '"+ DTOS(mv_par05) + "') OR "
			cQuery += " (E5_DTDISPO >=  '"     + DTOS(mv_par05) + "' AND "
		   cQuery += " (E5_DATA >=  '"  		  + DTOS(mv_par04) + "' AND " 
			cQuery += "  E5_DATA <=  '"     	  + DTOS(mv_par05) + "')))"			
		Else			
			cQuery += " AND E5_DTDISPO <=  '"     + DTOS(mv_par05) + "'"
		Endif
		cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','BA') "
		cQuery += " AND E5_BANCO = '"   + cBanco   + "'"
		cQuery += " AND E5_AGENCIA = '" + cAgencia + "'"
		cQuery += " AND E5_CONTA = '"   + cConta   + "'"
		cQuery += " AND E5_SITUACA <> 'C' "
		cQuery += " AND E5_VALOR <> 0 "
		cQuery += " AND E5_NUMCHEQ NOT LIKE '%*' "
		cQuery += " AND (E5_VENCTO <= '" + DTOS(mv_par05)  + "'" 
		cQuery += " OR E5_VENCTO <= E5_DATA) " 
		If mv_par07 == 2
			cQuery += " AND E5_RECONC <> ' ' "
		ElseIf mv_par07 == 3
			cQuery += " AND E5_RECONC = ' ' " 
		EndIf

		cQuery += " ORDER BY " + cOrder
	
		cQuery := ChangeQuery(cQuery)

		dbSelectAre("SE5")
		dbCloseArea()

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .T., .T.)
	
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	Else		// Se TOP-AS400
		If lAllFil
			cCondWhile := "!Eof() .And. E5_DTDISPO <= mv_par05"
		Else
			cCondWhile := "!Eof() .And. E5_FILIAL == xFilial('SE5') .And. E5_DTDISPO <= mv_par05"
		EndIf
	EndIf
#ENDIF

// Monta arquivo de trabalho (apenas quando usa SPB)
If lSpbInUse
	dbSelectArea("SE5")
	cNomeArq:= CriaTrab("",.F.)
	cIndex  := cNomeArq
	AAdd( aStru, {"E5_BLOQ"	,"C", 01, 0} )
	dbCreate( cNomeArq, aStru )
	USE &cNomeArq	Alias Trb  NEW
	dbSelectArea("TRB")
	IndRegua("TRB",cIndex,cChave,,,"Selecionando Registros...") //"Selecionando Registros..."
	dbSetIndex( cNomeArq +OrdBagExt())
	Fr470SPB(cChave, aStru)
Endif

//Filtro do usuario
cFilterUser:=aReturn[7]

While &(cCondWhile)

	IF lEnd
		@PROW()+1,0 PSAY OemToAnsi("Cancelado pelo operador")  //"Cancelado pelo operador"
		EXIT
	Endif
	
	IncRegua()
	
	#IFNDEF TOP
		If !Fr470Skip(cBanco,cAgencia,cConta)
			dbSkip()
			Loop
		EndIf	
	#ELSE
		If TcSrvType() == "AS/400"
			If !Fr470Skip(cBanco,cAgencia,cConta)
				dbSkip()
				Loop
			EndIf	
		EndIf
	#ENDIF		

	IF E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Na transferencia somente considera nestes numerarios 		  ³
	//³ No Fina100 ‚ tratado desta forma.                    		  ³
	//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
	//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
   //³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
   //³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
   //³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
      If !(E5_MOEDA $ cTabela14+IIf(cPaisLoc=="BRA","","/$ "))
			dbSkip()
			Loop
		Endif
	Endif
	If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" ;
		.or. Substr(E5_DOCUMEN,1,1) == "*" )
		dbSkip()
		Loop
	Endif

	If E5_MOEDA == "CH" .and. (IsCaixaLoja(E5_BANCO) .And. !lCxLoja)		// Sangria
		dbSkip()
		Loop
	Endif

	If !Empty( E5_MOTBX )
		If !MovBcoBx( E5_MOTBX )
			dbSkip( )
			Loop
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilterUser).and.!(&cFilterUser)
		dbSkip()
		Loop
	Endif

	IF li > nLin
		cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@li ++,113 PSAY nSaldoAtu Picture tm(nSaldoAtu,16,nMoeda)
	EndIF
	                                                                                      
	If lSpbInUse	
		dbSelectArea("TRB")
	Else
		dbSelectArea("SE5")
	Endif
	@li, 0 PSAY E5_DTDISPO
	@li,12 PSAY SUBSTR(E5_HISTOR,1,30)
	
	cDoc := E5_NUMCHEQ
	
	IF Empty( cDoc )
		cDoc := E5_DOCUMEN
	Endif
	
	IF Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) <= 19
		cDoc := Alltrim(E5_DOCUMEN) +if(!empty(Alltrim(E5_DOCUMEN)),"-"," ") + Alltrim(E5_NUMCHEQ )
	Endif
	
	If Substr( cDoc ,1, 1 ) == "*"
		dbSkip( )
		Loop
	Endif
	
	@li,043 PSAY IIF(AllTrim(cDoc) == ""," ",AllTrim(cDoc))	
	@li,061 PSAY E5_PREFIXO+IIF(EMPTY(E5_PREFIXO)," ","-")+E5_NUMERO+;
									 IIF(EMPTY(E5_PARCELA)," ","-")+E5_PARCELA
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³VerIfica se foi utilizada taxa contratada para moeda > 1          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTxMoedBc 	:= 0 
	

	If SE5->(FieldPos('E5_TXMOEDA')) > 0 .And.  SE5->E5_TXMOEDA > 0
		nTxMoedBc := SE5->E5_TXMOEDA	
	ElseIf cPaisLoc=="BRA"  .Or. cPaisLoc<>"BRA" .And. (Empty(E5_MOEDA) .Or. (!Empty(E5_MOEDA).And.Val(E5_MOEDA)==1) )
		nTxMoedBc :=E5_VALOR/E5_VLMOED2
	Else
		nTxMoedBc :=E5_VLMOED2/E5_VALOR
	Endif
	
	nTxMoeda := RecMoeda(E5_DTDISPO,mv_par06)

	nValor := Round(xMoeda(E5_VALOR,Iif((cPaisLoc<>"BRA".And.(E5_TIPODOC $ MVRECANT+"|ES") .and. Empty(E5_MOEDA)),1,nMoedaBco),mv_par06,E5_DTDISPO,nMoeda+1,,nTxMoedBc),nMoeda)

	IF E5_RECPAG="R"
		@li,78 PSAY  nValor	Picture tm(nValor,15,nMoeda)
		nSaldoAtu += nValor
		If Empty( E5_RECONC )
			aRecon[1][REC_NAO_CONCILIADO] += nValor
		Else
			aRecon[1][REC_CONCILIADO] += nValor
		EndIf
		If lSpbInUse
			//Adiantamentos sao sempre STR
			If E5_TIPO $ MVRECANT
					nSalSTR += nValor
			Else
				// Saldo STR ou transformados em STR
  				If E5_MODSPB $ " 1" .or. (E5_MODSPB $ "2/3" .AND. Empty(E5_BLOQ))
					nSalSTR += nValor
  				ElseIf E5_MODSPB == "2" //CIP
					nSalCIP += nValor
  				ElseIf E5_MODSPB == "3" //COMP
					nSalCOMP += nValor
			   Endif
			Endif
		Endif	
	Else
		@li,94 PSAY nValor  Picture tm(nValor,15,nMoeda)
		nSaldoAtu -= nValor
		If Empty( E5_RECONC )
			aRecon[1][PAG_NAO_CONCILIADO] += nValor
		Else
			aRecon[1][PAG_CONCILIADO] += nValor
		EndIf
		If lSpbInUse
			//Adiantamentos sao sempre STR
			If E5_TIPO $ MVPAGANT
				nSalSTR -= nValor
			Else
				// Saldo STR ou transformados em STR
  				If E5_MODSPB $ " 1" .or. (E5_MODSPB $ "2/3" .AND. Empty(E5_BLOQ))
					nSalSTR -= nValor
  				ElseIf E5_MODSPB == "2" //CIP
					nSalCIP -= nValor
  				ElseIf E5_MODSPB == "3" //COMP
					nSalCOMP -= nValor
			   Endif
			Endif
		Endif	
	Endif
	@li,113 PSAY nSaldoAtu Picture tm(nSaldoAtu,16,nMoeda)
   If lSpbInUse
		If (E5_MODSPB $ "2/3" .AND. !Empty(E5_BLOQ))
			@li,pCol() + 1 PSAY E5_BLOQ
		Endif	
	Endif
	@li++,pCol()PSAY Iif(Empty(E5_RECONC), " ", "x")
		
	If Len(Alltrim(E5_HISTOR)) > 30
		@li ++,12 PSAY SUBSTR(E5_HISTOR,31,30)
	Endif
	If lSpbInUse	
		dbSelectArea("TRB")
	Else
		dbSelectArea("SE5")
	Endif
	dbSkip()
EndDO

If li > nLin - 5
	cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif

li+=2
@li,048 PSAY OemToAnsi("SALDO INICIAL...........: ")  //"SALDO INICIAL...........: "
@li,113 PSAY nSaldoIni	Picture tm(nSaldoIni,16,nMoeda)

li+=2
If li > nLin - 5
	cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
@li,078 PSAY OemToAnsi("NAO CONCILIADOS")  //"NAO CONCILIADOS"
@li,098 PSAY OemToAnsi("    CONCILIADOS")  //"    CONCILIADOS"
@li,124 PSAY OemToAnsi("          TOTAL")  //"          TOTAL"

li++
@li,048 PSAY OemToAnsi("ENTRADAS NO PERIODO.....: ")  //"ENTRADAS NO PERIODO.....: "
@li,078 PSAY aRecon[1][REC_NAO_CONCILIADO] PicTure tm(aRecon[1][1],15,nMoeda)
@li,094 PSAY aRecon[1][REC_CONCILIADO] PicTure tm(aRecon[1][2],15,nMoeda)
@li,113 PSAY aRecon[1][REC_CONCILIADO] + aRecon[1][REC_NAO_CONCILIADO] PicTure tm((aRecon[1][1]+aRecon[1][2]),16,nMoeda)

li++
If li > nLin - 5
	cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
@li,048 PSAY OemToAnsi("SAIDAS NO PERIODO ......: ")  //"SAIDAS NO PERIODO ......: "
@li,078 PSAY aRecon[1][PAG_NAO_CONCILIADO] PicTure tm(aRecon[1][3],15,nMoeda)
@li,094 PSAY aRecon[1][PAG_CONCILIADO] PicTure tm(aRecon[1][4],15,nMoeda)
@li,113 PSAY aRecon[1][PAG_CONCILIADO] + aRecon[1][PAG_NAO_CONCILIADO] PicTure tm((aRecon[1][3]+aRecon[1][4]),16,nMoeda)

If lSpbInUse

	nSalStr += nSaldoAtu - (nSalStr+nSalCIP+nSalCOMP)
	li+=2
	If li > nLin - 5
		cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	@li, 48 PSAY "SALDO DISPONIVEL........: " //"SALDO DISPONIVEL........: "
	@li,113 PSAY nSalSTR	Picture tm(nSalSTR,16,nMoeda)
	
	li++
	@li, 48 PSAY "SALDO BLOQUEADO CIP (2).: " //"SALDO BLOQUEADO CIP (2).: "
	@li,113 PSAY nSalCIP	Picture tm(nSalCIP,16,nMoeda)
	
	li++
	@li, 48 PSAY "SALDO BLOQUEADO COMP (3):" //"SALDO BLOQUEADO COMP (3):"
	@li,113 PSAY nSalCOMP	Picture tm(nSalCOMP,16,nMoeda)
Endif

li++
If li > nLin - 5
	cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
@li, 48 PSAY OemToAnsi("LIMITE DE CREDITO ......: ")  //"LIMITE DE CREDITO ......: "
@li,113 PSAY nLimCred Picture tm(nLimCred,16,nMoeda)

li+=2
nSaldoAtu += nLimCred
If li > nLin - 5
	cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
@li, 48 PSAY OemToAnsi("SALDO ATUAL ............: ")  //"SALDO ATUAL ............: "
@li,113 PSAY nSaldoAtu	Picture tm(nSaldoAtu,16,nMoeda)

IF li != 80
	roda(cbcont,cbtxt,Tamanho)
EndIF

Set Device To Screen

#IFNDEF TOP
	dbSelectArea("SE5")
	RetIndex( "SE5" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
   If TcSrvType() != "AS/400"
		dbSelectArea("SE5")
		dbCloseArea()
		ChKFile("SE5")
   	dbSelectArea("SE5")
		dbSetOrder(1)
	Else
		dbSelectArea("SE5")
		RetIndex( "SE5" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	Endif
#ENDIF

If lSpbInUse
	dbSelectArea("TRB")
	dbCloseArea()
	Ferase(cNomeArq+GetDBExtension())
	Ferase(cNomeArq+OrdBagExt())
Endif
If aReturn[5] = 1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr470Skip ³ Autor ³ Pilar S. Albaladejo	  ³ Data ³ 13.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR470.PRX																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr470Skip(cBanco,cAgencia,cConta)
Local lRet := .T.

IF E5_TIPODOC $ "DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL"  //Valores de Baixas
	lRet := .F.
ElseIF Alltrim(E5_BANCO+E5_AGENCIA+E5_CONTA)!=Alltrim(cBanco+cAgencia+cConta)
	lRet := .F.
ElseIF E5_SITUACA = "C"    //Cancelado
	lRet := .F.
ElseIF E5_VALOR = 0
	lRet := .F.
ElseIF E5_VENCTO > mv_par05 .or. E5_VENCTO > E5_DATA
	lRet := .F.
ElseIf SubStr(E5_NUMCHEQ,1,1)=="*" 
	lRet := .F.
ElseIf (mv_par07 == 2 .and. Empty(E5_RECONC)) .or. (mv_par07 == 3 .and. !Empty(E5_RECONC))
	lRet := .F.
ElseIF E5_TIPODOC = "BA"      //Baixa Automatica
	lRet := .F.
Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr470Spb  ³ Autor ³ Mauricio Pequim Jro	  ³ Data ³ 23.03.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta arquivo de tranbalho para SPB                      )  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR470.PRX																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr470SPB(cChave, aStruct)

Local cCondTrb := iiF(lAllFil, ".T.",'E5_FILIAL == xFilial("SE5")')
Local nX

DbselectArea("SE5")
While !Eof() .and. &(cCondTrb)
	If (E5_DATA >= mv_par04 .and. E5_DATA <= MV_PAR05 .AND.E5_DTDISPO > MV_PAR05) .OR. (E5_DTDISPO <= MV_PAR05)
		RecLock( "TRB", .T. )
		For nX := 1 to Len( aStruct )   // Até o campo anterior a TRB->E5_BLOQ
			If SE5->(FieldName(nx))<>"E5_BLOQ"
				dbSelectArea("SE5")
				xConteudo := FieldGet( nX )
				dbSelectArea("TRB")
				FieldPut( TRB->(FieldPos(SE5->(FieldName(nx)))),	xConteudo )
			EndIf
		Next nX
		If (E5_DATA <= MV_PAR05 .AND.E5_DTDISPO > MV_PAR05 ) .or. ;
			(E5_DATA <= MV_PAR05 .AND.E5_MODSPB == "2" .and. E5_DTDISPO == MV_PAR05 .AND.;
			(dDataBase == E5_DTDISPO .and. ;
			((E5_RECPAG == "R" .and. E5_TIPODOC != "ES") .or. (E5_RECPAG == "P" .and. E5_TIPODOC == "ES"))) )
			TRB->E5_DTDISPO	:= TRB->E5_DATA
			TRB->E5_BLOQ		:= SE5->E5_MODSPB
		Endif	
		msUnlock()
   Endif                                                     
   DbselectArea("SE5")
   DBsKIP()
Enddo
dbselectArea("TRB")
dbGotop()
Return
//----------------------
