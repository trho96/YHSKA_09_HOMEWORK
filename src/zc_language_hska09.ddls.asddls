@EndUserText.label: 'Language projection view - Processor'
@AccessControl.authorizationCheck: #CHECK
@UI: {
 headerInfo: { typeName: 'Programming Language', typeNamePlural: 'Programming Languages', title: { type: #STANDARD, value: 'listing_id' } } }

@Search.searchable: true

define root view entity ZC_LANGUAGE_HSKA09
  as projection on ZI_LANGUAGE_HSKA09
{
      @UI.facet: [ { id:              'Language',
                    purpose:         #STANDARD,
                    type:            #IDENTIFICATION_REFERENCE,
                    label:           'Details',
                    position:        10 }
      ]
      @UI.hidden: true
  key listing_id,
      @UI: {
         lineItem:       [ { position: 10, importance: #HIGH } , { position: 10, type: #AS_DATAPOINT } ],
         identification: [ { position: 30, label: 'Programming Language' } ] }
      @Search.defaultSearchElement: true
      @UI.dataPoint:{title:'Programming Language', targetValueElement: 'name'}
      name,
      @UI.lineItem:       [ { position: 20, type: #AS_DATAPOINT} ]
      @UI.dataPoint:{title:'Popularity in %',visualization:#PROGRESS, targetValueElement: 'popularity', targetValue: 100}
      popularity,
      @UI.lineItem:       [ { position: 30, importance: #HIGH } ] 
      trend,
      @UI: {
          lineItem:       [ { position: 40, importance: #HIGH } ],
          identification: [ { position: 40, label: 'Region' } ] }
      region,

      @UI.lineItem:[ { position: 50, type: #AS_DATAPOINT }]
      @UI.dataPoint:{title:'Rating',visualization:#RATING,targetValue:5}
      Rating,
      @UI: {
          lineItem:       [ { position: 60, importance: #HIGH } ] }
      @UI.dataPoint:{title:'Todo', targetValueElement: 'Todo'}
      Todo,
      @UI: {
          identification: [ { position: 10, label: 'Developer' } ] }
      Developer,
      @UI: {
          identification: [ { position: 20, label: 'Publishing Year' } ] }
      Publishing_Year

}
