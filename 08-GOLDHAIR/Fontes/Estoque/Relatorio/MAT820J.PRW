#include "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma          ³ MAT820J              º Analista    ³ Rogerio Moraes                         º  Data  ³     23/04/10    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao         ³ Relatorio Ordem de Producao - Formula Padrao.                                                          º±±
±±º                  ³ Alterado em 05/07/2011 - Luiz - Inclusao de Fase de Producao e Roteiro de Producao                     º±±
±±º                  ³                                                                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso               ³ Exclusivo : USO DA JAD                                                                                 º±±
±±º                  ³                                                                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MAT820J()

Private o_Rep

o_Rep := TReport():New("MAT820J","Ordem de Produção - Fórmula Padrão","MTR820",{|o_Rep| A000R001(o_Rep)},"Imprime a Ordem de Produção - Fórmula Padrão")
o_Rep:HideHeader()
o_Rep:HideFooter()
o_Rep:HideParamPage()
o_Rep:SetLandscape()
o_Rep:PrintDialog()

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Inicia a impressao do relatorio                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function A000R001(o_Rep)

c_Odi := mv_par01
c_Odf := mv_par02
c_Desc:= mv_par07    // 1 ou 3 = Imprime Endereco (A_QRY->B1_ENDER) e 2 = Imprime Descricao (A_QRY->B1_DESC) 

// mv_par14    // 1=Completo, 2=Fabrica ou 3=Embalagem
if Type("mv_par14") <> "N"
   Alert("Atenção: Erro nos parâmetros de impresão. Verifique os parâmetros do relatório.")
   Return()
endif
if mv_par14 <1 .or. mv_par14 > 3
   Alert("Atenção: Parâmetro Layout incorreto. Verifique os parâmetros do relatório.")
   Return()
endif
do case
   case mv_par14 = 1
        c_Impr := "C"
   case mv_par14 = 2
        c_Impr := "F"
   case mv_par14 = 3
        c_Impr := "E"
endcase        

c_Log := GetSrvProfString('Startpath','') + 'LOGOCS' + '.BMP'
//c_Log := "c:\drivef\protheus10\PROTHEUS_JAD\system\lgrlor.BMP"
c_Nop := " "
n_Ctr := 1
n_Num := 1
n_Reg := 0
n_Pag := 0
c_Tpo := " "
c_ProdAtual := ""
o_F09 := TFont():New('Verdana',9,9,,.T.,,,,.T.,.F.)
o_F10 := TFont():New('Verdana',10,10,,.T.,,,,.T.,.F.)
o_F11 := TFont():New('Verdana',11,11,,.F.,,,,.T.,.F.)
o_F12 := TFont():New('Verdana',12,12,,.T.,,,,.T.,.F.)
o_F13 := TFont():New('Verdana',13,13,,.F.,,,,.T.,.F.)
o_F13N:= TFont():New('Verdana',13,13,,.T.,,,,.T.,.F.)
o_F14 := TFont():New('Verdana',14,14,,.T.,,,,.T.,.F.)
o_F20 := TFont():New('Verdana',20,20,,.T.,,,,.T.,.F.)
o_Brs := TBrush():New(,CLR_GRAY)

If Select("A_QRY") > 0
	DbSelectArea("A_QRY")
	DbCloseArea()
EndIf


// Inclusao do campo G1_FASE na Query      	INNER   JOIN %table.SG1% SG1 ON SG1.G1_COD = SC2.C2_PRODUTO AND SG1.G1_COMP = SD4.D4_COD AND SG1.%NotDel%
// Inclusao do campo B1_ENDER na Query do componente
// Inclusao do campo D4_LOCAL na Query do componente
BeginSql alias "A_QRY"
	SELECT	SC2.C2_NUM,SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AS C2_OP,RTRIM(SC2.C2_PRODUTO)+'  ---  '+RTRIM(SBP.B1_DESC) AS BP_DESC,
	SC2.C2_QUANT,SC2.C2_OBS,SBP.B1_VOLEMB,SBP.B1_PHINI,SBP.B1_PHFIN,SBP.B1_DENINI,SBP.B1_DENFIN,SBP.B1_VISINI,SBP.B1_VISFIN,SBP.B1_PRVALID,
	SBP.B1_CORPAD,SBP.B1_ODOPAD,SBP.B1_ASPPAD,SBP.B1_VOLPESO,SBP.B1_UNDVOL,SC2.C2_SEQUEN,SD4.D4_COD,SD4.D4_TRT,
	SBC.B1_DESC,SBC.B1_TIPO,SBC.B1_UM,SBC.B1_SEGUM,SBC.B1_TIPCONV,SBC.B1_CONV,SUM(SD4.D4_QTDEORI) AS D4_QTDEORI,
	SUM(SD4.D4_QTDEORI-SD4.D4_QUANT) AS D4_QTDREA,SD4.D4_LOTECTL, SD4.D4_DTVALID,SD4.D4_LOCAL, SD4.D4_OP
	FROM	%table:SC2% SC2
	INNER	JOIN %table:SB1% SBP ON SC2.C2_PRODUTO = SBP.B1_COD AND SBP.%NotDel%
	INNER	JOIN %table:SD4% SD4 ON SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN = SD4.D4_OP AND SD4.%NotDel%
	INNER	JOIN %table:SB1% SBC ON SD4.D4_COD = SBC.B1_COD AND SBC.B1_TIPO IN('EM','MP','PI','PA') AND SBC.%NotDel%
	INNER   JOIN %table:SG1% SG1 ON SG1.G1_COD = SC2.C2_PRODUTO AND SG1.G1_COMP = SD4.D4_COD AND SG1.%NotDel%
	WHERE	SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN BETWEEN %exp:c_Odi% AND %exp:c_Odf% AND
	SC2.C2_FILIAL = %xfilial:SC2% AND SG1.G1_TRT = SD4.D4_TRT AND SC2.%NotDel%
	GROUP	BY SC2.C2_NUM,SC2.C2_ITEM,SC2.C2_SEQUEN,SC2.C2_PRODUTO,SBP.B1_DESC,SC2.C2_QUANT,SC2.C2_OBS,
	SBP.B1_VOLEMB,SBP.B1_PHINI,SBP.B1_PHFIN,SBP.B1_DENINI,SBP.B1_DENFIN,SBP.B1_VISINI,SBP.B1_PRVALID,
	SBP.B1_VISFIN,SBP.B1_CORPAD,SBP.B1_ODOPAD,SBP.B1_ASPPAD,SBP.B1_VOLPESO,SBP.B1_UNDVOL,
	SD4.D4_COD,SD4.D4_TRT,SBC.B1_DESC,SBC.B1_TIPO,SBC.B1_UM,SBC.B1_SEGUM,SBC.B1_TIPCONV,
	SBC.B1_CONV,SD4.D4_LOTECTL, SD4.D4_DTVALID,SD4.D4_LOCAL, SD4.D4_OP
	ORDER	BY SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN,SBC.B1_TIPO DESC, SD4.D4_COD,SD4.D4_OP
