#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATA017 ³ Autor ³ 	Robson Bueno         ³ Data ³ 18.04.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Alimentacao de FOLLOW-UP de entrega                         ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ...                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³XXXXXXXXXXXXXX³XX/XX/XX³XXXXXX³                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATA017()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCores    := {},aCampos:={}

aCores    := {{	'C6_QTDENT<>C6_QTDVEN', 'BR_VERDE'},;	        // Pedido a Faturar
			   {'C6_QTDENT==C6_QTDVEN', 'BR_VERMELHO'}}        // Pedido Faturado

PRIVATE aRotina := { { "Pesquisar","AxPesqui"  ,0,1},;       // Pesquisa  PI
					 { "Visualizar","AxVisual",0,2},;        //  Vizualiza PI
                     { "Env.Sep.","U_RFTL17C",0,3},;        //  Vizualiza PI
                     { "Ret.Sep.","U_RFTL17D",0,4},;        //  Vizualiza PI
                     { "Disposicao","U_RFTL17A",0,5},;       // Aprova SA Bloqueada                       
					 { "Legenda","U_RFTL17B",0,6} }  
						
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemToAnsi("Follow-up do PV")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
aCampos := {{"Pedido","C6_NUM"},{"Item","C6_ITEM"},{"Codigo","C6_PRODUTO"},{"Descricao","C6_DESCRI"},{"Qtd","C6_QTDVEN"},{"Entregue","C6_QTDENT"},{"Prazo","C6_ENTREG"},{"Disposicao","C6_STATUS"}}
mBrowse(6,1,22,75,"SC6",aCampos,,,,3,aCores)

Return(.T.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Legenda									             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                 
User Function RFTL17B()

BrwLegenda(cCadastro,"Situacoes",{{"BR_VERMELHO","Pedido Ja Faturado"}, {"BR_VERDE","Pedido a Faturar"}})

Return (.T.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dialogo para insersao de followup                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function RFTL17A()

Local oDlgl

PRIVATE cStatus:=SC6->C6_STATUS

		
@ 000,000 To 400,400 Dialog Odlg1 Title OemToAnsi("Follow up de vendas")
@ 003,004 To 25,200 Title OemToAnsi("Processo") 
@ 010,015 Say OemToAnsi("Pedido") OF Odlgl PIXEL
//@ 035,015 GET cTpAverb SIZE 30,10 F3 "12" 
@ 010,055 Say SC6->C6_NUM SIZE 45,10 PICTURE PesqPict("SC6","C6_NUM")OF Odlgl PIXEL
@ 010,115 Say OemToAnsi("Item")OF Odlgl PIXEL
//@ 035,015 GET cTpAverb SIZE 30,10 F3 "12" 
@ 010,155 say SC6->C6_ITEM SIZE 30,10 PICTURE PesqPict("SC6","C6_ITEM")OF Odlgl PIXEL


@ 027,004 To 120,200 Title OemToAnsi("Dados do Produto") 
@ 035,015 Say OemToAnsi("Produto")OF Odlgl PIXEL
@ 035,055 Say SC6->C6_PRODUTO SIZE 100,10 PICTURE PesqPict("SC6","C6_COD") OF Odlgl PIXEL  
@ 047,015 Say OemToAnsi("Descricao")OF Odlgl PIXEL
@ 047,055 SAY SC6->C6_DESCRI SIZE 200,10 PICTURE PesqPict("SC6","C6_DESCRI")OF Odlgl PIXEL
@ 059,015 Say OemToAnsi("Qtd Venda")OF Odlgl PIXEL
@ 059,055 SAY SC6->C6_QTDVEN SIZE 30,10 PICTURE PesqPict("SC6","C6_QTDVEN")OF Odlgl PIXEL
@ 071,015 Say OemToAnsi("Qtd Entr.")OF Odlgl PIXEL
@ 071,055 SAY SC6->C6_QTDENT SIZE 30,10 PICTURE PesqPict("SC6","C6_QTDENT")OF Odlgl PIXEL
@ 083,015 Say OemToAnsi("Prazo")OF Odlgl PIXEL
@ 083,055 SAY SC6->C6_ENTREG SIZE 40,10 PICTURE PesqPict("SC6","C6_ENTREG") OF Odlgl PIXEL 

@ 123,004 To 170,200 Title OemToAnsi("Follow_up") 
@ 130,015 msGET cStatus SIZE 170,10 PICTURE PesqPict("SC6","C6_STATUS")OF Odlgl PIXEL
 
@ 180,100 BMPBUTTON TYPE 1 ACTION OkProc(odlg1)
@ 180,150 BMPBUTTON TYPE 2 ACTION FINALIZA(odlg1)

Activate Dialog Odlg1 CENTER

Return(.T.)

Static Function Finaliza(Odlg1)

Close(Odlg1)

RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OkProc    ºAutor  ³Robson Bueno        º Data ³ 10/08/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Confirmacao do Processo de digitacao dados                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³HCI                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OkProc(odlg1)
*
Local cAliasSC6 := GetArea()
RecLock("SC6",.F.)
SC6->C6_STATUS := cStatus 
MsUnLock()
*
Close(Odlg1)
RestArea(cAliaSSC6)
*
Return
                 
