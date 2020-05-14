@EndUserText.label: 'Language projection view - Processor'
@AccessControl.authorizationCheck: #CHECK
@UI: {
 headerInfo: { typeName: 'Programming Language', typeNamePlural: 'Programming Languages', title: { type: #STANDARD, value: 'language_id' } } }

@Search.searchable: true

define root view entity ZC_TYPES_HSKA09
  as projection on ZI_TYPES_HSKA09
{
      @UI.facet: [ { id:              'Language',
                    purpose:         #STANDARD,
                    type:            #IDENTIFICATION_REFERENCE,
                    label:           'Details',
                    position:        10 }
      ]
      @UI.hidden: true
      @UI.identification: [{ position: 10, label: 'language id' } ]
  key language_id,
      @UI: {
         lineItem:       [ { position: 10, importance: #HIGH } , { position: 10, type: #AS_DATAPOINT } ],
         identification: [ { position: 30, label: 'Programming Language' } ] }
      @Search.defaultSearchElement: true
      @UI.dataPoint:{title:'Programming Language', targetValueElement: 'name'}
      name,

      @UI: {lineItem:[ { position: 50, type: #AS_DATAPOINT }],
      identification: [ { position: 50, label: 'Rating' } ]}
      @UI.dataPoint:{title:'Rating',visualization:#RATING,targetValue:5}
      rating,
      @UI: {
          lineItem:       [ { position: 60, importance: #HIGH, criticality: 'Criticality' },
           { type: #FOR_ACTION, dataAction: 'acceptBlacklisted', label: 'Set Blacklisted' } ],
           identification: [ { position: 50, label: 'BlackListed' } ] }
      @UI.dataPoint:{title:'Blacklisted', targetValueElement: 'Blacklisted'}
      blacklisted,
      @UI: {
          identification: [ { position: 10, label: 'Developer' } ] }
      developer,
      @UI: {
          identification: [ { position: 20, label: 'Publishing Year' } ] }
      publishing_year,
      Criticality
}