EndSql

n_Reg := RecCount("A_QRY")
o_Rep:SetMeter(n_Reg)
n_Li1 := 0870
n_Li2 := 0820

While A_QRY->(!Eof())
	
	If o_Rep:Cancel()
		Exit
	EndIf
	
	If c_Nop != A_QRY->C2_OP    // Se mudou de OP ou primeira impressao

//		n_Pag := 0
		
        if c_Tpo == "EM" .and. c_Impr $ "E"
           n_Pag := 0
	       o_Rep:EndPage()	
        endif

		If 	(c_Tpo == "MP" .or. c_Tpo == "PI" .or. c_Tpo == "PA") .and. c_Impr $ "CF"   // na primeira impressao nao executa
			
			a_Area := GetArea()
			DBSelectArea("SG2")
			DBSetOrder(3)
			if DBSeek(xFilial("SG2")+c_ProdAtual) .and. GetMV("MV_OPIMPRO") == "S"  
				o_Rep:EndPage()
				A000R006()              // Monta Pagina roteiro de producao
				o_Rep:Say(0325,2560,c_Num,o_F20)
				o_Rep:Say(0430,0360,c_Prd,o_F13)
				A000R007(c_ProdAtual)   // Imprime Pagina roteiro de producao
			endif
			RestArea(a_Area)
			
			o_Rep:EndPage()
			A000R003()      // Monta layout da segunda pagina - Producao e CQ
			
			o_Rep:Say(0350,2560,c_Num,o_F20)
			o_Rep:Say(0430,0360,c_Prd,o_F13)
			o_Rep:Say(0510,0360,c_Cli,o_F13)
			o_Rep:Say(1470,1560,c_Phi+" a "+c_Phf,o_F11)
			o_Rep:Say(1545,1560,c_Dei+" a "+c_Def,o_F11)
			o_Rep:Say(1615,1560,c_Vii+" a "+c_Vif,o_F11)
			o_Rep:Say(1680,1560,c_Cop,o_F11)
			o_Rep:Say(1755,1560,c_Odp,o_F11)
			o_Rep:Say(1825,1560,c_Asp,o_F11)
			o_Rep:Say(1895,2510,"    /        /    ",o_F11)
			o_Rep:Say(2035,2510,"    /        /    ",o_F11)
			o_Rep:EndPage()
		EndIf
		
		c_Num := TransForm(A_QRY->C2_OP,"@R 999999-99-999")
		c_Prd := A_QRY->BP_DESC
		c_Cli := A_QRY->C2_OBS
		c_Qua := TransForm(A_QRY->C2_QUANT,"@E 99,999")
		c_Vol := TransForm(A_QRY->B1_VOLPESO*A_QRY->C2_QUANT,"@E 99999.999")
		c_Lot := Subs(A_QRY->C2_NUM,3,4)
		c_Uni := A_QRY->B1_UNDVOL
		c_Phi := TransForm(A_QRY->B1_PHINI,"@E 99.99")
		c_Phf := TransForm(A_QRY->B1_PHFIN,"@E 99.99")
		c_Dei := TransForm(A_QRY->B1_DENINI,"@E 9.999")
		c_Def := TransForm(A_QRY->B1_DENFIN,"@E 9.999")
		c_Vii := TransForm(A_QRY->B1_VISINI,"@E 999999")
		c_Vif := TransForm(A_QRY->B1_VISFIN,"@E 999999")
		c_Prz := TransForm(int(A_QRY->B1_PRVALID/30),"@E 999")    //Prazo de Validade em Meses - B1_PRVALID em dias
		c_Cop := A_QRY->B1_CORPAD
		c_Odp := A_QRY->B1_ODOPAD
		c_Asp := A_QRY->B1_ASPPAD
		c_Nop := A_QRY->C2_OP
		n_Li1 := 0870
		n_Li2 := 0820
		
		n_Num := 1
		n_Ctr := 1

      if c_Impr $ "CF"
		o_Rep:EndPage()
		n_Pag := 0
        A000R002()            // Monta layout da primeira pagina - Formula
		o_Rep:Say(0330,2560,c_Num,o_F20)
		o_Rep:Say(0430,0360,c_Prd,o_F13)
		o_Rep:Say(0510,0360,c_Cli,o_F13)
		o_Rep:Say(0630,0400,c_Qua,o_F13)
		o_Rep:Say(0630,0950,c_Vol,o_F13)
		o_Rep:Say(0630,1130,c_Uni,o_F13)
		o_Rep:Say(0630,1360,c_Lot,o_F13)
		o_Rep:Say(0630,2380,c_Prz+"m",o_F13)
	  endif
	EndIf
	
	If (A_QRY->B1_TIPO == 'MP' .or. A_QRY->B1_TIPO == 'PI' .or. A_QRY->B1_TIPO == 'PA') .and. c_Impr $ "CF"
		
		//      c_QtdDec := val(substr(str(A_QRY->D4_QTDEORI,8,6),6,3))        // Para verificar se necessita alterar para g quando kg - IMPRIME EM G PARA TUDO (09/05/2012 - TATI)
		//        if c_QtdDec = 0
		// 		   c_Qtd := AllTrim(TransForm(A_QRY->D4_QTDEORI,"@E 9,999.999999"))
		//		   c_Und := A_QRY->B1_UM
		//	    else
		//  	   c_Qtd := AllTrim(TransForm(A_QRY->D4_QTDEORI*1000,"@E 9,999.999999"))
		//		   c_Und := "G"
		//        endif
		
		// CONVERTER TUDO DE KG PARA G PARA IMPRIMIR NA COLUNA DE QTDE (09/05/2012 - TATI)
		// VERIFICAR SE TEM 'MP' OU 'PI' DIFERENTE DE KG, SE TIVER, EMITE ALERTA MAS IMPRIME
		
		if A_QRY->B1_UM <> "KG"
			//Alert("Atenção: Verificar estrutura do produto da OP "+c_Num+" pois existe componente (MP ou PI) com a Unidade de Medida diferente de KG!")
			c_Qtd := AllTrim(TransForm(A_QRY->D4_QTDEORI,"@E 9,999.999999"))
			c_Und := c_Und := A_QRY->B1_UM
		else
			//          if A_QRY->B1_TIPO == 'PI'
			//   	         c_Qtd := AllTrim(TransForm(A_QRY->D4_QTDEORI,"@E 9,999.999999"))
			//	         c_Und := c_Und := A_QRY->B1_UM
			//          else
			c_Qtd := AllTrim(TransForm(A_QRY->D4_QTDEORI,"@E 9,999.999999"))
			c_Und := A_QRY->B1_UM
			//          endif
		endif
		
		n_Col := 1640
		
		If !Empty(A_QRY->B1_CONV) .And. !Empty(A_QRY->B1_TIPCONV) .And. !Empty(A_QRY->B1_SEGUM)
			If A_QRY->B1_TIPCONV == "M"
				c_Qtd := AllTrim(TransForm(A_QRY->D4_QTDEORI * A_QRY->B1_CONV,"@E 9,999.999999"))
				c_Und := A_QRY->B1_SEGUM
			Else
				c_Qtd := AllTrim(TransForm(A_QRY->D4_QTDEORI / A_QRY->B1_CONV,"@E 9,999.999999"))
				c_Und := A_QRY->B1_SEGUM
			EndIf
		EndIf
		
		o_Rep:Say(n_Li1,0155,A_QRY->D4_TRT,o_F11)
		//o_Rep:Say(n_Li1,0275,A_QRY->G1_FASE,o_F11)
		o_Rep:Say(n_Li1,0340,A_QRY->D4_COD,o_F11)
		
		//if c_Desc = 2 .or. A_QRY->B1_TIPO == 'PI'
		o_Rep:Say(n_Li1,0600,A_QRY->B1_DESC,o_F11)     // imprime Descricao do Componente
		//else
		//   o_Rep:Say(n_Li1,0520,A_QRY->B1_ENDER,o_F11)	   // imprime Endereco do Componente
		//endif
		
		For i := Len(c_Qtd) To 1 Step -1
			If Substr(c_Qtd,i,1) == "." .Or. Substr(c_Qtd,i,1) == ","
				n_Col -= 12
			Else
				n_Col -= 20
			EndIf
			o_Rep:Say(n_Li1,n_Col,Substr(c_Qtd,i,1),o_F11)
		Next
		
		o_Rep:Say(n_Li1,1250,A_QRY->D4_LOCAL,o_F11)
		o_Rep:Say(n_Li1,1675,c_Und,o_F11)
		o_Rep:Say(n_Li1,1880,Iif(!Empty(A_QRY->D4_LOTECTL),subs(A_QRY->D4_DTVALID,7,2)+"/"+subs(A_QRY->D4_DTVALID,5,2)+"/"+subs(A_QRY->D4_DTVALID,1,4),""),o_F11)
		o_Rep:Say(n_Li1,2200,A_QRY->D4_LOTECTL,o_F11)
		
		c_Qtd := 0
		c_Und := ""
		n_Col := 0
		n_Li1 += 70
		n_Num += 1
		
		If n_Num > 19
			o_Rep:EndPage()
			A000R002()
			n_Num := 1
			n_Li1 := 0870
			o_Rep:Say(0330,2560,c_Num,o_F20)
			o_Rep:Say(0430,0360,c_Prd,o_F13)
			o_Rep:Say(0510,0360,c_Cli,o_F13)
			o_Rep:Say(0630,0400,c_Qua,o_F13)
			o_Rep:Say(0630,0950,c_Vol,o_F13)
			o_Rep:Say(0630,1130,c_Uni,o_F13)
			o_Rep:Say(0630,1360,c_Lot,o_F13)
			o_Rep:Say(0630,2380,c_Prz+"m",o_F13)
		EndIf
		c_Tpo := "MP"
		c_ProdAtual := substr(A_QRY->BP_DESC,1,7)
