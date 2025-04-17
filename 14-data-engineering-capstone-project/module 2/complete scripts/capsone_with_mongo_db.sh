####################### Module 2 assigment ######################
####################### Author : Abdoulaye OUATTARA
# Task 1: import data from json
use catalog # To create catalog databases
db.create.collection("electronics") # Here, i create my collection
mongoimport -u root -p xPurY3p94WYGIA2IPMjB5vnO --authenticationDatabase admin --db catalog --collection electronics --file catalog.json --host mongo

# Task 2: Lists all databases
show dbs 

# Task 3: Lists all collections
show collections

# Task 4: Create index for type field
db.electronics.createIndex( {'type' : 1})

# Task 5: Query to count latop number
db.electronics.countDocuments( {'type': 'latop'})
# or
db.electronics.aggregate([
  { 
    $group: { 
      _id: "$type", 
      count: { $sum: 1 } 
    }
  }
])

# Task 6: Query to count smart phone with screen size of 6 inches.
db.electronics.countDocuments(
    {
    'type': 'smart phone',
    'screen size':6
    }
)

# Querry to find out average of sreen size for smart phone
db.electronics.aggregate([
  { $match: { type: "smart phone" } },
  { $group: { _id: '$type', avgScreenSize: { $avg: "$screen size" } } }
])

# Export fields _id, "type","model"
mongoexport -u root -p xPurY3p94WYGIA2IPMjB5vnO --authenticationDatabase admin --db catalog --collection electronics --out electronics.csv --type=csv --fields _id,type,model --host mongo
