@EndUserText.label: 'Language projection view - Processor'
@AccessControl.authorizationCheck: #CHECK

@UI: {
 headerInfo: { typeName: 'ProgrammingLanguage', typeNamePlural: 'ProgrammingLanguages', title: { type: #STANDARD, value: 'language_id' } } }

@Search.searchable: true

define root view entity ZC_LANGUAGE_HSKA09
  as projection on ZI_LANGUAGE_HSKA09
{
      @UI.facet: [ { id:              'Language',
                    purpose:         #STANDARD,
                    type:            #IDENTIFICATION_REFERENCE,
                    label:           'Programming Language',
                    position:        10 } ]
      @UI.hidden: true
  key language_id,
      @UI: {
         lineItem:       [ { position: 10, importance: #HIGH } ],
         identification: [ { position: 10, label: 'Name' } ] }
      @Search.defaultSearchElement: true
      name,
      @UI: {
      lineItem:       [ { position: 20, importance: #HIGH } ],
      identification: [ { position: 20, label: 'RANK' } ] }
      rank,
      @UI: {
           lineItem:       [ { position: 30, importance: #HIGH } ],
           identification: [ { position: 30, label: 'Shares' } ] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      popularity,
      @UI: {
      lineItem:       [ { position: 40, importance: #HIGH } ],
      identification: [ { position: 40, label: 'Trend' } ] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      trend,
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_Currency', element: 'Currency' }}]
      cuky_field as CurrencyCode,
      @UI: {
      lineItem:       [ { position: 50, importance: #HIGH } ],
      identification: [ { position: 50, label: 'Region' } ] }
      region
}
