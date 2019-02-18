#Include 'protheus.ch'
#Include 'fwmvcdef.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC14
Exemplo de rotina automatica manipulando o modelo de dados

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC14()
Local   aSay     := {}
Local   aButton  := {}
Local   nOpc     := 0
Local   Titulo   := 'IMPORTACAO DE TURMA x ALUNO'
Local   cDesc1   := 'Esta rotina fara a importacao de turmas'
Local   cDesc2   := 'e alunos, relacionando os mesmos.'
Local   cDesc3   := ''
Local   lOk      := .T.

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch()            } } )

FormBatch( Titulo, aSay, aButton )

If nOpc == 1

	Processa( { || lOk := Runproc() },'Aguarde','Processando...',.F.)

	If lOk
		ApMsgInfo( 'Processamento terminado com sucesso.', 'ATENÇÃO' )

	Else
		ApMsgStop( 'Processamento realizado com problemas.', 'ATENÇÃO' )

	EndIf

EndIf

Return NIL


//-------------------------------------------------------------------
Static Function Runproc()
Local lRet     := .T.
Local aCposCab := {}
Local aCposDet := {}
Local aAux     := {}

aCposCab := {}
aCposDet := {}
aAdd( aCposCab, { 'ZB5_CODTUR' , 'A03' } )

aAux := {}
aAdd( aAux, { 'ZB6_RA' , '0014' } )
aAdd( aCposDet, aAux )

aAux := {}
aAdd( aAux, { 'ZA6_RA',  '0015' } )
aAdd( aCposDet, aAux )

If !Import(aCposCab, aCposDet )
	lRet := .F.
EndIf

Return lRet


//-------------------------------------------------------------------
Static Function Import(  aCpoMaster, aCpoDetail )
Local  oModel, oAux, oStruct
Local  nI        := 0
Local  nJ        := 0
Local  nPos      := 0
Local  lRet      := .T.
Local  aAux	     := {}
Local  aC  	     := {}
Local  aH        := {}
Local  nItErro   := 0
Local  lAux      := .T.
Local  cMaster	 := 'MASTERZB5'
Local  cDetail   := 'DETAILZB6'

// Carregamos o model que contem a definição da aplicação Turma x Aluno
oModel := FWLoadModel( 'MVC04' )

// Temos que definir qual a operação deseja: 3 – Inclusão / 4 – Alteração / 5 - Exclusão
oModel:SetOperation( MODEL_OPERATION_INSERT )

// Antes de atribuirmos os valores dos campos temos que ativar o modelo
// Se o Modelo nao puder ser ativado, talvez por uma regra de ativacao
// o retorno sera .F.
lRet := oModel:Activate()

If lRet

	// Obtemos o componente field
	oAux    := oModel:GetModel( cMaster )

	// Obtemos a estrutura de dados do field
	oStruct := oAux:GetStruct()
	aAux	:= oStruct:GetFields()

	If lRet
		For nI := 1 To Len( aCpoMaster )

			// Verifica se os campos passados existem na estrutura do field
			If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) ==  AllTrim( aCpoMaster[nI][1] ) } ) ) > 0

				// È feita a atribuicao do dado aos campo do Model do cabeçalho
				If !( lAux := oModel:SetValue( cMaster, aCpoMaster[nI][1], aCpoMaster[nI][2] ) )

					// Caso a atribuição não possa ser feita, por algum motivo (validação, por exemplo)
					// o método SetValue retorna .F.
					lRet    := .F.
					Exit

				EndIf
			EndIf
		Next
	EndIf
EndIf

If lRet
	// Obtemos agora o grid de Alunos
	oAux     := oModel:GetModel( cDetail )

	// Obtemos a estrutura de dados do item
	oStruct  := oAux:GetStruct()
	aAux	 := oStruct:GetFields()

	nItErro  := 0

	For nI := 1 To Len( aCpoDetail )
		// Incluímos uma linha nova
		// ATENCAO: O itens são criados em uma estrura de grid (FORMGRID), portanto já é criada uma primeira linha
		//branco automaticamente, desta forma começamos a inserir novas linhas a partir da 2ª vez

		If nI > 1

			// Incluimos uma nova linha de item

			If  ( nItErro := oAux:AddLine() ) <> nI

				// Se por algum motivo o metodo AddLine() não consegue incluir a linha,
				// ele retorna a quantidade de linhas já
				// existem no grid. Se conseguir retorna a quantidade mais 1
				lRet    := .F.
				Exit

			EndIf

		EndIf

		For nJ := 1 To Len( aCpoDetail[nI] )

		// Verifica se os campos passados existem na estrutura do grid
			If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) ==  AllTrim( aCpoDetail[nI][nJ][1] ) } ) ) > 0

				If !( lAux := oModel:SetValue( cDetail, aCpoDetail[nI][nJ][1], aCpoDetail[nI][nJ][2] ) )

					// Caso a atribuição não possa ser feita, por algum motivo (validação, por exemplo)
					// o método SetValue retorna .F.
					lRet    := .F.
					nItErro := nI
					Exit

				EndIf
			EndIf
		Next

		If !lRet
			Exit
		EndIf

	Next

EndIf

If lRet

	// Faz-se a validação dos dados, note que diferentemente das tradicionais "rotinas automáticas"
	// neste momento os dados não são gravados, são somente validados.
	If ( lRet := oModel:VldData() )

		// Se o dados foram validados faz-se a gravação efetiva dos dados (commit)
		lRet := oModel:CommitData()

	EndIf
EndIf

If !lRet

	// Se os dados não foram validados obtemos a descrição do erro para gerar LOG ou mensagem de aviso
	aErro   := oModel:GetErrorMessage()

	// A estrutura do vetor com erro é:
	//  [1] Id do formulário de origem
	//  [2] Id do campo de origem
	//  [3] Id do formulário de erro
	//  [4] Id do campo de erro
	//  [5] Id do erro
	//  [6] mensagem do erro
	//  [7] mensagem da solução
	//  [8] Valor atribuido
	//  [9] Valor anterior

	AutoGrLog( "Id do formulário de origem:" + ' [' + AllToChar( aErro[1]  ) + ']' )
	AutoGrLog( "Id do campo de origem:     " + ' [' + AllToChar( aErro[2]  ) + ']' )
	AutoGrLog( "Id do formulário de erro:  " + ' [' + AllToChar( aErro[3]  ) + ']' )
	AutoGrLog( "Id do campo de erro:       " + ' [' + AllToChar( aErro[4]  ) + ']' )
	AutoGrLog( "Id do erro:                " + ' [' + AllToChar( aErro[5]  ) + ']' )
	AutoGrLog( "Mensagem do erro:          " + ' [' + AllToChar( aErro[6]  ) + ']' )
	AutoGrLog( "Mensagem da solução:       " + ' [' + AllToChar( aErro[7]  ) + ']' )
	AutoGrLog( "Valor atribuido:           " + ' [' + AllToChar( aErro[8]  ) + ']' )
	AutoGrLog( "Valor anterior:            " + ' [' + AllToChar( aErro[9]  ) + ']' )

	If nItErro > 0
		AutoGrLog( "Erro no Item:              " + ' [' + AllTrim( AllToChar( nItErro  ) ) + ']' )
	EndIf

	MostraErro()

EndIf

// Desativamos o Model
oModel:DeActivate()

Return lRet