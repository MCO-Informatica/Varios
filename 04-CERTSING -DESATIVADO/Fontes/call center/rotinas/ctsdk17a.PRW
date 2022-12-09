#include 'protheus.ch'    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSDK17a   ºAutor  ³Leandro Nishihata  º Data ³  07/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³' Auxilia preenchimento do campo body na configuracao do 	  º±±
±±º          ³ corpo do html com base no modelo padrao certisign		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTSDK17a()

Local sTmpBody  	:= ""
Local aBody 		:= array(7,2)
Local i 			:= 1
Local enter			:= .T.
Local ctext			:= ""
Local Txtfim		:= ""
Local lFim			:= .F.
Local cTag			:= ""
Local aPergs 		:= {}
Local aRet 			:= {}
Local cbox			:= .T.
Local ordenc		:= space(7)
Local bOK 			:= {|| .T. }

// separa os blocos dentro da array
sTmpBody := alltrim(m->ky_body)
sTmpBody := alltrim(substr(sTmpBody,1,len(alltrim(sTmpBody))-3))

WHILE !lFim
	enter := .T.
	while enter // retira os "enter" do texto
		IF substr(sTmpBody,1,1) == Chr(13) .or. substr(sTmpBody,1,1) == Chr(10)
			sTmpBody := alltrim(substr(sTmpBody,2,len(sTmpBody)))
		else
		  enter := .F.
		endif		
	enddo	
	
	sTmpBody := alltrim(substr(sTmpBody,at("[",sTmpBody),len(alltrim(sTmpBody))))
	cTag := upper(substr(sTmpBody,at("[",sTmpBody)+1,at("]",sTmpBody)-at("[",sTmpBody)-1)) // armazena a tag 
	I := at("]",sTmpBody)+1
	sTmpBody := alltrim(substr(sTmpBody,i,len(alltrim(sTmpBody))))

	enter := .T.
	
	// retira linhas em branco.
	while enter 
		IF substr(sTmpBody,1,1) == Chr(13) .or. substr(sTmpBody,1,1) == Chr(10)
			sTmpBody := alltrim(substr(sTmpBody,2,len(sTmpBody)))
		else
		  enter := .F.
		endif		
	enddo		
	if at("[",sTmpBody) > 0 
		Txtfim := at("[",sTmpBody)-1
	else 
		Txtfim := len(sTmpBody)
		lFim := .T.
	endif		
	 
	//ctext   := CharSet(substr(sTmpBody,1,Txtfim))
	ctext   := substr(sTmpBody,1,Txtfim)

	DO CASE
	 	CASE UPPER(cTag) = "CABECALHO" 
	 		aBody[1][2] := ctext
	 		aBody[1][1] := cTag
	 	CASE UPPER(cTag) = "DETALHE CABECALHO" 
	 		aBody[2][2] := ctext
	 		aBody[2][1] := cTag
	 	CASE UPPER(cTag) = "PROTOCOLO" 
	 		aBody[3][2] := ""
	 		aBody[3][1] := cTag
	 	CASE UPPER(cTag) = "DADOS CADASTRAIS" 
	 		aBody[4][2] := ctext
	 		aBody[4][1] := cTag 
	 	CASE UPPER(cTag) = "SITUACAO" 
	 		aBody[5][2] := ctext
	 		aBody[5][1] := cTag 
	 	CASE UPPER(cTag) = "INTERACOES" 
	 		aBody[6][2] := ctext
	 		aBody[6][1] := cTag 
	 	CASE UPPER(cTag) = "RODAPE"
	 		aBody[7][2] := ctext
	 		aBody[7][1] := cTag 
	endcase
enddo