//	Else
    Endif
    If (A_QRY->B1_TIPO <> 'MP' .and. A_QRY->B1_TIPO <> 'PI' .and. A_QRY->B1_TIPO <> 'PA') .and. c_Impr $ "CE"

		If n_Ctr == 1
          if c_Impr $ "C"
            a_Area := GetArea()
            DBSelectArea("SG2")
            DBSetOrder(3)
            if DBSeek(xFilial("SG2")+c_ProdAtual) .and. GetMV("MV_OPIMPRO") == "S"
  			   o_Rep:EndPage()          
			   A000R006()
   			   o_Rep:Say(0325,2560,c_Num,o_F20)
			   o_Rep:Say(0430,0360,c_Prd,o_F13)			
			   A000R007(c_ProdAtual)
            endif
            RestArea(a_Area)
            
			o_Rep:EndPage()
			A000R003()
		   
			o_Rep:Say(0350,2560,c_Num,o_F20)
			o_Rep:Say(0430,0360,c_Prd,o_F13)
			o_Rep:Say(0510,0360,c_Cli,o_F13)
			o_Rep:Say(1470,1560,c_Phi+" a "+c_Phf,o_F11)
			o_Rep:Say(1545,1560,c_Dei+" a "+c_Def,o_F11) 
			o_Rep:Say(1615,1560,c_Vii+" a "+c_Vif,o_F11)
			o_Rep:Say(1680,1560,c_Cop,o_F11)
			o_Rep:Say(1755,1560,c_Odp,o_F11)
			o_Rep:Say(1825,1560,c_Asp,o_F11)
			o_Rep:Say(1895,2510,"    /        /    ",o_F11)
			o_Rep:Say(2035,2510,"    /        /    ",o_F11) 
			o_Rep:EndPage() 
          endif
		    
		  A000R004()         // Monta layout da terceira pagina - Material de Embalagem
   		  o_Rep:Say(0350,2560,c_Num,o_F20)
		  o_Rep:Say(0430,0360,c_Prd,o_F13)
		  o_Rep:Say(0510,0360,c_Cli,o_F13)
	      n_Ctr += 1
		EndIf

        c_QtdDec := val(substr(str(A_QRY->D4_QTDEORI,8,6),6,3))                // Verifica se qtde esta resultando em empenho a partir da 4a. casa decimal
        if c_QtdDec <> 0
           Alert("Atenção: Verificar empenho/estrutura do produto da OP "+c_Num+" pois existe empenho de Embalagem com decimais incorretas!")
        endif

		c_Qtd := AllTrim(TransForm(A_QRY->D4_QTDEORI,"@E 9,999.999999"))
		c_Und := A_QRY->B1_UM 
		n_Col := 1765
	      			
		/*
		If !Empty(A_QRY->B1_CONV) .And. !Empty(A_QRY->B1_TIPCONV) .And. !Empty(A_QRY->B1_SEGUM)               
   			If A_QRY->B1_TIPCONV == "M"
     			c_Qtd := AllTrim(TransForm(A_QRY->D4_QTDEORI * A_QRY->B1_CONV,"@E 9,999.999999"))
      			c_Und := A_QRY->B1_SEGUM
   			Else
      			c_Qtd := AllTrim(TransForm(A_QRY->D4_QTDEORI / A_QRY->B1_CONV,"@E 9,999.999999"))
      			c_Und := A_QRY->B1_SEGUM
   			EndIf
		EndIf
		*/
	
	   dbSelectArea("SDC")
	   dbSetOrder(2)
	   If dbSeek(xFilial("SDC")+A_QRY->(D4_COD+D4_LOCAL+D4_OP),.F.)
		
		   While !Eof() .and. SDC->(DC_PRODUTO+DC_LOCAL+DC_OP) ==  A_QRY->(D4_COD+D4_LOCAL+D4_OP)

			   n_Col := 1765
			   c_Qtd := AllTrim(TransForm(SDC->DC_QUANT,"@E 9,999.999999"))
			
			   o_Rep:Say(n_Li2,0175,SDC->DC_PRODUTO,o_F11)
			   o_Rep:Say(n_Li2,0420,A_QRY->B1_DESC,o_F11)
			   o_Rep:Say(n_Li2,1280,SDC->DC_LOCAL,o_F11)
			   o_Rep:Say(n_Li2,1420,SDC->DC_LOCALIZ,o_F11)
			   For i := Len(c_Qtd) To 1 Step -1
				   If Substr(c_Qtd,i,1) == "." .Or. Substr(c_Qtd,i,1) == ","
					   n_Col -= 12
				   Else
					   n_Col -= 20
				   EndIf
				   o_Rep:Say(n_Li2,n_Col,Substr(c_Qtd,i,1),o_F11)
			   Next

			   o_Rep:Say(n_Li2,2075,c_Und,o_F11)

			   n_Li2 += 70
			
			   dbSkip()
		   EndDo
	   Else
		   n_Col := 1765
		   c_Qtd := AllTrim(TransForm(A_QRY->D4_QTDEORI,"@E 9,999.999999"))
			
		   o_Rep:Say(n_Li2,0175,A_QRY->D4_COD,o_F11)
		   o_Rep:Say(n_Li2,0420,A_QRY->B1_DESC,o_F11)
		   o_Rep:Say(n_Li2,1280,A_QRY->D4_LOCAL,o_F11)
		   o_Rep:Say(n_Li2,1420,'',o_F11)
		   For i := Len(c_Qtd) To 1 Step -1
			   If Substr(c_Qtd,i,1) == "." .Or. Substr(c_Qtd,i,1) == ","
				   n_Col -= 12
			   Else
				   n_Col -= 20
			   EndIf
		       o_Rep:Say(n_Li2,n_Col,Substr(c_Qtd,i,1),o_F11)
		   Next

		   o_Rep:Say(n_Li2,2075,c_Und,o_F11)

		   n_Li2 += 70
	
	   EndIf
	
	   dbSelectArea("A_QRY")
	   
	   c_Qtd := 0
	   c_Und := ""
	   n_Col := 0
	   //n_Li2 += 70
	   c_Tpo := "EM"
	   cProdAtual := substr(A_QRY->BP_DESC,1,7)
	EndIf

	A_QRY->(DbSkip())
	
	o_Rep:IncMeter()
	
