#include "Protheus.ch"

User Function MTA650I()
Local aArea := GetArea()
Local aAreasb1 := sb1->(GetArea())
//Local aPar := {}
//Local aRet := {}
//Local lCont := .t.
Local cNumOp := ""
Local nQtd := 0
Local cPasta := GetNewPar( "MV_XPASETQ", "C:\ETIQUETAS PCP\")
Local nMvpar01 := mv_par01
Local nMvpar02 := mv_par02

	if funname() == "MATA650" .and. sc2->c2_sequen == '001' .and. sb1->(dbseek(xfilial()+sc2->c2_produto)) .and. sb1->b1_tipo = 'PA' .and. ;
		MsgYesNo("Gostaria de fazer a impressão das Etiquetas e Formalários de Controle de Produção ?")

		if !ExistDir( substr(cPasta,1,len(cPasta)-1) )
		   if MakeDir( substr(cPasta,1,len(cPasta)-1) ) != 0
		      msginfo( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
		   endif
		endif

		cNumOp := sc2->c2_num
		nQtd   := 1
		u_EtqPro(cNumOp,nQtd,cPasta)
		u_FormPro(cNumOp,cPasta)

		/*
		While lCont
			lCont := .f.
			aAdd(aPar,{9,"O arquivo Etq será gerado em: "+cPasta,200,7,.T.})
			aAdd(aPar,{1,"QTD vias ",1  ,"@E 99","Positivo()","",".T.",0,.T.})
			if ParamBox(aPar,"Impressão de etiqueta e Formulários...",@aRet)
				if aRet[2] <= 0
					MsgStop("Qtd Vias deve ser apontado !")
					lCont := .t.
				endif
				cNumOp := sc2->c2_num
				nQtd   := aRet[2]

				u_EtqPro(cNumOp,nQtd,cPasta)
				u_FormPro(cNumOp,cPasta)
			elseif !MsgYesNo("Deseja cancelar a impressão da etiqueta/formulários ?")
				lCont := .t.
				aPar[2,3] := aRet[2]
			else
				Par := {}
				aRet := {}
			endif
		end
		*/

	endif
	mv_par01 := nMvpar01
	mv_par02 := nMvpar02
	restArea(aAreasb1)
	restArea(aArea)
return