If !empty(ALLTRIM(m->KY_AUXBODY)) 
 	Do case 	
	 	CASE ALLTRIM(m->KY_AUXBODY) = "1" // CABECALHO
	 		aAdd( aPergs ,{11,"Cabeçalho",,,,.T.})   	 	
	 		cbox := .T.
	 	CASE ALLTRIM(m->KY_AUXBODY) = "2" // DETALHE CABECALHO
	 		aAdd( aPergs ,{11,"Detalhe do cabeçalho",,,,.T.})   	 	
	 		cbox := .T.	 	
	 	CASE ALLTRIM(m->KY_AUXBODY) = "3" // PROTOCOLO - essa opcao nao tem conteudo, somente a tag
	 		aBody[val(m->KY_AUXBODY)][2] :=	"" 
	 		if msgyesno("Incluir protocolo de atendimento ?")
	 			aBody[val(m->KY_AUXBODY)][1] :=	"PROTOCOLO" 
	 		endif
	 		cbox := .F.
	 	CASE ALLTRIM(m->KY_AUXBODY) = "4" // DADOS CADASTRAIS
	 		aAdd(aPergs,{1,"Dados cadastrais :",Space(999),"","mv_par01:=u_dadoscad()","","",90,.T.})
	 		cbox := .T.	 	
	 	CASE ALLTRIM(m->KY_AUXBODY) = "5" // SITUACAO
	 		aAdd(aPergs,{1,"Situação :",Space(999),"","mv_par01:=u_dadoscad()","","",90,.T.}) 
	 		cbox := .T.	 	
	 	CASE ALLTRIM(m->KY_AUXBODY) = "6" // INTERACOES
	 		
	 		aAdd( aPergs ,{3,"Ordenação",1, {"Crescente", "Decrescente"}, 50,'.T.',.T.})   
	 		aAdd( aPergs ,{3,"Interações",1, {"Todas", "Somente última"}, 50,'.T.',.T.})   
	 		aAdd( aPergs ,{9,"Selecionar Colunas ",200, 10,.T.})
	 		aAdd( aPergs ,{5,"1 - Item",.T., 90,'.T.',.T.})   
	 		aAdd( aPergs ,{5,"2 - Área",.T., 90,'.T.',.T.})
	 		aAdd( aPergs ,{5,"3 - Ação",.T., 90,'.T.',.T.})
	 		aAdd( aPergs ,{5,"4 - Ocorrência",.T., 90,'.T.',.T.})
	 		aAdd( aPergs ,{5,"5 - Consultor",.T., 90,'.T.',.T.})	 			 			 			 		
	 		aAdd( aPergs ,{5,"6 - Data/Hora",.T., 90,'.T.',.T.})	 		
	 		aAdd( aPergs ,{5,"7 - Observacao",.T., 90,'.T.',.T.})
	 		aAdd( aPergs ,{1,"Ordem das colunas(1 a 7): ",ordenc,"9999999",'mv_par11 := u_vldordem()',,'.T.',50,.F.})   
	 		cbox := .T.	 	
	 	CASE ALLTRIM(m->KY_AUXBODY) = "7" // RODAPE
	 		aAdd( aPergs ,{11,"Rodapé",,,,.T.})
	 		cbox := .T.	
	 	Endcase
	
	if cbox
		If ParamBox(aPergs ,"Parametros ",aRet) 
		 	aBody[val(m->KY_AUXBODY)][1] := X3Combo("KY_AUXBODY",m->KY_AUXBODY)
		    If ALLTRIM(m->KY_AUXBODY) = "6"	
		    	aBody[val(m->KY_AUXBODY)][2] := if(aret[1] = 1,"crescente","decrescente")+Chr(13) + Chr(10)
    			aBody[val(m->KY_AUXBODY)][2] += if(aret[2] = 1,"todas","ultima")+Chr(13) + Chr(10)
		    	mv_par11 := if(len(alltrim(mv_par11)) = 0,"1234567",mv_par11)
		    	For i:= 1 to len(mv_par11)
		    		if aRet[val(substr(mv_par11,i,1))+3]
			    		do case
			    			case substr(mv_par11,i,1) == "1"  
			    				aBody[val(m->KY_AUXBODY)][2] += "Item" +Chr(13) + Chr(10)
			    			case substr(mv_par11,i,1) == "2"  
			    				aBody[val(m->KY_AUXBODY)][2] += "area"+Chr(13) + Chr(10)
			    			case substr(mv_par11,i,1) == "3"  
			    				aBody[val(m->KY_AUXBODY)][2] += "acao"+Chr(13) + Chr(10)
			    			case substr(mv_par11,i,1) == "4"  
			    				aBody[val(m->KY_AUXBODY)][2] += "ocorrencia"+Chr(13) + Chr(10)
			    			case substr(mv_par11,i,1) == "5"  
			    				aBody[val(m->KY_AUXBODY)][2] += "consultor"+Chr(13) + Chr(10)
			    			case substr(mv_par11,i,1) == "6"  
			    				aBody[val(m->KY_AUXBODY)][2] += "datahora"+Chr(13) + Chr(10)
			    			case substr(mv_par11,i,1) == "7"	
			    				aBody[val(m->KY_AUXBODY)][2] += "Observacao"+Chr(13) + Chr(10)
			    			endcase
		    		endif
		    	next 1	
		    Else
		    	aBody[val(alltrim(m->KY_AUXBODY))][2] := aRet[1]		    
		    Endif
	   	EndIf
	endif
Endif