End

If	(c_Tpo == "MP" .or. c_Tpo = "PI" .or. c_Tpo == "PA") .and. c_Impr $ "CF"
	
	a_Area := GetArea()
	DBSelectArea("SG2")
	DBSetOrder(3)
	if DBSeek(xFilial("SG2")+c_ProdAtual) .and. GetMV("MV_OPIMPRO") == "S"
		o_Rep:EndPage()
		A000R006()
		o_Rep:Say(0325,2560,c_Num,o_F20)
		o_Rep:Say(0430,0360,c_Prd,o_F13)
		A000R007(c_ProdAtual)
	endif
	RestArea(a_Area)
	
	o_Rep:EndPage()
	A000R003()
	
	o_Rep:Say(0350,2560,c_Num,o_F20)
	o_Rep:Say(0430,0360,c_Prd,o_F13)
	o_Rep:Say(0510,0360,c_Cli,o_F13)
	o_Rep:Say(1470,1560,c_Phi+" a "+c_Phf,o_F11)
	o_Rep:Say(1545,1560,c_Dei+" a "+c_Def,o_F11)
	o_Rep:Say(1615,1560,c_Vii+" a "+c_Vif,o_F11)
	o_Rep:Say(1680,1560,c_Cop,o_F11)
	o_Rep:Say(1755,1560,c_Odp,o_F11)
	o_Rep:Say(1825,1560,c_Asp,o_F11)
	o_Rep:Say(1895,2510,"    /        /    ",o_F11)
	o_Rep:Say(2035,2510,"    /        /    ",o_F11)
	
	o_Rep:EndPage()
