#include "rwmake.ch" 
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