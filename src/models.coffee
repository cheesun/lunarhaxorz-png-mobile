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
  patients: {
    name: 'patients'
    columns: ['id']
  }

  staff: {
    name: 'staff'
    columns: ['id', 'name']
    fixtures: [
      { name: 'zhao'  }
      { name: 'david' }
      { name: 'ping'  }
      { name: 'chees' }
      { name: 'al'    }
      { name: 'cyb '  }
    ]
  }

  summaries: {
    name: 'summaries'
    columns: ['id', 'patient_id', 'date']
  }

  summaryValues: {
    name: 'summaryValues'
    columns: ['id', summary_id, field_id, dataPoint]
  }

  datapoints: {
    name: 'datapoints'
    columns: ['id', 'patient_id', 'status', 'timeIn', 'timeFor', 'timeOut', 'user', 'device', 'field_id', 'value']
  }

  fields: {
    name: 'fields'
    columns: ['id', sortOrder, label, key]
    fixtures: [
        { sortOrder:  1, label: Lastname,                     key: Lastname  }
        { sortOrder:  2, label: Firstname,                    key: Firstname }
        { sortOrder:  3, label: Date of Birth,                key: DOB       }
        { sortOrder:  4, label: Address,                      key: Address   }
        { sortOrder:  5, label: Height,                       key: Height    }
        { sortOrder:  6, label: Weight,                       key: Weight    }
        { sortOrder:  7, label: History (Active),             key: B/G       }
        { sortOrder:  8, label: History (Inactive),           key: B/G/      }
        { sortOrder:  9, label: Medications,                  key: Meds      }
        { sortOrder: 10, label: Allergies / Reactions,        key: Allergies }
        { sortOrder: 11, label: Alerts,                       key: Alerts    }
        { sortOrder: 12, label: Immunisations,                key: Imm       }
        { sortOrder: 13, label: Heart Rate (/min),            key: HR        }
        { sortOrder: 14, label: Blood Pressure (mmHg),        key: BP        }
        { sortOrder: 15, label: Respiratory Rate (/min),      key: RR        }
        { sortOrder: 16, label: Oxygen Saturation (%),        key: SO2       }
        { sortOrder: 17, label: Temperature (degC),           key: T         }
        { sortOrder: 18, label: Blood Glucose Level (mmol/L), key: BGL       }
        { sortOrder: 19, label: Coma Scale,                   key: CS        }
        { sortOrder: 20, label: White Cell Count (*1e6/L),    key: WCC       }
        { sortOrder: 21, label: Haemoglobin (g/L),            key: Hb        }
        { sortOrder: 22, label: Platelets (*1e6/L),           key: Plt       }
        { sortOrder: 23, label: Sodium (mmol/H),              key: Na        }
        { sortOrder: 24, label: Potassium (mmol/H),           key: K         }
        { sortOrder: 25, label: Chloride (mmol/H),            key: Cl        }
        { sortOrder: 26, label: Bicarbonate (mmol/H),         key: HCO3      }
        { sortOrder: 27, label: Urea (mmol/H),                key: Ur        }
        { sortOrder: 28, label: Creatinine (mmol/H),          key: Cr        }
        { sortOrder: 29, label: Bilirubin (mmol/H),           key: Bili      }
        { sortOrder: 30, label: X-Ray Chest,                  key: CXR       }
        { sortOrder: 31, label: X-Ray Abdomen,                key: AXR       }
        { sortOrder: 32, label: General Clinical Note,        key: Note      }
    ]

  }

}

class Model
  constructor: (@schema) ->

  buildFixtures: ->
    return unless @schema.fixtures
    for item in @schema.fixtures
      Database.runSql(
        'insert into ' + @schema.name + '(' + @schema.columns.join(',') + ') ' +
        'values (' + @schema.columns.map((val) -> '"' + item[val] + '"').join(',') + ')')

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

Patient = new Model(Schemas.patients)
Summary = new Model(Schemas.summaries)

for model in [Patient, Summary]
  model.buildTable(true)
  model.buildFixtures()

# exports - is there a better way?
window.$$ = window.$$ || {}
window.$$.Database = Database
window.$$.Patient = Patient
window.$$.Summary = Summary