EndIf

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Monta o layout da primeira pagina                                                                                           //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function A000R002()

n_Lin := o_Rep:Row()
o_Rep:SkipLine(2)

n_Lin := o_Rep:Row()
o_Rep:SayBitmap(n_Lin,0090,c_Log,510,255)
o_Rep:SkipLine(3)

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin,1272,"ORDEM DE PRODUÇÃO",o_F20,,CLR_RED)
o_Rep:SkipLine(3)

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin,1328,"FÓRMULA PADRÃO",o_F20,,CLR_RED)
o_Rep:SkipLine(6)

//n_Lin := o_Rep:Row()
//o_Rep:Say(n_Lin,0110,"DATA : "+Dtoc(dDatabase),o_F12)
//o_Rep:SkipLine(2)

//n_Lin := o_Rep:Row()
o_Rep:Say(0350,0110,"DATA/HORA: "+Dtoc(dDatabase)+"  -  "+Time(),o_F12)
o_Rep:Say(0350,2440,"NR: ",o_F12)
//o_Rep:SkipLine(3)

//n_Lin := o_Rep:Row()
o_Rep:Say(0430,0110,"PRODUTO :  ",o_F12)
//n_Lin := o_Rep:Row()
o_Rep:Say(0510,0110,"FABRIC. :  ",o_F12)
//o_Rep:SkipLine(2)

//n_Lin := o_Rep:Row()
o_Rep:FillRect({0590,0110,0605,3050},o_Brs)
//o_Rep:SkipLine(2)

//n_Lin := o_Rep:Row()
o_Rep:Say(0630,0110,"Qtde. em UN: ",o_F12)
o_Rep:Say(0630,0600,"Vol./Peso Prod.: ",o_F12)
o_Rep:Say(0630,1250,"Lote: ",o_F12)
o_Rep:Say(0630,1580,"Data Fabr.: ___/___/___",o_F12)
o_Rep:Say(0630,2180,"Prz.Val.: ",o_F12)
o_Rep:Say(0630,2550,"Data Valid.: ___/___/___",o_F12)
//o_Rep:SkipLine()

o_Rep:Box(0700,0110,2180,3050)

o_Rep:Line(0700,0240,2180,0240)   //1
o_Rep:Line(0700,0330,2180,0330)   //2
o_Rep:Line(0700,0580,2180,0580)   //3
o_Rep:Line(0700,1240,2180,1240)   //4
o_Rep:Line(0700,1330,2180,1330)   //5
o_Rep:Line(0700,1410,2180,1410)   //6
o_Rep:Line(0700,1650,2180,1650)   //7
o_Rep:Line(0700,1740,2180,1740)   //8
o_Rep:Line(0700,1820,2180,1820)   //9
o_Rep:Line(0700,2180,2180,2180)   //10
o_Rep:Line(0700,2460,2180,2460)   //11
o_Rep:Line(0700,2670,2180,2670)   //12
o_Rep:Line(0700,2750,2180,2750)   //13

For n_Lin := 0850 To 2110 Step 70
	o_Rep:Line(n_Lin,0110,n_Lin,3050)
Next

