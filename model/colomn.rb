class Colomn < Sequel::Model
 plugin :serialization
 plugin :json_serializer

 many_to_one  :table_models


end
