#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#define STR0001 "Relacao de Pedidos nao entregues"
#define STR0002 "Este programa ira emitir a relacao dos Pedidos Pendentes,"
#define STR0003 "imprimindo o numero do Pedido, Cliente, Data da Entrega, "
#define STR0004 "Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
#define STR0005 "Zebrado"
#define STR0006 "Administracao"
#define STR0007 "Por Pedido"
#define STR0008 "Por Produto"
#define STR0009 "Por Cliente"
#define STR0010 "Por Dt.Entrega"
#define STR0011 "NUMERO DATA DE    CODIGO LOJA /NOME DO CLIENTE                       IT CODIGO DO       DESCRICAO DO                   DATA DE         QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
#define STR0012 "PEDIDO EMISSAO                                                          PRODUTO         MATERIAL                       ENTREGA         PEDIDA       ENTREGUE     PENDENTE        PENDENTE    "
#define STR0013 "CODIGO DO       DESCRICAO DO                   NUMERO IT DATA DE      DATA DE      CODIGO LOJA /NOME DO CLIENTE                        QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
#define STR0014 "PRODUTO         MATERIAL                       PEDIDO    EMISSAO      ENTREGA                                                          PEDIDA       ENTREGUE     PENDENTE        PENDENTE    "
#define STR0015 "Selecionando Registros..."
#define STR0016 "CODIGO-LOJA/NOME DO CLIENTE                        NUMERO IT DATA DE      CODIGO DO        DESCRICAO DO                   DATA DE      QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
#define STR0017 "                                                   PEDIDO    EMISSAO      PRODUTO          MATERIAL                       ENTREGA      PEDIDA       ENTREGUE     PENDENTE        PENDENTE    "
#define STR0018 " - Por Data de Entrega"
#define STR0019 " DATA DE      NUMERO DATA DE      CODIGO LOJA /NOME DO CLIENTE                       IT CODIGO DO       DESCRICAO DO                   QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
#define STR0020 " ENTREGA      PEDIDO EMISSAO                                                            PRODUTO         MATERIAL                       PEDIDA       ENTREGUE     PENDENTE        PENDENTE    "
#define STR0021 "CANCELADO PELO OPERADOR"
#define STR0022 "Por Vendedor"
#define STR0023 "CODIGO VENDEDOR                                 NUMERO IT  DATA DE      CODIGO DO       DESCRICAO DO                   DATA DE         QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
#define STR0024 "                                                PEDIDO     EMISSAO      PRODUTO         MATERIAL                       ENTREGA         PEDIDA       ENTREGUE     PENDENTE        PENDENTE    "
#define STR0025 "TOTAL --------->"
#define STR0026 "TOTAL GERAL --->"
#define STR0027 "Relacao de Pedidos nao entregues"
#define STR0028 "Este programa ira emitir a relacao dos Pedidos Pendentes,"
#define STR0029 "imprimindo o numero do Pedido, Cliente, Data da Entrega, "
#define STR0030 "Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
#define STR0031 "Total do Pedido"
#define STR0032 "Total do Produto"
#define STR0033 "Total do Cliente"
#define STR0034 "Total da Dt.Entrega"
#define STR0035 "Total do Vendedor"
#define STR0036 "Quant.Pendente"
#define STR0037 "ValorTotal Pendente"
#define STR0038 "Gerando Tabela de Trabalho. Aguarde..."
#define STR0039 "TOTAL ----->"
#define STR0040 "Selecionando Registros..."
#define STR0041 "Por Pedido"
#define STR0042 "Por Produto"
#define STR0043 "Por Cliente"
#define STR0044 "Por Data"
#define STR0045 "Por Vendedor"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RMATR680 ³ Autor ³ Robson Sanchez        ³ Data ³ 23/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Pedidos nao entregues                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT - R4                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RMATR680()

Local oReport

oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RMATR680" , __cUserID )

PRIVATE nTamRef := Val(Substr(GetMv("MV_MASCGRD"),1,2))
PRIVATE cGrpAcesso:=""

//cGrpAcesso:= U_ChkRegConfid()   // Retorna todos os segmentos aos quais os usuarios Tem acesso
  
cGrpAcesso:= U_GrpsAcesso(__cUserId)

If Empty(cGrpAcesso)
   MsgStop("USUARIO SEM PERMISSAO - REGRA DE CONFIDENCIALIDADE","Atenção")
   Return 
Endif

oReport := ReportDef()
oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marco Bianchi         ³ Data ³ 04/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oPedNEnt
Local oProduto
Local oCliente
Local oData
Local oVendedor

Local nSaldo := 0
Local nValor := 0
Local nTotVen := 0
Local nTotEnt := 0
//Local cPerg	 :=	IIf(cPaisLoc == "BRA","MTR680","MR680A")
Local cPerg	 :=	"RMTR680"
Local nTamData  := Len(DTOC(MsDate()))


#IFNDEF TOP
	Local cCondicao := ""
	Local cAliasQry := "SC6"
#ELSE
	Local cWhere	:= ""	
	Local cQueryAdd := ""
	Local cAliasQry := GetNextAlias()
#ENDIF

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
oReport := TReport():New("RMATR680",STR0027,cPerg, {|oReport| ReportPrint(oReport,cAliasQry,oPedNEnt,oProduto,oCliente,oData,oVendedor)},STR0028 + " " + STR0029 + " " + STR0030)	// "Relacao de Pedidos nao entregues"###"Este programa ira emitir a relacao dos Pedidos Pendentes,"###"imprimindo o numero do Pedido, Cliente, Data da Entrega, "###"Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

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
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Pedido                                                         	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPedNEnt := TRSection():New(oReport,STR0041,{"TRB","SC6","SA1","SA3","SF4"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// "Relacao de Pedidos nao entregues"###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oPedNEnt:SetTotalInLine(.F.)
TRCell():New(oPedNEnt,"NUM"			,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM																				})
TRCell():New(oPedNEnt,"EMISSAO"		,"TRB","Dt.Emissao"              ,"@D"							,TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO																			})
TRCell():New(oPedNEnt,"CLIENTE"		,"TRB",RetTitle("C6_CLI"		),PesqPict("SC6","C6_CLI"		),TamSx3("C6_CLI"		)[1],/*lPixel*/,{|| TRB->CLIENTE																			})
TRCell():New(oPedNEnt,"LOJA"		,"TRB",RetTitle("C6_LOJA"		),PesqPict("SC6","C6_LOJA"		),TamSx3("C6_LOJA"		)[1],/*lPixel*/,{|| TRB->LOJA 																				})
TRCell():New(oPedNEnt,"NOMECLI"		,"TRB",RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| TRB->NOMECLI																			})
TRCell():New(oPedNEnt,"ITEM"		,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																				})
TRCell():New(oPedNEnt,"PRODUTO1"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(oPedNEnt,"PRODUTO2"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oPedNEnt,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),90						,/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oPedNEnt,"STATUS"    	,"TRB","Status"					 ,"@!"							 ,10						,/*lPixel*/,{|| TRB->STATUS																				})
TRCell():New(oPedNEnt,"XMOEDA"    	,"TRB",RetTitle("C6_XDESMOE"	),PesqPict("SC6","C6_XDESMOE"	),TamSx3("C6_XDESMOE"	)[1],/*lPixel*/,{|| TRB->XMOEDA																				})
TRCell():New(oPedNEnt,"PRCUNIT"		,"TRB","Prc.Unit",PesqPict("SC6","C6_XPRUNIT"	),TamSx3("C6_XPRUNIT"	)[1],/*lPixel*/,{|| TRB->PRCUNIT																			})

// Quando nome da celular nao e do SX3 e o campo for do tipo Data, o tamanho deve ser preenchido com
// Len(DTOC(MsDate())), para que nao haja problema na utilizacao de ano com 4 digitos.
TRCell():New(oPedNEnt,"DATENTR"		,"TRB","DtEntrega"				,"@D"							,TamSx3("C6_ENTREG"	)[1],/*lPixel*/ ,{|| TRB->DATENTR			})	// Data de Entrega
TRCell():New(oPedNEnt,"QUANTIDADE1"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(oPedNEnt,"QUANTIDADE2"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| TRB->QUANTIDADE							})
TRCell():New(oPedNEnt,"ENTREGUE1"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nTotEnt							})
//TRCell():New(oPedNEnt,"ENTREGUE2"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| TRB->ENTREGUE							})
//TRCell():New(oPedNEnt,"NSALDO"		,	  ,STR0036					 ,PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oPedNEnt,"NVALOR"		,	  ,STR0037					 ,PesqPict("SC6","C6_VALOR"		),TamSx3("C6_VALOR"		)[1],/*lPixel*/,{|| nValor																						})	// "Valot Total Pendente"



	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Produto                                                       	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProduto := TRSection():New(oReport,STR0042,{"TRB","SC6","SA1","SA3","SF4"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// "Relacao de Pedidos nao entregues"###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oProduto:SetTotalInLine(.F.)

TRCell():New(oProduto,"PRODUTO1"		,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(oProduto,"PRODUTO2"		,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oProduto,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	)	,90						,/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oProduto,"STATUS"    	,"TRB","Status"					 ,"@!"							 ,10						,/*lPixel*/,{|| TRB->STATUS																				})
TRCell():New(oProduto,"XMOEDA"    	,"TRB",RetTitle("C6_XDESMOE"	),PesqPict("SC6","C6_XDESMOE"	),TamSx3("C6_XDESMOE"	)[1],/*lPixel*/,{|| TRB->XMOEDA																				})
TRCell():New(oProduto,"PRCUNIT"		,"TRB","Prc.Unit",PesqPict("SC6","C6_XPRUNIT"	),TamSx3("C6_XPRUNIT"	)[1],/*lPixel*/,{|| TRB->PRCUNIT																			})
TRCell():New(oProduto,"NUM"			,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM 																				})
TRCell():New(oProduto,"ITEM"		,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																				})
TRCell():New(oProduto,"EMISSAO"		,"TRB","Dt.Emissao"              ,"@D"							,TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO																			})
TRCell():New(oProduto,"DATENTR"		,"TRB","DtEntrega"				,"@D"							,TamSx3("C6_ENTREG"	)[1],/*lPixel*/ ,{|| TRB->DATENTR			})	// Data de Entrega
TRCell():New(oProduto,"CLIENTE"		,"TRB",RetTitle("C6_CLI"		),PesqPict("SC6","C6_CLI"		),TamSx3("C6_CLI"		)[1],/*lPixel*/,{|| TRB->CLIENTE 																			})
TRCell():New(oProduto,"LOJA"		,"TRB",RetTitle("C6_LOJA"		),PesqPict("SC6","C6_LOJA"		),TamSx3("C6_LOJA"		)[1],/*lPixel*/,{|| TRB->LOJA 																				})
TRCell():New(oProduto,"NOMECLI"		,"TRB",RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| TRB->NOMECLI 																			})
TRCell():New(oProduto,"QUANTIDADE1"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(oProduto,"QUANTIDADE2"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| TRB->QUANTIDADE							})
TRCell():New(oProduto,"ENTREGUE1"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nTotEnt							})
//TRCell():New(oProduto,"ENTREGUE2"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| TRB->ENTREGUE							})
//TRCell():New(oProduto,"NSALDO"		,	  ,STR0036					 ,PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oProduto,"NVALOR"		,	  ,STR0037					 ,PesqPict("SC6","C6_VALOR"		),TamSx3("C6_VALOR"		)[1],/*lPixel*/,{|| nValor																						})	// "Valot Total Pendente"
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Cliente                                                       	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oCliente := TRSection():New(oReport,STR0043,{"TRB","SC6","SA1","SA3","SF4"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// "Relacao de Pedidos nao entregues"###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oCliente:SetTotalInLine(.F.)

TRCell():New(oCliente,"CLIENTE"		,"TRB",RetTitle("C6_CLI"		),PesqPict("SC6","C6_CLI"		),TamSx3("C6_CLI"		)[1],/*lPixel*/,{|| TRB->CLIENTE 																			})
TRCell():New(oCliente,"LOJA"		,"TRB",RetTitle("C6_LOJA"		),PesqPict("SC6","C6_LOJA"		),TamSx3("C6_LOJA"		)[1],/*lPixel*/,{|| TRB->LOJA 																				})
TRCell():New(oCliente,"NOMECLI"		,"TRB",RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| TRB->NOMECLI 																			})
TRCell():New(oCliente,"NUM"			,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM 																				})
TRCell():New(oCliente,"ITEM"  		,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																			})
TRCell():New(oCliente,"EMISSAO"		,"TRB","Dt.Emissao"              ,"@D"							,TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO																			})
TRCell():New(oCliente,"PRODUTO1"		,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(oCliente,"PRODUTO2"		,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oCliente,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),90,/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oCliente,"STATUS"    	,"TRB","Status"					 ,"@!"							 ,10						,/*lPixel*/,{|| TRB->STATUS																				})
TRCell():New(oCliente,"XMOEDA"    	,"TRB",RetTitle("C6_XDESMOE"	),PesqPict("SC6","C6_XDESMOE"	),TamSx3("C6_XDESMOE"	)[1],/*lPixel*/,{|| TRB->XMOEDA																				})
TRCell():New(oCliente,"PRCUNIT"		,"TRB","Prc.Unit",PesqPict("SC6","C6_XPRUNIT"	),TamSx3("C6_XPRUNIT"	)[1],/*lPixel*/,{|| TRB->PRCUNIT																			})
TRCell():New(oCliente,"DATENTR"		,"TRB","DtEntrega"				,"@D"							,TamSx3("C6_ENTREG"	)[1],/*lPixel*/ ,{|| TRB->DATENTR			})	// Data de Entrega
TRCell():New(oCliente,"QUANTIDADE1"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(oCliente,"QUANTIDADE2"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| TRB->QUANTIDADE							})
TRCell():New(oCliente,"ENTREGUE1"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nTotEnt							})
//TRCell():New(oCliente,"ENTREGUE2"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| TRB->ENTREGUE							})
//TRCell():New(oCliente,"NSALDO"		,	  ,STR0036					 ,PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oCliente,"NVALOR"		,	  ,STR0037					 ,PesqPict("SC6","C6_VALOR"		),TamSx3("C6_VALOR"		)[1],/*lPixel*/,{|| nValor																						})	// "Valot Total Pendente"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Data de Entrega                                                	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oData := TRSection():New(oReport,STR0044,{"TRB","SC6","SA1","SA3","SF4"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// "Relacao de Pedidos nao entregues"###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oData:SetTotalInLine(.F.)