o_Rep:Say(0755,0150,"Seq",o_F10,,CLR_GRAY)
o_Rep:Say(0755,0250,"Fase",o_F10,,CLR_GRAY)
o_Rep:Say(0755,0350,"Código",o_F10,,CLR_GRAY)
o_Rep:Say(0755,0730,"Descricao",o_F10,,CLR_GRAY)
o_Rep:Say(0755,1250,"Arm",o_F10,,CLR_GRAY)
o_Rep:Say(0755,1340,"Sep",o_F10,,CLR_GRAY)
o_Rep:Say(0755,1485,"Qtde",o_F10,,CLR_GRAY)
o_Rep:Say(0755,1660,"Und",o_F10,,CLR_GRAY)
o_Rep:Say(0755,1753,"Pes",o_F10,,CLR_GRAY)
o_Rep:Say(0730,1960,"Data",o_F10,,CLR_GRAY)
o_Rep:Say(0780,1930,"Validade",o_F10,,CLR_GRAY)
o_Rep:Say(0755,2280,"Lote",o_F10,,CLR_GRAY)
o_Rep:Say(0755,2520,"Etq N°",o_F10,,CLR_GRAY)
o_Rep:Say(0755,2680,"Man",o_F10,,CLR_GRAY)
o_Rep:Say(0755,2795,"Observação",o_F10,,CLR_GRAY)



o_Rep:Say(2250,0125,"Pesagem Conferida e Aprovada por : __________________________________________________  Hora Início: ___:___   Hora Fim: ___:___",o_F12)
n_Pag := n_Pag + 1
o_Rep:Say(2330,1567,"- "+StrZero(n_Pag,3)+" -",o_F09)

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Monta o layout da segunda pagina                                                                                           //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function A000R003()

n_Lin := o_Rep:Row()
o_Rep:SkipLine(2)

n_Lin := o_Rep:Row()
o_Rep:SayBitmap(n_Lin,0090,c_Log,510,255)
o_Rep:SkipLine(6)

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin,1426,"PRODUÇÃO",o_F20,,CLR_RED)
o_Rep:SkipLine(6)

//n_Lin := o_Rep:Row()
//o_Rep:Say(n_Lin,0110,"DATA : "+Dtoc(dDatabase),o_F12)
//o_Rep:SkipLine(2)

n_Lin := o_Rep:Row()
o_Rep:Say(0350,0110,"DATA/HORA: "+Dtoc(dDatabase)+"  -  "+Time(),o_F12)
o_Rep:Say(n_Lin,2440,"NR: ",o_F12)
o_Rep:SkipLine(2)

n_Lin := o_Rep:Row()
o_Rep:Say(430,0110,"PRODUTO :  ",o_F12)
o_Rep:SkipLine(3)
n_Lin := o_Rep:Row()
o_Rep:Say(510,0110,"FABRIC. :  ",o_F12)
o_Rep:SkipLine(3)
n_Lin := o_Rep:Row()
o_Rep:FillRect({590,0110,605,3050},o_Brs)
o_Rep:SkipLine(2)

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin,0110,"- Início : ______:______ Hs",o_F13)
o_Rep:Say(n_Lin,1150,"Término : ______:______ Hs",o_F13)
o_Rep:SkipLine(3)

//n_Lin := o_Rep:Row()
//o_Rep:Say(n_Lin,0110,"- Amostra retirada para controle de qualidade : (  ) Sim          (  ) Não         Motivo : __________________________________________________",o_F13)
//o_Rep:SkipLine(3)

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin,0110,"- Peso final do lote : _____________________(Kg)",o_F13)
o_Rep:SkipLine(3)

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin,0110,"- Rendimento : _____________________(%)",o_F13)
o_Rep:SkipLine(3)

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin,0110,"- Ajuste de processo, foi necessário ?",o_F13)
o_Rep:SkipLine(2)

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin,0135,"(  ) Sim               (  ) Não",o_F13)
o_Rep:SkipLine(3)

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin,0110,"Em caso afirmativo, qual foi o ajuste ?",o_F13)
o_Rep:SkipLine(3)

n_Lin := o_Rep:Row()
o_Rep:Line(n_Lin,0110,n_Lin,3050)
o_Rep:SkipLine()

n_Lin := o_Rep:Row()
o_Rep:FillRect({n_Lin,0110,n_Lin+15,3050},o_Brs)
o_Rep:SkipLine()

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin,1219,"CONTROLE DE QUALIDADE",o_F20,,CLR_RED)

o_Rep:Line(1360,1550,1360,3050)
o_Rep:Line(1360,1550,2090,1550)
o_Rep:Line(1360,2300,2090,2300)
o_Rep:Line(1360,3050,1460,3050)

o_Rep:Box(1460,0110,2090,3050)

For n_Lin := 1530 To 2020 Step 70
	o_Rep:Line(n_Lin,0110,n_Lin,3050)
Next

o_Rep:Say(1380,1848,"Padrão",o_F14,,CLR_GRAY)
o_Rep:Say(1380,2593,"Análise",o_F14,,CLR_GRAY)
o_Rep:Say(1470,0120,"- pH :",o_F13)
o_Rep:Say(1545,0120,"- Densidade :",o_F13)
o_Rep:Say(1615,0120,"- Viscosidade :",o_F13)
o_Rep:Say(1680,0120,"- Cor :",o_F13)
o_Rep:Say(1755,0120,"- Odor :",o_F13)
o_Rep:Say(1825,0120,"- Aspecto :",o_F13)
o_Rep:Say(1895,0120,"- Data Análise :",o_F13)
o_Rep:Say(1965,0120,"- Resp. pela Análise :",o_F13)
o_Rep:Say(2035,0120,"- Data Aprovação / Liberação do lote :",o_F13)
o_Rep:Say(2110,0110,"Obs. :",o_F14)

o_Rep:Say(1895,1560,"/////////////////////////",o_F14,,CLR_GRAY)
o_Rep:Say(1965,1560,"/////////////////////////",o_F14,,CLR_GRAY)
o_Rep:Say(2035,1560,"/////////////////////////",o_F14,,CLR_GRAY)

o_Rep:Line(2210,0110,2210,3050)
o_Rep:Line(2310,0110,2310,3050)

