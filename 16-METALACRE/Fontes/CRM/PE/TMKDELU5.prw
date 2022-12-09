#Include "RWMAKE.CH"      
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TMKDELU5  º Autor ³ Luiz Alberto      º Data ³ 10/07/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³PE Antes da Exclusao do Contato   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 													          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TMKDELU5()                     
Local aArea := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe algum atendimento para o contato na tabela de TELEMARKETING³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectarea("SUC")
DbSetorder(6)
If DbSeek(xFilial("SUC")+SU5->U5_CODCONT) .And. Empty(SUC->UC_DTENCER)
	MsgStop("Contato Possui Atendimento em Aberto - Numero: " + SUC->UC_CODIGO + " Não Pode Ser Excluido !","Atenção")	
	Return .f.
Else

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida a exclusao na tabela de Contatos x Entidades        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectarea("AC8")	
	DbSetOrder(1)
	If DbSeek(xFilial( "AC8" ) + SU5->U5_CODCONT)
		SX2->( DbSetOrder(1) )
		SX2->( DbSeek( AC8->AC8_ENTIDA ) )
			
		cTexto := ''
		While AC8->(!Eof()) .And. AC8->AC8_CODCON == SU5->U5_CODCONT .And. AC8->AC8_FILIAL == xFilial("AC8")
			If AC8->AC8_ENTIDA == 'SA1'
				If SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+AC8->AC8_CODENT))
					cTexto += ' Cliente: '+SA1->(A1_COD+A1_LOJA)+' - '+SA1->A1_NREDUZ + Chr(13) + Chr(10)
				Endif
			ElseIf AC8->AC8_ENTIDA == 'SA2'
				If SA2->(dbSetOrder(1), dbSeek(xFilial("SA2")+AC8->AC8_CODENT))
					cTexto += ' Fornec: '+SA2->(A2_COD+A2_LOJA)+' - '+SA2->A2_NREDUZ + Chr(13) + Chr(10)
				Endif
			ElseIf AC8->AC8_ENTIDA == 'SUS'
				If SUS->(dbSetOrder(1), dbSeek(xFilial("SUS")+AC8->AC8_CODENT))
					cTexto += ' Prospect: '+SUS->(US_COD+US_LOJA)+' - '+SUS->US_NREDUZ + Chr(13) + Chr(10)
				Endif
			ElseIf AC8->AC8_ENTIDA == 'ACH'
				If ACH->(dbSetOrder(1), dbSeek(xFilial("ACH")+AC8->AC8_CODENT))
					cTexto += ' Suspect: '+ACH->(ACH_CODIGO+ACH_LOJA)+' - '+ACH->ACH_NFANT + Chr(13) + Chr(10) 
				Endif
			Endif
			
			AC8->(dbSkip(1))
		Enddo
		If !Empty(cTexto)
			cTexto += Chr(13) + Chr(10) + Chr(13) + Chr(10) + ' Não poderá Ser Excluido, Exclua os Relacionamentos e Retorne !!!'
			
			Aviso("Atenção",cTexto,{"Ok"},3,"Contato Relacionado à:")

			Return .f.
		Endif   
	Endif
Endif	

Return .t.