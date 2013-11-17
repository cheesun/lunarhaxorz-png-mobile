Utils = {
  queryParam: (param) ->
    pageUrl = window.location.search.substring(1)
    parts = pageUrl.split('&')
    for part in parts
      name = part.split('=')
      return name[1] if name.length > 1 and name[0] == param

  type: (obj) ->
    if obj == undefined or obj == null
      return String obj
    classToType = {
      '[object Boolean]': 'boolean',
      '[object Number]': 'number',
      '[object String]': 'string',
      '[object Function]': 'function',
      '[object Array]': 'array',
      '[object Date]': 'date',
      '[object RegExp]': 'regexp',
      '[object Object]': 'object'
    }
    return classToType[Object.prototype.toString.call(obj)]
}

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

  reset: (models) ->
    for model in models
      console.log(model)
      model.buildTable(true)
      model.buildFixtures()
}

Schemas = {
  staff: {
    name: 'staff'
    columns: ['name']
    fixtures: [
      { name: 'zhao'  }
      { name: 'david' }
      { name: 'ping'  }
      { name: 'chees' }
      { name: 'al'    }
      { name: 'cyb '  }
    ]
  }

  datapoints: {
    name: 'datapoints'
    columns: ['patient_id', 'status', 'timeIn', 'timeFor', 'timeOut', 'user', 'device', 'field_id', 'value']
    fixtures: [
      { field_id: 2, value: 'zhao', patient_id: 1 }
      { field_id: 2, value: 'david', patient_id: 2 }
      { field_id: 2, value: 'ping', patient_id: 3 }
      { field_id: 2, value: 'chees',patient_id: 4 }
      { field_id: 2, value: 'al', patient_id: 5 }
      { field_id: 2, value: 'cyb', patient_id: 6 }
    ]
  }

  summaries: {
    name: 'summaries'
    columns: ['patient_id', 'date']
  }

  summaryValues: {
    name: 'summaryValues'
    columns: ['summary_id', 'field_id', 'dataPoint']
  }

  fields: {
    name: 'fields'
    columns: ['sortOrder', 'label', 'key']
    fixtures: [
        { sortOrder:  1, label: 'Lastname',                     key: 'Lastname'  }
        { sortOrder:  2, label: 'Firstname',                    key: 'Firstname' }
        { sortOrder:  3, label: 'Date of Birth',                key: 'DOB'       }
        { sortOrder:  4, label: 'Address',                      key: 'Address'   }
        { sortOrder:  5, label: 'Height',                       key: 'Height'    }
        { sortOrder:  6, label: 'Weight',                       key: 'Weight'    }
        { sortOrder:  7, label: 'History (Active)',             key: 'B/G'       }
        { sortOrder:  8, label: 'History (Inactive)',           key: 'B/G/'      }
        { sortOrder:  9, label: 'Medications',                  key: 'Meds'      }
        { sortOrder: 10, label: 'Allergies / Reactions',        key: 'Allergies' }
        { sortOrder: 11, label: 'Alerts',                       key: 'Alerts'    }
        { sortOrder: 12, label: 'Immunisations',                key: 'Imm'       }
        { sortOrder: 13, label: 'Heart Rate (/min)',            key: 'HR'        }
        { sortOrder: 14, label: 'Blood Pressure (mmHg)',        key: 'BP'        }
        { sortOrder: 15, label: 'Respiratory Rate (/min)',      key: 'RR'        }
        { sortOrder: 16, label: 'Oxygen Saturation (%)',        key: 'SO2'       }
        { sortOrder: 17, label: 'Temperature (degC)',           key: 'T'         }
        { sortOrder: 18, label: 'Blood Glucose Level (mmol/L)', key: 'BGL'       }
        { sortOrder: 19, label: 'Coma Scale',                   key: 'CS'        }
        { sortOrder: 20, label: 'White Cell Count (*1e6/L)',    key: 'WCC'       }
        { sortOrder: 21, label: 'Haemoglobin (g/L)',            key: 'Hb'        }
        { sortOrder: 22, label: 'Platelets (*1e6/L)',           key: 'Plt'       }
        { sortOrder: 23, label: 'Sodium (mmol/H)',              key: 'Na'        }
        { sortOrder: 24, label: 'Potassium (mmol/H)',           key: 'K'         }
        { sortOrder: 25, label: 'Chloride (mmol/H)',            key: 'Cl'        }
        { sortOrder: 26, label: 'Bicarbonate (mmol/H)',         key: 'HCO3'      }
        { sortOrder: 27, label: 'Urea (mmol/H)',                key: 'Ur'        }
        { sortOrder: 28, label: 'Creatinine (mmol/H)',          key: 'Cr'        }
        { sortOrder: 29, label: 'Bilirubin (mmol/H)',           key: 'Bili'      }
        { sortOrder: 30, label: 'X-Ray Chest',                  key: 'CXR'       }
        { sortOrder: 31, label: 'X-Ray Abdomen',                key: 'AXR'       }
        { sortOrder: 32, label: 'General Clinical Note',        key: 'Note'      }
    ]
  }

  patients: {
    name: 'patients'
    columns: []
    fixtures: [ {}, {}, {}, {}, {}, {} ]
    methods: {
      getAllWithName: (callback) ->
        Database.runSql('
          select patients.id, datapoints.value as name
          from patients
          left join datapoints on patients.id = datapoints.patient_id
          where datapoints.field_id = 2 or datapoints.field_id is null
          ', callback)
    }
  }

}

class Model
  constructor: (@schema) ->
    if @schema.methods?
      for methodName, method of @schema.methods
        @[methodName] = method

  buildFixtures: ->
    return unless @schema.fixtures
    for item in @schema.fixtures
      @create(item)

  buildTable: (clear) ->
    columns = @schema.columns.join(',')
    console.log(columns)
    columns = ', ' + columns if columns
    db = Database.open()
    db.transaction((tx) =>
      tx.executeSql('drop table if exists ' + @schema.name) if clear
      tx.executeSql('create table if not exists ' + @schema.name + ' (id integer primary key autoincrement' + columns + ')')
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
    columns = @schema.columns.join(',')
    columns = ', ' + columns if columns
    values = @schema.columns.map((val) ->
      if data[val]?
        if Utils.type(data[val]) == 'number'
          data[val]
        else
          '"' + data[val] + '"'
      else
        'null').join(', ')
    values = ', ' + values if values
    Database.runSql(
      'insert into ' + @schema.name + '(id' + columns + ') ' +
      'values (null' + values + ')')

Patient = new Model(Schemas.patients)
Summary = new Model(Schemas.summaries)
Datapoint = new Model(Schemas.datapoints)
Field = new Model(Schemas.fields)

# exports - is there a better way?
window.$$ = window.$$ || {}
window.$$.Database = Database
window.$$.Patient = Patient
window.$$.Summary = Summary
window.$$.Datapoint = Datapoint
window.$$.Field = Field
window.$$.Utils = Utils
window.$$.Models = [Patient, Summary, Datapoint, Field]