n_Pag := n_Pag + 1
o_Rep:Say(2330,1567,"- "+StrZero(n_Pag,3)+" -",o_F09)

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Monta o layout da terceira pagina                                                                                           //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function A000R004()

n_Lin := o_Rep:Row()
o_Rep:SkipLine(2)

n_Lin := o_Rep:Row()
o_Rep:SayBitmap(n_Lin,0090,c_Log,510,255)
o_Rep:SkipLine(3)

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin,1231,"ORDEM DE PRODUÇÃO",o_F20,,CLR_RED)
o_Rep:SkipLine(3)

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin,1171,"MATERIAL DE EMBALAGEM",o_F20,,CLR_RED)
o_Rep:SkipLine(6)

//n_Lin := o_Rep:Row()
//o_Rep:Say(n_Lin,0110,"DATA : "+Dtoc(dDatabase),o_F12)
//o_Rep:SkipLine(2)

n_Lin := o_Rep:Row()
o_Rep:Say(0350,0110,"DATA/HORA: "+Dtoc(dDatabase)+"  -  "+Time(),o_F12)
o_Rep:Say(n_Lin,2440,"NR: ",o_F12)
o_Rep:SkipLine(2)

n_Lin := o_Rep:Row()
o_Rep:Say(430,0110,"PRODUTO :  ",o_F12)
o_Rep:SkipLine(3)
n_Lin := o_Rep:Row()
o_Rep:Say(510,0110,"FABRIC. :  ",o_F12)
o_Rep:SkipLine(3)
n_Lin := o_Rep:Row()
o_Rep:FillRect({590,0110,605,3050},o_Brs)
o_Rep:SkipLine(2)

o_Rep:Box(0620,0110,2060,3050)

o_Rep:Line(0620,0410,2060,0410)
o_Rep:Line(0620,1250,2060,1250)
o_Rep:Line(0620,1380,2060,1380)
o_Rep:Line(0620,1515,2060,1515)
o_Rep:Line(0620,1780,2060,1780)
o_Rep:Line(0620,2050,2060,2050)
o_Rep:Line(0620,2150,2060,2150)
o_Rep:Line(0620,2600,2060,2600)

For n_Lin := 0800 To 1990 Step 70
	o_Rep:Line(n_Lin,0110,n_Lin,3050)
Next

o_Rep:Say(0675,0195,"Código",o_F14,,CLR_GRAY)
o_Rep:Say(0675,0500,"Descrição Itens",o_F14,,CLR_GRAY)
o_Rep:Say(0675,1270,"Arm",o_F14,,CLR_GRAY)
o_Rep:Say(0675,1420,"End",o_F14,,CLR_GRAY)
o_Rep:Say(0635,1605,"Qtde",o_F14,,CLR_GRAY)
o_Rep:Say(0705,1555,"Separada",o_F14,,CLR_GRAY)
o_Rep:Say(0635,1865,"Qtde",o_F14,,CLR_GRAY)
o_Rep:Say(0705,1820,"Utilizada",o_F14,,CLR_GRAY)
o_Rep:Say(0675,2055,"Und",o_F14,,CLR_GRAY)
o_Rep:Say(0635,2245,"Resp. Separ.",o_F14,,CLR_GRAY)
o_Rep:Say(0635,2705,"Resp. Conf.",o_F14,,CLR_GRAY)
o_Rep:Say(0705,2315,"Itens",o_F14,,CLR_GRAY)
o_Rep:Say(0705,2710,"Separação",o_F14,,CLR_GRAY)

o_Rep:Say(2250,0125,"Separação Conferida e Aprovada por : _______________________________________________  Hora Início: ___:___   Hora Fim: ___:___",o_F12)
n_Pag := n_Pag + 1
o_Rep:Say(2330,1567,"- "+StrZero(n_Pag,3)+" -",o_F09)

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Busca o lote do fornecedor                                                                                                  //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function A000R005(c_Prd,c_Lot)

Local c_Ret := " "

If !Empty(c_Lot)
	
	If Select("A_AUX") > 0
		DbSelectArea("A_AUX")
		DbCloseArea()
	EndIf
	
	BeginSql alias "A_AUX"
		SELECT	DISTINCT SD1.D1_LOTEFOR
		FROM	%table:SD1% SD1
		WHERE	SD1.D1_COD = %exp:c_Prd% AND
		SD1.D1_LOTECTL = %exp:c_Lot% AND
		SD1.D1_FILIAL = %xfilial:SD1% AND
		SD1.%NotDel%
	EndSql
	
	While A_AUX->(!Eof())
		c_Ret := A_AUX->D1_LOTEFOR
		
		A_AUX->(DbSkip())
		
	End
	
EndIf

Return(c_Ret)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Monta o Layout da Pagina do Roteiro de Producao                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function A000R006()

n_Lin := o_Rep:Row()
o_Rep:SkipLine(2)

n_Lin := o_Rep:Row()
o_Rep:SayBitmap(n_Lin,0090,c_Log,510,255)
o_Rep:SkipLine(3)

n_Lin := o_Rep:Row()
o_Rep:Say(n_Lin+100,1340,"ROTEIRO DE PRODUÇÃO",o_F20,,CLR_RED)
o_Rep:SkipLine(3)

o_Rep:Say(0350,0110,"DATA/HORA: "+Dtoc(dDatabase)+"  -  "+Time(),o_F12)
o_Rep:Say(0350,2440,"NR: ",o_F12)
o_Rep:Say(0430,0110,"PRODUTO  :  ",o_F12)

n_Lin := o_Rep:Row()
o_Rep:FillRect({500,0110,515,3050},o_Brs)
o_Rep:SkipLine(2)

