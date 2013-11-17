exports = {}

Database = {
  open: () ->
    window.openDatabase('test', '1.0', 'test', 200000)

  logError: (err) ->
    console.log(err)

  runSql: (sql, callback) ->
    db = @open()
    db.transaction((tx) ->
      console.log('running sql: ' + sql)
      tx.executeSql(sql, [], (tx, results) ->
        callback(results) if callback
      @logError
      )
    )
}

Schemas = {
  datapoints: {
    name: 'datapoints'
    columns: ['name', 'value', 'date']
  }

  summaries: {
    name: 'summaries'
    columns: ['patient_id', 'date']
  }

  patients: {
    name: 'patients'
    columns: ['name']
    fixtures: [
      { name: 'zhao' },
      { name: 'david' },
      { name: 'ping' },
      { name: 'chees' },
      { name: 'al' },
      { name: 'cyb' },
    ]

  }

}

class Model
  constructor: (@schema) ->

  buildFixtures: ->
    return unless @schema.fixtures
    for item in @schema.fixtures
      @create(item)

  buildTable: (clear) ->
    db = Database.open()
    db.transaction((tx) =>
      tx.executeSql('drop table if exists ' + @schema.name) if clear
      tx.executeSql('create table if not exists ' + @schema.name + ' (id integer primary key autoincrement, ' + @schema.columns.join(',') + ')')
    , Database.logError
    )

  getAll: (callback) ->
    Database.runSql('select * from ' + @schema.name, callback)

  get: (id, callback) ->
    Database.runSql('select * from ' + @schema.name + ' where id = ' + id,
      (results) ->
        callback(results.rows.item(0))
    )

  create: (data) ->
    Database.runSql(
      'insert into ' + @schema.name + '(id, ' + @schema.columns.join(',') + ') ' +
      'values (null, ' + @schema.columns.map((val) -> '"' + data[val] + '"').join(',') + ')')

Patient = new Model(Schemas.patients)
Summary = new Model(Schemas.summaries)
Datapoint = new Model(Schemas.datapoints)

for model in [Patient, Summary, Datapoint]
  model.buildTable(true)
  model.buildFixtures()

# exports - is there a better way?
window.$$ = window.$$ || {}
window.$$.Database = Database
window.$$.Patient = Patient
window.$$.Summary = Summary
window.$$.Datapoint = Datapoint