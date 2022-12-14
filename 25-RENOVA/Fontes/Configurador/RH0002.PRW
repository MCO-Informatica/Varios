#include "rwmake.ch" 
/*
CallCrys (<cRpt>,<cParams>,<cOptions>, [lWaitRun], [lShowGauge], [lRunOnServer], [lToFile]) ->cReport
Sendo:
<cRpt>         = Nome do relat?rio.
<cParams>      = Par?metros do relat?rio, separados por v?rgula (,) ou ponto e v?rgula (;). Caso este par?metro seja marcado, 
                 ser?o desconsiderados os par?metros marcados no SX1.
<cOptions>     = Op??es para n?o se mostrar a tela de configura??o de impress?o no formato <x>;<y>;<z>;<w>. Sendo:
			 	 x = Impress?o em V?deo(1), Impressora(2), Impressora(3), Excel(4), Excel Tabular(5), PDF(6), Texto(7) e Word(8).
			 	 y = Atualiza Dados(0) ou n?o(1).
			 	 z = N?mero de c?pias. Para exporta??o este valor sempre dever? ser 1.
			 	 w = T?tulo do Report. Para exporta??o este ser? o nome do arquivo sem extens?o.
[lWaitRun]     = Indica se deve interromper a execu??o da fun??o CallCrys at? o fechamento do relat?rio.
[lShowGauge]   = Indica se a barra de progress?o da gera??o do relat?rio deve ser exibida.
[lRunOnServer] = Indica se a execu??o do relat?rio deve ser feita no servidor.
[lToFile]      = Indica se o relat?rio gerado no servidor deve ser mantido apenas em arquivo, sem exibi??o para o usu?rio.
*/
User function RH0002()
	Local aSays:={}, aButtons:={}
	Local nOpca	:=0
	Private cCadastro := OemToAnsi("Gerar RH0002")
	
	AADD (aSays, OemToAnsi(" Este programa ira gerar O RH0002                                               "))
	AADD (aSays, OemToAnsi("                                                                                "))
	AADD (aSays, OemToAnsi("                                                                                "))
	cPerg := "RH0002"
	Pergunte(cPerg,.F.)
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	FormBatch( cCadastro, aSays, aButtons )
	
	If nOpcA == 1
		cOptions := '1;0;1;RH0002'
		
		cParams:= Mv_par01+';'+Mv_par02
		
		CallCrys("RH0002",cParams,cOptions,.F.,.T.,.T.,.F.)
	EndIf
	     
	Return .t.