TRCell():New(oData,"DATENTR"		,"TRB","DtEntrega"				,"@D"							,TamSx3("C6_ENTREG"	)[1],/*lPixel*/ ,{|| TRB->DATENTR			})	// Data de Entrega
TRCell():New(oData,"NUM"			,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM 																				})
TRCell():New(oData,"EMISSAO"		,"TRB","Dt.Emissao"              ,"@D"							,TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO																			})
TRCell():New(oData,"CLIENTE"		,"TRB",RetTitle("C6_CLI"		),PesqPict("SC6","C6_CLI"		),TamSx3("C6_CLI"		)[1],/*lPixel*/,{|| TRB->CLIENTE 																			})
TRCell():New(oData,"LOJA"		,"TRB",RetTitle("C6_LOJA"		),PesqPict("SC6","C6_LOJA"		),TamSx3("C6_LOJA"		)[1],/*lPixel*/,{|| TRB->LOJA 																				})
TRCell():New(oData,"NOMECLI"		,"TRB",RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| TRB->NOMECLI 																			})
TRCell():New(oData,"ITEM"		,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																				})
TRCell():New(oData,"PRODUTO1"		,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(odata,"PRODUTO2"		,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oData,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),90,/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oData,"STATUS"    	,"TRB","Status"					 ,"@!"							 ,10						,/*lPixel*/,{|| TRB->STATUS																				})
TRCell():New(oData,"XMOEDA"    	,"TRB",RetTitle("C6_XDESMOE"	),PesqPict("SC6","C6_XDESMOE"	),TamSx3("C6_XDESMOE"	)[1],/*lPixel*/,{|| TRB->XMOEDA																				})
TRCell():New(oData,"PRCUNIT"		,"TRB","Prc.Unit",PesqPict("SC6","C6_XPRUNIT"	),TamSx3("C6_XPRUNIT"	)[1],/*lPixel*/,{|| TRB->PRCUNIT																			})
TRCell():New(oData,"QUANTIDADE1"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(odata,"QUANTIDADE2"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| TRB->QUANTIDADE							})
TRCell():New(odata,"ENTREGUE1"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nTotEnt							})
//TRCell():New(odata,"ENTREGUE2"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| TRB->ENTREGUE							})
//TRCell():New(oData,"NSALDO"		,	  ,STR0036					 ,PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oData,"NVALOR"		,	  ,STR0037					 ,PesqPict("SC6","C6_VALOR"		),TamSx3("C6_VALOR"		)[1],/*lPixel*/,{|| nValor																						})	// "Valot Total Pendente"
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Vendedor                                                       	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oVendedor := TRSection():New(oReport,STR0045,{"TRB","SC6","SA1","SA3","SF4"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// "Relacao de Pedidos nao entregues"###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oVendedor:SetTotalInLine(.F.)

TRCell():New(oVendedor,"VENDEDOR"	,"TRB",RetTitle("C5_VEND1"		),PesqPict("SC5","C5_VEND1"	),TamSx3("C5_VEND1"	)[1],/*lPixel*/,{|| TRB->VENDEDOR																					})
TRCell():New(oVendedor,"NOMEVEN"		,"TRB",RetTitle("A3_NOME"		),PesqPict("SA3","A3_NOME"	),TamSx3("A3_NOME"	)[1],/*lPixel*/,{|| TRB->NOMEVEN																					})
TRCell():New(oVendedor,"NUM"			,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM 																				})
TRCell():New(oVendedor,"ITEM"		,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																				})
TRCell():New(oVendedor,"EMISSAO"		,"TRB","Dt.Emissao"              ,"@D"							,TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO																			})
TRCell():New(oVendedor,"PRODUTO1"		,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(oVendedor,"PRODUTO2"		,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oVendedor,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),90,/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oVendedor,"STATUS"    	,"TRB","Status"					 ,"@!"							 ,10						,/*lPixel*/,{|| TRB->STATUS																				})
TRCell():New(oVendedor,"XMOEDA"    	,"TRB",RetTitle("C6_XDESMOE"	),PesqPict("SC6","C6_XDESMOE"	),TamSx3("C6_XDESMOE"	)[1],/*lPixel*/,{|| TRB->XMOEDA																				})
TRCell():New(oVendedor,"PRCUNIT"		,"TRB","Prc.Unit",PesqPict("SC6","C6_XPRUNIT"	),TamSx3("C6_XPRUNIT"	)[1],/*lPixel*/,{|| TRB->PRCUNIT																			})
TRCell():New(oVendedor,"DATENTR"		,"TRB","DtEntrega"				,"@D"							,TamSx3("C6_ENTREG"	)[1],/*lPixel*/ ,{|| TRB->DATENTR			})	// Data de Entrega
TRCell():New(oVendedor,"QUANTIDADE1"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(oVendedor,"QUANTIDADE2"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| TRB->QUANTIDADE							})
TRCell():New(oVendedor,"ENTREGUE1"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nTotEnt							})
//TRCell():New(oVendedor,"ENTREGUE2"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| TRB->ENTREGUE							})
//TRCell():New(oVendedor,"NSALDO"		,	  ,STR0036					 ,PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oVendedor,"NVALOR"		,	  ,STR0037					 ,PesqPict("SC6","C6_VALOR"		),TamSx3("C6_VALOR"		)[1],/*lPixel*/,{|| nValor																						})	// "Valot Total Pendente"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 				    	                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
Pergunte(oReport:uParam,.F.)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Marco Bianchi         ³ Data ³ 04/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportPrint(oReport,cAliasQry,oPedNEnt,oProduto,oCliente,oData,oVendedor)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis   										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local dData     := CtoD("  /  /  ")
Local cNumPed   := ""
Local cNumCli   := ""
Local nTotVen   := 0
Local nTotEnt   := 0
Local nTotItem  := 0
Local nFirst    := 0
Local nSaldo    := 0
Local nValor    := 0
Local cQuebra	:= ""
Local nMoeda    := IIF(cPaisLoc == "BRA",MV_PAR18,1)
Local nSection := oReport:Section(1):GetOrder()
Local oSecao    := oReport:Section(nSection)

Private cNum		:= ""
Private cProduto	:= ""
Private cCli		:= ""
Private dEntreg 	:= CtoD("  /  /  ")
Private cVde    	:= ""    



