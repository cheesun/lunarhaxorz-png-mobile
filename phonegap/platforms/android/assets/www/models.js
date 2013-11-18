(function() {
  var Database, Datapoint, Field, Model, Patient, Schemas, Summary, SummaryValue, Utils;

  Utils = {
    queryParam: function(param) {
      var name, pageUrl, part, parts, _i, _len;
      pageUrl = window.location.search.substring(1);
      parts = pageUrl.split('&');
      for (_i = 0, _len = parts.length; _i < _len; _i++) {
        part = parts[_i];
        name = part.split('=');
        if (name.length > 1 && name[0] === param) {
          return name[1];
        }
      }
    },
    type: function(obj) {
      var classToType;
      if (obj === void 0 || obj === null) {
        return String(obj);
      }
      classToType = {
        '[object Boolean]': 'boolean',
        '[object Number]': 'number',
        '[object String]': 'string',
        '[object Function]': 'function',
        '[object Array]': 'array',
        '[object Date]': 'date',
        '[object RegExp]': 'regexp',
        '[object Object]': 'object'
      };
      return classToType[Object.prototype.toString.call(obj)];
    }
  };

  Database = {
    open: function() {
      return window.openDatabase('test', '1.0', 'test', 200000);
    },
    logError: function(err) {
      return console.log(err);
    },
    runSql: function(sql, callback) {
      var db;
      db = this.open();
      return db.transaction(function(tx) {
        console.log('running sql: ' + sql);
        return tx.executeSql(sql, [], function(tx, results) {
          if (callback) {
            return callback(results);
          }
        }, this.logError);
      });
    },
    reset: function(models) {
      var model, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = models.length; _i < _len; _i++) {
        model = models[_i];
        console.log(model);
        model.buildTable(true);
        _results.push(model.buildFixtures());
      }
      return _results;
    },
    empty: function(models) {
      var model, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = models.length; _i < _len; _i++) {
        model = models[_i];
        _results.push(model.buildTable(true));
      }
      return _results;
    }
  };

  Schemas = {
    staff: {
      name: 'staff',
      columns: ['name'],
      fixtures: [
        {
          name: 'zhao'
        }, {
          name: 'david'
        }, {
          name: 'ping'
        }, {
          name: 'chees'
        }, {
          name: 'al'
        }, {
          name: 'cyb '
        }
      ]
    },
    datapoints: {
      name: 'datapoints',
      columns: ['patient_id', 'status', 'timeIn', 'timeFor', 'timeOut', 'user', 'device', 'field_id', 'value'],
      fixtures: [
        {
          field_id: 2,
          value: 'zhao',
          patient_id: 1
        }, {
          field_id: 2,
          value: 'david',
          patient_id: 2
        }, {
          field_id: 2,
          value: 'ping',
          patient_id: 3
        }, {
          field_id: 2,
          value: 'chees',
          patient_id: 4
        }, {
          field_id: 2,
          value: 'al',
          patient_id: 5
        }, {
          field_id: 2,
          value: 'cyb',
          patient_id: 6
        }
      ]
    },
    summaries: {
      name: 'summaries',
      columns: ['patient_id', 'date'],
      methods: {
        getLatestFieldsForPatient: function(patient_id, field_id, callback) {
          var _this = this;
          return this.getLatestForPatient(patient_id, function(results) {
            var summary_id;
            if (results.rows.length > 0) {
              summary_id = results.rows.item(0).id;
              return _this.getFields(summary_id, field_id, callback);
            }
          });
        },
        getLatestForPatient: function(patient_id, callback) {
          return Database.runSql('\
          select *\
          from summaries\
          where patient_id = ' + patient_id + ' order by date desc\
          limit 1', callback);
        },
        getFields: function(summary_id, field_id, callback) {
          var conditions;
          conditions = [];
          if (summary_id) {
            conditions.push('summaries.id = ' + summary_id);
          }
          if (field_id) {
            conditions.push('summaryValues.field_id = ' + field_id);
          }
          return Database.runSql('\
          select datapoints.*\
          from summaries\
          join summaryValues on summaries.id = summaryValues.summary_id\
          join datapoints on summaryValues.dataPoint = datapoints.id\
          where ' + conditions.join(' and '), callback);
        }
      },
      fixtures: [
        {
          patient_id: 1,
          date: 0
        }
      ]
    },
    summaryValues: {
      name: 'summaryValues',
      columns: ['summary_id', 'field_id', 'dataPoint'],
      fixtures: [
        {
          summary_id: 1,
          field_id: 2,
          dataPoint: 1
        }
      ]
    },
    fields: {
      name: 'fields',
      columns: ['sortOrder', 'label', 'key'],
      fixtures: [
        {
          sortOrder: 1,
          label: 'Lastname',
          key: 'Lastname'
        }, {
          sortOrder: 2,
          label: 'Firstname',
          key: 'Firstname'
        }, {
          sortOrder: 3,
          label: 'Date of Birth',
          key: 'DOB'
        }, {
          sortOrder: 4,
          label: 'Address',
          key: 'Address'
        }, {
          sortOrder: 5,
          label: 'Height',
          key: 'Height'
        }, {
          sortOrder: 6,
          label: 'Weight',
          key: 'Weight'
        }, {
          sortOrder: 7,
          label: 'History (Active)',
          key: 'B/G'
        }, {
          sortOrder: 8,
          label: 'History (Inactive)',
          key: 'B/G/'
        }, {
          sortOrder: 9,
          label: 'Medications',
          key: 'Meds'
        }, {
          sortOrder: 10,
          label: 'Allergies / Reactions',
          key: 'Allergies'
        }, {
          sortOrder: 11,
          label: 'Alerts',
          key: 'Alerts'
        }, {
          sortOrder: 12,
          label: 'Immunisations',
          key: 'Imm'
        }, {
          sortOrder: 13,
          label: 'Heart Rate (/min)',
          key: 'HR'
        }, {
          sortOrder: 14,
          label: 'Blood Pressure (mmHg)',
          key: 'BP'
        }, {
          sortOrder: 15,
          label: 'Respiratory Rate (/min)',
          key: 'RR'
        }, {
          sortOrder: 16,
          label: 'Oxygen Saturation (%)',
          key: 'SO2'
        }, {
          sortOrder: 17,
          label: 'Temperature (degC)',
          key: 'T'
        }, {
          sortOrder: 18,
          label: 'Blood Glucose Level (mmol/L)',
          key: 'BGL'
        }, {
          sortOrder: 19,
          label: 'Coma Scale',
          key: 'CS'
        }, {
          sortOrder: 20,
          label: 'White Cell Count (*1e6/L)',
          key: 'WCC'
        }, {
          sortOrder: 21,
          label: 'Haemoglobin (g/L)',
          key: 'Hb'
        }, {
          sortOrder: 22,
          label: 'Platelets (*1e6/L)',
          key: 'Plt'
        }, {
          sortOrder: 23,
          label: 'Sodium (mmol/H)',
          key: 'Na'
        }, {
          sortOrder: 24,
          label: 'Potassium (mmol/H)',
          key: 'K'
        }, {
          sortOrder: 25,
          label: 'Chloride (mmol/H)',
          key: 'Cl'
        }, {
          sortOrder: 26,
          label: 'Bicarbonate (mmol/H)',
          key: 'HCO3'
        }, {
          sortOrder: 27,
          label: 'Urea (mmol/H)',
          key: 'Ur'
        }, {
          sortOrder: 28,
          label: 'Creatinine (mmol/H)',
          key: 'Cr'
        }, {
          sortOrder: 29,
          label: 'Bilirubin (mmol/H)',
          key: 'Bili'
        }, {
          sortOrder: 30,
          label: 'X-Ray Chest',
          key: 'CXR'
        }, {
          sortOrder: 31,
          label: 'X-Ray Abdomen',
          key: 'AXR'
        }, {
          sortOrder: 32,
          label: 'General Clinical Note',
          key: 'Note'
        }
      ]
    },
    patients: {
      name: 'patients',
      columns: [],
      fixtures: [{}, {}, {}, {}, {}, {}],
      methods: {
        getAllWithName: function(callback) {
          return Database.runSql('\
          select patients.id, datapoints.value as name\
          from patients\
          left join datapoints on patients.id = datapoints.patient_id\
          where datapoints.field_id = 2 or datapoints.field_id is null\
          ', callback);
        }
      }
    }
  };

  Model = (function() {
    function Model(schema) {
      var method, methodName, _ref;
      this.schema = schema;
      if (this.schema.methods != null) {
        _ref = this.schema.methods;
        for (methodName in _ref) {
          method = _ref[methodName];
          this[methodName] = method;
        }
      }
    }

    Model.prototype.buildFixtures = function() {
      var item, _i, _len, _ref, _results;
      if (!this.schema.fixtures) {
        return;
      }
      _ref = this.schema.fixtures;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        _results.push(this.create(item));
      }
      return _results;
    };

    Model.prototype.buildTable = function(clear) {
      var columns, db,
        _this = this;
      columns = this.schema.columns.join(',');
      console.log(columns);
      if (columns) {
        columns = ', ' + columns;
      }
      db = Database.open();
      return db.transaction(function(tx) {
        if (clear) {
          tx.executeSql('drop table if exists ' + _this.schema.name);
        }
        return tx.executeSql('create table if not exists ' + _this.schema.name + ' (id integer primary key autoincrement' + columns + ')');
      }, Database.logError);
    };

    Model.prototype.getAll = function(callback) {
      return Database.runSql('select * from ' + this.schema.name, callback);
    };

    Model.prototype.get = function(id, callback) {
      return Database.runSql('select * from ' + this.schema.name + ' where id = ' + id, function(results) {
        return callback(results.rows.item(0));
      });
    };

    Model.prototype.create = function(data) {
      var columns, values;
      columns = this.schema.columns.join(',');
      if (columns) {
        columns = ', ' + columns;
      }
      values = this.schema.columns.map(function(val) {
        if (data[val] != null) {
          if (Utils.type(data[val]) === 'number') {
            return data[val];
          } else {
            return '"' + data[val] + '"';
          }
        } else {
          return 'null';
        }
      }).join(', ');
      if (values) {
        values = ', ' + values;
      }
      return Database.runSql('insert into ' + this.schema.name + '(id' + columns + ') ' + 'values (null' + values + ')');
    };

    return Model;

  })();

  Patient = new Model(Schemas.patients);

  Summary = new Model(Schemas.summaries);

  Datapoint = new Model(Schemas.datapoints);

  Field = new Model(Schemas.fields);

  SummaryValue = new Model(Schemas.summaryValues);

  window.$$ = window.$$ || {};

  window.$$.Database = Database;

  window.$$.Patient = Patient;

  window.$$.Summary = Summary;

  window.$$.Datapoint = Datapoint;

  window.$$.SummaryValue = SummaryValue;

  window.$$.Field = Field;

  window.$$.Utils = Utils;

  window.$$.Models = [Patient, Summary, Datapoint, Field, SummaryValue];

}).call(this);
