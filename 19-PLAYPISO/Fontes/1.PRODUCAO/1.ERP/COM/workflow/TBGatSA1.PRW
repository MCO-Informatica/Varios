#Include "Protheus.ch"
#Include "TopConn.ch"


// ricardo avaliar
/*/{Protheus.doc} TBLibSA1
Biblioteca de tratativa de campos no cadastro de Clientes (SA1)
@type User_function
@version  1
@author Fabio
@since 21/04/2021
@param cCampo, character, Campo que vai disparar a fun??o
@return Logical, Retorna True para prosseguir se n?o houve tratativa
/*/
User Function TBLibSA1(cCampo,cTipo)
	Local xRet        := .T.
	Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]"
	Local nI          := 0
	Local cMsg 		  := ""

	Default cCampo    := ""
	Default cTipo     := "C"

	//Campo Vazio? Se Sim sai do fonte
	If !Empty(cCampo)

		//TIPO DE RETORNO
		If cTipo == "C"
			//CAMPO
			If cCampo == "A1_CEP"
				IF !Empty(U_RmvChEsp(M->A1_CEP))

					//	If M->A1_PESSOA $ "FJ"
					//		M->A1_CEP 	  := Transform(M->A1_CEP,"@R 99999-999")
					//	Else
					//		M->A1_CEP 	  := Transform(M->A1_CEP,"XXXXXXXXXX")
					//	EndIf
					M->A1_CEPE := M->A1_CEP
					M->A1_CEPC := M->A1_CEP
				EndIf

				MsgAlert("Acessar 'outras a??es' / 'mashup: Correios - Pesquisa de CEP' "+Chr(13)+Chr(10)+;
					"para preenchimento autom?tico dos campos de Endere?o, Bairro e Cidade","Aten??o")


				//CAMPO
			ElseIf cCampo == "A1_PESSOA" //.AND. cDestino == "A1_MUNICIP" //RFATG02()

				M->A1_COD := RFATG03()

				IF M->A1_PESSOA$"'E'"
					M->A1_MUN     := "EXTERIOR"
					M->A1_MUNICIP := "EXTERIOR"
					M->A1_EST     := "EX"
					M->A1_TIPO    := "F"
					M->A1_RECINSS := "1"
					M->A1_RECCSLL := "S"
					M->A1_RECPIS  := "S"
					M->A1_RECISS  := '1'
					M->A1_INCISS  := "S"
					//M->A1_CEP 	  := Transform(M->A1_CEP,"XXXXXXXXXX")
					M->A1_COD_MUN := "EX"
					M->A1_CODMUNE := "EX"
					M->A1_XCDMUNC := "EX"
					M->A1_REGIAO  := "006"
					M->A1_DSCREG  := "EXTERIOR"

				ElseIf M->A1_PESSOA$"'J','F'"
					M->A1_MUN     := Space(TamSX3("A1_MUN")[1])
					M->A1_MUNICIP := M->A1_MUN
					M->A1_EST     := Space(TamSX3("A1_EST")[1])
					M->A1_PAIS    := "105"
					M->A1_CODPAIS := "01058"
					M->A1_PAISDES := "BRASIL"
					M->A1_TIPO    := "F"
					M->A1_RECINSS := "S"
					M->A1_RECCSLL := "S"
					M->A1_RECPIS  := "S"
					M->A1_RECCOFI := "S"
					M->A1_INCISS  := "S"
					M->A1_RECISS  := '1'
					//M->A1_CEP 	  := Transform(M->A1_CEP,"@R 99999-999")
				EndIf

				If M->A1_PESSOA == "F"
					M->A1_XPINSCR := "2"
					M->A1_INSCR   := "ISENTO"
					M->A1_CNAE    := Space(TamSX3("A1_CNAE")[1])
					MsgAlert("Por favor, verifique o cadastro de n?veis quando o cliente ? pessoa f?sica","Aten??o")

				ElseIf M->A1_PESSOA == "E"
					M->A1_XPINSCR := "2"
					M->A1_INSCR   := "ISENTO"
					M->A1_CNAE    := Space(TamSX3("A1_CNAE")[1])

				Else
					M->A1_XPINSCR := " "
					M->A1_INSCR   := Space(TamSX3("A1_INSCR")[1])
					M->A1_CNAE    := Space(TamSX3("A1_CNAE")[1])

					cMsg := "Para Pessoas Jur?dicas, ? obrigat?rio o preenchimento dos campos:" +Chr(13)+Chr(10);
						+"1 - CPF/CNPJ"				+Chr(13)+Chr(10);
						+"2 - Inscri??o Estadual "	+Chr(13)+Chr(10);
						+"3 - Utilize a rotina de mashup, 'Receita Federal - CNPJ',"	+Chr(13)+Chr(10);
						+"para que seja preenchido o campo de CNAE corretamente. "

					//	MsgAlert(cMsg,"Aten??o")
				EndIf

				//CAMPO
			ElseIf cCampo == "A1_EST"
				M->A1_REGIAO := RFATG04()
				M->A1_DSCREG := POSICIONE("SX5",1,xFilial("SX5")+"A2"+M->A1_REGIAO,"X5_DESCRI")
				M->A1_ESTE   := M->A1_EST
				M->A1_ESTC   := M->A1_EST

				RetNvlEst()

				M->A1_XDNV3 := POSICIONE("SZ1",1,XFILIAL("SZ1")+"3"+M->A1_XNVL3,"Z1_DESCRI")
				M->A1_XDNV4 := POSICIONE("SZ1",1,XFILIAL("SZ1")+"4"+M->A1_XNVL4,"Z1_DESCRI")

				//M->A1_GRPTRIB := IIF(M->A1_EST == 'SC',"003",Space(TamSX3("A1_GRPTRIB")[1]))

				//CAMPO
			ElseIf cCampo == "A1_DDD"
				IF LEN(ALLTRIM(M->A1_DDD))<2
					MsgAlert("DDD Inv?lido")
					M->A1_DDD :=  Space(TamSX3("A1_DDD")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, ALLTRIM(M->A1_DDD) ) <> 0
						Alert("O campo - DDD  - admite apenas caracateres num?ricos. Por favor, digite novamente no formato correto")
						M->A1_DDD := Space(TamSX3("A1_DDD")[1])
						Exit
					EndIf
				Next

				If Val(M->A1_DDD) > 100
					Alert("O texto digitado para o campo - DDD - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_DDD := Space(TamSX3("A1_DDD")[1])
				EndIf

				If SubStr(M->A1_DDD,1,1) == "0"
					Alert("DDD Inv?lido!","Aten??o")
					xRet := .F.
				EndIf


				//CAMPO
			ElseIf cCampo == "A1_XDDD2"
				IF LEN(ALLTRIM(M->A1_XDDD2))<2
					MsgAlert("DDD Inv?lido")
					M->A1_XDDD2 := Space(TamSX3("A1_XDDD2")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, M->A1_XDDD2 ) <> 0
						Alert("O campo - DDD  - admite apenas caracateres num?ricos. Por favor, digite novamente no formato correto")
						M->A1_XDDD2:= Space(TamSX3("A1_XDDD2")[1])
						Exit
					EndIf
				Next

				If Val(M->A1_XDDD2) > 100
					Alert("O texto digitado para o campo - DDD - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_XDDD2 := Space(TamSX3("A1_XDDD2")[1])
				EndIf

				If SubStr(M->A1_XDDD2,1,1) == "0"
					Alert("DDD Inv?lido!","Aten??o")
					xRet := .F.
				EndIf


				//CAMPO
			ElseIf cCampo == "A1_XCEL1"
				IF LEN(ALLTRIM(M->A1_XCEL1))<>9
					alert("N?mero Celular Inv?lido")
					M->A1_XCEL1:=  Space(TamSX3("A1_XCEL1")[1])
				EndIf

				If LEN(ALLTRIM(M->A1_XCEL1))==9 .And. !Subs(Alltrim(M->A1_XCEL1),1,1)$"9"
					alert("O n?mero do celular deve come?ar com 9")
					M->A1_XCEL1:=  Space(TamSX3("A1_XCEL1")[1])
				Endif

				If Len(Alltrim(M->A1_XCEL1) )>100
					Alert("O texto digitado para o campo - CELULAR 1 - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_XCEL1 := Space(TamSX3("A1_XCEL1")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_XCEL1) ) <> 0
						Alert("O campo - CELULAR 1- admite apenas caracateres num?ricos. Por favor, digite novamente no formato correto")
						M->A1_XCEL1:= Space(TamSX3("A1_XCEL1")[1])
					EndIf
				Next

				If Empty(M->A1_XDDDC1)
					Alert("Preencha primeiro o DDD!","Aten??o")
					xRet := .F.
				EndIf


				//CAMPO
			ElseIf cCampo == "A1_EMAIL"
				M->A1_EMAIL := Lower(M->A1_EMAIL)
				If !IsEmail(Alltrim(M->A1_EMAIL))
					Alert("O Email digitado ? inv?lido. Por favor digite novamente no formato correto !")
					M->A1_EMAIL :=  Space(TamSX3("A1_EMAIL")[1])
				EndIf


				//CAMPO
			ElseIf cCampo == "A1_XEMAIL2"
				M->A1_XEMAIL2 := Lower(M->A1_XEMAIL2)
				If !IsEmail(Alltrim(M->A1_XEMAIL2))
					Alert("O Email digitado ? inv?lido. Por favor digite novamente no formato correto !")
					M->A1_XEMAIL2 :=  Space(TamSX3("A1_XEMAIL2")[1])
				EndIf


				//CAMPO
			ElseIf cCampo == "A1_XDDDC1"
				IF LEN(ALLTRIM(M->A1_XDDDC1))<2
					alert("DDD Inv?lido")
					M->A1_XDDDC1 :=  Space(TamSX3("A1_XDDDC1")[1])
				EndIf

				If SubStr(M->A1_XDDDC1,1,1) == "0"
					Alert("DDD Inv?lido!","Aten??o")
					xRet := .F.
				EndIf


				//CAMPO
			ElseIf cCampo == "A1_XDDDC2"
				IF LEN(ALLTRIM(M->A1_XDDDC2))<2
					alert("DDD Inv?lido")
					M->A1_XDDDC2 :=  Space(TamSX3("A1_XDDDC2")[1])
				EndIf

				If SubStr(M->A1_XDDDC2,1,1) == "0"
					Alert("DDD Inv?lido!","Aten??o")
					xRet := .F.
				EndIf


				//CAMPO
			ElseIf cCampo == "A1_XCCLANT"
				_cPesq1   := "-"
				_cPesq2   := "0"

				M->A1_XCCLANT := U_RmvChEsp(M->A1_XCCLANT)

				//M->A1_CGC := IIf(Empty(M->A1_CGC),"0",M->A1_CGC)

				/*
				If AT(_cPesq1, M->A1_XCCLANT ) <> 0
					Alert("O campo -- C?DIGO ANTIGO DO CLIENTE -- admite apenas caracteres num?ricos. Por favor, digite novamente no formato correto")
					M->A1_XCCLANT := Space(TamSX3("A1_XCCLANT")[1])
				EndIf
				*/

				If AT(_cPesq2, M->A1_XCCLANT ) == 1
					Alert("O primeiro caracter do campo -- C?DIGO ANTIGO DO CLIENTE -- n?o pode iniciar com 0 (zero). Por favor, digite novamente no formato correto")
					M->A1_XCCLANT := Space(TamSX3("A1_XCCLANT")[1])
				EndIf


				//CAMPO
			ElseIf cCampo == "A1_XRGERAL"
				If Len(Alltrim(M->A1_XRGERAL))<>9
					Alert("O RG informado ? inv?lido")
					M->A1_XRGERAL := Space(TamSX3("A1_XRGERAL")[1])
				EndIf

				For nI := 1 to Len(_cCaract)

					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_XRGERAL) ) <> 0
						Alert("Foi digitado algum caracter n?o permitido")
						M->A1_XRGERAL := Space(TamSX3("A1_XRGERAL")[1])
					EndIf
				Next


				//CAMPO
			ElseIf cCampo == "A1_PFISICA"

				M->A1_PFISICA := StrTran(M->A1_PFISICA,' ','')

				If Len(Alltrim(M->A1_PFISICA) )>20
					Alert("O n?mero digitado para o documento ? inv?lido. Por favor, digite novamente no formato correto")
					M->A1_PFISICA := Space(TamSX3("A1_PFISICA")[1])
				EndIf

				For nI := 1 to Len(_cCaract)

					_cPesq:= substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_PFISICA) ) <> 0
						Alert("Este campo admite apenas caracateres num?ricos. Por favor, digite novamente no formato correto")
						M->A1_PFISICA:= Space(TamSX3("A1_PFISICA")[1])
					EndIf
				Next


				//CAMPO
			ElseIf cCampo == "A1_NOME"
				If Len(Alltrim(M->A1_NOME))>80
					Alert("O texto digitado para o campo - NOME - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_NOME := Space(TamSX3("A1_NOME")[1])
				EndIf

				For nI := 1 to Len(_cCaract)

					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_NOME) ) <> 0
						Alert("O campo -NOME- admite apenas caracateres alfab?ticos sem acento. Por favor, digite novamente no formato correto")
						M->A1_NOME:= Space(TamSX3("A1_NOME")[1])
					EndIf
				Next

				M->A1_NOME := U_RmvChEsp(M->A1_NOME)

				//CAMPO
			ElseIf cCampo == "A1_NREDUZ"
				If Len(Alltrim(M->A1_NREDUZ) )>100
					Alert("O texto digitado para o campo - NOME FANTASIA - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_NREDUZ := Space(TamSX3("A1_NREDUZ")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_NREDUZ) ) <> 0
						Alert("O campo - NOME FANTASIA - admite apenas caracateres alfab?ticos sem acento. Por favor, digite novamente no formato correto")
						M->A1_NREDUZ:= Space(TamSX3("A1_NREDUZ")[1])
					EndIf
				Next

				M->A1_NREDUZ := U_RmvChEsp(M->A1_NREDUZ)


				//CAMPO
			ElseIf cCampo == "A1_COMPLEM"
				If Len(Alltrim(M->A1_COMPLEM) )>100
					Alert("O texto digitado para o campo - COMPLEMENTO DE ENDERE?O  - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_COMPLEM := Space(TamSX3("A1_COMPLEM")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_COMPLEM) ) <> 0
						Alert("O campo - COMPLEMENTO DE ENDERE?O - admite apenas caracateres alfab?ticos sem acento. Por favor, digite novamente no formato correto")
						M->A1_COMPLEM:= Space(TamSX3("A1_COMPLEM")[1])
					EndIf
				Next

				M->A1_XCOMPEC := U_RmvChEsp(M->A1_COMPLEM)
				M->A1_COMPENT := U_RmvChEsp(M->A1_COMPLEM)


				//CAMPO
			ElseIf cCampo == "A1_END"
				If Len(Alltrim(M->A1_END) )>100
					Alert("O texto digitado para o campo - ENDERE?O - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_END := Space(TamSX3("A1_END")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_END) ) <> 0
						Alert("O campo - ENDERE?O - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
						M->A1_END:= Space(TamSX3("A1_END")[1])
					EndIf
				Next

				M->A1_ENDENT := Alltrim(M->A1_END)
				M->A1_ENDCOB := Alltrim(M->A1_END)

			ElseIf cCampo == "A1_XNEND"
				M->A1_XNENDE := M->A1_XNEND
				M->A1_XNENDC := M->A1_XNEND

				//CAMPO
			ElseIf cCampo == "A1_BAIRRO"
				If Len(Alltrim(M->A1_BAIRRO) )>100
					Alert("O texto digitado para o campo - BAIRRO - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_BAIRRO := Space(TamSX3("A1_BAIRRO")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_BAIRRO) ) <> 0
						Alert("O campo - BAIRRO - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
						M->A1_BAIRRO:= Space(TamSX3("A1_BAIRRO")[1])
					EndIf
				Next

				M->A1_BAIRROE := Alltrim(M->A1_BAIRRO)
				M->A1_BAIRROC := Alltrim(M->A1_BAIRRO)

				//CAMPO
			ElseIf cCampo == "A1_CONTATO"
				/*
				M->A1_CONTATO := IIf(Empty(M->A1_CONTATO),Space(TamSX3("A1_CONTATO")[1]),M->A1_CONTATO)
				M->A1_CONTATO := U_RmvChEsp(M->A1_CONTATO)
				*/
				MsgInfo("Para contatos, utilize o cadastro de 'Contatos TB' no menu 'outras a??es'","Aten??o")

				/*
				If !VerContat()
					M->A1_CONTATO := Space(TamSX3("A1_CONTATO")[1])
				EndIf
				*/

				//CAMPO
			ElseIf cCampo == "A1_TEL"
				If Len(Alltrim(M->A1_TEL) )>100 .OR. Len(Alltrim(M->A1_TEL) ) < 8
					Alert("O texto digitado para o campo - TELEFONE - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_TEL := Space(TamSX3("A1_TEL")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_TEL) ) <> 0
						Alert("O campo - TELEFONE - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
						M->A1_TEL:= Space(TamSX3("A1_TEL")[1])
					EndIf
				Next

				If Empty(M->A1_DDD)
					Alert("Preencha primeiro o DDD!","Aten??o")
					xRet := .F.
				EndIf


				//CAMPO
			ElseIf cCampo == "A1_XTEL2"
				If Len(Alltrim(M->A1_XTEL2) )>100 .OR. Len(Alltrim(M->A1_XTEL2) ) < 8
					Alert("O texto digitado para o campo - TELEFONE 2 - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_XTEL2 := Space(TamSX3("A1_XTEL2")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_XTEL2) ) <> 0
						Alert("O campo - TELEFONE 2 - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
						M->A1_XTEL2:= Space(TamSX3("A1_XTEL2")[1])
					EndIf
				Next

				If Empty(M->A1_XDDD2)
					Alert("Preencha primeiro o DDD!","Aten??o")
					xRet := .F.
				EndIf

				//CAMPO
			ElseIf cCampo == "A1_XDDDC2"

				IF LEN(ALLTRIM(M->A1_XDDDC2))<2
					alert("DDD Inv?lido")
					M->A1_XDDDC2 :=  Space(TamSX3("A1_XDDDC2")[1])
				EndIf

				If Len(Alltrim(M->A1_XDDDC2) )>100
					Alert("O texto digitado para o campo - CELULAR 1 - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_XDDDC2 := Space(TamSX3("A1_XDDDC2")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_XDDDC2) ) <> 0
						Alert("O campo - CELULAR 1- admite apenas caracateres num?ricos. Por favor, digite novamente no formato correto")
						M->A1_XDDDC2:= Space(TamSX3("A1_XDDDC2")[1])
					EndIf
				Next


				//CAMPO
			ElseIf cCampo == "A1_XCEL2"
				If Len(Alltrim(M->A1_XCEL2) )>100 .OR. Len(Alltrim(M->A1_XCEL2) ) < 9
					Alert("O texto digitado para o campo - N?MERO CELULAR 1- ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_XCEL2 := Space(TamSX3("A1_XCEL2")[1])
				EndIf

				If LEN(ALLTRIM(M->A1_XCEL2))==9 .And. !Subs(Alltrim(M->A1_XCEL2),1,1)$"9"
					alert("O n?mero do celular deve come?ar com 9")
					M->A1_XCEL2:=  Space(TamSX3("A1_XCEL2")[1])
				Endif

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_XCEL2) ) <> 0
						Alert("O campo - N?MERO CELULAR 1 - admite apenas caracateres num?ricos. Por favor, digite novamente no formato correto")
						M->A1_XCEL2:= Space(TamSX3("A1_XCEL2")[1])
					EndIf
				Next

				If Empty(M->A1_XDDDC2)
					Alert("Preencha primeiro o DDD!","Aten??o")
					xRet := .F.
				EndIf


				//CAMPO
			ElseIf cCampo == "A1_ENDENT"
				If Len(Alltrim(M->A1_ENDENT) )>100
					Alert("O texto digitado para o campo - ENDERE?O DE ENTREGA - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_ENDENT := Space(TamSX3("A1_ENDENT")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_ENDENT) ) <> 0
						Alert("O campo - ENDERE?O DE ENTREGA - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
						M->A1_ENDENT:= Space(TamSX3("A1_ENDENT")[1])
					EndIf
				Next


				//CAMPO
			ElseIf cCampo == "A1_COMPENT"
				If Len(Alltrim(M->A1_COMPENT) )>100
					Alert("O texto digitado para o campo - COMPLMENTO DO ENDERE?O DE ENTREGA - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_COMPENT := Space(TamSX3("A1_COMPENT")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_COMPENT) ) <> 0
						Alert("O campo - COMPLMENTO DO ENDERE?O DE ENTREGA - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
						M->A1_COMPENT:= Space(TamSX3("A1_COMPENT")[1])
					EndIf
				Next


				//CAMPO
			ElseIf cCampo == "A1_BAIRROE"
				If Len(Alltrim(M->A1_BAIRROE) )>100
					Alert("O texto digitado para o campo - BAIRRO DE ENTREGA - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_BAIRROE := Space(TamSX3("A1_BAIRROE")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_BAIRROE) ) <> 0
						Alert("O campo - BAIRRO DE ENTREGA  - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
						M->A1_BAIRROE:= Space(TamSX3("A1_BAIRROE")[1])
					EndIf
				Next


				//CAMPO
			ElseIf cCampo == "A1_ENDCOB"
				If Len(Alltrim(M->A1_ENDCOB) )>100
					Alert("O texto digitado para o campo - ENDERE?O DE COBRAN?A - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_ENDCOB := Space(TamSX3("A1_ENDCOB")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_ENDCOB) ) <> 0
						Alert("O campo - ENDERE?O DE COBRAN?A  - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
						M->A1_ENDCOB:= Space(TamSX3("A1_ENDCOB")[1])
					EndIf
				Next


				//CAMPO
			ElseIf cCampo == "A1_XCOMPEC"
				If Len(Alltrim(M->A1_XCOMPEC) )>100
					Alert("O texto digitado para o campo - COMPLEMENTO DE ENDERE?O DE COBRAN?A - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_XCOMPEC := Space(TamSX3("A1_XCOMPEC")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_XCOMPEC) ) <> 0
						Alert("O campo - COMPLEMENTO DE ENDERE?O DE COBRAN?A  - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
						M->A1_XCOMPEC:= Space(TamSX3("A1_XCOMPEC")[1])
					EndIf
				Next


				//CAMPO
			ElseIf cCampo == "A1_BAIRROC"
				If Len(Alltrim(M->A1_BAIRROC) )>100
					Alert("O texto digitado para o campo - BAIRRO DE COBRAN?A - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_BAIRROC := Space(TamSX3("A1_BAIRROC")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_BAIRROC) ) <> 0
						Alert("O campo - BAIRRO DE COBRAN?A  - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
						M->A1_BAIRROC:= Space(TamSX3("A1_BAIRROC")[1])
					EndIf
				Next


				//CAMPO
			ElseIf cCampo == "A1_MUNE"
				If Len(Alltrim(M->A1_MUNE) )>100
					Alert("O texto digitado para o campo - MUNIC?PIO DE COBRAN?A - ? inv?lido.Por favor, digite novamente no formato correto")
					M->A1_MUNE := Space(TamSX3("A1_MUNE")[1])
				EndIf

				For nI := 1 to Len(_cCaract)
					_cPesq :=substr(_cCaract,nI,1)

					If AT(_cPesq, Alltrim(M->A1_MUNE) ) <> 0
						Alert("O campo - MUNIC?PIO DE COBRAN?A  - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
						M->A1_MUNE:= Space(TamSX3("A1_MUNE")[1])
					EndIf
				Next

				//CAMPO
			ElseIf cCampo == "A1_XPINSCR"
				If M->A1_XPINSCR == '2'
					M->A1_INSCR := "ISENTO"
					M->A1_CNAE  := Space(TamSX3("A1_CNAE")[1])
				Else
					MsgAlert("Para pessoa jur?dica, ? obrigat?rio preencher campo de Inscri??o Estadual!","Aten??o")
					M->A1_INSCR := Space(TamSX3("A1_INSCR")[1])
					M->A1_CNAE  := Space(TamSX3("A1_CNAE")[1])
				EndIf



				//CAMPO
			ElseIf cCampo == "A1_PAIS"
				M->A1_CODPAIS := Posicione("CCH",2,XFILIAL("CCH")+M->A1_PAISDES,"CCH_CODIGO")


				//CAMPO
			ElseIf cCampo == "A1_MUN"
				IF EMPTY(M->A1_COD_MUN)
					M->A1_COD_MUN := POSICIONE("CC2",4,XFILIAL("CC2")+M->A1_EST+M->A1_MUN,"CC2_CODMUN")

					If M->A1_REGIAO == '001'
						If AllTrim(M->A1_MUN) == "GUARAJA MIRIM"
							M->A1_CODMUN := "00001"
						ElseIf AllTrim(M->A1_MUN) == "BRASILEIRA"
							M->A1_CODMUN := "00105"
						ElseIf AllTrim(M->A1_MUN) == "CRUZEIRO DO SUL"
							M->A1_CODMUN := "00107"
						ElseIf AllTrim(M->A1_MUN) == "MANAUS"
							M->A1_CODMUN := "00255"
						ElseIf AllTrim(M->A1_MUN) == "MACAPA"
							M->A1_CODMUN := "00605"
						ElseIf AllTrim(M->A1_MUN) == "SANTANA"
							M->A1_CODMUN := "00615"
						ElseIf AllTrim(M->A1_MUN) == "PRESIDENTE FIGUEIREDO"
							M->A1_CODMUN := "09841"
						ElseIf AllTrim(M->A1_MUN) == "RIO PRETO DA EVA"
							M->A1_CODMUN := "09843"
						ElseIf AllTrim(M->A1_MUN) == "TABATINGA"
							M->A1_CODMUN := "09847"
						ElseIf AllTrim(M->A1_MUN) == "EPITACIOLANDIA"
							M->A1_CODMUN := "99998"
						ElseIf AllTrim(M->A1_MUN) == "PACARAIMA"
							M->A1_CODMUN := "99999"
						EndIf

					EndIf

					M->A1_CODMUNE := M->A1_COD_MUN
					M->A1_XCDMUNC := M->A1_COD_MUN
					M->A1_MUNE 	  := M->A1_MUN
					M->A1_MUNC    := M->A1_MUN

				EndIF

			ElseIf cCampo == "A1_CGC"
				If Empty(M->A1_CGC)  .AND. M->A1_PESSOA $ "F,J"
					Alert("Pessoa Jur?dica ou Pessoa Fisica"+Chr(13)+Chr(10)+"Campo de CNPJ/CPF ? obrigat?rio!","Aten??o")
					xRet := .F.
				EndIf

			ElseIf cCampo == "A1_INSCRI"
				If Empty(U_RmvChEsp(M->A1_INSCRI)) .AND. M->A1_PESSOA $ "J"
					Alert("Pessoa Jur?dica: "+Chr(13)+Chr(10)+"Campo de Inscri??o Estadual ? obrigat?rio!","Aten??o")
					xRet := .F.
				EndIf



			ElseIf cCampo == "A1_CNAE"
				MsgAlert("Acessar 'outras a??es' / 'mashup: Receita Federal - Consulta CNPJ' "+Chr(13)+Chr(10)+;
					"para preencher o CNAE","Aten??o")


				If Substr(M->A1_CNAE,1,2) == "86"
					M->A1_XNVL1 := "000034"
					M->A1_XDNV1 := POSICIONE("SZ1",1,XFILIAL("SZ1")+"1"+"000034","Z1_DESCRI")

					M->A1_XNVL2 := "000037"
					M->A1_XDNV2 := POSICIONE("SZ1",1,XFILIAL("SZ1")+"2"+"000037","Z1_DESCRI")

				ElseIf Substr(M->A1_CNAE,1,2) == "47"

					M->A1_XNVL1 := "000033"
					M->A1_XDNV1 := POSICIONE("SZ1",1,XFILIAL("SZ1")+"1"+"000033","Z1_DESCRI")

					M->A1_XNVL2 := "000035"
					M->A1_XDNV2 := POSICIONE("SZ1",1,XFILIAL("SZ1")+"2"+"000035","Z1_DESCRI")

				EndIf

			ElseIf cCampo == "A1_COD_MUN"
				M->A1_CODMUNE := M->A1_COD_MUN
				M->A1_XCDMUNC := M->A1_COD_MUN
				M->A1_MUNE 	  := M->A1_MUN
				M->A1_MUNC    := M->A1_MUN

			Else
				xRet := .T.

			EndIf

			//TIPO DE RETORNO
		ElseIf cTipo == "L"

			//CAMPO
			If cCampo == "A1_EST" //cCampo == "A1_PAIS"
				xRet := IIF(M->A1_PESSOA$"E",.F.,.T.) .AND. (M->A1_EST $ "MT,SC" .OR. Empty(M->A1_EST))

			ElseIf cCampo == "A1_COD_MUN" .AND. AllTrim(M->A1_EST) $ "RO,AC,AM,RR,AP"
				xRet := (M->A1_COD_MUN $ GETMV("MV_XCDDSA1").OR.Empty(M->A1_COD_MUN) )  //1400100 (BOA VISTA), 1400159 (BONFIM), 1100106 (GUAJAR?-MIRIM), 1200104 (BRASIL?IA), 1200252 (EPITACIOL?NDIA), 1200203 (CRUZEIRO DO SUL), 1304062 (TABATINGA), 1302603 (MANAUS),  1600303 (MACAP?) E 1600600

			ElseIf cCampo == "A1_XPINSCR"

				If M->A1_PESSOA $ "F,E"
					xRet := .F.
				Else
					xRet := .T.
				EndIf

			ElseIf cCampo == "A1_CODMUN"

				If M->A1_REGIAO == '001' .AND. !Empty(M->A1_MUN)

					If AllTrim(M->A1_MUN) == "GUARAJA MIRIM"
						xRet := .T.
					ElseIf AllTrim(M->A1_MUN) == "BRASILEIRA"
						xRet := .T.
					ElseIf AllTrim(M->A1_MUN) == "CRUZEIRO DO SUL"
						xRet := .T.
					ElseIf AllTrim(M->A1_MUN) == "MANAUS"
						xRet := .T.
					ElseIf AllTrim(M->A1_MUN) == "MACAPA"
						xRet := .T.
					ElseIf AllTrim(M->A1_MUN) == "SANTANA"
						xRet := .T.
					ElseIf AllTrim(M->A1_MUN) == "PRESIDENTE FIGUEIREDO"
						xRet := .T.
					ElseIf AllTrim(M->A1_MUN) == "RIO PRETO DA EVA"
						xRet := .T.
					ElseIf AllTrim(M->A1_MUN) == "TABATINGA"
						xRet := .T.
					ElseIf AllTrim(M->A1_MUN) == "EPITACIOLANDIA"
						xRet := .T.
					ElseIf AllTrim(M->A1_MUN) == "PACARAIMA"
						xRet := .T.
					Else
						xRet := .F.
					EndIf

				Else
					xRet := .F.

				EndIf

			EndIf


		Else

			xRet := .T.

		EndIf

	EndIf

Return xRet



/*/{Protheus.doc} RFATG03
Fun??o para informar prefixo de codigo de cliente conforme tipo de Pessoa
@type Static_function
@version  1
@author Fabio
@since 26/04/2021
@return Character, Novo Codigo
/*/
Static Function RFATG03() // Verificar Rogerio
	Local  _cCodigo  := ""
	Local  LFoi      := .F.
	Local  _cQuery   := ""


	If M->A1_PESSOA$"F"
		_cQuery:= " SELECT MAX(A1_COD) CODIGO " +CRLF
		_cQuery+= " FROM " + RetSqlName("SA1") +  " A1  " +CRLF
		_cQuery+= " WHERE A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF
		_cQuery+= " AND A1_COD BETWEEN '100001' AND '199999' " +CRLF
		lFoi := .T.
	ElseIf M->A1_PESSOA$"J"
		_cQuery:= " SELECT MAX(A1_COD) CODIGO " +CRLF
		_cQuery+= " FROM " + RetSqlName("SA1") +  " A1  " +CRLF
		_cQuery+= " WHERE A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF
		_cQuery+= " AND A1_COD BETWEEN '200001' AND '299999' " +CRLF
		lFoi := .T.
	ElseIf M->A1_PESSOA$"E"
		_cQuery:= " SELECT MAX(A1_COD) CODIGO " +CRLF
		_cQuery+= " FROM " + RetSqlName("SA1") +  " A1  " +CRLF
		_cQuery+= " WHERE A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF
		_cQuery+= " AND A1_COD BETWEEN '300001' AND '399999' " +CRLF
		lFoi := .T.

	EndIf

	If lFoi
		DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), "TMPSSS", .F., .T. )

		If !Empty(TMPSSS->CODIGO)
			_cCodigo := Soma1(TMPSSS->CODIGO,6)
		Endif

		TMPSSS->(dbCloseArea())
	Endif

	If Empty(_cCodigo)
		If M->A1_PESSOA == "F"
			_cCodigo := "100001"
		ElseIf M->A1_PESSOA == "J"
			_cCodigo := "200001"
		ElseIf M->A1_PESSOA == "E"
			_cCodigo := "300001"
		EndIf
	EndIf

return (_cCodigo)



/*/{Protheus.doc} RFATG04
Ajusta o campo A1_REGIAO de acordo com o Estado do Cliente
@type Static_function
@version  1
@author Fabio
@since 26/04/2021
@return Character, Codigo da Regiao
/*/
Static Function RFATG04()
/* ARMAZENA O CODIGO CORRESPONDENTE EM _cRegiao DE ACORDO COM O ESTADO DIGITADO EM A1_EST. SERVE DE REGRA PARA O GATILHO DOMINIO ? A1_EST E CONTRA-DOMINIO A1_REGIAO */

	local _cRegiao := ""

//-> REGIAO NORTE
	IF M->A1_EST$"'AC','AP','AM','PA','RO','RR','TO'"
		_cRegiao := "001"

//-> REGIAO NORDESTE
	ElseIf M->A1_EST$"'AL','BA','CE','MA','PB','PE','PI','RN','SE'"
		_cRegiao := "002"

//-> REGIAO CENTRO-OESTE
	ElseIf M->A1_EST$"'DF','GO','MT','MS'"
		_cRegiao := "003"

//-> REGIAO SUDESTE
	ElseIf M->A1_EST$"'ES','MG','SP','RJ'"
		_cRegiao := "004"

//-> REGIAO CENTRO SUL
	ElseIf M->A1_EST$"'PR','SC','RS'"
		_cRegiao := "005"

//-> REGIAO EXTERIOR
	ElseIf M->A1_EST$"'EX'"
		_cRegiao := "006"

	EndIf

Return(_cRegiao)

User Function RmvChEsp(cWord)
	cWord := OemToAnsi(AllTrim(cWord))
	cWord := FwNoAccent(cWord)
	cWord := FwCutOff(cWord)
	cWord := StrTran(cWord, "'", "")
	cWord := StrTran(cWord, "#", "")
	cWord := StrTran(cWord, "%", "")
	cWord := StrTran(cWord, "*", "")
	//cWord := StrTran(cWord, "&", "E")
	cWord := StrTran(cWord, ">", "")
	cWord := StrTran(cWord, "<", "")
	cWord := StrTran(cWord, "!", "")
	cWord := StrTran(cWord, "@", "")
	cWord := StrTran(cWord, "$", "")
	cWord := StrTran(cWord, "(", "")
	cWord := StrTran(cWord, ")", "")
	cWord := StrTran(cWord, "_", "")
	cWord := StrTran(cWord, "=", "")
	cWord := StrTran(cWord, "+", "")
	cWord := StrTran(cWord, "{", "")
	cWord := StrTran(cWord, "}", "")
	cWord := StrTran(cWord, "[", "")
	cWord := StrTran(cWord, "]", "")
	cWord := StrTran(cWord, "/", "")
	cWord := StrTran(cWord, "?", "")
	cWord := StrTran(cWord, ".", "")
	cWord := StrTran(cWord, "\", "")
	cWord := StrTran(cWord, "|", "")
	cWord := StrTran(cWord, ":", "")
	cWord := StrTran(cWord, ";", "")
	cWord := StrTran(cWord, '"', '')
	cWord := StrTran(cWord, '?', '')
	cWord := StrTran(cWord, '?', '')
	cWord := StrTran(cWord, '?', 'C')
	cWord := StrTran(cWord, '?', 'c')
	cWord := StrTran(cWord, '?', 'a')
	cWord := StrTran(cWord, '?', 'a')
	cWord := StrTran(cWord, '?', 'a')
	cWord := StrTran(cWord, '?', 'a')
	cWord := StrTran(cWord, '?', 'A')
	cWord := StrTran(cWord, '?', 'A')
	cWord := StrTran(cWord, '?', 'A')
	cWord := StrTran(cWord, '?', 'A')
	cWord := StrTran(cWord, '?', 'e')
	cWord := StrTran(cWord, '?', 'e')
	cWord := StrTran(cWord, '?', 'e')
	cWord := StrTran(cWord, '?', 'E')
	cWord := StrTran(cWord, '?', 'E')
	cWord := StrTran(cWord, '?', 'E')
	cWord := StrTran(cWord, '?', 'O')
	cWord := StrTran(cWord, '?', 'o')
	cWord := StrTran(cWord, '?', 'o')
	cWord := StrTran(cWord, '?', 'O')
	cWord := StrTran(cWord, '?', 'O')
	cWord := StrTran(cWord, '?', 'o')
	cWord := StrTran(cWord, '?', 'O')
	cWord := StrTran(cWord, '?', 'o')
	cWord := strtran(cWord,""+'"'+"","")

	cWord := AllTrim(UPPER(cWord))

Return cWord


Static Function RetNvlEst()
	Local cEstado := ""

	cEstado := Posicione("SX5",1,xFilial("SX5")+"12"+M->A1_EST,"X5_DESCRI")

	M->A1_XNVL3 := PadL(M->A1_REGIAO,6,'0')
	M->A1_XNVL4 := Posicione("SZ1",3,xFilial("SZ1")+"4"+cEstado,"Z1_COD")

Return Nil




/*/{Protheus.doc} RetMashup
Fun??o que faz tratativa de campos durante execu??o de Mashups
@type User_function
@version  1
@author Fabio
@since 05/05/2021
@return Character, Caractere de acordo com o campo que ser? preenchido
/*/
User Function RetMashup()
	Local cAlias  	:= ParamIXB[1]         		// Alias da tabela
	Local cMashup 	:= ParamIXB[2] 		// Nome do servi?o do Mashup
	Local cDescri 	:= ParamIXB[3]		// Descri??o do retorno
	Local cCampo  	:= ParamIXB[4]			// Campo de retorno
	Local xConteudo := ParamIXB[5]                 // Conte?do
	Local xRet

	If cMashup == "Correios.PesquisaCEP"
		If cDescri == "Cidade"
			M->A1_COD_MUN := POSICIONE("CC2",4,XFILIAL("CC2")+M->A1_EST+UPPER(xConteudo),"CC2_CODMUN")
			M->A1_CODMUNE := POSICIONE("CC2",4,XFILIAL("CC2")+M->A1_EST+UPPER(xConteudo),"CC2_CODMUN")
			M->A1_XCDMUNC := POSICIONE("CC2",4,XFILIAL("CC2")+M->A1_EST+UPPER(xConteudo),"CC2_CODMUN")
			M->A1_MUNE := UPPER(xConteudo)
			M->A1_MUNC := UPPER(xConteudo)
			xRet := xConteudo
		ElseIf cDescri == "CEP"
			M->A1_CEPE := xConteudo
			M->A1_CEPC := xConteudo
			xRet := xConteudo

		ElseiF cDescri = "CNAE"

			xRet := xConteudo

			If Substr(M->A1_CNAE,1,2) == "86"
				M->A1_XNVL1 := "000034"
				M->A1_XDNV1 := POSICIONE("SZ1",1,XFILIAL("SZ1")+"1"+"000034","Z1_DESCRI")

				M->A1_XNVL2 := "000037"
				M->A1_XDNV2 := POSICIONE("SZ1",1,XFILIAL("SZ1")+"2"+"000037","Z1_DESCRI")

			ElseIf Substr(M->A1_CNAE,1,2) == "47"

				M->A1_XNVL1 := "000033"
				M->A1_XDNV1 := POSICIONE("SZ1",1,XFILIAL("SZ1")+"1"+"000033","Z1_DESCRI")

				M->A1_XNVL2 := "000035"
				M->A1_XDNV2 := POSICIONE("SZ1",1,XFILIAL("SZ1")+"2"+"000035","Z1_DESCRI")

			EndIf

		EndIf

	EndIf

	If ValType(xConteudo) == "C"
		xConteudo := U_RmvChEsp(xConteudo)
		xRet := xConteudo
	EndIf

Return xRet


Static Function VerContat()
	Local lRet := .T.
	Local cSql := ""

	cSql := "SELECT Z2_NOME FROM "+RetSqlName("SZ2")+" SZ2 WHERE Z2_CLIENTE = '"+M->(A1_COD+A1_LOJA)+"' AND Z2_NOME = '"+M->A1_CONTATO+"' AND SZ2.D_E_L_E_T_<>'*' "
	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf
	TCQuery ChangeQuery(cSql) New Alias "QRY"

	lRet := !Empty(QRY->Z2_NOME)

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

Return lRet

