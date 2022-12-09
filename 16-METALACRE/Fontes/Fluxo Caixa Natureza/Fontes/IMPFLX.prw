#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#INCLUDE "rwmake.ch"

#DEFINE NATUREZA		001
#DEFINE DESCRICAO		002
#DEFINE REGISTRO		003

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IMPFLX   บAutor  ณLuiz Alberto V Alvesบ Data ณ  31/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao de Fluxo de Caixa  บฑฑ
ฑฑบ          ณ                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Vanguarda                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
User Function IMPFLX()
Local aArea	:= GetArea()
Local aHR
Local aEntida
Local aAgenda
Private oFont, cCode, oPrn                                        

Processa( {|| PrepImpFlx()},"Aguarde Imprimindo Agenda..." )

RestArea(aArea)
Return .t.

Static Function PrepImpFlx()
Local aArea := GetArea()

dbSelectArea("TRB2")
dbGoTop()      
Count To nReg
dbGoTop()
ProcRegua(nReg)

nTotCol := TRB2->(FCount())-3

cHtml 	:= '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
cHtml 	+= '<html> '
cHtml 	+= '<head> '
cHtml 	+= '  <meta content="text/html; charset=ISO-8859-1" '
cHtml 	+= ' http-equiv="content-type"> '
cHtml 	+= '  <title></title> '
cHtml 	+= '</head> '
cHtml 	+= '<body> '
cHtml 	+= '<table style="text-align: left; width: 100%;" border="1" '
cHtml 	+= ' cellpadding="2" cellspacing="2"> '
cHtml 	+= '  <tbody> '
cHtml 	+= '    <tr> '
cHtml 	+= '      <td colspan="' + AllTrim(Str(nTotCol,3)) + '" rowspan="1"><big style="font-weight: bold;"><big>' + SM0->M0_CODIGO +'/'+SM0->M0_CODFIL+' '+SM0->M0_NOMECOM+'</big></big></td> '
cHtml 	+= '    </tr> '
cHtml 	+= '    <tr align="center"> '
cHtml 	+= '      <td style="background-color: rgb(204, 204, 255);" '
cHtml 	+= ' colspan="' + AllTrim(Str(nTotCol,3)) + '" rowspan="1"><big><big><big>Fluxo de Caixa por Natureza</big></big></big></td> '
cHtml 	+= '    </tr> '
cHtml 	+= '    <tr> '
cHtml 	+= '      <td style="background-color: rgb(153, 153, 153); text-align: center;">Natureza</td> '
cHtml 	+= '      <td style="background-color: rgb(153, 153, 153);">Descri&ccedil;&atilde;o</td> '

for _ni := 1 to len(_aCpos) // Monta campos com as datas
	cHtml 	+= '<td style="background-color: rgb(153, 153, 153); text-align: center;">'+Iif(_nDiasPer==1,_aLegPer[_ni],Left(MesExtenso(Right(_aLegPer[_ni],2)),3)+'/'+SubStr(_aLegPer[_ni],1,4))+'</td> '
next _dData

cHtml 	+= '      <td style="background-color: rgb(153, 153, 153); text-align: center;">Total</td> '
cHtml 	+= '      </tr> '
cHtml 	+= '          <tr> '

While TRB2->(!Eof())
	IncProc("Gerando Visใo Fluxo de Caixa em HTML")
	
	cDesc   := "TRB2->DESCRICAO"
	
	cHtml 	+= ' <td> ' + TRB2->GRUPO  + '</td> '
	cHtml 	+= ' <td> ' + &cDesc + '</td> '
	for _ni := 1 to len(_aCpos) // Monta campos com as datas
		cHtml 	+= ' <td style="text-align: right;"> ' + TransForm(TRB2->&(_aCpos[_ni]),'@E 99,999,999.99')  + '</td> '
	next _dData
	cHtml 	+= ' <td style="text-align: right;"> ' + TransForm(TRB2->TOTAL,'@E 999,999,999,999.99')  + '</td> '

	cHtml 	+= ' </tr> '

	TRB2->(dbSkip(1))
Enddo

cHtml 	+= '<td colspan="' + AllTrim(Str(nTotCol,3)) + '" rowspan="1" '
cHtml 	+= ' style="background-color: rgb(153, 153, 153);"><big style="font-weight: bold;">OBS: Receitas (Recebidas) e Despesas (Pagas) Realizadas no Financeiro.</big></td> '
cHtml 	+= '    </tr> '
cHtml 	+= '  </tbody> '
cHtml 	+= '</table> '
cHtml 	+= '<br> '
cHtml 	+= '</body> '
cHtml 	+= '</html>   '

cArquivo := "C:\TEMP\fluxo.html"
memowrite(cArquivo,cHtml)
ShellExecute("open",cArquivo,"","", 5 )
    
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se em disco, desvia para Spool                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RecAgenda   บAutor ณLuiz Albertoบ Data ณ  Maio/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela Principal                                    บฑฑ
ฑฑบ          ณ Gera็ใo Financeira, Agenda, Controle de Aulas บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PILATES                                       บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function txtSem(cSem)
If cSem=='1'
	Return 'Domingo'
ElseIf cSem=='2'
	Return 'Segunda-Feira'
ElseIf cSem=='3'
	Return 'Ter็a-Feira'
ElseIf cSem=='4'
	Return 'Quarta-Feira'
ElseIf cSem=='5'
	Return 'Quinta-Feira'
ElseIf cSem=='6'
	Return 'Sexta-Feira'
ElseIf cSem=='7'
	Return 'Sแbado'
Endif	
Return ''
