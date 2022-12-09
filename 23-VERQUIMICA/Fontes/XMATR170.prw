#INCLUDE "MATR170.CH"
#INCLUDE "PROTHEUS.CH"
                              
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR170  ³ Autor ³ Ricardo Berti         ³ Data ³ 05.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Boletim de Entrada                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR170(ExpC1,ExpN1,ExpN2)                           	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                     	          ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xMatr170(cAlias,nReg,nOpcx)

Local oReport

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef(cAlias,nReg,nOpcx)
oReport:PrintDialog()

Return NIL


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Ricardo Berti 		³ Data ³ 05.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                     	          ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatorio                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATR170                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef(cAlias,nReg,nOpcx)

Local oReport 
Local oEmpresa
Local oFornec1
Local oFornec2
Local oClient1
Local oClient2
Local oNF
Local oNFItem
Local oEntCtb
Local oQuali
Local oDivPC
Local oNFTot1
Local oNFTot2
Local oDupli
Local oFisc1
Local oFisc2
Local oFisc3
Local oCell         
Local aVencto	:= {}
Local aImps		:= {}
Local cAliasSF1 := "SF1"
Local cAliasSD1 := "SD1"
Local lAuto		:= (nReg!=Nil)

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

oReport := TReport():New("MATR170",STR0002,"MTR170", {|oReport| ReportPrint(oReport,@aVencto,@aImps,nReg,@cAliasSF1,@cAliasSD1)},STR0001) ////"Boletim de Entrada"##"Este programa ira emitir o Boletim de Entrada."
oReport:SetPortrait()	// Define a orientacao default de pagina do relatorio como Retrato.

If lAuto
	oReport:ParamReadOnly() // Desabilita a edicao de parametros pelo usuario na tela de impressao
EndIf

oReport:HideParamPage()	// inibe impressao da pagina de parametros
oReport:SetPageFooter(4,{|| ImpRoda(oReport)})  // define rodape'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("MTR170",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utiLizadas para parametros                    		    ³
//³ mv_par01             // da Data                 		            ³
//³ mv_par02             // ate a Data      		                    ³
//³ mv_par03             // Nota De			                            ³
//³ mv_par04             // Nota Ate                          			³
//³ mv_par05             // Imprime Cta.Contabil x C.Custo x Entid.Ctb.	³
//³ mv_par06             // Imprimir o Custo ? Total ou Unit rio 		³
//³ mv_par07             // Ordenar itens por? Item+Prod/ Prd+It 		³
//³ mv_par08             // Imprime armazem? Sim/Nao			 		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lAuto
	dbSelectArea("SF1")
	dbGoto(nReg)
	MV_PAR01 := SF1->F1_DTDIGIT
	MV_PAR02 := SF1->F1_DTDIGIT
	MV_PAR03 := SF1->F1_DOC
	MV_PAR04 := SF1->F1_DOC
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao das celulas da secao do relatorio                               ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 1 - Dados Boletim       			                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:= TRSection():New(oReport,STR0089,{"SF1"},/*Ordem*/)  //"Cabeçalho do Boletim (Parte 2)"
oCell := TRCell():New(oSection1,"Tit"	,"",STR0002,,,,{|| STR0002+"   "+STR0047+(cAliasSD1)->D1_NUMSEQ ;  //"Boletim de Entrada"##"N. "
	+If((cAliasSF1)->F1_TIPO $ "DB", If( (cAliasSF1)->F1_TIPO=="D",STR0038,"  - "+AllTrim(STR0053)),"" ) })  //"Devolucao / Beneficiamento