// Remonta o texto conforme o padrao pré-stabelecido.
sTmpBody := " %!U_CTSDK17()!% " + Chr(13)+Chr(10)
sTmpBody += " <!-- " 

For  i:=1 to len(aBody)
	If !empty(aBody[i][1]) 				
		sTmpBody +=  "["+ aBody[i][1] +"] " + Chr(13) + Chr(10)	
		If !empty(aBody[i][2])
		sTmpBody +=  aBody[i][2] + if(substr(alltrim(aBody[i][2]),len(aBody[i][2])-1,len(aBody[i][2])) ==  Chr(13) + Chr(10),"",  Chr(13) + Chr(10))
		endif
	Endif	
Next
sTmpBody += " --> "
m->ky_body := sTmpBody
M->KY_AUXBODY := "0"
Return .t.			

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  dadoscad        ³ Autor ³Leandro Nishihata             	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Monta tela de seleção dos dados cadastrais                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para o CERTISIGN                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user Function dadoscad()

Local _TITULO		:={}
Local _CAMPO:= ""
Local _Temp 	:= ""
Local _MV_PAR 	:= space(6)
Local _cTamanho :=1
Local i			:= 1

if ALLTRIM(m->KY_AUXBODY) = "4"
	
	aadd(_TITULO,"Contato" )  
	_CAMPO+= left("U5_CONTAT "+space(10),10)
	aadd(_TITULO,"Razão social")
	_CAMPO+= left("A1_NOME"+space(10),10)
	aadd(_TITULO,"Código")
	_CAMPO+= left("ADE_CODCON"+space(10),10)
	aadd(_TITULO,"Cpf/cnpj")
	_CAMPO+= left("A1_CGC"+space(10),10)
	aadd(_TITULO,"Telefone")
	_CAMPO+= left("A1_TEL"+space(10),10)
	aadd(_TITULO,"E-mail do contato")
	_CAMPO+= left("ADE_TO"+space(10),10)
	aadd(_TITULO,"E-mail adicional")
	_CAMPO+= left("ADE_CC"+space(10),10)

else

	aadd(_TITULO,"Data abertura" )  
	_CAMPO+= left("ADE_DATA"+space(10),10)
	aadd(_TITULO,"Criticidade")
	_CAMPO+= left("ADE_SEVCOD"+space(10),10)
	aadd(_TITULO,"Código")
	_CAMPO+= left("ADE_CODCON"+space(10),10)
	aadd(_TITULO,"Situação atual")
	_CAMPO+= left("ADE_STATUS"+space(10),10)
	aadd(_TITULO,"Data previsão")
	_CAMPO+= left("ADE_DTEXPI"+space(10),10)
	aadd(_TITULO,"Área Responsável")
	_CAMPO+= left("ADE_GRUPO"+space(10),10)
	aadd(_TITULO,"Solicitação")
	_CAMPO+= left("ADE_CODINC"+space(10),10)
	

endif

f_Opcoes(@_Temp,'Selecione os campos',_TITULO,_CAMPO,,,.F.,10,30)
_MV_PAR:=""
For i:=1 to len(_Temp)
	If Substr(_Temp,i,1) # '*'
		_MV_PAR += Substr(_Temp,I,1)
			IF _cTamanho  = 10
			   _MV_PAR   += ","
			   _cTamanho :=1
			Else
				_cTamanho ++
			Endif
	Endif
Next
	
_MV_PAR := substr(_MV_PAR,1,len(_MV_PAR)-1)

Return _MV_PAR

// funcao de validacao do campo ordem
User function vldordem()

Local i		 := 1
Local tmp_mv := ""
Local adupl	 := {}
// Retira valores incorretos

for i:=1 to len(alltrim(mv_par11))
	if val(substr(mv_par11,i,1)) <= 7
		mv_par11 := if(at(alltrim(str(i)),mv_par11) > 0,mv_par11,alltrim(mv_par11)+alltrim(str(i)))
		tmp_mv += substr(mv_par11,i,1)
	endif	 
next i
mv_par11 := tmp_mv
tmp_mv := ""
// Retira valores duplicados
for i:=1 to len(alltrim(mv_par11))
	if ascan(adupl,substr(mv_par11,i,1)) = 0
		aadd(adupl,substr(mv_par11,i,1))
		tmp_mv += substr(mv_par11,i,1)
	endif	 
next i
mv_par11 := tmp_mv
// Completa campos
for i:=1 to 7
	mv_par11 := if(at(alltrim(str(i)),mv_par11) > 0,mv_par11,alltrim(mv_par11)+alltrim(str(i))) 
next i

return mv_par11