o_Rep:Box(0570,0110,0640,3050)  // somente do cabecalho

o_Rep:Line(0570,0240,0640,0240)   // linha separando verticalmente o box do cabecalho

//For n_Lin := 0570 To 2320 Step 70     // linhas separando horizontalmene o box - dos detalhes
//	o_Rep:Line(n_Lin,0110,n_Lin,3050)
//Next

o_Rep:Say(0580,0155,"Seq",o_F10,,CLR_GRAY)
o_Rep:Say(0580,0255,"Operação",o_F10,,CLR_GRAY)
n_Pag := n_Pag + 1
o_Rep:Say(2330,1567,"- "+StrZero(n_Pag,3)+" -",o_F09)

Return()



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Imprime o Roteiro de Producao - Tabela SG2                                                                                  //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function A000R007(c_Produto)

If Select("A_SG2") > 0
	DbSelectArea("A_SG2")
	DbCloseArea()
EndIf

c_Produto := substr(c_Produto,1,7)

BeginSql alias "A_SG2"
	SELECT	SG2.G2_PRODUTO, SG2.G2_CODIGO, SG2.G2_OPERAC
	FROM	%table:SG2% SG2
	WHERE	G2_PRODUTO = %exp:c_Produto% AND
	SG2.G2_FILIAL = %xfilial:SG2% AND
	SG2.%NotDel%
	ORDER	BY SG2.G2_OPERAC
EndSql

nLinha   := 660
nContador:=1
nLinIniBox:=640
nLinFinBox:=640


// A descricao da operacao devera conter no maximo duas linhas porque existindo mais que duas linhas torna a utilizacao inviavel pois deixa a operacao
// muito complexa. Observacao: Confirmado com Luciana da JAD em 05/07/11

While A_SG2->(!Eof())
	
	cDescr_1 := StrTran(Posicione("SG2",1,xFilial("SG2")+A_SG2->G2_PRODUTO+A_SG2->G2_CODIGO+A_SG2->G2_OPERAC,"G2_DESCR_1"), chr(13))
	
	nTamanho := len(rtrim(cDescr_1))
	nMaxLinha := MaxLinha(cDescr_1)
	nCD := 1
	cDesc1 := ""
	cDesc2 := ""
	
	if !nTamanho > nMaxLinha
		cDesc1:=substr(cDescr_1,1,nTamanho)
	else
		nInicio := nMaxLinha+1   // inicio da proxima cadeia
		while .T.
			if substr(cDescr_1,nInicio,1) = " "
				exit
			else
				nInicio := nInicio - 1
				if nInicio = 0
					nInicio = nMaxLinha+1
					exit
				endif
			endif
		enddo
		cDesc1:=substr(cDescr_1,1,nInicio)
		cDesc2:=substr(cDescr_1,nInicio+1,nTamanho-nInicio)
		nCD:=2
	endif
	
	if nCD = 1
		o_Rep:Say(nLinha,160,A_SG2->G2_OPERAC,o_F11)
		o_Rep:Say(nLinha,255,cDesc1,o_F11)
		nLinha    := nLinha + 70
		nContador := nContador + 1
		o_Rep:Box(nLinIniBox,0110,nLinIniBox+70,3050)
		o_Rep:Line(nLinIniBox,0240,nLinIniBox+70,0240)
		nLinIniBox:=nLinIniBox+70
	else
		if nContador = 24
			A000R006()
			o_Rep:Say(0325,2560,c_Num,o_F20)
			o_Rep:Say(0430,0360,c_Prd,o_F13)
			nLinha := 660
			nContador := 3
			o_Rep:Say(nLinha,160,A_SG2->G2_OPERAC,o_F11)
			o_Rep:Say(nLinha,255,cDesc1,o_F11)
			o_Rep:Say(nLinha+50,255,cDesc2,o_F11)
			nLinIniBox:=640
			o_Rep:Box(nLinIniBox,0110,nLinIniBox+120,3050)
			o_Rep:Line(nLinIniBox,0240,nLinIniBox+120,0240)
			nLinIniBox:=nLinIniBox+120
		else
			o_Rep:Say(nLinha,160,A_SG2->G2_OPERAC,o_F11)
			o_Rep:Say(nLinha,255,cDesc1,o_F11)
			o_Rep:Say(nLinha+50,255,cDesc2,o_F11)
			nLinha    := nLinha + 120
			nContador := nContador + 2
			o_Rep:Box(nLinIniBox,0110,nLinIniBox+120,3050)
			o_Rep:Line(nLinIniBox,0240,nLinIniBox+120,0240)
			nLinIniBox:=nLinIniBox+120
		endif
	endif
	
	A_SG2->(DbSkip())
	
	if !Eof() .and. nContador = 25
		o_Rep:EndPage()
		A000R006()
		o_Rep:Say(0325,2560,c_Num,o_F20)
		o_Rep:Say(0430,0360,c_Prd,o_F13)
		nLinha := 660
		nContador = 1
		nLinIniBox:=640
	endif
	
Enddo

Return()


*/
STATIC FUNCTION MaxLinha(cString,nTamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para saber quantos caracteres irão caber na linha ³
//³ visto que letras ocupam mais espaço do que os números.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local nMax	:= 0
Local nY   	:= 0
Default nTamanho := 2790

For nMax := 1 to Len(cString)
	If IsAlpha(SubStr(cString,nMax,1)) .And. IsUpper(SubStr(cString,nMax,1)) .AND. SubStr(cString,nMax,1) $ "MOQW"  // Caracteres que ocupam mais espaço em pixels
		nY += 33
	Else
		nY += 18
	EndIf
	
	If nY > nTamanho   // é o máximo de espaço para uma coluna
		nMax--
		Exit
	EndIf
Next

Return nMax