oCell:SetSize(3+Len(STR0002+STR0047)+TamSX3("D1_NUMSEQ")[1]+If((cAliasSF1)->F1_TIPO $ "DB",15,0) )
oCell := TRCell():New(oSection1,"DtRec"	,"",STR0065,,,,{|| STR0065+dtoc((cAliasSF1)->F1_RECBMTO) }) //"Material recebido em: " //"Material Recebido em: "###"Material Recebido em: "
oCell:SetSize(10+Len(STR0065)) //"Material Recebido em: "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 0 - Cabecalho 	  	                                        	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oCabec:= TRSection():New(oSection1,STR0090,{"SF1"},/*Ordem*/) //"Cabeçalho do Boletim (Parte 1)" 
oCabec:SetHeaderSection(.F.)
TRCell():New(oCabec,"Usu"	,"",STR0035,,Len(STR0035)+15,,{|| STR0035+CUSERNAME  })  //"Usuario: "
TRCell():New(oCabec,"DtBase","",STR0036,,Len(STR0036)+10,,{|| STR0036+Dtoc(dDataBase) }) //" Data Base: "
TRCell():New(oCabec,"DtImp" ,"",STR0048,,Len(STR0048)+35,,{|| Space(15)+STR0048+Dtoc(Date()) }) //"Data Impressao ")
TRCell():New(oCabec,"HrImp" ,"",STR0049,,Len(STR0049)+ 8,,{|| STR0049+Time() }) //"Hora ref. ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 2 - Dados da Empresa			                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oEmpresa := TRSection():New(oSection1,STR0091,{"SM0"},/*Ordem*/) //"Dados da Empresa/Filial"
		 TRCell():New(oEmpresa,"M0_NOME","SM0","M0NOME",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		 TRCell():New(oEmpresa,"M0_FILIAL","SM0","M0FILIAL")
oCell := TRCell():New(oEmpresa,"M0_CGC","SM0","M0CGC",,,,{|| "  - "+AllTrim(RetTitle("A1_CGC"))+": "+SM0->M0_CGC })
oCell:SetSize(6+Len(AllTrim(RetTitle("A1_CGC")))+TamSX3("A1_CGC")[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 3 - Dados do Fornecedor - I	                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFornec1 := TRSection():New(oSection1,STR0092,{"SA2"},/*Ordem*/) //"Fornecedor (Parte 1)" 
TRCell():New(oFornec1,"A2_COD","SA2",/*Titulo*/,/*Picture*/,TamSX3("A2_COD")[1]+5,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oFornec1,"A2_LOJA","SA2",/*Titulo*/,/*Picture*/,TamSX3("A2_LOJA")[1]+5)
TRCell():New(oFornec1,"A2_NOME","SA2",/*Titulo*/,/*Picture*/,60)
TRCell():New(oFornec1,"A2_END","SA2")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 4 - Dados do Fornecedor - II	                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFornec2 := TRSection():New(oSection1,STR0093,{"SA2"},/*Ordem*/) //"Fornecedor (Parte 2)" 
		 TRCell():New(oFornec2,"A2_MUN","SA2")
		 TRCell():New(oFornec2,"A2_EST","SA2")
oCell := TRCell():New(oFornec2,"CGCFOR","SA2","@X",,,,{|| AllTrim(RetTitle("A2_CGC"))+': '+If(cPaisLoc<>"BRA",Transform(SA2->A2_CGC,PesqPict("SA2","A2_CGC")),Transform(SA2->A2_CGC,PicPesFJ(If(Len(AllTrim(SA2->A2_CGC))<14,"F","J")))) } )
oCell:SetSize(10+Len(AllTrim(RetTitle("A2_CGC")))+TamSX3("A2_CGC")[1])
If cPaisLoc <> "PTG"
	oCell := TRCell():New(oFornec2,"A2_INSCR","SA2",,,,,{|| AllTrim(RetTitle("A2_INSCR"))+': '+Transform(SA2->A2_INSCR,PesqPict("SA2","A2_INSCR")) } )
	oCell:SetSize(2+Len(AllTrim(RetTitle("A2_INSCR")))+TamSX3("A2_INSCR")[1])
	oCell := TRCell():New(oFornec2,"A2_INSCRM","SA2",,,,,{|| AllTrim(RetTitle("A2_INSCRM"))+': '+Transform(SA2->A2_INSCRM,PesqPict("SA2","A2_INSCRM")) } )
	oCell:SetSize(2+Len(AllTrim(RetTitle("A2_INSCRM")))+TamSX3("A2_INSCRM")[1])
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 5 - Dados do Cliente - I 		                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oClient1 := TRSection():New(oSection1,STR0094,{"SA1"},/*Ordem*/) //"Cliente (Parte 1)"
TRCell():New(oClient1,"A1_COD","SA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClient1,"A1_LOJA","SA1")
TRCell():New(oClient1,"A1_NOME","SA1")
TRCell():New(oClient1,"A1_END","SA1")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 6 - Dados do Cliente - II		                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oClient2 := TRSection():New(oSection1,STR0095,{"SA1"},/*Ordem*/) //"Cliente (Parte 2)"
		 TRCell():New(oClient2,"A1_MUN","SA1")
		 TRCell():New(oClient2,"A1_EST","SA1")
oCell := TRCell():New(oClient2,"CGCCLI","SA1",,,,,{|| AllTrim(RetTitle("A1_CGC"))+': '+Transform(SA1->A1_CGC,PicPesFJ(If(Len(AllTrim(SA1->A1_CGC))<14,"F","J"))) }) 
oCell:SetSize(6+Len(AllTrim(RetTitle("A1_CGC")))+TamSX3("A1_CGC")[1])
If cPaisLoc <> "PTG"
	oCell := TRCell():New(oClient2,"A1_INSCR","SA1",,,,,{|| AllTrim(RetTitle("A1_INSCR"))+': '+Transform(SA1->A1_INSCR,PesqPict("SA1","A1_INSCR")) } )
	oCell:SetSize(2+Len(AllTrim(RetTitle("A1_INSCR")))+TamSX3("A1_INSCR")[1])
	oCell := TRCell():New(oClient2,"A1_INSCRM","SA1",,,,,{|| AllTrim(RetTitle("A1_INSCRM"))+': '+Transform(SA1->A1_INSCRM,PesqPict("SA1","A1_INSCRM")) } )
	oCell:SetSize(2+Len(AllTrim(RetTitle("A2_INSCRM")))+TamSX3("A2_INSCRM")[1])
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 7 - Dados da Nota Fiscal	                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oNF := TRSection():New(oSection1,STR0096,{"SF1"},/*Ordem*/) //"Cabeçalhos de documentos de entrada"
TRCell():New(oNF,SerieNfId("SF1",3,"F1_SERIE"),"SF1",SerieNfId("SF1",7,"F1_SERIE"),/*Picture*/,SerieNfId("SF1",6,"F1_SERIE"),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNF,"F1_DOC"		,"SF1")
TRCell():New(oNF,"F1_ESPECIE"	,"SF1")
TRCell():New(oNF,"F1_TIPO"		,"SF1",/*Titulo*/,/*Picture*/,20)
TRCell():New(oNF,"F1_EMISSAO"	,"SF1",/*Titulo*/,/*Picture*/,20)
TRCell():New(oNF,"DTVENC"		,"",RetTitle("E2_VENCTO"),,20,,{|| If( Len(aVencto) == 1, Dtoc(aVencto[1]),If(Len(aVencto) ==0,STR0115,STR0040)) }) //"Diversos" 
TRCell():New(oNF,"F1_VALBRUT"	,"SF1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 8 - Dados da Nota Fiscal - Itens                          	       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oNFItem := TRSection():New(oSection1,STR0097,{"SD1","SB1","SB1EMB"},/*Ordem*/) //"Itens de documentos de entrada"
TRCell():New(oNFItem,"D1_COD"	,"SD1",/*Titulo*/,/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNFItem,"D1_UM"	,"SD1",STR0111)
TRCell():New(oNFItem,"B1_DESC"	,"SB1",,,20)
oNFItem:Cell("B1_DESC"):SetLineBreak() 
TRCell():New(oNFItem,"B1_DESCEMB"	,"SB1EMB","Embalagem",,20,,{|| (cAliasSD1)->B1_DESCEMB })
oNFItem:Cell("B1_DESCEMB"):SetLineBreak() 
TRCell():New(oNFItem,"D1_LOCAL","SD1")
TRCell():New(oNFItem,"D1_QUANT","SD1",/*Titulo*/,/*Picture*/,20)
TRCell():New(oNFItem,"D1_VUNIT","SD1",,/*Picture*/,20)
TRCell():New(oNFItem,"D1_TOTAL","SD1",,/*Picture*/,20)
TRCell():New(oNFItem,"D1_IPI"	,"SD1",STR0112)
TRCell():New(oNFItem,"D1_PICM"	,"SD1",STR0113)
TRCell():New(oNFItem,"D1_CONTA","SD1")
TRCell():New(oNFItem,"D1_CC"	,"SD1")
TRCell():New(oNFItem,"D1_TES"	,"SD1",STR0110)
TRCell():New(oNFItem,"D1_CF"	,"SD1",STR0114)
TRCell():New(oNFItem,"D1_CUSTO","SD1",STR0013,,10,,{|| If( mv_par06==1,(cAliasSD1)->D1_CUSTO,(cAliasSD1)->D1_CUSTO / (cAliasSD1)->D1_QUANT ) }) //"Custo Total "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 9 - Entidades Contabeis 		                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oEntCtb := TRSection():New(oSection1,STR0098,{"SDE"},/*Ordem*/) //"Entidades Contábeis"
oCell := TRCell():New(oEntCtb,"DEITEMNF","")
oCell:GetFieldInfo("DE_ITEMNF")
oCell := TRCell():New(oEntCtb,"DEITEM"	,"")
oCell:GetFieldInfo("DE_ITEM")
		 TRCell():New(oEntCtb,"DEPERC"	,"",RetTitle("DE_PERC"),,6)
oCell := TRCell():New(oEntCtb,"DECC"	,"")
oCell:GetFieldInfo("DE_CC")
oCell := TRCell():New(oEntCtb,"DECONTA"	,"")
oCell:GetFieldInfo("DE_CONTA")
oCell := TRCell():New(oEntCtb,"DEITEMCTA","")
oCell:GetFieldInfo("DE_ITEMCTA")
oCell := TRCell():New(oEntCtb,"DECLVL"	,"")
oCell:GetFieldInfo("DE_CLVL")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 10 - Produtos Enviados ao Controle de Qualidade                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oQuali := TRSection():New(oSection1,STR0099,{"SD7"},/*Ordem*/) //"Produtos enviados ao CQ"
oCell := TRCell():New(oQuali,"D7PRODUTO","",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oCell:GetFieldInfo("D7_PRODUTO")
oCell := TRCell():New(oQuali,"D7LOCAL"	,"")
oCell:GetFieldInfo("D7_LOCAL")
oCell := TRCell():New(oQuali,"D7LOCDEST","")
oCell:GetFieldInfo("D7_LOCDEST")
oCell := TRCell():New(oQuali,"D7DATA"	,"")
oCell:GetFieldInfo("D7_DATA")
oCell := TRCell():New(oQuali,"D7NUMERO"	,"")
oCell:GetFieldInfo("D7_NUMERO")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 11 - Divergencia com Pedido de Compra                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDivPC := TRSection():New(oSection1,STR0100,{"SC7"},/*Ordem*/) //"Divergência com Pedido de Compra"
TRCell():New(oDivPC,"DivPC"	,"","Div",/*Picture*/,4,/*lPixel*/,/*{|| code-block de impressao }*/)
oCell := TRCell():New(oDivPC,"C7NUM"	,"",RetTitle("C7_NUM"),,TamSX3("C7_NUM")[1]+TamSX3("C7_ITEM")[1]+10)
oCell := TRCell():New(oDivPC,"C7DESCRI"	,"")
oCell:GetFieldInfo("C7_DESCRI")
If cPaisLoc == "BRA"
	oCell:SetSize(23)
Else
	oCell:SetSize(18)
EndIf
oCell:SetLineBreak()
oCell := TRCell():New(oDivPC,"DESCEMB","","Embalagem",,20)
oCell:SetLineBreak()

oCell := TRCell():New(oDivPC,"C7QUANT"	,"",RetTitle("C7_QUANT"),,20)
oCell := TRCell():New(oDivPC,"C7PRECO"	,"",RetTitle("C7_PRECO"),,20)
oCell := TRCell():New(oDivPC,"C7EMISSAO","")
oCell:GetFieldInfo("C7_EMISSAO")
oCell:SetSize(20)
oCell := TRCell():New(oDivPC,"C7DATPRF"	,"")
oCell:GetFieldInfo("C7_DATPRF")
oCell:SetSize(20)
//oCell := TRCell():New(oDivPC,"C7NUMSC"	,"")
//oCell:GetFieldInfo("C7_NUMSC")
oCell:SetSize(20)
oCell := TRCell():New(oDivPC,"C1SOLICIT","")
oCell:GetFieldInfo("C1_SOLICIT")
oCell := TRCell():New(oDivPC,"C1CC","")
oCell:GetFieldInfo("C1_CC")
oCell:SetSize(20)
oCell := TRCell():New(oDivPC,"E4DESCRI"	,"")
oCell:GetFieldInfo("E4_DESCRI")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 12 - TOTAIS DA NF (1/2)                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oNFTot1 := TRSection():New(oSection1,STR0101,{"SF1"},/*Ordem*/) //"Totais da Nota Fiscal (Parte 1)"
If cPaisLoc=="BRA"
	TRCell():New(oNFTot1,"F1_BASEICM"	,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oNFTot1,"F1_VALICM"	,"SF1")
	TRCell():New(oNFTot1,"F1_BRICMS"	,"SF1")
	TRCell():New(oNFTot1,"F1_ICMSRET"	,"SF1")
Else
	TRCell():New(oNFTot1,"QTIMP1"	,"",STR0067	,"@E 999,999,999,999.99",,,{|| aImps[1] }) //"Base de Calculo Imp."
	TRCell():New(oNFTot1,"VLIMP1"	,"",STR0068	,"@E 999,999,999,999.99",,,{|| aImps[2] }) //"Valor dos Impostos"
EndIf
TRCell():New(oNFTot1,"F1_VALMERC"	,"SF1")
TRCell():New(oNFTot1,"F1_DESCONT"	,"SF1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 13 - TOTAIS DA NF (2/2)                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oNFTot2 := TRSection():New(oSection1,STR0102,{"SF1"},/*Ordem*/) //"Totais da Nota Fiscal (Parte 2)"
TRCell():New(oNFTot2,"F1_FRETE"	,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNFTot2,"F1_SEGURO"	,"SF1")
TRCell():New(oNFTot2,"F1_DESPESA"	,"SF1")
If cPaisLoc=="BRA"
	TRCell():New(oNFTot2,"F1_VALIPI"	,"SF1")
EndIf
TRCell():New(oNFTot2,"F1_VALBRUT"	,"SF1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 14 - DESDOBRAMENTO DAS DUPLICATAS                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDupli := TRSection():New(oSection1,STR0103,{"SE2"},/*Ordem*/) // "Contas a Pagar"
oCell := TRCell():New(oDupli,"E2PREFIXO" ,"SE2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oCell:GetFieldInfo("E2_PREFIXO")
oCell := TRCell():New(oDupli,"E2NUM"	 ,"SE2")
oCell:GetFieldInfo("E2_NUM")
oCell := TRCell():New(oDupli,"E2PARCELA" ,"SE2")
oCell:GetFieldInfo("E2_PARCELA")
oCell := TRCell():New(oDupli,"E2VENCTO"	 ,"SE2")
oCell:GetFieldInfo("E2_VENCTO")
oCell := TRCell():New(oDupli,"E2VALOR"	 ,"SE2")
oCell:GetFieldInfo("E2_VALOR")
oCell := TRCell():New(oDupli,"E2NATUREZ" ,"SE2")
oCell:GetFieldInfo("E2_NATUREZ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 15 - DEMONSTRATIVO DOS LIVROS FISCAIS                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFisc1 := TRSection():New(oSection1,STR0104,{"SF3"},/*Ordem*/) //"Livros Fiscais"
oCell := TRCell():New(oFisc1,"IMP1" 	 ,"SF3"	,"IMP1",/*Picture*/,4,/*lPixel*/,/*{|| code-block de impressao }*/)
oFisc1:Cell("IMP1"):HideHeader()
oCell := TRCell():New(oFisc1,"CFOP" 	 ,"SF3")
oCell:GetFieldInfo("F3_CFOP")
		 TRCell():New(oFisc1,"ALIQ" 		,"SF3","Aliq","99")
		 TRCell():New(oFisc1,"F3_VALCONT","SF3")
		 TRCell():New(oFisc1,"BASEIMP1" ,"SF3",STR0069,"@E 999,999,999,999.99",16,.F.,,"RIGHT",.F.,"RIGHT") //"Base de Calculo"
		 TRCell():New(oFisc1,"VALIMP1" 	,"SF3",STR0070,"@E 999,999,999,999.99",16,.F.,,"RIGHT",.F.,"RIGHT") //"Imposto"
		 TRCell():New(oFisc1,"ISENTAS1" ,"SF3",STR0071,"@E 999,999,999,999.99",16,.F.,,"RIGHT",.F.,"RIGHT") //"Isentas"
		 TRCell():New(oFisc1,"OUTRAS1" 	,"SF3",STR0072,"@E 999,999,999,999.99",16,.F.,,"RIGHT",.F.,"RIGHT") //"Outras"
		 TRCell():New(oFisc1,"OBS1" 	,"SF3",STR0073,,22) //"Observacao"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 16 - DEMONSTRATIVO DOS DEMAIS IMPOSTOS - PIS / COFINS             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFisc2 := TRSection():New(oSection1,STR0105,{"SF1"},/*Ordem*/) //"Demais Impostos"
oCell := TRCell():New(oFisc2,"IMP2"		,"","IMP2",/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
oFisc2:Cell("IMP2"):HideHeader()
		 TRCell():New(oFisc2,"BASEIMP2","",STR0069,"@E 999,999,999,999.99") //"Base de Calculo"
		 TRCell():New(oFisc2,"VALIMP2" ,"",STR0070,"@E 999,999,999,999.99",16,.F.,,"RIGHT",.F.,"RIGHT") //"Imposto"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 17 - DEMONSTRATIVO DOS LIVROS FISCAIS (LOCALIZADO)                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFisc3 := TRSection():New(oSection1,STR0106,{"SD1"},/*Ordem*/) //"Livros Fiscais (Localizado)"
oCell := TRCell():New(oFisc3,"PRO3" ,"")
oCell:GetFieldInfo("D1_COD")
		 TRCell():New(oFisc3,"DESC3","",STR0074,,40) //"Descricao"
		 TRCell():New(oFisc3,"IMP3"	,"",STR0075,,5) //"Imp"
		 TRCell():New(oFisc3,"ALI3"	,"",STR0076,PesqPict("SD1","D1_ALQIMP6")) //"Aliq"
		 TRCell():New(oFisc3,"BASEIMP3","",STR0069 ,"@E 999,999,999,999.99") //"Base de Calculo"
		 TRCell():New(oFisc3,"VALORIMP3","",STR0077,"@E 999,999,999,999.99") //"Valor do imposto"
		
oReport:HideHeader()

oEmpresa:SetNoFilter({"SM0"})
oClient1:SetNoFilter({"SA1"})
oClient2:SetNoFilter({"SA1"})
oFornec1:SetNoFilter({"SA2"})
oFornec2:SetNoFilter({"SA2"})
oFisc1:SetNoFilter({"SF3"})
oQuali:SetNoFilter({"SD7"})
oDivPC:SetNoFilter({"SC7"})
oDupli:SetNoFilter({"SE2"})
oNFItem:SetNoFilter({"SB1"})
oEntCtb:SetNoFilter({"SDE"})

Return(oReport)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Ricardo Berti   		³ Data ³04.07.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ReportPrint(ExpO1,ExpA1,ExpA2,ExpN1,ExpC1,ExpC2)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±³          ³ExpA1: Array contendo os vencimentos das duplicatas da NF   ³±±
±±³          ³ExpA2: Array c/ bases e valores de impostos (LOCALIZ.)	  ³±±
±±³          ³ExpN1 = Numero do registro   (ROT.AUT.)         	          ³±±
±±³          ³ExpC1 = Alias do arquivo SF1                  	          ³±±
±±³          ³ExpC2 = Alias do arquivo SD1                  	          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATR170                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,aVencto,aImps,nReg,cAliasSF1,cAliasSD1)

LOCAL aAreaSF3	:= SF3->(GetArea())
LOCAL aAreaSF1	:= SF1->(GetArea())
LOCAL aAreaSE2	:= SE2->(GetArea())
LOCAL aAreaSC7	:= SC7->(GetArea())
Local cAliasSB1 := "SB1"
Local cAliasSF4 := "SF4"
Local lQuery	:= .F.
Local lQuali	:= .T.
Local lDupli	:= .T.
Local oSection1	:= oReport:Section(1)
Local oCabec	:= oReport:Section(1):Section(1)
Local oEmpresa	:= oReport:Section(1):Section(2)
Local oFornec1	:= oReport:Section(1):Section(3)
Local oFornec2	:= oReport:Section(1):Section(4)
Local oClient1	:= oReport:Section(1):Section(5)
Local oClient2	:= oReport:Section(1):Section(6)
Local oNF 		:= oReport:Section(1):Section(7)
Local oNFItem	:= oReport:Section(1):Section(8)
Local oEntCtb	:= oReport:Section(1):Section(9)
Local oQuali	:= oReport:Section(1):Section(10)
Local oDivPC	:= oReport:Section(1):Section(11)
Local oNFTot1	:= oReport:Section(1):Section(12)
Local oNFTot2	:= oReport:Section(1):Section(13)
Local oDupli	:= oReport:Section(1):Section(14)
Local oFisc1	:= oReport:Section(1):Section(15)
Local oFisc2	:= oReport:Section(1):Section(16)
Local oFisc3	:= oReport:Section(1):Section(17)

Local aAuxCombo1:= {"N","D","B","I","P","C","1","2","3"}
Local aCombo1	:= {STR0051,;	//"Normal"
					STR0052,;	//"Devoluçao"
					STR0053,;	//"Beneficiamento"
					STR0054,;	//"Compl.  ICMS"
					STR0055,;	//"Compl.  IPI"
					STR0056,;	//"Compl. Preco/frete"
					STR0119,; //Compl. Preço
					STR0120,; //Compl. Quantidade
					STR0121}  //Compl. Frete
Local cLocDest    := GetMV("MV_CQ")
Local cForMunic   := GetMv("MV_MUNIC")
Local aTotalNF    := {}
Local aDivergencia:= {}
Local aPedidos	  := {}
Local aDescPed    := {}
Local aCQ         := {}
Local aEntCont    := {}
Local cForAnt     := 0
Local nDocAnt     := 0
Local nX          := 0
Local nImp        := 0
Local nRecno      := 0
Local lPedCom     := .F.
Local cParcIR     := ""
Local cParcINSS   := ""
Local cParcISS    := ""
Local cParcCof    := ""
Local cParcPis    := ""
Local cParcCsll   := ""
Local cParcSest   := "" 
Local cDtEmis     := ""
Local cPrefixo
Local aItens      := {}
Local nBasePis    := 0
Local nValPis     := 0
Local nBaseCof    := 0
Local nValCof     := 0
Local nCT         := 0 
Local nRec        := 0
Local i           := 0
Local nCell
Local cFornece
Local cLoja
Local cDoc
Local cSerie
Local nISS
Local aRelImp     := MaFisRelImp("MT100",{ "SF1" })
Local lAuto		  := (nReg!=Nil)
Local cFornIss 	  := ""
Local cLojaIss    := ""
Local cRemito     := ""
Local cItemRem    := ""
Local cSerieRem   := ""
Local cFornRem    := ""
Local cLojaRem    := ""
Local cCodRem     := ""
Local cPedido     := ""
Local cItemPed    := ""
Local cOrderBy
Local cWhere	:= ""
Local cCampos     := ""

//impressao em planilha tipo tabela não disponível	
If oReport:nDevice == 4 .And. oReport:lXlsTable 
	MsgAlert(STR0118,STR0117)
	oReport:CancelPrint()
EndIf

dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SF4")
dbSetOrder(1)
dbSelectArea("SD1")
dbSetOrder(1)
dbSelectArea("SC7")
dbSetOrder(19)
dbSelectArea("SC1")
dbSetOrder(1)
dbSelectArea("SE4")
dbSetOrder(1)

If lAuto
	dbSelectArea("SF1")
	dbGoto(nReg)
Else
	dbSelectArea("SF1")
	dbSetOrder(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Filtragem do relatorio                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAliasSF1		:= GetNextAlias()
	cAliasSD1		:= cAliasSF1
	cAliasSB1		:= cAliasSF1
	cAliasSF4		:= cAliasSF1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)

	lQuery := .T.

	cWhere := "% AND NOT ("+IsRemito(3,'F1_TIPODOC')+ ")%"

	If mv_par07 == 1
		cOrderBy := "%F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,D1_ITEM%"
	Else
		cOrderBy := "%F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,D1_COD,D1_ITEM%"
	EndIf

	cCampos := "%SF1.F1_FILIAL,  SF1.F1_DOC,     SF1.F1_SERIE,   SF1.F1_FORNECE, SF1.F1_LOJA,   SF1.F1_DTDIGIT, SF1.F1_TIPO, "
	cCampos += "SF1.F1_ESPECIE, SF1.F1_EMISSAO, SF1.F1_PREFIXO, SF1.F1_ISS,     SF1.F1_VALBRUT,SF1.F1_BASEICM, SF1.F1_VALICM, "
	cCampos += "SF1.F1_BRICMS,  SF1.F1_ICMSRET, SF1.F1_VALMERC, SF1.F1_DESCONT, SF1.F1_FRETE,  SF1.F1_SEGURO,  SF1.F1_DESPESA, "    		
	cCampos += "SF1.F1_VALIPI,  SF1.F1_VALBRUT, SF1.F1_TIPODOC, SF1.F1_RECBMTO , F1_BASIMP6 , F1_VALIMP6 , F1_BASIMP5 , F1_VALIMP5 , "
	If SF1->(FieldPos("F1_TPCOMPL")) >0
		cCampos += "SF1.F1_TPCOMPL, "
	EndIf   
	cCampos += "SD1.D1_FILIAL,  SD1.D1_DOC,     SD1.D1_SERIE,   SD1.D1_FORNECE, SD1.D1_LOJA,   SD1.D1_ITEM,    SD1.D1_TES, "     
	cCampos +=	 "SD1.D1_PEDIDO,  SD1.D1_ITEMPC,  SD1.D1_QTDPEDI, SD1.D1_QUANT,   SD1.D1_VUNIT,  SD1.D1_DTDIGIT, "
	cCampos += "SD1.D1_NUMCQ,   SD1.D1_UM,      SD1.D1_LOCAL,   SD1.D1_TOTAL,   SD1.D1_IPI,    SD1.D1_IPI,     SD1.D1_PICM, "  	    
	cCampos += "SD1.D1_CONTA,   SD1.D1_CC,      SD1.D1_CF,      SD1.D1_CUSTO,   SD1.D1_RATEIO, SD1.D1_ITEMCTA, SD1.D1_CLVL, "   
	cCampos += "SD1.D1_NUMSEQ,  SD1.D1_EMISSAO, SD1.D1_COD, "  
	cCampos += "SB1.B1_COD,     SB1.B1_DESC,    SF4.F4_ESTOQUE, 	SD1.D1_REMITO,  SD1.D1_ITEMREM, SD1.D1_SERIREM, SB1EMB.B1_COD, SB1EMB.B1_DESC B1_DESCEMB%"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatorio da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:BeginQuery()

	BeginSql Alias cAliasSF1

	SELECT %Exp:cCampos%

	FROM  %table:SF1% SF1, %table:SB1% SB1
	
	LEFT JOIN %table:SB1% SB1EMB
	  ON  SB1EMB.B1_FILIAL    = %xFilial:SB1EMB%	AND 
		  SB1.B1_VQ_EM	   = SB1EMB.B1_COD 		AND
		  SB1EMB.%NotDel%
		  
	, %table:SD1% SD1 
	
	LEFT JOIN %table:SF4% SF4
	  ON  SF4.F4_FILIAL    = %xFilial:SF4%	 	AND 
		  SF4.F4_CODIGO	   = SD1.D1_TES 		AND
		  SF4.%NotDel%
		  


	WHERE SF1.F1_FILIAL    = %xFilial:SF1%	 	AND 
  		  SF1.F1_DTDIGIT  >= %Exp:Dtos(mv_par01)% AND 
  		  SF1.F1_DTDIGIT  <= %Exp:Dtos(mv_par02)% AND 
  		  SF1.F1_DOC      >= %Exp:mv_par03%		AND 
  		  SF1.F1_DOC      <= %Exp:mv_par04%	 	AND 
	      SD1.D1_FILIAL    = %xFilial:SD1%	 	AND 
		  SD1.D1_DOC	   = SF1.F1_DOC 		AND
		  SD1.D1_SERIE     = SF1.F1_SERIE		AND
		  SD1.D1_FORNECE   = SF1.F1_FORNECE	    AND
		  SD1.D1_LOJA      = SF1.F1_LOJA	    AND
	      SB1.B1_FILIAL    = %xFilial:SB1%	 	AND 
		  SB1.B1_COD	   = SD1.D1_COD 		AND
		  SB1.%NotDel%						 	AND
		  SD1.%NotDel%						 	AND
		  SF1.%NotDel%
		  %Exp:cWhere%

	ORDER BY %Exp:cOrderBy%
	
	EndSql 
	oSection1:EndQuery()

	oNF:SetParentQuery()
	oNFItem:SetParentQuery()

EndIf

If !lQuery
	TRPosition():New(oNFItem,"SB1",1,{|| xFilial("SB1")+(cAliasSD1)->D1_COD })
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatorio                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lAuto .And. !lQuery .And. !Empty(mv_par03)
	(cAliasSF1)->(dbSeek(xFilial("SF1")+mv_par03,.T.))
ElseIf !lAuto
	(cAliasSF1)->(dbGoTop())
EndIf

oReport:SetMeter(SF1->(LastRec()))

If mv_par06 == 2
	oNFItem:Cell("D1_CUSTO"):SetTitle(STR0012) // "Custo Unit. "
EndIf           
If mv_par08 == 1
	oNFItem:Cell("B1_DESC"):SetSize(17)
Else
	oNFItem:Cell("D1_LOCAL"):Disable()
EndIf
oNFItem:Cell("B1_DESC"):SetLineBreak()
oNFItem:Cell("B1_DESCEMB"):SetLineBreak()

If cPaisLoc=="BRA"
	oNFItem:Cell("D1_TOTAL"):SetSize(12)
Else
	oNFItem:Cell("D1_IPI"):Disable()
	oNFItem:Cell("D1_PICM"):Disable()
EndIf
If mv_par05 == 1
	oNFItem:Cell("D1_CC"):Disable()
ElseIf mv_par05 == 2
	oNFItem:Cell("D1_CONTA"):Disable()
Else
	oNFItem:Cell("D1_CONTA"):Disable()
	oNFItem:Cell("D1_CC"):Disable()
EndIf
dbSelectArea(cAliasSF1)

While !oReport:Cancel() .And. !(cAliasSF1)->(Eof()) .And. ;
	(cAliasSF1)->F1_FILIAL == xFilial("SF1") .And. (cAliasSF1)->F1_DOC <= MV_PAR04
	If oReport:Cancel()
		Exit
	EndIf

	If (lAuto .And. (cAliasSF1)->(Recno()) <> nReg)
		(cAliasSF1)->(dbSkip())
		Loop
	EndIf

	oSection1:Init(.f.) 
	oReport:IncMeter()

	If !lQuery
		dbSelectArea("SD1")
		dbSeek(xFilial("SD1")+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)
	Else
		dbSelectArea("SF1")
		dbSeek(xFilial("SF1")+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)		
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Definicao do titulo do relatorio - muda a cada nota				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetTitle(STR0002+" "+(cAliasSD1)->D1_NUMSEQ)

	aImps		 := {}
	aItens		 := {}
	aDivergencia := {}
	aPedidos     := {}
	aDescPed     := {}
	aEntCont     := {}
	aCQ			 := {}
	aVencto		 := {}
	aTotalNF	 := {}
	// Totais da NF
	aAdd(aTotalNF,(cAliasSF1)->F1_BASEICM)
	aAdd(aTotalNF,(cAliasSF1)->F1_VALICM)
	aAdd(aTotalNF,(cAliasSF1)->F1_ICMSRET)
	aAdd(aTotalNF,(cAliasSF1)->F1_VALMERC)
	aAdd(aTotalNF,(cAliasSF1)->F1_DESCONT)
	aAdd(aTotalNF,(cAliasSF1)->F1_FRETE)
	aAdd(aTotalNF,(cAliasSF1)->F1_SEGURO)
	aAdd(aTotalNF,(cAliasSF1)->F1_DESPESA)
	aAdd(aTotalNF,(cAliasSF1)->F1_VALIPI)
	aAdd(aTotalNF,(cAliasSF1)->F1_VALBRUT)
	If cPaisLoc <> "BRA"
		aImps	:= R170IMPT(cAliasSF1)
		aItens	:= R170IMPI(cAliasSF1)
	EndIf
	// Variaveis do cabecalho da NF
	cFornece := (cAliasSF1)->F1_FORNECE
	cLoja	 := (cAliasSF1)->F1_LOJA
	cDoc	 := (cAliasSF1)->F1_DOC
	cPrefixo := If(Empty((cAliasSF1)->F1_PREFIXO),&(GetMV("MV_2DUPREF")),(cAliasSF1)->F1_PREFIXO)
	cSerie	 := (cAliasSF1)->F1_SERIE
	cDtEmis  := (cAliasSF1)->F1_EMISSAO
	nISS	 := (cAliasSF1)->F1_ISS
	nBasePis := (cAliasSF1)->F1_BASIMP6
	nValPis  := (cAliasSF1)->F1_VALIMP6
	nBaseCof := (cAliasSF1)->F1_BASIMP5
	nValCof  := (cAliasSF1)->F1_VALIMP5

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cabecalho 			  	                                        	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oCabec:Init(.F.)
	oCabec:PrintLine()
	oCabec:Finish()
	oReport:FatLine()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Dados do Boletim		  	                                        	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:PrintLine()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Dados da Empresa		  	                                        	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oEmpresa:Init(.f.) 
	oEmpresa:PrintLine()
	oEmpresa:Finish()
	oReport:FatLine()

	If (cAliasSF1)->F1_TIPO $ "DB"
		dbSelectArea("SE1")
		dbSetOrder(2)
		dbSeek(xFilial("SE1")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA+(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_DOC)
		While !Eof() .And. E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM == ;
			xFilial("SE1")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA+(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_DOC
			If ALLTRIM(E1_ORIGEM)=="MATA100"
				aADD(aVencto,E1_VENCREA)
			EndIf
			dbSkip()
		EndDo

		oReport:PrintText(STR0078) //"Dados do Cliente"
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)
		oClient1:Init(.F.) 
		oClient1:PrintLine()
		oClient2:Init(.F.) 
		oClient2:PrintLine()
		oClient2:Finish()
		oClient1:Finish()
	Else
		dbSelectArea("SE2")
		dbSetOrder(6)
		dbSeek(xFilial("SE2")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA+cPrefixo+(cAliasSF1)->F1_DOC)
		While !Eof() .And. E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM == ;
			xFilial("SE2")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA+cPrefixo+(cAliasSF1)->F1_DOC
			If ALLTRIM(E2_ORIGEM)=="MATA100"
				aADD(aVencto,E2_VENCTO)
			EndIf
			dbSkip()
		EndDo

		oReport:PrintText(STR0066) //"Dados do Fornecedor"
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)
		nCell := Len(AllTrim(RetTitle("A2_CGC"))+': '+If(cPaisLoc<>"BRA",Transform(SA2->A2_CGC,PesqPict("SA2","A2_CGC")),Transform(SA2->A2_CGC,PicPesFJ(If(Len(AllTrim(SA2->A2_CGC))<14,"F","J")))))
		oFornec1:Init(.f.) 
		oFornec1:PrintLine()
		oFornec2:Init(.f.) 
		oFornec2:PrintLine()
		oFornec2:Finish()
		oFornec1:Finish()
	EndIf
	oReport:FatLine()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho da Nota de Entrada                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SkipLine()
	oReport:PrintText(STR0006) // "------------------------------------------------------- DADOS DA NOTA FISCAL -------------------------------------------------------"
	oNF:Init(.t.) 
	If SF1->(ColumnPos("F1_TPCOMPL")) > 0 .And. (cAliasSF1)->F1_TIPO == "C" .And. !Empty((cAliasSF1)->F1_TPCOMPL)
		oNF:Cell("F1_TIPO"):SetValue(aCombo1[aScan(aAuxCombo1,(cAliasSF1)->F1_TPCOMPL)])
	Else
		oNF:Cell("F1_TIPO"):SetValue(aCombo1[aScan(aAuxCombo1,(cAliasSF1)->F1_TIPO)])
	EndIf
	oNF:PrintLine()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos itens da Nota de Entrada                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasSD1)
	nDocAnt := D1_DOC+D1_SERIE
	cForAnt := D1_FORNECE+D1_LOJA

	oNFItem:Init(.t.) 
	While (!oReport:Cancel() .And. !Eof() .And. (cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE == nDocAnt .And.;
		cForAnt == (cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA .And. (cAliasSD1)->D1_FILIAL == xFilial("SD1") )
		If oReport:Cancel()
			Exit
		EndIf
		aArea := GetArea()
		If !lQuery
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4")+(cAliasSD1)->D1_TES)
		EndIf
		cPedido   := (cAliasSD1)->D1_PEDIDO
		cItemPed  := (cAliasSD1)->D1_ITEMPC			
		
		If cPaisLoc <> "BRA" .And. !Empty((cAliasSD1)->D1_REMITO)
			cRemito   := (cAliasSD1)->D1_REMITO
			cItemRem  := (cAliasSD1)->D1_ITEMREM
			cSerieRem := (cAliasSD1)->D1_SERIREM
			cFornRem  := (cAliasSD1)->D1_FORNECE
			cLojaRem  := (cAliasSD1)->D1_LOJA
			cCodRem	  := (cAliasSD1)->D1_COD
            
			dbSelectArea("SD1")
			SD1->(dbSetOrder(1))
			If SD1->(dbSeek(xFilial("SD1")+cRemito+cSerieRem+cFornRem+cLojaRem+cCodRem+Alltrim(cItemRem))) 
				If !Empty(SD1->D1_PEDIDO)
					cPedido   := SD1->D1_PEDIDO
					cItemPed  := SD1->D1_ITEMPC						
				Endif	
			Endif
			RestArea(aArea)
		Endif
		
		dbSelectArea("SC7")
		dbSetOrder(19)
		dbSeek(xFilial("SC7")+(cAliasSD1)->D1_COD+cPedido+cItemPed)
		If Empty(SC7->C7_NUM)
			aADD(aDivergencia,STR0079) //"Err"
			aADD(aPedidos,{"",STR0014,"","","","","","","","",""}) //"Sem Pedido de Compra"
		Else
			dbSelectArea("SC1")
			dbSetOrder(2)
			dbSeek(xFilial("SC1")+SC7->C7_PRODUTO+SC7->C7_NUMSC+SC7->C7_ITEMSC)
			dbSelectArea("SE4")
			dbSetOrder(1)
			dbSeek(xFilial("SE4")+SC7->C7_COND)
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)
			cDescEm := POSICIONE("SB1",1,xFilial("SB1")+SB1->B1_VQ_EM,"B1_DESC")
			lPedCom := !Empty(IF(SC7->C7_TIPO == 1,SubStr(SC1->C1_SOLICIT,1,15), SubStr(UsrFullName(SC7->C7_USER),1,15))+SC7->C7_CC)
			cProblema := ""
			If ( (cAliasSD1)->D1_QTDPEDI > 0 .And. (SC7->C7_QUANT <> (cAliasSD1)->D1_QTDPEDI) ) .Or. ;
				SC7->C7_QUANT <> (cAliasSD1)->D1_QUANT
				cProblema += "Q"
			Else
				cProblema += " "
			EndIf
			If (SC7->C7_QUANT - SC7->C7_QUJE) < (cAliasSD1)->D1_QUANT  .AND. (cAliasSD1)->D1_TES == "   "
				n_proc1 :=-((cAliasSD1)->D1_QUANT - (SC7->C7_QUANT - SC7->C7_QUJE)) / SC7->C7_QUANT * 100
			EndIf
			If (cAliasSD1)->D1_TES != "   " .AND. (SC7->C7_QUANT - SC7->C7_QUJE) < 0
				N_PORC1 :=-(SC7->C7_QUANT - SC7->C7_QUJE) / SC7->C7_QUANT * 100
			EndIf
			If If(Empty(SC7->C7_REAJUST),SC7->C7_PRECO,Formula(SC7->C7_REAJUST)) # (cAliasSD1)->D1_VUNIT
				If SC7->C7_MOEDA <> 1
					cProblema := cProblema+"M"
				Else
					cProblema := cProblema+"P"
				EndIf
			Else
				cProblema := cProblema+" "
			EndIf
			If SC7->C7_DATPRF <> (cAliasSD1)->D1_DTDIGIT
				cProblema := cProblema+"E"
			Else
				cProblema := cProblema+" "
			EndIf
			If !Empty(cProblema)
				aADD(aDivergencia,cProblema)
			Else
				aADD(aDivergencia,"Ok ")
			Endif
			aADD(aPedidos,{SC7->C7_NUM+"/"+SC7->C7_ITEM,;
				SC7->C7_DESCRI,;
				TransForm(SC7->C7_QUANT,PesqPict("SC7","C7_QUANT",11)),;
				TransForm(SC7->C7_PRECO,PesqPict("SC7","C7_PRECO",13)),;
				DTOC(SC7->C7_EMISSAO),;
				DTOC(SC7->C7_DATPRF),;
				SC7->C7_NUMSC+"/"+SC7->C7_ITEMSC,;      
				If(lPedCom,IF(SC7->C7_TIPO == 1,SubStr(SC1->C1_SOLICIT,1,15), SubStr(UsrFullName(SC7->C7_USER),1,15)),"") ,;
				If(lPedCom,SC7->C7_CC,""),;
				AllTrim(SE4->E4_DESCRI),;
				cDescEm} )
		Endif
		If !Empty((cAliasSD1)->D1_NUMCQ) .AND. (cAliasSF4)->F4_ESTOQUE == "S"
			AADD(aCQ,(cAliasSD1)->D1_NUMCQ+(cAliasSD1)->D1_COD+cLocDest+"001"+Dtos((cAliasSD1)->D1_DTDIGIT))
		Endif
		dbSelectArea(cAliasSD1)
		oNFItem:PrintLine()

		// Entidades Contabeis
		If ( mv_par05 == 3 )
			If ( (cAliasSD1)->D1_RATEIO == "1" )
				dbSelectArea("SDE")
				dbSetOrder(1)
				If MsSeek(xFilial("SDE")+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_ITEM)
					While !Eof() .And. DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA+DE_ITEMNF ==;
						xFilial("SDE")+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_ITEM
						aAdd(aEntCont,{SDE->DE_ITEMNF,SDE->DE_ITEM,Transform(SDE->DE_PERC,"@E 999.99"),SDE->DE_CC,SDE->DE_CONTA,SDE->DE_ITEMCTA,SDE->DE_CLVL})
						dbSkip()
					EndDo
				EndIf
			Else
				If !Empty((cAliasSD1)->D1_CC) .Or. !Empty((cAliasSD1)->D1_CONTA) .Or. !Empty((cAliasSD1)->D1_ITEMCTA)
					aAdd(aEntCont,{(cAliasSD1)->D1_ITEM," - ","   -  ",(cAliasSD1)->D1_CC,(cAliasSD1)->D1_CONTA,(cAliasSD1)->D1_ITEMCTA,(cAliasSD1)->D1_CLVL})
				EndIf
			EndIf
		EndIf
		dbSelectArea(cAliasSD1)
		dbSkip()
	EndDo
	oNFItem:Finish()   
	oNF:Finish()   
	oReport:FatLine()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Entidades Contabeis ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aEntCont) > 0
		oReport:SkipLine()
		oReport:PrintText(STR0061)  //"------------------------------------------------------- ENTIDADES CONTABEIS ---------------------------------------------------------"
		oEntCtb:Init() 
		For nX:=1 to Len(aEntCont)
			oEntCtb:Cell("DEITEMNF"):SetValue(aEntCont[nX][1])
			oEntCtb:Cell("DEITEM"):SetValue(aEntCont[nX][2])
			oEntCtb:Cell("DEPERC"):SetValue(aEntCont[nX][3])
			oEntCtb:Cell("DECC"):SetValue(aEntCont[nX][4])
			oEntCtb:Cell("DECONTA"):SetValue(aEntCont[nX][5])
			oEntCtb:Cell("DEITEMCTA"):SetValue(aEntCont[nX][6])
			oEntCtb:Cell("DECLVL"):SetValue(aEntCont[nX][7])
			oEntCtb:PrintLine()
		Next
		oEntCtb:Finish() 
		oReport:FatLine()
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime produtos enviados ao Controle de Qualidade SD7       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aCQ) > 0
		oReport:SkipLine()
		oReport:PrintText(STR0015)//"------------------------------------------- PRODUTO(s) ENVIADO(s) AO CONTROLE DE QUALIDADE -----------------------------------------"
		lFirst := .T.
		For nX:=1 to Len(aCQ)
			dbSelectArea("SD7")
			dbSetOrder(1)
			If dbSeek(xFilial("SD7")+aCQ[nX])
				If lFirst
					oQuali:Init() 
					lFirst := .F.
					lQuali := .T.
				EndIf
				oQuali:Cell("D7PRODUTO"):SetValue(SD7->D7_PRODUTO)
				oQuali:Cell("D7LOCAL"):SetValue(SD7->D7_LOCAL)
				oQuali:Cell("D7LOCDEST"):SetValue(SD7->D7_LOCDEST)
				oQuali:Cell("D7DATA"):SetValue(SD7->D7_DATA)
				oQuali:Cell("D7NUMERO"):SetValue(SD7->D7_NUMERO)
				oQuali:PrintLine()
			EndIf
		Next
		If lQuali
			oQuali:Finish() 
			oReport:FatLine()
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Divergencia com Pedido de Compra                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aPedidos) .And. !Empty(aDivergencia)
		oReport:SkipLine()
		oReport:PrintText(STR0019)  //"--------------------------------------------- DIVERGENCIAS COM O PEDIDO DE COMPRA --------------------------------------------------"
		oDivPC:Init()  
		dbSelectArea("SC7")
		dbSetOrder(1)
		For nX := 1 To Len(aPedidos) 
			dbSeek(xFilial("SC7")+Substr(aPedidos[nX][1],1,len(SC7->C7_NUM))+Substr(aPedidos[nX][1],len(SC7->C7_NUM)+2,len(SC7->C7_ITEM)))
			oDivPC:Cell("DivPC"):SetValue(aDivergencia[nX])
			oDivPC:Cell("C7NUM"):SetValue(aPedidos[nX][1])
			oDivPC:Cell("C7DESCRI"):SetValue(aPedidos[nX][2])
			oDivPC:Cell("DESCEMB"):SetValue(aPedidos[nX][11])
			oDivPC:Cell("C7QUANT"):SetValue(aPedidos[nX][3])
			oDivPC:Cell("C7PRECO"):SetValue(aPedidos[nX][4])
			oDivPC:Cell("C7EMISSAO"):SetValue(aPedidos[nX][5])
			oDivPC:Cell("C7DATPRF"):SetValue(aPedidos[nX][6])
			//oDivPC:Cell("C7NUMSC"):SetValue(aPedidos[nX][7])
			oDivPC:Cell("C1SOLICIT"):SetValue(aPedidos[nX][8])
			oDivPC:Cell("C1CC"):SetValue(aPedidos[nX][9])
			oDivPC:Cell("E4DESCRI"):SetValue(aPedidos[nX][10])
			oDivPC:PrintLine()
		Next
		oDivPC:Finish()
		oReport:FatLine()
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Totais da Nota Fiscal                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SkipLine()
	oReport:PrintText(STR0023) //"------------------------------------------------------- TOTAIS DA NOTA FISCAL ------------------------------------------------------"
	oNFTot1:Init() 
	If cPaisLoc=="BRA"
		oNFTot1:Cell("F1_BASEICM"):SetValue(aTotalNF[1])
		oNFTot1:Cell("F1_VALICM"):SetValue(aTotalNF[2])
		oNFTot1:Cell("F1_ICMSRET"):SetValue(aTotalNF[3])
	EndIf
	oNFTot1:Cell("F1_VALMERC"):SetValue(aTotalNF[4])
	oNFTot1:Cell("F1_DESCONT"):SetValue(aTotalNF[5])
	oNFTot1:PrintLine() 
	oReport:ThinLine()
	oNFTot2:Init() 
	oNFTot2:Cell("F1_FRETE"):SetValue(aTotalNF[6])
	oNFTot2:Cell("F1_SEGURO"):SetValue(aTotalNF[7])
	oNFTot2:Cell("F1_DESPESA"):SetValue(aTotalNF[8])
	If cPaisLoc=="BRA"
		oNFTot2:Cell("F1_VALIPI"):SetValue(aTotalNF[9])
	EndIf
	oNFTot2:Cell("F1_VALBRUT"):SetValue(aTotalNF[10])
	oNFTot2:PrintLine() 
	oNFTot2:Finish()
	oNFTot1:Finish()
	oReport:FatLine()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime desdobramento de Duplicatas                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder(6)
	
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega array conforme parâmetros                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nCT == 0
		aFornece := {{cFornece,cLoja,PadR(MVNOTAFIS,Len(SE2->E2_TIPO))},;
			    	{PadR(GetMv('MV_UNIAO')        ,Len(SE2->E2_FORNECE)),PadR(Replicate('0',Len(SE2->E2_LOJA)),Len(SE2->E2_LOJA)),PadR(MVTAXA,Len(SE2->E2_TIPO)) },;
					{PadR(GetMv('MV_FORINSS')      ,Len(SE2->E2_FORNECE)),PadR('00',Len(SE2->E2_LOJA)),PadR(MVINSS,Len(SE2->E2_TIPO))},;
					{PadR(GetMv('MV_MUNIC')        ,Len(SE2->E2_FORNECE)),PadR('00',Len(SE2->E2_LOJA)),PadR(MVISS ,Len(SE2->E2_TIPO))} }    
		
		nCT+=1		
	EndIf
	
	If dbSeek(xFilial("SE2")+cFornece+cLoja+cPrefixo+cDoc)
		nRec:=RECNO()
		oReport:SkipLine()
		oReport:PrintText(STR0026)//"--------------------------------------------------- DESDOBRAMENTO DE DUPLICATAS ----------------------------------------------------"
		oDupli:Init()
		
		//Verifica se o Fornecedor do Titulo ja existe no aFornec // 
		aAreaSE2 := SE2->(GetArea())
		dbSelectArea('SE2')
		dbSetOrder(9)
		IF dbSeek(xFilial("SE2")+cForMunic) 
	   		While !Eof().and. alltrim(SE2->E2_FORNECE) == alltrim(cForMunic)
	   		   	IF Ascan(aFornece,{|x| (alltrim(x[1])+alltrim(x[2])) == (alltrim(cForMunic)+alltrim(SE2->E2_LOJA))}) = 0
	   		 		aAdd(aFornece, {PadR(GetMv('MV_MUNIC'),Len(SE2->E2_FORNECE)),SE2->E2_LOJA,PadR(MVISS ,Len(SE2->E2_TIPO))} )
	   	   		EndIf
		  	 	DBSkip()
			EndDo 
		EndIF
		restArea(aAreaSE2)   			
		dbGoto(nRec) 

		While !Eof() .And. xFilial('SE2')+cFornece+cLoja+cPrefixo+cDoc==;
			E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM

			If SE2->E2_TIPO == aFornece[1,3]

				R170DupTR(oReport)
				cParcCSS := SE2->E2_PARCCSS
				cParcIR  := SE2->E2_PARCIR
				cParcINSS:= SE2->E2_PARCINS
				cParcISS := SE2->E2_PARCISS
				cParcCof := SE2->E2_PARCCOF
				cParcPis := SE2->E2_PARCPIS
				cParcCsll:= SE2->E2_PARCSLL
				cParcSest:= SE2->E2_PARCSES
				If !Empty(SE2->E2_FORNISS) .And. !Empty(SE2->E2_LOJAISS)
					cFornIss := SE2->E2_FORNISS
					cLojaIss := SE2->E2_LOJAISS
				Else
					cFornIss := aFornece[4,1]
					cLojaIss :=	aFornece[4,2]
				Endif				
				
				nRecno   := SE2->(Recno())

				dbSelectArea('SE2')
				dbSetOrder(1)
				If (!Empty(cParcIR)).And.dbSeek(xFilial('SE2')+cPrefixo+cDoc+cParcIR+aFornece[2,3]+aFornece[2,1]+aFornece[2,2])
					R170DupTR(oReport)
				Endif
				If (!Empty(cParcINSS)).And.dbSeek(xFilial('SE2')+cPrefixo+cDoc+cParcINSS+aFornece[3,3])
					R170DupTR(oReport)
				Endif                 
				         
				For i=1 to Len(aFornece)
					If AllTrim(aFornece[i,1])==alltrim(cForMunic)
						If (!Empty(cParcISS)).And.dbSeek(xFilial('SE2')+cPrefixo+cDoc+cParcISS+aFornece[i,3]+cFornIss+aFornece[i,2])
						    IF cDtEmis == SE2->E2_EMISSAO
								R170DupTR(oReport)
						   	EndIf
						EndIf
					EndIf   
				Next i
				
				If (!Empty(cParcCof)).And.dbSeek(xFilial('SE2')+cPrefixo+cDoc+cParcCof+aFornece[2,3])
					R170DupTR(oReport)
				Endif
				If (!Empty(cParcPis)).And.dbSeek(xFilial('SE2')+cPrefixo+cDoc+cParcPis+aFornece[2,3])
					R170DupTR(oReport)
				Endif
				If (!Empty(cParcCsll)).And.dbSeek(xFilial('SE2')+cPrefixo+cDoc+cParcCsll+aFornece[2,3])
					R170DupTR(oReport)
				Endif

				If (!Empty(cParcCSS)).And.dbSeek(xFilial('SE2')+cPrefixo+cDoc+cParcCSS+aFornece[2,3])
					While !Eof() .And. xFilial('SE2')+cPrefixo+cDoc+cParcCSS+aFornece[2,3] ==;
							SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO

						If PadR(GetMv('MV_CSS'),Len(SE2->E2_NATUREZ)) == SE2->E2_NATUREZ
							R170DupTR(oReport)
						EndIf

						dbSelectArea('SE2')
						dbSetOrder(1)
						dbSkip()
					EndDo
				Endif
				If (!Empty(cParcSest)).And.dbSeek(xFilial('SE2')+cPrefixo+cDoc+cParcSest+aFornece[5,3])
					R170DupTR(oReport)
				Endif				

				SE2->(dbGoto(nRecno))

			EndIf

			dbSelectArea('SE2')
			dbSetOrder(6)
			dbSkip()
		EndDo
		oDupli:Finish()
		oReport:FatLine()
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Dados dos Livros Fiscais                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisloc=="BRA"                                             
		dbSelectArea("SF3")
		dbSetOrder(4)
		If dbSeek(xFilial("SF3")+cFornece+cLoja+cDoc+cSerie)
            lFirst := .T.
			While ! Eof() .And. xFilial("SF3")+cFornece+cLoja+cDoc+cSerie==F3_FILiAL+F3_CLiEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE

				If Val(Substr(SF3->F3_CFO,1,1))<5

					If lFirst
						oReport:SkipLine()
						oReport:PrintText(STR0030) //"----------------------------------------------- DEMONSTRATIVO DOS LIVROS FISCAIS ---------------------------------------------------"
						oFisc1:Init(.t.) 
						lFirst := .F.
					EndIf
					oFisc1:Cell("IMP1"):SetValue(If(!Empty(nISS) .And. SF3->F3_TIPO == "S" ,STR0087,STR0088)) //"ISS"##"ICMS"
					oFisc1:Cell("CFOP"):SetValue(SF3->F3_CFO)
					oFisc1:Cell("ALIQ"):SetValue(SF3->F3_ALIQICM)
					oFisc1:Cell("BASEIMP1"):SetValue(SF3->F3_BASEICM)
					oFisc1:Cell("VALIMP1"):SetValue(SF3->F3_VALICM)
					oFisc1:Cell("ISENTAS1"):SetValue(SF3->F3_ISENICM)
					oFisc1:Cell("OUTRAS1"):SetValue(SF3->F3_OUTRICM)
					oFisc1:Cell("OBS1"):SetValue("")
					oFisc1:PrintLine()
					If !Empty(SF3->F3_ICMSRET)
						oReport:PrintText(STR0080+Transform(SF3->F3_ICMSRET,"@E 9,999,999,999.99"), oReport:Row() ,oFisc1:Cell("OBS1"):ColPos() ) //"RET  "
						oReport:SkipLine()
					Endif
					If !EMPTY(SF3->F3_ICMSCOM)
						oReport:PrintText(STR0081+Transform(SF3->F3_ICMSCOM,"@E 9,999,999,999.99"), oReport:Row() ,oFisc1:Cell("OBS1"):ColPos() ) //"Compl"
						oReport:SkipLine()
					Endif
					If !Empty(SF3->F3_BASEIPI) .Or. !Empty(SF3->F3_ISENIPI) .Or. !Empty(SF3->F3_OUTRIPI)
						oFisc1:Cell("IMP1"):SetValue(STR0086) //"IPI"
	   					oFisc1:Cell("CFOP"):SetValue("")
						oFisc1:Cell("ALIQ"):SetValue(Posicione("SD1",1,xFilial("SD1")+nDocAnt+cForAnt,"D1_IPI"))
						oFisc1:Cell("BASEIMP1"):SetValue(SF3->F3_BASEIPI)
						oFisc1:Cell("VALIMP1"):SetValue(SF3->F3_VALIPI)
						oFisc1:Cell("ISENTAS1"):SetValue(SF3->F3_ISENIPI)
						oFisc1:Cell("OUTRAS1"):SetValue(SF3->F3_OUTRIPI)
						oFisc1:Cell("OBS1"):SetValue("")
						oFisc1:PrintLine()
					Endif	
					If ! Empty(SF3->F3_VALOBSE)
						oReport:PrintText(STR0082+Transform(SF3->F3_VALOBSE,"@E 9,999,999,999.99"), oReport:Row() ,oFisc1:Cell("OBS1"):ColPos() ) //"OBS. "
						oReport:SkipLine()
					Endif
				Endif

				dbSkip()
			EndDo
			If ! lFirst
				oFisc1:Finish()
				oReport:FatLine()
			EndIf

		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Dados dos Demais Impostos                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport:SkipLine()
		If !Empty(nValPis) .Or. !Empty(nValCof)
			oReport:PrintText(STR0059) //  "----------------------------------------------- DEMONSTRATIVO DOS DEMAIS IMPOSTOS ---------------------------------------------------"
			oFisc2:Init(.t.)
			If !Empty(nValPis)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime Dados ref ao PIS                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oFisc2:Cell("IMP2"):SetValue(STR0083) //"PIS APURACAO"
				oFisc2:Cell("BASEIMP2"):SetValue(nBasePis)
				oFisc2:Cell("VALIMP2"):SetValue(nValPis)
				oFisc2:PrintLine()
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime Dados ref ao COFINS                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(nValCof)
				oFisc2:Cell("IMP2"):SetValue(STR0084) //"COFINS APURACAO"
				oFisc2:Cell("BASEIMP2"):SetValue(nBaseCof)
				oFisc2:Cell("VALIMP2"):SetValue(nValCof)
				oFisc2:PrintLine()
			Endif
			oFisc2:Finish()
			oReport:FatLine()
		EndIf
    Else
    	If Len(aItens[1])>=0
			oReport:SkipLine()
			oReport:PrintText(STR0042) //"-----------------------------------------------   RELACAO DE IMPOSTOS POR ITEM   ---------------------------------------------------"
			oFisc3:Init(.t.) 
			For nImp:=1 to Len(aItens)
				oFisc3:Cell("PRO3"):SetValue(aItens[nImp][1])
				oFisc3:Cell("DESC3"):SetValue(aItens[nImp][2])
				oFisc3:Cell("IMP3"):SetValue(aItens[nImp][3])
				oFisc3:Cell("ALI3"):SetValue(aItens[nImp][4])
				oFisc3:Cell("BASEIMP3"):SetValue(aItens[nImp][5])
				oFisc3:Cell("VALORIMP3"):SetValue(aItens[nImp][6])
				oFisc3:PrintLine()
			Next
			oFisc2:Finish()
			oReport:FatLine()
		Endif
	EndIf
	oReport:SkipLine(4)
/*
	oReport:PrintText(STR0033)//"------------------------------------------------------------------- VISTOS ---------------------------------------------------------"
	oReport:PrintText("|                               |                                |                                  |                              |")
	oReport:PrintText(STR0034) //"| Recebimento  Fiscal           | Contabil/Custos                | Departamento Fiscal              | Administracao                |"
	oReport:ThinLine()
*/
	dbSelectArea(cAliasSF1)
	If !lQuery
		dbSkip()
	EndIf
	oReport:IncMeter()
	oSection1:Finish()  

	If !lAuto .And. (cAliasSF1)->(!Eof())
		oReport:EndPage()     
	Endif	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original dos arquivos		             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaSF3)
RestArea(aAreaSF1)
RestArea(aAreaSE2)
RestArea(aAreaSC7)

If !lAuto .And. !lQuery
	dbSelectArea("SD1")
	RetIndex("SD1")
	If File(cArqIndSD1+ OrdBagExt())
		FErase(cArqIndSD1+ OrdBagExt() )
	EndIf
EndIf

Return NIL



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRoda  ³ Autor ³ Ricardo Berti         ³ Data ³09.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Desdobramento de duplicatas					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRoda(ExpO1)						                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1: obj Report										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum					   								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR170                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpRoda(oReport)

oReport:PrintText(STR0033) //"------------------------------------------------------------------- VISTOS ---------------------------------------------------------"
oReport:PrintText("|                               |                                |                                  |                              |")
oReport:PrintText(STR0034) //"| Recebimento  Fiscal           | Contabil/Custos                | Departamento Fiscal              | Administracao                |"
oReport:ThinLine()
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R170DupTR³ Autor ³ Ricardo Berti         ³ Data ³05.07.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Desdobramento de duplicatas					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R170DupTR(ExpO1)						                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1: obj Report										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum					   								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR170                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R170DupTR(oReport)

Local oDupli := oReport:Section(1):Section(14)
oDupli:Cell("E2PREFIXO"):SetValue(SE2->E2_PREFIXO)
oDupli:Cell("E2NUM"):SetValue(SE2->E2_NUM)
oDupli:Cell("E2PARCELA"):SetValue(SE2->E2_PARCELA)
oDupli:Cell("E2VENCTO"):SetValue(SE2->E2_VENCTO)
oDupli:Cell("E2VALOR"):SetValue(SE2->E2_VALOR)
oDupli:Cell("E2NATUREZ"):SetValue(SE2->E2_NATUREZ)
oDupli:PrintLine()
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³R170IMPT  ºAuthor ³Armando P. Waiteman º Date ³  08/07/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a somatoria dos impostos da nota. Retornando um array   º±±
±±º          ³com todas as informacoes a serem impressas                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR170                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R170IMPT(cAliasSF1)


Local aArea    := {}
Local aAreaSD1 := {}
Local aImp     := {}
Local aImpostos:= {}
Local nImpos:= 0
Local nBase := 0
Local nY,cCampImp,cCampBas

aArea:=GetArea()


dbSelectArea("SD1")
aAreaSD1:=GetArea()

dbSetOrder(3)

cSeek:=(xFilial("SD1")+Dtos((cAliasSF1)->F1_EMISSAO)+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE+;
	(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)

If dbSeek(cSeek)
	While cSeek==xFilial("SD1")+dtos(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
		if empty(TesImpInf(D1_TES))        
			exit
		endif
		aImpostos:=TesImpInf(D1_TES)
		For nY:=1 to Len(aImpostos)
			cCampImp:="SD1->"+(aImpostos[nY][2])
			cCampBas:="SD1->"+(aImpostos[nY][7])
			nImpos+=&cCampImp
		Next
		nBase +=&cCampBas
		dbSkip()	
	Enddo
EndIf

RestArea(aAreaSD1)
RestArea(aArea)

AADD(aImp,nBase)
AADD(aImp,nImpos)


Return aImp

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³R170IMPI  ºAuthor ³Armando P. Waiteman º Date ³  08/07/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna array com lista de impostos por item                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR170                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R170IMPI(cAliasSF1)


Local aArea    := {}
Local aAreaSD1 := {}
Local aImp     := {}
Local aRet     := {}
Local nY

aArea:=GetArea()


dbSelectArea("SD1")
aAreaSD1:=GetArea()

dbSetOrder(3)

cSeek:=(xFilial("SD1")+Dtos((cAliasSF1)->F1_EMISSAO)+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE+;
	(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)

If dbSeek(cSeek)
	While cSeek==xFilial("SD1")+dtos(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
		aImp:=TesImpInf(D1_TES)

		// Pega a descricao do produto
		dbSelectArea("SB1")
		aAreaSB1:=GetArea()
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD1->D1_COD)
		cDescProd:=B1_DESC
		RestArea(aAreaSB1)

		dbSelectArea("SD1")
		For nY:=1 to Len(aImp)
			AADD(aRet,{SD1->D1_COD,cDescProd,aImp[nY][1],&("SD1->"+aImp[nY][10]),&("SD1->"+(aImp[nY][7])),&("SD1->"+(aImp[nY][2]))})
		Next
		dbSkip()
	Enddo
EndIf

If Len(aRet)<= 0
	AADD(aRet,{"" ,"" ,"" ,0 ,0 ,0})
EndIf

RestArea(aAreaSD1)
RestArea(aArea)

Return aRet