//oSecao:Cell("NSALDO" ):SetBlock({|| nSaldo})
oSecao:Cell("NVALOR" ):SetBlock({|| nValor})
oSecao:Cell("QUANTIDADE1" ):SetBlock({|| nTotVen})
oSecao:Cell("ENTREGUE1" ):SetBlock({|| nTotEnt})
nSaldo := 0
nValor := 0
nTotVen := 0
nTotEnt := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Pedido                                                         	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nSection == 1			// Por Pedido
	cQuebra := "NUM = cNum"
	TRFunction():New(oPedNEnt:Cell("QUANTIDADE1"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oPedNEnt:Cell("QUANTIDADE2"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oPedNEnt:Cell("ENTREGUE1"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//	TRFunction():New(oPedNEnt:Cell("ENTREGUE2"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//	TRFunction():New(oPedNEnt:Cell("NSALDO"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oPedNEnt:Cell("NVALOR"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Produto                                                       	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf nSection == 2		// Por Produto
	cQuebra := "PRODUTO = cProduto"
	TRFunction():New(oProduto:Cell("QUANTIDADE1"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oProduto:Cell("QUANTIDADE2"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oProduto:Cell("ENTREGUE1"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//	TRFunction():New(oProduto:Cell("ENTREGUE2"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//	TRFunction():New(oProduto:Cell("NSALDO"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oProduto:Cell("NVALOR"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Cliente                                                       	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf nSection == 3		// Por Cliente
	cQuebra := "CLIENTE+LOJA = cCli"
	TRFunction():New(oCliente:Cell("QUANTIDADE1"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oCliente:Cell("QUANTIDADE2"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oCliente:Cell("ENTREGUE1"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//	TRFunction():New(oCliente:Cell("ENTREGUE2"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//	TRFunction():New(oCliente:Cell("NSALDO"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oCliente:Cell("NVALOR"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Data de Entrega                                                	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf nSection == 4		// Por Data de Entrega
	cQuebra := "DATENTR = dEntreg"
	TRFunction():New(oData:Cell("QUANTIDADE1"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oData:Cell("QUANTIDADE2"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oData:Cell("ENTREGUE1"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//	TRFunction():New(oData:Cell("ENTREGUE2"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//	TRFunction():New(oData:Cell("NSALDO"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oData:Cell("NVALOR"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Vendedor                                                       	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Else 
	cQuebra := "VENDEDOR = cVde"
	TRFunction():New(oVendedor:Cell("QUANTIDADE1"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oVendedor:Cell("QUANTIDADE2"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oVendedor:Cell("ENTREGUE1"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//	TRFunction():New(oVendedor:Cell("ENTREGUE2"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//	TRFunction():New(oVendedor:Cell("NSALDO"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oVendedor:Cell("NVALOR"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Altera o Titulo do Relatorio de acordo com parametros	 	           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(oReport:Title() + " - " + IIF(nSection == 1,STR0031,	;		// "Relacao de Pedidos nao entregues"###"Por Pedido"
								IIF(nSection==2,STR0032,;				// "Por Produto"
								IIF(nSection==3,STR0033,;				// "Por Cliente"
								IIF(nSection==4,STR0034,STR0035))));	// "Por Dt.Entrega"###"Por Vendedor"
								 + " - " + GetMv("MV_MOEDA"+STR(nMoeda,1)))	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Cabecalho no top da pagina                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSecao:SetHeaderPage()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transforma parametros Range em expressao SQL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oSecao,"SA1",1,{|| xFilial("SA1")+TRB->CLIENTE+TRB->LOJA })
TRPosition():New(oSecao,"SA3",1,{|| xFilial("SA3")+TRB->VENDEDOR })
TRPosition():New(oSecao,"SF4",1,{|| xFilial("SF4")+TRB->TES })
TRPosition():New(oSecao,"SC6",1,{|| xFilial("SC6")+TRB->NUM+TRB->ITEM+TRB->PRODUTO })


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Tabela Temporaria para impressao                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| TR680Trab(oReport,cAliasQry,nSection,oSecao)},STR0038)			// "Gerando Tabela de Trabalho. Aguarde..."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbGoTop()
oReport:SetMeter(RecCount())		// Total de elementos da regua

nFirst := 0
oSecao:Init()
While !oReport:Cancel() .And. !Eof()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica campo para quebra									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNum	:= NUM
	cProduto:= PRODUTO
	cCli	:= CLIENTE+LOJA
	dEntreg := DATENTR
	cVde    := VENDEDOR
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis Totalizadoras     		    					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSaldo  := QUANTIDADE-ENTREGUE
	nTotVen += QUANTIDADE
	nTotEnt += ENTREGUE
    nValor  := xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
    
	If !(TRB->GRADE == "S" .And. MV_PAR12 == 1)
       nTotItem+= nValor
    EndIf	
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Agrutina os produtos da grade conforme o parametro MV_PAR12  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF TRB->GRADE == "S" .And. MV_PAR12 == 1
		
		cProdRef:= Substr(TRB->PRODUTO,1,nTamRef)
		
		If nSection = 2
			cAgrutina := "cProdRef == Substr(PRODUTO,1,nTamRef)"
		Else
			cAgrutina := cQuebra
		Endif
		
		nSaldo  := 0
		nTotVen := 0
		nTotEnt := 0
        nValor  := 0
		nReg    := 0
		
		While !Eof() .And. xFilial("SC6") == TRB->FILIAL .And. cProdRef == Substr(PRODUTO,1,nTamRef);
			.And. TRB->GRADE == "S" .And. &cAgrutina .And. cNum == NUM
			
			nReg	:= Recno()
			nTotVen += QUANTIDADE
			nTotEnt += ENTREGUE
			nSaldo  += QUANTIDADE-ENTREGUE
    	    nValor  += xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
			
			dbSelectArea("TRB")
			dbSkip()
			oReport:IncMeter()
			
		End
		
        nTotItem+= nValor

		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	
	
	If (nFirst = 0 .And. nSection != 4) .Or. nSection == 4
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Seleicona celulas do cabecalho da linha                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
			Case nSection = 1    				// Por Pedido
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NOMECLI"	):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("STATUS"	):Show()
				oSecao:Cell("XMOEDA"	):Show()
				oSecao:Cell("PRCUNIT"	):Show()
				oSecao:Cell("DATENTR"	):Show()
			Case nSection = 2					// Pro Produto
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("STATUS"	):Show()
				oSecao:Cell("XMOEDA"	):Show()
				oSecao:Cell("PRCUNIT"	):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NOMECLI"	):Show()
			Case nSection = 3					// Por Cliente
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NOMECLI"	):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("STATUS"	):Show()
				oSecao:Cell("XMOEDA"	):Show()
				oSecao:Cell("PRCUNIT"	):Show()
				oSecao:Cell("DATENTR"	):Show()
			Case nSection = 4					// Por Data de Entrega
				If cNumPed+cNumCli+DtoS(dData) == NUM+CLIENTE+DtoS(DATENTR)
					oSecao:Cell("DATENTR"	):Hide()
					oSecao:Cell("NUM"		):Hide()
					oSecao:Cell("EMISSAO"	):Hide()
					oSecao:Cell("CLIENTE"	):Hide()
					oSecao:Cell("LOJA"		):Hide()
					oSecao:Cell("NOMECLI"	):Hide()
				Else
					oSecao:Cell("DATENTR"	):Show()
					oSecao:Cell("NUM"		):Show()
					oSecao:Cell("EMISSAO"	):Show()
					oSecao:Cell("CLIENTE"	):Show()
					oSecao:Cell("LOJA"		):Show()
					oSecao:Cell("NOMECLI"	):Show()
				EndIf
				cNumPed := NUM
				cNumCli := CLIENTE
				dData   := DATENTR

				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("STATUS"	):Show()
				oSecao:Cell("XMOEDA"	):Show()
				oSecao:Cell("PRCUNIT"	):Show()

			OtherWise	  											// Por Vendedor
				oSecao:Cell("VENDEDOR"	):Show()				
				oSecao:Cell("NOMEVEN"	):Show()				
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("STATUS"	):Show()
				oSecao:Cell("XMOEDA"	):Show()
				oSecao:Cell("PRCUNIT"	):Show()
				oSecao:Cell("DATENTR"	):Show()
		EndCase
		
		IF nFirst = 0 .And. nSection != 4
			nFirst := 1
		Endif
		
	Else

		Do Case
			Case nSection = 1    				// Por Pedido
				oSecao:Cell("NUM"		):Hide()
				oSecao:Cell("EMISSAO"	):Hide()
				oSecao:Cell("CLIENTE"	):Hide()
				oSecao:Cell("LOJA"		):Hide()
				oSecao:Cell("NOMECLI"	):Hide()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("STATUS"	):Show()
				oSecao:Cell("XMOEDA"	):Show()
				oSecao:Cell("PRCUNIT"	):Show()
				oSecao:Cell("DATENTR"	):Show()
			Case nSection = 2					// Pro Produto
				oSecao:Cell("PRODUTO1"	):Hide()
				oSecao:Cell("PRODUTO2"	):Hide()
				oSecao:Cell("DESCRICAO"	):Hide()
				oSecao:Cell("STATUS"	):Show()
				oSecao:Cell("XMOEDA"	):Show()
				oSecao:Cell("PRCUNIT"	):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NOMECLI"	):Show()
			Case nSection = 3					// Por Cliente
				oSecao:Cell("CLIENTE"	):Hide()
				oSecao:Cell("LOJA"		):Hide()
				oSecao:Cell("NOMECLI"	):Hide()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("STATUS"	):Show()
				oSecao:Cell("XMOEDA"	):Show()
				oSecao:Cell("PRCUNIT"	):Show()
				oSecao:Cell("DATENTR"	):Show()
			Case nSection = 4					// Por Data de Entrega
				If cNumPed+cNumCli+DtoS(dData) == NUM+CLIENTE+DtoS(DATENTR)
					oSecao:Cell("DATENTR"	):Hide()
					oSecao:Cell("NUM"		):Hide()
					oSecao:Cell("EMISSAO"	):Hide()
					oSecao:Cell("CLIENTE"	):Hide()
					oSecao:Cell("LOJA"		):Hide()
					oSecao:Cell("NOMECLI"	):Hide()
				Else
					oSecao:Cell("DATENTR"	):Show()
					oSecao:Cell("NUM"		):Show()
					oSecao:Cell("EMISSAO"	):Show()
					oSecao:Cell("CLIENTE"	):Show()
					oSecao:Cell("LOJA"		):Show()
					oSecao:Cell("NOMECLI"	):Show()
				EndIf
				cNumPed := NUM
				cNumCli := CLIENTE
				dData   := DATENTR
				
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("STATUS"	):Show()
				oSecao:Cell("XMOEDA"	):Show()
				oSecao:Cell("PRCUNIT"	):Show()
			OtherWise												// Por Vendedor
				oSecao:Cell("VENDEDOR"	):Hide()
				oSecao:Cell("NOMEVEN"	):Hide()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("STATUS"	):Show()
				oSecao:Cell("XMOEDA"	):Show()
				oSecao:Cell("PRCUNIT"	):Show()
				oSecao:Cell("DATENTR"	):Show()
		EndCase
	
	EndIf


	If TRB->GRADE=="S" .And. MV_PAR12 == 1
		oSecao:Cell("PRODUTO2"):Disable()
		oSecao:Cell("QUANTIDADE2"):Disable()
//		oSecao:Cell("ENTREGUE2"):Disable()
	Else 
		oSecao:Cell("PRODUTO1"):Disable()
		oSecao:Cell("QUANTIDADE1"):Disable()
		oSecao:Cell("ENTREGUE1"):Disable()
	EndIf	


	oSecao:PrintLine()

	dbSelectArea("TRB")
	dbSkip()
	oReport:IncMeter()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total do Pedido                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If NUM <> cNum
       If   nSection = 3 .Or.	nSection = 4 .Or.	nSection = 1
       		nTotitem:= 0	
			oSecao:SetTotalText(STR0031 + " " + cNum)
			oSecao:Finish()
			oSecao:Init()
       EndIf
    EndIf
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total ou linha divisora conforme a quebra		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !&cQuebra
			
		nTotVen := 0
		nTotEnt := 0
		nFirst  := 0   

		oSecao:SetTotalText(IIF(nSection == 1,STR0031 + " " + cNum,	;	// "Total do Pedido"
								IIF(nSection==2,STR0032 + " " + cProduto,;					// "Total do Produto"
								IIF(nSection==3,STR0033 + " " + cCli,;					// "Total do Cliente"
								IIF(nSection==4,STR0034 + " " + DTOC(dEntreg),STR0035  + " " + cVde)))))		// "Total da Dt.Entrega"###"Total do Vendedor"
		
		// Finaliza Secao
		If nSection <> 3 .And. nSection <> 4 .And. nSection <> 1
			oSecao:Finish()
			oSecao:Init()
		EndIf
			
		If mv_par15 == 1 .And. !Eof()
			// Forca salto de pagina no fim da secao
			oReport:nrow := 5000			
			oReport:skipLine()
		EndIf
		
		
	Endif
	
	dbSelectArea("TRB")
	
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza Relatorio                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSecao:SetPageBreak()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha tabela de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Tabelas                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	dbSelectArea(cAliasQry)
	dbClosearea()
	dbSelectArea("SC6")
	dbSetOrder(1)
#ELSE
	dbSelectArea("SC6")
	RetIndex("SC6")
	dbSetOrder(1)	
#ENDIF


Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³TR680Trab ³ Autor ³ Marco Bianchi         ³ Data ³ 05/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria Arquivo de Trabalho                             	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MATR680													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function TR680Trab(oReport,cAliasQry,nSection,oSecao)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCampos   := {}
Local aTam      := ""
Local cVend     := ""
Local cVendedor := ""
Local nTipVal   := IIF(cPaisLoc == "BRA",MV_PAR19,MV_PAR20)
Local nSaldo    := 0
Local nX        := 0
Local nQtdVend  := FA440CntVen() // Retorna a quantidade maxima de Vendedores
Local nValor	:= 0 
Local cStatus   :=""

#IFNDEF TOP
	Local cFilTrab  := ""
#ENDIF
cFilSA1        := ""
cFilSA3        := ""
cFilSF4        := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("C6_FILIAL")
AADD(aCampos,{ "FILIAL"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_NUM")
AADD(aCampos,{ "NUM"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_CLI")
AADD(aCampos,{ "CLIENTE"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NOME")
AADD(aCampos,{ "NOMECLI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_LOJA")
AADD(aCampos,{ "LOJA"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_VEND1")
AADD(aCampos,{ "VENDEDOR"  ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NOME")
AADD(aCampos,{ "NOMEVEN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ENTREG")
AADD(aCampos,{ "DATENTR"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEM")
AADD(aCampos,{ "ITEM"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRODUTO")
AADD(aCampos,{ "PRODUTO"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_DESCRI")
AADD(aCampos,{ "DESCRICAO" ,"C",90,aTam[2] } )
aTam:=TamSX3("C6_QTDVEN")
AADD(aCampos,{ "QUANTIDADE","N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDENT")
AADD(aCampos,{ "ENTREGUE"  ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_GRADE")
AADD(aCampos,{ "GRADE"     ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEMGRD")
AADD(aCampos,{ "ITEMGRD"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_TES")
AADD(aCampos,{ "TES"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLQ")
AADD(aCampos,{ "BLQ"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLOQUEI")
AADD(aCampos,{ "BLOQUEI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_VALOR")
AADD(aCampos,{ "VALOR"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_MOEDA")
AADD(aCampos,{ "MOEDA"   ,"N",aTam[1],aTam[2] } )
AADD(aCampos,{ "STATUS"  ,"C",10,0 } )                                                 

aTam:=TamSX3("C6_XDESMOE")
AADD(aCampos,{ "XMOEDA"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_XPRUNIT")
AADD(aCampos,{ "PRCUNIT"   ,"N",aTam[1],aTam[2] } )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

dbSelectArea("TRB")
Do Case
	Case nSection = 1
		IndRegua("TRB",cArqTrab,"FILIAL+NUM+ITEM+PRODUTO",,,STR0040)       //"Selecionando Registros..."
	Case nSection = 2
		IndRegua("TRB",cArqTrab,"FILIAL+PRODUTO+NUM+ITEM",,,STR0040)       //"Selecionando Registros..."
	Case nSection = 3
		IndRegua("TRB",cArqTrab,"FILIAL+CLIENTE+LOJA+NUM+ITEM",,,STR0040)  //"Selecionando Registros..."
	Case nSection = 4
		IndRegua("TRB",cArqTrab,"FILIAL+DTOS(DATENTR)+NUM+ITEM",,,STR0040) //"Selecionando Registros..."
	Case nSection = 5
		IndRegua("TRB",cArqTrab,"FILIAL+VENDEDOR+NUM+ITEM",,,STR0040)      //"Selecionando Registros..."
EndCase

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o Filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
dbSetOrder(1)

#IFDEF TOP
	
	
	aStruSC6  := SC6->(dbStruct())
	cWhere := "%" 
	If mv_par13 == 3
		cWhere += "AND C6_BLQ = 'R '"
	Endif	
	cWhere += "%" 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para tratamento do filtro do usuario.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("F680QRY")
		cQueryAdd := ExecBlock("F680QRY", .F., .F., {aReturn[7]})
		If ValType(cQueryAdd) == "C"
			cWhere += " AND ( " + cQueryAdd + ")"
		EndIf
	EndIf

	oSecao:BeginQuery()
	BeginSql Alias cAliasQry
	SELECT C6_FILIAL, C6_NUM,C6_CLI, C6_LOJA, C6_ENTREG, C6_ITEM, C6_PRODUTO, 
	C6_DESCRI, C6_VALOR, C6_PRCVEN, C6_QTDVEN, C6_QTDENT, C6_GRADE, 
	C6_ITEMGRD, C6_TES, C6_BLQ, C6_BLOQUEI,C6_XMOEDA, C6_XPRUNIT 
	
	FROM %Table:SC6% SC6
	WHERE C6_FILIAL = %xFilial:SC6%
		AND C6_NUM >= %Exp:mv_par01% AND C6_NUM <= %Exp:mv_par02%
		AND C6_PRODUTO >= %Exp:mv_par03% AND C6_PRODUTO <= %Exp:mv_par04%
		AND C6_CLI >= %Exp:mv_par05% AND C6_CLI <= %Exp:mv_par06%
		AND C6_ENTREG >= %Exp:DtoS(mv_par07)% AND C6_ENTREG <= %Exp:DtoS(mv_par08)%
        AND SC6.%notdel%
        %Exp:cWhere%
	ORDER BY C6_FILIAL,C6_NUM,C6_ITEM,C6_PRODUTO
	EndSql
	oSecao:EndQuery()
	
#ELSE
	
	cFilTrab   := CriaTrab("",.F.)
	cCondicao  := "C6_FILIAL=='"+xFilial("SC6")+"'.And."
	cCondicao  += "C6_NUM>='"+MV_PAR01+"'.And.C6_NUM<='"+MV_PAR02+"'.And."
	cCondicao  += "C6_PRODUTO>='"+MV_PAR03+"'.And.C6_PRODUTO<='"+MV_PAR04+"'.And."
	cCondicao  += "C6_CLI>='"+MV_PAR05+"'.And.C6_CLI<='"+MV_PAR06+"'.And."
	cCondicao  += "Dtos(C6_ENTREG)>='"+Dtos(MV_PAR07)+"'.And.Dtos(C6_ENTREG)<='"+Dtos(MV_PAR08)+"'"
	If mv_par13 == 3
		cCondicao += " .And. C6_BLQ == 'R ' "
	Endif	
	
	dbSelectArea(cAliasQry)
	dbSetOrder(1)
	IndRegua("SC6",cFilTrab,IndexKey(),,cCondicao)
	dbGoTop()
	
#ENDIF
       

If len(oSecao:GetAdvplExp("SA1")) > 0
	cFilSA1 := oSecao:GetAdvplExp("SA1")
EndIf
If len(oSecao:GetAdvplExp("SA3")) > 0
	cFilSA3 := oSecao:GetAdvplExp("SA3")
EndIf     		
If len(oSecao:GetAdvplExp("SF4")) > 0
	cFilSF4 := oSecao:GetAdvplExp("SF4")
EndIf

dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter(RecCount())     // Total de Elementos da Regua
While !oReport:Cancel() .And. !Eof() .And. (cAliasQry)->C6_FILIAL == xFilial("SC6")
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek( xFilial()+ (cAliasQry)->C6_CLI + (cAliasQry)->C6_LOJA )
   
	// Verifica filtro do usuario
	If !Empty(cFilSA1) .And. !(&cFilSA1)
		dbSelectArea(cAliasQry)	
   	dbSkip()
	   Loop
	EndIf	
                  
    If !Empty(mv_par20) .and. sa1->a1_grpven < mv_par20 
	   dbSelectArea(cAliasQry)	; dbSkip()
	   Loop
    Endif
       
    If !Empty(mv_par21) .and. sa1->a1_grpven > mv_par21
	   dbSelectArea(cAliasQry)	; dbSkip()
	   Loop
    Endif          

    If ! ("TODOS" $ cGrpAcesso)  // Nao é Usuario Master / Adv Vendas???    
       If ! (sa1->a1_grpven $ cGrpAcesso)   // O Segmento do Cliente nao Esta dentro do segmento daquele vendedor
	      dbSelectArea(cAliasQry)	; dbSkip()
	      Loop
	   Endif
    Endif

    sb1->(dbseek(xFilial('SB1')+(cAliasQry)->C6_PRODUTO )) 
    If ! Empty(mv_par22) .and. sb1->b1_fam < mv_par22 
	   dbSelectArea(cAliasQry)	; dbSkip()
	   Loop
    Endif

    If ! Empty(mv_par23) .and. sb1->b1_fam > mv_par23 
	   dbSelectArea(cAliasQry)	; dbSkip()
	   Loop
    Endif

	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek( xFilial(("SF4"))+(cAliasQry)->C6_TES )

	// Verifica filtro do usuario	
	If !Empty(cFilSF4) .And. !(&cFilSF4)
		dbSelectArea(cAliasQry)	
   	dbSkip()
	   Loop
	EndIf	
	
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek( xFilial(("SC5"))+(cAliasQry)->C6_NUM )

	dbSelectArea(cAliasQry)

    If mv_par24 <> 5   // Todos
       Do Case 
          Case mv_par24 	== 1 // Aberto 
               cStatus:="ABERTO"
               If ! Empty(sc5->c5_liberok)
                  dbskip() ; Loop
               Endif
                    
               If sc5->c5_x_rep == "R"
                  dbskip() ; Loop
               Endif

          Case mv_par24 == 2 // Liberado
               cStatus:="LIBERADO"
          
               If Empty(sc5->c5_liberok)
                  dbskip() ; Loop
               Endif

               If sc5->c5_x_rep == "R"
                  dbskip() ; Loop
               Endif
 
          Case mv_par24 == 3  // Reprovado
               cStatus:="REPROVADO"

               If sc5->c5_x_rep <> "R"
                  dbskip() ; Loop
               Endif
                    
          Case mv_par24 == 4 // Cancelados
               cStatus:="CANCELADO"
               If sc5->c5_x_canc <> "C"     
                  dbskip() ; Loop
               Endif
       End Case           
    Endif
    
    If mv_par24 == 5    // Todos
    
       If Empty(sc5->c5_liberok) .and. Empty(sc5->c5_nota) .and. Empty(sc5->c5_blq)    // Em Aberto
          cStatus:="ABERTO"
       Endif
       
       If !Empty(sc5->c5_liberok) .and. Empty(sc5->c5_nota) .and. Empty(sc5->c5_blq)  // Liberado
          cStatus:="LIBERADO"
       Endif                                                                                
       
       If sc5->c5_x_Rep == "R"      // Reprovado
          cStatus:="REPROVADO"
       Endif

       If sc5->c5_x_Canc == "C"     // Cancelado
          cStatus:="CANCELADO"
       Endif

    
    Endif
    
    
	If cPaisLoc <> "BRA"
		If ( SF4->F4_ESTOQUE == "S" .And. mv_par18 == 2 ) .Or. ( SF4->F4_ESTOQUE!= "S" .And. mv_par18 == 1 )
			dbSkip()
			Loop
		Endif
		If mv_par19 <> 4 .And. SC5->(FIELDPOS("C5_DOCGER")) > 0
			If (mv_par19 == 1 .And. SC5->C5_DOCGER <> '1' ) .Or.;		// Gera nota
				(mv_par19 == 2 .And. SC5->C5_DOCGER <> '2' ) .Or.;		// Gera REMITO
				(mv_par19 == 3 .And. SC5->C5_DOCGER <> '3' ) 			// Entrega futura
				dbSkip()
				Loop
			Endif
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se esta dentro dos parametros						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet:=ValidMasc((cAliasQry)->C6_PRODUTO,MV_PAR11)
	If Alltrim((cAliasQry)->C6_BLQ) == "R" .and. mv_par13 == 2 // Se Foi Eliminado Residuos
		nSaldo  := 0
	Else
		nSaldo  := C6_QTDVEN-C6_QTDENT
	Endif

	If ((C6_QTDENT < C6_QTDVEN .And. MV_PAR09 == 1) .Or. (MV_PAR09 == 2)).And.;
		((nSaldo == 0 .And. MV_PAR14 == 1.And.Alltrim((cAliasQry)->C6_BLQ)<>"R").Or. nSaldo <> 0).And.;
		((SF4->F4_DUPLIC == "S" .And. MV_PAR10 == 1) .Or. (SF4->F4_DUPLIC == "N";
		.And. MV_PAR10 == 2).Or.(MV_PAR10 == 3));
		.And. At(SC5->C5_TIPO,"DB") = 0 .And.lRet
		
		If nSection = 5		// Por Vendedor
			
			cVend := "1"
			For nX := 1 to nQtdVend
				cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
				If !EMPTY(cVendedor) .And. (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
					
					dbSelectArea("SA3")
					dbSetOrder(1)
					dbSeek( xFilial()+cVendedor)

					// Verifica filtro do usuario					
					If (Empty(cFilSA3)) .Or. (!Empty(cFilSA3) .And. (&cFilSA3))
					
						dbSelectArea("TRB")
						RecLock("TRB",.T.)
					
						Replace VENDEDOR   With cVendedor
						Replace NOMEVEN    With SA3->A3_NOME
						Replace FILIAL     With (cAliasQry)->C6_FILIAL
						Replace NUM        With (cAliasQry)->C6_NUM
						Replace EMISSAO    With SC5->C5_EMISSAO
						Replace CLIENTE    With (cAliasQry)->C6_CLI
						Replace NOMECLI    With SA1->A1_NOME
						Replace LOJA       With (cAliasQry)->C6_LOJA
						Replace DATENTR    With (cAliasQry)->C6_ENTREG
						Replace ITEM       With (cAliasQry)->C6_ITEM
						Replace PRODUTO    With (cAliasQry)->C6_PRODUTO
						Replace DESCRICAO  With (cAliasQry)->C6_DESCRI
						Replace QUANTIDADE With (cAliasQry)->C6_QTDVEN
						Replace ENTREGUE   With (cAliasQry)->C6_QTDENT
						Replace GRADE      With (cAliasQry)->C6_GRADE
						Replace ITEMGRD    With (cAliasQry)->C6_ITEMGRD
						Replace TES        With (cAliasQry)->C6_TES
						Replace BLQ        With (cAliasQry)->C6_BLQ
						Replace BLOQUEI    With (cAliasQry)->C6_BLOQUEI
						Replace STATUS     With cStatus
                        Replace XMOEDA      With IIF((cAliasQry)->C6_XMOEDA ==1, 'R$', 'US$')
                        Replace PRCUNIT    With (cAliasQry)->C6_XPRUNIT
					
						If nTipVal == 1 //--  Imprime Valor Total do Item
							nValor:=(cAliasQry)->C6_VALOR
						Else
							//--  Imprime Saldo
							If TRB->QUANTIDADE==0
								nValor:=(cAliasQry)->C6_VALOR
							Else
								nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasQry)->C6_PRCVEN
								nValor := If(nValor<0,0,nValor)
							EndIf
						EndIf
						Replace VALOR      With nValor
						Replace MOEDA      With SC5->C5_MOEDA
					
						MsUnLock()
					
					EndIf
					
				Endif
				
				cVend := Soma1(cVend,1)
				dbSelectArea("SC5")
				dbSetOrder(1)
			Next nX
			
		Else
			
			lVend := .F.
			cVend := "1"
			For nX := 1 to nQtdVend
				cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
				
				dbSelectArea("SA3")
				dbSetOrder(1)
				dbSeek( xFilial()+cVendedor)
				
				// Verifica filtro do usuario					
				If (Empty(cFilSA3)) .Or. (!Empty(cFilSA3) .And. (&cFilSA3))
					If (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
						lVend :=.T.
						Exit
					Endif
				Endif
				cVend := Soma1(cVend,1)
			Next nX


			If lVend
				
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				
				Replace FILIAL     With (cAliasQry)->C6_FILIAL
				Replace NUM        With (cAliasQry)->C6_NUM
				Replace EMISSAO    With SC5->C5_EMISSAO
				Replace CLIENTE    With (cAliasQry)->C6_CLI
				Replace NOMECLI    With SA1->A1_NOME
				Replace LOJA       With (cAliasQry)->C6_LOJA
				Replace DATENTR    With (cAliasQry)->C6_ENTREG
				Replace ITEM       With (cAliasQry)->C6_ITEM
				Replace PRODUTO    With (cAliasQry)->C6_PRODUTO
				Replace DESCRICAO  With (cAliasQry)->C6_DESCRI
				Replace QUANTIDADE With (cAliasQry)->C6_QTDVEN
				Replace ENTREGUE   With (cAliasQry)->C6_QTDENT
				Replace GRADE      With (cAliasQry)->C6_GRADE
				Replace ITEMGRD    With (cAliasQry)->C6_ITEMGRD
				Replace TES        With (cAliasQry)->C6_TES
				Replace BLQ        With (cAliasQry)->C6_BLQ
				Replace BLOQUEI    With (cAliasQry)->C6_BLOQUEI
				Replace STATUS     With cStatus
                Replace XMOEDA      With IIF((cAliasQry)->C6_XMOEDA ==1, 'R$', 'US$')
                Replace PRCUNIT    With (cAliasQry)->C6_XPRUNIT

				If nTipVal == 1 //--  Imprime Valor Total do Item
					nValor:=(cAliasQry)->C6_VALOR
				Else
					//--  Imprime Saldo
					If TRB->QUANTIDADE==0
						nValor:=(cAliasQry)->C6_VALOR
					Else
						nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasQry)->C6_PRCVEN
						nValor := If(nValor<0,0,nValor)
					EndIf
				EndIf
				Replace VALOR      With nValor
				Replace MOEDA      With SC5->C5_MOEDA
				
				lVend := .F.
				MsUnLock()
			Endif
		Endif
	Endif
	
	dbSelectArea(cAliasQry)
	dbSkip()
	oReport:IncMeter()
	
EndDo
#IFNDEF TOP
	dbSelectArea(cAliasQry)
	RetIndex(cAliasQry)
	FErase(cFilTrab+OrdBagExt())
#ENDIF


Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MATR680R3³ Autor ³ Alexandre Inacio Lemes³ Data ³ 15.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Pedidos nao entregues							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL. 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³	MOTIVO DA ALTERACAO					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Matr680R3()

LOCAL titulo    := OemToAnsi(STR0001)	//"Relacao de Pedidos nao entregues"
LOCAL cDesc1    := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao dos Pedidos Pendentes,"
LOCAL cDesc2    := OemToAnsi(STR0003)	//"imprimindo o numero do Pedido, Cliente, Data da Entrega, "
LOCAL cDesc3    := OemToAnsi(STR0004)	//"Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
LOCAL cString   := "SC6"
LOCAL tamanho   := "G"
LOCAL wnrel     := "MATR680"

PRIVATE aReturn := { STR0005, 1,STR0006, 1, 2, 1, "", 1 }      //"Zebrado"###"Administracao"
PRIVATE nTamRef := Val(Substr(GetMv("MV_MASCGRD"),1,2))
PRIVATE nomeprog:= "MATR680"
PRIVATE cPerg	 :=	IIf(cPaisLoc == "BRA","MTR680","MR680A")
PRIVATE cArqTrab:= ""
PRIVATE cFilTrab:= ""
PRIVATE nLastKey:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 				    	     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros		    			 ³
//³ mv_par01				// Do Pedido	                     ³
//³ mv_par02				// Ate o Pedido	                     ³
//³ mv_par03				// Do Produto				         ³
//³ mv_par04				// Ate o Produto					 ³
//³ mv_par05				// Do Cliente						 ³
//³ mv_par06				// Ate o cliente					 ³
//³ mv_par07				// Da data de entrega	    		 ³
//³ mv_par08				// Ate a data de entrega			 ³
//³ mv_par09				// Em Aberto , Todos 				 ³
//³ mv_par10				// C/Fatur.,S/Fatur.,Todos 			 ³
//³ mv_par11				// Mascara							 ³
//³ mv_par12				// Aglutina itens grade 			 ³
//³ mv_par13				// Considera Residuos (Sim/Nao)		 ³
//³ mv_par14				// Lista Tot.Faturados(Sim/Nao)		 ³
//³ mv_par15				// Salta pagina na Quebra(Sim/Nao)	     ³
//³ mv_par16				// Do vendedor                 		 ³
//³ mv_par17				// Ate o vendedor                    |
//³ mv_par18				// Qual a moeda                      |
//³ As proximas pertencem ao grupo MR680A que eh so para         |
//³ Localizacoes...                                     	     ³
//³ mv_par18				// Movimenta stock    (Sim/Nao)	     ³
//³ mv_par19		 // Gen. Doc (Factura/Remito/Ent. Fut/Todos) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 					     ³
//| aOrd = Ordems Por Pedido/Produto/Cliente/Dt.Entrega/Vendedor |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aOrd :={STR0007,STR0008,STR0009,STR0010,STR0022}
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C680Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ C680IMP	³ Autor ³ Alexandre Incaio Lemes³ Data ³ 15.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MATR680													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C680Imp(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis   										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL titulo    := OemToAnsi(STR0001)	//"Relacao de Pedidos nao entregues"
LOCAL dData     := CtoD("  /  /  ")
LOCAL cTotPed   := "NUM = cNum"
LOCAL CbTxt     := ""
LOCAL cabec1    := ""
LOCAL cabec2    := ""
LOCAL tamanho   := "G"
LOCAL cNumPed   := ""
LOCAL cNumCli   := ""
LOCAL limite    := 220
LOCAL CbCont    := 0
LOCAL nOrdem    := 0
LOCAL nTotVen   := 0
LOCAL nTotEnt   := 0
LOCAL nTotSal   := 0
LOCAL nTotItem  := 0
LOCAL nFirst    := 0
LOCAL nSaldo    := 0
LOCAL nValor    := 0
LOCAL nCont     := 0
LOCAL lImpTot   := .F.
LOCAL lContinua := .T.
LOCAL nMoeda    := IIF(cPaisLoc == "BRA",MV_PAR18,1)
LOCAL nTVGeral  := 0
LOCAL nTEGeral  := 0
LOCAL nTSGeral  := 0
LOCAL nTIGeral  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
li 	    := 80

nTipo   := IIF(aReturn[4]==1,15,18)
nOrdem  := aReturn[8]

Processa({|lEnd| C680Trb(@lEnd,wnRel,"TRB")},Titulo)

//                   999999 99/99/9999 999999xxxxxxxxxxxxxx/XXXXXXXX XX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX 99/99/9999 999999999999 999999999999 999999999999
//                             1         2         3         4         5         6         7         8         9        10        11        12        13
//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
dbSelectArea("TRB")

Do Case
	Case nOrdem = 1
		cQuebra := "NUM = cNum"
		titulo  := titulo +" - "+ STR0007 //"Por Pedido"
		cabec1  := STR0011 //"NUMERO  DATA DE   CODIGO LOJA /NOME DO CLIENTE                       IT CODIGO DO       DESCRICAO DO                    DATA DE        QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
		cabec2  := STR0012 //"PEDIDO  EMISSAO                                                         PRODUTO         MATERIAL                        ENTREGA        PEDIDA       ENTREGUE     PENDENTE        DO ITEM.    "    
	Case nOrdem = 2
		cQuebra := "PRODUTO = cProduto"
		titulo  := titulo + " - "+STR0008 //"Por Produto"
		cabec1  := STR0013 //"CODIGO DO       DESCRICAO DO                   NUMERO IT DATA DE      DATA DE      CODIGO LOJA /NOME DO CLIENTE                        QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
		cabec2  := STR0014 //"PRODUTO         MATERIAL                       PEDIDO    EMISSAO      ENTREGA                                                          PEDIDA       ENTREGUE     PENDENTE        DO ITEM.    "
	Case nOrdem = 3
		cQuebra := "CLIENTE+LOJA = cCli"
		titulo  := titulo + " - "+STR0009 //"Por Cliente"
		cabec1  := STR0016 //"CODIGO-LOJA/NOME DO CLIENTE                        NUMERO IT  DATA DE      CODIGO DO       DESCRICAO DO                   DATA DE      QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
		cabec2  := STR0017 //"                                                   PEDIDO     EMISSAO      PRODUTO         MATERIAL                       ENTREGA      PEDIDA       ENTREGUE     PENDENTE        DO ITEM.    "
	Case nOrdem = 4
		cQuebra := "DATENTR = dEntreg"
		titulo  := titulo + STR0018 //" - Por Data de Entrega"
		cabec1  := STR0019 //" DATA DE      NUMERO DATA DE      CODIGO LOJA /NOME DO CLIENTE                       IT CODIGO DO       DESCRICAO DO                   QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
		cabec2  := STR0020 //" ENTREGA      PEDIDO EMISSAO                                                            PRODUTO         MATERIAL                       PEDIDA       ENTREGUE     PENDENTE        DO ITEM.    "
		
	Case nOrdem = 5
		cQuebra := "VENDEDOR = cVde"
		titulo  := titulo + STR0022 //" - Por Vendedor"
		cabec1  := STR0023 //"CODIGO VENDEDOR                                 NUMERO IT  DATA DE      CODIGO DO       DESCRICAO DO                   DATA DE         QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL "
		cabec2  := STR0024 //"                                                PEDIDO     EMISSAO      PRODUTO         MATERIAL                       ENTREGA         PEDIDA       ENTREGUE     PENDENTE        DO ITEM.    "
EndCase

titulo += " - " + GetMv("MV_MOEDA"+STR(nMoeda,1))		//" MOEDA "
dbSelectArea("TRB")
dbGoTop()
SetRegua(RecCount())                    	// TOTAL DE ELEMENTOS DA REGUA

nFirst := 0

While !Eof() .And. lContinua
	
	IF lEnd
		@PROW()+1,001 Psay STR0021        //    "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IF li > 58 .Or.( MV_PAR15 = 1 .And.!&cQuebra)
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica campo para quebra									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNum	:= NUM
	cProduto:= PRODUTO
	cCli	:= CLIENTE+LOJA
	dEntreg := DATENTR
	cVde    := VENDEDOR
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis Totalizadoras     		    					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSaldo  := QUANTIDADE-ENTREGUE
	nTotSal += nSaldo
	nTotVen += QUANTIDADE
	nTotEnt += ENTREGUE
    nValor  := xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
    
	If !(TRB->GRADE == "S" .And. MV_PAR12 == 1)
       nTotItem+= nValor
       nTIGeral+= nValor
    EndIf	
    
	If nTotVen > QUANTIDADE .Or. nTotEnt > ENTREGUE
		lImpTot := .T.
	Else
		lImpTot := .F.
	EndIf
	
	IF (nFirst = 0 .And. nOrdem != 4).Or. nOrdem == 4
		
		li++
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime o cabecalho da linha		    					 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
			Case nOrdem = 1
				@li,  0 Psay NUM
				@li,  7 Psay TRB->EMISSAO
				@li, 18 Psay Left(CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI, 50)
			Case nOrdem = 2
				@li,  0 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
				@li, 16 Psay Left(TRB->DESCRICAO, 30)
			Case nOrdem = 3
				@li,  0 Psay Left(CLIENTE+"-"+LOJA+"/"+NOMECLI, 50)
			Case nOrdem = 4
				If cNumPed+cNumCli+DtoS(dData) != NUM+CLIENTE+DtoS(DATENTR)
					@li,  1 Psay DATENTR
					@li, 14 Psay NUM
					@li, 21 Psay EMISSAO
					@li, 34 Psay Left(CLIENTE+"-"+LOJA+"/"+NOMECLI, 50)
					cNumPed := NUM
					cNumCli := CLIENTE
				Else
					li--
				EndIf
				dData := DATENTR
			Case nOrdem = 5
				@li,  0 Psay Left(TRB->VENDEDOR+" "+NOMEVEN, 47)
		EndCase
		
		IF nFirst = 0 .And. nOrdem != 4
			nFirst := 1
		Endif
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Agrutina os produtos da grade conforme o parametro MV_PAR12  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF TRB->GRADE == "S" .And. MV_PAR12 == 1
		
		cProdRef:= Substr(TRB->PRODUTO,1,nTamRef)
		
		If nOrdem = 2
			cAgrutina := "cProdRef == Substr(PRODUTO,1,nTamRef)"
		Else
			cAgrutina := cQuebra
		Endif
		
		nSaldo  := 0
		nTotVen := 0
		nTotEnt := 0
		nTotSal := 0
        nValor  := 0
		nReg    := 0
		
		While !Eof() .And.xFilial("SC6") == TRB->FILIAL .And. cProdRef == Substr(PRODUTO,1,nTamRef);
			.And. TRB->GRADE == "S" .And. &cAgrutina .And. cNum == NUM
			
			nReg	 := Recno()
			
			nTotVen += QUANTIDADE
			nTotEnt += ENTREGUE
			nSaldo  += QUANTIDADE-ENTREGUE
    	    nValor  += xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
			
			dbSelectArea("TRB")
			IncRegua()
			dbSkip()
			
			lImpTot := .T.
			
		End
		
		nTotSal += nSaldo
        nTotItem+= nValor
		nTIGeral+= nValor
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime a linha Conforme a ordem selecionada na setprint	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
		Case nOrdem = 1
			@li, 69 Psay ITEM
			@li, 72 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 88 Psay Left(TRB->DESCRICAO, 30)
			@li,119 Psay DATENTR
		Case nOrdem = 2
			@li, 47 Psay NUM
			@li, 54 Psay ITEM
			@li, 57 Psay EMISSAO
			@li, 70 Psay DATENTR
			@li, 83 Psay Left(TRB->CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI,50)
		Case nOrdem = 3
			@li, 51 Psay NUM
			@li, 58 Psay ITEM
			@li, 61 Psay EMISSAO
			@li, 74 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 91 Psay Left(TRB->DESCRICAO,30)
			@li,122 Psay DATENTR
		Case nOrdem = 4
			@li, 85 Psay ITEM
			@li, 88 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamRef),PRODUTO)
			@li,104 Psay Left(TRB->DESCRICAO, 30)
		OtherWise
			@li, 48 Psay NUM
			@li, 55 Psay ITEM
			@li, 59 Psay EMISSAO
			@li, 72 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 88 Psay Left(TRB->DESCRICAO,30)
			@li,119 Psay DATENTR
	EndCase
	
	@li,136 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotVen,QUANTIDADE)	PICTURE PesqPictQt("C6_QTDVEN",12)
	@li,149 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotEnt,ENTREGUE)	PICTURE PesqPictQt("C6_QTDENT",12)
	@li,162 Psay nSaldo	PICTURE PesqPictQt("C6_QTDVEN",12)
	@li,176 Psay nValor	PICTURE PesqPict("SC6","C6_VALOR",12)
	
	nCont++
	li++
	
	dbSelectArea("TRB")
	IncRegua()
	dbSkip()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total do Pedido                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !&cTotPed
       If nOrdem = 1 .Or. nOrdem = 3 .Or.  nOrdem = 4 .Or. (nOrdem == 5 .And. !&cQuebra)
           @Li,000 Psay STR0025
           @Li,173 Psay nTotItem PICTURE PesqPict("SC6","C6_VALOR",15)
           If nOrdem = 3 
              li+=2
           Else
              li++
           ENdif
	       nTotitem:= 0	
       EndIf
    EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total ou linha divisora conforme a quebra		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !&cQuebra
		
		If (MV_PAR15 = 1 .And. nOrdem = 2) .Or. MV_PAR15 = 2
			
			If nOrdem = 2
				@Li,000 Psay STR0025
				@Li,136 Psay nTotVen PICTURE PesqPictQt("C6_QTDVEN",12)
				@Li,149 Psay nTotEnt PICTURE PesqPictQt("C6_QTDENT",12)
				@Li,162 Psay nTotSal PICTURE PesqPictQt("C6_QTDVEN",12)
				li++
			Endif
			
			If nTotVen > 0 .And. nOrdem != 1
				@li,  0 Psay __PrtThinLine()
				li++
			Endif
			
		Endif

		nTVGeral += nTotVen
		nTEGeral += nTotEnt
		nTSGeral += nTotSal
				
		nTotVen := 0
		nTotEnt := 0
		nTotSal := 0
		nCont   := 0
		nFirst  := 0
		
	Endif
	
End

If nTIGeral > 0        
	If li >= 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
	li++
	@Li,000 Psay STR0026
	@Li,136 Psay nTVGeral PICTURE PesqPictQt("C6_QTDVEN",12)
	@Li,149 Psay nTEGeral PICTURE PesqPictQt("C6_QTDENT",12)
	@Li,162 Psay nTSGeral PICTURE PesqPictQt("C6_QTDVEN",12)
	@Li,173 Psay nTIGeral PICTURE PesqPict("SC6","C6_VALOR",15)
EndIf

If li != 80
	Roda(cbcont,cbtxt)
Endif

dbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivos de trabalho.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ferase(cArqTrab+GetDBExtension())
Ferase(cArqTrab+OrdBagExt())
Ferase(cFilTrab+OrdBagExt())

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ C680TRB	³ Autor ³ Alexandre Inacio Lemes³ Data ³ 15.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria Arquivo de Trabalho                             	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MATR660													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function C680TRB(nOrdem)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL aCampos   := {}
LOCAL aTam      := ""
LOCAL cKey      := ""
LOCAL cCondicao := ""
LOCAL cVend     := ""
LOCAL cVendedor := ""
LOCAL cAliasSC6 := "SC6"
LOCAL cPedIni   := MV_PAR01
LOCAL cPedFim   := MV_PAR02
LOCAL cProIni   := MV_PAR03
LOCAL cProFim   := MV_PAR04
LOCAL cCliIni   := MV_PAR05
LOCAL cCliFim   := MV_PAR06
LOCAL cDatIni   := MV_PAR07
LOCAL cDatFim   := MV_PAR08
LOCAL nTipVal   := IIF(cPaisLoc == "BRA",MV_PAR19,MV_PAR20)
LOCAL nSaldo    := 0
LOCAL nX        := 0
LOCAL nQtdVend  := FA440CntVen() // Retorna a quantidade maxima de Vendedores
LOCAL nValor	:= 0
LOCAL cQueryAdd := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("C6_FILIAL")
AADD(aCampos,{ "FILIAL"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_NUM")
AADD(aCampos,{ "NUM"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_CLI")
AADD(aCampos,{ "CLIENTE"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NOME")
AADD(aCampos,{ "NOMECLI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_LOJA")
AADD(aCampos,{ "LOJA"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_VEND1")
AADD(aCampos,{ "VENDEDOR"  ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NOME")
AADD(aCampos,{ "NOMEVEN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ENTREG")
AADD(aCampos,{ "DATENTR"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEM")
AADD(aCampos,{ "ITEM"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRODUTO")
AADD(aCampos,{ "PRODUTO"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_DESCRI")
AADD(aCampos,{ "DESCRICAO" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDVEN")
AADD(aCampos,{ "QUANTIDADE","N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDENT")
AADD(aCampos,{ "ENTREGUE"  ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_GRADE")
AADD(aCampos,{ "GRADE"     ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEMGRD")
AADD(aCampos,{ "ITEMGRD"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_TES")
AADD(aCampos,{ "TES"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLQ")
AADD(aCampos,{ "BLQ"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLOQUEI")
AADD(aCampos,{ "BLOQUEI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_VALOR")
AADD(aCampos,{ "VALOR"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_MOEDA")
AADD(aCampos,{ "MOEDA"   ,"N",aTam[1],aTam[2] } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

nOrdem  := aReturn[8]

dbSelectArea("TRB")
Do Case
	Case nOrdem = 1
		IndRegua("TRB",cArqTrab,"FILIAL+NUM+ITEM+PRODUTO",,,STR0015)       //"Selecionando Registros..."
	Case nOrdem = 2
		IndRegua("TRB",cArqTrab,"FILIAL+PRODUTO+NUM+ITEM",,,STR0015)       //"Selecionando Registros..."
	Case nOrdem = 3
		IndRegua("TRB",cArqTrab,"FILIAL+CLIENTE+LOJA+NUM+ITEM",,,STR0015)  //"Selecionando Registros..."
	Case nOrdem = 4
		IndRegua("TRB",cArqTrab,"FILIAL+DTOS(DATENTR)+NUM+ITEM",,,STR0015) //"Selecionando Registros..."
	Case nOrdem = 5
		IndRegua("TRB",cArqTrab,"FILIAL+VENDEDOR+NUM+ITEM",,,STR0015)      //"Selecionando Registros..."
EndCase

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o Filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
dbSetOrder(1)

#IFDEF TOP
	
	cAliasSC6 := "MR680Trab"
	aStruSC6  := SC6->(dbStruct())
	cQuery := "SELECT C6_FILIAL, C6_NUM,C6_CLI, C6_LOJA, C6_ENTREG, C6_ITEM, C6_PRODUTO, " 
	cQuery += " C6_DESCRI, C6_VALOR, C6_PRCVEN, C6_QTDVEN, C6_QTDENT, C6_GRADE, "
	cQuery += " C6_ITEMGRD, C6_TES, C6_BLQ, C6_BLOQUEI,C6_XMOEDA, C6_XPRUNIT "
	cQuery += "FROM "+RetSqlName("SC6")+" "
	cQuery += "WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND "
	cQuery += "C6_NUM >= '"+cPedIni+"' AND "
	cQuery += "C6_NUM <= '"+cPedFim+"' AND "
	cQuery += "C6_PRODUTO >= '"+cProIni+"' AND "
	cQuery += "C6_PRODUTO <= '"+cProFim+"' AND "
	cQuery += "C6_CLI >= '"+cCliIni+"' AND "
	cQuery += "C6_CLI <= '"+cCliFim+"' AND "
	cQuery += "C6_ENTREG >= '"+Dtos(cDatIni)+"' AND "
	cQuery += "C6_ENTREG <= '"+Dtos(cDatFim)+"' AND  "
	
	If mv_par13 == 3
		cQuery += "C6_BLQ = 'R ' AND "
	Endif	
	
	cQuery += "D_E_L_E_T_ = ' ' "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para tratamento do filtro do usuario.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("F680QRY")
		cQueryAdd := ExecBlock("F680QRY", .F., .F., {aReturn[7]})
		If ValType(cQueryAdd) == "C"
			cQuery += " AND ( " + cQueryAdd + ")"
		EndIf
	EndIf
	
	cQuery += "ORDER BY "+SqlOrder(IndexKey())
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC6,.T.,.T.)
	
	For nX := 1 To Len(aStruSC6)
		If ( aStruSC6[nX][2] <> "C" )
			TcSetField(cAliasSC6,aStruSC6[nX][1],aStruSC6[nX][2],aStruSC6[nX][3],aStruSC6[nX][4])
		EndIf
	Next nX
	
	dbSelectArea(cAliasSC6)
	
#ELSE
	
	cFilTrab   := CriaTrab("",.F.)
	cCondicao  := "C6_FILIAL=='"+xFilial("SC6")+"'.And."
	cCondicao  += "C6_NUM>='"+MV_PAR01+"'.And.C6_NUM<='"+MV_PAR02+"'.And."
	cCondicao  += "C6_PRODUTO>='"+MV_PAR03+"'.And.C6_PRODUTO<='"+MV_PAR04+"'.And."
	cCondicao  += "C6_CLI>='"+MV_PAR05+"'.And.C6_CLI<='"+MV_PAR06+"'.And."
	cCondicao  += "Dtos(C6_ENTREG)>='"+Dtos(MV_PAR07)+"'.And.Dtos(C6_ENTREG)<='"+Dtos(MV_PAR08)+"'"
	If mv_par13 == 3
		cCondicao += " .And. C6_BLQ == 'R ' "
	Endif	
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	IndRegua("SC6",cFilTrab,IndexKey(),,cCondicao,STR0015)    // "Selecionando Registros..."
	dbGoTop()
	
#ENDIF

ProcRegua(RecCount())                                         // Total de Elementos da Regua

While !Eof() .And. (cAliasSC6)->C6_FILIAL == xFilial("SC6")
	
	If ( Empty(aReturn[7]) .Or. &(aReturn[7]) )
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek( xFilial()+ (cAliasSC6)->C6_CLI + (cAliasSC6)->C6_LOJA )
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek( xFilial(("SF4"))+(cAliasSC6)->C6_TES )
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek( xFilial(("SC5"))+(cAliasSC6)->C6_NUM )
		
		dbSelectArea(cAliasSC6)
		
		If cPaisLoc <> "BRA"
			If ( SF4->F4_ESTOQUE == "S" .And. mv_par18 == 2 ) .Or. ( SF4->F4_ESTOQUE!= "S" .And. mv_par18 == 1 )
				dbSkip()
				Loop
			Endif
			If mv_par19 <> 4 .And. SC5->(FIELDPOS("C5_DOCGER")) > 0
				If (mv_par19 == 1 .And. SC5->C5_DOCGER <> '1' ) .Or.;//Gera nota
					(mv_par19 == 2 .And. SC5->C5_DOCGER <> '2' ) .Or.;//Gera REMITO
					(mv_par19 == 3 .And. SC5->C5_DOCGER <> '3' ) //Entrega futura
					dbSkip()
					Loop
				Endif
			Endif
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se esta dentro dos parametros						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet:=ValidMasc((cAliasSC6)->C6_PRODUTO,MV_PAR11)
		
		If Alltrim((cAliasSC6)->C6_BLQ) == "R" .and. mv_par13 == 2 // Se Foi Eliminado Residuos
			nSaldo  := 0
		Else
			nSaldo  := C6_QTDVEN-C6_QTDENT
		Endif
		
		If ((C6_QTDENT < C6_QTDVEN .And. MV_PAR09 == 1) .Or. (MV_PAR09 == 2)).And.;
			((nSaldo == 0 .And. MV_PAR14 == 1.And.Alltrim((cAliasSC6)->C6_BLQ)<>"R").Or. nSaldo <> 0).And.;
			((SF4->F4_DUPLIC == "S" .And. MV_PAR10 == 1) .Or. (SF4->F4_DUPLIC == "N";
			.And. MV_PAR10 == 2).Or.(MV_PAR10 == 3));
			.And. At(SC5->C5_TIPO,"DB") = 0 .And.lRet
			
			If nOrdem = 5
				
				cVend := "1"
				
				For nX := 1 to nQtdVend
					
					cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
					
					If !EMPTY(cVendedor) .And. (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
						
						dbSelectArea("SA3")
						dbSetOrder(1)
						dbSeek( xFilial()+cVendedor)
						
						dbSelectArea("TRB")
						RecLock("TRB",.T.)
						
						REPLACE VENDEDOR   WITH cVendedor
						REPLACE NOMEVEN    WITH SA3->A3_NOME
						REPLACE FILIAL     WITH (cAliasSC6)->C6_FILIAL
						REPLACE NUM        WITH (cAliasSC6)->C6_NUM
						REPLACE EMISSAO    WITH SC5->C5_EMISSAO
						REPLACE CLIENTE    WITH (cAliasSC6)->C6_CLI
						REPLACE NOMECLI    WITH SA1->A1_NOME
						REPLACE LOJA       WITH (cAliasSC6)->C6_LOJA
						REPLACE DATENTR    WITH (cAliasSC6)->C6_ENTREG
						REPLACE ITEM       WITH (cAliasSC6)->C6_ITEM
						REPLACE PRODUTO    WITH (cAliasSC6)->C6_PRODUTO
						REPLACE DESCRICAO  WITH (cAliasSC6)->C6_DESCRI
						REPLACE QUANTIDADE WITH (cAliasSC6)->C6_QTDVEN
						REPLACE ENTREGUE   WITH (cAliasSC6)->C6_QTDENT
						REPLACE GRADE      WITH (cAliasSC6)->C6_GRADE
						REPLACE ITEMGRD    WITH (cAliasSC6)->C6_ITEMGRD
						REPLACE TES        WITH (cAliasSC6)->C6_TES
						REPLACE BLQ        WITH (cAliasSC6)->C6_BLQ
						REPLACE BLOQUEI    WITH (cAliasSC6)->C6_BLOQUEI
						Replace STATUS     With cStatus
                        Replace XMOEDA      With IIF((cAliasQry)->C6_XMOEDA ==1, 'R$', 'US$')
                        Replace PRCUNIT    With (cAliasQry)->C6_XPRUNIT

						If nTipVal == 1 //--  Imprime Valor Total do Item
							nValor:=(cAliasSC6)->C6_VALOR						
						Else
							//--  Imprime Saldo
							If TRB->QUANTIDADE==0
								nValor:=(cAliasSC6)->C6_VALOR
							Else
								nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasSC6)->C6_PRCVEN
								nValor := If(nValor<0,0,nValor)
							EndIf
						EndIf							
						REPLACE VALOR      WITH nValor
						REPLACE MOEDA      WITH SC5->C5_MOEDA
						
						MsUnLock()
						
					Endif
					
					cVend := Soma1(cVend,1)
					
					dbSelectArea("SC5")
					dbSetOrder(1)
					
				Next nX
				
			Else
				
				lVend := .F.
				cVend := "1"
				
				For nX := 1 to nQtdVend
					cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
					If (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
						lVend :=.T.
						Exit
					Endif
					cVend := Soma1(cVend,1)
				Next nX
				
				If lVend
					
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					
					REPLACE FILIAL     WITH (cAliasSC6)->C6_FILIAL
					REPLACE NUM        WITH (cAliasSC6)->C6_NUM
					REPLACE EMISSAO    WITH SC5->C5_EMISSAO
					REPLACE CLIENTE    WITH (cAliasSC6)->C6_CLI
					REPLACE NOMECLI    WITH SA1->A1_NOME
					REPLACE LOJA       WITH (cAliasSC6)->C6_LOJA
					REPLACE DATENTR    WITH (cAliasSC6)->C6_ENTREG
					REPLACE ITEM       WITH (cAliasSC6)->C6_ITEM
					REPLACE PRODUTO    WITH (cAliasSC6)->C6_PRODUTO
					REPLACE DESCRICAO  WITH (cAliasSC6)->C6_DESCRI
					REPLACE QUANTIDADE WITH (cAliasSC6)->C6_QTDVEN
					REPLACE ENTREGUE   WITH (cAliasSC6)->C6_QTDENT
					REPLACE GRADE      WITH (cAliasSC6)->C6_GRADE
					REPLACE ITEMGRD    WITH (cAliasSC6)->C6_ITEMGRD
					REPLACE TES        WITH (cAliasSC6)->C6_TES
					REPLACE BLQ        WITH (cAliasSC6)->C6_BLQ
					REPLACE BLOQUEI    WITH (cAliasSC6)->C6_BLOQUEI
					Replace STATUS     With cStatus
                    Replace XMOEDA      With IIF((cAliasQry)->C6_XMOEDA ==1, 'R$', 'US$')
                    Replace PRCUNIT    With (cAliasQry)->C6_XPRUNIT

					If nTipVal == 1 //--  Imprime Valor Total do Item
						nValor:=(cAliasSC6)->C6_VALOR						
					Else
						//--  Imprime Saldo
						If TRB->QUANTIDADE==0
							nValor:=(cAliasSC6)->C6_VALOR
						Else
							nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasSC6)->C6_PRCVEN
							nValor := If(nValor<0,0,nValor)
						EndIf
					EndIf						
					REPLACE VALOR      WITH nValor
					REPLACE MOEDA      WITH SC5->C5_MOEDA
					
					lVend := .F.
					
					MsUnLock()
					
				Endif
				
			Endif
			
		Endif
		
	Endif
	
	dbSelectArea(cAliasSC6)
	IncProc()
	dbSkip()
	
End

#IFDEF TOP
	dbSelectArea(cAliasSC6)
	dbClosearea()
	dbSelectArea("SC6")
#ELSE
	dbSelectArea("SC6")
	RetIndex("SC6")
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Paulo Eduardo       ³Data³ 17.03.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
LOCAL cKey     := ""
LOCAL aHelpPor := {}
LOCAL aHelpEng := {}
LOCAL aHelpSpa := {}

If cPaisLoc <> "BRA"

	If SX1->(DbSeek("MTR68007"))
		RecLock("SX1",.F.)
		Replace SX1->X1_PERSPA With "¿De Fecha Entrega ?"
		Replace SX1->X1_PERENG With "From Delivery Date ?"
		SX1->(MsUnLock())
		SX1->(DbCommit())
	Endif

	If SX1->(DbSeek("MR680A07"))
		RecLock("SX1",.F.)
		Replace SX1->X1_PERSPA With "¿De Fecha Entrega ?"
		Replace SX1->X1_PERENG With "From Delivery Date ?"
		SX1->(MsUnLock())
		SX1->(DbCommit())
	Endif

	dbSelectArea("SX1")
	If MsSeek("MR680A13")
		If Empty(SX1->X1_DEF03) .Or. Empty(SX1->X1_DEFSPA3) .Or. Empty(SX1->X1_DEFENG3)
			RecLock("SX1",.F.)
			SX1->X1_DEF03   := "Somente"
			SX1->X1_DEFSPA3 := "Solamente"
			SX1->X1_DEFENG3 := "Only"
			MsUnlock()
		Endif
	Endif

	PutSx1("MR680A","20","Imprime             ","Imprime             ","Print               ","mv_chl","N",1,0,1,"C","","","","","mv_par20",;
	"Valor Total","Valor Total","Total Value","",;
	"Saldo","Saldo","Balance")	
	
	If MsSeek("MR680A")
		While !(EOF()) .and. SX1->X1_GRUPO == "MR680A"
			cKey := "P." + SX1->X1_GRUPO + SX1->X1_ORDEM + "."
			If SX1->X1_ORDEM < "18"
				If Empty(SX1->X1_HELP)
					RecLock("SX1",.F.)
					SX1->X1_HELP := ".MTR680" + SX1->X1_ORDEM + "."
					MsUnlock()
				EndIf
			Else
				If SX1->X1_ORDEM == "18"
					aHelpPor := {}
					aHelpSpa := {}
					aHelpEng := {}
					aAdd(aHelpPor,"Informe se o TES gera movimentacao")
					aAdd(aHelpPor,"no estoque")
					aAdd(aHelpSpa,"Informe si el TES genera movimiento")
					aAdd(aHelpSpa,"en el stock.")
					aAdd(aHelpEng,"Inform whether TIO generates stock")
					aAdd(aHelpEng,"movement.")
					PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
				ElseIf SX1->X1_ORDEM == "19"
					aHelpPor := {}
					aHelpSpa := {}
					aHelpEng := {}
					aAdd(aHelpPor,"Informe o tipo de documento a ser")
					aAdd(aHelpPor,"gerado.")
					aAdd(aHelpSpa,"Informe el tipo de documento que se")
					aAdd(aHelpSpa,"generara.")
					aAdd(aHelpEng,"Inform the document type to be")
					aAdd(aHelpEng,"generated.")
					PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
				ElseIf SX1->X1_ORDEM == "20"
					aHelpPor := {}
					aHelpSpa := {}
					aHelpEng := {}
					aAdd(aHelpPor,"Informe qual valor sera impresso")
					aAdd(aHelpPor,"no campo 'VALOR TOTAL'")
					aAdd(aHelpSpa,"Informe que valor se imprimira")
					aAdd(aHelpSpa,"en el campo 'VALOR TOTAL'")
					aAdd(aHelpEng,"Enter the value to be printed")
					aAdd(aHelpEng,"in 'TOTAL VALUE' field.")
					PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)										
				EndIf
			EndIf
			DbSkip()
		EndDo
	EndIf	
Else
	dbSelectArea("SX1")
	If MsSeek("RMTR68009")
		If Empty(SX1->X1_DEF02) .Or. Empty(SX1->X1_DEFSPA2) .Or. Empty(SX1->X1_DEFENG2)
			RecLock("SX1",.F.)
			SX1->X1_DEF02   := "Todos"
			SX1->X1_DEFSPA2 := "Todos"
			SX1->X1_DEFENG2 := "All"
			MsUnlock()
		Endif
	Endif

	dbSelectArea("SX1")
	If MsSeek("RMTR68013")
		If Empty(SX1->X1_DEF03) .Or. Empty(SX1->X1_DEFSPA3) .Or. Empty(SX1->X1_DEFENG3)
			RecLock("SX1",.F.)
			SX1->X1_DEF03   := "Somente"
			SX1->X1_DEFSPA3 := "Solamente"
			SX1->X1_DEFENG3 := "Only"
			MsUnlock()
		Endif
	Endif

	dbSelectArea("SX1")
	If MsSeek("RMTR68019")
		If Empty(SX1->X1_DEF01) .Or. Empty(SX1->X1_DEFSPA1) .Or. Empty(SX1->X1_DEFENG1) .Or.;
			Empty(SX1->X1_DEF02) .Or. Empty(SX1->X1_DEFSPA2) .Or. Empty(SX1->X1_DEFENG2)
			RecLock("SX1",.F.)
			SX1->X1_DEF01   := "Valor Total"
			SX1->X1_DEFSPA1 := "Valor Total"
			SX1->X1_DEFENG1 := "Total Value"
			SX1->X1_DEF02   := "Saldo"
			SX1->X1_DEFSPA2 := "Saldo"
			SX1->X1_DEFENG2 := "Balance"
			MsUnlock()
		Endif
	Else
		PutSx1("RMTR680","19","Imprime             ","Imprime             ","Print               ","mv_chj","N",1,0,1,"C","","","","","mv_par19",;
		"Valor Total","Valor Total","Total Value","",;
		"Saldo","Saldo","Balance")	
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Informe qual valor sera impresso")
		aAdd(aHelpPor,"no campo 'VALOR TOTAL'")
		aAdd(aHelpSpa,"Informe que valor se imprimira")
		aAdd(aHelpSpa,"en el campo 'VALOR TOTAL'")
		aAdd(aHelpEng,"Enter the value to be printed")
		aAdd(aHelpEng,"in 'TOTAL VALUE' field.")
		PutSX1Help("P.MTR68019.",aHelpPor,aHelpEng,aHelpSpa)						
	Endif

    If ! MsSeek("RMTR68020")
		aHelp := {}
		AAdd( aHelp, 'Digite o Codigo inicial do Segmento' )
		PutSx1("RMTR680",'20',"Do Segmento ?","Do Segmento ?","Do Segmento ?",'MV_Chk','C',6,0,0,'G','','ACY','','',"MV_PAR20","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)

		aHelp := {}
		AAdd( aHelp, 'Digite o Codigo Final do Segmento' )
		PutSx1("RMTR680",'21',"Ate o Segmento ?","Ate o Segmento ?","Ate o Segmento ?",'MV_Chl','C',6,0,0,'G','','ACY','','',"MV_PAR21","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)

    Endif
    
    If ! MsSeek("RMTR68022")
    
		aHelp := {}
		AAdd( aHelp, 'Digite o Codigo inicial da Familia' )
		PutSx1("RMTR680",'22',"Da Familia ?","Da Familia ?","Da Familia ?",'MV_Chm','C',2,0,0,'G','','SZ1','','',"MV_PAR22","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)

		aHelp := {}
		AAdd( aHelp, 'Digite o Codigo Final da Familia' )
		PutSx1("RMTR680",'23',"Ate a Familia ?","Ate a Familia ?","Ate a Familia ?",'MV_Chn','C',2,0,0,'G','','SZ1','','',"MV_PAR23","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)
    
    Endif
    
    
    If ! MsSeek("RMTR68024")
	   aHelp := {}
       AAdd( aHelp, 'Filtrar os pedidos a serem impressos' )
       PutSx1("RMTR680",'24','Status?','Status?','Status?','MV_CHo','C',1,0,0,'C','','','','',"MV_PAR24","Aberto","Aberto","Aberto","","Liberado","Liberado","Liberado","Reprovado","Reprovado","Reprovado","Cancelado","Cancelado","Cancelado","Todos","Todos","Todos",aHelp,aHelp,aHelp)
    Endif

EndIf

Return
         


User Function GrpsAcesso(cCodUser)
Local cGrupos := ""
Local cSql    := ""

Local cAdmVnds	:= GetMv("MV_TABPR94") 

If (cCodUser $ cAdmVnds)
	// Administracao Vendas
   cGrupo:="TODOS"
   Return cGrupo
Endif
 
cSql := "SELECT A3_GRPVEN "
cSql += "FROM "
cSql += "  " + RetSqlName("SA3") + " SA3 "
cSql += "WHERE "
cSql += "  A3_CODUSR = '" + cCodUser + "' "
cSql += "UNION ALL "
cSql += "SELECT VEN.A3_GRPVEN "
cSql += "FROM "
cSql += "  " + RetSqlName("SA3") + " GER JOIN " + RetSqlName("SA3") + " VEN ON "
cSql += "    GER.A3_FILIAL = VEN.A3_FILIAL   AND "
cSql += "    GER.D_E_L_E_T_ = ' '      AND "
cSql += "    VEN.D_E_L_E_T_ = ' '      AND "
cSql += "    GER.A3_COD = VEN.A3_GEREN "
cSql += "WHERE "
cSql += "  GER.A3_CODUSR = '" + cCodUser + "' "
cSql += "GROUP BY "
cSql += "  VEN.A3_GRPVEN "
TcQuery cSql New Alias "GRPS"
cGrupos += GRPS->A3_GRPVEN
GRPS->(DbSkip())
GRPS->(DbEval({|| cGrupos += "/" + A3_GRPVEN },,,,,.T.))         
GRPS->(DBCLOSEAREA("GRPS"))
Return AllTrim(cGrupos) 

  
                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ChkRegConfid     ºAutor  ³Caverna        º Data ³  04/26/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica a Regra de Confidencialidade aplicada na Makeni   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Primeiramente ela verifica se o usuario é Master/Adm Vendasº±±
               Neste Caso se o usuario for um Master, a funcao retorna a   ±±
               string "TODOS" indicando que o usuario terá acesso a todos  ±±
               os segmentos e em caso contrario retornará os segmentos aos ±±
               quais terá acesso.										   ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±Retorno    : Uma String separada por virgulas dos segmentos aos quais o  ±±
±±             usuário tem acesso										   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


