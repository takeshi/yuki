class TableModel < Sequel::Model
 plugin :serialization
 plugin :json_serializer

 one_to_many :colomns,:class => Colomn

end
