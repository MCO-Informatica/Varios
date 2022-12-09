#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³REPC01  ºAutor  ³Wellington Mendes      º Data ³  27/10/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressã do Pedido de Compras via Crystal Reports            ±±
±±º                                                                       º±±
±±ºUso       ³ Exclusivo RENOVA                                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


/*
CallCrys (<cRpt>,<cParams>,<cOptions>, [lWaitRun], [lShowGauge], [lRunOnServer], [lToFile]) ->cReport
Sendo:
<cRpt>         = Nome do relatório.
<cParams>      = Parâmetros do relatório, separados por vírgula (,) ou ponto e vírgula (;). Caso este parâmetro seja marcado,
serão desconsiderados os parâmetros marcados no SX1.
<cOptions>     = Opções para não se mostrar a tela de configuração de impressão no formato <x>;<y>;<z>;<w>. Sendo:
x = Impressão em Vídeo(1), Impressora(2), Impressora(3), Excel(4), Excel Tabular(5), PDF(6), Texto(7) e Word(8).
y = Atualiza Dados(0) ou não(1).
z = Número de cópias. Para exportação este valor sempre deverá ser 1.
w = Título do Report. Para exportação este será o nome do arquivo sem extensão.
[lWaitRun]     = Indica se deve interromper a execução da função CallCrys até o fechamento do relatório.
[lShowGauge]   = Indica se a barra de progressão da geração do relatório deve ser exibida.
[lRunOnServer] = Indica se a execução do relatório deve ser feita no servidor.
[lToFile]      = Indica se o relatório gerado no servidor deve ser mantido apenas em arquivo, sem exibição para o usuário.
*/

User function REPC01()
Local aSays:={}, aButtons:={}
Local nOpca	:=0
Private cCadastro := OemToAnsi("Impressão Pedido de Compras Grupo Renova")

AADD (aSays, OemToAnsi(" Este programa Ira Gerar a Impressão do Pedido de Compras Via Crystal Reports   "))
AADD (aSays, OemToAnsi("                                                                                "))
AADD (aSays, OemToAnsi("                                                                                "))
cPerg := "REPC01"
Ajusta()
pergunte(cPerg,.F.)

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
FormBatch( cCadastro, aSays, aButtons )

If nOpcA == 1
	cOptions := CVALTOCHAR(Mv_par10)+';0;1;REPC01'
	
	cParams:= CVALTOCHAR(Mv_par01)+';'+CVALTOCHAR(Mv_par02)+';'+Mv_par03+';'+Mv_par04+';'+Mv_par05+';'+Mv_par06+';'+Mv_par07+';'+Mv_par08+';'+CVALTOCHAR(Mv_par09)
	
	cFile := CriaTrab(cParams,.F.)
	
	CallCrys("REPC01",cFile,cOptions,.T.,.T.,.F.,.F.)
	//CallCrys("REPC01",cFile,cOptions)
EndIf

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Ajusta    ³ Autor ³ Márcio Menon	 		  ³ Data ³ 11/12/2006		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	³±±
±±³          ³ no SX3                                                           	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ 																		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Idioma-Language ?             ","¿Idioma-Language ?            ","Idioma-Language ?             ","mv_ch1","C",1,0,1,"C",""                    ,"mv_par01","1=Portugues    ","1=Portugues    ","1=Portugues    ","","","2=Ingles       ","2=Ingles       ","2=Ingles       ","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Vias-Impression ?             ","¿Vias-Impression ?      	     ","Vias-Impression ?          	  ","mv_ch2","C",1,0,1,"C",""                    ,"mv_par02","1              ","1              ","1              ","","","2              ","2              ","2              ","","","3           ","3           ","3           ","","","             ","          ","     ","","","         ","      ","     ","","","","",""})
Aadd(aPergs,{"E-mail ?      	            ","¿E-mail ?                     ","E-mail ?                	  ","mv_ch3","C",50,0,0,"G",""                   ,"mv_par03","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Contato-Contact ?             ","¿Contato-Contact ?            ","Contato-Contact ?             ","mv_ch4","C",40,0,0,"G",""                   ,"mv_par04","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Pedido de ?                   ","¿Pedido de ?                  ","Pedido de ?                   ","mv_ch5","C",6,0,0,"G","SC7"                 ,"mv_par05","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Pedido Até ?                  ","¿Pedido Até ?                 ","Pedido Até ?                  ","mv_ch6","C",6,0,0,"G","SC7"                 ,"mv_par06","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Comprador-Purchase ?          ","¿Comprador-Purchase ?         ","Comprador-Purchase ?          ","mv_ch7","C",40,0,0,"G",""                   ,"mv_par07","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Observacao-Observation ?      ","¿Observacao-Observation ?     ","Observacao-Observation ?      ","mv_ch8","C",60,0,0,"G",""                   ,"mv_par08","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Valor com Imp-Value Taxas ?   ","¿Valor com Imp-Value Taxas ?  ","Valor com Imp-Value Taxas ?   ","mv_ch9","C",1,0,2,"C",""                    ,"mv_par09","1=Sim          ","1=Si           ","1=Yes          ","","","2=Nao          ","2=No           ","2=No           ","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Tipo Impressao ?              ","¿Tipo Impressao ?             ","Tipo Impressao ?              ","mv_ch10","C",1,0,1,"C",""                   ,"mv_par10","1=Video        ","1=Video        ","1=Video        ","","","2=Impressora2  ","2=Impressora2 ","2=Impressora2   ","","","3=Impress3  ","3=Impress3  ","3=Impress3  ","","","4=Excel(4)","4=Excel(4)","4=Excel(4)","","","","","","","","","",""})

AjustaSx1("REPC01",aPergs)

Return












